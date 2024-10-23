unit uImendes;

interface

uses SysUtils, Winapi.Windows, uClassesIMendes, Rest.Json, Rest.Types, uWebServiceIMendes,
  uDialogs, uLogSistema, uFrmProdutosIMendes, IBX.IBQuery, IBX.IBDatabase,
  uFuncoesBancoDados, smallfunc_xe, IBX.IBCustomDataSet, uSistema, Data.DB,
  System.StrUtils, unit7, Mais3, uSmallConsts;

type TPesquisaImendes = (tpCodigo, tpEAN);

  function ProdutosDescricaoImendes(sCNPJ, sDescricao: string): TArray<TProdutoImendes>;
  function GetCodImendes(sCNPJ, sDescricao: string): integer;
  function GetTributacaoProd(ibdEstoque : TibDataSet; TipoPesquisa: TPesquisaImendes): boolean;
  function GetTributacaoEstoque(ibdEstoque : TibDataSet; sFiltro : string; out sMensagem : string): boolean;
  procedure SetTribProd(ibdEstoque : TibDataSet; Grupo : TGrupo; PreencheIPI : Boolean; UF : string; out sErro : string);
  procedure GetDadosCabecalho(Cabecalho: TCabecalhoTrib; Transaction : TIBTransaction);
  function GetCitTribIMendes(AliqICMS, BcIcms : double; CFOP, UF : string; Transaction : TIBTransaction):string;
  function GetSeqCitIMendes(Transaction : TIBTransaction):string;
  function LimpaCaracteresEspeciaisIM(sTexto:string):string;
  function GetProdutosDevolvidos(sCNPJ:string; out sMensagem : string; Transaction : TIBTransaction):boolean;
  function RemoveDevolvidos(sCNPJ:string; Produtos : TArray<TProdDevolvidos> ):boolean;
  function GetProdutosPendentes(sCNPJ,sUF:string; out sFiltro, sMensagem : string):boolean;

  
implementation

uses uFrmTelaProcessamento;

function ProdutosDescricaoImendes(sCNPJ,sDescricao : string): TArray<TProdutoImendes>;
var
  ConsultaProdDesc : TConsultaEnvDados;
  RetConsultaProdDesc : TRetConsultaProdDesc;
  sJson, sJsonRet : string;
begin
  Result := nil;

  try
    ConsultaProdDesc := TConsultaEnvDados.Create;
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
    end;
  finally
    FreeAndNil(ConsultaProdDesc);
  end;
end;


function GetCodImendes(sCNPJ,sDescricao : string):integer;
var
  ProdutoImendesArray : TArray<TProdutoImendes>;
  i : integer;
begin
  Result := 0;
  sDescricao := Trim(LimpaCaracteresEspeciaisIM(sDescricao));

  //Busca código pela descrição do produto
  try
    ProdutoImendesArray := ProdutosDescricaoImendes(sCNPJ,sDescricao);

    if Length(ProdutoImendesArray) > 0 then
    begin
      //Lista para usuário selecionar um produto
      Result := GetCodigoImendesProd(ProdutoImendesArray);
    end else
    begin
      if (Length(sDescricao) > 10)
        and (Pos(' ',RemoveUltimoTexto(sDescricao)) > 0) then
      begin
        Result := GetCodImendes(sCNPJ,RemoveUltimoTexto(sDescricao));
      end else
      begin
        MensagemSistema('Nenhum produto encontrado com essa descrição!',msgAtencao);
        Exit;
      end;
    end;
  finally
    for I := Low(ProdutoImendesArray) to High(ProdutoImendesArray) do
    begin
      FreeAndNil(ProdutoImendesArray[i]);
    end;

    SetLength(ProdutoImendesArray,0);
  end;
end;

