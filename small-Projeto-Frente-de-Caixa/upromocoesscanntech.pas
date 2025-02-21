(*
Classe criada para analisar os itens da venda no balcão e aplicar a promoção
do clube de promoções que estiver vigente na data da venda.
O objetivo é que após cada item ser vendido ou cancelado no frente de caixa
seja chamada a procedure AplicarPromocao().
AplicaPromocao() irá analisar se o clube de promoções está ativo e
os itens da venda e aplicar os descontos ou bonificações
vigentes nas promoções identificadas
*)
unit upromocoesscanntech;

interface

uses SysUtils, Variants, Classes, Graphics, Controls, StdCtrls
  , IBDatabase
  , IBCustomDataSet
  , IBQuery
  ;

const PROMOCAO_DESC_LLEVA_PAGA          = 'LLEVA_PAGA';
const PROMOCAO_DESC_DESCUENTO_VARIABLE  = 'DESCUENTO_VARIABLE';
const PROMOCAO_DESC_PRECIO_FIJO         = 'PRECIO_FIJO';
const PROMOCAO_DESC_ADICIONAL_REGALO    = 'ADICIONAL_REGALO';
const PROMOCAO_DESC_ADICIONAL_DESCUENTO = 'ADICIONAL_DESCUENTO';
const PROMOCAO_DESC_DESCUENTO_FIJO      = 'DESCUENTO_FIJO';

const PROMOCAO_STATUS_ACEITA    = 'Aceita';

const PREFIXO_DESCONTO_SCANNTECH = 'CP';

type
  TPromocoesScanntech = class
  private
    FIBDatabase: TIBDatabase;
    FIBTCONSULTA: TIBTransaction;
    FIBDataSet27: TIBDataSet;
    FIBQITENS: TIBQuery;
    FCaixa: String;
    FPedido: String;
    procedure SetIBDatabase(const Value: TIBDatabase);
    procedure SetFIBDataSet27(const Value: TIBDataSet);
    function ClubePromocoesAtivo: Boolean;
    function AplicaPromocaoLLevaPaga: Boolean;
    function AplicaPromocaoDescuentoVariable: Boolean;
    function AplicaPromocaoPrecoFijo: Boolean;
    function AplicaPromocaoAdicionalRegalo: Boolean;
    function AplicaPromocaoAdicionalDescuento: Boolean;
    function AplicaPromocaoDescuentoFijo: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function AplicaPromocao(Caixa: String; Pedido: String): Boolean;
    property IBDatabase: TIBDatabase read FIBDatabase write SetIBDatabase;
    property IBDataSet27: TIBDataSet read FIBDataSet27 write SetFIBDataSet27; // repassa o IBDATASET do form de venda com todos seus eventos
  end;

implementation

uses ufuncoesfrente, DB;

{ TPromocoesScanntech }

function TPromocoesScanntech.AplicaPromocao(Caixa, Pedido: String): Boolean;
var
  bPromocaoAplicada: Boolean;
  IBQTEMP: TIBQuery;
