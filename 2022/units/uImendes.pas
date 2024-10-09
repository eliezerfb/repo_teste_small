unit uImendes;

interface

uses SysUtils, Winapi.Windows, uClassesIMendes, Rest.Json, Rest.Types, uWebServiceIMendes,
  uDialogs, uLogSistema, uFrmProdutosIMendes, IBX.IBQuery, IBX.IBDatabase,
  uFuncoesBancoDados, smallfunc_xe, IBX.IBCustomDataSet, uSistema, Data.DB;

  function ProdutosDescricaoImendes(sCNPJ, sDescricao: string): TArray<TProdutoImendes>;
  function GetCodImendes(sCNPJ, sDescricao: string): integer;
  function GetTributacaoProd(ibdEstoque : TibDataSet): boolean;
  procedure SetTribProd(ibdEstoque : TibDataSet; Grupo : TGrupo);
  procedure GetDadosCabecalho(Cabecalho: TCabecalhoTrib; Transaction : TIBTransaction);

implementation

function ProdutosDescricaoImendes(sCNPJ,sDescricao : string): TArray<TProdutoImendes>;
var
  ConsultaProdDesc : TConsultaProdDesc;
  RetConsultaProdDesc : TRetConsultaProdDesc;
  sJson, sJsonRet : string;
begin
  Result := nil;

  try
    ConsultaProdDesc := TConsultaProdDesc.Create;
    ConsultaProdDesc.NomeServico := 'DESCRPRODUTOS';
    ConsultaProdDesc.Dados       := sCNPJ + '|'+ sDescricao;
    sJson := TJson.ObjectToJsonString(ConsultaProdDesc);

    if EnviaRequisicaoIMendes(rmPOST,
                             'EnviaRecebeDados',
                             sJson,
                             sJsonRet) then
    begin
      try
        RetConsultaProdDesc := TJson.JsonToObject<TRetConsultaProdDesc>(sJsonRet);
        Result := RetConsultaProdDesc.Produto;
      finally
        FreeAndNil(RetConsultaProdDesc);
      end;
    end else
    begin
      MensagemSistema('Falha ao consultar informações.',msgErro);
      LogSistema(sJsonRet);
    end;
  finally
    FreeAndNil(ConsultaProdDesc);
  end;
end;


function GetCodImendes(sCNPJ,sDescricao : string):integer;
var
  ProdutoImendesArray : TArray<TProdutoImendes>;
  i, CodIMendes : integer;
begin
  Result := 0;

  //Busca código pela descrição do produto
  try
    ProdutoImendesArray := ProdutosDescricaoImendes(sCNPJ,sDescricao);

    if Length(ProdutoImendesArray) > 0 then
    begin
      //Lista para usuário selecionar um produto
      CodIMendes := GetCodigoImendesProd(ProdutoImendesArray);
    end else
    begin
      MensagemSistema('Nenhum produto encontrado com essa descrição!',msgAtencao);
      Exit;
    end;
  finally
    for I := Low(ProdutoImendesArray) to High(ProdutoImendesArray) do
    begin
      FreeAndNil(ProdutoImendesArray[i]);
    end;

    SetLength(ProdutoImendesArray,0);
  end;

  Result := CodIMendes;
end;

function GetTributacaoProd(ibdEstoque : TibDataSet): boolean;
var
  TributacaoIMendesDTO : TTributacaoIMendesDTO;
  RetTributacaoIMendesDTO : TRetTributacaoIMendesDTO;
  ProdutoArray : TArray<TProdutoTrib>;
  sJson, sJsonRet : string;
  sUF : TArray<string>;
