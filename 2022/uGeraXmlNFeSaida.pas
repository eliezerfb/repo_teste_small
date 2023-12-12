unit uGeraXmlNFeSaida;

interface

uses
  SysUtils
  , Classes
  , IniFiles
  , Forms
  , Controls
  , Windows
  , Dialogs
  , Math
  , DB
  , ibdatabase
  , IBQuery
  , ShellApi
  , SpdNFeDataSets
  , spdXMLUtils
  , spdNFeType
  , spdNFe
  , SmallFunc
  , unit7
  , unit11
  , unit29
  , unit12
  , Mais
  , ugeraxmlnfe
  , StrUtils
;



var
  sCodigoANP, sDentroOuForadoEStado : string;
  vIVA60_V_ICMST : Real;

  // Rateio
  fCalculo, vFRETE, vOUTRAS, vDESCONTO, vSEGURO : Real;
  fDesconto, fFrete, fOutras, fSeguro : array[0..999] of double;

  fRateioDoDesconto, {fPercentualFCPST, fPercentualFCP, }vIVA60_B_ICMST : Real;

  dvICMSMonoRet_N45Total: Real; // Sandro Silva 2023-06-07
  dqBCMonoRet_N43aTotal: real; // Sandro Silva 2023-09-04
  sMensagemIcmMonofasicoSobreCombustiveis: String; // Sandro Silva 2023-06-16

  procedure GeraXmlNFeSaida;
  procedure GeraXmlNFeSaidaTags(vIPISobreICMS : Boolean; fSomaNaBase : Real);


implementation

uses uFrmInformacoesRastreamento, uFuncoesFiscais, uFuncoesRetaguarda,
  uDialogs, ufrmOrigemCombustivel, uFuncoesBancoDados;

procedure GeraXmlNFeSaida;
var
  spMVAST, spICMSST, sChave, sEx1, sEx2, sEx3, sEx4, sEx5, sEx6, sEx7, sEx8, sEx9, sEx10, sEx11, sEx12, sEx13, sEx14, sEx15, sEx16, sEx17, sEx18 : String;
  fTotalDupl,  vTotalImpostoImportacao : Real;
  _file : TStringList;
  I, J, iAnoRef : integer;
  sComplemento : String;
  sRetorno : String;
  sRecibo : String;
  sCupomReferenciado : String;
  sUFEmbarq, sLocaldeEmbarque, sLocalDespacho, sPais, sCodPais : String;
  vST, vBC, vBCST, vPIS, vPIS_S, vCOFINS, vCOFINS_S, vICMS : Real;
  vBC_PIS : Real;

  fTotaldeTriubutos, fTotaldeTriubutos_uf, fTotaldeTriubutos_muni , fSomaNaBase : Real;
  Mais1Ini : tIniFile;

  // Pis cofins da Operação
  sCST_PIS_COFINS : String;
  rpPIS, rpCOFINS, bcPISCOFINS_op : Real;
  bTributa : Boolean;

  sDIFAL_OBS : String;
  fAliquotaPadrao, fPercentualDeReducaoDeBC, fICMSDesonerado, vICMSDeson, fFCPST, fFCPUFDest, fICMSUFDest, fICMSUFREmet, fDIFAL, fIPIDevolvido,  fFCP: Real;

  stpOp_VeiculosNovos,
  sChassi_VeiculosNovos,
  sCCor_VeiculosNovos,
  sXCor_VeiculosNovos,
  sPot_VeiculosNovos,
  scilin_VeiculosNovos,
  spesoL_VeiculosNovos,
  spesoB_VeiculosNovos,
  snSerie_VeiculosNovos,
  stpComb_VeiculosNovos,
  snMotor_VeiculosNovos,
  sCMT_VeiculosNovos,
  sdist_VeiculosNovos,
  sanoMod_VeiculosNovos,
  sanoFab_VeiculosNovos,
  stpPint_VeiculosNovos,
  stpVeic_VeiculosNovos,
  sespVeic_VeiculosNovos,
  sVIN_VeiculosNovos,
  scondVeic_VeiculosNovos,
  scMod_VeiculosNovos,
  scCorDENATRAN_VeiculosNovos,
  slota_VeiculosNovos,
  stpRest_VeiculosNovos : String;
  stPag_YA02: String; // Sandro Silva 2023-06-29
  dQtdAcumulado: Double;
  IBQUERY99: TIBQuery; // Sandro Silva 2022-11-10 Para Substituir Form7.IBDATASET99 que é usado em eventos disparados em cascata
  IBQCREDENCIADORA: TIBQuery;

  vlBalseIPI, vlFreteRateadoItem : Double;

  vFreteSobreIPI,vIPISobreICMS : Boolean;
  cBenef, cBenefItem : string;