begin
  Result := False;
  IBQTEMP    := CriaIBQuery(FIBDataSet27.Transaction);
  IBQTEMP.DisableControls;

  FCaixa  := Caixa;
  FPedido := Pedido;

  if ClubePromocoesAtivo then
  begin

    //seleciona as promoções relacionadas aos itens da venda
    FIBQITENS.Close;
    FIBQITENS.SQL.Text :=
      'select count(A.REFERENCIA) as ITENS, sum(A.QUANTIDADE) as QTDACUMULADA ' +
      ', CP.ID as ID_PROMOCAO, CP.TIPO as TIPO_PROMOCAO, CP.LIMITE, CP.STATUS, CP.VIGENCIAI, CP.VIGENCIAF ' +
      ', CPC.QTDCOMPRA, CPC.PRECO, CPC.DESCONTO, CPC.QTDPAGA ' +
      'from ALTERACA A ' +
      'join CLUBEPROMOCOESCONDIARTIGOS CPCA on CPCA.EAN = A.REFERENCIA ' +
      'join CLUBEPROMOCOES CP on CP.ID = CPCA.ID_PROMOCAO and (A.DATA between CP.VIGENCIAI and CP.VIGENCIAF) ' +
      'join CLUBEPROMOCOESCONDICOES CPC on CPC.ID_PROMOCAO = CP.ID ' +
      'where char_length(A.REFERENCIA) >= 8 ' +
      ' and A.PEDIDO = :PEDIDO and A.CAIXA = :CAIXA and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
      ' and A.DESCRICAO <> ''<CANCELADO>'' ' +
      'group by CP.ID, CP.TIPO, CP.LIMITE, CP.STATUS, CP.VIGENCIAI, CP.VIGENCIAF ' +
      ', CPC.QTDCOMPRA, CPC.PRECO, CPC.DESCONTO, CPC.QTDPAGA';
    FIBQITENS.ParamByName('CAIXA').AsString  := FCaixa;
    FIBQITENS.ParamByName('PEDIDO').AsString := FPedido;
    FIBQITENS.Open;
    while FIBQITENS.Eof = False do
    begin                                                                                

      if (FIBQITENS.FieldByName('TIPO_PROMOCAO').AsString = PROMOCAO_DESC_LLEVA_PAGA)
        or (FIBQITENS.FieldByName('TIPO_PROMOCAO').AsString = PROMOCAO_DESC_DESCUENTO_VARIABLE)
        or (FIBQITENS.FieldByName('TIPO_PROMOCAO').AsString = PROMOCAO_DESC_PRECIO_FIJO)
        or (FIBQITENS.FieldByName('TIPO_PROMOCAO').AsString = PROMOCAO_DESC_DESCUENTO_FIJO)
      then
      begin
        //Primeiro exclui os descontos referentes a uma promoção aplicados anteriormente
        // do tipo PROMOCAO_DESC_LLEVA_PAGA, PROMOCAO_DESC_DESCUENTO_VARIABLE, PROMOCAO_DESC_PRECIO_FIJO
        IBQTEMP.Close;
        IBQTEMP.SQL.Text :=
          'select A.* ' +
          'from ALTERACA A ' +
          'join CLUBEPROMOCOESCONDIARTIGOS CPCA on CPCA.EAN = A.REFERENCIA and CPCA.ID_PROMOCAO = :ID_PROMOCAO ' +
          'where A.PEDIDO = :PEDIDO ' +
          'and A.CAIXA = :CAIXA ' +
          'and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
          ' and A.DESCRICAO <> ''<CANCELADO>'' ' +
          'order by ITEM';
        IBQTEMP.ParamByName('CAIXA').AsString        := FCaixa;
        IBQTEMP.ParamByName('PEDIDO').AsString       := FPedido;
        IBQTEMP.ParamByName('ID_PROMOCAO').AsInteger := FIBQITENS.FieldByName('ID_PROMOCAO').AsInteger;
        IBQTEMP.Open;

        // Exclui os descontos aplicados anteriormente
        while IBQTEMP.Eof = False do
        begin

          FIBDataSet27.Close;
          FIBDataSet27.SelectSQL.Text :=
            'select * ' +
            'from ALTERACA ' +
            'where PEDIDO = :PEDIDO ' +
            'and CAIXA = :CAIXA ' +
            'and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ' +
            'and DESCRICAO = ''Desconto'' ' +
            ' and REFERENCIA = ' + QuotedStr(PREFIXO_DESCONTO_SCANNTECH + FIBQITENS.FieldByName('ID_PROMOCAO').AsString) + // Apenas os descontos atribuídos pelo clube de descontos
            ' and ITEM = :ITEM ' +
            'order by ITEM';
          FIBDataSet27.ParamByName('CAIXA').AsString  := FCaixa;
          FIBDataSet27.ParamByName('PEDIDO').AsString := FPedido;
          FIBDataSet27.ParamByName('ITEM').AsString   := IBQTEMP.FieldByName('ITEM').AsString;
          FIBDataSet27.Open;

          if FIBDataSet27.FieldByName('ITEM').AsString = IBQTEMP.FieldByName('ITEM').AsString then
          begin
            FIBDataSet27.Delete;
          end;
                                                 
          IBQTEMP.Next;
        end;
      end;


      if (FIBQITENS.FieldByName('TIPO_PROMOCAO').AsString = PROMOCAO_DESC_ADICIONAL_REGALO)
        or (FIBQITENS.FieldByName('TIPO_PROMOCAO').AsString = PROMOCAO_DESC_ADICIONAL_DESCUENTO) then
      begin
        //Primeiro exclui os descontos referentes a uma promoção aplicados anteriormente
        // do tipo ADICIONAL_REGALO
        IBQTEMP.Close;
        IBQTEMP.SQL.Text :=
          'select A.* ' +
          'from ALTERACA A ' +
          'join CLUBEPROMOCOESBENEFICIOS CPB on CPB.EAN = A.REFERENCIA and CPB.ID_PROMOCAO = :ID_PROMOCAO ' +
          'where A.PEDIDO = :PEDIDO ' +
          'and A.CAIXA = :CAIXA ' +
          'and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
          ' and A.DESCRICAO <> ''<CANCELADO>'' ' +
          'order by ITEM';
        IBQTEMP.ParamByName('CAIXA').AsString        := FCaixa;
        IBQTEMP.ParamByName('PEDIDO').AsString       := FPedido;
        IBQTEMP.ParamByName('ID_PROMOCAO').AsInteger := FIBQITENS.FieldByName('ID_PROMOCAO').AsInteger;
        IBQTEMP.Open;
        // Exclui os descontos aplicados anteriormente
        while IBQTEMP.Eof = False do
        begin

          FIBDataSet27.Close;
          FIBDataSet27.SelectSQL.Text :=
            'select * ' +
            'from ALTERACA ' +
            'where PEDIDO = :PEDIDO ' +
            'and CAIXA = :CAIXA ' +
            'and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ' +
            'and DESCRICAO = ''Desconto'' ' +
            ' and REFERENCIA = ' + QuotedStr(PREFIXO_DESCONTO_SCANNTECH + FIBQITENS.FieldByName('ID_PROMOCAO').AsString) + // Apenas os descontos atribuídos pelo clube de descontos
            ' and ITEM = :ITEM ' +
            'order by ITEM';
          FIBDataSet27.ParamByName('CAIXA').AsString  := FCaixa;
          FIBDataSet27.ParamByName('PEDIDO').AsString := FPedido;
          FIBDataSet27.ParamByName('ITEM').AsString   := IBQTEMP.FieldByName('ITEM').AsString;
          FIBDataSet27.Open;

          if FIBDataSet27.FieldByName('ITEM').AsString = IBQTEMP.FieldByName('ITEM').AsString then
          begin
            if (FIBQITENS.FieldByName('TIPO_PROMOCAO').AsString = PROMOCAO_DESC_ADICIONAL_REGALO)
              or (FIBQITENS.FieldByName('TIPO_PROMOCAO').AsString = PROMOCAO_DESC_ADICIONAL_DESCUENTO) then
              FIBDataSet27.Delete;
          end;

          IBQTEMP.Next;
        end;

      end;

      // Aplica somente se a promoção estiver com status aceita
      if FIBQITENS.FieldByName('STATUS').AsString = PROMOCAO_STATUS_ACEITA then
      begin

        if FIBQITENS.FieldByName('TIPO_PROMOCAO').AsString = PROMOCAO_DESC_LLEVA_PAGA then
        begin
          bPromocaoAplicada := AplicaPromocaoLLevaPaga;
          if bPromocaoAplicada then
            Result := True;
        end
        else
          if FIBQITENS.FieldByName('TIPO_PROMOCAO').AsString = PROMOCAO_DESC_DESCUENTO_VARIABLE then
          begin
            bPromocaoAplicada := AplicaPromocaoDescuentoVariable;
            if bPromocaoAplicada then
              Result := True;
          end
          else
            if FIBQITENS.FieldByName('TIPO_PROMOCAO').AsString = PROMOCAO_DESC_PRECIO_FIJO then
            begin
              bPromocaoAplicada := AplicaPromocaoPrecoFijo;
              if bPromocaoAplicada then
                Result := True;
            end
            else
              if FIBQITENS.FieldByName('TIPO_PROMOCAO').AsString = PROMOCAO_DESC_ADICIONAL_REGALO then
              begin
                bPromocaoAplicada := AplicaPromocaoAdicionalRegalo;
                if bPromocaoAplicada then
                  Result := True;
              end
              else
                if (FIBQITENS.FieldByName('TIPO_PROMOCAO').AsString = PROMOCAO_DESC_ADICIONAL_DESCUENTO) then
                begin
                  bPromocaoAplicada := AplicaPromocaoAdicionalDescuento;
                  if bPromocaoAplicada then
                    Result := True;
                end
                else
                  if (FIBQITENS.FieldByName('TIPO_PROMOCAO').AsString = PROMOCAO_DESC_DESCUENTO_FIJO) then
                  begin
                    bPromocaoAplicada := AplicaPromocaoDescuentoFijo;
                    if bPromocaoAplicada then
                      Result := True;
                  end;
      end;

      FIBQITENS.Next;
    end;
  end;

  FreeAndNil(IBQTEMP);

end;

function TPromocoesScanntech.AplicaPromocaoAdicionalDescuento: Boolean;
var
  iItensFalta: Integer;
  dDescontoCP: Double;
  iConta: Integer;
  iLimite: Integer;
  iQtdBonus: Integer;
  IBQTEMP: TIBQuery;
  IBQBENE: TIBQuery;