function GetTributacaoProd(ibdEstoque : TibDataSet; TipoPesquisa: TPesquisaImendes): boolean;
var
  TributacaoIMendesDTO : TTributacaoIMendesDTO;
  RetTributacaoIMendesDTO : TRetTributacaoIMendesDTO;
  ProdutoArray : TArray<TProdutoTrib>;
  sJson, sJsonRet : string;
  sUF : TArray<string>;
  bEncontrado : boolean;
  sErro : string;
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
    ProdutoArray[0].Descricao  := LimpaCaracteresEspeciaisIM(ibdEstoque.FieldByName('DESCRICAO').AsString);

    if TipoPesquisa = tpCodigo then
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
        bEncontrado := False;

        if RetTributacaoIMendesDTO.Grupo <> nil then
        begin
          if Length(RetTributacaoIMendesDTO.Grupo[0].Produto) > 0 then
            if ContainsText(RetTributacaoIMendesDTO.Grupo[0].Produto[0], ibdEstoque.FieldByName('REFERENCIA').AsString) then
              bEncontrado := True;

          if Length(RetTributacaoIMendesDTO.Grupo[0].CodIMendes) > 0 then
            if (RetTributacaoIMendesDTO.Grupo[0].CodIMendes[0] = ibdEstoque.FieldByName('CODIGO_IMENDES').AsString) then
              bEncontrado := True;

          if bEncontrado then
          begin
            //Atribui tributação ao produto
            SetTribProd(ibdEstoque,
                        RetTributacaoIMendesDTO.Grupo[0],
                        TSistema.GetInstance.ConsultarIPIImendes,
                        TributacaoIMendesDTO.Uf[0],
                        sErro);

            //Auditoria
            Audita('ALTEROU', 'ESTOQUE',
                   Senhas.UsuarioPub,
                   'TRIBUTAÇÃO  INTELIGENTE '+ibdEstoque.FieldByName('CODIGO').AsString+' - '+ibdEstoque.FieldByName('DESCRICAO').AsString,
                   0,0);
            
            Result := True;
          end;
        end;

        if not(bEncontrado) then
        begin
          //Define Status
          if not (ibdEstoque.State = dsEdit) then
            ibdEstoque.Edit;

          ibdEstoque.FieldByName('STATUS_TRIBUTACAO').AsString        := _cStatusImendesPendente;
          ibdEstoque.FieldByName('DATA_STATUS_TRIBUTACAO').AsDateTime := now;
        end;
      finally
        FreeAndNil(RetTributacaoIMendesDTO);
      end;
    end else
    begin
      MensagemSistema('Falha ao consultar tributação.',msgErro);
    end;
  finally
    FreeAndNil(RetTributacaoIMendesDTO);
    FreeAndNil(TributacaoIMendesDTO);
    FreeAndNil(ProdutoArray[0]);
    SetLength(sUF,0);
  end;
end;