begin
  if AllTrim(Form7.ibDataSet15OPERACAO.AsString) = '' then
    Form7.ibDataSet14.Append
  else
    Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);

  if Form7.ibDataSet14BASE.AsFloat <> 0 then
    bTributa := True
  else
    bTributa := False;

  // Pis cofins da Operação
  sCST_PIS_COFINS := Form7.ibDataSet14.FieldByname('CSTPISCOFINS').AsString;
  rpPIS           := Form7.ibDataSet14.FieldByname('PPIS').AsFloat;
  rpCOFINS        := Form7.ibDataSet14.FieldByname('PCOFINS').AsFloat;
  bcPISCOFINS_op  := Form7.ibDataSet14.FieldByname('BCPISCOFINS').AsFloat;

  //Mauricio Parizotto 2023-03-28
  vFreteSobreIPI := CampoICMporNatureza('FRETESOBREIPI',Form7.ibDataSet15OPERACAO.AsString,Form7.ibDataSet15.Transaction) = 'S';
  vIPISobreICMS  := CampoICMporNatureza('SOBREIPI',Form7.ibDataSet15OPERACAO.AsString,Form7.ibDataSet15.Transaction) = 'S';
  cBenef         := trim(CampoICMporNatureza('CBENEF',Form7.ibDataSet15OPERACAO.AsString,Form7.ibDataSet15.Transaction)); //Mauricio Parizotto 2023-12-12

  // Relaciona os clientes com o arquivo de vendas
  Form7.ibDAtaset2.Close;
  Form7.ibDAtaset2.Selectsql.Clear;
  Form7.ibDAtaset2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet15CLIENTE.AsString)+' ');  //
  Form7.ibDAtaset2.Open;

  // Data da última venda para o cliente
  try
    if  Form7.ibDAtaset2ULTIMACO.AsDateTime < Form7.ibDataSet15EMISSAO.AsDateTime then
    begin
      Form7.ibDAtaset2.Edit;
      Form7.ibDAtaset2ULTIMACO.AsDateTime := Form7.ibDataSet15EMISSAO.AsDateTime;
      Form7.ibDAtaset2.Post;
    end;
  except
    try
      Form7.ibDataSet15.Edit;
      Form7.ibDataSet15LOKED.AsString := 'S';
      Form7.ibDataSet15.Post;
    except end;
  end;

  Form7.ibDataSet9.Locate('NOME',Form7.ibDataSet15VENDEDOR.AsString,[]);
  Form7.ibDataSet18.Locate('NOME',Form7.ibDataSet15TRANSPORTA.AsString,[]);

  IBQUERY99 := Form7.CriaIBQuery(Form7.IBDataSet99.Transaction);

  // Informações do Emitente da NFe
  IBQUERY99.Close;
  IBQUERY99.SQL.Clear;
  IBQUERY99.SQL.Add('select * from MUNICIPIOS where NOME='+QuotedStr(Form7.ibDataSet13MUNICIPIO.AsString)+' '+' and UF='+QuotedStr(UpperCase(Form7.ibDataSet13ESTADO.AsString))+' ');
  IBQUERY99.Open;

  if AllTrim(Copy(IBQUERY99.FieldByname('CODIGO').AsString,1,7)) = '' then
  begin
    Form7.ibDataSet15.Edit;
    Form7.ibDataSet15STATUS.AsString    := 'Erro: Nome do município do emitente inválido.';
    Abort;
  end;

  Form7.spdNFeDataSets.LoteNFe.Clear;
  Form7.spdNFeDataSets.Incluir; // Inicia a insercao de dados na NFe

  // Autorização para obter XML
  if Form7.ibDataSet13ESTADO.AsString = 'BA' then
  begin
    if Length(LimpaNumero(Form7.sCNPJContabilidade)) = 0 then
    begin
      Form7.sCNPJContabilidade := LimpaNumero('13.937.073/0001-56');
    end;
  end;

  if Length(LimpaNumero(Form7.sCNPJContabilidade)) <> 0 then
  begin
    Form7.spdNFeDataSets.IncluirPart('AUTXML');
    if Length(LimpaNumero(Form7.sCNPJContabilidade)) = 11 then
    begin
      Form7.spdNFeDataSets.Campo('CPF_GA03').Value  := LimpaNumero(Form7.sCNPJContabilidade);
    end else
    begin
      Form7.spdNFeDataSets.Campo('CNPJ_GA02').Value := LimpaNumero(Form7.sCNPJContabilidade);
    end;
    Form7.spdNFeDataSets.SalvarPart('AUTXML');
  end;

  // Then end Autorização para obter XML
  Form7.spdNFeDataSets.Campo('Id_A03').Value      := ''; // Calcula Automático. Essa linha é desnecessária

  if Form1.sVersaoLayout = '4.00' then
  begin
    Form7.spdNFeDataSets.Campo('versao_A02').Value  := '4.00'; // Versão do Layout que está utilizando
  end else
  begin
    Form7.spdNFeDataSets.Campo('versao_A02').Value  := '3.10'; // Versão do Layout que está utilizando
  end;

  Form7.spdNFeDataSets.Campo('cUF_B02').Value     := Copy(IBQUERY99.FieldByname('CODIGO').AsString,1,2);  //Codigo da UF para o estado SC = '42'
  Form7.spdNFeDataSets.Campo('cNF_B03').Value     := '004640327'; // Código Interno do Sistema que está integrando com a NFe
  Form7.spdNFeDataSets.Campo('natOp_B04').Value   := ConverteAcentos2(Form7.ibDataSet15.FieldByname('OPERACAO').AsString);

  if Form1.sVersaoLayout = '4.00' then
  begin
  end else
  begin
    if Copy(Uppercase(Form7.ibDataSet14.FieldByname('INTEGRACAO').AsString)+'       ',1,7) = 'RECEBER' then
    begin
      Form7.spdNFeDataSets.Campo('indPag_B05').Value  := '1'; //Indicador da Forma de Pgto (0=Pagamento à vista; 1=Pagamento à prazo; 2=outros)
    end else
    begin
      if allTrim(Copy(Uppercase(Form7.ibDataSet14.FieldByname('INTEGRACAO').AsString)+'       ',1,7)) = '' then
      begin
        Form7.spdNFeDataSets.Campo('indPag_B05').Value  := '2'; //Indicador da Forma de Pgto (0=Pagamento à vista; 1=Pagamento à prazo; 2=outros)
      end else
      begin
        Form7.spdNFeDataSets.Campo('indPag_B05').Value  := '0'; //Indicador da Forma de Pgto (0=Pagamento à vista; 1=Pagamento à prazo; 2=outros)
      end;
    end;
  end;

  Form7.spdNFeDataSets.Campo('mod_B06').Value     := '55'; //Código do Modelo de Documento Fiscal

  if Form1.bModoSCAN then
  begin
    Form7.spdNFeDataSets.Campo('serie_B07').Value   := IntToStr(StrToInt(Copy(Form7.ibDataSet15.FieldByname('NUMERONF').AsString,10,3))+900); // Série SCAN
  end else
  begin
    Form7.spdNFeDataSets.Campo('serie_B07').Value   := IntToStr(StrToInt(Copy(Form7.ibDataSet15.FieldByname('NUMERONF').AsString,10,3))); // Série do Documento
  end;

  Form7.spdNFeDataSets.Campo('nNF_B08').Value      := IntToStr(StrToInt(Copy(Form7.ibDataSet15.FieldByname('NUMERONF').AsString,1,9))); // Número da Nota Fiscal

  Form7.spdNFeDataSets.Campo('dhEmi_B09').Value    := StrTran(DateToStrInvertida(Form7.ibDataSet15.FieldByname('EMISSAO').AsDateTime),'/','-')+'T'+TimeToStr(Time)+Form7.sFuso; // Data de Emissão da Nota Fiscal

  // Permite data e hora de saída em branco
  if AllTrim(Form7.ibDataSet15.FieldByname('SAIDAD').AsString) <> '' then
  begin
    Form7.spdNFeDataSets.Campo('dhSaiEnt_B10').Value := StrTran(DateToStrInvertida(Form7.ibDataSet15.FieldByname('SAIDAD').AsDateTime),'/','-')+'T'+Form7.ibDataSet15.FieldByname('SAIDAH').AsString+Form7.sFuso; // Data de Saída ou Entrada da Nota Fiscal
    if Form7.spdNFeDataSets.Campo('dhSaiEnt_B10').Value < Form7.spdNFeDataSets.Campo('dhEmi_B09').Value then Form7.spdNFeDataSets.Campo('dhSaiEnt_B10').Value := Form7.spdNFeDataSets.Campo('dhEmi_B09').Value;
  end;

  Form7.spdNFeDataSets.Campo('tpNF_B11').Value     := '1'; // Tipo de Documento Fiscal (0-Entrada, 1-Saída)

  // Identificador do local de destino da operação 1-Operação Interna, 2-Operação Interestadual e 3-Operação com exterior
  if Copy(Form7.ibDataSet14CFOP.AsString,1,1) = '7' then
  begin
    Form7.spdNFeDataSets.Campo('idDest_B11a').Value  := '3'; // Identificador do local de destino da operação 1-Operação Interna, 2-Operação Interestadual e 3-Operação com exterior
  end else
  begin
    if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) <> UpperCase(Form7.ibDataSet13ESTADO.AsString))  then
    begin
      if (Pos('<idDest>1<',Form7.ibDataSet14OBS.AsString)<>0) then
      begin
        Form7.spdNFeDataSets.Campo('idDest_B11a').Value  := '1'; // Identificador do local de destino da operação 1-Operação Interna, 2-Operação Interestadual e 3-Operação com exterior
      end else
      begin
        if Form7.ibDAtaset2ESTADO.AsString = 'EX' then
        begin
          Form7.spdNFeDataSets.Campo('idDest_B11a').Value  := '1'; // Identificador do local de destino da operação 1-Operação Interna, 2-Operação Interestadual e 3-Operação com exterior
        end else
        begin
          Form7.spdNFeDataSets.Campo('idDest_B11a').Value  := '2'; // Identificador do local de destino da operação 1-Operação Interna, 2-Operação Interestadual e 3-Operação com exterior
        end;
      end;
    end else
    begin
      if (Pos('<idDest>2<',Form7.ibDataSet14OBS.AsString)<>0) then
      begin
        Form7.spdNFeDataSets.Campo('idDest_B11a').Value  := '2'; // Identificador do local de destino da operação 1-Operação Interna, 2-Operação Interestadual e 3-Operação com exterior
      end else
      begin
        Form7.spdNFeDataSets.Campo('idDest_B11a').Value  := '1'; // Identificador do local de destino da operação 1-Operação Interna, 2-Operação Interestadual e 3-Operação com exterior
      end;
    end;
  end;

  Form7.spdNFeDataSets.Campo('cMunFG_B12').Value   := Copy(IBQUERY99.FieldByname('CODIGO').AsString,1,7); // Código da Cidade do Emitente (Tabela do IBGE)

  // B20a Tag Nota de Produtor Rural Saída
  Form7.spdNFeDataSets.Campo('tpImp_B21').Value   := '1'; // Tipo de Impressão da Danfe (1- Retrato , 2-Paisagem)

  if Form1.bModoSCAN then
  begin
    Form7.spdNFeDataSets.Campo('tpEmis_B22').Value  := '3';
  end else
  begin
    if Form7.bContingencia then
    begin
      Form7.spdNFeDataSets.Campo('tpEmis_B22').Value  := '5'; // Papel normal Contingência
    end else
    begin
      if Form1.bModoSVC then
      begin
        if (UpperCase(Form7.ibDataSet13ESTADO.AsString) = 'AM') or
           (UpperCase(Form7.ibDataSet13ESTADO.AsString) = 'BA') or
           (UpperCase(Form7.ibDataSet13ESTADO.AsString) = 'CE') or
           (UpperCase(Form7.ibDataSet13ESTADO.AsString) = 'ES') or
           (UpperCase(Form7.ibDataSet13ESTADO.AsString) = 'GO') or
           (UpperCase(Form7.ibDataSet13ESTADO.AsString) = 'MA') or
           (UpperCase(Form7.ibDataSet13ESTADO.AsString) = 'MS') or
           (UpperCase(Form7.ibDataSet13ESTADO.AsString) = 'MT') or
           (UpperCase(Form7.ibDataSet13ESTADO.AsString) = 'PA') or
           (UpperCase(Form7.ibDataSet13ESTADO.AsString) = 'PE') or
           (UpperCase(Form7.ibDataSet13ESTADO.AsString) = 'PI') or
           (UpperCase(Form7.ibDataSet13ESTADO.AsString) = 'PR') then
        begin
          Form7.spdNFeDataSets.Campo('tpEmis_B22').Value  := '7'; // SVC-RS
        end else
        begin
          Form7.spdNFeDataSets.Campo('tpEmis_B22').Value  := '6'; // SVC-AN
        end;
      end else
      begin
        Form7.spdNFeDataSets.Campo('tpEmis_B22').Value  := '1'; //Forma de Emissão da NFe (1-Normal, 2-Contingência 3-SCAN)
      end;
    end;
  end;

  Form7.spdNFeDataSets.Campo('cDV_B23').Value     := ''; // Calcula Automatico - Linha desnecessária já que o componente calcula o Dígito Verificador automaticamente e coloca no devido campo

  if Form1.bHomologacao then
    Form7.spdNFeDataSets.Campo('tpAmb_B24').Value := '2'
  else
    Form7.spdNFeDataSets.Campo('tpAmb_B24').Value   := '1';

  Form7.spdNFeDataSets.Campo('finNFe_B25').Value       := Form7.ibDataSet15FINNFE.AsString;    // Finalidade da NFe (1-Normal, 2-Complementar, 3-de Ajuste, 4-Devolução de mercadoria)
  Form7.spdNFeDataSets.Campo('indFinal_B25a').Value    := Form7.ibDataSet15INDFINAL.AsString;  // Indica operação com Consumidor final] deve ser preenchido. Dica: Utilize: 0-Não, 1-Consumidor Final'. Process stopped. Use Step or Run to continue.
  Form7.spdNFeDataSets.Campo('indPres_B25b').Value     := Form7.ibDataSet15INDPRES.AsString;   // Indicador de presença do comprador no estabelecimento comercial.. Utilize: 0-Não, 1-Operação presencial, 2-Operação não presencial, Internet, 3-Operação Não presencial, teleatendimento, 9-Operação não presencial, outros.'.

  if (Form7.ibDataSet15INDPRES.AsString = '2') or (Form7.ibDataSet15INDPRES.AsString = '3') or (Form7.ibDataSet15INDPRES.AsString = '4') or (Form7.ibDataSet15INDPRES.AsString = '9') then
  begin
    if AllTrim(Form7.ibDataSet15MARKETPLACE.AsString) = '' then
    begin
      Form7.spdNFeDataSets.Campo('indIntermed_B25c').Value := '0';  // Indicador de intermediador/marketplace E B01 N 0-1 1 0=Operação sem intermediador (em site ou plataforma própria) 1=Operação em site ou plataforma de terceiros (intermediadores/marketplace)
    end else
    begin
      try
        Form1.ibDAtaset200.Close;
        Form1.ibDAtaset200.SelectSql.Clear;
        Form1.ibDAtaset200.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet15MARKETPLACE.AsString)+' ');  //
        Form1.ibDAtaset200.Open;

        if Form7.ibDataSet15MARKETPLACE.AsString = Form1.ibDAtaset200.FieldByname('NOME').AsString then
        begin
          Form7.spdNFeDataSets.Campo('indIntermed_B25c').Value  := '1';  // Indicador de intermediador/marketplace E B01 N 0-1 1 0=Operação sem intermediador (em site ou plataforma própria) 1=Operação em site ou plataforma de terceiros (intermediadores/marketplace)
          Form7.spdNFeDataSets.Campo('CNPJ_YB02').Value         := LimpaNumero(Form1.ibDAtaset200.FieldByname('CGC').AsString);  // CNPJ do Intermediador da Transação (agenciador, plataforma de delivery, marketplace e similar) de serviços e de negócios.

          if AllTrim(RetornaValorDaTagNoCampo('idCadIntTran',Form1.ibDAtaset200.FieldByname('OBS').AsString)) <> '' then
          begin
            Form7.spdNFeDataSets.Campo('idCadIntTran_YB03').Value := AllTrim(RetornaValorDaTagNoCampo('idCadIntTran',Form1.ibDAtaset200.FieldByname('OBS').AsString)); // Identificador cadastrado no intermediador
          end else
          begin
            Form7.spdNFeDataSets.Campo('idCadIntTran_YB03').Value := ConverteAcentos2(Form7.ibDataSet13.FieldByname('NOME').AsString); // Identificador cadastrado no intermediador
          end;
        end;
      except
        on E: Exception do
        begin
          {
          Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+'ao gravar MKP'
          ),'Atenção',mb_Ok + MB_ICONWARNING);
          Mauricio Parizotto 2023-10-25}
          MensagemSistema(E.Message+chr(10)+chr(10)+'ao gravar MKP',msgAtencao);
        end;
      end;
    end;
  end;

  // Complemento de ICMS
  if NFeFinalidadeComplemento(Form7.ibDataSet15FINNFE.AsString) then
  begin
    sChave                                      := Form1.Small_InputForm_ApenasNumeros('NFe', 'Chave de acesso da NF-e referenciada (ID da NF-e)', '', 44);

    try
      if sChave <> '' then
      begin
        Form7.spdNFeDataSets.IncluirPart('NREF');
        Form7.spdNFeDataSets.Campo('refNFe_BA02').Value := sChave;
        Form7.spdNFeDataSets.SalvarPart('NREF');
      end;
    except
      on E: Exception do
      begin
        {
        Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+'ao gravar NREF 2'
        ),'Atenção',mb_Ok + MB_ICONWARNING);
        Mauricio Parizotto 2023-10-25}
        MensagemSistema(E.Message+chr(10)+chr(10)+'ao gravar NREF 2',msgAtencao);
      end;
    end;
  end else
  begin
    // Sandro Silva 2023-05-18 if Form7.ibDataSet15FINNFE.AsString = '4' then
    if NFeFinalidadeDevolucao(Form7.ibDataSet15FINNFE.AsString) then
    begin
      sChave := '';

      if Pos('ID da NF-e referenciada:',Form7.ibDataSet15COMPLEMENTO.AsString) <> 0 then
      begin
        sChave := Copy(Form7.ibDataSet15COMPLEMENTO.AsString+Replicate(' ',30), Pos('ID da NF-e referenciada:',Form7.ibDataSet15COMPLEMENTO.AsString)+24,44);
      end;

      // Só pede se não está na obs
      if Length(LimpaNumero(sChave)) <> 44 then
      begin
        sChave                                      := Form1.Small_InputForm_ApenasNumeros('NFe', pChar('Chave de acesso da NF-e de devolução referenciada'+chr(10)+
                                                                                          '(ID da NF-e) ou Número do ECF (3) + COO (6) para'+chr(10)+
                                                                                          'cupom fiscal referenciado'), sChave, 44);
      end;

      try
        if Length(LimpaNumero(sChave))= 9 then
        begin
          Form7.spdNFeDataSets.IncluirPart('NREF');
          Form7.spdNFeDataSets.Campo('mod_BA21').Value    := '2D';
          Form7.spdNFeDataSets.Campo('nECF_BA22').Value   := Copy(LimpaNumero(sChave),1,3);
          Form7.spdNFeDataSets.Campo('nCOO_BA23').Value   := Copy(LimpaNumero(sChave),4,6);
          Form7.spdNFeDataSets.SalvarPart('NREF');
        end else
        begin
          if Length(LimpaNumero(sChave))= 44 then
          begin
            Form7.spdNFeDataSets.IncluirPart('NREF');
            Form7.spdNFeDataSets.Campo('refNFe_BA02').Value := sChave;
            Form7.spdNFeDataSets.SalvarPart('NREF');
          end else
          begin
            {
            ShowMessage('Informação inválida informe a'+chr(10)+
                        'Chave de acesso da NF-e de devolução referenciada'+chr(10)+
                        '(ID da NF-e) ou Número do ECF (3) + COO (6) para'+chr(10)+
                        'cupom fiscal referenciado');
            Mauricio Parizotto 2023-10-25}
            MensagemSistema('Informação inválida informe a'+chr(10)+
                            'Chave de acesso da NF-e de devolução referenciada'+chr(10)+
                            '(ID da NF-e) ou Número do ECF (3) + COO (6) para'+chr(10)+
                            'cupom fiscal referenciado'
                            ,msgAtencao);

            Abort;
          end;
        end;
      except
        on E: Exception do
        begin
          {
          Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+'ao gravar NREF 3'
          ),'Atenção',mb_Ok + MB_ICONWARNING);
          Mauricio Parizotto 2023-10-25}
          MensagemSistema(E.Message+chr(10)+chr(10)+'ao gravar NREF 3',msgAtencao);

          Abort;
        end;
      end;
    end;
  end;

  // Complemento de ICMS
  Form7.spdNFeDataSets.Campo('procEmi_B26').Value := '0'; // Identificador do Processo de emissão (0-Emissão da Nfe com Aplicativo do Contribuinte). Ver outras opções no manual da Receita.
  Form7.spdNFeDataSets.Campo('verProc_B27').Value := '001'; // Versão do Aplicativo Emissor

  // NFe com CPF
  if Length(LimpaNumero(Form7.ibDataSet13CGC.AsString)) = 11 then
  begin
    Form7.spdNFeDataSets.Campo('CPF_C02a').Value    := LimpaNumero(Form7.ibDataSet13.FieldByname('CGC').AsString); // CNPJ do Emitente
  end else
  begin
    Form7.spdNFeDataSets.Campo('CNPJ_C02').Value    := LimpaNumero(Form7.ibDataSet13.FieldByname('CGC').AsString); // CNPJ do Emitente
  end;

  Form7.spdNFeDataSets.Campo('xNome_C03').Value   := ConverteAcentosNome(Form7.ibDataSet13.FieldByname('NOME').AsString); // Razao Social ou Nome do Emitente
  Form7.spdNFeDataSets.Campo('xFant_C04').Value   := ConverteAcentosNome(Form7.ibDataSet13.FieldByname('NOME').AsString); ; // Nome Fantasia do Emitente

  Form7.spdNFeDataSets.Campo('xLgr_C06').Value    := ConverteAcentos2(ExtraiEnderecoSemONumero(Form7.ibDataSet13.FieldByname('ENDERECO').AsString)); // Logradouro do Emitente // Sandro Silva 2023-10-16 Form7.spdNFeDataSets.Campo('xLgr_C06').Value    := ConverteAcentos2(Endereco_Sem_Numero(Form7.ibDataSet13.FieldByname('ENDERECO').AsString)); // Logradouro do Emitente
  Form7.spdNFeDataSets.Campo('nro_C07').Value     := ExtraiNumeroSemOEndereco(Form7.ibDataSet13.FieldByname('ENDERECO').AsString); // Numero do Logradouro do Emitente // Sandro Silva 2023-10-16 Form7.spdNFeDataSets.Campo('nro_C07').Value     := Numero_Sem_Endereco(Form7.ibDataSet13.FieldByname('ENDERECO').AsString); // Numero do Logradouro do Emitente

  Form7.spdNFeDataSets.Campo('xBairro_C09').Value := ConverteAcentos2(Form7.ibDataSet13.FieldByname('COMPLE').AsString); // Bairro do Emitente

  Form7.spdNFeDataSets.Campo('cMun_C10').Value    := Copy(IBQUERY99.FieldByname('CODIGO').AsString,1,7); // Código da Cidade do Emitente (Tabela do IBGE)
  Form7.spdNFeDataSets.Campo('xMun_C11').Value    := ConverteAcentos2(IBQUERY99.FieldByname('NOME').AsString); // Nome da Cidade do Emitente

  Form7.spdNFeDataSets.Campo('UF_C12').Value      := IBQUERY99.FieldByname('UF').AsString; // Código do Estado do Emitente (Tabela do IBGE)
  Form7.spdNFeDataSets.Campo('CEP_C13').Value     := LimpaNumero(Form7.ibDataSet13.FieldByname('CEP').AsString); // Cep do Emitente

  if Alltrim(ConverteAcentos2(IBQUERY99.FieldByname('NOME').AsString))='' then
  begin
    Form7.ibDataSet15.Edit;
    Form7.ibDataSet15STATUS.AsString    := 'Erro: Verifique o CEP do emitente';
    Abort;
  end;

  Form7.spdNFeDataSets.Campo('cPais_C14').Value   := '1058'; // Código do País do Emitente (Tabela BACEN)
  Form7.spdNFeDataSets.Campo('xPais_C15').Value   := 'BRASIL'; // Nome do País do Emitente

  if Length(LimpaNumero(Form7.ibDataSet13.FieldByname('TELEFO').AsString)) = 11 then Form7.spdNFeDataSets.Campo('fone_C16').Value    := Copy(LimpaNumero(Form7.ibDataSet13.FieldByname('TELEFO').AsString),2,10) else Form7.spdNFeDataSets.Campo('fone_C16').Value    := LimpaNumero(Form7.ibDataSet13.FieldByname('TELEFO').AsString); // Fone do Emitente
  Form7.spdNFeDataSets.Campo('IE_C17').Value      := LimpaNumero(Form7.ibDataSet13.FieldByname('IE').AsString); // Inscrição Estadual do Emitente

  if LimpaNumero(Form7.ibDataSet13.FieldByname('IM').AsString) <> '' then
  begin
    Form7.spdNFeDataSets.Campo('IM_C19').Value      := StrTran(LimpaNumero(Form7.ibDataSet13.FieldByname('IM').AsString),'-',''); // Inscrição Estadual do Emitente

    if AllTrim(Form7.ibDataSet13.FieldByname('CNAE').AsString) <> '' then
    begin
      Form7.spdNFeDataSets.Campo('CNAE_C20').Value      := AllTrim(Form7.ibDataSet13.FieldByname('CNAE').AsString); // CNAE
    end else
    begin
      Form7.spdNFeDataSets.Campo('CNAE_C20').Value    := '0000000'; // CNAE
    end;
  end;

  if UpperCase(AllTrim(Form12.Label28.Caption)) = UpperCase('IE SUBSTITUTO') then
  begin
    Form7.spdNFeDataSets.Campo('IEST_C18').Value    := LimpaNumero(Form7.ibDataSet15IDENTIFICADOR1.AsString); // Inscrição Estadual do Substituto Tributário Emitente
  end;

  sDentroOuForadoEStado := Copy(Form7.ibDataSet14CFOP.AsString,1,1);

  // Informações do Destinatário da NFe
  if Form7.ibDAtaset2ESTADO.AsString <> 'EX' then
  begin
    IBQUERY99.Close;
    IBQUERY99.SQL.Clear;
    IBQUERY99.SQL.Add('select * from MUNICIPIOS where NOME='+QuotedStr(Form7.ibDAtaset2CIDADE.AsString)+' and UF='+QuotedStr(Form7.ibDAtaset2ESTADO.AsString)+' ');
    IBQUERY99.Open;

    if Alltrim(ConverteAcentos2(IBQUERY99.FieldByname('NOME').AsString))='' then
    begin
      Form7.ibDataSet15.Edit;
      Form7.ibDataSet15STATUS.AsString    := 'Erro: Verifique o município do destinatário';
      Abort;
    end;

    if Form7.spdNFe.Ambiente = spdNFeType.akHomologacao then
    begin
      Form7.spdNFeDataSets.Campo('xNome_E04').Value     := 'NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL'; // Razao social ou Nome do Destinatário
      Form7.spdNFeDataSets.Campo('CNPJ_E02').Value      := '99999999000191'; // CNPJ do Destinatário
      Form7.spdNFeDataSets.Campo('IE_E17').Value        := '';

      if (Form7.ibDAtaset2ESTADO.AsString ='AM') or
         (Form7.ibDAtaset2ESTADO.AsString ='BA') or
         (Form7.ibDAtaset2ESTADO.AsString ='CE') or
         (Form7.ibDAtaset2ESTADO.AsString ='GO') or
         (Form7.ibDAtaset2ESTADO.AsString ='MG') or
         (Form7.ibDAtaset2ESTADO.AsString ='MS') or
         (Form7.ibDAtaset2ESTADO.AsString ='MT') or
         (Form7.ibDAtaset2ESTADO.AsString ='PE') or
         (Form7.ibDAtaset2ESTADO.AsString ='RN') or
         (Form7.ibDAtaset2ESTADO.AsString ='SE') or
         (Form7.ibDAtaset2ESTADO.AsString ='SP') then
      begin
        Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value  := '9';    // 1-Contribuinte; 2-Isento; 9-Não contribuinte
      end else
      begin
        Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value  := '2';    // 1-Contribuinte; 2-Isento; 9-Não contribuinte
      end;
    end else
    begin
      if (Length(AllTrim(Form7.ibDAtaset2CGC.AsString)) = 18) then Form7.spdNFeDataSets.Campo('CNPJ_E02').Value := AllTrim(LimpaNumero(Form7.ibDAtaset2.FieldByname('CGC').AsString)); // CNPJ do Destinatário
      if (Length(AllTrim(Form7.ibDAtaset2CGC.AsString)) = 14) then Form7.spdNFeDataSets.Campo('CPF_E03').Value  := AllTrim(LimpaNumero(Form7.ibDAtaset2.FieldByname('CGC').AsString)); // CPF do Destinatário
      Form7.spdNFeDataSets.Campo('xNome_E04').Value   := ConverteAcentosNome(Form7.ibDAtaset2.FieldByname('NOME').AsString); // Razao social ou Nome do Destinatário
    end;

    Form7.spdNFeDataSets.Campo('xLgr_E06').Value    := ConverteAcentos2(ExtraiEnderecoSemONumero(Form7.ibDataset2.FieldByname('ENDERE').AsString)); // Logradouro do destinatario // Sandro Silva 2023-10-16 Form7.spdNFeDataSets.Campo('xLgr_E06').Value    := ConverteAcentos2(Endereco_Sem_Numero(Form7.ibDAtaset2.FieldByname('ENDERE').AsString)); // Logradouro do Emitente
    Form7.spdNFeDataSets.Campo('nro_E07').Value     := ExtraiNumeroSemOEndereco(Form7.ibDAtaset2.FieldByname('ENDERE').AsString); // Numero do Logradouro do Emitente // Sandro Silva 2023-10-16 Form7.spdNFeDataSets.Campo('nro_E07').Value     := Numero_Sem_Endereco(Form7.ibDAtaset2.FieldByname('ENDERE').AsString); // Numero do Logradouro do Emitente

    Form7.spdNFeDataSets.Campo('xBairro_E09').Value := ConverteAcentos2(Form7.ibDAtaset2.FieldByname('COMPLE').AsString); // Bairro do Destinatario
    Form7.spdNFeDataSets.Campo('cMun_E10').Value    := Copy(IBQUERY99.FieldByname('CODIGO').AsString,1,7); // Código do Município do Destinatário (Tabela IBGE)
    Form7.spdNFeDataSets.Campo('xMun_E11').Value    := ConverteAcentos2(IBQUERY99.FieldByname('NOME').AsString); //Nome da Cidade do Destinatário
    Form7.spdNFeDataSets.Campo('UF_E12').Value      := IBQUERY99.FieldByname('UF').AsString; // Sigla do Estado do Destinatário

    Form7.spdNFeDataSets.Campo('CEP_E13').Value     := LimpaNumero(Form7.ibDAtaset2.FieldByname('CEP').AsString); // Cep do Destinatário
    Form7.spdNFeDataSets.Campo('cPais_E14').Value   := '1058'; // Código do Pais do Destinatário (Tabela do BACEN)
    Form7.spdNFeDataSets.Campo('xPais_E15').Value   := 'BRASIL';// Nome do País do Destinatário
    if Length(LimpaNumero(Form7.ibDAtaset2.FieldByname('FONE').AsString)) = 11 then
      Form7.spdNFeDataSets.Campo('fone_E16').Value    := Copy(LimpaNumero(Form7.ibDAtaset2.FieldByname('FONE').AsString),2,10)
    else
      Form7.spdNFeDataSets.Campo('fone_E16').Value    := LimpaNumero(Form7.ibDAtaset2.FieldByname('FONE').AsString); // Fone do Destinatário

    if (Length(AllTrim(Form7.ibDAtaset2CGC.AsString)) = 0) then
    begin
      Form7.ibDataSet15.Edit;
      Form7.ibDataSet15STATUS.AsString    := 'Erro: CNPJ ou CPF do destinatário inválido';
      Abort;
    end;

    if (Length(AllTrim(Form7.ibDAtaset2CEP.AsString)) <> 9) then
    begin
      Form7.ibDataSet15.Edit;
      Form7.ibDataSet15STATUS.AsString    := 'Erro: CEP do destinatário inválido';
      Abort;
    end;

    if Limpanumero(Form7.ibDAtaset2FONE.AsString) <> '' then
    begin
      if Length(Limpanumero(Form7.ibDAtaset2FONE.AsString)) < 8 then
      begin
        Form7.ibDataSet15.Edit;
        Form7.ibDataSet15STATUS.AsString    := 'Erro: Telefone do destinatário inválido.';
        Abort;
      end;
    end;

    if Form7.spdNFe.Ambiente <> spdNFeType.akHomologacao then
    begin
      if Copy(Form7.ibDAtaset2.FieldByname('IE').AsString,1,2) = 'PR' then // Produtor Rural
      begin
        Form7.spdNFeDataSets.Campo('IE_E17').Value          := LimpaNumero(Form7.ibDAtaset2.FieldByname('IE').AsString); // Inscrição Estadual do Destinatário
        Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value  := '1';      // Contribuinte ICMS
        // Form7.spdNFeDataSets.Campo('IE_E17').Value          := ''; // Produtor rural
      end else
      begin
        if (Length(AllTrim(Form7.ibDAtaset2CGC.AsString)) = 18) then
        begin
          if allTrim(Form7.ibDAtaset2.FieldByname('IE').AsString) = '' then
          begin
            Form7.spdNFeDataSets.Campo('IE_E17').Value          := '';
            Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value  := '9';   // 1-Contribuinte; 2-Isento; 9-Não contribuinte
          end else
          begin
            if (not ConsisteInscricaoEstadual(LimpaNumero(Form7.ibDAtaset2IE.AsString),Form7.ibDAtaset2ESTADO.AsString)) then
            begin
              if Form7.ibDAtaset2.FieldByname('IE').AsString = 'ISENTO' then
              begin
                Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value  := '2';  // 1-Contribuinte; 2-Isento; 9-Não contribuinte
                Form7.spdNFeDataSets.Campo('IE_E17').Value          := '';
              end else
              begin
                Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value  := '1';  // 1-Contribuinte; 2-Isento; 9-Não contribuinte
                Form7.spdNFeDataSets.Campo('IE_E17').Value      := LimpaNumero(Form7.ibDAtaset2.FieldByname('IE').AsString); // Inscrição Estadual do Destinatário
              end;
            end else
            begin
              if Form7.ibDAtaset2.FieldByname('IE').AsString = 'ISENTO' then   // DLL IE NOVA
              begin
                Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value  := '2';  // 1-Contribuinte; 2-Isento; 9-Não contribuinte
                Form7.spdNFeDataSets.Campo('IE_E17').Value          := '';
              end else
              begin
                Form7.ibDataSet15.Edit;
                Form7.ibDataSet15STATUS.AsString    := 'Erro: Inscrição Estadual do Destinatário Inválida';
                Abort;
              end;
            end;
          end;
        end else
        begin
          // Form7.spdNFeDataSets.Campo('IE_E17').Value := 'ISENTO'; // Inscrição Estadual do Destinatário
          Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value  := '9';   // 1-Contribuinte; 2-Isento; 9-Não contribuinte
          Form7.spdNFeDataSets.Campo('IE_E17').Value          := '';

          // quando é CPF não deve mostrar o IE
        end;
      end;
    end;

    // Inscrição SUFRAMA Superintendência da Zona Franca de Manaus
    try
      if RetornaValorDaTagNoCampo('SUFRAMA', Form7.ibDAtaset2.FieldByname('OBS').AsString) <> '' then
      begin
        Form7.spdNFeDataSets.Campo('ISUF_E18').Value := RetornaValorDaTagNoCampo('SUFRAMA', Form7.ibDAtaset2.FieldByname('OBS').AsString);
      end;
    except
    end;
  end else
  begin
    // Consumidor estrangeiro
    try
      Form7.spdNFeDataSets.Campo('xLgr_E06').Value    := ConverteAcentos2(ExtraiEnderecoSemONumero(Form7.ibDAtaset2.FieldByname('ENDERE').AsString)); // Logradouro do Emitente // Sandro Silva 2023-10-16 Form7.spdNFeDataSets.Campo('xLgr_E06').Value    := ConverteAcentos2(Endereco_Sem_Numero(Form7.ibDAtaset2.FieldByname('ENDERE').AsString)); // Logradouro do Emitente
      Form7.spdNFeDataSets.Campo('nro_E07').Value     := ExtraiNumeroSemOEndereco(Form7.ibDAtaset2.FieldByname('ENDERE').AsString); // Numero do Logradouro do Emitente // Sandro Silva 2023-10-16 Form7.spdNFeDataSets.Campo('nro_E07').Value     := Numero_Sem_Endereco(Form7.ibDAtaset2.FieldByname('ENDERE').AsString); // Numero do Logradouro do Emitente

      Form7.spdNFeDataSets.Campo('xBairro_E09').Value := ConverteAcentos2(Form7.ibDAtaset2.FieldByname('COMPLE').AsString); // Bairro do Destinatario
      Form7.spdNFeDataSets.Campo('cMun_E10').Value    := '9999999';   // Código do Município do Destinatário (Tabela IBGE)
      Form7.spdNFeDataSets.Campo('xMun_E11').Value    := 'EXTERIOR'; //Nome da Cidade do Destinatário
      Form7.spdNFeDataSets.Campo('UF_E12').Value      := 'EX';      // Sigla do Estado do Destinatário

      Form7.spdNFeDataSets.Campo('CEP_E13').Value         := '00000000'; // Cep do Destinatário
      Form7.spdNFeDataSets.Campo('fone_E16').Value        := '';        // Fone do Destinatário
      Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value  := '9';      // Não Contribuinte

      if Form7.spdNFe.Ambiente = spdNFeType.akHomologacao then
      begin
        Form7.spdNFeDataSets.Campo('xNome_E04').Value   := 'NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL'; // Razao social ou Nome do Destinatário
      end else
      begin
        Form7.spdNFeDataSets.Campo('xNome_E04').Value   := ConverteAcentosNome(Form7.ibDAtaset2.FieldByname('NOME').AsString); // Razao social ou Nome do Destinatário
      end;

      if Copy(Form7.ibDataSet14CFOP.AsString,1,1) <> '7' then
      begin
        sPais    := Form1.Small_InputForm('NFe', 'País destino', 'Estados Unidos');
        sCodPais := Form1.Small_InputForm('NFe', 'Código do País destino', '2496');

        Form7.spdNFeDataSets.Campo('cPais_E14').Value            := sCodPais;       // Código do Pais do Destinatário (Tabela do BACEN)
        Form7.spdNFeDataSets.Campo('xPais_E15').Value            := sPais;    // Nome do País do Destinatário
        Form7.spdNFeDataSets.Campo('idEstrangeiro_E03a').Value   := Form1.Small_InputForm('Identificação de estrangeiro','Número do passaporte ou documento legal do comprador estrangeiro: ',''); // Identificacao do destinatario no caso de comprador estrangeiro
      end else
      begin
        // Exportacao Exportação
        try
          Form7.spdNFeDataSets.Campo('IE_E17').Value := '';
          Form7.spdNFeDataSets.Campo('CNPJ_E02').Value := '';

          sPais    := 'Estados Unidos';
          sCodPais := '2496';

          Form29.Label_01.Visible := True;
          Form29.Label_02.Visible := True;
          Form29.Label_03.Visible := True;
          Form29.Label_04.Visible := True;
          Form29.Label_05.Visible := True;
          Form29.Label_06.Visible := True;

          Form29.Edit_01.Visible := True;
          Form29.Edit_02.Visible := True;
          Form29.Edit_03.Visible := True;
          Form29.Edit_04.Visible := True;
          Form29.Edit_05.Visible := True;
          Form29.Edit_06.Visible := True;

          Form29.Label_01.Caption := 'País destino:';
          Form29.Label_02.Caption := 'Código do País destino:';
          Form29.Label_03.Caption := 'Identificação do destinatário no caso de comprador estrangeiro:';
          Form29.Label_04.Caption := 'UF de embarque:';
          Form29.Label_05.Caption := 'Local de embarque:';
          Form29.Label_06.Caption := 'Descrição do Recinto Alfandegado'+chr(10)+
                                     'onde foi efetivado o despacho'+chr(10)+
                                     'conforme padronização da RFB:';

          Form29.Edit_01.Text := sPais;
          Form29.Edit_02.Text := sCodPais;
          Form29.Edit_03.Text := '';
          Form29.Edit_04.Text := UpperCase(Form7.ibDataSet13ESTADO.AsString);
          Form29.Edit_05.Text := '';
          Form29.Edit_06.Text := '';

          Form1.Small_InputForm_Dados('Exportação');

          sPais            := Form29.Edit_01.Text;
          sCodPais         := Form29.Edit_02.Text;
          sEx15            := Form29.Edit_03.Text;
          sUFEmbarq        := Form29.Edit_04.Text;
          sLocaldeEmbarque := Form29.Edit_05.Text;
          sLocalDespacho   := Form29.Edit_06.Text;
{
          sPais    := Form1.Small_InputForm('NFe', 'País destino', 'Estados Unidos');
          sCodPais := Form1.Small_InputForm('NFe', 'Código do País destino', '2496');
          sEx15  := Form1.Small_InputForm('NF-e importação', 'Identificação do destinatário no caso de comprador estrangeiro:',sEx15);
}
          Form7.spdNFeDataSets.Campo('cPais_E14').Value       := sCodPais;  // Código do Pais do Destinatário (Tabela do BACEN)
          Form7.spdNFeDataSets.Campo('xPais_E15').Value       := sPais;    // Nome do País do Destinatário

          Form7.spdNFeDataSets.Campo('UFSaidaPais_ZA02').Value   := sUFEmbarq;     // Estado do embarque = Estado do Emitente
          Form7.spdNFeDataSets.Campo('xLocExporta_ZA03').Value   := sLocaldeEmbarque;                  // Local do embarque
          Form7.spdNFeDataSets.Campo('xLocDespacho_ZA04').Value  := sLocalDespacho;                  // Local do Despacho
          Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value  := '9';  // 1-Contribuinte; 2-Isento; 9-Não contribuinte

          if AllTrim(sEx15) = '' then
          begin
            Form7.spdNFeDataSets.Campo('idEstrangeiro_E03a').GeraTagVazia   := True;     // Indentificação do destinaário no caso de comprador estrangeiro
          end else
          begin
            Form7.spdNFeDataSets.Campo('idEstrangeiro_E03a').Value  := sEx15;      // Indentificação do destinaário no caso de comprador estrangeiro
          end;
        except
          on E: Exception do
          begin
            {
            Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+ 'Ao preencher Identificação do destinatário no caso de comprador estrangeiro'
            ),'Atenção',mb_Ok + MB_ICONWARNING);
            Mauricio Parizotto 2023-10-25}
            MensagemSistema(E.Message+chr(10)+chr(10)+ 'Ao preencher Identificação do destinatário no caso de comprador estrangeiro',msgErro);
          end;
        end;
      end;
    except
      on E: Exception do
      begin
        //Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+'Ao preencher dados para exportação'),'Atenção',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
        MensagemSistema(E.Message+chr(10)+chr(10)+'Ao preencher dados para exportação',msgErro);
      end;
    end;
  end;

  // Calcular o desconto do Item
  vDESCONTO := 0;
  vFRETE    := 0;
  vSEGURO   := 0;
  vOUTRAS   := 0;

  for I := 1 to 999 do
  begin
    fOutras[I]   := 0;
    fFrete[I]    := 0;
    fseguro[I]   := 0;
    fDesconto[I] := 0;
  end;

  dvICMSMonoRet_N45Total := 0.00; // Sandro Silva 2023-06-07
  dqBCMonoRet_N43aTotal  := 0.00; // Sandro Silva 2023-09-04
  sMensagemIcmMonofasicoSobreCombustiveis := ''; // Sandro Silva 2023-06-16

  I := 0;
  //
  if Form7.ibDataSet15.FieldByname('MERCADORIA').AsFloat <> 0 then
  begin
    Form7.ibDataSet16.First;
    while not Form7.ibDataSet16.Eof do
    begin
      Form7.ibDataSet4.Close;
      Form7.ibDataSet4.Selectsql.Clear;
      Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet16CODIGO.AsString)); 
      Form7.ibDataSet4.Open;

      if (Alltrim(Form7.ibDataSet4DESCRICAO.AsString) = Alltrim(Form7.ibDataSet16DESCRICAO.AsString)) and (Alltrim(Form7.ibDataSet4DESCRICAO.AsString) <> '') then
      begin
        I := I + 1;
        begin
          fOutras[I]   := Arredonda((Form7.ibDataSet15.FieldByname('DESPESAS').AsFloat / Form7.ibDataSet15.FieldByname('MERCADORIA').AsFloat * Form7.ibDataSet16.FieldByname('TOTAL').AsFloat),2);
        end;

        fFrete[I]    := Arredonda((Form7.ibDataSet15.FieldByname('FRETE').AsFloat / Form7.ibDataSet15.FieldByname('MERCADORIA').AsFloat * Form7.ibDataSet16.FieldByname('TOTAL').AsFloat),2);
        fSeguro[I]   := Arredonda((Form7.ibDataSet15.FieldByname('SEGURO').AsFloat / Form7.ibDataSet15.FieldByname('MERCADORIA').AsFloat * Form7.ibDataSet16.FieldByname('TOTAL').AsFloat),2);
        fDesconto[I] := Arredonda((Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat / Form7.ibDataSet15.FieldByname('MERCADORIA').AsFloat * Form7.ibDataSet16.FieldByname('TOTAL').AsFloat),2);

        vFRETE       := vFRETE + fFrete[I];
        vSEGURO      := vSEGURO + fSeguro[I];
        vOUTRAS      := vOUTRAS + fOutras[I];
        vDESCONTO    := vDESCONTO + fDesconto[I];
      end;

      Form7.ibDataSet16.Next;
    end;
  end;

  vDESCONTO      := (Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat - vDESCONTO);
  vSEGURO        := (Form7.ibDataSet15.FieldByname('SEGURO').AsFloat - vSEGURO);
  vFRETE         := (Form7.ibDataSet15.FieldByname('FRETE').AsFloat - vFRETE);
  vOUTRAS        := (Form7.ibDataSet15.FieldByname('DESPESAS').AsFloat - vOUTRAS);

  for I := 1 to 999 do
  begin
    // DIFERENCA DE CENTAVOS DO DESCONTO
    if vDESCONTO <> 0 then
    begin
      if fDesconto[I] = Math.MaxValue( fDesconto ) then
      begin
        fDesconto[I] := fDesconto[I] + vDESCONTO;
        vDESCONTO := 0;
      end;
    end;

    // DIFERENCA DE CENTAVOS DO FRETE
    if vFRETE <> 0 then
    begin
      if fFRETE[I] = Math.MaxValue( fFRETE ) then
      begin
        fFRETE[I] := fFRETE[I] + vFRETE;
        vFRETE := 0;
      end;
    end;

    // DIFERENCA DE CENTAVOS DO SEGURO
    if vSEGURO <> 0 then
    begin
      if fSEGURO[I] = Math.MaxValue( fSEGURO ) then
      begin
        fSEGURO[I] := fSEGURO[I] + vSEGURO;
        vSEGURO := 0;
      end;
    end;

    // DIFERENCA DE CENTAVOS DO OUTRAS
    if vOUTRAS <> 0 then
    begin
      if fOUTRAS[I] = Math.MaxValue( fOUTRAS ) then
      begin
        fOUTRAS[I] := fOUTRAS[I] + vOUTRAS;
        vOUTRAS := 0;
      end;
    end;
  end;

  vIVA60_B_ICMST := 0;
  vIVA60_V_ICMST := 0;
  vPIS           := 0;
  vPIS_S         := 0;
  vCOFINS        := 0;
  vCOFINS_S      := 0;
  vBCST          := 0;
  vST            := 0;
  vBC            := 0;
  VICMS          := 0;
  I              := 0;
  fFCPUFDest     := 0;
  fICMSUFDest    := 0;
  fICMSUFREmet   := 0;
  fFCPST         := 0;
  fFCP           := 0;
  fIPIDevolvido  := 0;
  vICMSDeson     := 0;

  sComplemento := '';
  sCupomReferenciado := '';

  // Itens da nota de SAIDA
  Form7.ibDataSet16.First;
  while not Form7.ibDataSet16.Eof do
  begin
    //fPercentualFCP := 0;
    fSomaNaBase    := 0;

    Form7.ibDataSet4.Close;
    Form7.ibDataSet4.Selectsql.Clear;
    Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet16CODIGO.AsString));
    Form7.ibDataSet4.Open;

    if (Alltrim(Form7.ibDataSet4DESCRICAO.AsString) = Alltrim(Form7.ibDataSet16DESCRICAO.AsString)) and (Alltrim(Form7.ibDataSet4DESCRICAO.AsString) <> '') then
    begin
      I := I + 1;

      try
        if Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value = '9' then Form7.spdNFeDataSets.Campo('IE_E17').Value          := '';
        if Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value = '2' then Form7.spdNFeDataSets.Campo('IE_E17').Value          := '';
        Form7.spdNFeDataSets.SalvarItem;
      except
        on E: Exception do
        begin
          MensagemSistema(E.Message+chr(10)+chr(10)+'Ao salvar item código: '+Form7.spdNFeDataSets.Campo('cProd_I02').Value+chr(10)+Form7.spdNFeDataSets.Campo('xProd_I04').Value+chr(10)+
                          chr(10)+'Leia atentamente a mensagem acima e tente resolver o problema. Considere pedir ajuda ao seu contador para o preenchimento correto da NF-e.'
                          ,msgAtencao);
        end;
      end;

      Form7.spdNFeDataSets.IncluirItem;

      // Informações Referentes aos ITens da NFe
      Form7.spdNFeDataSets.Campo('nItem_H02').Value := IntToStr(I); // Número do Item da NFe (1 até 990)

      // Dados do Produto Vendido
      if (RetornaValorDaTagNoCampo('cProd', Form7.ibDataSet4.FieldByname('TAGS_').AsString) <> '') then //
        Form7.spdNFeDataSets.Campo('cProd_I02').Value    := Copy(RetornaValorDaTagNoCampo('cProd', Form7.ibDataSet4.FieldByname('TAGS_').AsString), 1, 60)
      else
        if Form7._ecf65_ValidaGtinNFCe(Form7.ibDataSet4.FieldByname('REFERENCIA').AsString) then
          Form7.spdNFeDataSets.Campo('cProd_I02').Value    := Form7.ibDataSet4.FieldByname('CODIGO').AsString //Código do PRoduto ou Serviço
        else
          //Form7.spdNFeDataSets.Campo('cProd_I02').Value   := LimpaNumero(Form7.ibDataSet4.FieldByname('REFERENCIA').AsString); // Código de BARRAS
          if Length(Alltrim(LimpaNumero(Form7.ibDataSet4.FieldByname('REFERENCIA').AsString))) < 6 then
            Form7.spdNFeDataSets.Campo('cProd_I02').Value    := Form7.ibDataSet4.FieldByname('CODIGO').AsString //Código do PRoduto ou Serviço
          else
            Form7.spdNFeDataSets.Campo('cProd_I02').Value   := LimpaNumero(Form7.ibDataSet4.FieldByname('REFERENCIA').AsString); // Código de BARRAS

      // EAN do Produto
      Form7.spdNFeDataSets.Campo('cEAN_I03').Value := 'SEM GTIN'; // EAN do Produto
      if (RetornaValorDaTagNoCampo('cEAN', Form7.ibDataSet4.FieldByname('TAGS_').AsString) <> '') then
        Form7.spdNFeDataSets.Campo('cEAN_I03').Value := RetornaValorDaTagNoCampo('cEAN', Form7.ibDataSet4.FieldByname('TAGS_').AsString)
      else
      begin
        if Form7._ecf65_ValidaGtinNFCe(Form7.ibDataSet4.FieldByname('REFERENCIA').AsString) then
          Form7.spdNFeDataSets.Campo('cEAN_I03').Value := LimpaNumero(Form7.ibDataSet4.FieldByname('REFERENCIA').AsString); // EAN do Produto
      end;

      Form7.spdNFeDataSets.Campo('xProd_I04').Value    := Alltrim(ConverteAcentos2(Form7.ibDataSet4.FieldByname('DESCRICAO').AsString));// Descrição do PRoduto

      // NCM
      if Length(Alltrim(LimpaNumero(Form7.ibDataSet4.FieldByname('CF').AsString))) = 8 then
      begin
        Form7.spdNFeDataSets.Campo('NCM_I05').Value      := Alltrim(LimpaNumero(Form7.ibDataSet4.FieldByname('CF').AsString)); // Código do NCM - informar de acordo com o Tabela oficial do NCM

        fICMSDesonerado := 0;

        //cBenef
        {Mauricio Parizotto 2023-12-12 Inicio}
        cBenefItem := '';
        if cBenef = '' then
        begin
          //Verifica CIT
          if trim(Form7.ibDataSet4ST.AsString) <> '' then
          begin
            cBenefItem := ExecutaComandoEscalar(Form7.ibDataSet4.Transaction,
                                                ' Select CBENEF'+
                                                ' From ICM'+
                                                ' Where ST = '+QuotedStr(Form7.ibDataSet4ST.AsString));
          end;

          //Se não tiver valor na operação e nem CIT, tenta pegar do produto
          if cBenefItem = '' then
            cBenefItem := RetornaValorDaTagNoCampo('cBenef',Form7.ibDataSet4.FieldByname('TAGS_').AsString);
        end else
        begin
          cBenefItem := cBenef;
        end;
        {Mauricio Parizotto 2023-12-12 Fim}

        //if (Form7.ibDataSet13.FieldByname('CRT').AsString <> '1') then Mauricio Parizotto 2023-11-03 ficha 7553
        begin
          //if (RetornaValorDaTagNoCampo('cBenef',Form7.ibDataSet4.FieldByname('TAGS_').AsString)<>'') and (RetornaValorDaTagNoCampo('cBenef',Form7.ibDataSet4.FieldByname('TAGS_').AsString)<>'0000000000') then Mauricio Parizotto 2023-12-12
          if (cBenefItem<>'') and (cBenefItem<>'0000000000') then
          begin
            //Form7.spdNFeDataSets.Campo('cBenef_I05f').Value     := RetornaValorDaTagNoCampo('cBenef',Form7.ibDataSet4.FieldByname('TAGS_').AsString);      // Código de Benefício Fiscal na UF aplicado ao item Mauricio Parizotto 2023-12-12
            Form7.spdNFeDataSets.Campo('cBenef_I05f').Value     := cBenefItem;

            if AllTrim(RetornaValorDaTagNoCampo('motDesICMS',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
            begin
              Form7.spdNFeDataSets.Campo('motDesICMS_N28').Value  := RetornaValorDaTagNoCampo('motDesICMS',Form7.ibDataSet4.FieldByname('TAGS_').AsString);  // Motivo da desoneração do ICMS

              if (Form7.ibDataSet16BASE.Asfloat <> 100) and (Form7.ibDataSet16BASE.Asfloat <> 0) then
              begin
                Form7.IBQuery14.Close;
                Form7.IBQuery14.SQL.Clear;
                Form7.IBQuery14.SQL.Add('select * from ICM where NOME='+QuotedStr(Form7.ibDataSet15OPERACAO.AsString)+' ');
                Form7.IBQuery14.Open;

                fAliquotaPadrao := (Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat)/100;
                fPercentualDeReducaoDeBC := (100 - Form7.ibDataSet16.FieldByname('BASE').AsFloat)/100;

                fICMSDesonerado := Form7.ibDataSet16.FieldByname('TOTAL').AsFloat * ( 1 - ( fAliquotaPadrao * ( 1 - fPercentualDeReducaoDeBC))) / ( 1 - fAliquotaPadrao) - Form7.ibDataSet16.FieldByname('TOTAL').AsFloat;
              end else
              begin
                if AllTrim(Form7.ibDataSet4ST.Value) <> '' then       // Quando alterar esta rotina alterar também retributa Ok 1/ Abril
                begin
                  // Nova rotina para posicionar na tabéla de CFOP
                  Form7.IBQuery14.Close;
                  Form7.IBQuery14.SQL.Clear;
                  Form7.IBQuery14.SQL.Add('select * from ICM where ST='+QuotedStr(Form7.ibDataSet4ST.AsString)+''); // Nova rotina
                  Form7.IBQuery14.Open;

                  if Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat = 0 then
                  begin
                    Form7.IBQuery14.Close;
                    Form7.IBQuery14.SQL.Clear;
                    Form7.IBQuery14.SQL.Add('select * from ICM where NOME='+QuotedStr(Form7.ibDataSet15OPERACAO.AsString)+' ');
                    Form7.IBQuery14.Open;

                    fAliquotaPadrao := (Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat)/100;

                    fICMSDesonerado := Form7.ibDataSet16.FieldByname('TOTAL').AsFloat / (1 - fAliquotaPadrao)* fAliquotaPadrao;
                  end;

                  Form7.IBQuery14.Close;
                  Form7.IBQuery14.SQL.Clear;
                  Form7.IBQuery14.SQL.Add('select * from ICM where ST='+QuotedStr(Form7.ibDataSet4ST.AsString)+''); // Nova rotina
                  Form7.IBQuery14.Open;
                end;
              end;

              Form7.spdNFeDataSets.Campo('vICMSDeson_N28a').Value := FormatFloatXML(fICMSDesonerado);  // Valor do ICMS desonerado
              //
              vICMSDeson := vICMSDeson + StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vICMSDeson_N28a').AsString,',',''),'.',','));
            end;
          end;
        end;
      end else
      begin
        // Serviço
        Form7.spdNFeDataSets.Campo('NCM_I05').Value      := '00'; // Código do NCM - informar de acordo com o Tabela oficial do NCM
      end;

      Form7.spdNFeDataSets.Campo('CFOP_I08').Value     := Alltrim(Form7.ibDataSet16.FieldByname('CFOP').AsString); // CFOP incidente neste Item da NF
      if Alltrim(ConverteAcentos2(Form7.ibDataSet4.FieldByname('MEDIDA').AsString)) <> '' then
        Form7.spdNFeDataSets.Campo('uCom_I09').Value     := ConverteAcentos2(Form7.ibDataSet4.FieldByname('MEDIDA').AsString) // Unidade de Medida do Item
      else
        Form7.spdNFeDataSets.Campo('uCom_I09').Value     := 'UND';

      Form7.spdNFeDataSets.Campo('qCom_I10').Value     := StrTran(Form7.ibDataSet16.FieldByname('QUANTIDADE').AsString,',','.'); // Quantidade Comercializada do Item
      Form7.spdNFeDataSets.Campo('vUnCom_I10a').Value  := StrTran(Alltrim(FormatFloat('##0.'+Replicate('0',StrToInt(Form1.ConfPreco)),Form7.ibDataSet16.FieldByname('UNITARIO').AsFloat)),',','.'); // Valor Comercializado do Item
      Form7.spdNFeDataSets.Campo('vProd_I11').Value    := FormatFloatXML(Form7.ibDataSet16.FieldByname('TOTAL').AsFloat); // Valor Total Bruto do Item

      if AllTrim(Form7.ibDataSet4CEST.AsString) <> '' then
      begin
        Form7.spdNFeDataSets.Campo('CEST_I05c').Value    := Form7.ibDataSet4CEST.AsString; // Código CEST
      end;

      // B2B
      if (Copy(Form7.ibDataSet16XPED.AsString,1,2) <> 'CF') then
      begin
        if AllTrim(Form7.ibDataSet16XPED.AsString)     <> '' then
          Form7.spdNFeDataSets.Campo('xPed_I60').AsString       := AllTrim(Form7.ibDataSet16XPED.AsString);
        if AllTrim(Form7.ibDataSet16NITEMPED.AsString) <> '' then
          Form7.spdNFeDataSets.Campo('nItemPed_I61').AsString   := AllTrim(Form7.ibDataSet16NITEMPED.AsString);
      end;

      // Tributos
      if bTributa then
      begin
        if Copy(Form7.ibDataSet14CFOP.AsString,1,1) <> '7' then // Exportação
        begin
//                    if Form7.ibDAtaset2ESTADO.AsString <> 'EX' then
          if  (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-(fDesconto[I]*Form7.ibDataSet4.FieldByname('IIA').AsFloat/100)) > 0  then
          begin
            //
            Form7.spdNFeDataSets.Campo('vTotTrib_M02').Value  :=  StrTran(Alltrim(FormatFloat('##0.00',
            Arredonda(((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-(fDesconto[I]))*Form7.ibDataSet4.FieldByname('IIA').AsFloat/100),2) +    // Federais
            Arredonda(((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-(fDesconto[I]))*Form7.ibDataSet4.FieldByname('IIA_UF').AsFloat/100),2) + // Estaduais
            Arredonda(((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-(fDesconto[I]))*Form7.ibDataSet4.FieldByname('IIA_MUNI').AsFloat/100),2) // Municipais
            )),',','.'); // Valor aproximado total de tributos

            // Federais
            fTotaldeTriubutos := fTotaldeTriubutos +
            Arredonda(((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-(fDesconto[I]))*Form7.ibDataSet4.FieldByname('IIA').AsFloat/100),2);

            // Estaduais
            fTotaldeTriubutos_uf := fTotaldeTriubutos_uf +
            Arredonda(((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-(fDesconto[I]))*Form7.ibDataSet4.FieldByname('IIA_UF').AsFloat/100),2);

            // Municipais
            fTotaldeTriubutos_muni := fTotaldeTriubutos_muni +
            Arredonda(((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-(fDesconto[I]))*Form7.ibDataSet4.FieldByname('IIA_MUNI').AsFloat/100),2);
          end;
        end
      end;

      try
        if Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat <> 0 then
          fRateioDoDesconto  := Arredonda((Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat / Form7.ibDataSet15.FieldByname('MERCADORIA').AsFloat * Form7.ibDataSet16.FieldByname('TOTAL').AsFloat),2)
        else fRateioDoDesconto := 0; // REGRA DE TRÊS ratiando o desconto no total
      except
        fRateioDoDesconto := 0;
      end;

      // Campo obrigatório
      if (Pos(Alltrim(Form7.ibDataSet16.FieldByname('CFOP').AsString),Form1.CFOP5124) = 0) then  // 5104 Industrialização efetuada para outra empresa não soma na base
      begin
        if Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat <> 0 then
          if (fDesconto[I]) > 0.01 then
            Form7.spdNFeDataSets.Campo('vDesc_I17').Value    := FormatFloatXML(fDesconto[I]); // REGRA DE TRÊS ratiando o valor do frete Valor Total do Desconto
        begin
          if Form7.ibDataSet15.FieldByname('DESPESAS').AsFloat <> 0 then if (fOutras[I])   > 0.01 then
            Form7.spdNFeDataSets.Campo('vOutro_I17a').Value  := FormatFloatXML(fOutras[I]); // REGRA DE TRÊS ratiando o valor de outras
        end;

        if Form7.ibDataSet15.FieldByname('FRETE').AsFloat    <> 0 then if (fFrete[I])    > 0.01 then
          Form7.spdNFeDataSets.Campo('vFrete_I15').Value   := FormatFloatXML(fFrete[I]);   // REGRA DE TRÊS ratiando o valor do frete Valor Total do Frete

        if Form7.ibDataSet15.FieldByname('SEGURO').AsFloat   <> 0 then if (fseguro[I])   > 0.01 then
          Form7.spdNFeDataSets.Campo('vSeg_I16').Value     := FormatFloatXML(fSeguro[I]); // REGRA DE TRÊS ratiando o valor do frete Valor Total do Seguro

        if Form7.ibDataSet15.FieldByname('FRETE').AsFloat    <> 0 then if (fFrete[I])    > 0.01 then
          fSomaNaBase  := fSomanaBase + (fFrete[I]);    // REGRA DE TRÊS ratiando o valor Total do Frete

        if Form7.ibDataSet15.FieldByname('SEGURO').AsFloat   <> 0 then if (fSeguro[I])   > 0.01 then
          fSomaNaBase  := fSomanaBase + (fSeguro[I]);   // REGRA DE TRÊS ratiando valor do Seguro

        if (Form7.ibDataSet14SOBREOUTRAS.AsString = 'S') then
        begin
          if Form7.ibDataSet15.FieldByname('DESPESAS').AsFloat <> 0 then if (fOutras[I])   > 0.01 then
            fSomaNaBAse  := fSomanaBase + (fOutras[I]);   // REGRA DE TRÊS ratiando o valor de outras
        end;

        if Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat <> 0 then if (fDesconto[I]) > 0.01 then
          fSomaNaBase  := fSomanaBase - (fDesconto[I]); // REGRA DE TRÊS ratiando o valor do frete descontando
      end else
      begin
        fSomaNaBase := 0;
      end;

      if vIPISobreICMS then
      begin
        // ICM Sobre o IPI
        fSomaNaBase := fSomaNaBase + Form7.ibDataSet16.FieldByname('IPI').AsFloat * Form7.ibDataSet16.FieldByname('TOTAL').AsFloat / 100;  // Soma o valor do IPI na base
      end;

      if (Pos(Alltrim(Form7.ibDataSet16.FieldByname('CFOP').AsString),Form1.CFOP5124) = 0) then// 5104 Industrialização efetuada para outra empresa não soma na base
      begin
        Form7.spdNFeDataSets.Campo('indTot_I17b').Value   := '1'; // 0 - O valor do Item NÃO compõe o valor total da nota 1 - O valor do Item compõe o valor total da nota
      end else
      begin
        Form7.spdNFeDataSets.Campo('indTot_I17b').Value   := '0'; // 0 - O valor do Item NÃO compõe o valor total da nota 1 - O valor do Item compõe o valor total da nota
      end;

      // EAN do Produto
      Form7.spdNFeDataSets.Campo('cEANTrib_I12').Value := 'SEM GTIN';
      if (RetornaValorDaTagNoCampo('cEANTrib', Form7.ibDataSet4.FieldByname('TAGS_').AsString) <> '') then
        Form7.spdNFeDataSets.Campo('cEANTrib_I12').Value := RetornaValorDaTagNoCampo('cEANTrib', Form7.ibDataSet4.FieldByname('TAGS_').AsString)
      else
      begin
        if (RetornaValorDaTagNoCampo('cEAN', Form7.ibDataSet4.FieldByname('TAGS_').AsString) <> '') then
          Form7.spdNFeDataSets.Campo('cEANTrib_I12').Value := RetornaValorDaTagNoCampo('cEAN', Form7.ibDataSet4.FieldByname('TAGS_').AsString)
        else
        begin
          if Form7._ecf65_ValidaGtinNFCe(Form7.ibDataSet4.FieldByname('REFERENCIA').AsString) then
            Form7.spdNFeDataSets.Campo('cEANTrib_I12').Value := LimpaNumero(Form7.ibDataSet4.FieldByname('REFERENCIA').AsString);
        end;
      end;

      // Quantidade tributável
      if RetornaValorDaTagNoCampo('uTrib',Form7.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then
      begin
        Form7.spdNFeDataSets.Campo('uTrib_I13').Value    := RetornaValorDaTagNoCampo('uTrib',Form7.ibDataSet4.FieldByname('TAGS_').AsString);

        if LimpaNumero(RetornaValorDaTagNoCampo('qTrib',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
        begin
          Form7.spdNFeDataSets.Campo('qTrib_I14').Value    := FormatFloatXML(Form7.ibDataSet16.FieldByname('QUANTIDADE').AsFloat * StrToFloat( RetornaValorDaTagNoCampo('qTrib',Form7.ibDataSet4.FieldByname('TAGS_').AsString)), 4);  // Quantidade Tributável do Item
          Form7.spdNFeDataSets.Campo('vUnTrib_I14a').Value := FormatFloatXML(Form7.ibDataSet16.FieldByname('TOTAL').AsFloat / StrToFloat(StrTran(Form7.spdNFeDataSets.Campo('qTrib_I14').AsString,'.',',')),10); // Valor Tributável do Item
        end else
        begin
          Form7.spdNFeDataSets.Campo('qTrib_I14').Value    := StrTran(Form7.ibDataSet16.FieldByname('QUANTIDADE').AsString,',','.');  // Quantidade Tributável do Item
          Form7.spdNFeDataSets.Campo('vUnTrib_I14a').Value := StrTran(Alltrim(FormatFloat('##0.'+Replicate('0',StrToInt(Form1.ConfPreco)),Form7.ibDataSet16.FieldByname('UNITARIO').AsFloat)),',','.'); // Valor Tributável do Item
        end;
      end else
      begin
        if Alltrim(ConverteAcentos2(Form7.ibDataSet4.FieldByname('MEDIDA').AsString)) <> '' then
          Form7.spdNFeDataSets.Campo('uTrib_I13').Value    := ConverteAcentos2(Form7.ibDataSet4.FieldByname('MEDIDA').AsString)
        else
          Form7.spdNFeDataSets.Campo('uTrib_I13').Value    := 'UND'; // Unidade de Medida Tributável do Item

        Form7.spdNFeDataSets.Campo('qTrib_I14').Value    := StrTran(Form7.ibDataSet16.FieldByname('QUANTIDADE').AsString,',','.');  // Quantidade Tributável do Item
        Form7.spdNFeDataSets.Campo('vUnTrib_I14a').Value := StrTran(Alltrim(FormatFloat('##0.'+Replicate('0',StrToInt(Form1.ConfPreco)),Form7.ibDataSet16.FieldByname('UNITARIO').AsFloat)),',','.'); // Valor Tributável do Item
      end;

      // FCI
      if AllTrim(Form7.ibDataSet4CODIGO_FCI.AsString) <> '' then
      begin
        Form7.spdNFeDataSets.Campo('nFCI_I70').Value := Form7.ibDataSet4CODIGO_FCI.AsString; // Número de controle da FCI - Ficha de Conteúdo de Importação
        // Informação relacionada com a Resolução 13/2012 do
        // Senado Federal. Formato: Algarismos, letras maiúsculas
        // de "A" a "F" e o caractere hífen. Exemplo:
        // B01F70AF-10BF-4B1F-848C-65FF57F616FE
      end;

      // JA. Detalhamento Específico de Veículos Novos
      if RetornaValorDaTagNoCampo('tpOp',Form7.ibDataSet4.FieldByname('TAGS_').AsString)<> '' then
      begin
        // Pegar estes dados nas tags do produto
        stpOp_VeiculosNovos     := RetornaValorDaTagNoCampo('tpOp',Form7.ibDataSet4.FieldByname('TAGS_').AsString);
        spot_VeiculosNovos      := RetornaValorDaTagNoCampo('pot',Form7.ibDataSet4.FieldByname('TAGS_').AsString);
        scilin_VeiculosNovos    := RetornaValorDaTagNoCampo('cilin',Form7.ibDataSet4.FieldByname('TAGS_').AsString);
        spesoL_VeiculosNovos    := RetornaValorDaTagNoCampo('pesoL',Form7.ibDataSet4.FieldByname('TAGS_').AsString);
        spesoB_VeiculosNovos    := RetornaValorDaTagNoCampo('pesoB',Form7.ibDataSet4.FieldByname('TAGS_').AsString);
        stpComb_VeiculosNovos   := RetornaValorDaTagNoCampo('tpComb',Form7.ibDataSet4.FieldByname('TAGS_').AsString);
        sCMT_VeiculosNovos      := RetornaValorDaTagNoCampo('CMT',Form7.ibDataSet4.FieldByname('TAGS_').AsString);
        sdist_VeiculosNovos     := RetornaValorDaTagNoCampo('dist',Form7.ibDataSet4.FieldByname('TAGS_').AsString);
        sanoMod_VeiculosNovos   := RetornaValorDaTagNoCampo('anoMod',Form7.ibDataSet4.FieldByname('TAGS_').AsString);
        sanoFab_VeiculosNovos   := RetornaValorDaTagNoCampo('anoFab',Form7.ibDataSet4.FieldByname('TAGS_').AsString);
        stpPint_VeiculosNovos   := RetornaValorDaTagNoCampo('tpPint',Form7.ibDataSet4.FieldByname('TAGS_').AsString);
        stpVeic_VeiculosNovos   := RetornaValorDaTagNoCampo('tpVeic',Form7.ibDataSet4.FieldByname('TAGS_').AsString);
        sespVeic_VeiculosNovos  := RetornaValorDaTagNoCampo('espVeic',Form7.ibDataSet4.FieldByname('TAGS_').AsString);
        sVIN_VeiculosNovos      := RetornaValorDaTagNoCampo('VIN',Form7.ibDataSet4.FieldByname('TAGS_').AsString);
        scondVeic_VeiculosNovos := RetornaValorDaTagNoCampo('condVeic',Form7.ibDataSet4.FieldByname('TAGS_').AsString);
        scMod_VeiculosNovos     := RetornaValorDaTagNoCampo('cMod',Form7.ibDataSet4.FieldByname('TAGS_').AsString);
        slota_VeiculosNovos     := RetornaValorDaTagNoCampo('lota',Form7.ibDataSet4.FieldByname('TAGS_').AsString);

        // Pegar estes dados na função dados
        Form29.Label_01.Visible := True;
        Form29.Label_02.Visible := True;
        Form29.Label_03.Visible := True;
        Form29.Label_04.Visible := True;
        Form29.Label_05.Visible := True;
        Form29.Label_06.Visible := True;
        Form29.Label_07.Visible := True;

        Form29.Edit_01.Visible := True;
        Form29.Edit_02.Visible := True;
        Form29.Edit_03.Visible := True;
        Form29.Edit_04.Visible := True;
        Form29.Edit_05.Visible := True;
        Form29.Edit_06.Visible := True;
        Form29.Edit_07.Visible := True;

        Form29.Label_01.Caption := 'Chassi do veículo VIN (código-identificação-veículo):';
        Form29.Label_02.Caption := 'Cor Código de cada montadora:';
        Form29.Label_03.Caption := 'Descrição da Cor:';
        Form29.Label_04.Caption := 'Serial (série):';
        Form29.Label_05.Caption := 'Número de Motor:';
        Form29.Label_06.Caption := 'Código da Cor (Ver tab. DENATRAN):';
        Form29.Label_07.Caption := 'Restrição:'+chr(10)+chr(10)+'0=Não há'+chr(10)+'1=Alienação Fiduciária'+chr(10)+'2=Arrendamento Mercantil'+chr(10)+'3=Reserva de Domínio'+chr(10)+'4=Penhor de Veículos'+chr(10)+'9=Outras';

        Form29.Edit_01.Text := '';
        Form29.Edit_02.Text := '';
        Form29.Edit_03.Text := '';
        Form29.Edit_04.Text := '';
        Form29.Edit_05.Text := '';
        Form29.Edit_06.Text := '';
        Form29.Edit_07.Text := '';

        Form1.Small_InputForm_Dados('Detalhamento de Veículos novos: '+Form7.ibDataSet4.FieldByname('DESCRICAO').AsString);

        sChassi_VeiculosNovos       := Form29.Edit_01.Text;
        sCCor_VeiculosNovos         := Form29.Edit_02.Text;
        sXCor_VeiculosNovos         := Form29.Edit_03.Text;
        snSerie_VeiculosNovos       := Form29.Edit_04.Text;
        snMotor_VeiculosNovos       := Form29.Edit_05.Text;
        scCorDENATRAN_VeiculosNovos := Form29.Edit_06.Text;
        stpRest_VeiculosNovos       := Form29.Edit_07.Text;

        Form7.spdNFeDataSets.Campo('tpOp_J02').Value          := stpOp_VeiculosNovos;         // 1=Venda concessionária, 2=Faturamento direto para consumidor final 3=Venda direta para grandes consumidores (frotista, governo, ...) 0=Outros
        Form7.spdNFeDataSets.Campo('chassi_J03').Value        := sChassi_VeiculosNovos;       // Chassi do veículo VIN (código-identificação-veículo)
        Form7.spdNFeDataSets.Campo('cCor_J04').Value          := sCCor_VeiculosNovos;         // Cor Código de cada montadora
        Form7.spdNFeDataSets.Campo('xCor_J05').Value          := sXCor_VeiculosNovos;         // Descrição da Cor
        Form7.spdNFeDataSets.Campo('pot_J06').Value           := sPot_VeiculosNovos;          // Potência Motor (CV) Potência máxima do motor do veículo em cavalo vapor
        Form7.spdNFeDataSets.Campo('cilin_J07').Value         := scilin_VeiculosNovos;        // Cilindradas Capacidade voluntária do motor expressa em centímetros cúbicos (CC). (cilindradas) (v2.0)
        Form7.spdNFeDataSets.Campo('pesoL_J08').Value         := spesoL_VeiculosNovos;        // Peso Líquido Em toneladas - 4 casas decimais
        Form7.spdNFeDataSets.Campo('pesoB_J09').Value         := spesoB_VeiculosNovos;        // Peso Bruto Peso Bruto Total - em tonelada - 4 casas decimais
        Form7.spdNFeDataSets.Campo('nSerie_J10').Value        := snSerie_VeiculosNovos;       // Serial (série)
        Form7.spdNFeDataSets.Campo('tpComb_J11').Value        := stpComb_VeiculosNovos;       // Tipo de combustível
        Form7.spdNFeDataSets.Campo('nMotor_J12').Value        := snMotor_VeiculosNovos;       // Número de Motor
        Form7.spdNFeDataSets.Campo('CMT_J13').Value           := sCMT_VeiculosNovos;          // Capacidade Máxima de Tração CMT-Capacidade Máxima de Tração - em Toneladas 4 casas decimais (v2.0)
        Form7.spdNFeDataSets.Campo('dist_J14').Value          := sdist_VeiculosNovos;         // Distância entre eixos
        Form7.spdNFeDataSets.Campo('anoMod_J16').Value        := sanoMod_VeiculosNovos;       // Ano Modelo de Fabricação
        Form7.spdNFeDataSets.Campo('anoFab_J17').Value        := sanoFab_VeiculosNovos;       // Ano de Fabricação
        Form7.spdNFeDataSets.Campo('tpPint_J18').Value        := stpPint_VeiculosNovos;       // Tipo de Pintura
        Form7.spdNFeDataSets.Campo('tpVeic_J19').Value        := stpVeic_VeiculosNovos;       // Tipo de Veículo Utilizar Tabela RENAVAM, conforme exemplos abaixo: 02=CICLOMOTO; 03=MOTONETA; 04=MOTOCICLO; 05=TRICICLO; 06=AUTOMÓVEL; 07=MICROÔNIBUS; 08=ÔNIBUS; 10=REBOQUE; 11=SEMIRREBOQUE; 13=CAMINHONETA; 14=CAMINHÃO; 17=C. TRATOR; 22=ESP / ÔNIBUS; 23=MISTO / CAM; 24=CARGA/CAM; ...
        Form7.spdNFeDataSets.Campo('espVeic_J20').Value       := sespVeic_VeiculosNovos;      // Espécie de Veículo Utilizar Tabela RENAVAM 1=PASSAGEIRO; 2=CARGA; 3=MISTO; 4=CORRIDA; 5=TRAÇÃO; 6=ESPECIAL;
        Form7.spdNFeDataSets.Campo('VIN_J21').Value           := sVIN_VeiculosNovos;          // Condição do VIN Informa-se o veículo tem VIN (chassi) remarcado. R=Remarcado; N=Normal
        Form7.spdNFeDataSets.Campo('condVeic_J22').Value      := scondVeic_VeiculosNovos;     // Condição do Veículo 1=Acabado; 2=Inacabado; 3=Semiacabado
        Form7.spdNFeDataSets.Campo('cMod_J23').Value          := scMod_VeiculosNovos;         // Código Marca Modelo Utilizar Tabela RENAVAM
        Form7.spdNFeDataSets.Campo('cCorDENATRAN_J24').Value  := scCorDENATRAN_VeiculosNovos; // Código da Cor Segundo as regras de pré-cadastro do DENATRAN (v2.0) 01=AMARELO, 02=AZUL, ...
        Form7.spdNFeDataSets.Campo('lota_J25').Value          := slota_VeiculosNovos;         // Capacidade máxima de lotação Quantidade máxima permitida de passageiros sentados, inclusive o motorista. (v2.0)
        Form7.spdNFeDataSets.Campo('tpRest_J26').Value        := stpRest_VeiculosNovos;       // Restrição 0=Não há; 1=Alienação Fiduciária; 2=Arrendamento Mercantil; 3=Reserva de Domínio; 4=Penhor de Veículos; 9=Outras. (v2.0)

        if Form7.spdNFeDataSets.Campo('tpOp_J02').Value = '2' then
        begin
          Form7.spdNFeDataSets.Campo('CNPJ_G02').Value        :=  Form7.spdNFeDataSets.Campo('CNPJ_E02').Value;    // CNPJ Informar CNPJ ou CPF
          Form7.spdNFeDataSets.Campo('CPF_G02a').Value        :=  Form7.spdNFeDataSets.Campo('CPF_E03').Value;     // CPF Preencher os zeros não significativos
          Form7.spdNFeDataSets.Campo('xLgr_G03').Value        :=  Form7.spdNFeDataSets.Campo('xLgr_E06').Value;    // Logradouro
          Form7.spdNFeDataSets.Campo('nro_G04').Value         :=  Form7.spdNFeDataSets.Campo('nro_E07').Value;     // Número
          Form7.spdNFeDataSets.Campo('xBairro_G06').Value     :=  Form7.spdNFeDataSets.Campo('xBairro_E09').Value; // Bairro
          Form7.spdNFeDataSets.Campo('cMun_G07').Value        :=  Form7.spdNFeDataSets.Campo('cMun_E10').Value;    // Código do município Utilizar a Tabela do IBGE (Anexo IX - Tabela de UF, Município e País). Informar ‘9999999 ‘para operações com o exterior.
          Form7.spdNFeDataSets.Campo('xMun_G08').Value        :=  Form7.spdNFeDataSets.Campo('xMun_E11').Value;    // Nome do município E G01 C 1-1 2-60 Informar ‘EXTERIOR ‘para operações com o exterior.
          Form7.spdNFeDataSets.Campo('UF_G09').Value          :=  Form7.spdNFeDataSets.Campo('UF_E12').Value;      // Sigla da UF Informar ‘EX’ para operações com o exterior.
          Form7.spdNFeDataSets.Campo('xCpl_G05').Value        :=  ''; // Complemento
        end;
      end;

      // Combustíveis
      sCodigoANP := '';// Iniciar varíavel vazia
      try
        if (copy(Form7.ibDataSet16CFOP.AsString,2,2)='65') or (copy(Form7.ibDataSet16CFOP.AsString,2,2)='66') then
        begin
          if RetornaValorDaTagNoCampo('cProdANP',Form7.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then
          begin
            sCodigoANP := RetornaValorDaTagNoCampo('cProdANP',Form7.ibDataSet4.FieldByname('TAGS_').AsString);
          end;

          while Length(sCodigoANP) <> 9 do
          begin
            sCodigoANP := LimpaNumero(Form1.Small_InputForm('Código ANP',chr(10)+'Informe o código ANP:'+chr(10)+chr(10)+'(Esta informação pode ser digitada no controle de estoque na aba Tags: cProdANP: 000000000)', ''));
          end;

          if Length(sCodigoANP) = 9 then
          begin
            if AllTrim(RetornaValorDaTagNoCampo('cProdANP',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) = '' then
            begin
              if not (Form7.ibDataSet4.State in ([dsEdit, dsInsert])) then
                Form7.ibDataSet4.Edit;
              Form7.ibDataSet4TAGS_.AsString := Form7.ibDataSet4TAGS_.AsString + chr(10) + '<cProdANP>'+sCodigoANP + '</cProdANP>';
              Form7.ibDataSet4.Post;
              Form7.ibDataSet4.Edit;
            end;

            Form7.spdNFeDataSets.incluirPart('L1');
            Form7.spdNFeDataSets.Campo('cProdANP_LA02').Value := sCodigoANP; // Código de produto da ANP
            Form7.spdNFeDataSets.Campo('UFCons_LA06').Value   := IBQUERY99.FieldByname('UF').AsString; // Sigla do Estado do Destinatário

            if Form1.sVersaoLayout = '4.00' then
            begin
              if (RetornaValorDaTagNoCampo('descANP', Form7.ibDataSet4.FieldByname('TAGS_').AsString) = '') then
              begin
                //ShowMessage('Incluir no controle de estoque na aba Tags: descANP: Descrição do produto conforme ANP'); Mauricio Parizotto 2023-10-25
                MensagemSistema('Incluir no controle de estoque na aba Tags: descANP: Descrição do produto conforme ANP',msgAtencao);
              end else
              begin
                Form7.spdNFeDataSets.campo('descANP_LA03').Value := RetornaValorDaTagNoCampo('descANP',Form7.ibDataSet4TAGS_.AsString);                                                  // Descrição do produto conforme ANP
              end;

              if (Form7.spdNFeDataSets.Campo('cProdANP_LA02').Value = '210203001') then
              begin
                if (RetornaValorDaTagNoCampo('pGLP', Form7.ibDataSet4.FieldByname('TAGS_').AsString) = '') or
                   (RetornaValorDaTagNoCampo('pGNn', Form7.ibDataSet4.FieldByname('TAGS_').AsString) = '') or
                   (RetornaValorDaTagNoCampo('pGNi', Form7.ibDataSet4.FieldByname('TAGS_').AsString) = '') then
                begin
                  {
                  ShowMessage('Incluir no controle de estoque na aba Tags:'+
                              Chr(10)+
                              Chr(10)+'pGLP: 0,0000'+
                              Chr(10)+'pGNn: 0,0000'+
                              Chr(10)+'pGNi: 0,0000'+
                              Chr(10)+'vPart: 0,00'
                              );
                  Mauricio Parizotto 2023-10-25}
                  MensagemSistema('Incluir no controle de estoque na aba Tags:'+
                                  Chr(10)+
                                  Chr(10)+'pGLP: 0,0000'+
                                  Chr(10)+'pGNn: 0,0000'+
                                  Chr(10)+'pGNi: 0,0000'+
                                  Chr(10)+'vPart: 0,00'
                                  ,msgAtencao);

                  Abort;
                end else
                begin
                  if (StrToFloatDef(RetornaValorDaTagNoCampo('pGLP', Form7.ibDataSet4.FieldByname('TAGS_').AsString), 0)
                  + StrToFloatDef(RetornaValorDaTagNoCampo('pGNn', Form7.ibDataSet4.FieldByname('TAGS_').AsString), 0)
                  + StrToFloatDef(RetornaValorDaTagNoCampo('pGNi', Form7.ibDataSet4.FieldByname('TAGS_').AsString), 0)) <> 100 then
                  begin
                    {
                    ShowMessage('Erro: LA01 grupo LA Combustível (pGLP + pGNn + pGNi) = '
                    + FormatFloat('#,##0.0000', StrToFloatDef(RetornaValorDaTagNoCampo('pGLP', Form7.ibDataSet4.FieldByname('TAGS_').AsString), 0)
                    + StrToFloatDef(RetornaValorDaTagNoCampo('pGNn', Form7.ibDataSet4.FieldByname('TAGS_').AsString), 0)
                    + StrToFloatDef(RetornaValorDaTagNoCampo('pGNi', Form7.ibDataSet4.FieldByname('TAGS_').AsString), 0)) + '%' + Chr(10)
                    + 'Rejeição: Somatório percentuais de GLP derivado do petróleo, pGLP(id:LA03a) e pGNn(id:LA03b) e pGNi(id:LA03c) diferente de 100. Verifique no cadastro do produto '
                                              + Chr(10) + Form7.spdNFeDataSets.Campo('cProd_I02').Value + ' ' + Form7.spdNFeDataSets.Campo('xProd_I04').Value);
                    Mauricio Parizotto 2023-10-25}
                    MensagemSistema('Erro: LA01 grupo LA Combustível (pGLP + pGNn + pGNi) = '
                                    + FormatFloat('#,##0.0000', StrToFloatDef(RetornaValorDaTagNoCampo('pGLP', Form7.ibDataSet4.FieldByname('TAGS_').AsString), 0)
                                    + StrToFloatDef(RetornaValorDaTagNoCampo('pGNn', Form7.ibDataSet4.FieldByname('TAGS_').AsString), 0)
                                    + StrToFloatDef(RetornaValorDaTagNoCampo('pGNi', Form7.ibDataSet4.FieldByname('TAGS_').AsString), 0)) + '%' + Chr(10)
                                    + 'Rejeição: Somatório percentuais de GLP derivado do petróleo, pGLP(id:LA03a) e pGNn(id:LA03b) e pGNi(id:LA03c) diferente de 100. Verifique no cadastro do produto '
                                    + Chr(10) + Form7.spdNFeDataSets.Campo('cProd_I02').Value + ' ' + Form7.spdNFeDataSets.Campo('xProd_I04').Value
                                    ,msgAtencao);

                    Abort;
                  end else
                  begin
                    Form7.spdNFeDataSets.Campo('pGLP_LA03a').Value   := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('pGLP', Form7.ibDataSet4.FieldByname('TAGS_').AsString), 0),4);  // Percentual do GLP derivado do petróleo no produto GLP (cProdANP=210203001) E LA01 N 0-1 3v4 Informar em número decimal o percentual do GLP derivado de petróleo no produto GLP. Valores de 0 a 100.
                    Form7.spdNFeDataSets.Campo('pGNn_LA03b').Value   := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('pGNn', Form7.ibDataSet4.FieldByname('TAGS_').AsString), 0),4);  // Percentual de Gás Natural Nacional – GLGNn para o produto GLP (cProdANP=210203001) E LA01 N 0-1 3v4 Informar em número decimal o percentual do Gás Natural Nacional – GLGNn para o produto GLP. Valores de 0 a 100.
                    Form7.spdNFeDataSets.Campo('pGNi_LA03c').Value   := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('pGNi', Form7.ibDataSet4.FieldByname('TAGS_').AsString), 0),4);  // Percentual de Gás Natural Importado – GLGNi para o produto GLP (cProdANP=210203001) E LA01 N 0-1 3v4 Informar em número decimal o percentual do Gás Natural Importado – GLGNi para o produto GLP. Valores de 0 a 100.
                  end;
                end;
              end;

              if RetornaValorDaTagNoCampo('vPart', Form7.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then
                Form7.spdNFeDataSets.Campo('vPart_LA03d').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('vPart', Form7.ibDataSet4.FieldByname('TAGS_').AsString), 0)); // Valor de partida (cProdANP=210203001)
            end;

            Form7.spdNFeDataSets.SalvarPart('L1');
          end;
        end;
      except
      end;


      // Grupo K. Detalhamento Específico de Medicamento e de matérias-primas farmacêuticas
      // ANVISA
      // Grupo de detalhamento de Medicamentos (med)
      if AllTrim(RetornaValorDaTagNoCampo('cProdANVISA',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
      begin
        Form7.spdNFeDataSets.Campo('cProdANVISA_K01a').Value      := RetornaValorDaTagNoCampo('cProdANVISA',Form7.ibDataSet4.FieldByname('TAGS_').AsString);  // Código de Produto da ANVISA

        if RetornaValorDaTagNoCampo('cProdANVISA',Form7.ibDataSet4.FieldByname('TAGS_').AsString) = 'ISENTO' then
        begin
          Form7.spdNFeDataSets.Campo('xMotivoIsencao_K01b').Value   := RetornaValorDaTagNoCampo('xMotivoIsencao',Form7.ibDataSet4.FieldByname('TAGS_').AsString);  // Motivo da isenção da ANVISA
        end;

        Form7.spdNFeDataSets.Campo('vPMC_K06').Value              :=  FormatFloatXML(Form7.ibDataSet4.FieldByname('PRECO').AsFloat); // Preço máximo consumidor
        //
        // Decidimos não informar estas TAG´s porque quando informa pede as TAG´s de rastreabilidade
        //
        //  Form7.spdNFeDataSets.Campo('nLote_I81').Value              := '00000000000000000001';   // Número do Lote do produto
        //  Form7.spdNFeDataSets.Campo('qLote_I82').Value              := StrTran(Alltrim(FormatFloat('##0.'+Replicate('0',StrToInt(Form1.ConfPreco)),Form7.ibDataSet4.FieldByname('QTD_ATUAL').AsFloat)),',','.');;   // Quantidade de produto no Lote
        //  Form7.spdNFeDataSets.Campo('dFab_I83').Value               := '2021-12-31';   // Data de fabricação/ Produção
        //  Form7.spdNFeDataSets.Campo('dVal_I84').Value               := '2022-12-31';   // Data de validade
        //  Form7.spdNFeDataSets.Campo('cAgreg_I85').Value             := '';   // Código de Agregação
      end;

      //Grupo I80. Rastreabilidade de produto
      //Grupo criado para permitir a rastreabilidade de qualquer produto sujeito a regulações sanitárias, casos de recolhimento/recall, além de defensivos
      //agrícolas, produtos veterinários, odontológicos, medicamentos, bebidas, águas envasadas, embalagens, etc., a partir da indicação de informações de
      //número de lote, data de fabricação/produção, data de validade, etc. Obrig.atório o preenchimento deste grupo no caso de medicamentos e produtos
      //farmacêuticos.
      if AnsiUpperCase(Copy(Trim(RetornaValorDaTagNoCampo('rastro',Form7.ibDataSet4.FieldByname('TAGS_').AsString)), 1, 1)) = 'S' then
      begin
        // Form para lançamento de dados de rastreabilidade
        // Fica em loop enquanto a quantidade lançada seja menor que a quantidade do item ou clique no botão "Cancelar"

        Application.CreateForm(TFrmInformacoesRastreamento, FrmInformacoesRastreamento);
        try
          dQtdAcumulado := 0;
          FrmInformacoesRastreamento.Caption       := 'Rastreabilidade';
          //FrmInformacoesRastreamento.ActiveControl := FrmInformacoesRastreamento.DBGridRastro;
          FrmInformacoesRastreamento.QtdItemNaNota := StrToFloatDef(Form7.spdNFeDataSets.Campo('qCom_I10').Value, 0);
          FrmInformacoesRastreamento.lbProduto.Caption             := '' + Form7.ibDataSet4.FieldByname('CODIGO').AsString + ' - ' + Form7.ibDataSet4.FieldByname('DESCRICAO').AsString + ' - ' + Form7.ibDataSet4.FieldByname('MEDIDA').AsString;
          FrmInformacoesRastreamento.lbValorQuantidadeItem.Caption := Form7.spdNFeDataSets.Campo('qCom_I10').Value;
          FrmInformacoesRastreamento.ShowModal;
          if FrmInformacoesRastreamento.ModalResult = mrOk then
          begin
            FrmInformacoesRastreamento.CDSLOTES.First;
            while FrmInformacoesRastreamento.CDSLOTES.Eof = False do
            begin
              try
                dQtdAcumulado := dQtdAcumulado + FrmInformacoesRastreamento.CDSLOTES.FieldByName('QUANTIDADE').AsFloat;
                Form7.spdNFeDataSets.IncluirPart('I80');
                Form7.spdNFeDataSets.Campo('nLote_I81').Value  := ConverteAcentos2(Trim(FrmInformacoesRastreamento.CDSLOTES.FieldByName('NUMERO').AsString));   // Número do Lote do produto
                Form7.spdNFeDataSets.Campo('qLote_I82').Value  := StrTran(Trim(FormatFloat('0.000', FrmInformacoesRastreamento.CDSLOTES.FieldByName('QUANTIDADE').AsFloat)), ',', '.');   // Quantidade de produto no Lote. Precisa de 3 casas decimais para Sefaz aceitar valores em casos como 0.5 -> 0.500
                Form7.spdNFeDataSets.Campo('dFab_I83').Value   := FormatDateTime('yyyy-mm-dd', FrmInformacoesRastreamento.CDSLOTES.FieldByName('DTFABRICACAO').AsDateTime);   // Data de fabricação/ Produção
                Form7.spdNFeDataSets.Campo('dVal_I84').Value   := FormatDateTime('yyyy-mm-dd', FrmInformacoesRastreamento.CDSLOTES.FieldByName('DTVALIDADE').AsDateTime);   // Data de validade
                Form7.spdNFeDataSets.Campo('cAgreg_I85').Value := ConverteAcentos2(Trim(FrmInformacoesRastreamento.CDSLOTES.FieldByName('CODIGOAGREGACAO').AsString));   // Código de Agregação
                Form7.spdNFeDataSets.SalvarPart('I80');
              except
                on E: Exception do
                begin
                  {
                  Application.MessageBox(pChar(E.Message + chr(10) + chr(10) + Form7.ibDataSet4.FieldByname('CODIGO').AsString + ' - ' + Form7.ibDataSet4.FieldByname('DESCRICAO').AsString + ' - ' + Form7.ibDataSet4.FieldByname('MEDIDA').AsString + chr(10)+ 'ao gerar Grupo Rastro'
                    ), 'Atenção', mb_Ok + MB_ICONWARNING);
                   Mauricio Parizotto 2023-10-25}
                   MensagemSistema(E.Message + chr(10) + chr(10) + Form7.ibDataSet4.FieldByname('CODIGO').AsString + ' - ' + Form7.ibDataSet4.FieldByname('DESCRICAO').AsString + ' - ' + Form7.ibDataSet4.FieldByname('MEDIDA').AsString + chr(10)+ 'ao gerar Grupo Rastro'
                                   ,msgAtencao);
                end;
              end;
              FrmInformacoesRastreamento.CDSLOTES.Next;
            end;
          end;
        finally
          FreeAndNil(FrmInformacoesRastreamento);
        end;
      end;

      //Gera Tas
      GeraXmlNFeSaidaTags(vIPISobreICMS, fSomaNaBase);

      // FCP
      if Form1.sVersaoLayout = '4.00' then
      begin
        // Nesta nova versão não haverá alteração no leiaute do DANFE. As informações relativas ao Fundo de Combate à Pobreza (FCP) devem ser informadas:
        // - No campo de "Informações Adicionais do Produto, tag: indAdProd", os valores informados por item nos campos (vBCFCP, pFCP, vFCP, vBCFCPST, pFCPST, vFCPST), quando existirem; e
        if StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBCFCP_N17a').AsString,',',''),'.',','))   <> 0 then
          Form7.spdNFeDataSets.campo('InfAdProd_V01').Value := AllTrim(Form7.spdNFeDataSets.campo('InfAdProd_V01').Value + ' vBCFCP '  + Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value);

        if StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('pFCP_N17b').AsString,',',''),'.',','))     <> 0 then
          Form7.spdNFeDataSets.campo('InfAdProd_V01').Value := AllTrim(Form7.spdNFeDataSets.campo('InfAdProd_V01').Value + ' pFCP '    + Form7.spdNFeDataSets.campo('pFCP_N17b').Value);

        if StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vFCP_N17c').AsString,',',''),'.',','))     <> 0 then
          Form7.spdNFeDataSets.campo('InfAdProd_V01').Value := AllTrim(Form7.spdNFeDataSets.campo('InfAdProd_V01').Value + ' vFCP '    + Form7.spdNFeDataSets.campo('vFCP_N17c').Value);

        if StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBCFCPST_N23a').AsString,',',''),'.',',')) <> 0 then
          Form7.spdNFeDataSets.campo('InfAdProd_V01').Value := AllTrim(Form7.spdNFeDataSets.campo('InfAdProd_V01').Value + ' vBCFCPST '+ Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value);

        if StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('pFCPST_N23b').AsString,',',''),'.',','))   <> 0 then
          Form7.spdNFeDataSets.campo('InfAdProd_V01').Value := AllTrim(Form7.spdNFeDataSets.campo('InfAdProd_V01').Value + ' pFCPST '  + Form7.spdNFeDataSets.campo('pFCPST_N23b').Value);

        if StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vFCPST_N23d').AsString,',',''),'.',','))   <> 0 then
          Form7.spdNFeDataSets.campo('InfAdProd_V01').Value := AllTrim(Form7.spdNFeDataSets.campo('InfAdProd_V01').Value + ' vFCPST '  + Form7.spdNFeDataSets.campo('vFCPST_N23d').Value);

      end;

      // IPI
      if AllTrim(Form7.ibDataSet16.FieldByname('CST_IPI').AsString) <> '' then
      begin
        // CST IPI
        // 00 Entrada com recuperação de crédito
        // 01 Entrada tributada com alíquota zero
        // 02 Entrada isenta
        // 03 Entrada não-tributada
        // 04 Entrada imune
        // 05 Entrada com suspensão
        // 49 Outras entradas
        // 50 Saída tributada
        // 51 Saída tributada com alíquota zero
        // 52 Saída isenta
        // 53 Saída não-tributada
        // 54 Saída imune
        // 55 Saída com suspensão
        // 99 Outras saídas
        if Form1.sVersaoLayout = '4.00' then
        begin
        end else
        begin
          Form7.spdNFeDataSets.Campo('clEnq_O02').Value     := 'NDA'; // Classe de enquadramento do IPI para cigarros e Bebidas
        end;

        Form7.spdNFeDataSets.Campo('CNPJProd_O03').Value  := '00000000000000'; // CNPJ do produtor quando diferente do emitente
        Form7.spdNFeDataSets.Campo('cSelo_O04').Value     := '';   // Código do celo de controle IPI
        Form7.spdNFeDataSets.Campo('qSelo_O05').Value     := '0';   // Quantidade de celo de controle

        if LimpaNumero(Form7.ibDataSet4ENQ_IPI.AsString) <> '' then
        begin
          Form7.spdNFeDataSets.Campo('cEnq_O06').Value      := Form7.ibDataSet4ENQ_IPI.AsString; // Enquadramento legal do IPI
        end else
        begin
          Form7.spdNFeDataSets.Campo('cEnq_O06').Value      := '999'; // Enquadramento legal do IPI
        end;

        // Form7.spdNFeDataSets.Campo('CST_O09').Value       := '50';  // Saída tributada de IPI
        Form7.spdNFeDataSets.Campo('CST_O09').Value       :=  Form7.ibDataSet16.FieldByname('CST_IPI').AsString; // Saída tributada de IPI

        if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
        begin
          Form7.spdNFeDataSets.Campo('qUnid_O11').Value := StrTran(Alltrim(FormatFloat('##0.0000',Form7.ibDataSet16.FieldByname('QUANTIDADE').AsFloat)),',','.'); // Quantidade Total da Unidade padrao para tributacao
          Form7.spdNFeDataSets.Campo('vUnid_O12').Value := StrTran(Alltrim(FormatFloat('##0.0000',StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString))))),',','.'); // Valor por unidade tributavel
          Form7.spdNFeDataSets.Campo('pIPI_O13').Value  := ''; // Percentual do IPI
          Form7.spdNFeDataSets.Campo('vIPI_O14').Value  := FormatFloatXML(Arredonda2((Form7.ibDataSet16.FieldByname('QUANTIDADE').AsFloat * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString)))),2)); // Valor do IPI
        end else
        begin
          vlFreteRateadoItem := 0;

          if vFreteSobreIPI then
            vlFreteRateadoItem := fFrete[I];

          vlBalseIPI := Form7.ibDataSet16.FieldByname('TOTAL').AsFloat + vlFreteRateadoItem; //Mauricio Parizotto 2023-03-27

          Form7.spdNFeDataSets.Campo('vBC_O10').Value       := FormatFloatXML(vlBalseIPI); // Valor da BC do IPI
          Form7.spdNFeDataSets.Campo('pIPI_O13').Value      := FormatFloatXML(Form7.ibDataSet16.FieldByname('IPI').AsFloat); // Percentual do IPI

          // Sandro Silva 2023-05-18 if Form7.ibDataSet15FINNFE.AsString = '4' then // Devolucao Devolução Não deve mudar
          if NFeFinalidadeDevolucao(Form7.ibDataSet15FINNFE.AsString) then // Devolucao Devolução Não deve mudar
          begin
            Form7.spdNFeDataSets.Campo('vIPI_O14').Value      := FormatFloatXML(Arredonda2(Form7.ibDataSet16.FieldByname('VIPI').AsFloat,2)); // Valor do IPI
          end else
          begin
            Form7.spdNFeDataSets.Campo('vIPI_O14').Value      := FormatFloatXML(Arredonda2(Form7.ibDataSet16.FieldByname('IPI').AsFloat*vlBalseIPI/100,2)); // Valor do IPI
          end;
        end;
      end;

      // CST PIS E CST COFINS
      // 1 - Na OBS do produto incluir: PIS COFINS
      // 2 - Na tabela de ICM na natureza da opereção preencher: BC PIS, % PIS, BC COFINS, % COFINS e CST PIS COFINS=99
      Form7.spdNFeDataSets.Campo('CST_Q06').Value   := Form7.ibDataSet16.FieldByname('CST_PIS_COFINS').AsString;
      Form7.spdNFeDataSets.Campo('CST_S06').Value   := Form7.ibDataSet16.FieldByname('CST_PIS_COFINS').AsString;

      // PIS
      Form7.spdNFeDataSets.Campo('vBC_Q07').Value     := FormatFloatXML(Form7.ibDataSet16.FieldByname('VBC_PIS_COFINS').AsFloat); // Valor da Base de Cálculo do PIS
      Form7.spdNFeDataSets.Campo('pPIS_Q08').Value    := FormatFloatXML(Form7.ibDataSet16.FieldByname('ALIQ_PIS').AsFloat); // Alíquota em Percencual do PIS
      if Form7.ibDataSet16.FieldByname('ALIQ_PIS').AsFloat > 0 then
        Form7.spdNFeDataSets.Campo('vPIS_Q09').Value    := FormatFloatXML(Form7.ibDataSet16.FieldByname('VBC_PIS_COFINS').AsFloat * (Form7.ibDataSet16.FieldByname('ALIQ_PIS').AsFloat/100) )
      else
        Form7.spdNFeDataSets.Campo('vPIS_Q09').Value    := '0.00'; // Valor do PIS em Reais

      // COFINS
      Form7.spdNFeDataSets.Campo('vBC_S07').Value        := FormatFloatXML(Form7.ibDataSet16.FieldByname('VBC_PIS_COFINS').AsFloat); // Valor da Base de Cálculo do COFINS
      Form7.spdNFeDataSets.Campo('pCOFINS_S08').Value    := FormatFloatXML(Form7.ibDataSet16.FieldByname('ALIQ_COFINS').AsFloat); // Alíquota em Percencual do COFINS
      if Form7.ibDataSet16.FieldByname('ALIQ_COFINS').AsFloat > 0 then
        Form7.spdNFeDataSets.Campo('vCOFINS_S11').Value    := FormatFloatXML(Form7.ibDataSet16.FieldByname('VBC_PIS_COFINS').AsFloat * (Form7.ibDataSet16.FieldByname('ALIQ_COFINS').AsFloat/100) ) // Valor do COFINS em Reais
      else
        Form7.spdNFeDataSets.Campo('vCOFINS_S11').Value    := '0.00'; // Valor do COFINS em Reais

      // Pis/Cofins por unidade
      if Form7.spdNFeDataSets.Campo('CST_Q06').Value = '03' then
      begin
        //Pis
        Form7.spdNFeDataSets.Campo('vPIS_Q09').Value      := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet16.FieldByname('VBC_PIS_COFINS').AsFloat*Form7.ibDataSet16.FieldByname('ALIQ_PIS').AsFloat)),',','.'); // Valor do PIS em Reais
        Form7.spdNFeDataSets.Campo('qBCPROD_S09').Value   := StrTran(Alltrim(FormatFloat('##0.0000',Form7.ibDataSet16.FieldByname('VBC_PIS_COFINS').AsFloat)),',','.'); // Quantidade Vendida
        Form7.spdNFeDataSets.Campo('vAliqPROD_Q11').Value := StrTran(Alltrim(FormatFloat('##0.0000',Form7.ibDataSet16.FieldByname('ALIQ_PIS').AsFloat)),',','.'); // Alíquota do PIS (em reais)

        //Cofins
        Form7.spdNFeDataSets.Campo('vCOFINS_S11').Value   := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet16.FieldByname('VBC_PIS_COFINS').AsFloat*Form7.ibDataSet16.FieldByname('ALIQ_COFINS').AsFloat)),',','.'); // Valor do COFINS em Reais
        Form7.spdNFeDataSets.Campo('qBCPROD_Q10').Value   := StrTran(Alltrim(FormatFloat('##0.0000',Form7.ibDataSet16.FieldByname('VBC_PIS_COFINS').AsFloat)),',','.'); // Quantidade Vendida
        Form7.spdNFeDataSets.Campo('vAliqPROD_S10').Value := StrTran(Alltrim(FormatFloat('##0.0000',Form7.ibDataSet16.FieldByname('ALIQ_COFINS').AsFloat)),',','.'); // Alíquota do COFINS (em reais)
      end;

      vPIS := vPIS + Arredonda(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vPIS_Q09').AsString,',',''),'.',',')),2);
      vCOFINS := vCOFINS + Arredonda(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vCOFINS_S11').AsString,',',''),'.',',')),2);

      // totalizador da nota complementar
      // Sandro Silva 2023-05-25 if Form7.ibDataSet15FINNFE.AsString = '2' then // Complementar
      if NFeFinalidadeComplemento(Form7.ibDataSet15FINNFE.AsString) then // Complementar
      begin
        {Mauricio Parizotto 2023-06-05
        Form7.spdNFeDataSets.Campo('vUnTrib_I14a').Value := '0.00'; // Valor Tributável do Item
        Form7.spdNFeDataSets.Campo('qCom_I10').Value     := '0.00'; // Quantidade Comercializada do Item
        Form7.spdNFeDataSets.Campo('vUnCom_I10a').Value  := '0.00'; // Valor Comercializado do Item
        Form7.spdNFeDataSets.Campo('vProd_I11').Value    := '0.00'; // Valor Total Bruto do Item
        }

        //Só zera valores se não for nota de complemento de valor
        if Form7.spdNFeDataSets.Campo('vUnTrib_I14a').Value = '0.01' then
        begin
          Form7.spdNFeDataSets.Campo('qTrib_I14').Value    := '0.00'; // Quantidade Tributável do Item
          Form7.spdNFeDataSets.Campo('vUnTrib_I14a').Value := '0.00'; // Valor Tributável do Item
          Form7.spdNFeDataSets.Campo('qCom_I10').Value     := '0.00'; // Quantidade Comercializada do Item
          Form7.spdNFeDataSets.Campo('vUnCom_I10a').Value  := '0.00'; // Valor Comercializado do Item
          Form7.spdNFeDataSets.Campo('vProd_I11').Value    := '0.00'; // Valor Total Bruto do Item
        end;


        Form7.spdNFeDataSets.Campo('vBC_N15').Value         := FormatFloatXML(Form7.ibDataSet15.FieldByname('BASEICM').AsFloat); // BC

        if (Form7.ibDataSet15.FieldByname('BASEICM').AsCurrency > 0) and (Form7.ibDataSet15.FieldByname('ICMS').AsCurrency > 0) then
        begin
          // Form7.spdNFeDataSets.Campo('pICMS_N16').Value     := FormatFloatXML(Arredonda(((Form7.ibDataSet15.FieldByname('ICMS').AsFloat / Form7.ibDataSet15.FieldByname('BASEICM').AsFloat) * 100), 1)) // Alíquota do ICMS em Percentual
          {Dailon (f-7249) 2023-08-28 inicio}
          if AnsiContainsText(FloatToStr(Arredonda((Form7.ibDataSet15.FieldByname('ICMS').AsFloat / Form7.ibDataSet15.FieldByname('BASEICM').AsFloat) * 100, 1))  ,',5') then
            Form7.spdNFeDataSets.Campo('pICMS_N16').Value := FormatFloatXML(Arredonda((Form7.ibDataSet15.FieldByname('ICMS').AsFloat / Form7.ibDataSet15.FieldByname('BASEICM').AsFloat) * 100, 1))
          else
            Form7.spdNFeDataSets.Campo('pICMS_N16').Value := FormatFloatXML(Arredonda((Form7.ibDataSet15.FieldByname('ICMS').AsFloat / Form7.ibDataSet15.FieldByname('BASEICM').AsFloat) * 100, 0));
          {Dailon (f-7249) 2023-08-28 fim}
        end
        else
          Form7.spdNFeDataSets.Campo('pICMS_N16').Value     := FormatFloatXML(0); // Alíquota do ICMS em Percentual

        Form7.spdNFeDataSets.Campo('vICMS_N17').Value       := FormatFloatXML(Form7.ibDataSet15.FieldByname('ICMS').AsFloat);     // Valor do ICMS em Reais

        Form7.spdNFeDataSets.Campo('vbCST_N21').Value       := FormatFloatXML(Form7.ibDataSet15.FieldByname('BASESUBSTI').AsFloat); // Valor cobrado anteriormente por ST
        Form7.spdNFeDataSets.Campo('vICMSST_N23').Value     := FormatFloatXML(Form7.ibDataSet15.FieldByname('ICMSSUBSTI').AsFloat); // Valor do ICMS ST em Reais
//                    Form7.spdNFeDataSets.Campo('pICMSST_N22').Value     := StrTran(Alltrim(FormatFloat('##0.00',100)),',','.'); // Alíquota do ICMS em Percentual
        if Form7.spdNFeDataSets.Campo('vICMSST_N23').Value <> '0' then // Mudei 11/05/2022
        begin
          Form7.spdNFeDataSets.Campo('pICMSST_N22').Value     := FormatFloatXML(0); // Alíquota do ICMS em Percentual
        end else
        begin
          Form7.spdNFeDataSets.Campo('pICMSST_N22').Value     := '0';      // Alíquota do ICMS em Percentual
          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value      := '0.00';  // Percentual de margem de valor adicionado do ICMS ST
          Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '0.00'; // Percentual de redução de BC do ICMS ST
        end;
      end;

      // Devolucao
      // Sandro Silva 2023-05-18 if Form7.ibDataSet15FINNFE.AsString = '4' then // Devolucao Devolução
      if NFeFinalidadeDevolucao(Form7.ibDataSet15FINNFE.AsString) then // Devolução
      begin
        // Imposto da NF de DEVOLUCAO devolução
        // neste ponto é possível informar os impostos com os valores da nota de entrada
        // não importa que já foram informados o que vai valer são estes valores
        Form7.spdNFeDataSets.Campo('vBC_N15').Value       := FormatFloatXML(Form7.ibDataSet16VBC.AsFloat); // BC
        Form7.spdNFeDataSets.Campo('CST_N12').Value       := Right(Form7.ibDataSet16CST_ICMS.AsString,2);                                   // Tipo da Tributação do ICMS (00 - Integralmente) ver outras formas no Manual

        Form7.spdNFeDataSets.Campo('vICMS_N17').Value     := '';

        if (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '900') then
        begin
          Form7.spdNFeDataSets.Campo('vICMS_N17').Value     := FormatFloatXML(Form7.ibDataSet16VICMS.AsFloat);     // Valor do ICMS em Reais
        end;

        if (Form7.spdNFeDataSets.Campo('CST_N12').AssTring <> '40') and
          (Form7.spdNFeDataSets.Campo('CST_N12').AssTring <> '50') and //Mauricio Parizotto 2023-07-04
          (Form7.spdNFeDataSets.Campo('CST_N12').AssTring <> '41') then
        begin
          Form7.spdNFeDataSets.Campo('vICMS_N17').Value     := FormatFloatXML(Form7.ibDataSet16VICMS.AsFloat);     // Valor do ICMS em Reais
        end;

        {Sandro Silva 2023-06-13 inicio}
        if (Pos('|' + Form7.spdNFeDataSets.Campo('CST_N12').AssTring + '|', '|61|') > 0) or
           (Pos('|' + Form7.spdNFeDataSets.Campo('CSOSN_N12a').AsString + '|', '|61|') > 0) then
        begin
          Form7.spdNFeDataSets.Campo('vBC_N15').Value       := '0.00';
          Form7.spdNFeDataSets.Campo('vICMS_N17').Value     := '0.00';
          Form7.spdNFeDataSets.Campo('CSOSN_N12a').Clear;
          Form7.spdNFeDataSets.Campo('CST_N12').AsString    := '61';

        end;
        {Sandro Silva 2023-06-13 fim}


        {Sandro Silva 2023-05-25 inicio}
        // Se no código acima pICMS_N16 ficou zerado, descobre o valor a partir de vICMS_N17 dividido por vBC_N15
        if FormatXMLToFloat(Form7.spdNFeDataSets.Campo('pICMS_N16').Value) = 0.00 then
        begin
          if (FormatXMLToFloat(Form7.spdNFeDataSets.Campo('vICMS_N17').Value) > 0.00) and (FormatXMLToFloat(Form7.spdNFeDataSets.Campo('vBC_N15').Value) > 0.00) then
            Form7.spdNFeDataSets.Campo('pICMS_N16').Value := FormatFloatXML((FormatXMLToFloat(Form7.spdNFeDataSets.Campo('vICMS_N17').Value) / FormatXMLToFloat(Form7.spdNFeDataSets.Campo('vBC_N15').Value)) * 100); // Descobre o percentual de ICMS
        end;
        {Sandro Silva 2023-05-28 fim}

        if (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '10') then
        begin
          Form7.spdNFeDataSets.Campo('modBCST_N18').Value     := '4'; // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual
        end;

        if (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '20') then
        begin
          Form7.spdNFeDataSets.Campo('pRedBC_N14').Value := FormatFloatXML(100-Form7.ibDataSet16.FieldByname('BASE').AsFloat); // Percentual da redução de BC
        end;

        if (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '30') then
        begin
          Form7.spdNFeDataSets.Campo('modBCST_N18').Value     := '4';   // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual
          Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '100'; // Percentual de redução de BC do ICMS ST
        end;

        if (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '60') then
        begin
          if (not NFeFinalidadeDevolucao(Form7.ibDataSet15FINNFE.AsString)) or
             ((NFeFinalidadeDevolucao(Form7.ibDataSet15FINNFE.AsString)) and (Form7.spdNFeDataSets.Campo('indFinal_B25a').Value  = '0')) then
          begin
            Form7.spdNFeDataSets.Campo('vbCSTRet_N26').Value    := FormatFloatXML(Form7.ibDataSet16VBCST.AsFloat);  // Valor do BC do ICMS ST retido na UF Emitente ok
            Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value  := FormatFloatXML(Form7.ibDataSet16VICMSST.AsFloat);  //  Valor do ICMS ST retido na UF Emitente
            Form7.spdNFeDataSets.Campo('vICMSSubstituto_N26b').Value  := '0.00'; // Valor do icms próprio do substituto cobrado em operação anterior

            if (Form7.ibDataSet16VICMSST.AsFloat > 0) and (Form7.ibDataSet16VBCST.AsFloat > 0) then
            begin
              Form7.spdNFeDataSets.Campo('pST_N26a').Value        := FormatFloatXML((Form7.ibDataSet16VICMSST.AsFloat / Form7.ibDataSet16VBCST.AsFloat)*100);  // Aliquota suportada pelo consumidor
            end else
            begin
              Form7.spdNFeDataSets.Campo('pST_N26a').Value        := '0.00';
            end;
          end;
        end;

        if (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '70') then
        begin
          Form7.spdNFeDataSets.Campo('pRedBC_N14').Value := FormatFloatXML(100-Form7.ibDataSet16.FieldByname('BASE').AsFloat); // Percentual da redução de BC
          Form7.spdNFeDataSets.Campo('modBCST_N18').Value     := '4';   // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual
          Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '100'; // Percentual de redução de BC do ICMS ST
        end;

        if (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '90') then
        begin
          Form7.spdNFeDataSets.Campo('pRedBC_N14').Value := FormatFloatXML(100-Form7.ibDataSet16.FieldByname('BASE').AsFloat); // Percentual da redução de BC
          Form7.spdNFeDataSets.Campo('modBCST_N18').Value     := '4';   // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual
          Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '100'; // Percentual de redução de BC do ICMS ST
        end;

        Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := FormatFloatXML(Form7.ibDataSet16VBCST.AsFloat);    // Valor da BC do ICMS ST
        Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := FormatFloatXML(Form7.ibDataSet16VICMSST.AsFloat);  // VAlor do ICMS ST

        // Criar estes dois campos e armazenar no Form7.ibDataSet16 e recuperar na nota de devolução
        spMVAST  := '0,00';
        spICMSST := '0,00';

        // Só pede se tem Valor de ICMSST
        if Form7.ibDataSet16VICMSST.AsFloat > 0 then
        begin
          spMVAST  := Form1.Small_InputForm('NFe', 'Informe o pMVAST (% de margem de valor adicionado do ICMS ST) para o produto: '+Form7.ibDataSet16DESCRICAO.AsString, '0,00');
          spICMSST := Form1.Small_InputForm('NFe', 'Informe o pICMSST (% Aliquota do Imposto do ICMS ST) para o produto: '+Form7.ibDataSet16DESCRICAO.AsString, '0,00');
        end;

        Form7.spdNFeDataSets.Campo('pMVAST_N19').Value    := FormatFloatXML(StrToFloat(LimpaNumeroDeixandoAVirgula(spMVAST)));  // Percentual de margem de valor adicionado do ICMS ST

        if Form7.spdNFeDataSets.Campo('vICMSST_N23').Value <> '0' then // Mudei 20/06/2022
        begin
          Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   := FormatFloatXML(StrToFloat(LimpaNumeroDeixandoAVirgula(spICMSST))); // Alíquota do ICMS em Percentual
        end else
        begin
          Form7.spdNFeDataSets.Campo('pICMSST_N22').Value     := '0';      // Alíquota do ICMS em Percentual
          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value      := '0.00';  // Percentual de margem de valor adicionado do ICMS ST
          Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '0.00'; // Percentual de redução de BC do ICMS ST
        end;

        // IPI
        // UA. Tributos Devolvidos (para o item da NF-e)
        Form7.ibDataset97.Close;
        Form7.ibDataset97.SelectSql.Clear;
        Form7.ibDataset97.SelectSQL.Add(' select * from ITENS002 ,COMPRAS '+
                                        ' where  COMPRAS.NFEID='+QuotedStr(sChave)+
                                        '   and COMPRAS.NUMERONF=ITENS002.NUMERONF '+
                                        '   and ITENS002.CODIGO='+QuotedStr(Form7.ibDataSet16CODIGO.AsString)+' ');
        Form7.ibDataset97.Open;

        if AllTrim(Form7.ibDataSet16.FieldByname('CST_IPI').AsString) <> '' then
        begin
          vlFreteRateadoItem := 0;

          if vFreteSobreIPI then
            vlFreteRateadoItem := fFrete[I];

          vlBalseIPI := Form7.ibDataSet16.FieldByname('TOTAL').AsFloat + vlFreteRateadoItem; //Mauricio Parizotto 2023-03-27

          Form7.spdNFeDataSets.Campo('vBC_O10').Value       := FormatFloatXML(vlBalseIPI); // Valor da BC do IPI
          Form7.spdNFeDataSets.Campo('pIPI_O13').Value      := FormatFloatXML(Form7.ibDataSet16.FieldByname('IPI').AsFloat); // Percentual do IPI

          // Sandro Silva 2023-05-18 if Form7.ibDataSet15FINNFE.AsString = '4' then // Devolucao Devolução Não deve mudar
          if NFeFinalidadeDevolucao(Form7.ibDataSet15FINNFE.AsString) then // Devolucao Devolução Não deve mudar
          begin
            Form7.spdNFeDataSets.Campo('vIPI_O14').Value      := FormatFloatXML(Arredonda2(Form7.ibDataSet16.FieldByname('VIPI').AsFloat,2)); // Valor do IPI
          end else
          begin
            Form7.spdNFeDataSets.Campo('vIPI_O14').Value      := FormatFloatXML(Arredonda2(Form7.ibDataSet16.FieldByname('IPI').AsFloat*vlBalseIPI/100,2)); // Valor do IPI
          end;
        end else
        begin
          if sChave <> '' then
          begin
            // Já está no item certo
            if sChave = Form7.ibDataset97.FieldByName('NFEID').AsString then
            begin
              Form7.spdNFeDataSets.campo('pDevol_UA02').Value        := FormatFloatXML((Form7.ibDataSet16QUANTIDADE.AsFloat/Form7.ibDataset97.FieldByname('QTD_ORIGINAL').Asfloat) * 100);    // Percentual da mercadoria devolvida
              Form7.spdNFeDataSets.campo('vIPIDevol_UA04').Value     := FormatFloatXML((Form7.ibDataset97.FieldByname('VIPI').Asfloat /Form7.ibDataset97.FieldByname('QTD_ORIGINAL').Asfloat ) * Form7.ibDataSet16QUANTIDADE.AsFloat); // Valor do IPI devolvido
              fIPIDevolvido     := fIPIDevolvido + StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vIPIDevol_UA04').AsString,',',''),'.',','));
            end else
            begin
              Form7.spdNFeDataSets.campo('pDevol_UA02').Value        := '100.00';    // Percentual da mercadoria devolvida
              Form7.spdNFeDataSets.campo('vIPIDevol_UA04').Value     := FormatFloatXML(Form7.ibDataSet16VIPI.AsFloat); // Valor do IPI devolvido
              fIPIDevolvido     := fIPIDevolvido + StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vIPIDevol_UA04').AsString,',',''),'.',','));
              //ShowMessage('Nota fiscal referenciada não encontrada'); Mauricio Parizotto 2023-10-25
              MensagemSistema('Nota fiscal referenciada não encontrada',msgAtencao);
            end;
          end;
        end;

        {
        if sChave <> Form7.ibDataset97.FieldByName('NFEID').AsString then
        begin
          // Devolução Quando não tem NF relacionada calcula a aliquota
          // Ficha 6243
          // Sandro Silva 2022-09-20 Form7.spdNFeDataSets.Campo('pICMS_N16').Value       := StrTran(Alltrim(FormatFloat('##0.00',Arredonda(((StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vICMS_N17').AsString,',',''),'.',',')) / StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))) * 100),1))),',','.'); // Calcula a Alíquota do ICMS em Percentual
          try
            // vBC_N15 não pode ser zero, causa erro na divisão para encontrar a alíquota
            if StrToFloatDef(StrTran(StrTran(Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','), 0) > 0 then
              Form7.spdNFeDataSets.Campo('pICMS_N16').Value := FormatFloatXML(Arredonda(((StrToFloatDef(StrTran(StrTran(Form7.spdNFeDataSets.Campo('vICMS_N17').AsString,',',''),'.',','), 0) / StrToFloatDef(StrTran(StrTran(Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','), 0)) * 100),1)); // Calcula a Alíquota do ICMS em Percentual
          except
          end;
        end;
        Mauricio Parizotto 2023-08-14 Comentado pois já faz na unit uNotaFiscalEletronicaCalc}
      end;

      // TOTALIZADOR DA NOTA
      // Calculo do valor real
      //
      // vICMS
      // vBCST
      //
      try
        if Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '60' then
        begin
          Form7.spdNFeDataSets.Campo('vICMSST_N23').Value     := '0';  // Isso aqui não está certo teria que remover a soma na tag CST 60
        end;

        vICMS          := vICMS + StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vICMS_N17').AsString,',',''),'.',','));
        vBC            := vBC   + StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','));
        vST            := vST   + Arredonda(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vICMSST_N23').AsString,',',''),'.',',')),2);

        if Form7.spdNFeDataSets.Campo('CST_N12').AssTring <> '60' then
        begin
          vBCST          := vBCST + StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,',',''),'.',','));
        end;

        fFCP     := fFCP + StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vFCP_N17c').AsString,',',''),'.',','));
        fFCPST   := fFCPST + StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vFCPST_N23d').AsString,',',''),'.',','));
      except
        on E: Exception do
        begin
          {
          Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+ 'ao calcular o totalizadores da NF-e Erro: 25275'
          ),'Atenção',mb_Ok + MB_ICONWARNING);
          Mauricio Parizotto 2023-10-25}
          MensagemSistema(E.Message+chr(10)+chr(10)+ 'ao calcular o totalizadores da NF-e Erro: 25275',msgErro);
        end;
      end;
    end else
    begin
      // INICIO OBS no produto na informações complementares
      Form7.spdNFeDataSets.Campo('InfAdProd_V01').Value := AllTrim(AllTrim(Form7.spdNFeDataSets.Campo('InfAdProd_V01').Value) + ' ' + ConverteAcentos2(AllTrim(Form7.ibDataSet16.FieldByname('DESCRICAO').AsString)));
      // sComplemento := sComplemento + ' ' + Form7.ibDataSet16.FieldByname('DESCRICAO').AsString;
      // FINAL OBS no produto na informações complementares
    end;

    // Veículos

    {
    <veicProd>
    <tpOp>1</tpOp>
    <chassi>9321JD5109M027807</chassi>
    <cCor>044</cCor>
    <xCor>AZUL</xCor>
    <pot>7</pot>
    <CM3>15</CM3>
    <pesoL>313.0000</pesoL>
    <pesoB>350.0000</pesoB>
    <nSerie>123456789</nSerie>
    <tpComb>GASOLINA</tpComb>
    <nMotor>JD59027807</nMotor>
    <CMKG>1</CMKG>
    <dist>16</dist>
    <RENAVAM>000011231</RENAVAM>
    <anoMod>2009</anoMod>
    <anoFab>2009</anoFab>
    <tpPint>S</tpPint>
    <tpVeic>04</tpVeic>
    <espVeic>1</espVeic>
    <VIN>N</VIN>    // Veicle Identificação Number
    <condVeic>1</condVeic> // 1-Acabado 2-Inacabado 3-Semi-Acabado
    <cMod>000001</cMod>
    </veicProd>
    }

    if Copy(Form7.ibDataSet14CFOP.AsString,1,1) = '7' then // Exportação
    begin
      // Controle de Exportação por Item
      Form7.spdNFeDataSets.IncluirPart('adi');

      // Drawback (Regime Aduaneiro Especial de Drawback)
      Mais1ini := TIniFile.Create(Form1.sAtual+'\exportac.ini');
      sEx14    := Mais1Ini.ReadString('DI','Ex14','');

      try
        sEx14 := Form1.Small_InputForm('NF-e exportação','Item: '+chr(10)+chr(10)+Form7.ibDataSet4.FieldByname('DESCRICAO').AsString+chr(10)+chr(10)+ 'Número do ato concessório de Drawback:',sEx14);
        Form7.spdNFeDataSets.Campo('nDraw_I51').Value  := sEx14;      // Número do ato concessório de Drawback

        // Nota fiscal de exportação referenciada
        if (Copy(Form7.ibDataSet16CFOP.AsString,2,3) = '503') or (Copy(Form7.ibDataSet16CFOP.AsString,2,3) = '501') then
        begin
          sEx16 := Form1.Small_InputForm('NF-e exportação','Item: '+chr(10)+chr(10)+Form7.ibDataSet4.FieldByname('DESCRICAO').AsString+chr(10)+chr(10)+ 'Número de Registro de Exportação:',sEx16);
          Form7.spdNFeDataSets.Campo('nRE_I53').Value  := sEx16;      // Número de Registro de Exportação

          sEx15 := Form1.Small_InputForm('NF-e exportação','Item: '+chr(10)+chr(10)+Form7.ibDataSet4.FieldByname('DESCRICAO').AsString+chr(10)+chr(10)+ 'Chave de Acesso da NF-e recebida para exportação:',sEx15);
          Form7.spdNFeDataSets.Campo('chNFe_I54').Value  := sEx15;      // Chave de Acesso da NF-e recebida para exportação
          Form7.spdNFeDataSets.Campo('qExport_I55').Value := StrTran(Alltrim(FormatFloat('##0.0000',Form7.ibDataSet16.FieldByname('QUANTIDADE').AsFloat)),',','.'); // Quantidade do item realmente exportado

          try
            Form7.spdNFeDataSets.IncluirPart('nRef');
            Form7.spdNFeDataSets.Campo('refNFe_BA02').Value  := sEx15;      // Chave de Acesso da NF-e recebida para exportação
            Form7.spdNFeDataSets.SalvarPart('nRef');
          except
          end;
        end;
      except
        on E: Exception do
        begin
          {
          Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+ 'ao informar Número do ato concessório de Drawback'
          ),'Atenção',mb_Ok + MB_ICONWARNING);
          Mauricio Parizotto 2023-10-25}
          MensagemSistema(E.Message+chr(10)+chr(10)+ 'ao informar Número do ato concessório de Drawback',msgErro);
        end;
      end;

      Form7.spdNFeDataSets.SalvarPart('adi');
      // Fim - The End - Controle de Exportação por Item
    end;

    // BC: BASE DE CÁLCULO DO ICMS
    // FCP: FUNDO DE COMBATE À POBREZA DO ESTADO DESTINATÁRIO
    // ALQ: ALÍQUOTA DO IMPOSTO
    // ALQ INTER: ALÍQUOTA INTERESTADUAL APLICÁVEL À OPERAÇÃO OU PRESTAÇÃO
    // ALQ INTRA: ALÍQUOTA INTERNA NA UF DE DESTINO APLICÁVEL À OPERAÇÃO OU PRESTAÇÃO
    // DIFAL: ICMS CORRESPONDENTE À DIFERENÇA ENTRE A ALÍQUOTA INTERNA DO ESTADO DESTINATÁRIO E A ALÍQUOTA INTERESTADUAL
    //
    if ((Form7.spdNFeDataSets.Campo('idDest_B11a').Value  = '2') and (Form7.spdNFeDataSets.Campo('indFinal_B25a').Value  = '1')) then
    begin
      // Calculo do DIFAL
      // vBCUFDest (R$ 1.000) X pICMSUFDest (17%) = 170
      // vBCUFDest (R$ 1.000) X pICMSInter (12%)  = 120
      // Valor do DIFAL 170 - 120 = 50
      try
        if StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',',')) >= 0.01 then
        begin
          if (Form7.ibDataSet16PICMSUFDEST.AsFloat >= 0.01) then // or (Pos('<FCP>',Form7.ibDataSet4TAGS_.AsString) <> 0) then
          begin
            Form7.spdNFeDataSets.Campo('vBCUFDest_NA03').Value         := Form7.spdNFeDataSets.Campo('vBC_N15').Value;              // Valor da BC do ICMS na UF de destino

            {Sandro Silva 2023-05-15 inicio
            if Form1.sVersaoLayout = '4.00' then
            begin
              Form7.spdNFeDataSets.campo('vBCFCPUFDest_NA04').Value := Form7.spdNFeDataSets.Campo('vBC_N15').Value; // Valor da BC FCP na UF de destino
            end;
            }
             Form7.spdNFeDataSets.campo('vBCFCPUFDest_NA04').Value := Form7.spdNFeDataSets.Campo('vBC_N15').Value; // Valor da BC FCP na UF de destino

            // fPercentualFCP
            if (Form7.ibDataSet16PFCPUFDEST.AsFloat <> 0) or (Form7.ibDataSet16PICMSUFDEST.AsFloat <> 0) then
            begin
              Form7.spdNFeDataSets.Campo('pFCPUFDest_NA05').Value        := FormatFloatXML(Form7.ibDataSet16PFCPUFDEST.AsFloat); // Percentual do ICMS relativo ao Fundo de Combate à Pobreza (FCP) na UF de destino
              Form7.spdNFeDataSets.Campo('pICMSUFDest_NA07').Value       := FormatFloatXML(Form7.ibDataSet16PICMSUFDEST.AsFloat);
              Form7.spdNFeDataSets.Campo('vFCPUFDest_NA13').Value        := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',',')) * Form7.ibDataSet16PFCPUFDEST.AsFloat / 100); // Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) da UF de destino
            end;
            //
            // Alíquota interestadual das UF envolvidas:
            // - 4% alíquota interestadual para produtos importados;
            // - 7% para os Estados de origem do Sul e Sudeste (exceto ES),
            // destinado para os Estados do Norte, Nordeste, CentroOeste
            // e Espírito Santo;
            // - 12% para os demais casos
            //
            {Sandro Silva 2023-05-18 inicio
            if (Copy(Form7.ibDataSet4CST.AsString,1,1) = '1')
            or (Copy(Form7.ibDataSet4CST.AsString,1,1) = '2')
            or (Copy(Form7.ibDataSet4CST.AsString,1,1) = '3')
            or (Copy(Form7.ibDataSet4CST.AsString,1,1) = '8') then // Produto importado
            }
            if ProdutoOrigemImportado(Copy(Form7.ibDataSet4CST.AsString, 1, 1)) then
            begin
              Form7.spdNFeDataSets.Campo('pICMSInter_NA09').Value        := '4.00'; // Alíquota interna da UF de destino
            end else
            begin
              if (pos('|'+Form7.ibDataSet13ESTADO.AsString+'|','|RS|SC|PR|SP|MG|RJ|')>0) and (pos('|'+Form7.ibDAtaset2ESTADO.AsString+'|','|RS|SC|PR|SP|MG|RJ|')=0) then
              begin
                Form7.spdNFeDataSets.Campo('pICMSInter_NA09').Value := '7.00'; // Alíquota interna da UF de destino
              end else
              begin
                Form7.spdNFeDataSets.Campo('pICMSInter_NA09').Value := '12.00'; // Alíquota interna da UF de destino
              end;
            end;

            try
              // Quando é uma NF-e referenciada pega o ano da nota referenciada se não peda da data da emissão
              if Length(LimpaNumero(Form7.spdNFeDataSets.Campo('refNFe_BA02').Value)) > 20 then
              begin
                iAnoRef := 2000+StrToInt(Copy(Form7.spdNFeDataSets.Campo('refNFe_BA02').Value,3,2));
              end else
              begin
                iAnoRef := Year(Date);
              end;
            except
              iAnoRef := Year(Date);
            end;

            if iAnoRef = 2016 then
            begin
              Form7.spdNFeDataSets.Campo('pICMSInterPart_NA11').Value    := FormatFloatXML(40);  // Percentual provisório de partilha do ICMS Interestadual
            end else
            begin
              if iAnoRef = 2017 then
              begin
                Form7.spdNFeDataSets.Campo('pICMSInterPart_NA11').Value    := FormatFloatXML(60);  // Percentual provisório de partilha do ICMS Interestadual
              end else
              begin
                if iAnoRef = 2018 then
                begin
                  Form7.spdNFeDataSets.Campo('pICMSInterPart_NA11').Value    := FormatFloatXML(80);  // Percentual provisório de partilha do ICMS Interestadual
                end else
                begin
                  if iAnoRef >= 2019 then
                  begin
                    Form7.spdNFeDataSets.Campo('pICMSInterPart_NA11').Value    := FormatFloatXML(100);  // Percentual provisório de partilha do ICMS Interestadual
                  end;
                end;
              end;
            end;

            if (StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBCUFDest_NA03').AsString,',',''),'.',',')) * StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('pICMSUFDest_NA07').AsString,',',''),'.',',')) / 100)
               > (StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBCUFDest_NA03').AsString,',',''),'.',',')) * StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('pICMSInter_NA09').AsString,',',''),'.',',')) / 100) then
            begin
              fDIFAL := (StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBCUFDest_NA03').AsString,',',''),'.',',')) * StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('pICMSUFDest_NA07').AsString,',',''),'.',',')) / 100)
                      - (StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBCUFDest_NA03').AsString,',',''),'.',',')) * StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('pICMSInter_NA09').AsString,',',''),'.',',')) / 100);
            end else
            begin
              fDIFAL := (StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBCUFDest_NA03').AsString,',',''),'.',',')) * StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('pICMSInter_NA09').AsString,',',''),'.',',')) / 100)
                      - (StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBCUFDest_NA03').AsString,',',''),'.',',')) * StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('pICMSUFDest_NA07').AsString,',',''),'.',',')) / 100)
            end;

            // fPercentualFCP
            if Form7.ibDataSet16PFCP.AsFloat <> 0 then
            begin
              Form7.spdNFeDataSets.Campo('vFCPUFDest_NA13').Value        := FormatFloatXML(StrToFloat(StrTran(StrTran('0' + Form7.spdNFeDataSets.Campo('vBC_N15').AsString, ',', ''), '.', ',')) * (Form7.ibDataSet16PFCP.AsFloat) / 100); // Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) da UF de destino
            end;
            // Percentual de ICMS Interestadual para a UF de destino:
            // - 40% em 2016;
            // - 60% em 2017;
            // - 80% em 2018;
            // - 100% a partir de 2019
            //
            if (Form7.ibDataSet16PFCP.AsFloat <> 0) and not ((Form7.spdNFeDataSets.Campo('idDest_B11a').Value  = '2') and (Form7.spdNFeDataSets.Campo('indFinal_B25a').Value  = '1')) then
            begin
              Form7.spdNFeDataSets.Campo('vICMSUFDest_NA15').Value       := '0.00';  // Valor do ICMS Interestadual para a UF de destino
              Form7.spdNFeDataSets.Campo('vICMSUFRemet_NA17').Value      := '0.00';  // Valor do ICMS Interestadual para a UF do remetente
            end else
            begin
              if iAnoRef = 2016 then
              begin
                Form7.spdNFeDataSets.Campo('vICMSUFDest_NA15').Value       := FormatFloatXML(fDIFAL*40/100);  // Valor do ICMS Interestadual para a UF de destino
                Form7.spdNFeDataSets.Campo('vICMSUFRemet_NA17').Value      := FormatFloatXML(fDIFAL*60/100);  // Valor do ICMS Interestadual para a UF do remetente
              end else
              begin
                if iAnoRef = 2017 then
                begin
                  Form7.spdNFeDataSets.Campo('vICMSUFDest_NA15').Value       := FormatFloatXML(fDIFAL*60/100);  // Valor do ICMS Interestadual para a UF de destino
                  Form7.spdNFeDataSets.Campo('vICMSUFRemet_NA17').Value      := FormatFloatXML(fDIFAL*40/100);  // Valor do ICMS Interestadual para a UF do remetente
                end else
                begin
                  if iAnoRef = 2018 then
                  begin
                    Form7.spdNFeDataSets.Campo('vICMSUFDest_NA15').Value       := FormatFloatXML(fDIFAL*80/100);  // Valor do ICMS Interestadual para a UF de destino
                    Form7.spdNFeDataSets.Campo('vICMSUFRemet_NA17').Value      := FormatFloatXML(fDIFAL*20/100);  // Valor do ICMS Interestadual para a UF do remetente
                  end else
                  begin
                    if iAnoRef >= 2019 then
                    begin
                      Form7.spdNFeDataSets.Campo('vICMSUFDest_NA15').Value       := FormatFloatXML(fDIFAL*100/100);  // Valor do ICMS Interestadual para a UF de destino
                      Form7.spdNFeDataSets.Campo('vICMSUFRemet_NA17').Value      := FormatFloatXML(fDIFAL*0/100);  // Valor do ICMS Interestadual para a UF do remetente
                    end;
                  end;
                end;
              end;
            end;

            fFCPUFDest   := fFCPUFDest   + StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vFCPUFDest_NA13').AsString,',',''),'.',','));
            fICMSUFDest  := fICMSUFDest  + StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vICMSUFDest_NA15').AsString,',',''),'.',','));
            fICMSUFREmet := fICMSUFREmet + StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vICMSUFREmet_NA17').AsString,',',''),'.',','));
          end else
          begin
            //ShowMessage('Atenção'+chr(10)+chr(10)+'Preencher nos itens da NF o valor da Alíquota Interna da UF de destino e do (FCP) Fundo de Combate a Pobreza se necessário.'+Chr(10)+Chr(10)+'Leia atentamente a mensagem acima e tente resolver o problema. Considere pedir ajuda ao seu contador para o preenchimento correto da NF-e.'); Mauricio Parizotto 2023-10-25}
            MensagemSistema('Atenção'+chr(10)+chr(10)+
                            'Preencher nos itens da NF o valor da Alíquota Interna da UF de destino e do (FCP) Fundo de Combate a Pobreza se necessário.'+Chr(10)+Chr(10)+
                            'Leia atentamente a mensagem acima e tente resolver o problema. Considere pedir ajuda ao seu contador para o preenchimento correto da NF-e.'
                            ,msgAtencao);
            Abort;
          end;
        end else
        begin
          Form7.spdNFeDataSets.Campo('vBCUFDest_NA03').Value         := '0.00'; // Valor da BC do ICMS na UF de destino
          //
          if Form1.sVersaoLayout = '4.00' then
          begin
            Form7.spdNFeDataSets.campo('vBCFCPUFDest_NA04').Value := Form7.spdNFeDataSets.Campo('vBC_N15').Value; // Valor da BC FCP na UF de destino
          end;

          Form7.spdNFeDataSets.Campo('pFCPUFDest_NA05').Value        := '0.00'; // Percentual do ICMS relativo ao Fundo de Combate à Pobreza (FCP) na UF de destino
          Form7.spdNFeDataSets.Campo('pICMSUFDest_NA07').Value       := '0.00'; // Aliquota interestadual das UF envolvidas
//                      Form7.spdNFeDataSets.Campo('pICMSInter_NA09').Value        := '0.00'; // Alíquota interna da UF de destino
          //
          // Alíquota interestadual das UF envolvidas:
          // - 4% alíquota interestadual para produtos importados;
          // - 7% para os Estados de origem do Sul e Sudeste (exceto ES),
          // destinado para os Estados do Norte, Nordeste, CentroOeste
          // e Espírito Santo;
          // - 12% para os demais casos
          //
          {Sandro Silva 2023-05-18 inicio
          if (Copy(Form7.ibDataSet4CST.AsString,1,1) = '1')
          or (Copy(Form7.ibDataSet4CST.AsString,1,1) = '2')
          or (Copy(Form7.ibDataSet4CST.AsString,1,1) = '3')
          or (Copy(Form7.ibDataSet4CST.AsString,1,1) = '8') then // Produto importado
          }
          if ProdutoOrigemImportado(Copy(Form7.ibDataSet4CST.AsString, 1, 1)) then
          begin
            Form7.spdNFeDataSets.Campo('pICMSInter_NA09').Value        := '4.00'; // Alíquota interna da UF de destino
          end else
          begin
            if (pos('|'+Form7.ibDataSet13ESTADO.AsString+'|','|RS|SC|PR|SP|MG|RJ|')>0) and (pos('|'+Form7.ibDAtaset2ESTADO.AsString+'|','|RS|SC|PR|SP|MG|RJ|')=0) then
            begin
              Form7.spdNFeDataSets.Campo('pICMSInter_NA09').Value := '7.00'; // Alíquota interna da UF de destino
            end else
            begin
              Form7.spdNFeDataSets.Campo('pICMSInter_NA09').Value := '12.00'; // Alíquota interna da UF de destino
            end;
          end;

          try
            // Quando é uma NF-e referenciada pega o ano da nota referenciada se não peda da data da emissão
            if Length(LimpaNumero(Form7.spdNFeDataSets.Campo('refNFe_BA02').Value)) > 20 then
            begin
              iAnoRef := 2000+StrToInt(Copy(Form7.spdNFeDataSets.Campo('refNFe_BA02').Value,3,2));
            end else
            begin
              iAnoRef := Year(Date);
            end;
          except
            iAnoRef := Year(Date);
          end;

          if iAnoRef = 2016 then
          begin
            Form7.spdNFeDataSets.Campo('pICMSInterPart_NA11').Value    := FormatFloatXML(40);  // Percentual provisório de partilha do ICMS Interestadual
          end else
          begin
            if iAnoRef = 2017 then
            begin
              Form7.spdNFeDataSets.Campo('pICMSInterPart_NA11').Value    := FormatFloatXML(60);  // Percentual provisório de partilha do ICMS Interestadual
            end else
            begin
              if iAnoRef = 2018 then
              begin
                Form7.spdNFeDataSets.Campo('pICMSInterPart_NA11').Value    := FormatFloatXML(80);  // Percentual provisório de partilha do ICMS Interestadual
              end else
              begin
                if iAnoRef >= 2019 then
                begin
                  Form7.spdNFeDataSets.Campo('pICMSInterPart_NA11').Value    := FormatFloatXML(100);  // Percentual provisório de partilha do ICMS Interestadual
                end;
              end;
            end;
          end;

          Form7.spdNFeDataSets.Campo('vFCPUFDest_NA13').Value        := '0.00'; // Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) da UF de destino
          Form7.spdNFeDataSets.Campo('vICMSUFDest_NA15').Value       := '0.00'; // Valor do ICMS Interestadual para a UF de destino
          Form7.spdNFeDataSets.Campo('vICMSUFRemet_NA17').Value      := '0.00'; // Valor do ICMS Interestadual para a UF do remetente
        end;
      except
        on E: Exception do
        begin
          {
          Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+'Ao calcular o Grupo de Tributação do ICMS para UF Destino item código: '+Form7.spdNFeDataSets.Campo('cProd_I02').Value+chr(10)+Form7.spdNFeDataSets.Campo('xProd_I04').Value+chr(10)+
          chr(10)+'Leia atentamente a mensagem acima e tente resolver o problema. Considere pedir ajuda ao seu contador para o preenchimento correto da NF-e.'
          ),'Atenção',mb_Ok + MB_ICONWARNING);
          Mauricio Parizotto 2023-10-25}
          MensagemSistema(E.Message+chr(10)+chr(10)+'Ao calcular o Grupo de Tributação do ICMS para UF Destino item código: '+Form7.spdNFeDataSets.Campo('cProd_I02').Value+chr(10)+Form7.spdNFeDataSets.Campo('xProd_I04').Value+chr(10)+
                          chr(10)+'Leia atentamente a mensagem acima e tente resolver o problema. Considere pedir ajuda ao seu contador para o preenchimento correto da NF-e.'
                          ,msgErro);
        end;
      end;
    end;

    // Cupom Fiscal Referenciado
    if (Copy(Form7.ibDataSet16XPED.AsString,1,2) = 'CF') and (Length(AllTrim(Form7.ibDataSet16XPED.AsString))=13) then
    begin
      try
        // CF123456CX123
        if Pos(('REF COO: '+Copy(Form7.ibDataSet16XPED.AsString,3,6)+' CAIXA: '+Copy(Form7.ibDataSet16XPED.AsString,11,3)),sCupomReferenciado) = 0 then
        begin
          Form7.spdNFeDataSets.IncluirPart('NREF');

          try
            Form7.ibQuery1.Close;
            Form7.ibQuery1.Sql.Clear;
            Form7.ibQuery1.Sql.Add('select NUMERONF, CAIXA, NFEID from NFCE where NUMERONF='+QuotedStr(Copy(Form7.ibDataSet16XPED.AsString,3,6))+' and CAIXA='+QuotedStr(Copy(Form7.ibDataSet16XPED.AsString,11,3))+' ');
            Form7.ibQuery1.Open;

            if Form7.ibQuery1.FieldByname('NFEID').AsString <> '' then
            begin
              Form7.spdNFeDataSets.Campo('refNFe_BA02').Value  := Form7.ibQuery1.FieldByname('NFEID').AsString;
            end else
            begin
              if Form7.IBQuery1.FieldByName('NUMERONF').AsString = Copy(Form7.ibDataSet16XPED.AsString,3,6) then
              begin
                Form7.spdNFeDataSets.Campo('mod_BA21').Value  := '2B'; // NFCE ou PAF
              end else
              begin
                Form7.spdNFeDataSets.Campo('mod_BA21').Value  := '2D'; // PAF ECF
              end;

              Form7.spdNFeDataSets.Campo('nECF_BA22').Value := Copy(Form7.ibDataSet16XPED.AsString,11,3);
              Form7.spdNFeDataSets.Campo('nCOO_BA23').Value := Copy(Form7.ibDataSet16XPED.AsString,3,6);
              Form7.spdNFeDataSets.SalvarPart('NREF');
            end;
          except
            Form7.spdNFeDataSets.Campo('mod_BA21').Value  := '2D'; // PAF ECF
            Form7.spdNFeDataSets.Campo('nECF_BA22').Value := Copy(Form7.ibDataSet16XPED.AsString,11,3);
            Form7.spdNFeDataSets.Campo('nCOO_BA23').Value := Copy(Form7.ibDataSet16XPED.AsString,3,6);
            Form7.spdNFeDataSets.SalvarPart('NREF');
          end;

          sCupomReferenciado := sCupomReferenciado + 'REF COO: '+Copy(Form7.ibDataSet16XPED.AsString,3,6)+' CAIXA: '+Copy(Form7.ibDataSet16XPED.AsString,11,3)+' ';
        end;
      except
        on E: Exception do
        begin
          {
          Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+'ao gravar NREF 0'
          ),'Atenção',mb_Ok + MB_ICONWARNING);
          Mauricio Parizotto 2023-10-25}
          MensagemSistema(E.Message+chr(10)+chr(10)+'ao gravar NREF 0',msgErro);
        end;
      end;
    end;
    // Fim Cupom fiscal referenciado


    {Sandro Silva 2023-10-31 inicio}
    if (Form7.spdNFeDataSets.Campo('indFinal_B25a').Value <> '1') // não é consumidor final 
    and (Trim(Form7.spdNFeDataSets.Campo('cProdANP_LA02').AsString) <> '')
    and ((StrToFloatDef(RetornaValorDaTagNoCampo('pGNn', Form7.ibDataSet4.FieldByname('TAGS_').AsString), 0) + StrToFloatDef(RetornaValorDaTagNoCampo('pGNi', Form7.ibDataSet4.FieldByname('TAGS_').AsString), 0) > 0)) // regra LA18-20
    and ((Pos('|' + Form7.spdNFeDataSets.Campo('CST_N12').AssTring + '|', '|61|') > 0) or
       (Pos('|' + Form7.spdNFeDataSets.Campo('CSOSN_N12a').AsString + '|', '|61|') > 0)) then
    begin

      try
        Application.CreateForm(TFrmOrigemCombustivel, FrmOrigemCombustivel);
        FrmOrigemCombustivel.CodigoProduto    := Form7.ibDataSet4.FieldByname('CODIGO').AsString;
        FrmOrigemCombustivel.DescricaoProduto := Form7.ibDataSet4.FieldByname('DESCRICAO').AsString;
        FrmOrigemCombustivel.UnidadeProduto   := Form7.ibDataSet4.FieldByname('MEDIDA').AsString;

        if FrmOrigemCombustivel.CDSORIGEM.IsEmpty then
          FrmOrigemCombustivel.ShowModal;
        FrmOrigemCombustivel.CDSORIGEM.First;
        while FrmOrigemCombustivel.CDSORIGEM.Eof = False do
        begin

          Form7.spdNFeDataSets.IncluirPart('LA18');
          Form7.spdNFeDataSets.Campo('indImport_LA19').Value := Trim(FrmOrigemCombustivel.CDSORIGEM.FieldByName('INDIMPORT').AsString);
          Form7.spdNFeDataSets.Campo('cUFOrig_LA20').Value   := IntToStr(Form7.spdNFe.ObterCodigoUF(AnsiUpperCase(Trim(FrmOrigemCombustivel.CDSORIGEM.FieldByName('UFORIGEM').AsString))));
          Form7.spdNFeDataSets.Campo('pOrig_LA21').Value     := FormatFloatXML(FrmOrigemCombustivel.CDSORIGEM.FieldByName('PORIGEM').AsFloat, 4);
          Form7.spdNFeDataSets.SalvarPart('LA18');

          FrmOrigemCombustivel.CDSORIGEM.Next;
        end;
        FreeAndNil(FrmOrigemCombustivel);
      except
      end;
    end;
    {Sandro Silva 2023-10-31 fim}


    Form7.ibDataSet16.Next;
  end;

  try
    {Sandro Silva 2023-05-15 inicio
    if Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value = '9' then Form7.spdNFeDataSets.Campo('IE_E17').Value          := '';
    if Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value = '2' then Form7.spdNFeDataSets.Campo('IE_E17').Value          := '';
    }
    if Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value = '9' then
      Form7.spdNFeDataSets.Campo('IE_E17').Value := '';
    if Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value = '2' then
      Form7.spdNFeDataSets.Campo('IE_E17').Value := '';
    {Sandro Silva 2023-05-15 fim}
    Form7.spdNFeDataSets.SalvarItem;
  except
    on E: Exception do
    begin
      {
      Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+'Ao salvar item código: '+Form7.spdNFeDataSets.Campo('cProd_I02').Value+chr(10)+Form7.spdNFeDataSets.Campo('xProd_I04').Value+chr(10)+
      chr(10)+'Leia atentamente a mensagem acima e tente resolver o problema. Considere pedir ajuda ao seu contador para o preenchimento correto da NF-e.'
      ),'Atenção',mb_Ok + MB_ICONWARNING);
      Mauricio Parizotto 2023-10-25}
      MensagemSistema(E.Message+chr(10)+chr(10)+'Ao salvar item código: '+Form7.spdNFeDataSets.Campo('cProd_I02').Value+chr(10)+Form7.spdNFeDataSets.Campo('xProd_I04').Value+chr(10)+
                      chr(10)+'Leia atentamente a mensagem acima e tente resolver o problema. Considere pedir ajuda ao seu contador para o preenchimento correto da NF-e.'
                      ,msgErro);
    end;
  end;

  // Totalizadores da NFe
  Form7.spdNFeDataSets.Campo('vBC_W03').Value     := FormatFloatXML(vBC); //Base de Cálculo do ICMS
  Form7.spdNFeDataSets.Campo('vICMS_W04').Value   := FormatFloatXML(vICMS); // Valor Total do ICMS

  sDIFAL_OBS := '';

  if (Form7.spdNFeDataSets.Campo('idDest_B11a').Value  = '2') and (Form7.spdNFeDataSets.Campo('indFinal_B25a').Value  = '1') then
  begin
    Form7.spdNFeDataSets.Campo('vFCPUFDest_W04c').Value   := FormatFloatXML(fFCPUFDest);    // Valor total do ICMS relativo Fundo de Combate à Pobreza (FCP) da UF de destino
    Form7.spdNFeDataSets.Campo('vICMSUFDest_W04e').Value  := FormatFloatXML(fICMSUFDest);    // Valor total do ICMS Interestadual para a UF de destino
    Form7.spdNFeDataSets.Campo('vICMSUFREmet_W04g').Value := FormatFloatXML(fICMSUFREmet);    // Valor total do ICMS Interestadual para a UF do remetente
    sDIFAL_OBS := 'Valores totais do ICMS Interestadual: DIFAL da UF destino R$'+AllTrim(Form7.spdNFeDataSets.Campo('vICMSUFDest_W04e').AsString)+' + FCP R$'+AllTrim(Form7.spdNFeDataSets.Campo('vFCPUFDest_W04c').AsString)+'; DIFAL da UF Origem R$'+AllTrim(Form7.spdNFeDataSets.Campo('vICMSUFREmet_W04g').AsString);
  end else
  begin
    if fFCPUFDest <> 0 then // Fundo de combate a probreza
    begin
      Form7.spdNFeDataSets.Campo('vFCPUFDest_W04c').Value   := FormatFloatXML(fFCPUFDest);    // Valor total do ICMS relativo Fundo de Combate à Pobreza (FCP) da UF de destino
      Form7.spdNFeDataSets.Campo('vICMSUFDest_W04e').Value  := FormatFloatXML(fICMSUFDest);    // Valor total do ICMS Interestadual para a UF de destino
      Form7.spdNFeDataSets.Campo('vICMSUFREmet_W04g').Value := FormatFloatXML(fICMSUFREmet);    // Valor total do ICMS Interestadual para a UF do remetente
      sDIFAL_OBS := 'FCP R$'+AllTrim(Form7.spdNFeDataSets.Campo('vFCPUFDest_W04c').AsString);
    end;
  end;

  Form7.spdNFeDataSets.Campo('vICMSDeson_W04a').Value    := FormatFloatXML(vICMSDeson); // Desonerado

  // No caso de nota fiscal de devolucao
  // Sandro Silva 2023-05-18 if (Form7.ibDataSet15FINNFE.AsString = '4') and (AllTrim(Form7.ibDataSet16.FieldByname('CST_IPI').AsString) = '') then
  if (NFeFinalidadeDevolucao(Form7.ibDataSet15FINNFE.AsString)) and (AllTrim(Form7.ibDataSet16.FieldByname('CST_IPI').AsString) = '') then
  begin
    Form7.spdNFeDataSets.campo('vIPIDevol_W12a').Value  := FormatFloatXML(Arredonda2(fIPIDevolvido,2)); // Valor Total do IPI devolvido
    Form7.spdNFeDataSets.Campo('vIPI_W12').Value        := '0.00'; // Valor Total do IPI
  end else
  begin
    Form7.spdNFeDataSets.campo('vIPIDevol_W12a').Value  := '0.00'; // Valor Total do IPI devolvido
    Form7.spdNFeDataSets.Campo('vIPI_W12').Value        := FormatFloatXML(Arredonda2(Form7.ibDataSet15.FieldByname('IPI').AsFloat,3)); // Valor Total do IPI
  end;

  Form7.spdNFeDataSets.campo('vFCP_W04h').Value       := FormatFloatXML(fFCP); // Valor Total do FCP (Fundo de Combate à Pobreza)
  Form7.spdNFeDataSets.campo('vFCPST_W06a').Value     := FormatFloatXML(fFCPST); // Valor Total do FCP (Fundo de Combate à Pobreza) retido por substituição tributária
  Form7.spdNFeDataSets.campo('vFCPSTRet_W06b').Value  := '0.00'; // Valor Total do FCP retido anteriormente por Substituição Tributária

  Form7.spdNFeDataSets.Campo('vBCST_W05').Value   := FormatFloatXML(vBCST - vIVA60_B_ICMST); // Valor Total do ICMS Sibst. Tributária
  Form7.spdNFeDataSets.Campo('vST_W06').Value     := FormatFloatXML(vST); // Valor Total do ICMS Sibst. Tributária

  {Sandro Silva 2023-09-04 inicio}
  Form7.spdNFeDataSets.Campo('qBCMonoRet_W06d1').Value  := FormatFloatXML(dqBCMonoRet_N43aTotal); //Valor total da quantidade tributada do ICMS monofásico retido anteriormente
  Form7.spdNFeDataSets.Campo('vICMSMonoRet_W06e').Value := FormatFloatXML(dvICMSMonoRet_N45Total); //Valor total do ICMS monofásico retido anteriormente
  {Sandro Silva 2023-09-04 fim}

  Form7.spdNFeDataSets.Campo('vFrete_W08').Value  := FormatFloatXML(Form7.ibDataSet15.FieldByname('FRETE').AsFloat); // Valor Total do Frete
  Form7.spdNFeDataSets.Campo('vSeg_W09').Value    := FormatFloatXML(Form7.ibDataSet15.FieldByname('SEGURO').AsFloat); // Valor Total do Seguro
  Form7.spdNFeDataSets.Campo('vDesc_W10').Value   := FormatFloatXML(Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat); // Valor Total de Desconto
  Form7.spdNFeDataSets.Campo('vII_W11').Value     := '0.00'; // Valor Total do II
  Form7.spdNFeDataSets.Campo('vPIS_W13').Value    := FormatFloatXML(vPIS); // Valor Toal do PIS
  Form7.spdNFeDataSets.Campo('vCOFINS_W14').Value := FormatFloatXML(vCOFINS); // Valor Total do COFINS
  Form7.spdNFeDataSets.Campo('vOutro_W15').Value  := FormatFloatXML(Form7.ibDataSet15.FieldByname('DESPESAS').AsFloat); // OUtras Despesas Acessórias

  //if Form7.ibDataSet15FINNFE.AsString = '2' then // Complemento de ICMS // Mauricio Parizotto 2023-06-05  - Entrou complento de valor
  if (Form7.ibDataSet15FINNFE.AsString = '2')
    and (Form7.ibDataSet15.FieldByname('MERCADORIA').AsFloat = 0.01) then // Complemento de ICMS
  begin
    Form7.spdNFeDataSets.Campo('vProd_W07').Value   := '0.00'; // Valor Total de Produtos e Serviços
  end else
  begin
    Form7.spdNFeDataSets.Campo('vProd_W07').Value   := FormatFloatXML(Form7.ibDataSet15.FieldByname('MERCADORIA').AsFloat); // Valor Total de Produtos e Serviços
  end;

  try
    // Recalcula o total da nota
    if StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vST_W06').AsString,',',''),'.',',')) <> 0 then
    begin
      Form7.spdNFeDataSets.Campo('vNF_W16').Value     := FormatFloatXML(
      (
        StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vProd_W07').asString  ,',',''),'.',',')) // Mercadoria
      + StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vFrete_W08').asString ,',',''),'.',',')) // Frete
      + StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vSeg_W09').asString   ,',',''),'.',',')) // Seguro
      + StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vIPI_W12').asString   ,',',''),'.',',')) // IPI
      + StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vST_W06').asString    ,',',''),'.',',')) // Valor do ICMS substituição
      + StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vOutro_W15').asString ,',',''),'.',',')) // Despesas
      + StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vFCPST_W06a').asString ,',',''),'.',','))// Valor Total do FCP (Fundo de Combate à Pobreza) retido por substituição tributária
      - StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vDesc_W10').asString  ,',',''),'.',',')) // Desconto
      + Form7.ibDataSet15SERVICOS.AsFloat
      + fIPIDevolvido)
      ) ;

      // Valor Total da NFe
      // Ficou fora a retenção
    end else
    begin
      Form7.spdNFeDataSets.Campo('vNF_W16').Value     := FormatFloatXML(Form7.ibDataSet15.FieldByname('TOTAL').AsFloat);
    end;
  except
    on E: Exception do
    begin
      //Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);Mauricio Parizotto 2023-10-25
      MensagemSistema(E.Message,msgErro);
    end;
  end;

  if Form1.sVersaoLayout = '4.00' then
  begin
    // Nesta nova versão não haverá alteração no leiaute do DANFE. As informações relativas ao Fundo de Combate à Pobreza (FCP) devem ser informadas:
    // - Os valores de totais do FCP (id: W04b e W06a) devem ser informados em "Informações Adicionais de Interesse do Fisco, campo "infAdFisco", quando existirem.
    if StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vFCP_W04h').AsString,',',''),'.',','))       <> 0 then Form7.spdNFeDataSets.campo('infAdFisco_Z02').Value := AllTrim(Form7.spdNFeDataSets.campo('infAdFisco_Z02').Value  + ' vFCP '  + Form7.spdNFeDataSets.campo('vFCP_W04h').Value);
    if StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vFCPST_W06a').AsString,',',''),'.',','))     <> 0 then Form7.spdNFeDataSets.campo('infAdFisco_Z02').Value := AllTrim(Form7.spdNFeDataSets.campo('infAdFisco_Z02').Value  + ' vFCPST ' + Form7.spdNFeDataSets.campo('vFCPST_W06a').Value);
  end;

  if Form7.ibDataSet15FINNFE.AsString = '2' then // Complemento de ICMS
  begin
    if Form7.ibDataSet15.FieldByname('MERCADORIA').AsFloat = 0.01 then
    begin
      Form7.spdNFeDataSets.Campo('vNF_W16').Value     := '0.00'; // Valor Total de Produtos e Serviços
    end;
  end;

  // ISSQN
  if Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat >= 0.01 then
  begin
    Form7.ibDataSet14.First;
    while (Form7.ibDataSet14ISS.AsFloat = 0) and ( not Form7.ibDataSet14.EOF) do
      Form7.ibDataSet14.Next;
    if Form7.ibDataSet14ISS.AsFloat = 0 then
      Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);

    try
      Form7.ibDataSet35.First;
      while not Form7.ibDataSet35.Eof do
      begin
        Form7.ibDataSet4.Close;
        Form7.ibDataSet4.Selectsql.Clear;
        Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(Form7.ibDataSet35DESCRICAO.AsString)+' ');  //
        Form7.ibDataSet4.Open;

        I := I + 1;

        Form7.spdNFeDataSets.IncluirItem;

        // Informações Referentes aos ITens da NFe
        Form7.spdNFeDataSets.Campo('nItem_H02').Value := IntToStr(I); // Número do Item da NFe (1 até 990)

        // Dados do Produto Vendido
        Form7.spdNFeDataSets.Campo('cProd_I02').Value    := '0000000000000'; //Código do PRoduto ou Serviço
        Form7.spdNFeDataSets.Campo('cEAN_I03').Value     := 'SEM GTIN'; // EAN do Produto
        Form7.spdNFeDataSets.Campo('xProd_I04').Value    := Alltrim(ConverteAcentos2(Form7.ibDataSet35.FieldByname('DESCRICAO').AsString));// Descrição do Servico

        Form7.spdNFeDataSets.Campo('NCM_I05').Value      := '00'; // Código do NCM - informar de acordo com o Tabela oficial do NCM
        Form7.spdNFeDataSets.Campo('CFOP_I08').Value     := sDentroOuForadoEStado+'933'; //  Prestação de serviço, cujo imposto é de competência municipal, desde que informado em Nota Fiscal modelo 1 ou 1-A. (NR Ajuste SINIEF 06/2005)a partir de 01/01/2006

        Form7.spdNFeDataSets.Campo('uCom_I09').Value     := 'UND';
        Form7.spdNFeDataSets.Campo('qCom_I10').Value     := StrTran(Form7.ibDataSet35.FieldByname('QUANTIDADE').AsString,',','.'); // Quantidade Comercializada do Item
        Form7.spdNFeDataSets.Campo('vUnCom_I10a').Value  := StrTran(Alltrim(FormatFloat('##0.'+Replicate('0',StrToInt(Form1.ConfPreco)),Form7.ibDataSet35.FieldByname('UNITARIO').AsFloat)),',','.'); // Valor Comercializado do Item
        Form7.spdNFeDataSets.Campo('vProd_I11').Value    := FormatFloatXML(Form7.ibDataSet35.FieldByname('TOTAL').AsFloat); // Valor Total Bruto do Item
        Form7.spdNFeDataSets.Campo('cEANTrib_I12').Value := 'SEM GTIN'; // EAN do Produto

        // ISS
        Form7.spdNFeDataSets.Campo('uTrib_I13').Value     := 'UND'; // Unidade de Medida Tributável do Item
        Form7.spdNFeDataSets.Campo('qTrib_I14').Value     := StrTran(Form7.ibDataSet35.FieldByname('QUANTIDADE').AsString,',','.');  // Quantidade Tributável do Item
        Form7.spdNFeDataSets.Campo('vUnTrib_I14a').Value  := StrTran(Alltrim(FormatFloat('##0.0000',Form7.ibDataSet35.FieldByname('UNITARIO').AsFloat)),',','.'); // Valor Tributável do Item
        Form7.spdNFeDataSets.Campo('indTot_I17b').Value   := '0'; // 0 - O valor do Item NÃO compõe o valor total da nota 1 - O valor do Item compõe o valor total da nota
        Form7.spdNFeDataSets.Campo('orig_N11').Value      := '0'; // Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)

        // Serviços

        // De olho no imposto Serviços
        Form7.spdNFeDataSets.Campo('vTotTrib_M02').Value  :=  StrTran(Alltrim(FormatFloat('##0.00',
        Arredonda(((Form7.ibDataSet35.FieldByname('TOTAL').AsFloat)*Form7.ibDataSet4.FieldByname('IIA').AsFloat/100),2) +    // Federais
        Arredonda(((Form7.ibDataSet35.FieldByname('TOTAL').AsFloat)*Form7.ibDataSet4.FieldByname('IIA_UF').AsFloat/100),2) + // Estaduais
        Arredonda(((Form7.ibDataSet35.FieldByname('TOTAL').AsFloat)*Form7.ibDataSet4.FieldByname('IIA_MUNI').AsFloat/100),2) // Municipais
        )),',','.'); // Valor aproximado total de tributos


        // Federais
        fTotaldeTriubutos := fTotaldeTriubutos +
        Arredonda(((Form7.ibDataSet35.FieldByname('TOTAL').AsFloat)*Form7.ibDataSet4.FieldByname('IIA').AsFloat/100),2);
        //
        // Estaduais
        fTotaldeTriubutos_uf := fTotaldeTriubutos_uf +
        Arredonda(((Form7.ibDataSet35.FieldByname('TOTAL').AsFloat)*Form7.ibDataSet4.FieldByname('IIA_UF').AsFloat/100),2);
            
        // Municipais
        fTotaldeTriubutos_muni := fTotaldeTriubutos_muni +
        Arredonda(((Form7.ibDataSet35.FieldByname('TOTAL').AsFloat)*Form7.ibDataSet4.FieldByname('IIA_MUNI').AsFloat/100),2);

        Form7.spdNFeDataSets.Campo('vBC_U02').Value       := StrTran(Alltrim(FormatFloat('##0.00', Form7.ibDataSet14.FieldByname('BAseISS').AsFloat * Form7.ibDataSet35.FieldByname('TOTAL').AsFloat / 100)),',','.'); // Valor da BC do ISSSQN
        Form7.spdNFeDataSets.Campo('vAliq_U03').Value     := FormatFloatXML(Form7.ibDataSet14.FieldByname('ISS').AsFloat);  // Aliquota de ISSQN
        Form7.spdNFeDataSets.Campo('vISSQN_U04').Value    := FormatFloatXML(Form7.ibDataSet35.FieldByname('ISS').AsFloat);// Valor do ISSQN
        Form7.spdNFeDataSets.Campo('cMunFG_U05').Value    := Copy(IBQUERY99.FieldByname('CODIGO').AsString,1,7); // Código do município IBGE;

        if RetornaValorDaTagNoCampo('cListServ',Form7.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then
        begin
          Form7.spdNFeDataSets.Campo('cListServ_U06').Value := RetornaValorDaTagNoCampo('cListServ',Form7.ibDataSet4.FieldByname('TAGS_').AsString); // Item da lista de serviços; Padrão ABRASF
        end else
        begin
          Form7.spdNFeDataSets.Campo('cListServ_U06').Value := '14.01'; // Item da lista de serviços; Padrão ABRASF
        end;

        Form7.spdNFeDataSets.Campo('indISS_U12').Value        := '1'; // Indicador da exigibilidade do ISS 1-Exigível; 2-Não incidente; 3-Isenção; 4-Exportação; 5-Imunidade; 6-Exig.Susp. Judicial; 7-Exig.Susp. ADM

        if AllTrim(RetornaValorDaTagNoCampo('cServico',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
        begin
          Form7.spdNFeDataSets.Campo('cServico_U13').Value      := AllTrim(RetornaValorDaTagNoCampo('cServico',Form7.ibDataSet4.FieldByname('TAGS_').AsString)); // Código do serviço prestado dentro do município
        end else
        begin
          Form7.spdNFeDataSets.Campo('cServico_U13').Value      := '00000000000000000001'; // Código do serviço prestado dentro do município
        end;

        Form7.spdNFeDataSets.Campo('cMun_U14').Value          := Form7.spdNFeDataSets.Campo('cMun_E10').Value; // Valor outras retenções Tabela do IBGE. Informar “9999999” para serviço fora do Pais.
        Form7.spdNFeDataSets.Campo('cPais_U15').Value         := '1058'; // Código do país onde o serviço foi prestado no caso Brasil
        Form7.spdNFeDataSets.Campo('nProcesso_U16').Value      := '';    // Número do Processo administrativo ou judicial de suspenção do processo Informar somente quando declarada a suspensão da exigibilidade do ISSQN.
        Form7.spdNFeDataSets.Campo('indIncentivo_U17').Value   := '2';   // indIncentivo Indicador de incentivo Fiscal 1 – SIm; 2 – Não;

        // PIS Sobre Serviços
        if (rpPIS * bcPISCOFINS_op <> 0) then
        begin
          vBC_PIS := bcPISCOFINS_op * Form7.ibDataSet35.FieldByname('TOTAL').AsFloat / 100;
          Form7.spdNFeDataSets.Campo('CST_Q06').Value   := Form7.ibDataSet14.FieldByname('CSTPISCOFINS').AsString; // Codigo de Situacao Tributária PIS - ver opções no Manual
          Form7.spdNFeDataSets.Campo('vBC_Q07').Value   := FormatFloatXML(vBC_PIS); // Valor da Base de Cálculo do PIS
          Form7.spdNFeDataSets.Campo('pPIS_Q08').Value  := FormatFloatXML(rpPIS); // Alíquota em Percencual do PIS
          Form7.spdNFeDataSets.Campo('vPIS_Q09').Value  := FormatFloatXML(rpPIS * bcPISCOFINS_op * Form7.ibDataSet35.FieldByname('TOTAL').AsFloat / 100 / 100);  // Valor do PIS sobre serviços
          vPIS_S := vPIS_S + Arredonda(rpPIS * bcPISCOFINS_op * Form7.ibDataSet35.FieldByname('TOTAL').AsFloat / 100 / 100,2);
        end else
        begin
          vBC_PIS := 0;
          Form7.spdNFeDataSets.Campo('CST_Q06').Value   := '08';   // Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',1,2); // Codigo de Situacao Tributária - ver opções no Manual
          Form7.spdNFeDataSets.Campo('vBC_Q07').Value   := '0.00'; // Valor da Base de Cálculo do PIS
          Form7.spdNFeDataSets.Campo('pPIS_Q08').Value  := '0.00'; // Alíquota em Percencual do PIS
          Form7.spdNFeDataSets.Campo('vPIS_Q09').Value  := '0.00';  // Valor do PIS sobre serviços
        end;
            
        // COFINS Sobre Serviços
        if (rpCOFINS * bcPISCOFINS_op <> 0) then
        begin
          Form7.spdNFeDataSets.Campo('CST_S06').Value     := Form7.ibDataSet14.FieldByname('CSTPISCOFINS').AsString;  // Código de Situacao Tributária COFINS - ver opções no Manual
          Form7.spdNFeDataSets.Campo('vBC_S07').Value     := FormatFloatXML(bcPISCOFINS_op * Form7.ibDataSet35.FieldByname('TOTAL').AsFloat / 100 ); // Valor da Base de Cálculo do COFINS
          Form7.spdNFeDataSets.Campo('pCOFINS_S08').Value := FormatFloatXML(rpCOFINS); // Alíquota do COFINS em Percentual
          Form7.spdNFeDataSets.Campo('vCOFINS_S11').Value := FormatFloatXML(rpCOFINS * bcPISCOFINS_op * Form7.ibDataSet35.FieldByname('TOTAL').AsFloat / 100 / 100); // Valor do COFINS em Reais

          vCOFINS_S := vCOFINS_S + arredonda(rpCOFINS * bcPISCOFINS_op * Form7.ibDataSet35.FieldByname('TOTAL').AsFloat / 100 / 100,2);
        end else
        begin
          Form7.spdNFeDataSets.Campo('CST_S06').Value     := '08'; // Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',1,2); // Código de Situacao Tributária - ver opções no Manual
          Form7.spdNFeDataSets.Campo('vBC_S07').Value     := '0.00'; // Valor da Base de Cálculo do COFINS
          Form7.spdNFeDataSets.Campo('pCOFINS_S08').Value := '0.00'; // Alíquota do COFINS em Percentual
          Form7.spdNFeDataSets.Campo('vCOFINS_S11').Value := '0.00'; // Valor do COFINS em Reais
        end;

        if Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value = '9' then
          Form7.spdNFeDataSets.Campo('IE_E17').Value          := '';
        if Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value = '2' then
          Form7.spdNFeDataSets.Campo('IE_E17').Value          := '';

        Form7.spdNFeDataSets.SalvarItem;

        Form7.ibDataSet35.Next;
      end;

      Form7.spdNFeDataSets.Campo('vServ_W18').Value   := FormatFloatXML(Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat); // Valor Total de serviços

      Form7.ibDataSet14.DisableControls;
      Form7.ibDataSet14.Close;
      Form7.ibDataSet14.SelectSQL.Clear;
      Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
      Form7.ibDataSet14.Open;
      Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);
      Form7.ibDataSet14.EnableControls;

      if (Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat <>  0) then
      begin
        if (Form7.ibDataSet14.FieldByname('BASEISS').AsFloat * Form7.ibDataSet14.FieldByname('ISS').AsFloat) =  0 then
        begin
          Form7.ibDataSet14.First;
          while (Form7.ibDataSet14ISS.AsFloat = 0) and ( not Form7.ibDataSet14.EOF) do Form7.ibDataSet14.Next;
          if Form7.ibDataSet14ISS.AsFloat = 0 then
            Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);
        end;

        if (Form7.ibDataSet14.FieldByname('BASEISS').AsFloat * Form7.ibDataSet14.FieldByname('ISS').AsFloat) <>  0 then
        begin
          Form7.spdNFeDataSets.Campo('vBC_W19').Value        := FormatFloatXML(Form7.ibDataSet14.FieldByname('BAseISS').AsFloat * Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat / 100); // Base de calculo do ISS
          Form7.spdNFeDataSets.Campo('vISS_W20').Value       := FormatFloatXML(Form7.ibDataSet15.FieldByname('ISS').AsFloat); // Valor Total de ISS
        end;

        // Pis Sobre Serviços
        if (rpPIS * bcPISCOFINS_op <> 0) then
        begin
          Form7.spdNFeDataSets.Campo('vPIS_W21').Value  :=  FormatFloatXML(vPIS_S);  // Valor do PIS sobre serviços
        end;

        // COFINS Sobre Serviços
        if (rpCOFINS * bcPISCOFINS_op <> 0) then
        begin
          Form7.spdNFeDataSets.Campo('vCOFINS_W22').Value  :=  FormatFloatXML(vCOFINS_S);  // Valor do COFINS sobre serviços
        end;

        Form7.spdNFeDataSets.Campo('dCompet_W22a').Value       := StrTran(DateToStrInvertida(Date),'/','-')+'T'+TimeToStr(Time)+Form7.sFuso;
      end;

      // Imposto de renda: Se o valor for maior do que o Teto limite para tributação de IR sobre serviços tributa: Servicos >= ConfLimite then IR = Servicos * (( ConfIR / 100) * 1) else IR = 0;
      try
        if Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat >= Form1.ConfLimite  then
        begin
          Form7.spdNFeDataSets.Campo('vBCIRRF_W27').Value := FormatFloatXML(Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat); // Base de Cálculo do IRRF
          Form7.spdNFeDataSets.Campo('vIRRF_W28').Value   := FormatFloatXML(Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat * ((Form1.ConfIR / 100) * 1)); // Valor Retido do IRRF
        end;
      except
      end;
    except
      on E: Exception do
      begin
        {
        Application.MessageBox(pChar(E.Message+chr(10)+
        chr(10)+'Ao informar serviços.'+
        chr(10)+'Leia atentamente a mensagem acima e tente resolver o problema. Considere pedir ajuda ao seu contador para o preenchimento correto da NF-e.'
        ),'Atenção',mb_Ok + MB_ICONWARNING);
        Mauricio Parizotto 2023-10-25}
        MensagemSistema(E.Message+chr(10)+
                        chr(10)+'Ao informar serviços.'+
                        chr(10)+'Leia atentamente a mensagem acima e tente resolver o problema. Considere pedir ajuda ao seu contador para o preenchimento correto da NF-e.'
                        ,msgErro);

        Form7.ibDataSet15.Edit;
        Form7.ibDataSet15STATUS.AsString    := 'Erro: Ao salvar XML.';
        Abort;
      end;
    end;
  end;

  // Valor aproximado total de tributos
  if Copy(Form7.ibDataSet14CFOP.AsString,1,1) <> '7' then // Exportação
//              if Form7.ibDAtaset2ESTADO.AsString <> 'EX' then
  begin
    if (fTotaldeTriubutos + fTotaldeTriubutos_uf + fTotaldeTriubutos_muni) > 0 then
    begin
      Form7.spdNFeDataSets.Campo('vTotTrib_W16a').Value  := FormatFloatXML(fTotaldeTriubutos + fTotaldeTriubutos_uf + fTotaldeTriubutos_muni ); // Valor aproximado total de tributos

      if fTotaldeTriubutos + fTotaldeTriubutos_uf + fTotaldeTriubutos_muni <> 0 then
      begin
        sComplemento := sComplemento + 'Trib aprox R$: ';
      end;

      if fTotaldeTriubutos <> 0 then
        sComplemento := sComplemento + Alltrim(FormatFloat('##0.00', fTotaldeTriubutos )) + ' Federal ';
      if fTotaldeTriubutos_uf <> 0 then
        sComplemento := sComplemento + Alltrim(FormatFloat('##0.00', fTotaldeTriubutos_uf )) + ' Estadual ';
      if fTotaldeTriubutos_muni <> 0 then
        sComplemento := sComplemento + Alltrim(FormatFloat('##0.00', fTotaldeTriubutos_muni )) + ' Municipal ';

      if fTotaldeTriubutos + fTotaldeTriubutos_uf + fTotaldeTriubutos_muni <> 0 then
      begin
        Form7.ibQuery3.Close;
        Form7.ibQuery3.SQL.Clear;
        Form7.ibQuery3.SQL.Add('select first 1 FONTE, CHAVE from IBPT_');
        Form7.ibQuery3.Open;

        sComplemento := sComplemento + 'Fonte: ' + alltrim(Form7.ibQuery3.FieldByname('FONTE').AsString) + ' ' + AllTrim(Form7.ibQuery3.FieldByname('CHAVE').AsString);
      end;
    end;
  end;

  // Dados do Transporte da NFe
  Form7.spdNFeDataSets.Campo('modFrete_X02').Value := Alltrim(Form7.ibDataSet15.FieldByname('FRETE12').AsString);

  if AllTrim(Form7.ibDataSet15TRANSPORTA.AsString)<>'' then
  begin
    {if (Length(AllTrim(Form7.ibDataSet18.FieldByname('CGC').AsString)) = 0) then
    begin
      Form7.ibDataSet15.Edit;
      Form7.ibDataSet15STATUS.AsString    := 'Erro: CNPJ da transportadora inválido';
      Abort;
    end; Ficha 6820}

    if (Length(AllTrim(Form7.ibDataSet18.FieldByname('CGC').AsString)) = 18) then
    begin
      if LimpaNumero(Form7.ibDataSet18IE.AsString) <> '' then
      begin
        if ConsisteInscricaoEstadual(LimpaNumero(Form7.ibDataSet18IE.AsString),Form7.ibDataSet18UF.AsString) then
        begin
          Form7.ibDataSet15.Edit;
          Form7.ibDataSet15STATUS.AsString    := 'Erro: Inscrição Estadual da transportadora Inválida.';

          Abort;
        end;
      end;
    end;

    if (Length(AllTrim(Form7.ibDataSet18.FieldByname('CGC').AsString)) = 18) then
    begin
      Form7.spdNFeDataSets.Campo('CNPJ_X04').Value     := LimpaNumero(Form7.ibDataSet18.FieldByname('CGC').AsString); // CNPJ do Transportador
    end else
    begin
      Form7.spdNFeDataSets.Campo('CPF_X05').Value     := LimpaNumero(Form7.ibDataSet18.FieldByname('CGC').AsString); // CNPJ do Transportador
    end;

    Form7.spdNFeDataSets.Campo('xNome_X06').Value    := ConverteAcentosNome(Form7.ibDataSet18.FieldByname('NOME').AsString); // Nome do Transportador

    if AllTrim(Form7.ibDataSet18.FieldByname('IE').AsString) <> '' then
    begin
      if UpperCase(Form7.ibDataSet18.FieldByname('IE').AsString)='ISENTO' then
      begin
        Form7.spdNFeDataSets.Campo('IE_X07').Value       := 'ISENTO'; //  Inscrição estadual do Transportador
      end else
      begin
        Form7.spdNFeDataSets.Campo('IE_X07').Value       := LimpaNumero(Form7.ibDataSet18.FieldByname('IE').AsString); //  Inscrição estadual do Transportador
      end;
    end;

    Form7.spdNFeDataSets.Campo('xEnder_X08').Value   := ConverteAcentos2(Form7.ibDataSet18.FieldByname('ENDERECO').AsString); // Endereço do Transportador
    Form7.spdNFeDataSets.Campo('xMun_X09').Value     := ConverteAcentos2(Form7.ibDataSet18.FieldByname('MUNICIPIO').AsString); // Nome do Município do Transportador
    Form7.spdNFeDataSets.Campo('UF_X10').Value       := Form7.ibDataSet18.FieldByname('UF').AsString; // Sigla do Estado do Transportador

    if Length(StrTran(StrTran(Form7.ibDataSet15.FieldByname('PLACA').AsString,' ',''),'-','')) = 7 then
    begin
      Form7.spdNFeDataSets.Campo('placa_X19').Value    := StrTran(StrTran(Form7.ibDataSet15.FieldByname('PLACA').AsString,' ',''),'-',''); // Placa do Veículo
      Form7.spdNFeDataSets.Campo('uf_X20').Value       := Form7.ibDataSet18.FieldByname('ESTADO').AsString; // Sigla do Estado da Placa do Veículo
      Form7.spdNFeDataSets.Campo('rntc_X21').Value     := Form7.ibDataSet18.FieldByname('ANTT').AsString; // Registro nacional de Trasportador de Cargas (ANTT)
    end;
  end else
  begin
    Form7.spdNFeDataSets.Campo('CNPJ_X04').Value     := ''; // CNPJ do Transportador
    Form7.spdNFeDataSets.Campo('CPF_X05').Value      := ''; // CNPJ do Transportador
    Form7.spdNFeDataSets.Campo('xNome_X06').Value    := ''; // Nome do Transportador
    Form7.spdNFeDataSets.Campo('IE_X07').Value       := ''; //  Inscrição estadual do Transportador
    Form7.spdNFeDataSets.Campo('xEnder_X08').Value   := ''; // Endereço do Transportador
    Form7.spdNFeDataSets.Campo('xMun_X09').Value     := ''; // Nome do Município do Transportador
    Form7.spdNFeDataSets.Campo('UF_X10').Value       := ''; // Sigla do Estado do Transportador
    Form7.spdNFeDataSets.Campo('placa_X19').Value    := ''; // Placa do Veículo
    Form7.spdNFeDataSets.Campo('uf_X20').Value       := ''; // Sigla do Estado da Placa do Veículo
    Form7.spdNFeDataSets.Campo('rntc_X21').Value     := ''; // Registro nacional de Trasportador de Cargas (ANTT)
  end;

  {Sandro Silva 2023-06-29 inicio
  if Form1.sVersaoLayout = '4.00' then
  begin
    Form7.spdNFeDataSets.IncluirPart('YA');
    //
    // 01=Dinheiro
    // 02=Cheque
    // 03=Cartão de Crédito
    // 04=Cartão de Débito
    // 05=Crédito Loja
    // 10=Vale Alimentação
    // 11=Vale Refeição
    // 12=Vale Presente
    // 13=Vale Combustível
    // * Removida * 14=Duplicata Mercantil *
    // 15=Boleto Bancário
    // 90= Sem pagamento
    // 99=Outros
    //


    if (Form7.spdNFeDataSets.Campo('finNFe_B25').Value = '4') or (Form7.spdNFeDataSets.Campo('finNFe_B25').Value = '3') or (Form7.spdNFeDataSets.Campo('finNFe_B25').Value = '2') then // Finalidade da NFe (1-Normal, 2-Complementar, 3-de Ajuste, 4-Devolução de mercadoria)
    begin
//                  Form7.spdNFeDataSets.campo('indPag_YA01b').Value    := '0';   // Pagamento a vista
      Form7.spdNFeDataSets.campo('tPag_YA02').Value       := '90';  // Sem Pagamento
    end else
    begin
      Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);

      if Copy(Uppercase(Form7.ibDataSet14.FieldByname('INTEGRACAO').AsString)+'       ',1,7) = 'RECEBER' then
      begin
//                    Form7.spdNFeDataSets.campo('indPag_YA01b').Value    := '1';   // Pagamento a prazo
//                  Form7.spdNFeDataSets.campo('tPag_YA02').Value       := '05';  // Forma de pagamento
        // Sandro Silva 2023-06-20 Form7.spdNFeDataSets.campo('tPag_YA02').Value       := '14';  // Duplicata Mercantil
        Form7.spdNFeDataSets.campo('tPag_YA02').Value       := '14';  // 14-Duplicata Mercantil
      end else
      begin
//                    Form7.spdNFeDataSets.campo('indPag_YA01b').Value    := '0';   // Pagamento a vista
        Form7.spdNFeDataSets.campo('tPag_YA02').Value       := '01';  // Forma de pagamento
      end;
    end;
    //
    if Form7.spdNFeDataSets.campo('tPag_YA02').Value = '90' then
    begin
      // Sem Pagamento
      Form7.spdNFeDataSets.campo('vPag_YA03').Value       := '0.00';
//                  Form7.spdNFeDataSets.campo('vTroco_YA09').Value     := '0.00';  // valor do troco
    end else
    begin
      Form7.spdNFeDataSets.campo('vPag_YA03').Value       :=  Form7.spdNFeDataSets.Campo('vNF_W16').Value;
      Form7.spdNFeDataSets.campo('vTroco_YA09').Value     := '0.00';  // valor do troco
    end;

    if False then
    begin
      // Se for Cartão
      Form7.spdNFeDataSets.campo('tpIntegra_YA04a').Value := '2';  // Tipo de Integração para pagamento
      Form7.spdNFeDataSets.campo('CNPJ_YA05').Value       := '';  // CNPJ da Credenciadora de cartão de crédito e/ou débito
      Form7.spdNFeDataSets.campo('tBand_YA06').Value      := '';  // Bandeira da operadora de cartão de crédito e/ou débito
      Form7.spdNFeDataSets.campo('cAut_YA07').Value       := '';  // Número de autorização da operação cartão de crédito e/ou débito
    end;

    Form7.spdNFeDataSets.SalvarPart('YA');
  end;
  }
  if (Form7.spdNFeDataSets.Campo('finNFe_B25').Value = '4') or (Form7.spdNFeDataSets.Campo('finNFe_B25').Value = '3') or (Form7.spdNFeDataSets.Campo('finNFe_B25').Value = '2') then // Finalidade da NFe (1-Normal, 2-Complementar, 3-de Ajuste, 4-Devolução de mercadoria)
  begin
    Form7.spdNFeDataSets.IncluirPart('YA');
    Form7.spdNFeDataSets.campo('tPag_YA02').Value       := '90';  // Sem Pagamento
    Form7.spdNFeDataSets.campo('vPag_YA03').Value       := '0.00';
    //                  Form7.spdNFeDataSets.campo('vTroco_YA09').Value     := '0.00';  // valor do troco

    Form7.spdNFeDataSets.SalvarPart('YA');
  end
  else
  begin

    Form7.ibDataSet7.First;
    stPag_YA02 := '';
    IBQCREDENCIADORA := Form7.CriaIBQuery(Form7.ibDataSet7.Transaction);
    while not Form7.ibDataSet7.Eof do
    begin

      Form7.spdNFeDataSets.IncluirPart('YA');
      //
      // 01=Dinheiro
      // 02=Cheque
      // 03=Cartão de Crédito
      // 04=Cartão de Débito
      // 05=Crédito Loja
      // 10=Vale Alimentação
      // 11=Vale Refeição
      // 12=Vale Presente
      // 13=Vale Combustível
      // * Removida * 14=Duplicata Mercantil *
      // 15=Boleto Bancário
      // 90= Sem pagamento
      // 99=Outros
      //

      if Trim(Form7.ibDataSet7FORMADEPAGAMENTO.AsString) = '' then
        stPag_YA02 := '' 
      else
        stPag_YA02 := IdFormasDePagamentoNFe(Trim(Form7.ibDataSet7FORMADEPAGAMENTO.AsString)); // Sandro Silva 2023-07-13 stPag_YA02 := Copy(Trim(Form7.ibDataSet7FORMADEPAGAMENTO.AsString), 1, 2);
      if stPag_YA02 = '' then
        stPag_YA02 := '14'; // 14=Duplicata Mercantil

      Form7.spdNFeDataSets.campo('tPag_YA02').Value       := stPag_YA02;  // Forma de pagamento
      {Sandro Silva 2023-07-20 inicio}
      if stPag_YA02 = '99' then
        Form7.spdNFeDataSets.campo('xPag_YA02a').Value       := 'Outras Formas';
      {Sandro Silva 2023-07-20 fim}
      Form7.spdNFeDataSets.campo('vPag_YA03').Value       := FormatFloatXML(Form7.ibDataSet7VALOR_DUPL.AsFloat);

      //if (Copy(Form7.ibDataSet7FORMADEPAGAMENTO.AsString, 1, 2) = '03') or (Copy(Form7.ibDataSet7FORMADEPAGAMENTO.AsString, 1, 2) = '04') then
      if FormaDePagamentoEnvolveCartao(Form7.ibDataSet7FORMADEPAGAMENTO.AsString) then
      begin
        IBQCREDENCIADORA.Close;
        IBQCREDENCIADORA.SQL.Text :=
          'select * ' +
          'from CLIFOR ' +
          'where NOME = ' + QuotedStr(Form7.ibDataSet7INSTITUICAOFINANCEIRA.AsString);
        IBQCREDENCIADORA.Open;
        // Se for Cartão
        Form7.spdNFeDataSets.campo('tpIntegra_YA04a').Value := '2';  // Tipo de Integração para pagamento
        Form7.spdNFeDataSets.campo('CNPJ_YA05').Value       := LimpaNumero(IBQCREDENCIADORA.FieldByName('CGC').AsString);  // CNPJ da Credenciadora de cartão de crédito e/ou débito
        Form7.spdNFeDataSets.campo('tBand_YA06').Value      := CodigotBandNF(Form7.ibDataSet7BANDEIRA.AsString);  // Bandeira da operadora de cartão de crédito e/ou débito
        Form7.spdNFeDataSets.campo('cAut_YA07').Value       := Copy(Form7.ibDataSet7AUTORIZACAOTRANSACAO.AsString, 1, 20);  // Número de autorização da operação cartão de crédito e/ou débito
      end;

      Form7.spdNFeDataSets.SalvarPart('YA');

      Form7.ibDataSet7.Next;
    end;
    FreeAndNil(IBQCREDENCIADORA);
    if stPag_YA02 = '' then
    begin
      Form7.spdNFeDataSets.campo('tPag_YA02').Value       := '01';  // Forma de pagamento
      Form7.spdNFeDataSets.campo('vPag_YA03').Value       :=  Form7.spdNFeDataSets.Campo('vNF_W16').Value;
    end;
    Form7.spdNFeDataSets.campo('vTroco_YA09').Value     := '0.00';  // valor do troco

  end;
  {Sandro Silva 2023-06-29 fim}

  if Form7.ibDataSet15FINNFE.AsString <> '2' then
  begin
    // Dados da Carga Transportada
    Form7.spdNFeDataSets.Campo('qVol_X27').Value     := LimpaNumero(Form7.ibDataSet15.FieldByname('VOLUMES').AsString); // Quantidade de Volumes transportados
    Form7.spdNFeDataSets.Campo('esp_X28').Value      := ConverteAcentos2(Form7.ibDataSet15.FieldByname('ESPECIE').AsString); // Espécie de Carga Transportada
    Form7.spdNFeDataSets.Campo('marca_X29').Value    := ConverteAcentos2(Form7.ibDataSet15.FieldByname('MARCA').AsString); // MArca da Carga Transportada
    Form7.spdNFeDataSets.Campo('nVol_X30').Value     := ConverteAcentos2(Form7.ibDataSet15.FieldByname('NVOL').AsString);; // Numeração dos Volumes transportados

    Form7.spdNFeDataSets.Campo('pesoL_X31').Value    := StrTran(Alltrim(FormatFloat('##0.000',Form7.ibDataSet15.FieldByname('PESOLIQUI').AsFloat)),',','.'); // Peso Líquido
    Form7.spdNFeDataSets.Campo('pesoB_X32').Value    := StrTran(Alltrim(FormatFloat('##0.000',Form7.ibDataSet15.FieldByname('PESOBRUTO').AsFloat)),',','.'); // Peso Bruto

    {
    // Dados De Cobrança
    // 1 Fatura  - 3 Duplicatas //
    Form7.spdNFeDataSets.Y.Append; // Inclui somente nessa Parte "Y" da NFe
    Form7.spdNFeDataSets.Campo('nFat_Y03').Value  := Copy(Form7.ibDataSet15NUMERONF.AsString,1,9); // Número da Farura
    Form7.spdNFeDataSets.Campo('vOrig_Y04').Value := Form7.spdNFeDataSets.Campo('vNF_W16').Value; // Valor Original da Fatura

    if Form1.sVersaoLayout = '4.00' then
    begin
//                  if Form7.spdNFe.Ambiente = spdNFeType.akHomologacao then
      begin
        Form7.spdNFeDataSets.Campo('vDesc_Y05').Value := '0.00'; // Valor do Desconto
      end;
    end;

    //Form7.spdNFeDataSets.Campo('vLiq_Y06').Value  := Form7.spdNFeDataSets.Campo('vNF_W16').Value; // Valor Líquido da Fatura
    }
    // Dados De Cobrança
    J := 0;
    fTotalDupl := 0;

    Form7.ibDataSet7.First;
    {Sandro Silva 2023-06-29 inicio
while not Form7.ibDataSet7.Eof do
    begin
      // Note que Os dados da Fatura se encontram no Parte "Y" da NFe que vamos
      // fazer várias inserções para a Mesma NFe como demonstracao
      // Dados da Fatura
      //
      // Duplicatas
      //
      J := J + 1;

      Form7.spdNFeDataSets.IncluirCobranca;
      Form7.spdNFeDataSets.Campo('nDup_Y08').Value  := StrZero(J,3,0); // Número da parcela
//                  Form7.spdNFeDataSets.Campo('nDup_Y08').Value  := Form7.ibDataSet7DOCUMENTO.AsString; // Número da Duplicata
      Form7.spdNFeDataSets.Campo('dVenc_Y09').Value := StrTran(DateToStrInvertida(Form7.ibDataSet7VENCIMENTO.AsDateTime),'/','-');; // Data de Vencimento da Duplicata
      Form7.spdNFeDataSets.Campo('vDup_Y10').Value  := FormatFloatXML(Form7.ibDataSet7VALOR_DUPL.AsFloat); // Valor da Duplicata
          
      // Soma o total das parcelas
      try
        fTotalDupl := fTotalDupl + StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vDup_Y10').AsString,',',''),'.',','));

        Form7.ibDataSet7.Next;

        if Form7.ibDataSet7.Eof then
        begin
          if fTotalDupl <> StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vNF_W16').AsString,',',''),'.',',')) then
          begin
            // Soma a diferença na última
            Form7.spdNFeDataSets.Campo('vDup_Y10').Value := FormatFloatXML(Form7.ibDataSet7VALOR_DUPL.AsFloat +  (StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vNF_W16').AsString,',',''),'.',',')) - fTotalDupl)  );
          end;
        end;
      except
      end;
          
      Form7.spdNFeDataSets.SalvarCobranca;
    end;
    }

    while not Form7.ibDataSet7.Eof do
    begin
      if FormaDePagamentoGeraBoleto(Form7.ibDataSet7FORMADEPAGAMENTO.AsString) then
      begin
        // Note que Os dados da Fatura se encontram no Parte "Y" da NFe que vamos
        // fazer várias inserções para a Mesma NFe como demonstracao
        // Dados da Fatura
        //
        // Duplicatas
        //
        J := J + 1;

        if J = 1 then
          Form7.spdNFeDataSets.Y.Append; // Inclui somente nessa Parte "Y" da NFe

        Form7.spdNFeDataSets.IncluirCobranca;
        Form7.spdNFeDataSets.Campo('nDup_Y08').Value  := StrZero(J,3,0); // Número da parcela
        //                  Form7.spdNFeDataSets.Campo('nDup_Y08').Value  := Form7.ibDataSet7DOCUMENTO.AsString; // Número da Duplicata
        Form7.spdNFeDataSets.Campo('dVenc_Y09').Value := StrTran(DateToStrInvertida(Form7.ibDataSet7VENCIMENTO.AsDateTime),'/','-');; // Data de Vencimento da Duplicata
        Form7.spdNFeDataSets.Campo('vDup_Y10').Value  := FormatFloatXML(Form7.ibDataSet7VALOR_DUPL.AsFloat); // Valor da Duplicata

        // Soma o total das parcelas
        fTotalDupl := fTotalDupl + StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vDup_Y10').AsString,',',''),'.',','));
      end;

      Form7.ibDataSet7.Next;

      {
      if fTotalDupl > 0 then
      begin
        try
          if Form7.ibDataSet7.Eof then
          begin
            if fTotalDupl <> StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vNF_W16').AsString,',',''),'.',',')) then
            begin
              // Soma a diferença na última
              Form7.spdNFeDataSets.Campo('vDup_Y10').Value := FormatFloatXML(Form7.ibDataSet7VALOR_DUPL.AsFloat +  (StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vNF_W16').AsString,',',''),'.',',')) - fTotalDupl)  );
            end;
          end;
        except
        end;

        Form7.spdNFeDataSets.SalvarCobranca;
      end;
      }
      if fTotalDupl > 0 then
      begin
        Form7.spdNFeDataSets.Campo('nFat_Y03').Value  := Copy(Form7.ibDataSet15NUMERONF.AsString,1,9); // Número da Farura
        Form7.spdNFeDataSets.Campo('vOrig_Y04').Value := FormatFloatXML(fTotalDupl); // Valor Original da Fatura
        Form7.spdNFeDataSets.Campo('vDesc_Y05').Value := '0.00'; // Valor do Desconto
        Form7.spdNFeDataSets.Campo('vLiq_Y06').Value  := FormatFloatXML(fTotalDupl); // Valor Líquido da Fatura
        Form7.spdNFeDataSets.SalvarCobranca;
      end;
    end;
    {Sandro Silva 2023-06-29 fim}
    Form7.spdNFeDataSets.Y.Post; // Grava a Duplicata em questão.
  end;

  // Dados Adicionais da NFe - Observações
  if RetornaValorDaTagNoCampo('infAdFisco', Form7.ibDataSet14.FieldByname('OBS').AsString) <> '' then
  begin
    Form7.spdNFeDataSets.Campo('infAdFisco_Z02').Value      := AllTrim(Form7.spdNFeDataSets.Campo('infAdFisco_Z02').Value +' '+ RetornaValorDaTagNoCampo('infAdFisco', Form7.ibDataSet14.FieldByname('OBS').AsString));
    Form7.spdNFeDataSets.Campo('infCpl_Z03').Value          := Trim(ConverteCaracterEspecialXML(Trim(sTrTran(pChar('<infAdFisco>' +
                                                               RetornaValorDaTagNoCampo('infAdFisco', Form7.ibDataSet14.FieldByname('OBS').AsString) + '</infAdFisco>'), Trim(Form7.ibDataSet15COMPLEMENTO.AsString), '') +
                                                               ' ' + Trim(sComplemento) + ' ' + sDIFAL_OBS + ' ' + sCupomReferenciado))); // Informacoes Complementares
  end else
  begin
    Form7.spdNFeDataSets.Campo('infCpl_Z03').Value     := Trim(ConverteCaracterEspecialXML(Trim(Form7.ibDataSet15COMPLEMENTO.AsString + ' ' + Trim(sComplemento) + ' ' + sDIFAL_OBS + ' ' + sCupomReferenciado))); // Informacoes Complementares
  end;

  {Sandro Silva 2023-06-07 inicio}
  // Ativar quando Tecnospeed deixar de incluir essa inform. complementar por conta própria na visualização do danfe
  // Sandro Silva 2023-06-16 if dvICMSMonoRet_N45Total > 0.00 then
  // Sandro Silva 2023-06-16Form7.spdNFeDataSets.Campo('infCpl_Z03').Value := Form7.spdNFeDataSets.Campo('infCpl_Z03').Value + '|' + 'ICMS monofásico sobre combustíveis cobrado anteriormente conforme Convênio ICMS 199/2022;';
  if sMensagemIcmMonofasicoSobreCombustiveis <> '' then
    Form7.spdNFeDataSets.Campo('infCpl_Z03').Value := Form7.spdNFeDataSets.Campo('infCpl_Z03').Value + '|' + sMensagemIcmMonofasicoSobreCombustiveis;
  {Sandro Silva 2023-06-07 fim}

  // Form7.spdNFeDataSets.Campo('xPed_ZB03').Value      := Form7.ibDataSet16NUMEROOS.AsString; // Informar o pedido no caso a OS
  // SAIDA
end;

procedure GeraXmlNFeSaidaTags(vIPISobreICMS : Boolean; fSomaNaBase : Real);
var
  sReg : String;
  fIPIPorUnidade : Real;
  vIVA60_V_ICMST : Real;
  ItemNFe: TItemNFe;
  fAliquota : Real;
  fTotalMercadoria : Real;
  fPercentualFCP, fPercentualFCPST: Real; // Sandro Silva 2023-05-15
  dvICMSMonoRet_N45: Real; // Sandro Silva 2023-06-07
begin
  //Mauricio Parizotto 2023-04-03
  fTotalMercadoria := RetornaValorSQL(' Select coalesce(sum(TOTAL),0) '+
                                      ' From ITENS001 '+
                                      ' Where NUMERONF='+QuotedStr(Form7.ibDAtaSet15NUMERONF.AsString),Form7.ibDAtaSet15.Transaction);

  // TAGS - Saída
  //////////////////// Aqui começam os Impostos Incidentes sobre o Item////////////////////////
  /// Verificar Manual pois existe uma variação nos campos de acordo com Tipo de Tribucação ////
  // ICMS
  // fPercentualFCP
  {Sandro Silva 2023-04-02 inicio
  if (Form7.ibDataSet16PFCPUFDEST.AsFloat <> 0) or (Form7.ibDataSet16PICMSUFDEST.AsFloat <> 0) then
  begin
    // Quando preenche na nota não vai nada nessas tags
    fPercentualFCP := 0; // Form7.ibDataSet16PFCPUFDEST.AsFloat;
    fPercentualFCPST := 0; // fPercentualFCP; // tributos da NF-e
  end else
  begin
    // Quando nao esta preenchido da nota pega valores nas tags
    if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCP',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
    begin
      fPercentualFCP := StrTofloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCP',Form7.ibDataSet4.FieldByname('TAGS_').AsString))); // tributos da NF-e
    end else
    begin
      fPercentualFCP := 0;
    end;

    // fPercentualFCPST
    if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCPST',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
    begin
      fPercentualFCPST := StrTofloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCPST',Form7.ibDataSet4.FieldByname('TAGS_').AsString))); // tributos da NF-e
    end else
    begin
      fPercentualFCPST := 0; // fPercentualFCP; // tributos da NF-e
    end;
  end;
  }
  //fPercentualFCP   := Form7.ibDataSet16PFCP.AsFloat;
  //fPercentualFCPST := Form7.ibDataSet16PFCPST.AsFloat;
  {Sandro Silva 2023-05-15 inicio
  if (Form7.ibDataSet16PFCPUFDEST.AsFloat <> 0) or (Form7.ibDataSet16PICMSUFDEST.AsFloat <> 0) then
  begin
    // Quando preenche na nota não vai nada nessas tags
    fPercentualFCP   := 0; // Form7.ibDataSet16PFCPUFDEST.AsFloat;
    fPercentualFCPST := 0; // fPercentualFCP; // tributos da NF-e
  end else
  begin
    fPercentualFCP   := Form7.ibDataSet16PFCP.AsFloat; // tributos da NF-e
    fPercentualFCPST := Form7.ibDataSet16PFCPST.AsFloat; // tributos da NF-e
  end;
  }
  fPercentualFCP   := Form7.ibDataSet16PFCP.AsFloat; // tributos da NF-e
  fPercentualFCPST := Form7.ibDataSet16PFCPST.AsFloat; // tributos da NF-e
  {Sandro Silva 2023-05-15 fim}

  if (LimpaNumero(Form7.ibDataSet13.FieldByname('CRT').AsString) <> '1') then
  begin
    // Início TAGS saída por CST - CRT 2 ou 3 - Regime normal
    // N11 e N12 todos Tem
    {Sandro Silva 2023-05-15 inicio
    try
      if AllTrim(Form7.ibDataSet14.FieldByName('CST').AsString) <> '' then
      begin
        Form7.spdNFeDataSets.Campo('orig_N11').Value   := Copy(LimpaNumero(Form7.ibDataSet14.FieldByname('CST').AsString)+'000',1,1); //Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
        Form7.spdNFeDataSets.Campo('CST_N12').Value    := Copy(LimpaNumero(Form7.ibDataSet14.FieldByname('CST').AsString)+'000',2,2); // Tipo da Tributação do ICMS (00 - Integralmente) ver outras formas no Manual
      end else
      begin
        Form7.spdNFeDataSets.Campo('orig_N11').Value   := Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',1,1); //Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
        Form7.spdNFeDataSets.Campo('CST_N12').Value    := Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2); // Tipo da Tributação do ICMS (00 - Integralmente) ver outras formas no Manual
      end;
    except
      Form7.spdNFeDataSets.Campo('orig_N11').Value   := Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',1,1); //Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
      Form7.spdNFeDataSets.Campo('CST_N12').Value    := Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2); // Tipo da Tributação do ICMS (00 - Integralmente) ver outras formas no Manual
    end;
    }
    try
      // Sandro Silva 2023-06-13 if Form7.spdNFeDataSets.Campo('finNFe_B25').Value = '4' then // 4=NFe Devolução
      if NFeFinalidadeDevolucao(Form7.spdNFeDataSets.Campo('finNFe_B25').Value) then // Devolução
      begin
        Form7.spdNFeDataSets.Campo('orig_N11').Value   := Copy(LimpaNumero(Form7.ibDataSet16.FieldByname('CST_ICMS').AsString)+'000',1,1); //Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
        Form7.spdNFeDataSets.Campo('CST_N12').Value    := Copy(LimpaNumero(Form7.ibDataSet16.FieldByname('CST_ICMS').AsString)+'000',2,2); // Tipo da Tributação do ICMS (00 - Integralmente) ver outras formas no Manual
      end
      else
      begin

        if AllTrim(Form7.ibDataSet14.FieldByName('CST').AsString) <> '' then
        begin
          Form7.spdNFeDataSets.Campo('orig_N11').Value   := Copy(LimpaNumero(Form7.ibDataSet14.FieldByname('CST').AsString)+'000',1,1); //Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
          Form7.spdNFeDataSets.Campo('CST_N12').Value    := Copy(LimpaNumero(Form7.ibDataSet14.FieldByname('CST').AsString)+'000',2,2); // Tipo da Tributação do ICMS (00 - Integralmente) ver outras formas no Manual
        end else
        begin
          Form7.spdNFeDataSets.Campo('orig_N11').Value   := Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',1,1); //Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
          Form7.spdNFeDataSets.Campo('CST_N12').Value    := Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2); // Tipo da Tributação do ICMS (00 - Integralmente) ver outras formas no Manual
        end;
      end;
    except
      Form7.spdNFeDataSets.Campo('orig_N11').Value   := Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',1,1); //Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
      Form7.spdNFeDataSets.Campo('CST_N12').Value    := Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2); // Tipo da Tributação do ICMS (00 - Integralmente) ver outras formas no Manual
    end;
    {Sandro Silva 2023-05-15 fim}
    // Tem que voltar ao CFOP original da nota

    // Posiciona na tabéla de CFOP
    if AllTrim(Form7.ibDataSet4ST.Value) <> '' then       // Quando alterar esta rotina alterar também retributa Ok 1/ Abril
    begin
      sReg := Form7.ibDataSet14REGISTRO.AsString;
      Form7.ibDataSet14.DisableControls;
      Form7.ibDataSet14.Close;
      Form7.ibDataSet14.SelectSQL.Clear;
      Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
      Form7.ibDataSet14.Open;
      if not Form7.ibDataSet14.Locate('ST',Form7.ibDataSet4ST.AsString,[loCaseInsensitive, loPartialKey]) then
        Form7.ibDataSet14.Locate('REGISTRO',sReg,[]);
      Form7.ibDataSet14.EnableControls;
    end else
    begin
      Form7.ibDataSet14.DisableControls;
      Form7.ibDataSet14.Close;
      Form7.ibDataSet14.SelectSQL.Clear;
      Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
      Form7.ibDataSet14.Open;
      Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);
      Form7.ibDataSet14.EnableControls;
    end;

    // TAGS
    if (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '00')
      or (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '10')
      or (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '20')
      or (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '51')
      or (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '70')
      or (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '90') then
    begin
      if (Form7.ibDataSet16.FieldByname('BASE').AsFloat = 0) then
      begin
        Form7.spdNFeDataSets.Campo('vBC_N15').Value   := '0'; // Valor da Base de Cálculo do ICMS
        Form7.spdNFeDataSets.Campo('vICMS_N17').Value := '0'; // Valor do ICMS em Reais
      end else
      begin
        Form7.spdNFeDataSets.Campo('vBC_N15').Value     := FormatFloatXML(Form7.ibDataSet16.FieldByname('VBC').AsFloat);   // BC
        Form7.spdNFeDataSets.Campo('vICMS_N17').Value   := FormatFloatXML(Form7.ibDataSet16.FieldByname('VICMS').AsFloat); // Valor do ICMS em Reais
      end;
    end;

    if Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '00' then
    begin
      // St 00
      Form7.spdNFeDataSets.Campo('modBC_N13').Value   := '3'; // Modalidade de determinação da Base de Cálculo - ver Manual
      Form7.spdNFeDataSets.Campo('pICMS_N16').Value   := FormatFloatXML(Form7.ibDataSet16.FieldByname('ICM').AsFloat); // Alíquota do ICMS em Percentual
    end;

    if (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '10')
    or (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '30')
    or (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '60')
    or (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '70')
    or (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '90') then
    begin
      // St 60 só tem N21 e N23
      // Posiciona na tabéla de CFOP
      if AllTrim(Form7.ibDataSet4ST.Value) <> '' then       // Quando alterar esta rotina alterar também retributa Ok 1/ Abril
      begin
        sReg := Form7.ibDataSet14REGISTRO.AsString;
        Form7.ibDataSet14.DisableControls;
        Form7.ibDataSet14.Close;
        Form7.ibDataSet14.SelectSQL.Clear;
        Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
        Form7.ibDataSet14.Open;
        if not Form7.ibDataSet14.Locate('ST',Form7.ibDataSet4ST.AsString,[loCaseInsensitive, loPartialKey]) then
          Form7.ibDataSet14.Locate('REGISTRO',sReg,[]);
        Form7.ibDataSet14.EnableControls;
      end else
      begin
        Form7.ibDataSet14.DisableControls;
        Form7.ibDataSet14.Close;
        Form7.ibDataSet14.SelectSQL.Clear;
        Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
        Form7.ibDataSet14.Open;
        Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);
        Form7.ibDataSet14.EnableControls;
      end;

      if Form7.ibDataSet4PIVA.AsFloat > 0 then
      begin
        if Form7.ibDataSet16.FieldByname('BASE').AsFloat > 0 then
        begin
          // IPI Por Unidade
          fIPIPorUnidade := 0;
          if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
          begin
            fIPIPorUnidade := (Form7.ibDataSet16.FieldByname('QUANTIDADE').AsFloat * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString))));
          end;

          if (vIPISobreICMS) and (Form7.ibDataSet16.FieldByname('IPI').AsFloat>0) then
          begin
            // CALCULO DO IVA
            if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
            begin
              // VINICULAS
              try
                Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  (((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
                  + (Form7.ibDataSet16.FieldByname('IPI').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) / 100)
                  )
                  * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 * Form7.ibDataSet4PIVA.AsFloat),2))),',','.'); // Valor da BST
              except end;
            end else
            begin
              Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
              (((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
              + (Form7.ibDataSet16.FieldByname('IPI').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) / 100)
              )
              * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 * Form7.ibDataSet4PIVA.AsFloat),2))),',','.'); // Valor da BST
            end;

            if Form7.AliqICMdoCliente16() < Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
            begin
              // Desconta o ICM normal
              if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
              begin
                // VINICULAS
                try
                  Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  Arredonda(((
                  (((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
                  + (Form7.ibDataSet16.FieldByname('IPI').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) / 100)
                  )
                  ) * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                  - ((
                  ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
                  + (Form7.ibDataSet16.FieldByname('IPI').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) / 100) // Teste inclui esta linha
                  ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )
                  ),2))),',','.'); // Valor do ICMS ST em Reais
                except
                end;
              end else
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda(
                Arredonda(((
                (((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
                + (Form7.ibDataSet16.FieldByname('IPI').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) / 100)
                )
                ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                - ((
                ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
                + (Form7.ibDataSet16.FieldByname('IPI').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) / 100) // Teste inclui esta linha
                ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )
                ,2))),',','.'); // Valor do ICMS ST em Reais
              end;
            end else
            begin
              // Desconta o ICM normal
              if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
              begin
                // VINICULAS
                try
                  {Sandro Silva 2023-05-23 inicio
                  Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  arredonda(((
                  (((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
                  + (Form7.ibDataSet16.FieldByname('IPI').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) / 100)
                  )
                  ) * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 * Form7.AliqICMdoCliente16() / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                  - ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
                  + (Form7.ibDataSet16.FieldByname('IPI').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) / 100) // Teste inclui esta linha
                  ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat  / 100 )
                  ),2))),',','.'); // Valor do ICMS ST em Reais
                  }

                  // Estava arredondando duas vezes. Arredondava a primeira parte do cálculo, depois subtraia a segunda parte, que não estava arredondada, e arredondava o resultado
                  // Isso causa diferença entre o cálculo feito para exibir os valores na tela de lançamento de itens
                  Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   :=
                    StrTran(
                        FormatFloat('##0.00',
                          Arredonda(
                               (((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat - fRateioDoDesconto) + fIPIPorUnidade) + (Form7.ibDataSet16.FieldByname('IPI').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat - fRateioDoDesconto) / 100))) * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString, pos('<BCST>',Form7.ibDataSet14OBS.AsString) + 6, 5)) / 100 * Form7.AliqICMdoCliente16() / 100 ) * Form7.ibDataSet4PIVA.AsFloat
                             - ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat - fRateioDoDesconto) + fIPIPorUnidade) + (Form7.ibDataSet16.FieldByname('IPI').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat - fRateioDoDesconto) / 100)) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 * Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString) + '_').AsFloat  / 100)
                          ,2)
                        )
                    ,',','.'); // Valor do ICMS ST em Reais

                except
                end;
              end else
              begin
                {Sandro Silva 2023-05-23 inicio
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda(
                Arredonda(((
                (((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
                + (Form7.ibDataSet16.FieldByname('IPI').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) / 100)
                )
                ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 * Form7.AliqICMdoCliente16() / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                - ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
                + (Form7.ibDataSet16.FieldByname('IPI').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) / 100) // Teste inclui esta linha
                ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat  / 100 )
                ,2))),',','.'); // Valor do ICMS ST em Reais
                }

                // Estava arredondando duas vezes. Arredondava a primeira parte do cálculo, depois subtraia a segunda parte, que não estava arredondada, e arredondava o resultado
                // Isso causa diferença entre o cálculo feito para exibir os valores na tela de lançamento de itens
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   :=
                  StrTran(
                      FormatFloat('##0.00',
                        Arredonda(
                            (((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade) + (Form7.ibDataSet16.FieldByname('IPI').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) / 100))) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 * Form7.AliqICMdoCliente16() / 100 )* Form7.ibDataSet4PIVA.AsFloat
                             -
                             ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade) + (Form7.ibDataSet16.FieldByname('IPI').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) / 100) ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat  / 100 )
                        , 2)
                      )
                  ,',','.'); // Valor do ICMS ST em Reais

                {Sandro Silva 2023-05-23 fim}
              end;
            end;
          end else
          begin
            // CALCULO DO IVA
            if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
            begin
              // VINICULAS
              try
                Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
                * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
              except end;
            end else
            begin
              Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda(( ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
              * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
            end;
            if Form7.AliqICMdoCliente16() < Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
            begin
              if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
              begin
                // VINICULAS
                try
                  Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  Arredonda((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)+ fIPIPorUnidade) * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                  - (((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )
                  ),2) )),',','.'); // Valor do ICMS ST em Reais
                except end;
              end else
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                Arredonda((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)+ fIPIPorUnidade) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                - (((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )
                ),2) )),',','.'); // Valor do ICMS ST em Reais
              end;
            end else
            begin
              if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
              begin
                // VINICULAS
                try
                  Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  Arredonda((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)+ fIPIPorUnidade) * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 * Form7.AliqICMdoCliente16() / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                  - (((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )
                  ),2) )),',','.'); // Valor do ICMS ST em Reais
                except end;
              end else
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                Arredonda((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)+ fIPIPorUnidade) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 * Form7.AliqICMdoCliente16() / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                - (((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )
                ),2) )),',','.'); // Valor do ICMS ST em Reais
              end;
            end;
          end;
          //
          if Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '60' then
          begin
            //  CALCULO DO IVA
            vIVA60_B_ICMST := vIVA60_B_ICMST + ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 * Form7.ibDataSet4PIVA.AsFloat;

            if Form7.AliqICMdoCliente16() < Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
            begin
              vIVA60_V_ICMST := vIVA60_V_ICMST + ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat
              - ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 );
            end else
            begin
              vIVA60_V_ICMST := vIVA60_V_ICMST + ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 * Form7.AliqICMdoCliente16() / 100 )* Form7.ibDataSet4PIVA.AsFloat
              - ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 );
            end;
          end;

          // Desconta o ICM sobre IPI normal do ST    CALCULO DO IVA
          if Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '60' then
          begin
            // FICHA 2786
            Form7.spdNFeDataSets.Campo('pST_N26a').Value              := '0.00'; // Aliquota suportada pelo consumidor
            Form7.spdNFeDataSets.Campo('vICMSSubstituto_N26b').Value  := '0.00'; // Valor do icms próprio do substituto cobrado em operação anterior
            Form7.spdNFeDataSets.Campo('vbCSTRet_N26').Value          := '0.00'; // Valor cobrado anteriormente por ST ok
            Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value        := '0.00'; // Valor do ICMS ST em Reais
          end else
          begin
            Form7.spdNFeDataSets.Campo('vbCSTRet_N26').Value    := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
            (((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 * Form7.ibDataSet4PIVA.AsFloat)
            ),2) )),',','.'); // Valor da BC do ICMS ST cobrado anteriormente por ST (v2.0) NAO
            //
            if Form7.AliqICMdoCliente16() < Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
            begin
              Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value  := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
              ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat
              - ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )
              ),2) )),',','.'); // Valor do ICMS ST em Reais
            end else
            begin
              Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value  := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
              ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )* Form7.ibDataSet4PIVA.AsFloat
              - ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )
              ),2) )),',','.'); // Valor do ICMS ST em Reais
            end;
          end;
        end;
      end else
      begin
        if Form7.ibDataSet15BASESUBSTI.AsFloat <> 0 then
        begin
          if Form7.spdNFeDataSets.Campo('CST_N12').AssTring <> '60' then
          begin
            Form7.spdNFeDataSets.Campo('pMVAST_N19').Value      := '100'; // Percentual de margem de valor adicionado do ICMS ST
          end;

          // incluir + fSomaNaBase
          if Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '60' then
          begin
            if Form7.spdNFeDataSets.Campo('indFinal_B25a').Value  = '1' then
            begin
              Form7.spdNFeDataSets.campo('pRedBCEfet_N34').Value      := FormatFloatXML(100-Form7.ibDataSet14BASE.AsFloat);                                                                                              // Percentual de redução da base de cálculo efetiva
              Form7.spdNFeDataSets.campo('vBCEfet_N35').Value         := FormatFloatXML(((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat + fSomaNaBase) * Form7.ibDataSet14BASE.AsFloat / 100));                              // Valor da base de cálculo efetiva
              Form7.spdNFeDataSets.campo('pICMSEfet_N36').Value       := FormatFloatXML(Form7.AliqICMdoCliente16());                                                                                                         // Alíquota do ICMS efetiva
              Form7.spdNFeDataSets.campo('vICMSEfet_N37').Value       := FormatFloatXML(Form7.AliqICMdoCliente16()*(((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat + fSomaNaBase) * Form7.ibDataSet14BASE.AsFloat / 100))/100); // Valor do ICMS efetivo
            end else
            begin
              // Procura pela última compra deste item
              Form7.ibQuery1.Close;
              Form7.ibQuery1.Sql.Clear;
              Form7.ibQuery1.Sql.Add('select first 1 ITENS002.CODIGO, ITENS002.QUANTIDADE, ITENS002.VBCST, ITENS002.VICMSST from ITENS002, COMPRAS where ITENS002.NUMERONF = COMPRAS.NUMERONF and Coalesce(ITENS002.VICMSST,0)<>0 and ITENS002.CODIGO='+QuotedStr(Form7.ibDataSet4CODIGO.AsString)+' order by COMPRAS.EMISSAO desc');
              Form7.ibQuery1.Open;

              if Form7.ibQuery1.FieldByname('VICMSST').AsFloat <> 0 then
              begin
                Form7.spdNFeDataSets.Campo('pST_N26a').Value              := FormatFloatXML((Form7.ibQuery1.FieldByname('VICMSST').AsFloat / Form7.ibQuery1.FieldByname('VBCST').AsFloat)*100);  // Aliquota suportada pelo consumidor
                Form7.spdNFeDataSets.Campo('vICMSSubstituto_N26b').Value  := '0.00'; // Valor do icms próprio do substituto cobrado em operação anterior
                Form7.spdNFeDataSets.Campo('vbCSTRet_N26').Value          := FormatFloatXML(Form7.ibQuery1.FieldByname('VBCST').AsFloat / Form7.ibQuery1.FieldByname('QUANTIDADE').AsFloat * Form7.ibDataSet16QUANTIDADE.AsFloat);  // Valor do BC do ICMS ST retido na UF Emitente ok
                Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value        := FormatFloatXML(Form7.ibQuery1.FieldByname('VICMSST').AsFloat / Form7.ibQuery1.FieldByname('QUANTIDADE').AsFloat * Form7.ibDataSet16QUANTIDADE.AsFloat);  //  Valor do ICMS ST retido na UF Emitente
              end else
              begin
                Form7.spdNFeDataSets.Campo('pST_N26a').Value              := '0.00'; // Aliquota suportada pelo consumidor
                Form7.spdNFeDataSets.Campo('vICMSSubstituto_N26b').Value  := '0.00'; // Valor do icms próprio do substituto cobrado em operação anterior
                Form7.spdNFeDataSets.Campo('vbCSTRet_N26').Value          := '0.00'; // Valor cobrado anteriormente por ST Ok
                Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value        := '0.00'; // Valor do ICMS ST em Reais
              end;
            end;
          end else
          begin
            Form7.spdNFeDataSets.Campo('vbCSTRet_N26').Value    := '0.00'; // Valor cobrado anteriormente por ST Ok
            Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value  := '0.00'; // Valor do ICMS ST em Reais
          end;

          Form7.spdNFeDataSets.Campo('vbCST_N21').Value       := FormatFloatXML(Form7.ibDataSet16.FieldByname('TOTAL').AsFloat); // Valor cobrado anteriormente por ST
          Form7.spdNFeDataSets.Campo('vICMSST_N23').Value     := FormatFloatXML(Arredonda((Form7.AliqICMdoCliente16()*(Form7.ibDataSet16.FieldByname('TOTAL').AsFloat)/100),2) ); // Valor do ICMS ST em Reais
        end else
        begin
          if Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '60' then
          begin
            Form7.spdNFeDataSets.Campo('pMVAST_N19').Value      := '0'; // Percentual de margem de valor adicionado do ICMS ST

            if (Form7.spdNFeDataSets.Campo('indFinal_B25a').Value = '1') {and (not NFeFinalidadeDevolucao(Form7.ibDataSet15FINNFE.AsString))} then
            begin
              Form7.spdNFeDataSets.campo('pRedBCEfet_N34').Value      := FormatFloatXML(100-Form7.ibDataSet14BASE.AsFloat);// Percentual de redução da base de cálculo efetiva
              Form7.spdNFeDataSets.campo('vBCEfet_N35').Value         := FormatFloatXML(((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat + fSomaNaBase) * Form7.ibDataSet14BASE.AsFloat / 100));  // Valor da base de cálculo efetiva
              Form7.spdNFeDataSets.campo('pICMSEfet_N36').Value       := FormatFloatXML(Form7.AliqICMdoCliente16()); // Alíquota do ICMS efetiva
              Form7.spdNFeDataSets.campo('vICMSEfet_N37').Value       := FormatFloatXML(Form7.AliqICMdoCliente16()*(((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat + fSomaNaBase) * Form7.ibDataSet14BASE.AsFloat / 100))/100); // Valor do ICMS efetivo
            end else
            begin
              // Procura pela última compra deste item
              Form7.ibQuery1.Close;
              Form7.ibQuery1.Sql.Clear;
              Form7.ibQuery1.Sql.Add('select first 1 ITENS002.CODIGO, ITENS002.QUANTIDADE, ITENS002.VBCST, ITENS002.VICMSST from ITENS002, COMPRAS where ITENS002.NUMERONF = COMPRAS.NUMERONF and Coalesce(ITENS002.VICMSST,0)<>0 and ITENS002.CODIGO='+QuotedStr(Form7.ibDataSet4CODIGO.AsString)+' order by COMPRAS.EMISSAO desc');
              Form7.ibQuery1.Open;

              if Form7.ibQuery1.FieldByname('VICMSST').AsFloat <> 0 then
              begin
                Form7.spdNFeDataSets.Campo('pST_N26a').Value              := FormatFloatXML((Form7.ibQuery1.FieldByname('VICMSST').AsFloat / Form7.ibQuery1.FieldByname('VBCST').AsFloat)*100);  // Aliquota suportada pelo consumidor
                Form7.spdNFeDataSets.Campo('vICMSSubstituto_N26b').Value  := '0.00'; // Valor do icms próprio do substituto cobrado em operação anterior
                Form7.spdNFeDataSets.Campo('vbCSTRet_N26').Value          := FormatFloatXML(Form7.ibQuery1.FieldByname('VBCST').AsFloat / Form7.ibQuery1.FieldByname('QUANTIDADE').AsFloat * Form7.ibDataSet16QUANTIDADE.AsFloat);  // Valor do BC do ICMS ST retido na UF Emitente ok
                Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value        := FormatFloatXML(Form7.ibQuery1.FieldByname('VICMSST').AsFloat / Form7.ibQuery1.FieldByname('QUANTIDADE').AsFloat * Form7.ibDataSet16QUANTIDADE.AsFloat);  //  Valor do ICMS ST retido na UF Emitente
              end else
              begin
                Form7.spdNFeDataSets.Campo('pST_N26a').Value              := '0.00'; // Aliquota suportada pelo consumidor
                Form7.spdNFeDataSets.Campo('vICMSSubstituto_N26b').Value  := '0.00'; // Valor do icms próprio do substituto cobrado em operação anterior
                Form7.spdNFeDataSets.Campo('vbCSTRet_N26').Value          := '0.00'; // Valor cobrado anteriormente por ST Ok
                Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value        := '0.00'; // Valor do ICMS ST em Reais
              end;
            end;
          end;

          Form7.spdNFeDataSets.Campo('vbCST_N21').Value       := '0.00'; // Valor cobrado anteriormente por ST
          Form7.spdNFeDataSets.Campo('vICMSST_N23').Value     := '0.00';  // Valor do ICMS ST em Reais
        end;
      end;
    end;


    if Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '10' then
    begin
      // St 10
      if Form7.ibDataSet4PIVA.AsFloat > 0 then
      begin
        Form7.spdNFeDataSets.Campo('modBC_N13').Value     := '0'; // Modalidade de determinação da Base de Cálculo - ver Manual
      end else
      begin
        Form7.spdNFeDataSets.Campo('modBC_N13').Value     := '3'; // Modalidade de determinação da Base de Cálculo - ver Manual
      end;

      Form7.spdNFeDataSets.Campo('modBCST_N18').Value   := '4'; // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual

      Form7.spdNFeDataSets.Campo('pICMS_N16').Value     := FormatFloatXML(Form7.ibDataSet16.FieldByname('ICM').AsFloat); // Alíquota do ICMS em Percentual

      if sDentroOuForadoEStado = '6' then
        // Se for fora do estado tem que pega a ALIQUOTA do EMITENTE
        Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   := FormatFloatXML(Form7.RetornarAliquotaICM(Form7.ibDataSet13ESTADO.AsString)) // Alíquota do ICMS em Percentual
      else
        Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   := FormatFloatXML(Form7.AliqICMdoCliente16()); // Alíquota do ICMS em Percentual
    end;

    if (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '40') or (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '41') or (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '50') then
    begin
      Form7.spdNFeDataSets.Campo('vbCSTRet_N26').Value    := '';  // Valor cobrado anteriormente por ST
      Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value  := '';  // Valor do ICMS ST em Reais
      Form7.spdNFeDataSets.Campo('vBCSTDest_N31').Value   := '';  // Valor da BC do ICMS ST da UF Destino
    end;

    if (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '20') or (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '51') then
    begin
      // St 20
      if Form7.ibDataSet4PIVA.AsFloat > 0 then
      begin
        Form7.spdNFeDataSets.Campo('modBC_N13').Value     := '0'; // Modalidade de determinação da Base de Cálculo - ver Manual
      end else
      begin
        Form7.spdNFeDataSets.Campo('modBC_N13').Value     := '3'; // Modalidade de determinação da Base de Cálculo - ver Manual
      end;

      if (100-Form7.ibDataSet16.FieldByname('BASE').AsFloat) = 100 then
      begin
        Form7.spdNFeDataSets.Campo('pRedBC_N14').Value := '100'; // Percentual da redução de BC
      end else
      begin
        Form7.spdNFeDataSets.Campo('pRedBC_N14').Value := FormatFloatXML(100-Form7.ibDataSet16.FieldByname('BASE').AsFloat); // Percentual da redução de BC
      end;

      Form7.spdNFeDataSets.Campo('pICMS_N16').Value     := FormatFloatXML(Form7.ibDataSet16.FieldByname('ICM').AsFloat); // Alíquota do ICMS em Percentual
      Form7.spdNFeDataSets.Campo('vICMSOp_N16a').Value  := FormatFloatXML(Arredonda2( (Form7.ibDataSet16.FieldByname('ICM').AsFloat*(Form7.ibDataSet16.FieldByname('TOTAL').AsFloat + fSomaNaBase )/100*Form7.ibDataSet16.FieldByname('BASE').AsFloat/100) ,2));


      // Tag OBS no ICMS <pDIF>33,33</pDIF>
      if RetornaValorDaTagNoCampo('pDif', Form7.ibDataSet14.FieldByname('OBS').AsString) <> '' then
        Form7.spdNFeDataSets.Campo('pDif_N16b').Value      := StrTran(FormatFloat('##0.0000', Arredonda(StrToFloatDef(RetornaValorDaTagNoCampo('pDif', Form7.ibDataSet14.FieldByname('OBS').AsString), 0),4)),',','.')
      else
        Form7.spdNFeDataSets.Campo('pDif_N16b').Value      := '100';

      // Fórmula complexa poderia ser simplificada mas foi testada e está funcionando
      Form7.spdNFeDataSets.Campo('vICMSDif_N16c').Value :=
          StrTran(Alltrim(FormatFloat('##0.00',(Form7.ibDataSet16.FieldByname('ICM').AsFloat*(Form7.ibDataSet16.FieldByname('TOTAL').AsFloat + fSomaNaBase )/100*Form7.ibDataSet16.FieldByname('BASE').AsFloat/100
          )*StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('pDif_N16b').AsString,',',''),'.',','))/100)),',','.');

      if Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '51' then
      begin
        Form7.spdNFeDataSets.Campo('vICMS_N17').Value := StrTran(Alltrim(FormatFloat('##0.00',
            Arredonda2( (Form7.ibDataSet16.FieldByname('ICM').AsFloat*(Form7.ibDataSet16.FieldByname('TOTAL').AsFloat + fSomaNaBase )/100*Form7.ibDataSet16.FieldByname('BASE').AsFloat/100),2)
            - StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vICMSDif_N16c').AsString,',',''),'.',','))
            )),',','.');
      end;
    end;

    if Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '30' then
    begin
      // St 30
      Form7.spdNFeDataSets.Campo('modBCST_N18').Value     := '4'; // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual
      Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '100'; // Percentual de redução de BC do ICMS ST
      Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   := FormatFloatXML(Form7.AliqICMdoCliente16()); // Alíquota do ICMS em Percentual
    end;

    if Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '60' then
    begin
      // St 60
      Form7.spdNFeDataSets.Campo('modBCST_N18').Value     := '4'; // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual
      Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '100'; // Percentual de redução de BC do ICMS ST
      Form7.spdNFeDataSets.Campo('pICMSST_N22').Value     := FormatFloatXML(Form7.AliqICMdoCliente16()); // Alíquota do ICMS em Percentual
    end;

    if (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '70')
    or (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '90') then
    begin
      // St 70
      if Form7.ibDataSet4PIVA.AsFloat > 0 then
      begin
        Form7.spdNFeDataSets.Campo('modBC_N13').Value     := '0'; // Modalidade de determinação da Base de Cálculo - ver Manual
      end else
      begin
        Form7.spdNFeDataSets.Campo('modBC_N13').Value     := '3'; // Modalidade de determinação da Base de Cálculo - ver Manual
      end;

      if (100-Form7.ibDataSet16.FieldByname('BASE').AsFloat) = 100 then
      begin
        Form7.spdNFeDataSets.Campo('pRedBC_N14').Value := '100'; // Percentual da redução de BC
      end else
      begin
        Form7.spdNFeDataSets.Campo('pRedBC_N14').Value := FormatFloatXML(100-Form7.ibDataSet16.FieldByname('BASE').AsFloat); // Percentual da redução de BC
      end;

      Form7.spdNFeDataSets.Campo('pICMS_N16').Value     := FormatFloatXML(Form7.ibDataSet16.FieldByname('ICM').AsFloat); // Alíquota do ICMS em Percentual
      Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   := FormatFloatXML(Form7.AliqICMdoCliente16()); // Alíquota do ICMS em Percentual

      Form7.spdNFeDataSets.Campo('modBCST_N18').Value     := '4'; // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual

      if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
      begin
        // VINICULAS
        try
          Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    :=  FormatFloatXML(StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5))   );
        except end;
      end else
      begin
        Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '100'; // Percentual de redução de BC do ICMS ST
      end;
    end;

    if LimpaNumero(Form7.ibDataSet13.FieldByname('CRT').AsString) = '1' then
    begin
      Form7.spdNFeDataSets.Campo('vBC_N15').Value     := '0';  // BC
      Form7.spdNFeDataSets.Campo('vICMS_N17').Value   := '0';  // Valor do ICMS em Reais
    end;

    if (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '30') or
       (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '10') or
       (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '70') or
       (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '90') then
    begin
      if Form7.ibDataSet4PIVA.AsFloat > 0 then
      begin
        if Form7.ibDataSet16.FieldByname('BASE').AsFloat > 0 then
        begin
          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := FormatFloatXML((Form7.ibDataSet4PIVA.AsFloat*100)-100 ); // Percentual de margem de valor adicionado do ICMS ST
        end else
        begin
          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := '100'; // Percentual de margem de valor adicionado do ICMS ST
        end;
      end else
      begin
        Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := '100'; // Percentual de margem de valor adicionado do ICMS ST
      end;
    end;

    // Saída empresa no Regime normal por CST
    if Form1.sVersaoLayout = '4.00' then
    begin
      if Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '60' then
      begin
        if Pos(sCodigoANP,pChar('210203001, 320101001, 320101002, 320102002, 320102001, 320102003, 320102005, 320201001, 320103001,'+
                          '220102001, 320301001, 320103002, 820101032, 820101026, 820101027, 820101004, 820101005, 820101022,'+
                          '820101031, 820101030, 820101014, 820101006, 820101016, 820101015, 820101025, 820101017, 820101018,'+
                          '820101019, 820101020, 820101021, 420105001, 420101005, 420101004, 420102005, 420102004, 420104001,'+
                          '820101033, 820101034, 420106001, 820101011, 820101003, 820101013, 820101012, 420106002, 830101001,'+
                          '420301004, 420202001, 420301001, 420301002, 410103001, 410101001, 410102001, 430101004, 510101001,'+
                          '510101002, 510102001, 510102002, 510201001, 510201003, 510301003, 510103001, 510301001')) <> 0 then
        begin
          Form7.spdNFeDataSets.Campo('orig_N11').Value   := Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',1,1); //Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
          Form7.spdNFeDataSets.Campo('CST_N12').Value    := Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2); // Tipo da Tributação do ICMS (00 - Integralmente) ver outras formas no Manual
          Form7.spdNFeDataSets.Campo('vbCSTRet_N26').Value    := '0.00';  // Valor cobrado anteriormente por ST Ok
          Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value  := '0.00';  // Valor do ICMS ST em Reais
          Form7.spdNFeDataSets.Campo('vBCSTDest_N31').Value   := '0.00';  // Valor da BC do ICMS ST da UF Destino
          Form7.spdNFeDataSets.Campo('vICMSSTDest_N32').Value := '0.00';  // Informar o valor do ICMS ST da UF destino
        end;
      end;

      if Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '00' then
      begin
        {
        if fPercentualFCP <> 0 then
        begin
          Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(fPercentualFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
          Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))*fPercentualFCP/100); // Valor do Fundo de Combate à Pobreza (FCP)
        end;
        }
        // Sandro Silva 2023-05-15 if (Form7.ibDataSet16.FieldByname('PFCP').AsFloat) <> 0 then
        if fPercentualFCP <> 0 then
        begin
          Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(fPercentualFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
          Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(Form7.ibDataSet16.FieldByname('VFCP').AsFloat); // Valor do Fundo de Combate à Pobreza (FCP)
        end;
      end;

      if Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '10' then
      begin
        {
        if fPercentualFCP <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',',')));// Valor da Base de Cálculo do FCP
          Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(fPercentualFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
          Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))*fPercentualFCP/100); // Valor do Fundo de Combate à Pobreza (FCP)
        end;

        if fPercentualFCPST <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
          Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(fPercentualFCPST); // Percentual do FCP retido por Substituição Tributária

          if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*fPercentualFCPST/100) -(StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vFCP_N17c').AsString,'.',','))) ); // Valor do FCP retido por Substituição Tributária
          end else
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*fPercentualFCPST/100) ); // Valor do FCP retido por Substituição Tributária
          end;
        end;
        }
        // Sandro Silva 2023-05-15 if (Form7.ibDataSet16.FieldByname('PFCP').AsFloat) <> 0 then
        if fPercentualFCP <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := FormatFloatXML(Form7.ibDataSet16.FieldByname('VBCFCP').AsFloat);// Valor da Base de Cálculo do FCP
          Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(fPercentualFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
          Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(Form7.ibDataSet16.FieldByname('VFCP').AsFloat); // Valor do Fundo de Combate à Pobreza (FCP)
        end;

        // Sandro Silva 2023-05-15 if Form7.ibDataSet16.FieldByname('PFCPST').AsFloat <> 0 then
        if fPercentualFCPST <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(Form7.ibDataSet16.FieldByname('VBCFCPST').AsFloat); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
          Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(fPercentualFCPST); // Percentual do FCP retido por Substituição Tributária

          if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML(Form7.ibDataSet16.FieldByname('VFCPST').AsFloat); // Valor do FCP retido por Substituição Tributária
          end else
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML(Form7.ibDataSet16.FieldByname('VFCPST').AsFloat); // Valor do FCP retido por Substituição Tributária
          end;
        end;
      end;

      if Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '20' then
      begin
        // Sandro Silva 2023-05-15 if Form7.ibDataSet16.FieldByname('PFCP').AsFloat <> 0 then
        if fPercentualFCP <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := FormatFloatXML(Form7.ibDataSet16.FieldByname('VBCFCP').AsFloat); // Valor da Base de Cálculo do FCP
          Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(fPercentualFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
          Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(Form7.ibDataSet16.FieldByname('VFCP').AsFloat); // Valor do Fundo de Combate à Pobreza (FCP)
        end;
      end;

      if Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '30' then
      begin
        {
        if fPercentualFCP <> 0 then
        begin
          fCalculo := (Form7.ibDataSet16.FieldByname('BASE').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat + fSomaNaBase )/100)*fPercentualFCP/100;
        end;

        if fPercentualFCPST <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
          Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(fPercentualFCPST); // Percentual do FCP retido por Substituição Tributária

          if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*fPercentualFCPST/100)-(fCalculo)); // Valor do FCP retido por Substituição Tributária
          end else
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*fPercentualFCPST/100)); // Valor do FCP retido por Substituição Tributária
          end;
        end;
        }

        // Sandro Silva 2023-05-15 if Form7.ibDataSet16.FieldByname('PFCPST').AsFloat <> 0 then
        if fPercentualFCPST <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(Form7.ibDataSet16.FieldByname('VBCFCPST').AsFloat); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
          Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(fPercentualFCPST); // Percentual do FCP retido por Substituição Tributária
          Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML(Form7.ibDataSet16.FieldByname('VFCPST').AsFloat); // Valor do FCP retido por Substituição Tributária
        end;

      end;

      if Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '51' then
      begin
        // Sandro Silva 2023-05-15 if Form7.ibDataSet16PFCP.AsFloat <> 0 then
        if fPercentualFCP <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := FormatFloatXML(Form7.ibDataSet16.FieldByname('VBCFCP').AsFloat); // Valor da Base de Cálculo do FCP
          Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(fPercentualFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
          Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(Form7.ibDataSet16.FieldByname('VFCP').AsFloat); // Valor do Fundo de Combate à Pobreza (FCP)
        end;
      end;

      if Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '60' then
      begin
        //
        //                          Form7.spdNFeDataSets.campo('vBCFCPSTRet_N27a').Value := '0.00'; // Valor da Base de Cálculo do FCP retido anteriormente por ST
        //                          Form7.spdNFeDataSets.campo('pFCPSTRet_N27b').Value   := '0.00'; // Percentual do FCP retido anteriormente por Substituição Tributária
        //                          Form7.spdNFeDataSets.campo('vFCPSTRet_N27d').Value   := '0.00'; // Valor do FCP retido por Substituição Tributária
        //
      end;

      if (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '70') or (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '90') then
      begin
        {
        if fPercentualFCP <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP
          Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(fPercentualFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
          Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vBC_N15').AsString,',',''),'.',','))*fPercentualFCP/100); // Valor do Fundo de Combate à Pobreza (FCP)
        end;

        if fPercentualFCPST <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
          Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(fPercentualFCPST); // Percentual do FCP retido por Substituição Tributária

          if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*fPercentualFCPST/100)-(StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vFCP_N17c').AsString,'.',',')))); // Valor do FCP retido por Substituição Tributária
          end else
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',','))*fPercentualFCPST/100)); // Valor do FCP retido por Substituição Tributária
          end;
        end;
        }
        // Sandro Silva 2023-05-15 if Form7.ibDataSet16.FieldByname('PFCP').AsFloat <> 0 then
        if fPercentualFCP <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := FormatFloatXML(Form7.ibDataSet16.FieldByname('VBCFCP').AsFloat); // Valor da Base de Cálculo do FCP
          Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(fPercentualFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
          Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(Form7.ibDataSet16.FieldByname('VFCP').AsFloat); // Valor do Fundo de Combate à Pobreza (FCP)
        end;

        // Sandro Silva 2023-05-15 if Form7.ibDataSet16.FieldByname('PFCPST').AsFloat <> 0 then
        if fPercentualFCPST <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(Form7.ibDataSet16.FieldByname('VBCFCPST').AsFloat); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
          Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(fPercentualFCPST); // Percentual do FCP retido por Substituição Tributária

          if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value  := FormatFloatXML(Form7.ibDataSet16.FieldByname('VFCPST').AsFloat); // Valor do FCP retido por Substituição Tributária
          end else
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value  := FormatFloatXML(Form7.ibDataSet16.FieldByname('VFCPST').AsFloat); // Valor do FCP retido por Substituição Tributária
          end;
        end;
      end;
    end;


    // final TAGS saaída por CST - CRT 2 ou 3 - Regime normal
  end; // if (LimpaNumero(Form7.ibDataSet13.FieldByname('CRT').AsString) <> '1') then


  if (LimpaNumero(Form7.ibDataSet13.FieldByname('CRT').AsString) = '1') then
  begin
    // Início TAGS saída por CSOSN - CRT = 1 imples Nacional
    // TAGS - Simples NAcional - CSOSN
    // N12a Tem em todas - e eé referencia para classificar as tags

    {Sandro Silva 2023-05-15 inicio
    ItemNFe := TItemNFe.Create;
    CsosnComOrigemdoProdutoNaOperacao(Form7.ibDataSet4.FieldByName('CODIGO').AsString, Form7.ibDataSet15OPERACAO.AsString, ItemNFe);
    Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value := ItemNFe.CSOSN;

    // N11 - Tem em todas
    Form7.spdNFeDataSets.Campo('orig_N11').Value   := ItemNFe.Origem;
    FreeAndNil(ItemNFe);
    }
    // Sandro Silva 2023-06-13 if Form7.spdNFeDataSets.Campo('finNFe_B25').Value = '4' then // 4=NFe Devolução
    if NFeFinalidadeDevolucao(Form7.spdNFeDataSets.Campo('finNFe_B25').Value) then // Devolução
    begin
      Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value := Form7.ibDataSet16.FieldByname('CSOSN').AsString;

      // N11 - Tem em todas
      Form7.spdNFeDataSets.Campo('orig_N11').Value   := Copy(Form7.ibDataSet16.FieldByname('CST_ICMS').AsString, 1, 1); // origem
    end
    else
    begin
      ItemNFe := TItemNFe.Create;
      CsosnComOrigemdoProdutoNaOperacao(Form7.ibDataSet4.FieldByName('CODIGO').AsString, Form7.ibDataSet15OPERACAO.AsString, ItemNFe);
      Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value := ItemNFe.CSOSN;

      // N11 - Tem em todas
      Form7.spdNFeDataSets.Campo('orig_N11').Value   := ItemNFe.Origem;
      FreeAndNil(ItemNFe);
    end;
    {Sandro Silva 2023-05-15 fim}

    {Sandro Silva 2022-10-04 inicio}
    // Sandro Silva 2022-11-11 AtualizaItens001CSOSN(Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value);
    {Sandro Silva 2022-10-04 fim}
    //
    if  (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '101') and
        (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '102') and
        (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '103') and
        (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '201') and
        (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '202') and
        (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '203') and
        (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '300') and
        (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '400') and
        (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '500') and
        (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '900') and
        (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value <> '61')
        then
    begin
      Form7.ibDataSet15.Edit;
      Form7.ibDataSet15STATUS.AsString    := 'Erro: Informe o CSOSN do produto '+ConverteAcentos2(Form7.ibDataSet4.FieldByname('DESCRICAO').AsString);
      Abort;

    end;

    // CSOSN 101
    if Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '101' then
    begin
      // 101 Tributada pelo simples nacional com permissão de credito
      if Copy(Form7.ibDataSet14OBS.AsString,1,24) = 'PERMITE O APROVEITAMENTO' then
      begin
        // PERMITE O APROVEITAMENTO DO CRÉDITO DE ICMS NO VALOR DE R$; CORRESPONDENTE Á ALÍQUOTA DE 2,82%, NOS TERMOS DO ART. 23 DA LC 123
        try
          fAliquota := StrToFloat(Alltrim(StrTran(Copy(Form7.ibDataSet14OBS.AsString,90,4),'.',',')));
        except
          fAliquota := 2.82;
        end;
      end else
      begin
        // fAliquota := 2.82;
        fAliquota := 0;
      end;

      Form7.spdNFeDataSets.Campo('pCredSN_N29').VAlue      := FormatFloatXML(fAliquota); // Aliquota aplicave de cálculo de crédito (Simples Nacional)
      Form7.spdNFeDataSets.Campo('vCredICMSSN_N30').VAlue  := FormatFloatXML(((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) * fAliquota / 100); // VAlor de crédito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)
    end;
    // CSOSN 102, 103, 300, 400
    if (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '102')
    or (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '103')
    or (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '300')
    or (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '400') then
    begin
      // N11 - Já esta preenchido acima todos tem
    end;

    // CSOSN 201 - Tributado pelo Simples Nacional Com permissão de Crédito e com cobrança do ICMS por substituição Tributária
    if (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '201') then
    begin
      //
      Form7.spdNFeDataSets.Campo('modBCST_N18').Value   := '4'; // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual

      if Form7.ibDataSet4PIVA.AsFloat > 0 then
      begin
        if Form7.ibDataSet16.FieldByname('BASE').AsFloat > 0 then
        begin
          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := FormatFloatXML( (Form7.ibDataSet4PIVA.AsFloat*100)-100 ); // Percentual de margem de valor adicionado do ICMS ST
        end else
        begin
          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := '100'; // Percentual de margem de valor adicionado do ICMS ST
        end;
      end else
      begin
        Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := '100'; // Percentual de margem de valor adicionado do ICMS ST
      end;

      Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '100'; // Percentual de redução de BC do ICMS ST

      if Form7.ibDataSet16.FieldByname('BASE').AsFloat > 0 then
      begin
        if Form7.ibDataSet4PIVA.AsFloat > 0 then
        begin
          try
            // IPI Por Unidade
            fIPIPorUnidade := 0;
            if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
            begin
              fIPIPorUnidade := (Form7.ibDataSet16.FieldByname('QUANTIDADE').AsFloat * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString))));
            end;

            //if ((Form7.ibDataSet14SOBREIPI.AsString = 'S')) and (Form7.ibDataSet16.FieldByname('IPI').AsFloat>0) then
            if (vIPISobreICMS) and (Form7.ibDataSet16.FieldByname('IPI').AsFloat>0) then
            begin
              if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
              begin
                // VINICULAS
                try
                  Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                  +(Form7.ibDataSet16.FieldByname('IPI').AsFloat * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  )
                   * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
                except end;
              end else
              begin
                Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                +(Form7.ibDataSet16.FieldByname('IPI').AsFloat * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                )
                 * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
              end;

              // Desconta o ICM sobre IPI normal do ST  CALCULO DO IVA
              if Form7.AliqICMdoCliente16() < Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                Arredonda(((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                +(Form7.ibDataSet16.FieldByname('IPI').AsFloat * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                - ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                +(Form7.ibDataSet16.FieldByname('IPI').AsFloat * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )
                ),2) )),',','.'); // Valor do ICMS ST em Reais
              end else
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                Arredonda(((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                +(Form7.ibDataSet16.FieldByname('IPI').AsFloat * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                - ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                +(Form7.ibDataSet16.FieldByname('IPI').AsFloat * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )
                ),2) )),',','.'); // Valor do ICMS ST em Reais
              end;
            end else
            begin
              if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
              begin
                // VINICULAS
                try
                  Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                  +(0 * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  )
                   * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
                except end;
              end else
              begin
                Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                +(0 * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                )
                 * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
              end;

              // Posiciona na tabéla de CFOP
              if AllTrim(Form7.ibDataSet4ST.Value) <> '' then       // Quando alterar esta rotina alterar também retributa Ok 1/ Abril
              begin
                sReg := Form7.ibDataSet14REGISTRO.AsString;
                Form7.ibDataSet14.DisableControls;
                Form7.ibDataSet14.Close;
                Form7.ibDataSet14.SelectSQL.Clear;
                Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
                Form7.ibDataSet14.Open;
                if not Form7.ibDataSet14.Locate('ST',Form7.ibDataSet4ST.AsString,[loCaseInsensitive, loPartialKey]) then
                  Form7.ibDataSet14.Locate('REGISTRO',sReg,[]);
                Form7.ibDataSet14.EnableControls;
              end else
              begin
                Form7.ibDataSet14.DisableControls;
                Form7.ibDataSet14.Close;
                Form7.ibDataSet14.SelectSQL.Clear;
                Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
                Form7.ibDataSet14.Open;
                Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);
                Form7.ibDataSet14.EnableControls;
              end;

              // Desconta o ICM sobre IPI normal do ST  CALCULO DO IVA
              if Form7.AliqICMdoCliente16() < Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  Arredonda(((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                  +(0 * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                  - ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                  +(0 * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )
                  ),2) )),',','.'); // Valor do ICMS ST em Reais
              end else
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  Arredonda(((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                  +(0 * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                  - ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                  +(0 * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )
                  ),2) )),',','.'); // Valor do ICMS ST em Reais
              end;
            end;
          except
            Form7.ibDataSet15.Edit;
            Form7.ibDataSet15STATUS.AsString    := 'Erro: Verifique o IVA do produto código: '+Form7.ibDataSet4CODIGO.AsString;
            Abort;
          end;
        end else
        begin
          Form7.spdNFeDataSets.Campo('vbCST_N21').Value       := FormatFloatXML(Form7.ibDataSet16.FieldByname('TOTAL').AsFloat); // Valor cobrado anteriormente por ST
          Form7.spdNFeDataSets.Campo('vICMSST_N23').Value     := FormatFloatXML(Arredonda((Form7.AliqICMdoCliente16()*Form7.ibDataSet16.FieldByname('TOTAL').AsFloat/100),2) ); // Valor do ICMS ST em Reais
        end;
      end;

      Form7.spdNFeDataSets.Campo('pICMSST_N22').Value     := FormatFloatXML(Form7.AliqICMdoCliente16()); // Alíquota do ICMS em Percentual
      Form7.spdNFeDataSets.Campo('pCredSN_N29').VAlue     := FormatFloatXML(fAliquota); // Aliquota aplicave de cálculo de crédito (Simples Nacional)
      Form7.spdNFeDataSets.Campo('vCredICMSSN_N30').VAlue := FormatFloatXML(((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) * fAliquota / 100); // VAlor de crédito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)
    end;

    // CSOSN 202, 203 -
    if (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '202') or (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '203') then
    begin
      Form7.spdNFeDataSets.Campo('modBCST_N18').Value   := '4'; // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual

      if Form7.ibDataSet4PIVA.AsFloat > 0 then
      begin
        if Form7.ibDataSet16.FieldByname('BASE').AsFloat > 0 then
        begin
          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := FormatFloatXML( (Form7.ibDataSet4PIVA.AsFloat*100)-100 ); // Percentual de margem de valor adicionado do ICMS ST
        end else
        begin
          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := '100'; // Percentual de margem de valor adicionado do ICMS ST
        end;
      end else
      begin
        Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := '100'; // Percentual de margem de valor adicionado do ICMS ST
      end;
      Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '100'; // Percentual de redução de BC do ICMS ST

      if Form7.ibDataSet16.FieldByname('BASE').AsFloat > 0 then
      begin
        if Form7.ibDataSet4PIVA.AsFloat > 0 then
        begin
          try
            // IPI Por Unidade
            fIPIPorUnidade := 0;
            if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
            begin
              fIPIPorUnidade := (Form7.ibDataSet16.FieldByname('QUANTIDADE').AsFloat * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString))));
            end;

            // Valor da Base de Calculo de ISMS St do item
            //if ((Form7.ibDataSet14SOBREIPI.AsString = 'S')) and (Form7.ibDataSet16.FieldByname('IPI').AsFloat>0) then
            if (vIPISobreICMS) and (Form7.ibDataSet16.FieldByname('IPI').AsFloat>0) then
            begin
              if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
              begin
                // VINICULAS
                try
                  Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                  +(Form7.ibDataSet16.FieldByname('IPI').AsFloat * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  )
                   * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
                except end;
              end else
              begin
                Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda(((
                (((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                +(Form7.ibDataSet16.FieldByname('IPI').AsFloat * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                )
                 * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
              end;

              // Posiciona na tabéla de CFOP
              if AllTrim(Form7.ibDataSet4ST.Value) <> '' then       // Quando alterar esta rotina alterar também retributa Ok 1/ Abril
              begin
                sReg := Form7.ibDataSet14REGISTRO.AsString;
                Form7.ibDataSet14.DisableControls;
                Form7.ibDataSet14.Close;
                Form7.ibDataSet14.SelectSQL.Clear;
                Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
                Form7.ibDataSet14.Open;
                if not Form7.ibDataSet14.Locate('ST',Form7.ibDataSet4ST.AsString,[loCaseInsensitive, loPartialKey]) then Form7.ibDataSet14.Locate('REGISTRO',sReg,[]);
                Form7.ibDataSet14.EnableControls;
              end else
              begin
                Form7.ibDataSet14.DisableControls;
                Form7.ibDataSet14.Close;
                Form7.ibDataSet14.SelectSQL.Clear;
                Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
                Form7.ibDataSet14.Open;
                Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);
                Form7.ibDataSet14.EnableControls;
              end;

              // Desconta o ICM sobre IPI normal do ST  CALCULO DO IVA
              if Form7.AliqICMdoCliente16() < Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  Arredonda(((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                  +(Form7.ibDataSet16.FieldByname('IPI').AsFloat * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste
                  ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                  - ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                  +(Form7.ibDataSet16.FieldByname('IPI').AsFloat * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )
                  ),2) )),',','.'); // Valor do ICMS ST em Reais
              end else
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  Arredonda(((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                  +(Form7.ibDataSet16.FieldByname('IPI').AsFloat * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                  - ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                  +(Form7.ibDataSet16.FieldByname('IPI').AsFloat * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )
                  ),2) )),',','.'); // Valor do ICMS ST em Reais
              end;
            end else
            begin
              if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
              begin
                // VINICULAS
                try
                  Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                  +(0 * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  )
                   * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
                except end;
              end else
              begin
                Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda(((
                  (((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                  +(0 * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  )
                   * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
              end;
              // Posiciona na tabéla de CFOP
              if AllTrim(Form7.ibDataSet4ST.Value) <> '' then       // Quando alterar esta rotina alterar também retributa Ok 1/ Abril
              begin
                sReg := Form7.ibDataSet14REGISTRO.AsString;
                Form7.ibDataSet14.DisableControls;
                Form7.ibDataSet14.Close;
                Form7.ibDataSet14.SelectSQL.Clear;
                Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
                Form7.ibDataSet14.Open;
                if not Form7.ibDataSet14.Locate('ST',Form7.ibDataSet4ST.AsString,[loCaseInsensitive, loPartialKey]) then
                  Form7.ibDataSet14.Locate('REGISTRO',sReg,[]);
                Form7.ibDataSet14.EnableControls;
              end else
              begin
                Form7.ibDataSet14.DisableControls;
                Form7.ibDataSet14.Close;
                Form7.ibDataSet14.SelectSQL.Clear;
                Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
                Form7.ibDataSet14.Open;
                Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);
                Form7.ibDataSet14.EnableControls;
              end;

              // Desconta o ICM sobre IPI normal do ST  CALCULO DO IVA
              if Form7.AliqICMdoCliente16() < Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  Arredonda(((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                  +(0 * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                  - ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                  +(0 * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )
                  ),2) )),',','.'); // Valor do ICMS ST em Reais
              end else
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  Arredonda(((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                  +(0 * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                  - ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                  +(0 * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )
                  ),2) )),',','.'); // Valor do ICMS ST em Reais
              end;
            end;
          except
            Form7.ibDataSet15.Edit;
            Form7.ibDataSet15STATUS.AsString    := 'Erro: Verifique o IVA do produto código: '+Form7.ibDataSet4CODIGO.AsString;
            Abort;
          end;
        end else
        begin
          Form7.spdNFeDataSets.Campo('vbCST_N21').Value       := FormatFloatXML(Form7.ibDataSet16.FieldByname('TOTAL').AsFloat); // Valor cobrado anteriormente por ST
          Form7.spdNFeDataSets.Campo('vICMSST_N23').Value     := FormatFloatXML(Arredonda((Form7.AliqICMdoCliente16()*Form7.ibDataSet16.FieldByname('TOTAL').AsFloat/100),2) ); // Valor do ICMS ST em Reais
        end;
      end;

      if Copy(Form7.ibDataSet14OBS.AsString,1,24) = 'PERMITE O APROVEITAMENTO' then
      begin
        // PERMITE O APROVEITAMENTO DO CRÉDITO DE ICMS NO VALOR DE R$; CORRESPONDENTE Á ALÍQUOTA DE 2,82%, NOS TERMOS DO ART. 23 DA LC 123
        try
          fAliquota := StrToFloat(Alltrim(StrTran(Copy(Form7.ibDataSet14OBS.AsString,90,4),'.',',')));
        except
          fAliquota := 2.82;
        end;
      end else
      begin
        // fAliquota := 2.82;
        fAliquota := 0;
      end;

      Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   := FormatFloatXML(Form7.AliqICMdoCliente16()); // Alíquota do ICMS em Percentual
    end;

    // CSOSN 500
    // Sandro Silva 2023-05-25 if (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '500') then
    if (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '500') or
     ((Form7.ibDataSet16.FieldByname('CSOSN').AsString = '500') and (NFeFinalidadeDevolucao(Form7.ibDataSet15FINNFE.AsString)))
     then
    begin
      if Form7.spdNFeDataSets.Campo('indFinal_B25a').Value  = '1' then
      begin
        Form7.spdNFeDataSets.campo('pRedBCEfet_N34').Value      := FormatFloatXML(100-Form7.ibDataSet14BASE.AsFloat);                                                                                              // Percentual de redução da base de cálculo efetiva
        Form7.spdNFeDataSets.campo('vBCEfet_N35').Value         := FormatFloatXML(((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat + fSomaNaBase) * Form7.ibDataSet14BASE.AsFloat / 100));                              // Valor da base de cálculo efetiva
        Form7.spdNFeDataSets.campo('pICMSEfet_N36').Value       := FormatFloatXML(Form7.AliqICMdoCliente16());                                                                                                         // Alíquota do ICMS efetiva
        Form7.spdNFeDataSets.campo('vICMSEfet_N37').Value       := FormatFloatXML(Form7.AliqICMdoCliente16()*(((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat + fSomaNaBase) * Form7.ibDataSet14BASE.AsFloat / 100))/100); // Valor do ICMS efetivo
      end else
      begin
        // Procura pela última compra deste item
        Form7.ibQuery1.Close;
        Form7.ibQuery1.Sql.Clear;
        Form7.ibQuery1.Sql.Add('select first 1 ITENS002.CODIGO, ITENS002.QUANTIDADE, ITENS002.VBCST, ITENS002.VICMSST from ITENS002, COMPRAS where ITENS002.NUMERONF = COMPRAS.NUMERONF and Coalesce(ITENS002.VICMSST,0)<>0 and ITENS002.CODIGO='+QuotedStr(Form7.ibDataSet4CODIGO.AsString)+' order by COMPRAS.EMISSAO desc');
        Form7.ibQuery1.Open;

        if Form7.ibQuery1.FieldByname('VICMSST').AsFloat <> 0 then
        begin
          Form7.spdNFeDataSets.Campo('pST_N26a').Value              := FormatFloatXML((Form7.ibQuery1.FieldByname('VICMSST').AsFloat / Form7.ibQuery1.FieldByname('VBCST').AsFloat)*100);  // Aliquota suportada pelo consumidor
          Form7.spdNFeDataSets.Campo('vICMSSubstituto_N26b').Value  := '0.00'; // Valor do icms próprio do substituto cobrado em operação anterior
          Form7.spdNFeDataSets.Campo('vbCSTRet_N26').Value          := FormatFloatXML(Form7.ibQuery1.FieldByname('VBCST').AsFloat / Form7.ibQuery1.FieldByname('QUANTIDADE').AsFloat * Form7.ibDataSet16QUANTIDADE.AsFloat);  // Valor do BC do ICMS ST retido na UF Emitente ok
          Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value        := FormatFloatXML(Form7.ibQuery1.FieldByname('VICMSST').AsFloat / Form7.ibQuery1.FieldByname('QUANTIDADE').AsFloat * Form7.ibDataSet16QUANTIDADE.AsFloat);  //  Valor do ICMS ST retido na UF Emitente
        end else
        begin
          Form7.spdNFeDataSets.Campo('pST_N26a').Value              := '0.00'; // Aliquota suportada pelo consumidor
          Form7.spdNFeDataSets.Campo('vICMSSubstituto_N26b').Value  := '0.00'; // Valor do icms próprio do substituto cobrado em operação anterior
          Form7.spdNFeDataSets.Campo('vbCSTRet_N26').Value          := '0.00'; // Valor cobrado anteriormente por ST Ok
          Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value        := '0.00'; // Valor do ICMS ST em Reais
        end;
      end;
    end;

    // CSOSN 900
    // NOTA DEVOLUCAO D E V
    // Sandro Silva 2023-05-25 if (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '900') or (Form7.ibDataSet14.FieldByname('CSOSN').AsString = '900') then
    if (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '900')
     or ((Form7.ibDataSet16.FieldByname('CSOSN').AsString = '900') and (NFeFinalidadeDevolucao(Form7.ibDataSet15FINNFE.AsString)))
     then
    begin
      // 900 – Outros – Classificam-se neste código as demais operações que não se enquadrem nos códigos 101, 102, 103, 201, 202, 203, 300, 400 e 500.
      //
      // N11 - Já está preenchido acima - todos tem
      // N12a - Já está preenchido acima - todos tem
      try
        Form7.spdNFeDataSets.Campo('modBC_N13').Value  := '3'; // Modalidade de determinação da Base de Cálculo - ver Manual

        if (Form7.ibDataSet16.FieldByname('BASE').AsFloat = 0) then
        begin
          Form7.spdNFeDataSets.Campo('vBC_N15').Value   := '0'; // Valor da Base de Cálculo do ICMS
          Form7.spdNFeDataSets.Campo('vICMS_N17').Value := '0'; // Valor do ICMS em Reais
        end else
        begin
          if (Form7.ibDataSet16.FieldByname('BASE').AsFloat = 0) then
          begin
            Form7.spdNFeDataSets.Campo('vBC_N15').Value   := '0'; // Valor da Base de Cálculo do ICMS
            Form7.spdNFeDataSets.Campo('vICMS_N17').Value := '0'; // Valor do ICMS em Reais
          end else
          begin
            Form7.spdNFeDataSets.Campo('vBC_N15').Value     := FormatFloatXML(Form7.ibDataSet16.FieldByname('BASE').AsFloat*(Form7.ibDataSet16.FieldByname('TOTAL').AsFloat + fSomaNaBase )/100);  // BC
            Form7.spdNFeDataSets.Campo('vICMS_N17').Value   := FormatFloatXML(Form7.ibDataSet16.FieldByname('ICM').AsFloat*(Form7.ibDataSet16.FieldByname('TOTAL').AsFloat + fSomaNaBase )/100*Form7.ibDataSet16.FieldByname('BASE').AsFloat/100);     // Valor do ICMS em Reais
          end;
        end;

        if (100-Form7.ibDataSet16.FieldByname('BASE').AsFloat) <> 0 then
        begin
          Form7.spdNFeDataSets.Campo('pRedBC_N14').Value := FormatFloatXML(100-Form7.ibDataSet16.FieldByname('BASE').AsFloat); // Percentual da redução de BC
        end;

        Form7.spdNFeDataSets.Campo('pICMS_N16').Value   := FormatFloatXML(Form7.ibDataSet16.FieldByname('ICM').AsFloat); // Alíquota do ICMS em Percentual

        Form7.spdNFeDataSets.Campo('modBCST_N18').Value   := '4'; // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual

        if Form7.ibDataSet4PIVA.AsFloat > 0 then
        begin
          if Form7.ibDataSet16.FieldByname('BASE').AsFloat > 0 then
          begin
            Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := FormatFloatXML( (Form7.ibDataSet4PIVA.AsFloat*100)-100 ); // Percentual de margem de valor adicionado do ICMS ST
          end else
          begin
            Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := '100'; // Percentual de margem de valor adicionado do ICMS ST
          end;
        end else
        begin
          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := '100'; // Percentual de margem de valor adicionado do ICMS ST
        end;
        Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '100'; // Percentual de redução de BC do ICMS ST

        if Form7.ibDataSet4PIVA.AsFloat > 0 then
        begin
          if Form7.ibDataSet16.FieldByname('BASE').AsFloat > 0 then
          begin
            // Posiciona na tabéla de CFOP
            if AllTrim(Form7.ibDataSet4ST.Value) <> '' then       // Quando alterar esta rotina alterar também retributa Ok 1/ Abril
            begin
              sReg := Form7.ibDataSet14REGISTRO.AsString;
              Form7.ibDataSet14.DisableControls;
              Form7.ibDataSet14.Close;
              Form7.ibDataSet14.SelectSQL.Clear;
              Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
              Form7.ibDataSet14.Open;
              if not Form7.ibDataSet14.Locate('ST',Form7.ibDataSet4ST.AsString,[loCaseInsensitive, loPartialKey]) then
                Form7.ibDataSet14.Locate('REGISTRO',sReg,[]);
              Form7.ibDataSet14.EnableControls;
            end else
            begin
              Form7.ibDataSet14.DisableControls;
              Form7.ibDataSet14.Close;
              Form7.ibDataSet14.SelectSQL.Clear;
              Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
              Form7.ibDataSet14.Open;
              Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);
              Form7.ibDataSet14.EnableControls;
            end;

            //if ((Form7.ibDataSet14SOBREIPI.AsString = 'S')) and (Form7.ibDataSet16.FieldByname('IPI').AsFloat>0) then
            if (vIPISobreICMS) and (Form7.ibDataSet16.FieldByname('IPI').AsFloat>0) then
            begin
              // IPI Por Unidade
              fIPIPorUnidade := 0;
              if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
              begin
                fIPIPorUnidade := (Form7.ibDataSet16.FieldByname('QUANTIDADE').AsFloat * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString))));
              end;

              // Valor da Base de Calculo de ISMS St do item
              Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', ((
                (((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) +  fIPIPorUnidade)
                +(Form7.ibDataSet16.FieldByname('IPI').AsFloat * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                )
                 * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 * Form7.ibDataSet4PIVA.AsFloat) )),',','.'); // Valor da B ST

              // Desconta o ICM sobre IPI normal do ST   CALCULO DO IVA
              if Form7.AliqICMdoCliente16() < Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  Arredonda(((
                  (((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) +(Form7.ibDataSet16.FieldByname('IPI').AsFloat * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100))
                   * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat),2)
                   -((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))+(Form7.ibDataSet16.FieldByname('IPI').AsFloat * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100)) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100) // Desconta o ICMS Normal
                   ),2))),',','.'); // Valor do ICMS ST em Reais
              end else
              begin
                Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  Arredonda(((
                  (((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))+(Form7.ibDataSet16.FieldByname('IPI').AsFloat * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100))
                   * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat),2)
                   -((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))+(Form7.ibDataSet16.FieldByname('IPI').AsFloat * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100)
                   ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100) // Desconta o ICMS Normal
                  ),2))),',','.'); // Valor do ICMS ST em Reais
              end;
            end else
            begin
              // IPI Por Unidade
              fIPIPorUnidade := 0;
              if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
              begin
                fIPIPorUnidade := (Form7.ibDataSet16.FieldByname('QUANTIDADE').AsFloat * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',Form7.ibDataSet4.FieldByname('TAGS_').AsString))));
              end;
              // Valor da Base de Calculo de ISMS St do item
              if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
              begin
                // VINICULAS
                try
                  Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                    ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                    +(0 * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                    )
                     * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
                except end;
              end else
              begin
                Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                  ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) + fIPIPorUnidade)
                  +(0 * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                  )
                   * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 * Form7.ibDataSet4PIVA.AsFloat),2) )),',','.'); // Valor da B ST
              end;

              // Desconta o ICM sobre IPI normal do ST    CALCULO DO IVA
              if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
              begin
                if Form7.AliqICMdoCliente16() < Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
                begin
                  Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                    Arredonda(((
                    (((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
                    + (Form7.ibDataSet16.FieldByname('IPI').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) / 100)
                    )
                    ) * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                    - ((
                    ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
                    + (Form7.ibDataSet16.FieldByname('IPI').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) / 100) // Teste inclui esta linha
                    ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )
                    ),2))),',','.'); // Valor do ICMS ST em Reais
                end else
                begin
                  Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00',
                    Arredonda(
                    ((
                    (((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
                    + (Form7.ibDataSet16.FieldByname('IPI').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) / 100)
                    )) * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 *
                    Form7.AliqICMdoCliente16()
                     / 100 ) * Form7.ibDataSet4PIVA.AsFloat,2)
                    -
                    Arredonda(
                    ((
                    (((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) + fIPIPorUnidade)
                    + (Form7.ibDataSet16.FieldByname('IPI').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) / 100)
                    )) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *
                    Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat
                     / 100 ),2)
                    )),',','.'); // Valor do ICMS ST em Reais
                end;
              end else
              begin
                if Form7.AliqICMdoCliente16() < Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
                begin
                  Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                    Arredonda(((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                    +(0 * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                    ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                    - ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                    +(0 * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                    ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )
                    ),2) )),',','.'); // Valor do ICMS ST em Reais
                end else
                begin
                  Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00', Arredonda((
                    Arredonda(((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                    +(0 * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                    ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.AliqICMdoCliente16() / 100 )* Form7.ibDataSet4PIVA.AsFloat,2)
                    - ((((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto))
                    +(0 * ((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) / 100) // Teste inclui esta linha
                    ) * Form7.ibDataSet16.FieldByname('BASE').AsFloat / 100 *  Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )
                    ),2) )),',','.'); // Valor do ICMS ST em Reais
                end;
              end;
            end;
          end else
          begin
            Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := '0'; // Valor da B ST
            Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := '0';
          end;
        end else
        begin
          Form7.spdNFeDataSets.Campo('vbCST_N21').Value       := '0'; // Valor cobrado anteriormente por ST
          Form7.spdNFeDataSets.Campo('vICMSST_N23').Value     := '0';  // Valor do ICMS ST em Reais
        end;

        if Form7.spdNFeDataSets.Campo('vICMSST_N23').Value <> '0' then // Mudei 11/05/2022
        begin
          Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   := FormatFloatXML(Form7.AliqICMdoCliente16()); // Alíquota do ICMS em Percentual
        end else
        begin
          Form7.spdNFeDataSets.Campo('pICMSST_N22').Value     := '0';       // Alíquota do ICMS em Percentual
          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value      := '0.00';   // Percentual de margem de valor adicionado do ICMS ST
          Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '0.00';  // Percentual de redução de BC do ICMS ST
        end;

        if Copy(Form7.ibDataSet14OBS.AsString,1,24) = 'PERMITE O APROVEITAMENTO' then
        begin
          // PERMITE O APROVEITAMENTO DO CRÉDITO DE ICMS NO VALOR DE R$; CORRESPONDENTE Á ALÍQUOTA DE 2,82%, NOS TERMOS DO ART. 23 DA LC 123
          try
            fAliquota := StrToFloat(Alltrim(StrTran(Copy(Form7.ibDataSet14OBS.AsString,90,4),'.',',')));
          except
            fAliquota := 2.82;
          end;
        end else
        begin
          fAliquota := 0;
        end;

        try
          Form7.spdNFeDataSets.Campo('pCredSN_N29').VAlue       := FormatFloatXML(fAliquota); // Aliquota aplicave de cálculo de crédito (Simples Nacional)
          Form7.spdNFeDataSets.Campo('vCredICMSSN_N30').VAlue   := FormatFloatXML(((Form7.ibDataSet16.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)) * fAliquota / 100); // VAlor de crédito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)
        except
        end;

        try
          // Sandro Silva 2023-05-15 if Form7.ibDataSet16.FieldByname('PFCP').AsFloat <> 0 then
          if fPercentualFCP <> 0 then
          begin
            Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := FormatFloatXML(Form7.ibDataSet16.FieldByname('VBCFCP').AsFloat); // Valor da Base de Cálculo do FCP
            Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(fPercentualFCP); // Percentual do Fundo de Combate à Pobreza (FCP)
            Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(Form7.ibDataSet16.FieldByname('VFCP').AsFloat); // Valor do Fundo de Combate à Pobreza (FCP)
          end;

          // Sandro Silva 2023-05-15 if Form7.ibDataSet16.FieldByname('PFCPST').AsFloat <> 0 then
          if fPercentualFCPST <> 0 then
          begin
            Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(Form7.ibDataSet16.FieldByname('VBCFCPST').AsFloat); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(fPercentualFCPST); // Percentual do FCP retido por Substituição Tributária

            if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
            begin
              Form7.spdNFeDataSets.campo('vFCPST_N23d').Value  := FormatFloatXML(Form7.ibDataSet16.FieldByname('VFCPST').AsFloat); // Valor do FCP retido por Substituição Tributária
            end else
            begin
              Form7.spdNFeDataSets.campo('vFCPST_N23d').Value  := FormatFloatXML(Form7.ibDataSet16.FieldByname('VFCPST').AsFloat); // Valor do FCP retido por Substituição Tributária
            end;
          end;
        except
        end;

      except
        on E: Exception do
        begin
          //Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+ 'ao calcular FCP.'),'Atenção',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
          MensagemSistema(E.Message+chr(10)+chr(10)+ 'ao calcular FCP.',msgErro);
        end;
      end;
    end;

    if Form1.sVersaoLayout = '4.00' then
    begin
      try
        // Sandro Silva 2023-05-04 fCalculo := (Form7.ibDataSet16.FieldByname('BASE').AsFloat * (Form7.ibDataSet16.FieldByname('TOTAL').AsFloat + fSomaNaBase ) / 100) * Form7.ibDataSet16PFCP.AsFloat / 100;

        if Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '201' then
        begin
          // fPercentualFCPST
          // Sandro Silva 2023-05-15 if Form7.ibDataSet16PFCPST.AsFloat <> 0 then
          if fPercentualFCPST <> 0 then
          begin
            { // Sandro Silva 2023-05-04
            //Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(Form7.ibDataSet16VBCFCPST.AsFloat); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(Form7.ibDataSet16PFCPST.AsFloat); // Percentual do FCP retido por Substituição Tributária

            if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
            begin
              //Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0' + Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',',')) * Form7.ibDataSet16PFCPST.AsFloat / 100) - (fCalculo)); // Valor do FCP retido por Substituição Tributária
              Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML(Form7.ibDataSet16VFCPST.AsFloat); // Valor do FCP retido por Substituição Tributária
            end else
            begin
              //Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0' + Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,'.',',')) * Form7.ibDataSet16PFCPST.AsFloat / 100)); // Valor do FCP retido por Substituição Tributária
              Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML(Form7.ibDataSet16VFCPST.AsFloat); // Valor do FCP retido por Substituição Tributária
            end;
            }
            Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(Form7.ibDataSet16VBCFCPST.AsFloat); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(fPercentualFCPST); // Percentual do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML(Form7.ibDataSet16VFCPST.AsFloat); // Valor do FCP retido por Substituição Tributária

          end;
        end;

        if (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '202') or (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '203') then
        begin
          // fPercentualFCPST
          // Sandro Silva 2023-05-15 if Form7.ibDataSet16PFCPST.AsFloat <> 0 then
          if fPercentualFCPST <> 0 then
          begin
            {
            //Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(StrToFloat(StrTran(StrTran('0'+Form7.spdNFeDataSets.Campo('vbCST_N21').AsString,',',''),'.',','))); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(Form7.ibDataSet16VBCFCPST.AsFloat); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(Form7.ibDataSet16PFCPST.AsFloat); // Percentual do FCP retido por Substituição Tributária

            if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
            begin
              //Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0' + Form7.spdNFeDataSets.Campo('vbCST_N21').AsString, '.', ',')) * Form7.ibDataSet16PFCPST.AsFloat / 100) - (fCalculo)); // Valor do FCP retido por Substituição Tributária
              Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML(Form7.ibDataSet16VFCPST.AsFloat); // Valor do FCP retido por Substituição Tributária
            end else
            begin
              //Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0' + Form7.spdNFeDataSets.Campo('vbCST_N21').AsString, '.', ',')) * Form7.ibDataSet16PFCPST.AsFloat / 100)); // Valor do FCP retido por Substituição Tributária
              Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML(Form7.ibDataSet16VFCPST.AsFloat); // Valor do FCP retido por Substituição Tributária
            end;
            }
            Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(Form7.ibDataSet16VBCFCPST.AsFloat); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(fPercentualFCPST); // Percentual do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML(Form7.ibDataSet16VFCPST.AsFloat); // Valor do FCP retido por Substituição Tributária

          end;
        end;

        if (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '500') then
        begin
          //                            Form7.spdNFeDataSets.campo('vBCFCPSTRet_N27a').Value := '0.00'; // Valor da Base de Cálculo do FCP retido anteriormente por ST
          //                            Form7.spdNFeDataSets.campo('pFCPSTRet_N27b').Value   := '0.00'; // Percentual do FCP retido anteriormente por Substituição Tributária
          //                            Form7.spdNFeDataSets.campo('vFCPSTRet_N27d').Value   := '0.00'; // Valor do FCP retido por Substituição Tributária
        end;

        // NOTA DEVOLUCAO D E V
        // Sandro Silva 2023-05-25 if (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '900') or (Form7.ibDataSet14.FieldByname('CSOSN').AsString = '900') then
        if (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '900') or (Form7.ibDataSet16.FieldByname('CSOSN').AsString = '900') then
        begin
          try
            // fPercentualFCPST
            // Sandro Silva 2023-05-15 if Form7.ibDataSet16PFCPST.AsFloat <> 0 then
            if fPercentualFCPST <> 0 then
            begin
              {
              //Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(StrToFloat(StrTran(StrTran('0' + Form7.spdNFeDataSets.Campo('vbCST_N21').AsString, ',', ''), '.', ','))); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
              Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(Form7.ibDataSet16VBCFCPST.AsFloat); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
              Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(Form7.ibDataSet16PFCPST.AsFloat); // Percentual do FCP retido por Substituição Tributária

              if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
              begin
                //Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0' + Form7.spdNFeDataSets.Campo('vbCST_N21').AsString, '.', ',')) * Form7.ibDataSet16PFCPST.AsFloat / 100) - (fCalculo)); // Valor do FCP retido por Substituição Tributária
                Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML(Form7.ibDataSet16VFCPST.AsFloat); // Valor do FCP retido por Substituição Tributária
              end else
              begin
                //Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML((StrToFloat(StrTran('0' + Form7.spdNFeDataSets.Campo('vbCST_N21').AsString, '.', ',')) * Form7.ibDataSet16PFCPST.AsFloat / 100)); // Valor do FCP retido por Substituição Tributária
                Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML(Form7.ibDataSet16VFCPST.AsFloat); // Valor do FCP retido por Substituição Tributária
              end;
              }
              //Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(StrToFloat(StrTran(StrTran('0' + Form7.spdNFeDataSets.Campo('vbCST_N21').AsString, ',', ''), '.', ','))); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
              Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(Form7.ibDataSet16VBCFCPST.AsFloat); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
              Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(fPercentualFCPST); // Percentual do FCP retido por Substituição Tributária
              Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML(Form7.ibDataSet16VFCPST.AsFloat); // Valor do FCP retido por Substituição Tributária

            end;
          except
            on E: Exception do
            begin
              //Application.MessageBox(pChar(E.Message + chr(10) + chr(10) + 'ao calcular Percentual do FCP retido por Substituição Tributária CSOSN 900'), 'Atenção', mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
              MensagemSistema(E.Message + chr(10) + chr(10) + 'ao calcular Percentual do FCP retido por Substituição Tributária CSOSN 900',msgErro);
            end;
          end;
        end;
      except
        on E: Exception do
        begin
          //Application.MessageBox(pChar(E.Message + chr(10) + chr(10) + 'ao calcular FCP 2.'), 'Atenção', mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
          MensagemSistema(E.Message + chr(10) + chr(10) + 'ao calcular FCP 2.',msgErro);
        end;
      end;
    end;

    {Sandro Silva 2023-06-01 inicio}
    if Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '61' then
    begin
      // Ficha 6907
      // Simples nacional usa CST 61 no lugar do CSOSN
      if (Form7.ibDataSet13.FieldByname('CRT').AsString <> '1')
      or (not NFeFinalidadeDevolucao(Form7.spdNFeDataSets.Campo('finNFe_B25').Value))
      //if Form7.spdNFeDataSets.Campo('CSOSN_N12a').AsString = '61'
      then
      begin
        Form7.spdNFeDataSets.Campo('CSOSN_N12a').Clear;
        Form7.spdNFeDataSets.Campo('CST_N12').AsString := '61';
      end;
    end;
    {Sandro Silva 2023-06-01 fim}

    // Final TAGS saída por CSOSN - CRT = 1 imples Nacional
  end;

  {Sandro Silva 2023-06-07 inicio}
  //qBCMonoRet = será igual à quantidade do produto informado na nota
  //adRemICMSRet = buscar da tag adRemICMSRet do cadastro do produto
  //vICMSMonoRet = multiplicar o valor da tag qBCMonoRet pelo valor da tag adRemICMSRet

  // Não é posssível informar CSOSN 61. Para CSOSN 61 será criado no grupo imposto a tag CST
  if (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '61')
    or (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '61') // Sandro Silva 2023-06-12
  then
  begin
    sMensagemIcmMonofasicoSobreCombustiveis := 'ICMS monofásico sobre combustíveis cobrado anteriormente conforme Convênio ICMS 199/2022;';

    Form7.spdNFeDataSets.Campo('vBC_N15').Value     := '0.00';  // BC
    Form7.spdNFeDataSets.Campo('vICMS_N17').Value   := '0.00';  // Valor do ICMS em Reais

    Form7.spdNFeDataSets.Campo('qBCMonoRet_N43a').Value  := Form7.spdNFeDataSets.Campo('qCom_I10').Value;
    dqBCMonoRet_N43aTotal := dqBCMonoRet_N43aTotal + XmlValueToFloat(Form7.spdNFeDataSets.Campo('qCom_I10').Value); // Sandro Silva 2023-09-04
    Form7.spdNFeDataSets.Campo('adRemICMSRet_N44').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('adRemICMSRet', Form7.ibDataSet4.FieldByname('TAGS_').AsString), 0.00), 4);
    dvICMSMonoRet_N45       := XmlValueToFloat(Form7.spdNFeDataSets.Campo('qBCMonoRet_N43a').AsString) * XmlValueToFloat(Form7.spdNFeDataSets.Campo('adRemICMSRet_N44').AsString);
    // Sandro Silva 2023-09-04 dvICMSMonoRet_N45Total := dvICMSMonoRet_N45Total + dvICMSMonoRet_N45;

    Form7.spdNFeDataSets.Campo('vICMSMonoRet_N45').Value := FormatFloatXML(dvICMSMonoRet_N45);

    dvICMSMonoRet_N45Total := dvICMSMonoRet_N45Total + XmlValueToFloat(Form7.spdNFeDataSets.Campo('vICMSMonoRet_N45').Value); // Sandro Silva 2023-09-04
  end;
  {Sandro Silva 2023-06-07 fim}
end;

end.