begin

  Result := False;
  IBQTEMP := CriaIBQuery(FIBDataSet27.Transaction);
  IBQBENE := CriaIBQuery(FIBDataSet27.Transaction);

  IBQTEMP.DisableControls;
  IBQBENE.DisableControls;

  try
    // Seleciona todos os itens lançados pertencentes a promoção identificada
    IBQTEMP.Close;
    IBQTEMP.SQL.Text :=
      'select A.* ' +
      'from ALTERACA A ' +
      'join CLUBEPROMOCOESCONDIARTIGOS CPCA on CPCA.EAN = A.REFERENCIA and CPCA.ID_PROMOCAO = :ID_PROMOCAO ' +
      'where A.PEDIDO = :PEDIDO ' +
      'and A.CAIXA = :CAIXA ' +
      'and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
      ' and A.DESCRICAO <> ''<CANCELADO>'' ' +      
      'order by QUANTIDADE desc'; // Ordenar do item com quantidade maior para o menor
    IBQTEMP.ParamByName('CAIXA').AsString        := FCaixa;
    IBQTEMP.ParamByName('PEDIDO').AsString       := FPedido;
    IBQTEMP.ParamByName('ID_PROMOCAO').AsInteger := FIBQITENS.FieldByName('ID_PROMOCAO').AsInteger;
    IBQTEMP.Open;

    if (FIBQITENS.FieldByName('QTDACUMULADA').AsInteger div FIBQITENS.FieldByName('QTDCOMPRA').AsInteger) > 0 then
    begin
      // Aplica o desconto aos X primeiros itens conforme a quantidade de itens da promoção lançados e a quantidade definida na promoção
      IBQTEMP.First;

      iConta      := 0;
      iLimite     := 0;
      iItensFalta := Trunc(FIBQITENS.FieldByName('QTDACUMULADA').AsInteger / FIBQITENS.FieldByName('QTDCOMPRA').AsInteger);

      while IBQTEMP.Eof = False do
      begin
                                                                   
        if iItensFalta > 0 then
        begin

          if (iLimite < FIBQITENS.FieldByName('LIMITE').AsInteger) or (FIBQITENS.FieldByName('LIMITE').AsInteger = 0) then
          begin

            if iConta + IBQTEMP.FieldByName('QUANTIDADE').AsInteger <= FIBQITENS.FieldByName('QTDCOMPRA').AsInteger then
              iConta := iConta + IBQTEMP.FieldByName('QUANTIDADE').AsInteger
            else
              iConta := (FIBQITENS.FieldByName('QTDCOMPRA').AsInteger - iConta); // o que sobrou para descontar

            if iConta >= FIBQITENS.FieldByName('QTDCOMPRA').AsInteger then
            begin
              //iConta  := 0;
              //iLimite := iLimite + 1;

              dDescontoCP := FIBQITENS.FieldByName('DESCONTO').AsFloat / 100;

              //Lança desconto no próximo item benefício pertencente a promoção que não possui desconto da promoção
              IBQBENE.Close;
              IBQBENE.SQL.Text :=
                'select A.* ' +
                'from ALTERACA A ' +
                'join CLUBEPROMOCOESBENEFICIOS CPCA on CPCA.EAN = A.REFERENCIA and CPCA.ID_PROMOCAO = :ID_PROMOCAO ' +
                'where A.PEDIDO = :PEDIDO ' +
                'and A.CAIXA = :CAIXA ' +
                'and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
                ' and A.DESCRICAO <> ''<CANCELADO>'' ' +
                'order by ITEM';
              IBQBENE.ParamByName('CAIXA').AsString        := FCaixa;
              IBQBENE.ParamByName('PEDIDO').AsString       := FPedido;
              IBQBENE.ParamByName('ID_PROMOCAO').AsInteger := FIBQITENS.FieldByName('ID_PROMOCAO').AsInteger;
              IBQBENE.Open;

              while IBQBENE.Eof = False do
              begin

                FIBDataSet27.Close;
                FIBDataSet27.SelectSQL.Text :=
                  'select * ' +
                  'from ALTERACA ' +
                  'where PEDIDO = :PEDIDO ' +
                  'and CAIXA = :CAIXA ' +
                  'and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ' +
                  'and DESCRICAO = ''Desconto'' ' +
                  ' and REFERENCIA = ' + QuotedStr(PREFIXO_DESCONTO_SCANNTECH + FIBQITENS.FieldByName('ID_PROMOCAO').AsString) + // Apenas os descontos atribuídos pelo clube de descontos
                  ' and ITEM = :ITEM ' +
                  'order by ITEM';
                FIBDataSet27.ParamByName('CAIXA').AsString  := FCaixa;
                FIBDataSet27.ParamByName('PEDIDO').AsString := FPedido;
                FIBDataSet27.ParamByName('ITEM').AsString   := IBQBENE.FieldByName('ITEM').AsString;
                FIBDataSet27.Open;

                if FIBDataSet27.FieldByName('ITEM').AsString = '' then
                begin

                  if (iItensFalta - IBQBENE.FieldByName('QUANTIDADE').AsInteger) >= 0 then
                    iQtdBonus := IBQBENE.FieldByName('QUANTIDADE').AsInteger
                  else
                    iQtdBonus := iItensFalta;

                  FIBDataSet27.Append; // Desconto do Item
                  FIBDataSet27.FieldByName('REFERENCIA').AsString := PREFIXO_DESCONTO_SCANNTECH + FIBQITENS.FieldByName('ID_PROMOCAO').AsString;
                  FIBDataSet27.FieldByName('TIPO').AsString       := 'BALCAO';
                  FIBDataSet27.FieldByName('PEDIDO').AsString     := IBQBENE.FieldByName('PEDIDO').AsString;
                  FIBDataSet27.FieldByName('DESCRICAO').AsString  := 'Desconto';  // Desconto no item
                  FIBDataSet27.FieldByName('ITEM').AsString       := IBQBENE.FieldByName('ITEM').AsString;
                  FIBDataSet27.FieldByName('DATA').AsDateTime     := IBQBENE.FieldByName('DATA').AsDateTime;
                  {Sandro Silva 2022-09-09 inicio
                  FIBDataSet27.FieldByName('HORA').AsString       := IBQBENE.FieldByName('HORA').AsString;
                  }
                  FIBDataSet27.FieldByName('HORA').AsString       := FormatDateTime('HH:nn:ss', Time);
                  {Sandro Silva 2022-09-09 fim}
                  FIBDataSet27.FieldByName('QUANTIDADE').AsFloat  := 1;
                  FIBDataSet27.FieldByName('UNITARIO').AsFloat    := StrToFloat(FormatFloat('0.00', ((IBQBENE.FieldByName('UNITARIO').AsFloat * -1) * iQtdBonus) * dDescontoCP));
                  FIBDataSet27.FieldByName('TOTAL').AsFloat       := StrToFloat(FormatFloat('0.00', ((IBQBENE.FieldByName('UNITARIO').AsFloat * -1) * iQtdBonus) * dDescontoCP));
                  FIBDataSet27.FieldByName('CAIXA').AsString      := IBQBENE.FieldByName('CAIXA').AsString;
                  FIBDataSet27.FieldByName('ALIQUICM').AsString   := IBQBENE.FieldByName('ALIQUICM').AsString;
                  FIBDataSet27.Post;

                  if iConta >= FIBQITENS.FieldByName('QTDCOMPRA').AsInteger then
                  begin
                    iConta  := 0;
                    iLimite := iLimite + iQtdBonus; //1;
                  end;

                  iItensFalta := iItensFalta - iQtdBonus;

                  Break; // Sai do loop depois de aplicar o desconto 
                end;

                IBQBENE.Next;
              end; // while IBQ.Eof = False do

            end;

          end;

        end;

        IBQTEMP.Next;

      end;

    end;
    Result := True;
  except

  end;

  FreeAndNil(IBQTEMP);
  FreeAndNil(IBQBENE);