function GetTributacaoEstoque(ibdEstoque : TibDataSet; sFiltro : string; out sMensagem :string): boolean;
var
  TributacaoIMendesDTO : TTributacaoIMendesDTO;
  ProdutoArray : TArray<TProdutoTrib>;
  sSQL, sCodigo, sCodEan, sCodEan2 : string;
  sUF : TArray<string>;

  qryProduto: TIBQuery;
  iProd : integer;
  bEanValido : boolean;

  {$Region'//// EnviaPacoteRequest ////'}
  procedure EnviaPacoteRequest(sProgresso : string);
    var
      i, iGrupo, iProduto, iImendes : integer;
      sJson, sJsonRet : string;
      RetTributacaoIMendesDTO : TRetTributacaoIMendesDTO;
      sErro : string;
  begin
    //Gera Json envio
    try
      TributacaoIMendesDTO.Produto := ProdutoArray;

      sJson := TJson.ObjectToJsonString(TributacaoIMendesDTO);
    finally
      for i := Low(ProdutoArray) to High(ProdutoArray) do
      begin
        FreeAndNil(ProdutoArray[i]);
      end;

      SetLength(ProdutoArray,0);
    end;

    //Atualiza status processamento
    AtualizaStatusProc('Consultando tributação ',
                       sProgresso);

    //Envia requisição API
    if EnviaRequisicaoIMendes(rmPOST,
                             'RegrasFiscais',
                             sJson,
                             sJsonRet) then
    begin
      try
        //Atualiza status processamento
        AtualizaStatusProc('Atribuindo tributação aos produtos ',
                           sProgresso);

        RetTributacaoIMendesDTO := TJson.JsonToObject<TRetTributacaoIMendesDTO>(sJsonRet);

        if RetTributacaoIMendesDTO.Grupo <> nil then
        begin
          for iGrupo := Low(RetTributacaoIMendesDTO.Grupo) to High(RetTributacaoIMendesDTO.Grupo) do
          begin
            //Código IMendes
            for iImendes := Low(RetTributacaoIMendesDTO.Grupo[iGrupo].CodIMendes) to High(RetTributacaoIMendesDTO.Grupo[iGrupo].CodIMendes) do
            begin
              if ibdEstoque.Locate('CODIGO_IMENDES',RetTributacaoIMendesDTO.Grupo[iGrupo].CodIMendes[iImendes],[]) then
              begin
                //Atribui tributação ao produto
                SetTribProd(ibdEstoque,
                            RetTributacaoIMendesDTO.Grupo[iGrupo],
                            TSistema.GetInstance.ConsultarIPIImendes,
                            TributacaoIMendesDTO.Uf[0],
                            sErro);

                ibdEstoque.Post;
              end;
            end;

            //Código de Barras
            for iProduto := Low(RetTributacaoIMendesDTO.Grupo[iGrupo].Produto) to High(RetTributacaoIMendesDTO.Grupo[iGrupo].Produto) do
            begin
              if Length(RetTributacaoIMendesDTO.Grupo[iGrupo].Produto[iProduto]) = 5 then
              begin
                //Código Interno
                sCodigo := RetTributacaoIMendesDTO.Grupo[iGrupo].Produto[iProduto];

                if ibdEstoque.Locate('CODIGO',sCodigo,[]) then
                begin
                  //Atribui tributação ao produto
                  SetTribProd(ibdEstoque,
                              RetTributacaoIMendesDTO.Grupo[iGrupo],
                              TSistema.GetInstance.ConsultarIPIImendes,
                              TributacaoIMendesDTO.Uf[0],
                              sErro);

                  ibdEstoque.Post;
                end;

              end else
              begin
                //Código de barras
                sCodEan   := RetTributacaoIMendesDTO.Grupo[iGrupo].Produto[iProduto];
                sCodEan2  := RetTributacaoIMendesDTO.Grupo[iGrupo].Produto[iProduto];

                if Copy(sCodEan2,1,1) = '0' then
                  Delete(sCodEan2,1,1);

                if (ibdEstoque.Locate('REFERENCIA',sCodEan,[]))
                  or (ibdEstoque.Locate('REFERENCIA',sCodEan2,[])) then
                begin
                  //Atribui tributação ao produto
                  SetTribProd(ibdEstoque,
                              RetTributacaoIMendesDTO.Grupo[iGrupo],
                              TSistema.GetInstance.ConsultarIPIImendes,
                              TributacaoIMendesDTO.Uf[0],
                              sErro);

                  ibdEstoque.Post;
                end;
              end;
            end;
          end;
        end;

        sMensagem := sMensagem + sErro;
      finally
        FreeAndNil(RetTributacaoIMendesDTO);
      end;
    end else
    begin
      sMensagem := 'Falha ao consultar regras fiscais.'
    end;
  end;
  {$Endregion}
