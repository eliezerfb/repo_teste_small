unit uDuplicaOrcamento;

interface

uses
  DB, IBDatabase, uIDuplicaOrcamento, IBQuery, uConectaBancoSmall, Forms, Windows;

type
  TDuplicaOrcamento = class(TInterfacedObject, IDuplicaOrcamento)
  private
    FcNewOrcamento: String;
    FcNroOrcamento: String;
    FoTransaction: TIBTransaction;
    FDataSetOrcamento: TDataSet;
    FDataSetOrcamentoOBS: TDataSet;
    function RetornaNroRegistro(AcGenerator: String): String;
    function RetornarDados(AcTabela: String): TIBQuery;
    procedure DuplicaTabelaOrcamento;
    procedure DuplicaTabelaOrcamentoObs;
    procedure GeraNovoNroPedido;
    function TestarCampoNaoDuplicar(AcCampo: String): Boolean;
    function TestarJaExiteNumeroOrcamento: Boolean;
  public
    class function New: IDuplicaOrcamento;
    function SetTransaction(AoTransaction: TIBTransaction): IDuplicaOrcamento;
    function SetNroOrcamento(AcNroPedido: String): IDuplicaOrcamento;
    function SetDataSetOrcamento(AoDataSet: TDataSet): IDuplicaOrcamento;
    function SetDataSetOrcamentoOBS(AoDataSet: TDataSet): IDuplicaOrcamento;
    function Duplicar: Boolean;
  end;

implementation

uses
  SysUtils, SmallFunc, uSmallResourceString;

{ TDuplicaOrcamento }

function TDuplicaOrcamento.Duplicar: Boolean;
begin
  Result := False;
  try
    GeraNovoNroPedido;

    DuplicaTabelaOrcamento;
    DuplicaTabelaOrcamentoObs;

    Result := True;
  except
    Application.MessageBox(PChar('Não foi possível duplicar o orçamento.' + SlineBreak + 'Tente novamente.'), Pchar(_cTituloMsg), mb_Ok + MB_ICONINFORMATION);
  end;
end;

procedure TDuplicaOrcamento.DuplicaTabelaOrcamento;
var
  i: Integer;
  qryDados: TIBQuery;
begin
  qryDados := RetornarDados('ORCAMENT');
  try
    try
      while not qryDados.Eof do
      begin
        FDataSetOrcamento.Append;

        if FDataSetOrcamento.FieldByName('REGISTRO').AsString = EmptyStr then
          FDataSetOrcamento.FieldByName('REGISTRO').AsString := RetornaNroRegistro('G_ORCAMENT');
        if FDataSetOrcamento.FieldByName('PEDIDO').AsString = EmptyStr then
          FDataSetOrcamento.FieldByName('PEDIDO').AsString := FcNewOrcamento;

        FDataSetOrcamento.FieldByName('DATA').AsDateTime := Date;
        
        for i := 0 to Pred(qryDados.FieldCount) do
        begin
          if Assigned(FDataSetOrcamento.FindField(qryDados.Fields[i].FieldName)) then
          begin
            if TestarCampoNaoDuplicar(qryDados.Fields[i].FieldName) then
              Continue;

            FDataSetOrcamento.FindField(qryDados.Fields[i].FieldName).Value := qryDados.Fields[i].Value;
          end;
        end;

        FDataSetOrcamento.Post;

        qryDados.Next;
      end;
    except
    end;
  finally
    FreeAndNil(qryDados)
  end;
end;

procedure TDuplicaOrcamento.DuplicaTabelaOrcamentoObs;
var
  i: Integer;
  qryDados: TIBQuery;