end;

function TPromocoesScanntech.AplicaPromocaoAdicionalRegalo: Boolean;
var
  iItensFalta: Integer;
  //dDescontoCP: Double;
  iConta: Integer;
  iLimite: Integer;
  iQtdBonus: Integer;
  IBQTEMP: TIBQuery;
  IBQBENE: TIBQuery;
begin

  Result := False;
  IBQTEMP := CriaIBQuery(FIBDataSet27.Transaction);
  IBQBENE := CriaIBQuery(FIBDataSet27.Transaction);

  IBQTEMP.DisableControls;
  IBQBENE.DisableControls;

  try
    // Seleciona todos os itens lançados pertencentes a promoção identificada
    IBQTEMP.Close;
    IBQTEMP.SQL.Text :=
      'select A.* ' +
      'from ALTERACA A ' +
      'join CLUBEPROMOCOESCONDIARTIGOS CPCA on CPCA.EAN = A.REFERENCIA and CPCA.ID_PROMOCAO = :ID_PROMOCAO ' +
      'where A.PEDIDO = :PEDIDO ' +
      'and A.CAIXA = :CAIXA ' +
      'and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
      ' and A.DESCRICAO <> ''<CANCELADO>'' ' +      
      'order by QUANTIDADE desc'; // Ordenar do item com quantidade maior para o menor
    IBQTEMP.ParamByName('CAIXA').AsString        := FCaixa;
    IBQTEMP.ParamByName('PEDIDO').AsString       := FPedido;
    IBQTEMP.ParamByName('ID_PROMOCAO').AsInteger := FIBQITENS.FieldByName('ID_PROMOCAO').AsInteger;
    IBQTEMP.Open;

    if (FIBQITENS.FieldByName('QTDACUMULADA').AsInteger div FIBQITENS.FieldByName('QTDCOMPRA').AsInteger) > 0 then
    begin
      // Aplica o desconto aos X primeiros itens conforme a quantidade de itens da promoção lançados e a quantidade definida na promoção
      IBQTEMP.First;

      iConta  := 0;
      iLimite := 0;
      iItensFalta := Trunc(FIBQITENS.FieldByName('QTDACUMULADA').AsInteger / FIBQITENS.FieldByName('QTDCOMPRA').AsInteger);
      while IBQTEMP.Eof = False do
      begin

        if iItensFalta > 0 then
        begin

          if (iLimite < FIBQITENS.FieldByName('LIMITE').AsInteger) or (FIBQITENS.FieldByName('LIMITE').AsInteger = 0) then
          begin

            if iConta + IBQTEMP.FieldByName('QUANTIDADE').AsInteger <= FIBQITENS.FieldByName('QTDCOMPRA').AsInteger then
              iConta := iConta + IBQTEMP.FieldByName('QUANTIDADE').AsInteger
            else
              iConta := (FIBQITENS.FieldByName('QTDCOMPRA').AsInteger - iConta); // o que sobrou para descontar

            if iConta >= FIBQITENS.FieldByName('QTDCOMPRA').AsInteger then
            begin
              iConta  := 0;
              iLimite := iLimite + 1;

              //Lança desconto no próximo item benefício pertencente a promoção que não possui desconto da promoção
              IBQBENE.Close;
              IBQBENE.SQL.Text :=
                'select A.* ' +
                'from ALTERACA A ' +
                'join CLUBEPROMOCOESBENEFICIOS CPCA on CPCA.EAN = A.REFERENCIA and CPCA.ID_PROMOCAO = :ID_PROMOCAO ' +
                'where A.PEDIDO = :PEDIDO ' +
                'and A.CAIXA = :CAIXA ' +
                'and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
                ' and A.DESCRICAO <> ''<CANCELADO>'' ' +
                'order by ITEM';
              IBQBENE.ParamByName('CAIXA').AsString        := FCaixa;
              IBQBENE.ParamByName('PEDIDO').AsString       := FPedido;
              IBQBENE.ParamByName('ID_PROMOCAO').AsInteger := FIBQITENS.FieldByName('ID_PROMOCAO').AsInteger;
              IBQBENE.Open;

              while IBQBENE.Eof = False do
              begin

                FIBDataSet27.Close;
                FIBDataSet27.SelectSQL.Text :=
                  'select * ' +
                  'from ALTERACA ' +
                  'where PEDIDO = :PEDIDO ' +
                  'and CAIXA = :CAIXA ' +
                  'and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ' +
                  'and DESCRICAO = ''Desconto'' ' +
                  ' and REFERENCIA = ' + QuotedStr(PREFIXO_DESCONTO_SCANNTECH + FIBQITENS.FieldByName('ID_PROMOCAO').AsString) + // Apenas os descontos atribuídos pelo clube de descontos
                  ' and ITEM = :ITEM ' +
                  'order by ITEM';
                FIBDataSet27.ParamByName('CAIXA').AsString  := FCaixa;
                FIBDataSet27.ParamByName('PEDIDO').AsString := FPedido;
                FIBDataSet27.ParamByName('ITEM').AsString   := IBQBENE.FieldByName('ITEM').AsString;
                FIBDataSet27.Open;

                if FIBDataSet27.FieldByName('ITEM').AsString = '' then
                begin

                  if (iItensFalta - IBQBENE.FieldByName('QUANTIDADE').AsInteger) >= 0 then
                    iQtdBonus := IBQBENE.FieldByName('QUANTIDADE').AsInteger
                  else
                    iQtdBonus := iItensFalta;

                  FIBDataSet27.Append; // Desconto do Item
                  FIBDataSet27.FieldByName('REFERENCIA').AsString := PREFIXO_DESCONTO_SCANNTECH + FIBQITENS.FieldByName('ID_PROMOCAO').AsString;
                  FIBDataSet27.FieldByName('TIPO').AsString       := 'BALCAO';
                  FIBDataSet27.FieldByName('PEDIDO').AsString     := IBQBENE.FieldByName('PEDIDO').AsString;
                  FIBDataSet27.FieldByName('DESCRICAO').AsString  := 'Desconto';  // Desconto no item
                  FIBDataSet27.FieldByName('ITEM').AsString       := IBQBENE.FieldByName('ITEM').AsString;
                  FIBDataSet27.FieldByName('DATA').AsDateTime     := IBQBENE.FieldByName('DATA').AsDateTime;
                  {Sandro Silva 2022-09-09 inicio
                  FIBDataSet27.FieldByName('HORA').AsString       := IBQBENE.FieldByName('HORA').AsString;
                  }
                  FIBDataSet27.FieldByName('HORA').AsString       := FormatDateTime('HH:nn:ss', Time);
                  {Sandro Silva 2022-09-09 fim}
                  FIBDataSet27.FieldByName('QUANTIDADE').AsFloat  := 1;
                  FIBDataSet27.FieldByName('UNITARIO').AsFloat    := StrToFloat(FormatFloat('0.00', ((IBQBENE.FieldByName('UNITARIO').AsFloat - 0.01) * -1) * iQtdBonus));
                  FIBDataSet27.FieldByName('TOTAL').AsFloat       := StrToFloat(FormatFloat('0.00', ((IBQBENE.FieldByName('UNITARIO').AsFloat - 0.01) * -1) * iQtdBonus));
                  FIBDataSet27.FieldByName('CAIXA').AsString      := IBQBENE.FieldByName('CAIXA').AsString;
                  FIBDataSet27.FieldByName('ALIQUICM').AsString   := IBQBENE.FieldByName('ALIQUICM').AsString;
                  FIBDataSet27.Post;

                  if iConta >= FIBQITENS.FieldByName('QTDCOMPRA').AsInteger then
                  begin
                    iConta  := 0;
                    iLimite := iLimite + iQtdBonus; //1;
                  end;

                  iItensFalta := iItensFalta - iQtdBonus;

                  Break; // Sai do loop depois de aplicar o desconto 
                end;

                IBQBENE.Next;
              end; // while IBQ.Eof = False do

            end;

          end;

        end;

        IBQTEMP.Next;

      end;

    end;
    Result := True;
  except

  end;

  FreeAndNil(IBQTEMP);
  FreeAndNil(IBQBENE);