begin
  Result := False;

  sSQL := ' Select *'+
          ' From ESTOQUE'+
          ' Where Coalesce(ATIVO,0) = 0 '+
          '   and Coalesce(TIPO_ITEM,'''') <> ''09'' '+//Serviço
          '   and Coalesce(CONSULTA_TRIBUTACAO,''N'') = ''S'' '+//Marcado
          sFiltro+
          ' Order By IDESTOQUE';

  //Consulta para retorno
  ibdEstoque.Close;
  ibdEstoque.SelectSQL.Text := sSQL;
  ibdEstoque.Open;

  if ibdEstoque.IsEmpty then
  begin
    sMensagem := 'Nenhum produto para sanear!';
    Exit;
  end;

  try
    try
      TributacaoIMendesDTO := TTributacaoIMendesDTO.Create;

      //Cabeçalho
      GetDadosCabecalho(TributacaoIMendesDTO.Cabecalho,ibdEstoque.Transaction);

      //UF
      SetLength(sUF,1);
      sUF[0] := TributacaoIMendesDTO.Cabecalho.Uf;
      TributacaoIMendesDTO.Uf := sUF;

      {$Region'//// Consulta produtos para enviar ////'}
      qryProduto := CriaIBQuery(ibdEstoque.Transaction);
      qryProduto.SQL.Text := sSQL;
      qryProduto.Open;
      qryProduto.FetchAll;

      while not qryProduto.Eof do
      begin
        bEanValido := (qryProduto.FieldByName('REFERENCIA').AsString <> '')
                      and (ValidaEAN(qryProduto.FieldByName('REFERENCIA').AsString))
                      and (Copy(qryProduto.FieldByName('REFERENCIA').AsString,1,2) <> '20' ); //Codigo interno


        iProd := Length(ProdutoArray);
        SetLength(ProdutoArray,iProd+1);

        ProdutoArray[iProd] := TProdutoTrib.Create;
        ProdutoArray[iProd].Descricao  := LimpaCaracteresEspeciaisIM(qryProduto.FieldByName('DESCRICAO').AsString);

        ProdutoArray[iProd].CodIMendes := qryProduto.FieldByName('CODIGO_IMENDES').AsString;

        if bEanValido then
        begin
          ProdutoArray[iProd].Codigo     := qryProduto.FieldByName('REFERENCIA').AsString;
          ProdutoArray[iProd].TipoCodigo := 0; //Código EAN (barras)
        end else
        begin
          ProdutoArray[iProd].Codigo     := qryProduto.FieldByName('CODIGO').AsString;
          ProdutoArray[iProd].TipoCodigo := 1; //Código Interno
        end;

        qryProduto.Next;

        //Envia para API pacotes de 1000 produtos
        if (qryProduto.Eof)
          or (Length(ProdutoArray) >= 1000) then
        begin
          var
            sAtual, sTotal : string;

          if qryProduto.Eof then
            sAtual := IntToStr(qryProduto.RecNo)
          else
            sAtual := IntToStr(qryProduto.RecNo-1);

          sTotal := qryProduto.RecordCount.ToString;

          EnviaPacoteRequest(sAtual+'/'+sTotal);
        end;
      end;
      {$Endregion}

      Result := sMensagem = '';
    finally
      FreeAndNil(qryProduto);
      FreeAndNil(TributacaoIMendesDTO);
      SetLength(sUF,0);
    end;

    //O que não retornou marca como Pendente
    ExecutaComando(' Update ESTOQUE '+
                   '   set STATUS_TRIBUTACAO = '+QuotedStr(_cStatusImendesPendente)+
                   '   , DATA_STATUS_TRIBUTACAO = CURRENT_TIMESTAMP '+
                   ' Where Coalesce(ATIVO,0) = 0 '+
                   '   and Coalesce(TIPO_ITEM,'''') <> ''09'' '+//Serviço
                   '   and Coalesce(CONSULTA_TRIBUTACAO,''N'') = ''S'' '+//Marcado
                   '   and STATUS_TRIBUTACAO <> '+QuotedStr(_cStatusImendesConsultado)+
                   sFiltro,
                   ibdEstoque.Transaction);
  except
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

