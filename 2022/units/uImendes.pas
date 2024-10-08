unit uImendes;

interface

uses SysUtils, Winapi.Windows, uClassesIMendes, Rest.Json, Rest.Types, uWebServiceIMendes,
  uDialogs, uLogSistema, uFrmProdutosIMendes;

  function ProdutosDescricaoImendes(sCNPJ, sDescricao: string): TArray<TProdutoImendes>;
  function GetCodImendes(sCNPJ, sDescricao: string): integer;

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

end.