end;

function TPromocoesScanntech.AplicaPromocaoDescuentoFijo: Boolean;
var
  iItensFalta: Integer;
  iLimite: Integer;
  iConta: Integer;
  dDescontoCP: Double;
  IBQTEMP: TIBQuery;
begin
  Result := False;
  IBQTEMP    := CriaIBQuery(FIBDataSet27.Transaction);

  IBQTEMP.DisableControls;

  try
    // Seleciona todos os itens lançados pertencentes a promoção identificada
    IBQTEMP.Close;
    IBQTEMP.SQL.Text :=
      'select A.* ' +
      'from ALTERACA A ' +
      'join CLUBEPROMOCOESCONDIARTIGOS CPCA on CPCA.EAN = A.REFERENCIA and CPCA.ID_PROMOCAO = :ID_PROMOCAO ' +
      'where A.PEDIDO = :PEDIDO ' +
      'and A.CAIXA = :CAIXA ' +
      'and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
      ' and A.DESCRICAO <> ''<CANCELADO>'' ' +      
      'order by QUANTIDADE desc'; // Ordenar do item com quantidade maior para o menor
    IBQTEMP.ParamByName('CAIXA').AsString        := FCaixa;
    IBQTEMP.ParamByName('PEDIDO').AsString       := FPedido;
    IBQTEMP.ParamByName('ID_PROMOCAO').AsInteger := FIBQITENS.FieldByName('ID_PROMOCAO').AsInteger;
    IBQTEMP.Open;

    if (FIBQITENS.FieldByName('QTDACUMULADA').AsInteger div FIBQITENS.FieldByName('QTDCOMPRA').AsInteger) > 0 then
    begin
      // Aplica o desconto aos X primeiros itens conforme a quantidade de itens da promoção lançados e a quantidade definida na promoção
      IBQTEMP.First;

      dDescontoCP := StrToFloat(FormatFloat('0.000', (FIBQITENS.FieldByName('DESCONTO').AsFloat * Trunc(FIBQITENS.FieldByName('QTDACUMULADA').AsInteger / FIBQITENS.FieldByName('QTDCOMPRA').AsInteger)) / FIBQITENS.FieldByName('QTDACUMULADA').AsInteger));  // Valor de desconto a cada vez que atingir a quantidade comprada do item referência
      iConta  := 0;
      iLimite := 0;
      iItensFalta := FIBQITENS.FieldByName('QTDACUMULADA').AsInteger;
      while IBQTEMP.Eof = False do
      begin

        if iItensFalta > 0 then
        begin

          if (iLimite < FIBQITENS.FieldByName('LIMITE').AsInteger) or (FIBQITENS.FieldByName('LIMITE').AsInteger = 0) then
          begin

            if iConta + IBQTEMP.FieldByName('QUANTIDADE').AsInteger <= FIBQITENS.FieldByName('QTDCOMPRA').AsInteger then
              iConta := iConta + IBQTEMP.FieldByName('QUANTIDADE').AsInteger
            else
              iConta := (FIBQITENS.FieldByName('QTDCOMPRA').AsInteger - iConta); // o que sobrou para descontar

            FIBDataSet27.Close;                        
            FIBDataSet27.SelectSQL.Text :=
              'select * ' +
              'from ALTERACA ' +
              'where PEDIDO = :PEDIDO ' +
              ' and CAIXA = :CAIXA ' +
              ' and ITEM = :ITEM ' +
              ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ' +
              ' and DESCRICAO = ''Desconto'' ' +
              ' and REFERENCIA like ' + QuotedStr(PREFIXO_DESCONTO_SCANNTECH + '%') +
              'order by ITEM';
            FIBDataSet27.ParamByName('CAIXA').AsString  := FCaixa;
            FIBDataSet27.ParamByName('PEDIDO').AsString := FPedido;
            FIBDataSet27.ParamByName('ITEM').AsString   := IBQTEMP.FieldByName('ITEM').AsString;
            FIBDataSet27.Open;

            FIBDataSet27.Append; // Desconto do Item
            FIBDataSet27.FieldByName('REFERENCIA').AsString := PREFIXO_DESCONTO_SCANNTECH + FIBQITENS.FieldByName('ID_PROMOCAO').AsString;
            FIBDataSet27.FieldByName('TIPO').AsString       := 'BALCAO';
            FIBDataSet27.FieldByName('PEDIDO').AsString     := IBQTEMP.FieldByName('PEDIDO').AsString;
            FIBDataSet27.FieldByName('DESCRICAO').AsString  := 'Desconto';  // Desconto no item
            FIBDataSet27.FieldByName('ITEM').AsString       := IBQTEMP.FieldByName('ITEM').AsString;
            FIBDataSet27.FieldByName('DATA').AsDateTime     := IBQTEMP.FieldByName('DATA').AsDateTime;
            {Sandro Silva 2022-09-09 inicio
            FIBDataSet27.FieldByName('HORA').AsString       := IBQTEMP.FieldByName('HORA').AsString;
            }
            FIBDataSet27.FieldByName('HORA').AsString       := FormatDateTime('HH:nn:ss', Time);
            {Sandro Silva 2022-09-09 fim}
            FIBDataSet27.FieldByName('QUANTIDADE').AsFloat  := 1;
            FIBDataSet27.FieldByName('UNITARIO').AsFloat    := StrToFloat(FormatFloat('0.00', (IBQTEMP.FieldByName('QUANTIDADE').AsInteger * dDescontoCP) * -1));
            FIBDataSet27.FieldByName('TOTAL').AsFloat       := StrToFloat(FormatFloat('0.00', (IBQTEMP.FieldByName('QUANTIDADE').AsInteger * dDescontoCP) * -1));
            FIBDataSet27.FieldByName('CAIXA').AsString      := IBQTEMP.FieldByName('CAIXA').AsString;
            FIBDataSet27.FieldByName('ALIQUICM').AsString   := IBQTEMP.FieldByName('ALIQUICM').AsString;
            FIBDataSet27.Post;

            if iConta >= FIBQITENS.FieldByName('QTDCOMPRA').AsInteger then
            begin
              iConta  := 0;
              iLimite := iLimite + 1;
            end;

            iItensFalta := iItensFalta - IBQTEMP.FieldByName('QUANTIDADE').AsInteger

          end;

        end;

        IBQTEMP.Next;

      end;

    end;
    Result := True;
  except

  end;

  FreeAndNil(IBQTEMP);