begin
  Result := False;

  //Envia Informações
  try
    TributacaoIMendesDTO := TTributacaoIMendesDTO.Create;

    //Cabeçalho
    GetDadosCabecalho(TributacaoIMendesDTO.Cabecalho,ibdEstoque.Transaction);

    //Produtos
    SetLength(ProdutoArray,1);
    ProdutoArray[0] := TProdutoTrib.Create;
    ProdutoArray[0].Descricao  := ibdEstoque.FieldByName('DESCRICAO').AsString;

    if ibdEstoque.FieldByName('CODIGO_IMENDES').AsString <> '' then
      ProdutoArray[0].CodIMendes := ibdEstoque.FieldByName('CODIGO_IMENDES').AsString
    else
      ProdutoArray[0].Codigo     := ibdEstoque.FieldByName('REFERENCIA').AsString;

    TributacaoIMendesDTO.Produto := ProdutoArray;

    //UF
    SetLength(sUF,1);
    sUF[0] := TributacaoIMendesDTO.Cabecalho.Uf;
    TributacaoIMendesDTO.Uf := sUF;

    sJson := TJson.ObjectToJsonString(TributacaoIMendesDTO);

    if EnviaRequisicaoIMendes(rmPOST,
                             'RegrasFiscais',
                             sJson,
                             sJsonRet) then
    begin
      try
        RetTributacaoIMendesDTO := TJson.JsonToObject<TRetTributacaoIMendesDTO>(sJsonRet);

        if RetTributacaoIMendesDTO <> nil then
        begin
          //Atribui tributação ao produto
          SetTribProd(ibdEstoque, RetTributacaoIMendesDTO.Grupo[0]);
          Result := True;
        end;
      finally
        FreeAndNil(RetTributacaoIMendesDTO);
      end;
    end else
    begin
      MensagemSistema('Falha ao consultar regras fiscais.',msgErro);
      LogSistema(sJsonRet);
    end;
  finally
    FreeAndNil(TributacaoIMendesDTO);
    FreeAndNil(ProdutoArray[0]);
    SetLength(sUF,0);
  end;
end;

procedure GetDadosCabecalho(Cabecalho: TCabecalhoTrib; Transaction : TIBTransaction);
var
  qryAux: TIBQuery;
  sRegime : string;
begin
  try
    qryAux := CriaIBQuery(Transaction);
    qryAux.SQL.Text := ' Select'+
                       ' 	 CGC,'+
                       ' 	 CRT,'+
                       ' 	 ESTADO,'+
                       ' 	 CNAE'+
                       ' From EMITENTE';
    qryAux.Open;

    if (qryAux.FieldByName('CRT').AsString = '1') or (qryAux.FieldByName('CRT').AsString = '4')  then
    begin
      sRegime := 'S'
    end else
    begin
      if TSistema.GetInstance.CodFaixaImendes = '98' then
        sRegime := 'P'
      else
        sRegime := 'R';
    end;

    Cabecalho.Amb        := '2'; //1-Homologação 2-Producao
    Cabecalho.Cnae       := qryAux.FieldByName('CNAE').AsString;
    Cabecalho.Cnpj       := LimpaNumero(qryAux.FieldByName('CGC').AsString);
    Cabecalho.CodFaixa   := TSistema.GetInstance.CodFaixaImendes;
    Cabecalho.Crt        := qryAux.FieldByName('CRT').AsString;
    Cabecalho.Uf         := qryAux.FieldByName('ESTADO').AsString;
    Cabecalho.RegimeTrib := sRegime;

    qryAux.Close;
  finally
    FreeAndNil(qryAux);
  end;
end;

procedure SetTribProd(ibdEstoque : TibDataSet; Grupo : TGrupo);
begin
  try
    if not (ibdEstoque.State = dsEdit) then
      ibdEstoque.Edit;

    ibdEstoque.FieldByName('CF').AsString   := LimpaNumero(Grupo.Ncm);
    ibdEstoque.FieldByName('CEST').AsString := LimpaNumero(Grupo.Cest);
    //ibdEstoque.FieldByName('CST_PIS_COFINS_ENTRADA').AsString := LimpaNumero(Grupo.c);

    ibdEstoque.FieldByName('STATUS_TRIBUTACAO').AsString        := 'Consultado';
    ibdEstoque.FieldByName('DATA_STATUS_TRIBUTACAO').AsDateTime := now;
  except
    on e:exception do
      MensagemSistema('Erro ao atribuir tributação.'+#13#10+e.Message,
                      msgErro);
  end;
end;



{
procedure SetTribProd(ibdEstoque : TibDataSet; RetTributacaoIMendesDTO : TRetTributacaoIMendesDTO);
var
  i : integer;
  sCodIMendes, sCodEan : string;
  bLocalizado : boolean;
begin
  for I := Low(RetTributacaoIMendesDTO.Grupo) to High(RetTributacaoIMendesDTO.Grupo) do
  begin
    bLocalizado := False;
    sCodIMendes := '';
    sCodEan     := '';

    if Length(RetTributacaoIMendesDTO.Grupo[i].CodIMendes) > 0 then
    begin
      sCodIMendes := RetTributacaoIMendesDTO.Grupo[i].CodIMendes[0];
    end;

    if Length(RetTributacaoIMendesDTO.Grupo[i].Produto) > 0 then
    begin
      sCodEan     := RetTributacaoIMendesDTO.Grupo[i].Produto[0];
    end;

    if bLocalizado then
    begin
      /////
    end;

  end;
end;
}


end.