procedure SetTribProd(ibdEstoque : TibDataSet; Grupo : TGrupo; PreencheIPI : Boolean; UF : string; out sErro : string);
begin
  Form7.SaneamentoIMendes := True;

  try
    if not (ibdEstoque.State = dsEdit) then
      ibdEstoque.Edit;

    ibdEstoque.FieldByName('CF').AsString                     := LimpaNumero(Grupo.Ncm);
    ibdEstoque.FieldByName('CEST').AsString                   := LimpaNumero(Grupo.Cest);
    ibdEstoque.FieldByName('TAGS_').AsString                  := AlteraValorDaTagNoCampo('cProdANP', Grupo.Codanp, ibdEstoque.FieldByName('TAGS_').AsString);
    
    ibdEstoque.FieldByName('CST_PIS_COFINS_ENTRADA').AsString := Grupo.Piscofins.CstEnt;
    ibdEstoque.FieldByName('CST_PIS_COFINS_SAIDA').AsString   := Grupo.Piscofins.CstSai;
    ibdEstoque.FieldByName('ALIQ_PIS_SAIDA').AsFloat          := Grupo.Piscofins.AliqPIS;
    ibdEstoque.FieldByName('ALIQ_PIS_SAIDA').AsFloat          := Grupo.Piscofins.AliqCOFINS;
    ibdEstoque.FieldByName('NATUREZA_RECEITA').AsString       := Grupo.Piscofins.Nri;

    if PreencheIPI then
    begin
      ibdEstoque.FieldByName('CST_IPI').AsString              := Grupo.Ipi.CstSai;
      ibdEstoque.FieldByName('IPI').AsFloat                   := Grupo.Ipi.AliqIPI;
      ibdEstoque.FieldByName('ENQ_IPI').AsString              := Grupo.Ipi.Codenq;
    end;
    
    ibdEstoque.FieldByName('CST').AsString                    := Grupo.Regra[0].Cst;
    ibdEstoque.FieldByName('CSOSN').AsString                  := Grupo.Regra[0].Csosn;
    
    if (Copy(Grupo.Regra[0].Cst,2,2) = '00')
      or (Copy(Grupo.Regra[0].Cst,2,2) = '20') 
      or (Copy(Grupo.Regra[0].Cst,2,2) = '40') 
      or (Copy(Grupo.Regra[0].Cst,2,2) = '41') 
      or (Copy(Grupo.Regra[0].Cst,2,2) = '60') 
      or (Copy(Grupo.Regra[0].Cst,2,2) = '61') 
      or (Copy(Grupo.Regra[0].Cst,2,2) = '90') then
    begin
      ibdEstoque.FieldByName('CST_NFCE').AsString             := Copy(Grupo.Regra[0].Cst,2,2);
    end else
    begin
      ibdEstoque.FieldByName('CST_NFCE').Clear;
    end;

    if (Grupo.Regra[0].Csosn = '102') 
      or (Grupo.Regra[0].Csosn = '103')
      or (Grupo.Regra[0].Csosn = '300')
      or (Grupo.Regra[0].Csosn = '400')
      or (Grupo.Regra[0].Csosn = '500')
      or (Grupo.Regra[0].Csosn = '900')
      or (Grupo.Regra[0].Csosn = '61') then
    begin
      ibdEstoque.FieldByName('CSOSN_NFCE').AsString           := Grupo.Regra[0].Csosn;
    end else
    begin
      ibdEstoque.FieldByName('CSOSN_NFCE').Clear;
    end;

    if (Grupo.Regra[0].Cst = '010') 
      or (Grupo.Regra[0].Cst = '030')
      or (Grupo.Regra[0].Cst = '070')
      or (Grupo.Regra[0].Csosn = '201')
      or (Grupo.Regra[0].Csosn = '202')
      or (Grupo.Regra[0].Csosn = '203') then
    begin
      ibdEstoque.FieldByName('PIVA').AsFloat                  := 1 + (Grupo.Regra[0].Iva / 100);
    end else
    begin
      ibdEstoque.FieldByName('PIVA').Clear;
    end;

    if Grupo.Regra[0].Fcp > 0 then
      ibdEstoque.FieldByName('TAGS_').AsString                  := AlteraValorDaTagNoCampo('FCP', Grupo.Regra[0].Fcp.ToString, ibdEstoque.FieldByName('TAGS_').AsString)
    else
      ibdEstoque.FieldByName('TAGS_').AsString                  := AlteraValorDaTagNoCampo('FCP', '', ibdEstoque.FieldByName('TAGS_').AsString);

    ibdEstoque.FieldByName('TAGS_').AsString                  := AlteraValorDaTagNoCampo('cBenef', Grupo.Regra[0].CodBenef, ibdEstoque.FieldByName('TAGS_').AsString);
    ibdEstoque.FieldByName('TAGS_').AsString                  := AlteraValorDaTagNoCampo('pRedBC', FloatToStr(100 - Grupo.Regra[0].Reducaobcicms), ibdEstoque.FieldByName('TAGS_').AsString);
    
    if (Grupo.Regra[0].CfopVenda = 5101) 
      or (Grupo.Regra[0].CfopVenda = 5102)
      or (Grupo.Regra[0].CfopVenda = 5103)
      or (Grupo.Regra[0].CfopVenda = 5104)
      or (Grupo.Regra[0].CfopVenda = 5115)
      or (Grupo.Regra[0].CfopVenda = 5405) 
      or (Grupo.Regra[0].CfopVenda = 5656) 
      or (Grupo.Regra[0].CfopVenda = 5667) 
      or (Grupo.Regra[0].CfopVenda = 5933) 
      or (Grupo.Regra[0].CfopVenda = 5949) then
    begin
      ibdEstoque.FieldByName('CFOP').AsString                 := Grupo.Regra[0].CfopVenda.ToString;
    end else
    begin
      ibdEstoque.FieldByName('CFOP').Clear;
    end;

    ibdEstoque.FieldByName('ALIQUOTA_NFCE').AsFloat           := Grupo.Regra[0].Aliqicms;


    //CIT
    ibdEstoque.FieldByName('ST').AsString  := GetCitTribIMendes(Grupo.Regra[0].Aliqicms,
                                                                100 - Grupo.Regra[0].Reducaobcicms,  
                                                                Grupo.Regra[0].CfopVenda.ToString,
                                                                UF,
                                                                ibdEstoque.Transaction);

    
    //Define Status
    ibdEstoque.FieldByName('STATUS_TRIBUTACAO').AsString        := _cStatusImendesConsultado;
    ibdEstoque.FieldByName('DATA_STATUS_TRIBUTACAO').AsDateTime := now;
    ibdEstoque.FieldByName('IDPERFILTRIBUTACAO').Clear;
  except
    on e:exception do
      sErro := 'Erro ao atribuir tributação prod: '+ibdEstoque.FieldByName('CODIGO').AsString+#13#10+e.Message+#13#10;
  end;

  Form7.SaneamentoIMendes := False;