end;

function TPromocoesScanntech.AplicaPromocaoDescuentoVariable: Boolean;
var
  iItensFalta: Integer;
  iLimite: Integer;
  iConta: Integer;
  dDescontoCP: Double;
  IBQTEMP: TIBQuery;
begin
  Result := False;
  IBQTEMP    := CriaIBQuery(FIBDataSet27.Transaction);

  IBQTEMP.DisableControls;

  try
    // Seleciona todos os itens lançados pertencentes a promoção identificada
    IBQTEMP.Close;
    IBQTEMP.SQL.Text :=
      'select A.* ' +
      'from ALTERACA A ' +
      'join CLUBEPROMOCOESCONDIARTIGOS CPCA on CPCA.EAN = A.REFERENCIA and CPCA.ID_PROMOCAO = :ID_PROMOCAO ' +
      'where A.PEDIDO = :PEDIDO ' +
      'and A.CAIXA = :CAIXA ' +
      'and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
      ' and A.DESCRICAO <> ''<CANCELADO>'' ' +      
      'order by QUANTIDADE desc'; // Ordenar do item com quantidade maior para o menor
    IBQTEMP.ParamByName('CAIXA').AsString        := FCaixa;
    IBQTEMP.ParamByName('PEDIDO').AsString       := FPedido;
    IBQTEMP.ParamByName('ID_PROMOCAO').AsInteger := FIBQITENS.FieldByName('ID_PROMOCAO').AsInteger;
    IBQTEMP.Open;

    if (FIBQITENS.FieldByName('QTDACUMULADA').AsInteger div FIBQITENS.FieldByName('QTDCOMPRA').AsInteger) > 0 then
    begin
      // Aplica o desconto aos X primeiros itens conforme a quantidade de itens da promoção lançados e a quantidade definida na promoção
      IBQTEMP.First;

      dDescontoCP := (FIBQITENS.FieldByName('DESCONTO').AsFloat / 100 ) / FIBQITENS.FieldByName('QTDCOMPRA').AsInteger; // Desconto concedido a cada FIBQITENS.FieldByName('QTDCOMPRA').AsInteger comprada
      iConta  := 0;
      iLimite := 0;
      iItensFalta := FIBQITENS.FieldByName('QTDACUMULADA').AsInteger;
      while IBQTEMP.Eof = False do
      begin

        if iItensFalta > 0 then
        begin

          if (iLimite < FIBQITENS.FieldByName('LIMITE').AsInteger) or (FIBQITENS.FieldByName('LIMITE').AsInteger = 0) then
          begin

            if iConta + IBQTEMP.FieldByName('QUANTIDADE').AsInteger <= FIBQITENS.FieldByName('QTDCOMPRA').AsInteger then
              iConta := iConta + IBQTEMP.FieldByName('QUANTIDADE').AsInteger
            else
              iConta := (FIBQITENS.FieldByName('QTDCOMPRA').AsInteger - iConta); // o que sobrou para descontar

            FIBDataSet27.Close;                        
            FIBDataSet27.SelectSQL.Text :=
              'select * ' +
              'from ALTERACA ' +
              'where PEDIDO = :PEDIDO ' +
              ' and CAIXA = :CAIXA ' +
              ' and ITEM = :ITEM ' +
              ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ' +
              ' and DESCRICAO = ''Desconto'' ' +
              ' and REFERENCIA like ' + QuotedStr(PREFIXO_DESCONTO_SCANNTECH + '%') +
              'order by ITEM';
            FIBDataSet27.ParamByName('CAIXA').AsString  := FCaixa;
            FIBDataSet27.ParamByName('PEDIDO').AsString := FPedido;
            FIBDataSet27.ParamByName('ITEM').AsString   := IBQTEMP.FieldByName('ITEM').AsString;
            FIBDataSet27.Open;

            FIBDataSet27.Append; // Desconto do Item
            FIBDataSet27.FieldByName('REFERENCIA').AsString := PREFIXO_DESCONTO_SCANNTECH + FIBQITENS.FieldByName('ID_PROMOCAO').AsString;
            FIBDataSet27.FieldByName('TIPO').AsString       := 'BALCAO';
            FIBDataSet27.FieldByName('PEDIDO').AsString     := IBQTEMP.FieldByName('PEDIDO').AsString;
            FIBDataSet27.FieldByName('DESCRICAO').AsString  := 'Desconto';  // Desconto no item
            FIBDataSet27.FieldByName('ITEM').AsString       := IBQTEMP.FieldByName('ITEM').AsString;
            FIBDataSet27.FieldByName('DATA').AsDateTime     := IBQTEMP.FieldByName('DATA').AsDateTime;
            {Sandro Silva 2022-09-09 inicio
            FIBDataSet27.FieldByName('HORA').AsString       := IBQTEMP.FieldByName('HORA').AsString;
            }
            FIBDataSet27.FieldByName('HORA').AsString       := FormatDateTime('HH:nn:ss', Time);
            {Sandro Silva 2022-09-09 fim}
            FIBDataSet27.FieldByName('QUANTIDADE').AsFloat  := 1;
            FIBDataSet27.FieldByName('UNITARIO').AsFloat    := StrToFloat(FormatFloat('0.00', ((((IBQTEMP.FieldByName('UNITARIO').AsFloat * IBQTEMP.FieldByName('QUANTIDADE').AsInteger)) * dDescontoCP )* -1)));
            FIBDataSet27.FieldByName('TOTAL').AsFloat       := StrToFloat(FormatFloat('0.00', ((((IBQTEMP.FieldByName('UNITARIO').AsFloat * IBQTEMP.FieldByName('QUANTIDADE').AsInteger)) * dDescontoCP )* -1)));
            FIBDataSet27.FieldByName('CAIXA').AsString      := IBQTEMP.FieldByName('CAIXA').AsString;
            FIBDataSet27.FieldByName('ALIQUICM').AsString   := IBQTEMP.FieldByName('ALIQUICM').AsString;
            FIBDataSet27.Post;

            if iConta >= FIBQITENS.FieldByName('QTDCOMPRA').AsInteger then
            begin
              iConta  := 0;
              iLimite := iLimite + 1;
            end;

            iItensFalta := iItensFalta - 1

          end;

        end;

        IBQTEMP.Next;

      end;

    end;
    Result := True;
  except

  end;

  FreeAndNil(IBQTEMP);