begin
  qryDados := RetornarDados('ORCAMENTOBS');
  try
    try
      while not qryDados.Eof do
      begin
        FDataSetOrcamentoOBS.Append;

        if FDataSetOrcamentoOBS.FieldByName('REGISTRO').AsString = EmptyStr then
          FDataSetOrcamentoOBS.FieldByName('REGISTRO').AsString := RetornaNroRegistro('G_ORCAMENTOBS_REGISTRO');
        if FDataSetOrcamentoOBS.FieldByName('PEDIDO').AsString = EmptyStr then
          FDataSetOrcamentoOBS.FieldByName('PEDIDO').AsString := FcNewOrcamento;

        for i := 0 to Pred(qryDados.FieldCount) do
        begin
          if Assigned(FDataSetOrcamentoOBS.FindField(qryDados.Fields[i].FieldName)) then
          begin
            if (qryDados.Fields[i].FieldName = 'REGISTRO') or (qryDados.Fields[i].FieldName = 'PEDIDO') then
              Continue;

            FDataSetOrcamentoOBS.FindField(qryDados.Fields[i].FieldName).Value := qryDados.Fields[i].Value;
          end;
        end;

        FDataSetOrcamentoOBS.Post;

        qryDados.Next;
      end;
    except
    end;
  finally
    FreeAndNil(qryDados)
  end;
end;

class function TDuplicaOrcamento.New: IDuplicaOrcamento;
begin
  Result := Self.Create;
end;

function TDuplicaOrcamento.SetDataSetOrcamento(AoDataSet: TDataSet): IDuplicaOrcamento;
begin
  Result := Self;

  FDataSetOrcamento := AoDataSet;
end;

function TDuplicaOrcamento.SetDataSetOrcamentoOBS(AoDataSet: TDataSet): IDuplicaOrcamento;
begin
  Result := Self;

  FDataSetOrcamentoOBS := AoDataSet;
end;

function TDuplicaOrcamento.SetTransaction(AoTransaction: TIBTransaction): IDuplicaOrcamento;
begin
  Result := Self;

  FoTransaction := AoTransaction;
end;

function TDuplicaOrcamento.RetornaNroRegistro(AcGenerator: String): String;
var
  QryGen: TIBQuery;
begin
  QryGen := CriaIBQuery(FoTransaction);
  try
    QryGen.Close;
    QryGen.SQL.Clear;
    QryGen.SQL.Add('select gen_id('+AcGenerator+',1) from rdb$database');
    QryGen.Open;

    Result := StrZero(StrToInt(QryGen.FieldByname('GEN_ID').AsString),10,0);
  finally
    FreeAndNil(QryGen);
  end;
end;

function TDuplicaOrcamento.RetornarDados(AcTabela: String): TIBQuery;
begin
  Result := CriaIBQuery(FoTransaction);

  Result.Close;
  Result.SQL.Clear;
  Result.SQL.Add('SELECT *');
  Result.SQL.Add('FROM ' + AcTabela);
  Result.SQL.Add('WHERE (PEDIDO=' + QuotedStr(FcNroOrcamento) + ')');
  Result.Open;

  Result.First;
end;

function TDuplicaOrcamento.SetNroOrcamento(AcNroPedido: String): IDuplicaOrcamento;
begin
  Result := Self;

  FcNroOrcamento := AcNroPedido;
end;

procedure TDuplicaOrcamento.GeraNovoNroPedido;
begin
  while (FcNewOrcamento = EmptyStr) or (TestarJaExiteNumeroOrcamento) do
    FcNewOrcamento := RetornaNroRegistro('G_ORCAMENTO');
end;

function TDuplicaOrcamento.TestarJaExiteNumeroOrcamento: Boolean;
var
  QryDados: TIBQuery;
begin
  Result := False;

  if FcNewOrcamento = EmptyStr then
    Exit;
    
  QryDados := CriaIBQuery(FoTransaction);
  try
    QryDados.Close;
    QryDados.SQL.Clear;
    QryDados.SQL.Add('SELECT');
    QryDados.SQL.Add('COUNT(PEDIDO) AS QTDE');
    QryDados.SQL.Add('FROM ORCAMENT');
    QryDados.SQL.Add('WHERE (PEDIDO=:XPEDIDO)');
    QryDados.ParamByName('XPEDIDO').AsString := FcNewOrcamento;
    QryDados.Open;

    Result := (QryDados.FieldByName('QTDE').AsInteger > 0);
  finally
    FreeAndNil(QryDados);
  end;
end;

function TDuplicaOrcamento.TestarCampoNaoDuplicar(AcCampo: String): Boolean;
const
  _cCampos = ';REGISTRO;NUMERONF;COO;PEDIDO;DATA;ENCRYPTHASH;VALORICM;ALIQUICM;';
begin
  Result := Pos(';'+AcCampo+';', _cCampos) > 0;
end;

end.