end;


function GetCitTribIMendes(AliqICMS, BcIcms : double; CFOP, UF : string; Transaction : TIBTransaction):string;
var
  qryAux: TIBQuery;
  sCIT : string;
  sDescricao : string;
begin
  Result := '';

  try
    {$Region'//// Verifica se já tem tributação cadastrada ////'}
    try
      qryAux := CriaIBQuery(Transaction);
      qryAux.SQL.Text := ' Select'+
                         '   ST'+
                         ' From ICM'+
                         ' Where TRIB_INTELIGENTE = ''S'' '+
                         '   and CFOP = '+QuotedStr(CFOP)+
                         '   and '+UF+'_ = '+StringReplace(AliqICMS.ToString,',','.',[rfReplaceAll])+
                         '   and BASE = '+StringReplace(BcIcms.ToString,',','.',[rfReplaceAll])+
                         '   and COALESCE(ST,'''') <> ''''  ';
      qryAux.Open;

      if not qryAux.IsEmpty then
      begin
        Result := qryAux.FieldByName('ST').AsString;
        Exit;
      end;
    finally
      FreeAndNil(qryAux);
    end;
    {$Endregion}

    {$Region'//// Se não tem tributação cadastrada ////'}
    sCIT       := GetSeqCitIMendes(Transaction);
    sDescricao := 'Tributação '+AliqICMS.ToString+'% BASE ICMS '+ BcIcms.ToString + '% CFOP ' + CFOP;

    Form7.ibDataSet14.Append;
    Form7.ibDataSet14CFOP.AsString                := CFOP;
    Form7.ibDataSet14NOME.AsString                := sDescricao;
    Form7.ibDataSet14ST.AsString                  := sCIT;
    Form7.ibDataSet14BASE.AsFloat                 := BcIcms;
    Form7.ibDataSet14.FieldByName(UF+'_').AsFloat := AliqICMS;
    Form7.ibDataSet14LISTAR.AsString              := 'N';
    Form7.ibDataSet14TRIB_INTELIGENTE.AsString    := 'S';
    Form7.ibDataSet14.Post;

    Result := sCIT;
    {$Endregion}
  except
  end;
end;

function GetSeqCitIMendes(Transaction : TIBTransaction):string;
var
  iSec : integer;
  sSeq, sLetra : string;