end;

function TPromocoesScanntech.AplicaPromocaoLLevaPaga: Boolean;
var
  iAplica: Integer; // Número de vezes que deverá aplicar o desconto
  IBQTEMP: TIBQuery;
  iTotalAplicado: Integer;
begin
  Result := False;
  IBQTEMP    := CriaIBQuery(FIBDataSet27.Transaction);

  IBQTEMP.DisableControls;

  try
    // Seleciona todos os itens lançados pertencentes a promoção identificada
    IBQTEMP.Close;
    IBQTEMP.SQL.Text :=
      'select A.* ' +
      'from ALTERACA A ' +
      'join CLUBEPROMOCOESCONDIARTIGOS CPCA on CPCA.EAN = A.REFERENCIA and CPCA.ID_PROMOCAO = :ID_PROMOCAO ' +
      'where A.PEDIDO = :PEDIDO ' +
      'and A.CAIXA = :CAIXA ' +
      'and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
      ' and A.DESCRICAO <> ''<CANCELADO>'' ' +
      'order by ITEM';
    IBQTEMP.ParamByName('CAIXA').AsString        := FCaixa;
    IBQTEMP.ParamByName('PEDIDO').AsString       := FPedido;
    IBQTEMP.ParamByName('ID_PROMOCAO').AsInteger := FIBQITENS.FieldByName('ID_PROMOCAO').AsInteger;
    IBQTEMP.Open;

    if (FIBQITENS.FieldByName('QTDACUMULADA').AsInteger div FIBQITENS.FieldByName('QTDCOMPRA').AsInteger) > 0 then
    begin

      // Aplica o desconto aos X primeiros itens conforme a quantidade de itens da promoção lançados e a quantidade definida na promoção
      IBQTEMP.First;
      iAplica        := 0;
      iTotalAplicado := 0;
      while IBQTEMP.Eof = False do
      begin
        iAplica := iAplica + IBQTEMP.FieldByName('QUANTIDADE').AsInteger;

        if (iTotalAplicado <= (FIBQITENS.FieldByName('LIMITE').AsInteger * FIBQITENS.FieldByName('QTDCOMPRA').AsInteger)) or (FIBQITENS.FieldByName('LIMITE').AsInteger = 0)  then
        begin

          if (iAplica >= FIBQITENS.FieldByName('QTDCOMPRA').AsInteger) then
          begin

            iAplica := iAplica - FIBQITENS.FieldByName('QTDCOMPRA').AsInteger; // Se o acumulado for maior que a quantidade determinada pela promoção, mantem a diferença para ser somada a quantidade do próximo item vendido
            if iAplica < 0 then
              iAplica := 0;

            iTotalAplicado := iTotalAplicado + IBQTEMP.FieldByName('QUANTIDADE').AsInteger;

            FIBDataSet27.Close;
            FIBDataSet27.SelectSQL.Text :=
              'select * ' +
              'from ALTERACA ' +
              'where PEDIDO = :PEDIDO ' +
              ' and CAIXA = :CAIXA ' +
              ' and ITEM = :ITEM ' +
              ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ' +
              ' and DESCRICAO = ''Desconto'' ' +
              ' and REFERENCIA like ' + QuotedStr(PREFIXO_DESCONTO_SCANNTECH + '%') +
              'order by ITEM';
            FIBDataSet27.ParamByName('CAIXA').AsString  := FCaixa;
            FIBDataSet27.ParamByName('PEDIDO').AsString := FPedido;
            FIBDataSet27.ParamByName('ITEM').AsString   := IBQTEMP.FieldByName('ITEM').AsString;
            FIBDataSet27.Open;

            FIBDataSet27.Append; // Desconto do Item
            FIBDataSet27.FieldByName('REFERENCIA').AsString := PREFIXO_DESCONTO_SCANNTECH + FIBQITENS.FieldByName('ID_PROMOCAO').AsString;
            FIBDataSet27.FieldByName('TIPO').AsString       := 'BALCAO';
            FIBDataSet27.FieldByName('PEDIDO').AsString     := IBQTEMP.FieldByName('PEDIDO').AsString;
            FIBDataSet27.FieldByName('DESCRICAO').AsString  := 'Desconto';  // Desconto no item
            FIBDataSet27.FieldByName('ITEM').AsString       := IBQTEMP.FieldByName('ITEM').AsString;
            FIBDataSet27.FieldByName('DATA').AsDateTime     := IBQTEMP.FieldByName('DATA').AsDateTime;
            {Sandro Silva 2022-09-09 inicio
            FIBDataSet27.FieldByName('HORA').AsString       := IBQTEMP.FieldByName('HORA').AsString;
            }
            FIBDataSet27.FieldByName('HORA').AsString       := FormatDateTime('HH:nn:ss', Time);
            {Sandro Silva 2022-09-09 fim}
            FIBDataSet27.FieldByName('QUANTIDADE').AsFloat  := 1;
            FIBDataSet27.FieldByName('UNITARIO').AsFloat    := (IBQTEMP.FieldByName('UNITARIO').AsFloat - 0.01) * -1;
            FIBDataSet27.FieldByName('TOTAL').AsFloat       := (IBQTEMP.FieldByName('UNITARIO').AsFloat - 0.01) * -1;
            FIBDataSet27.FieldByName('CAIXA').AsString      := IBQTEMP.FieldByName('CAIXA').AsString;
            FIBDataSet27.FieldByName('ALIQUICM').AsString   := IBQTEMP.FieldByName('ALIQUICM').AsString;
            FIBDataSet27.Post;

            Result := True;

          end;

        end;
        IBQTEMP.Next;
        
      end;

    end;

  except

  end;

  FreeAndNil(IBQTEMP);
end;

function TPromocoesScanntech.AplicaPromocaoPrecoFijo: Boolean;
var
  iItensFalta: Integer;
  dDescontoCP: Double;
  iConta: Integer;
  iLimite: Integer;
  dFinal: Double;
  IBQTEMP: TIBQuery;
