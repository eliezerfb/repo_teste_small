unit uDuplicaNFSe;

interface

uses
  IBX.IBDatabase, uIDuplicaNFSe, Data.DB, IBX.IBQuery, System.SysUtils;

type
  TDuplicaNFSe = class(TInterfacedObject, IDuplicaNFSe)
  private
    FoTransaction: TIBTransaction;
    FcNumeroNF: String;
    FcNewNFSe: String;
    FoDataSetNFSe: TDataSet;
    FoDataSetItens: TDataSet;
    procedure DuplicaTabelaVenda;
    function RetornarDados(AcTabela: String): TIBQuery;
    function RetornaNroRegistro(AcGenerator: String): String;
    procedure GeraNovoNroNF;
    function TestarCampoNaoDuplicar(AcCampo: String): Boolean;
    function TestarJaExiteNumeroOrcamento: Boolean;
    procedure DuplicaTabelaItens;
    function TestarCampoNaoDuplicarItens(AcCampo: String): Boolean;
  public
    class function New: IDuplicaNFSe;
    function SetTransaction(AoTransaction: TIBTransaction): IDuplicaNFSe;
    function SetNumeroNF(AcNumeroNF: String): IDuplicaNFSe;
    function SetDataSetsNFSe(AoDataSetNFSe, AoDataSetItens: TDataSet): IDuplicaNFSe;
    function Duplicar: Boolean;
  end;

implementation

uses
  uDialogs, uConectaBancoSmall, smallFunc_xe;

{ TDuplicaNFSe }

function TDuplicaNFSe.Duplicar: Boolean;
begin
  Result := False;
  try
    if LimpaNumero(FcNumeroNF) = EmptyStr then
    begin
      MensagemSistema('Nenhuma NFS-e selecionada.', msgInformacao);
      Exit;
    end;
    DuplicaTabelaVenda;
    DuplicaTabelaItens;

    Result := True;
  except
    MensagemSistema('Não foi possível duplicar a NFS-e.' + SlineBreak + 'Tente novamente.',msgAtencao);
  end;
end;

procedure TDuplicaNFSe.DuplicaTabelaVenda;
var
  i: Integer;
  qryDados: TIBQuery;
begin
  qryDados := RetornarDados('VENDAS');
  try
    while not qryDados.Eof do
    begin
      FoDataSetNFSe.Append;

      if not (FoDataSetNFSe.State in [dsInsert, dsEdit]) then
        FoDataSetNFSe.Edit;
      if FoDataSetNFSe.FieldByName('REGISTRO').AsString = EmptyStr then
        FoDataSetNFSe.FieldByName('REGISTRO').AsString := RetornaNroRegistro('G_VENDAS');

      if FoDataSetNFSe.FieldByName('NUMERONF').AsString = EmptyStr then
      begin
        GeraNovoNroNF;
        FoDataSetNFSe.FieldByName('NUMERONF').AsString := FcNewNFSe;
      end
      else
        FcNewNFSe := FoDataSetNFSe.FieldByName('NUMERONF').AsString;

      FoDataSetNFSe.FieldByName('EMITIDA').AsString := 'S';
      for i := 0 to Pred(qryDados.FieldCount) do
      begin
        if Assigned(FoDataSetNFSe.FindField(qryDados.Fields[i].FieldName)) then
        begin
          if not (FoDataSetNFSe.State in [dsInsert, dsEdit]) then
            FoDataSetNFSe.Edit;
          if TestarCampoNaoDuplicar(qryDados.Fields[i].FieldName) then
            Continue;

          FoDataSetNFSe.FindField(qryDados.Fields[i].FieldName).Value := qryDados.Fields[i].Value;
        end;
      end;
      FoDataSetNFSe.FieldByName('NSUD').AsDateTime := FoDataSetNFSe.FieldByName('EMISSAO').AsDateTime;

      FoDataSetNFSe.Post;

      qryDados.Next;
    end;
  finally
    FreeAndNil(qryDados)
  end;
end;

procedure TDuplicaNFSe.DuplicaTabelaItens;
var
  i: Integer;
  qryDados: TIBQuery;