begin
  Result := '';

  try
    iSec   := StrToIntDef(IncGenerator(Transaction.DefaultDatabase,'G_CIT'),1);
    sSeq   := StrZero(iSec,3,0);
    sLetra := LetraNumeroAlfabeto(StrToIntDef(Copy(sSeq,1,1),0)+1);
    sSeq   := sLetra+Copy(sSeq,2,2);

    //Verifica se já esta em uso
    if ExecutaComandoEscalar(Transaction,' Select Count(*)'+
                                         ' From ICM'+
                                         ' Where ST ='+QuotedStr(sSeq)) > 0 then
      sSeq := GetSeqCitIMendes(Transaction);

    Result := sSeq;
  except
  end;
end;

function LimpaCaracteresEspeciaisIM(sTexto:string):string;
begin
  sTexto := StringReplace(sTexto,'\',' ',[rfReplaceAll]);
  sTexto := StringReplace(sTexto,'/',' ',[rfReplaceAll]);
  sTexto := StringReplace(sTexto,'''',' ',[rfReplaceAll]);
  sTexto := StringReplace(sTexto,':',' ',[rfReplaceAll]);
  sTexto := StringReplace(sTexto,'*',' ',[rfReplaceAll]);
  sTexto := StringReplace(sTexto,'?',' ',[rfReplaceAll]);
  sTexto := StringReplace(sTexto,'"',' ',[rfReplaceAll]);
  sTexto := StringReplace(sTexto,'<',' ',[rfReplaceAll]);
  sTexto := StringReplace(sTexto,'>',' ',[rfReplaceAll]);
  sTexto := StringReplace(sTexto,'|',' ',[rfReplaceAll]);

  Result := sTexto;
end;

function GetProdutosDevolvidos(sCNPJ:string; out sMensagem : string; Transaction : TIBTransaction):boolean;
var
  ConsultaProdDesc : TConsultaEnvDados;
  RetDevolvidos : TRetDevolvidosDTO;
  sJson, sJsonRet : string;
  sFiltroCodigo, sFiltroEan, sCodEAN : string;
  i: Integer;
begin
  Result := False;

  try
    ConsultaProdDesc := TConsultaEnvDados.Create;
    ConsultaProdDesc.NomeServico := 'HISTORICOACESSO';
    ConsultaProdDesc.Dados       := sCNPJ;
    sJson := TJson.ObjectToJsonString(ConsultaProdDesc);

    if EnviaRequisicaoIMendes(rmPOST,
                             'EnviaRecebeDados',
                             sJson,
                             sJsonRet) then
    begin
      try
        RetDevolvidos := TJson.JsonToObject<TRetDevolvidosDTO>(sJsonRet);

        sFiltroCodigo := QuotedStr('XYZ');
        sFiltroEan    := QuotedStr('XYZ');

        for i := Low(RetDevolvidos.ProdDevolvidos) to High(RetDevolvidos.ProdDevolvidos) do
        begin
          if RetDevolvidos.ProdDevolvidos[i].CodInterno = 'S' then
          begin
            sFiltroCodigo := sFiltroCodigo + ','+QuotedStr(RetDevolvidos.ProdDevolvidos[i].Codigo);
          end else
          begin
            sCodEAN       := RetDevolvidos.ProdDevolvidos[i].Codigo;
            sFiltroEan    := sFiltroEan + ','+QuotedStr(sCodEAN);

            if Copy(sCodEAN,1,1) = '0' then
            begin
              Delete(sCodEAN,1,1);
              sFiltroEan    := sFiltroEan + ','+QuotedStr(sCodEAN);
            end;
          end;
        end;

        if Length(RetDevolvidos.ProdDevolvidos) > 0 then
        begin
          //Marca rejeitados
          ExecutaComando(' Update ESTOQUE '+
                         '   set STATUS_TRIBUTACAO ='+QuotedStr(_cStatusImendesRejeitado)+
                         ' Where STATUS_TRIBUTACAO = '+QuotedStr(_cStatusImendesPendente)+
                         '   and ( CODIGO IN ('+sFiltroCodigo+')  or REFERENCIA IN ('+sFiltroEan+') )',
                         Transaction);

          //Remove Devolvidos
          if RemoveDevolvidos(sCNPJ,RetDevolvidos.ProdDevolvidos) then
            Result := True;
        end;
      finally
        FreeAndNil(RetDevolvidos);
      end;
    end else
    begin
      sMensagem := 'Falha ao consultar informações.';
    end;
  finally
    FreeAndNil(ConsultaProdDesc);
  end;
end;


function RemoveDevolvidos(sCNPJ:string; Produtos : TArray<TProdDevolvidos> ):boolean;
var
  ConsultaProdDesc : TConsultaEnvDados;
  sJson, sJsonRet, sIds : string;
  i: Integer;
begin
  Result := False;

  for I := Low(Produtos) to High(Produtos) do
  begin
    sIds := sIds + ',{ \"id\": '+Produtos[i].Id.tostring+' }';
  end;

  Delete(sIds,1,1);

  try
    ConsultaProdDesc := TConsultaEnvDados.Create;
    ConsultaProdDesc.NomeServico := 'REMOVEDEVOLVIDOS';
    ConsultaProdDesc.Dados       := '{ \"cnpj\": \"'+sCNPJ+'\",\"produtos\": [ '+sIds+' ] }';
    sJson := TJson.ObjectToJsonString(ConsultaProdDesc);
    sJson := StringReplace(sJson,'\\\','\',[rfReplaceAll]);

    if EnviaRequisicaoIMendes(rmPOST,
                             'EnviaRecebeDados',
                             sJson,
                             sJsonRet) then
    begin
      Result := True;
    end;
  finally
    FreeAndNil(ConsultaProdDesc);
  end;
end;

function GetProdutosPendentes(sCNPJ,sUF:string; out sFiltro, sMensagem : string):boolean;
var
  ConsultaProdDesc : TConsultaEnvDados;
  sJson, sJsonRet : string;
  sFiltroCodigo, sFiltroEan, sCodEAN : string;
  RetPendentesDTO : TRetPendentesDTO;
  i : integer;
begin
  Result := False;

  try
    ConsultaProdDesc := TConsultaEnvDados.Create;
    ConsultaProdDesc.NomeServico := 'ALTERADOS';
    ConsultaProdDesc.Dados       := sCNPJ+'|'+sUF+'|1000';
    sJson := TJson.ObjectToJsonString(ConsultaProdDesc);

    if EnviaRequisicaoIMendes(rmPOST,
                             'EnviaRecebeDados',
                             sJson,
                             sJsonRet) then
    begin
      try
        RetPendentesDTO := TJson.JsonToObject<TRetPendentesDTO>(sJsonRet);

        if RetPendentesDTO.Cabecalho.ProdutosRetornados > 0 then
        begin
          sFiltroCodigo := QuotedStr('XYZ');
          sFiltroEan    := QuotedStr('XYZ');

          for I := Low(RetPendentesDTO.Produto) to High(RetPendentesDTO.Produto) do
          begin
            if RetPendentesDTO.Produto[i].CodigoInterno = 'S' then
            begin
              sFiltroCodigo := sFiltroCodigo + ','+QuotedStr(RetPendentesDTO.Produto[i].Codigo);
            end else
            begin
              sCodEAN       := RetPendentesDTO.Produto[i].Codigo;
              sFiltroEan    := sFiltroEan + ','+QuotedStr(sCodEAN);

              if Copy(sCodEAN,1,1) = '0' then
              begin
                Delete(sCodEAN,1,1);
                sFiltroEan    := sFiltroEan + ','+QuotedStr(sCodEAN);
              end;
            end;
          end;

          sFiltro := ' and ( CODIGO IN ('+sFiltroCodigo+')  or REFERENCIA IN ('+sFiltroEan+') )';
          Result := True;
        end else
        begin
          sMensagem := 'Nenhum produto pendente retornado.';
        end;
      finally
        FreeAndNil(RetPendentesDTO);
      end;
    end else
    begin
      sMensagem := 'Falha ao consultar produtos pendentes.';
    end;
  finally
    FreeAndNil(ConsultaProdDesc);
  end;
end;

end.