begin
  Result := False;
  IBQTEMP    := CriaIBQuery(FIBDataSet27.Transaction);

  IBQTEMP.DisableControls;

  try
    // Seleciona todos os itens lançados pertencentes a promoção identificada
    IBQTEMP.Close;
    IBQTEMP.SQL.Text :=
      'select A.* ' +
      'from ALTERACA A ' +
      'join CLUBEPROMOCOESCONDIARTIGOS CPCA on CPCA.EAN = A.REFERENCIA and CPCA.ID_PROMOCAO = :ID_PROMOCAO ' +
      'where A.PEDIDO = :PEDIDO ' +
      'and A.CAIXA = :CAIXA ' +
      'and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
      ' and A.DESCRICAO <> ''<CANCELADO>'' ' +
      'order by A.QUANTIDADE desc, A.ITEM'; // Ordenar do item com quantidade maior para o menor para ficar certo a aplicação do desconto com quantidades maiores
    IBQTEMP.ParamByName('CAIXA').AsString        := FCaixa;
    IBQTEMP.ParamByName('PEDIDO').AsString       := FPedido;
    IBQTEMP.ParamByName('ID_PROMOCAO').AsInteger := FIBQITENS.FieldByName('ID_PROMOCAO').AsInteger;
    IBQTEMP.Open;

    if (FIBQITENS.FieldByName('QTDACUMULADA').AsInteger div FIBQITENS.FieldByName('QTDCOMPRA').AsInteger) > 0 then
    begin
      // Aplica o desconto aos X primeiros itens conforme a quantidade de itens da promoção lançados e a quantidade definida na promoção
      IBQTEMP.First;

      dDescontoCP  := StrToFloat(FormatFloat('0.00', (FIBQITENS.FieldByName('PRECO').AsFloat / FIBQITENS.FieldByName('QTDCOMPRA').AsInteger))); // Desconto concedido a cada FIBQITENS.FieldByName('QTDCOMPRA').AsInteger comprada
      iConta  := 0;
      iLimite := 0;
      iItensFalta := FIBQITENS.FieldByName('QTDACUMULADA').AsInteger;
      while IBQTEMP.Eof = False do
      begin
                                                 
        if iItensFalta > 0 then
        begin

          if (iLimite < FIBQITENS.FieldByName('LIMITE').AsInteger) or (FIBQITENS.FieldByName('LIMITE').AsInteger = 0) then
          begin

            FIBDataSet27.Close;
            FIBDataSet27.SelectSQL.Text :=
              'select * ' +
              'from ALTERACA ' +
              'where PEDIDO = :PEDIDO ' +
              ' and CAIXA = :CAIXA ' +
              ' and ITEM = :ITEM ' +
              ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ' +
              ' and DESCRICAO = ''Desconto'' ' +
              ' and REFERENCIA like ' + QuotedStr(PREFIXO_DESCONTO_SCANNTECH + '%') +
              'order by ITEM';
            FIBDataSet27.ParamByName('CAIXA').AsString  := FCaixa;
            FIBDataSet27.ParamByName('PEDIDO').AsString := FPedido;
            FIBDataSet27.ParamByName('ITEM').AsString   := IBQTEMP.FieldByName('ITEM').AsString;
            FIBDataSet27.Open;

            if iConta + IBQTEMP.FieldByName('QUANTIDADE').AsInteger <= FIBQITENS.FieldByName('QTDCOMPRA').AsInteger then
              iConta := iConta + IBQTEMP.FieldByName('QUANTIDADE').AsInteger
            else
              iConta := (FIBQITENS.FieldByName('QTDCOMPRA').AsInteger - iConta); // o que sobrou para descontar

            if IBQTEMP.FieldByName('QUANTIDADE').AsInteger = 1 then
            begin
              dFinal := dDescontoCP;
              dFinal := ((IBQTEMP.FieldByName('UNITARIO').AsFloat * IBQTEMP.FieldByName('QUANTIDADE').AsInteger) - dFinal);
            end
            else
            begin
              dFinal := dDescontoCP * iConta;
              dFinal := ((IBQTEMP.FieldByName('UNITARIO').AsFloat * iConta) - dFinal); // Quantidade proporcial que falta para fechar o desconto limitado
            end;

            FIBDataSet27.Append; // Desconto do Item
            FIBDataSet27.FieldByName('REFERENCIA').AsString := PREFIXO_DESCONTO_SCANNTECH + FIBQITENS.FieldByName('ID_PROMOCAO').AsString;
            FIBDataSet27.FieldByName('TIPO').AsString       := 'BALCAO';
            FIBDataSet27.FieldByName('PEDIDO').AsString     := IBQTEMP.FieldByName('PEDIDO').AsString;
            FIBDataSet27.FieldByName('DESCRICAO').AsString  := 'Desconto';  // Desconto no item
            FIBDataSet27.FieldByName('ITEM').AsString       := IBQTEMP.FieldByName('ITEM').AsString;
            FIBDataSet27.FieldByName('DATA').AsDateTime     := IBQTEMP.FieldByName('DATA').AsDateTime;
            {Sandro Silva 2022-09-09 inicio
            FIBDataSet27.FieldByName('HORA').AsString       := IBQTEMP.FieldByName('HORA').AsString;
            }
            FIBDataSet27.FieldByName('HORA').AsString       := FormatDateTime('HH:nn:ss', Time);
            {Sandro Silva 2022-09-09 fim}
            FIBDataSet27.FieldByName('QUANTIDADE').AsFloat  := 1;
            FIBDataSet27.FieldByName('UNITARIO').AsFloat    := StrToFloat(FormatFloat('0.00', (dFinal * -1)));
            FIBDataSet27.FieldByName('TOTAL').AsFloat       := StrToFloat(FormatFloat('0.00', (dFinal * -1)));
            FIBDataSet27.FieldByName('CAIXA').AsString      := IBQTEMP.FieldByName('CAIXA').AsString;
            FIBDataSet27.FieldByName('ALIQUICM').AsString   := IBQTEMP.FieldByName('ALIQUICM').AsString;
            FIBDataSet27.Post;

            if iConta >= FIBQITENS.FieldByName('QTDCOMPRA').AsInteger then
            begin
              iConta  := 0;
              iLimite := iLimite + 1;
            end;

            iItensFalta := iItensFalta - 1

          end;

        end;

        IBQTEMP.Next;

      end;

    end;

    Result := True;

  except

  end;

  FreeAndNil(IBQTEMP);

end;

function TPromocoesScanntech.ClubePromocoesAtivo: Boolean;
var
  IBQCLUBECONFIG: TIBQuery;
begin
  IBQCLUBECONFIG := CriaIBQuery(FIBDataSet27.Transaction);
  try
    IBQCLUBECONFIG.Close;
    IBQCLUBECONFIG.SQL.Text :=
      'select ATIVO ' +
      'from CLUBEPROMOCOESCONFIG ';
    IBQCLUBECONFIG.Open;

    Result := (IBQCLUBECONFIG.FieldByName('ATIVO').AsString = 'S');
  except
    Result := False;
  end;
  FreeAndNil(IBQCLUBECONFIG);
end;

constructor TPromocoesScanntech.Create;
begin
  inherited;

end;

destructor TPromocoesScanntech.Destroy;
begin
  FreeAndNil(FIBQITENS);
  FreeAndNil(FIBTCONSULTA);
  inherited;
end;

procedure TPromocoesScanntech.SetFIBDataSet27(const Value: TIBDataSet);
begin
  FIBDataSet27 := Value;
end;

procedure TPromocoesScanntech.SetIBDatabase(const Value: TIBDatabase);
begin
  FIBDatabase := Value;

  FIBTCONSULTA := CriaIBTransaction(FIBDatabase);
  FIBQITENS := CriaIBQuery(FIBTCONSULTA);

  FIBQITENS.DisableControls;

end;

end.