begin
  qryDados := RetornarDados('ITENS003');
  try
    while not qryDados.Eof do
    begin
      FoDataSetItens.Append;

      if FoDataSetItens.FieldByName('REGISTRO').AsString = EmptyStr then
        FoDataSetItens.FieldByName('REGISTRO').AsString := RetornaNroRegistro('G_ITENS003');
      FoDataSetItens.FieldByName('NUMERONF').AsString := FcNewNFSe;

      for i := 0 to Pred(qryDados.FieldCount) do
      begin
        if Assigned(FoDataSetItens.FindField(qryDados.Fields[i].FieldName)) then
        begin
          if not (FoDataSetItens.State in [dsInsert, dsEdit]) then
            FoDataSetItens.Edit;
          if TestarCampoNaoDuplicarItens(qryDados.Fields[i].FieldName) then
            Continue;

          FoDataSetItens.FindField(qryDados.Fields[i].FieldName).Value := qryDados.Fields[i].Value;
        end;
      end;

      FoDataSetItens.Post;

      qryDados.Next;
    end;
  finally
    FreeAndNil(qryDados)
  end;
end;

function TDuplicaNFSe.RetornaNroRegistro(AcGenerator: String): String;
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

function TDuplicaNFSe.RetornarDados(AcTabela: String): TIBQuery;
begin
  Result := CriaIBQuery(FoTransaction);

  Result.Close;
  Result.SQL.Clear;
  Result.SQL.Add('SELECT *');
  Result.SQL.Add('FROM ' + AcTabela);
  Result.SQL.Add('WHERE (NUMERONF=' + QuotedStr(FcNumeroNF) + ')');
  Result.Open;

  Result.First;
end;

class function TDuplicaNFSe.New: IDuplicaNFSe;
begin
  Result := Self.Create;
end;

function TDuplicaNFSe.SetDataSetsNFSe(AoDataSetNFSe,
  AoDataSetItens: TDataSet): IDuplicaNFSe;
begin
  Result := Self;

  FoDataSetNFSe  := AoDataSetNFSe;
  FoDataSetItens := AoDataSetItens;
end;

function TDuplicaNFSe.SetNumeroNF(AcNumeroNF: String): IDuplicaNFSe;
begin
  Result := Self;

  FcNumeroNF := AcNumeroNF
end;

function TDuplicaNFSe.SetTransaction(AoTransaction: TIBTransaction): IDuplicaNFSe;
begin
  Result := Self;

  FoTransaction := AoTransaction;
end;

procedure TDuplicaNFSe.GeraNovoNroNF;
begin
  while (FcNewNFSe = EmptyStr) or (TestarJaExiteNumeroOrcamento) do
    FcNewNFSe := RetornaNroRegistro('G_SERIERPS');
end;

function TDuplicaNFSe.TestarJaExiteNumeroOrcamento: Boolean;
var
  QryDados: TIBQuery;
begin
  Result := False;

  if FcNewNFSe = EmptyStr then
    Exit;

  QryDados := CriaIBQuery(FoTransaction);
  try
    QryDados.Close;
    QryDados.SQL.Clear;
    QryDados.SQL.Add('SELECT');
    QryDados.SQL.Add('COUNT(NUMERONF) AS QTDE');
    QryDados.SQL.Add('FROM VENDAS');
    QryDados.SQL.Add('WHERE (NUMERONF=:XNUMERONF)');
    QryDados.ParamByName('XNUMERONF').AsString := FcNewNFSe;
    QryDados.Open;

    Result := (QryDados.FieldByName('QTDE').AsInteger > 0);
  finally
    FreeAndNil(QryDados);
  end;
end;

function TDuplicaNFSe.TestarCampoNaoDuplicar(AcCampo: String): Boolean;
const
  _cCampos = ';REGISTRO;NUMERONF;EMISSAO;SAIDAH;SAIDAD;NFEPROTOCOLO;STATUS;NFEXML;RECIBOXML;NSU;NSUH;EMITIDA;NSUD;';
begin
  Result := Pos(';'+AcCampo+';', _cCampos) > 0;
end;

function TDuplicaNFSe.TestarCampoNaoDuplicarItens(AcCampo: String): Boolean;
const
  _cCampos = ';REGISTRO;NUMERONF;';
begin
  Result := Pos(';'+AcCampo+';', _cCampos) > 0;
end;

end.
