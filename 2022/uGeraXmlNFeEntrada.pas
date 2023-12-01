unit uGeraXmlNFeEntrada;

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
  , uFuncoesFiscais
  , uFuncoesRetaguarda
;

var
  sCodigoANP : string;

  // Rateio
  fCalculo, vFRETE, vOUTRAS, vDESCONTO, vSEGURO : Real;
  fDesconto, fFrete, fOutras, fSeguro : array[0..999] of double;
  sMensagemIcmMonofasicoSobreCombustiveis: String; // Sandro Silva 2023-06-16
  dqBCMonoRet_N43aTotal: real; // Sandro Silva 2023-09-04
  dvICMSMonoRet_N45Total: Real; // Sandro Silva 2023-09-04

  procedure GeraXmlNFeEntrada;
  procedure GeraXmlNFeEntradaTags;

implementation

uses uDialogs, ufrmOrigemCombustivel;

procedure GeraXmlNFeEntrada;
var
  fNFe: String; // Sandro Silva 2022-09-12

  spMVAST, spICMSST, sChave, sEx1, sEx2, sEx3, sEx4, sEx5, sEx6, sEx7, sEx8, sEx9, sEx10, sEx11, sEx12, sEx13, sEx14, sEx15, sEx16, sEx17, sEx18 : String;
  fTotalDupl, vTotalImpostoImportacao : Real;

  I, J, iAnoRef : integer;
  sReg : String;
  sComplemento : String;
  sRetorno : String;
  sRecibo : String;
  sCupomReferenciado : String;
  sDentroOuForadoEStado, sUFEmbarq, sLocaldeEmbarque, sLocalDespacho, sPais, sCodPais : String;
  vST, vBC, vBCST, vPIS, vPIS_S, vCOFINS, vCOFINS_S, vICMS : Real;
  fTotaldeTriubutos, fTotaldeTriubutos_uf, fTotaldeTriubutos_muni : Real;
  Mais1Ini : tIniFile;

  // Pis cofins da Operação
  sCST_PIS_COFINS : String;
  rpPIS, rpCOFINS : Real;
  bTributa : Boolean;

  sDIFAL_OBS : String;
  fAliquotaPadrao, fPercentualDeReducaoDeBC, fICMSDesonerado, vICMSDeson, fFCPST, fFCPUFDest, fICMSUFDest, fICMSUFREmet, fDIFAL, fIPIDevolvido,  fPercentualFCPST, fFCP: Real;
  
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
  dQtdAcumulado: Double;
  IBQUERY99: TIBQuery; // Sandro Silva 2022-11-10 Para Substituir Form7.IBDATASET99 que é usado em eventos disparados em cascata
begin
  Form7.ibDataSet24.Close;
  Form7.ibDataSet24.SelectSQL.Clear;
  Form7.ibDataSet24.SelectSQL.Add('select * from COMPRAS where NUMERONF='+QuotedStr(Copy(Form7.ibDataSet15NUMERONF.AsString,1,12))+' and FORNECEDOR='+QuotedStr(Form7.ibDataSet15CLIENTE.AsString) );
  Form7.ibDataSet24.Open;

  Form7.ibDataSet14.Close;
  Form7.ibDataSet14.SelectSQL.Clear;
  Form7.ibDataSet14.SelectSQL.Add('select * FROM ICM order by upper(NOME)');
  Form7.ibDataSet14.Open;

  Form7.ibDataSet8.Close;
  Form7.ibDataSet8.DataSource := Form7.DataSource24;
  Form7.ibDataSet8.Selectsql.Clear;
  Form7.ibDataSet8.Selectsql.Add('select * from PAGAR where NUMERONF=:NUMERONF and NOME=:FORNECEDOR');
  Form7.ibDataSet8.Open;

  Form7.ibDataSet23.Close;
  Form7.ibDataSet23.DataSource  := Form7.DataSource24;
  Form7.ibDataSet23.Selectsql.Clear;
  Form7.ibDataSet23.Selectsql.Add('select * from ITENS002 where NUMERONF=:NUMERONF and FORNECEDOR=:FORNECEDOR');
  Form7.ibDataSet23.Open;

  Form7.ibDataSet24.EnableControls;

  LogRetaguarda('Form7.ibDataSet24.EnableControls; 125'); // Sandro Silva 2023-11-27

  Form7.ibDataSet23.EnableControls;

  if AllTrim(Form7.ibDataSet15OPERACAO.AsString) = '' then
    Form7.ibDataSet14.Append
  else
    Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);

  // Pis cofins da Operação
  sCST_PIS_COFINS := Form7.ibDataSet14.FieldByname('CSTPISCOFINS').AsString;
  rpPIS           := Form7.ibDataSet14.FieldByname('PPIS').AsFloat;
  rpCOFINS        := Form7.ibDataSet14.FieldByname('PCOFINS').AsFloat;

  // Relaciona os clientes com o arquivo de vendas
  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet15CLIENTE.AsString)+' ');  //
  Form7.ibDataSet2.Open;

  Form7.ibDataSet18.Locate('NOME',Form7.ibDataSet24TRANSPORTA.AsString,[]);

  IBQUERY99 := Form7.CriaIBQuery(Form7.IBDataSet99.Transaction);

  // Informações do Emitente da NFe
  IBQUERY99.Close;
  IBQUERY99.SQL.Clear;
  IBQUERY99.SQL.Add('select * from MUNICIPIOS where NOME='+QuotedStr(Form7.ibDataSet13MUNICIPIO.AsString)+' '+' and UF='+QuotedStr(UpperCase(Form7.ibDataSet13ESTADO.AsString))+' ');
  IBQUERY99.Open;

  if AllTrim(Copy(IBQUERY99.FieldByname('CODIGO').AsString,1,7)) = '' then
  begin
    Form7.ibDataset15.Edit;
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

  if Form1.sVersaoLayout = '4.00' then // Ok
  begin
    Form7.spdNFeDataSets.Campo('versao_A02').Value  := '4.00'; // Versão do Layout que está utilizando
  end else
  begin
    Form7.spdNFeDataSets.Campo('versao_A02').Value  := '3.10'; // Versão do Layout que está utilizando
  end;

  Form7.spdNFeDataSets.Campo('cUF_B02').Value     := Copy(IBQUERY99.FieldByname('CODIGO').AsString,1,2);  //Codigo da UF para o estado SC = '42'
  Form7.spdNFeDataSets.Campo('cNF_B03').Value     := '004640327'; // Código Interno do Sistema que está integrando com a NFe
  Form7.spdNFeDataSets.Campo('natOp_B04').Value   := ConverteAcentos2(Form7.ibDataSet15.FieldByname('OPERACAO').AsString);

  if Copy(Form7.ibDataSet15.FieldByname('OPERACAO').AsString,1,13) = '999 - Estorno' then
  begin
    sChave                                      := Form1.Small_InputForm('NFe', 'Chave de acesso da NF-e referenciada (ID da NF-e)', '');

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
        Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+'ao gravar NREF 1'
        ),'Atenção', mb_Ok + MB_ICONWARNING);
        Mauricio Parizotto 2023-10-25}
        MensagemSistema(E.Message+chr(10)+chr(10)+'ao gravar NREF 1',msgAtencao);
      end;
    end;

    try
      Form7.spdNFeDataSets.Campo('finNFe_B25').Value  := '3'; // Finalidade da NFe (1-Normal, 2-Complementar, 3-de Ajuste, 4-Devolução de mercadoria)
      Form7.spdNFeDataSets.Campo('natOp_B04').Value   := '999 - Estorno de NF-e não cancelada no prazo legal';
    except
      //ShowMessage('Erro ao gravar natOp_B04'); Mauricio Parizotto 2023-10-25
      MensagemSistema('Erro ao gravar natOp_B04',msgErro);
    end;
  end else
  begin
    if Form7.ibDataSet24FINNFE.AsString = '2' then
    begin
      sChave                                      := Form1.Small_InputForm('NFe', 'Chave de acesso da NF-e referenciada (ID da NF-e)', '');

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
      if Form7.ibDataSet24FINNFE.AsString = '4'  then
      begin
        sChave                                      := Form1.Small_InputForm('NFe', pChar('Chave de acesso da NF-e de devolução referenciada'+chr(10)+
                                                                                          '(ID da NF-e) ou Número do ECF (3) + COO (6) para'+chr(10)+
                                                                                          'cupom fiscal referenciado') , '');
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

    Form7.spdNFeDataSets.Campo('finNFe_B25').Value     := Form7.ibDataSet24FINNFE.AsString; // Finalidade da NFe (1-Normal, 2-Complementar, 3-de Ajuste, 4-Devolução de mercadoria)
  end;

  Form7.spdNFeDataSets.Campo('indFinal_B25a').Value  := Form7.ibDataSet24INDFINAL.AsString; // Indica operação com Consumidor final] deve ser preenchido. Dica: Utilize: 0-Não, 1-Consumidor Final'. Process stopped. Use Step or Run to continue.
  Form7.spdNFeDataSets.Campo('indPres_B25b').Value   := Form7.ibDataSet24INDPRES.AsString;  // Indicador de presença do comprador no estabelecimento comercial.. Utilize: 0-Não, 1-Operação presencial, 2-Operação não presencial, Internet, 3-Operação Não presencial, teleatendimento, 9-Operação não presencial, outros.'.

  if Form1.sVersaoLayout = '4.00' then // Ok
  begin

  end else
  begin
    if Form7.ibDataSet14.FieldByname('INTEGRACAO').AsString = 'Pagar' then
    begin
      Form7.spdNFeDataSets.Campo('indPag_B05').Value  := '1'; //Indicador da Forma de Pgto (0=Pagamento à vista; 1=Pagamento à prazo; 2=outros)
    end else
    begin
      if AllTrim(Form7.ibDataSet14.FieldByname('INTEGRACAO').AsString) = '' then
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
  Form7.spdNFeDataSets.Campo('dhEmi_B09').Value    := StrTran(DateToStrInvertida(Form7.ibDataSet24.FieldByname('EMISSAO').AsDateTime),'/','-')+'T'+TimeToStr(Time)+Form7.sFuso; // Data de Emissão da Nota Fiscal

  // Permite data e hora de saída em branco
  if AllTrim(Form7.ibDataSet24.FieldByname('SAIDAD').AsString) <> '' then
  begin
    Form7.spdNFeDataSets.Campo('dhSaiEnt_B10').Value := StrTran(DateToStrInvertida(Form7.ibDataSet24.FieldByname('SAIDAD').AsDateTime),'/','-')+'T'+Form7.ibDataSet15.FieldByname('SAIDAH').AsString+Form7.sFuso; // Data de Saída ou Entrada da Nota Fiscal
    if Form7.spdNFeDataSets.Campo('dhSaiEnt_B10').Value < Form7.spdNFeDataSets.Campo('dhEmi_B09').Value then Form7.spdNFeDataSets.Campo('dhSaiEnt_B10').Value := Form7.spdNFeDataSets.Campo('dhEmi_B09').Value;
  end;

  Form7.spdNFeDataSets.Campo('tpNF_B11').Value     := '0'; // Tipo de Documento Fiscal (0-Entrada, 1-Saída)

  // Identificador do local de destino da operação 1-Operação Interna, 2-Operação Interestadual e 3-Operação com exterior
  if Copy(Form7.ibDataSet14CFOP.AsString,1,1) = '3' then
  begin
    Form7.spdNFeDataSets.Campo('idDest_B11a').Value  := '3'; // Identificador do local de destino da operação 1-Operação Interna, 2-Operação Interestadual e 3-Operação com exterior
  end else
  begin
    if (UpperCase(Form7.ibDataSet2ESTADO.AsString) <> UpperCase(Form7.ibDataSet13ESTADO.AsString))  then
    begin
      Form7.spdNFeDataSets.Campo('idDest_B11a').Value  := '2'; // Identificador do local de destino da operação 1-Operação Interna, 2-Operação Interestadual e 3-Operação com exterior
    end else
    begin
      Form7.spdNFeDataSets.Campo('idDest_B11a').Value  := '1'; // Identificador do local de destino da operação 1-Operação Interna, 2-Operação Interestadual e 3-Operação com exterior
    end;
  end;

  Form7.spdNFeDataSets.Campo('cMunFG_B12').Value   := Copy(IBQUERY99.FieldByname('CODIGO').AsString,1,7); // Código da Cidade do Emitente (Tabela do IBGE)

  // B20a Tag Nota de Produtor Rural
  if Copy(Form7.ibDAtaset2.FieldByname('IE').AsString,1,2) = 'PR' then // Produtor Rural
  begin
    Form11.ShowModal; // Nota de Produtor Rural
    try
      Form7.spdNFeDataSets.IncluirPart('NREF');
      //
      Form7.ibDataset100.Close;
      Form7.ibDataset100.SelectSql.Clear;
      Form7.ibDataset100.SelectSQL.Add('select * from MUNICIPIOS where UF='+QuotedStr(UpperCase(Form11.Edit1.Text))+' ');
      Form7.ibDataset100.Open;
      {
        //
     Form7.spdNFeDataSets.Campo('cUF_BA04').Value   := Copy(Form7.ibDataset100.FieldByname('CODIGO').AsString,1,2);  // Código da UF do emitente do Documento Fiscal
      Form7.spdNFeDataSets.Campo('AAMM_BA05').Value  := Form11.Edit2.Text; // Ano e Mês de emissão da NF-e
      //
      if Length(LimpaNumero(Form11.Edit3.Text)) = 11 then
      begin
        Form7.spdNFeDataSets.Campo('CPF_BA14').Value  := LimpaNumero(Form11.Edit3.Text); // CPF do emitente
      end else
      begin
        Form7.spdNFeDataSets.Campo('CNPJ_BA06').Value  := LimpaNumero(Form11.Edit3.Text); // CNPJ do emitente
      end;
      //
      Form7.spdNFeDataSets.Campo('mod_BA07').Value   := '01'; // Modelo do documento fiscal
      Form7.spdNFeDataSets.Campo('serie_BA08').Value := IntToStr(StrToInt(LimpaNumero(Form11.Edit5.Text))); // Série
      Form7.spdNFeDataSets.Campo('nNF_BA09').Value   := IntToStr(StrToInt(LimpaNumero(Form11.Edit6.Text))); // Número do documento fiscal
      //
      }

      Form7.spdNFeDataSets.Campo('cUF_BA11').Value   := Copy(Form7.ibDataset100.FieldByname('CODIGO').AsString,1,2);  // Código da UF do emitente do Documento Fiscal
      Form7.spdNFeDataSets.Campo('AAMM_BA12').Value  := Form11.Edit2.Text; // Ano e Mês de emissão da NF-e

      if length(LimpaNumero(Form11.Edit3.Text)) = 11 then
      begin
        Form7.spdNFeDataSets.Campo('CPF_BA14').Value  := LimpaNumero(Form11.Edit3.Text); // CPF do emitente
      end else
      begin
        Form7.spdNFeDataSets.Campo('CNPJ_BA13').Value  := LimpaNumero(Form11.Edit3.Text); // CNPJ do emitente
      end;

      if LimpaNumero(Form11.Edit4.Text) = '' then
      begin
        Form7.spdNFeDataSets.Campo('IE_BA15').Value      := 'ISENTO'; // IE do emitente
      end else
      begin
        Form7.spdNFeDataSets.Campo('IE_BA15').Value      := LimpaNumero(Form11.Edit4.Text); // IE do emitente
      end;

      Form7.spdNFeDataSets.Campo('mod_BA16').Value   := Copy(Form11.ComboBox7.Items[Form11.ComboBox7.ItemIndex]+'04',1,2); // Informar o código 04 - NF de Produtor ou 01 - Para NF avulsa
      Form7.spdNFeDataSets.Campo('serie_BA17').Value := IntToStr(StrToInt(LimpaNumero(Form11.Edit5.Text))); // Série
      Form7.spdNFeDataSets.Campo('nNF_BA18').Value   := IntToStr(StrToInt(LimpaNumero(Form11.Edit6.Text))); // Número do documento fiscal

      Form7.spdNFeDataSets.SalvarPart('NREF');
    except
      on E: Exception do
      begin
        {
        Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+ ' ao criar xml para nota de produtor rural.'
        ),'Atenção',mb_Ok + MB_ICONWARNING);
        Mauricio Parizotto 2023-10-25}
        MensagemSistema(E.Message+chr(10)+chr(10)+ ' ao criar xml para nota de produtor rural.',msgAtencao);
      end;
    end;
  end;

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

  if Form1.bHomologacao then Form7.spdNFeDataSets.Campo('tpAmb_B24').Value := '2' else Form7.spdNFeDataSets.Campo('tpAmb_B24').Value := '1';

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

  Form7.spdNFeDataSets.Campo('IE_C17').Value := LimpaNumero(Form7.ibDataSet13.FieldByname('IE').AsString); // Inscrição Estadual do Emitente

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

  // Informações do Destinatário da NFe
  if Form7.ibDAtaset2ESTADO.AsString <> 'EX' then
  begin
    // Informações do Destinatário da NFe
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
      Form7.spdNFeDataSets.Campo('CNPJ_E02').Value      := '99999999000191'; // CNPJ do Destinatário
      Form7.spdNFeDataSets.Campo('xNome_E04').Value     := 'NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL'; // Razao social ou Nome do Destinatário
      Form7.spdNFeDataSets.Campo('IE_E17').Value        := '';
      //
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

    Form7.spdNFeDataSets.Campo('xLgr_E06').Value    := ConverteAcentos2(ExtraiEnderecoSemONumero(Form7.ibDAtaset2.FieldByname('ENDERE').AsString)); // Logradouro do Destinatario // Sandro Silva 2023-10-16 Form7.spdNFeDataSets.Campo('xLgr_E06').Value    := ConverteAcentos2(Endereco_Sem_Numero(Form7.ibDAtaset2.FieldByname('ENDERE').AsString)); // Logradouro do Emitente
    Form7.spdNFeDataSets.Campo('nro_E07').Value     := ExtraiNumeroSemOEndereco(Form7.ibDAtaset2.FieldByname('ENDERE').AsString); // Numero do Logradouro do Destinatario // Sandro Silva 2023-10-16 Form7.spdNFeDataSets.Campo('nro_E07').Value     := Numero_Sem_Endereco(Form7.ibDAtaset2.FieldByname('ENDERE').AsString); // Numero do Logradouro do Emitente

    Form7.spdNFeDataSets.Campo('xBairro_E09').Value := Alltrim(ConverteAcentos2(Form7.ibDAtaset2.FieldByname('COMPLE').AsString)); // Bairro do Destinatario
    Form7.spdNFeDataSets.Campo('cMun_E10').Value    := Copy(IBQUERY99.FieldByname('CODIGO').AsString,1,7); // Código do Município do Destinatário (Tabela IBGE)

    Form7.spdNFeDataSets.Campo('xMun_E11').Value    := Alltrim(ConverteAcentos2(IBQUERY99.FieldByname('NOME').AsString)); //Nome da Cidade do Destinatário
    Form7.spdNFeDataSets.Campo('UF_E12').Value      := IBQUERY99.FieldByname('UF').AsString; // Sigla do Estado do Destinatário

    Form7.spdNFeDataSets.Campo('CEP_E13').Value     := LimpaNumero(Form7.ibDAtaset2.FieldByname('CEP').AsString); // Cep do Destinatário
    Form7.spdNFeDataSets.Campo('cPais_E14').Value   := '1058'; // Código do Pais do Destinatário (Tabela do BACEN)
    Form7.spdNFeDataSets.Campo('xPais_E15').Value   := 'BRASIL';// Nome do País do Destinatário

    if Length(LimpaNumero(Form7.ibDAtaset2.FieldByname('FONE').AsString)) = 11 then
      Form7.spdNFeDataSets.Campo('fone_E16').Value    := Copy(LimpaNumero(Form7.ibDAtaset2.FieldByname('FONE').AsString),2,10) else Form7.spdNFeDataSets.Campo('fone_E16').Value    := LimpaNumero(Form7.ibDAtaset2.FieldByname('FONE').AsString); // Fone do Destinatário

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
      end else
      begin
        if (Length(AllTrim(Form7.ibDAtaset2CGC.AsString)) = 18) then
        begin
          if AllTrim(Form7.ibDAtaset2.FieldByname('IE').AsString) = '' then
          begin
            // Form7.ibDAtaset2.Edit;
            // Form7.ibDAtaset2.FieldByname('IE').AsString := 'ISENTO';
            // Form7.spdNFeDataSets.Campo('IE_E17').Value        := Form7.ibDAtaset2.FieldByname('IE').AsString; // Inscrição Estadual do Destinatário
            Form7.spdNFeDataSets.Campo('IE_E17').Value          := '';
            Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value  := '9'; // 1-Contribuinte; 2-Isento; 9-Não contribuinte
          end else
          begin
            if not ConsisteInscricaoEstadual(LimpaNumero(Form7.ibDAtaset2IE.AsString),Form7.ibDAtaset2ESTADO.AsString) then
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
              if Form7.ibDAtaset2.FieldByname('IE').AsString = 'ISENTO' then
              begin
                Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value  := '2'; // 1-Contribuinte; 2-Isento; 9-Não contribuinte
              end else
              begin
                Form7.ibDataSet15.Edit;
                Form7.ibDataSet15STATUS.AsString    := 'Erro: Inscrição Estadual Inválida';
                Abort;
              end;
            end;
          end;
        end else
        begin
          Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value  := '9';   // 1-Contribuinte; 2-Isento; 9-Não contribuinte
          Form7.spdNFeDataSets.Campo('IE_E17').Value          := '';

          // quando é CPF não deve mostrar o IE
        end;
      end;
    end;
  end else
  begin
    // Vendedor estrangeiro
    Form7.spdNFeDataSets.Campo('xLgr_E06').Value    := ConverteAcentos2(ExtraiEnderecoSemONumero(Form7.ibDAtaset2.FieldByname('ENDERE').AsString)); // Logradouro do  // Sandro Silva 2023-10-16 Form7.spdNFeDataSets.Campo('xLgr_E06').Value    := ConverteAcentos2(Endereco_Sem_Numero(Form7.ibDAtaset2.FieldByname('ENDERE').AsString)); // Logradouro do Emitente
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

    if Copy(Form7.ibDataSet14CFOP.AsString,1,1) <> '3' then
    begin
      Form7.spdNFeDataSets.Campo('cPais_E14').Value            := '1058';  // Código do Pais do Destinatário (Tabela do BACEN)
      Form7.spdNFeDataSets.Campo('xPais_E15').Value            := 'Brasil';    // Nome do País do Destinatário
      Form7.spdNFeDataSets.Campo('idEstrangeiro_E03a').Value   := Form1.Small_InputForm('Identificação de estrangeiro','Número do passaporte ou documento legal do comprador estrangeiro: ',''); // Identificacao do destinatario no caso de comprador estrangeiro
    end else
    begin
      // Importação
      sEx3 := '';
      Mais1ini := TIniFile.Create(Form1.sAtual+'\importac.ini');
      //
      sPais    := 'Estados Unidos';
      sCodPais := '2496';
      sEx1     := Mais1Ini.ReadString('DI','Ex1','999999999');
      sEx2     := Mais1Ini.ReadString('DI','Ex2','2010-12-01');
      sEx3     := Mais1Ini.ReadString('DI','Ex3','Alfandega do porto de Santos');
      sEx4     := Mais1Ini.ReadString('DI','Ex4','SP');
      sEx5     := Mais1Ini.ReadString('DI','Ex5','2011-10-03');
      sEx6     := Mais1Ini.ReadString('DI','Ex6','0001');
      sEx7     := Mais1Ini.ReadString('DI','Ex7','1');
      //
      Form29.Label_01.Visible := True;
      Form29.Label_02.Visible := True;
      Form29.Label_03.Visible := True;
      Form29.Label_04.Visible := True;
      Form29.Label_05.Visible := True;
      Form29.Label_06.Visible := True;
      Form29.Label_07.Visible := True;
      Form29.Label_08.Visible := True;
      Form29.Label_09.Visible := True;
      Form29.Label_10.Visible := True;
      //
      Form29.Edit_01.Visible := True;
      Form29.Edit_02.Visible := True;
      Form29.Edit_03.Visible := True;
      Form29.Edit_04.Visible := True;
      Form29.Edit_05.Visible := True;
      Form29.Edit_06.Visible := True;
      Form29.Edit_07.Visible := True;
      Form29.Edit_08.Visible := True;
      Form29.Edit_09.Visible := True;
      Form29.Edit_10.Visible := True;
      //
      Form29.Label_01.Caption := 'País de origem:';
      Form29.Label_02.Caption := 'Código do País de origem:';
      Form29.Label_03.Caption := 'Número do Documento de Importação (DI/DSI/DA):';
      Form29.Label_04.Caption := 'Data de Registro da DI/DSI/DA no formato AAAA-MM-DD:';
      Form29.Label_05.Caption := 'Local de desembaraço:';
      Form29.Label_06.Caption := 'Sigla da UF onde ocorreu o Desembaraço Aduaneiro:';
      Form29.Label_07.Caption := 'Data do Desembaraço Aduaneiro Formato AAAA-MM-DD:';
      Form29.Label_08.Caption := 'Código do exportador:';
      Form29.Label_09.Caption := 'Número da adição:';
      Form29.Label_10.Caption := 'Identificação do destinatário no caso de comprador estrangeiro:';
      //
      Form29.Edit_01.Text := sPais;
      Form29.Edit_02.Text := sCodPais;
      Form29.Edit_03.Text := sEx1;
      Form29.Edit_04.Text := sEx2;
      Form29.Edit_05.Text := sEx3;
      Form29.Edit_06.Text := sEx4;
      Form29.Edit_07.Text := sEx5;
      Form29.Edit_08.Text := sEx6;
      Form29.Edit_09.Text := sEx7;
      Form29.Edit_10.Text := sEx15;
      //
      Form1.Small_InputForm_Dados('Importação');
      //
      sPais     := Form29.Edit_01.Text;
      sCodPais  := Form29.Edit_02.Text;
      sEx1      := Form29.Edit_03.Text;
      sEx2      := Form29.Edit_04.Text;
      sEx3      := Form29.Edit_05.Text;
      sEx4      := Form29.Edit_06.Text;
      sEx5      := Form29.Edit_07.Text;
      sEx6      := Form29.Edit_08.Text;
      sEx7      := Form29.Edit_09.Text;
      sEx15     := Form29.Edit_10.Text;
      //
{
      sPais    := Form1.Small_InputForm('NFe', 'País destino', 'Estados Unidos');
      sCodPais := Form1.Small_InputForm('NFe', 'Código do País destino', '2496');
      sEx1     := Form1.Small_InputForm('NF-e importação', 'Número do Documento de Importação (DI/DSI/DA):',sEx1);
      sEx2     := Form1.Small_InputForm('NF-e importação', 'Data de Registro da DI/DSI/DA no formato AAAA-MM-DD:',sEx2);
      sEx3     := Form1.Small_InputForm('NF-e importação', 'Local de desembaraço:',sEx3);
      sEx4     := Form1.Small_InputForm('NF-e importação', 'Sigla da UF onde ocorreu o Desembaraço Aduaneiro:',sEx4);
      sEx5     := Form1.Small_InputForm('NF-e importação', 'Data do Desembaraço Aduaneiro Formato AAAA-MM-DD:',sEx5);
      sEx6     := Form1.Small_InputForm('NF-e importação', 'Código do exportador:',sEx6);
      sEx7     := Form1.Small_InputForm('NF-e importação', 'Número da adição:',sEx7);
      sEx15    := Form1.Small_InputForm('NF-e importação', 'Identificação do destinatário no caso de comprador estrangeiro:',sEx15);
}

      //
      // http://www.tecno-services.com/, acesse o painel administrador
      // suporte@smallsoft.com.br
      // genesis
      //
      Mais1Ini.WriteString('DI','Ex1',sEx1);
      Mais1Ini.WriteString('DI','Ex2',sEx2);
      Mais1Ini.WriteString('DI','Ex3',sEx3);
      Mais1Ini.WriteString('DI','Ex4',sEx4);
      Mais1Ini.WriteString('DI','Ex5',sEx5);
      Mais1Ini.WriteString('DI','Ex6',sEx6);
      Mais1Ini.WriteString('DI','Ex7',sEx7);
      Mais1Ini.WriteString('DI','Ex15',sEx15);
      //
      Mais1ini.Free;
      //
      Form7.spdNFeDataSets.Campo('xLgr_E06').Value    := ConverteAcentos2(ExtraiEnderecoSemONumero(Form7.ibDAtaset2.FieldByname('ENDERE').AsString)); // Logradouro do  // Sandro Silva 2023-10-16 Form7.spdNFeDataSets.Campo('xLgr_E06').Value    := ConverteAcentos2(Endereco_Sem_Numero(Form7.ibDAtaset2.FieldByname('ENDERE').AsString)); // Logradouro do Emitente
      Form7.spdNFeDataSets.Campo('nro_E07').Value     := ExtraiNumeroSemOEndereco(Form7.ibDAtaset2.FieldByname('ENDERE').AsString); // Numero do Logradouro do Emitente // Sandro Silva 2023-10-16 Form7.spdNFeDataSets.Campo('nro_E07').Value     := Numero_Sem_Endereco(Form7.ibDAtaset2.FieldByname('ENDERE').AsString); // Numero do Logradouro do Emitente
      //
      Form7.spdNFeDataSets.Campo('xBairro_E09').Value := ConverteAcentos2(Form7.ibDAtaset2.FieldByname('COMPLE').AsString); // Bairro do Destinatario
      Form7.spdNFeDataSets.Campo('cMun_E10').Value    := '9999999'; // Código do Município do Destinatário (Tabela IBGE)
      Form7.spdNFeDataSets.Campo('xMun_E11').Value    := 'EXTERIOR'; //Nome da Cidade do Destinatário
      Form7.spdNFeDataSets.Campo('UF_E12').Value      := 'EX'; // Sigla do Estado do Destinatário
      //
      Form7.spdNFeDataSets.Campo('CEP_E13').Value         := '00000000';  // Cep do Destinatário
      Form7.spdNFeDataSets.Campo('fone_E16').Value        := '';         // Fone do Destinatário
      Form7.spdNFeDataSets.Campo('cPais_E14').Value       := sCodPais;  // Código do Pais do Destinatário (Tabela do BACEN)
      Form7.spdNFeDataSets.Campo('xPais_E15').Value       := sPais;    // Nome do País do Destinatário
      Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value  := '9';     // Não Contribuinte
      //
      try
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
          Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+ 'Identificação do destinatário no caso de comprador estrangeiro'
          ),'Atenção',mb_Ok + MB_ICONWARNING);
          Mauricio Parizotto 2023-10-25}
          MensagemSistema(E.Message+chr(10)+chr(10)+ 'Identificação do destinatário no caso de comprador estrangeiro',msgAtencao);
        end;
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

  I := 0;

  vPIS           := 0;
  vCOFINS        := 0;

  dqBCMonoRet_N43aTotal  := 0.00; // Sandro Silva 2023-09-04
  dvICMSMonoRet_N45Total := 0.00; // Sandro Silva 2023-09-04


  Form7.ibDAtaset23.First;
  while not Form7.ibDAtaset23.Eof do
  begin
    Form7.ibDataSet4.Close;
    Form7.ibDataSet4.Selectsql.Clear;
    Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDAtaset23CODIGO.AsString)+' ');  //
    Form7.ibDataSet4.Open;
    //
    if (Alltrim(Form7.ibDataSet4DESCRICAO.AsString) = Alltrim(Form7.ibDAtaset23DESCRICAO.AsString)) and (Alltrim(Form7.ibDataSet4DESCRICAO.AsString) <> '') then
    begin
      I := I + 1;
//                  if (Form7.ibDataSet14SOBREOUTRAS.AsString = 'S') then
      begin
        fOutras[I]   := Arredonda((Form7.ibDAtaset24.FieldByname('DESPESAS').AsFloat / Form7.ibDAtaset24.FieldByname('MERCADORIA').AsFloat * Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat),2);
      end;

      fFrete[I]    := Arredonda((Form7.ibDAtaset24.FieldByname('FRETE').AsFloat / Form7.ibDAtaset24.FieldByname('MERCADORIA').AsFloat * Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat),2);
      fSeguro[I]   := Arredonda((Form7.ibDAtaset24.FieldByname('SEGURO').AsFloat / Form7.ibDAtaset24.FieldByname('MERCADORIA').AsFloat * Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat),2);
      fDesconto[I] := Arredonda((Form7.ibDAtaset24.FieldByname('DESCONTO').AsFloat / Form7.ibDAtaset24.FieldByname('MERCADORIA').AsFloat * Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat),2);

      vFRETE       := vFRETE + fFrete[I];
      vSEGURO      := vSEGURO + fSeguro[I];
      vOUTRAS      := vOUTRAS + fOutras[I];
      vDESCONTO    := vDESCONTO + fDesconto[I];
    end;

    Form7.ibDAtaset23.Next;
  end;

  vDESCONTO      := (Form7.ibDAtaset24.FieldByname('DESCONTO').AsFloat - vDESCONTO);
  vSEGURO        := (Form7.ibDAtaset24.FieldByname('SEGURO').AsFloat - vSEGURO);
  vFRETE         := (Form7.ibDAtaset24.FieldByname('FRETE').AsFloat - vFRETE);
//              if (Form7.ibDataSet14SOBREOUTRAS.AsString = 'S') then
  begin
    vOUTRAS        := (Form7.ibDAtaset24.FieldByname('DESPESAS').AsFloat - vOUTRAS);
  end;

  for I := 1 to 999 do
  begin
    // DIFERENCA DE CENTAVOS DO DESCONTO
    if vDESCONTO <> 0 then
    begin
      if fDesconto[I] = Math.MAxValue( fDesconto ) then
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

  I := 0;
  vTotalImpostoImportacao := 0;
  sMensagemIcmMonofasicoSobreCombustiveis := ''; // Sandro Silva 2023-06-16

  Form7.ibDAtaset23.First;
  while not Form7.ibDAtaset23.Eof do
  begin
    Form7.ibDataSet4.Close;
    Form7.ibDataSet4.Selectsql.Clear;
    Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDAtaset23CODIGO.AsString)+' ');  //
    Form7.ibDataSet4.Open;

    if (Alltrim(Form7.ibDataSet4DESCRICAO.AsString) = AllTrim(Form7.ibDAtaset23DESCRICAO.AsString)) and (copy(Form7.ibDAtaset23CFOP.AsString,2,3)<>'604') then
    begin
      I := I + 1;

      try
        if Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value = '9' then Form7.spdNFeDataSets.Campo('IE_E17').Value          := ''; // Form7.spdNFeDataSets.Campo('IE_E17').GeraTagVazia := True;
        if Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value = '2' then Form7.spdNFeDataSets.Campo('IE_E17').Value          := '';

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
                          ,msgAtencao);
        end;
      end;

      Form7.spdNFeDataSets.IncluirItem;

      // Informações Referentes aos ITens da NFe
      Form7.spdNFeDataSets.Campo('nItem_H02').Value := IntToStr(I); // Número do Item da NFe (1 até 990)
      //
      // Dados do Produto Comprado
      //
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

      Form7.spdNFeDataSets.Campo('cEAN_I03').Value := 'SEM GTIN'; // EAN do Produto
      if Form7._ecf65_ValidaGtinNFCe(Form7.ibDataSet4.FieldByname('REFERENCIA').AsString) then
        Form7.spdNFeDataSets.Campo('cEAN_I03').Value := LimpaNumero(Form7.ibDataSet4.FieldByname('REFERENCIA').AsString); // EAN do Produto

      Form7.spdNFeDataSets.Campo('xProd_I04').Value    := ConverteAcentos2(Form7.ibDataSet4.FieldByname('DESCRICAO').AsString);// Descrição do PRoduto

      // NCM
      if Length(Alltrim(LimpaNumero(Form7.ibDataSet4.FieldByname('CF').AsString))) = 8 then
      begin
        Form7.spdNFeDataSets.Campo('NCM_I05').Value      := Alltrim(LimpaNumero(Form7.ibDataSet4.FieldByname('CF').AsString)); // Código do NCM - informar de acordo com o Tabela oficial do NCM
      end else
      begin
        // Serviço
        Form7.spdNFeDataSets.Campo('NCM_I05').Value      := '00'; // Código do NCM - informar de acordo com o Tabela oficial do NCM
      end;

      Form7.spdNFeDataSets.Campo('CFOP_I08').Value     := Alltrim(Form7.ibDAtaset23.FieldByname('CFOP').AsString); // CFOP incidente neste Item da NF
      if Alltrim(ConverteAcentos2(Form7.ibDataSet4.FieldByname('MEDIDA').AsString)) <> '' then Form7.spdNFeDataSets.Campo('uCom_I09').Value     := ConverteAcentos2(Form7.ibDataSet4.FieldByname('MEDIDA').AsString) // Unidade de Medida do Item
        else Form7.spdNFeDataSets.Campo('uCom_I09').Value     := 'UND';
      Form7.spdNFeDataSets.Campo('qCom_I10').Value     := StrTran(Form7.ibDAtaset23.FieldByname('QUANTIDADE').AsString,',','.'); // Quantidade Comercializada do Item
//                  Form7.spdNFeDataSets.Campo('qCom_I10').Value     := StrTran(Alltrim(FormatFloat('##0.0000',Form7.ibDAtaset23.FieldByname('QUANTIDADE').AsFloat)),',','.'); // Quantidade Comercializada do Item
      Form7.spdNFeDataSets.Campo('vUnCom_I10a').Value  := StrTran(Alltrim(FormatFloat('##0.'+Replicate('0',StrToInt(Form1.ConfPreco)),Form7.ibDAtaset23.FieldByname('UNITARIO').AsFloat)),',','.'); // Valor Comercializado do Item
      Form7.spdNFeDataSets.Campo('vProd_I11').Value    := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat)),',','.'); // Valor Total Bruto do Item

      if Form7.ibDataSet4CEST.AsString <> '' then
      begin
        Form7.spdNFeDataSets.Campo('CEST_I05c').Value    := Form7.ibDataSet4CEST.AsString; // Código CEST
      end;

      // Campo obrigatório
      if Form7.ibDAtaset24.FieldByname('FRETE').AsFloat    <> 0 then if (fFrete[I])    > 0.01 then Form7.spdNFeDataSets.Campo('vFrete_I15').Value  := StrTran(Alltrim(FormatFloat('##0.00',(fFrete[I]))),',','.');    // REGRA DE TRÊS ratiando o valor do frete Valor Total do Frete
      if Form7.ibDAtaset24.FieldByname('SEGURO').AsFloat   <> 0 then if (fSeguro[I])   > 0.01 then Form7.spdNFeDataSets.Campo('vSeg_I16').Value    := StrTran(Alltrim(FormatFloat('##0.00',(fSeguro[I]))),',','.');   // REGRA DE TRÊS ratiando o valor do frete Valor Total do Seguro

//                  if (Form7.ibDataSet14SOBREOUTRAS.AsString = 'S') then
      begin
        if Form7.ibDAtaset24.FieldByname('DESPESAS').AsFloat <> 0 then if (fOutras[I])   > 0.01 then Form7.spdNFeDataSets.Campo('vOutro_I17a').Value := StrTran(Alltrim(FormatFloat('##0.00',(fOutras[I]))),',','.');   // REGRA DE TRÊS ratiando o valor do frete Valor Total do DESPESAS
      end;

      if Form7.ibDAtaset24.FieldByname('DESCONTO').AsFloat <> 0 then if (fDesconto[I]) > 0.01 then Form7.spdNFeDataSets.Campo('vDesc_I17').Value   := StrTran(Alltrim(FormatFloat('##0.00',(fDesconto[I]))),',','.'); // REGRA DE TRÊS ratiando o valor do frete Valor Total do Desconto

      if Alltrim(Form7.spdNFeDataSets.Campo('NCM_I05').Value) = '' then
      begin
        Form7.ibDataSet15.Edit;
        Form7.ibDataSet15STATUS.AsString    := 'Erro: Informe o NCM do produto '+ConverteAcentos2(Form7.ibDataSet4.FieldByname('DESCRICAO').AsString);
        Abort;
      end;

      if (RetornaValorDaTagNoCampo('cBenef',Form7.ibDataSet4.FieldByname('TAGS_').AsString)<>'') and (RetornaValorDaTagNoCampo('cBenef',Form7.ibDataSet4.FieldByname('TAGS_').AsString)<>'0000000000') then
      begin
        Form7.spdNFeDataSets.Campo('cBenef_I05f').Value     := RetornaValorDaTagNoCampo('cBenef',Form7.ibDataSet4.FieldByname('TAGS_').AsString);      // Código de Benefício Fiscal na UF aplicado ao item
      end;

      if (Pos(Alltrim(Form7.ibDAtaset23.FieldByname('CFOP').AsString),Form1.CFOP5124) = 0) then // 5104 Industrialização efetuada para outra empresa não soma na base
      begin
        Form7.spdNFeDataSets.Campo('indTot_I17b').Value   := '1'; // 0 - O valor do Item NÃO compõe o valor total da nota 1 - O valor do Item compõe o valor total da nota
      end else
      begin
        Form7.spdNFeDataSets.Campo('indTot_I17b').Value   := '0'; // 0 - O valor do Item NÃO compõe o valor total da nota 1 - O valor do Item compõe o valor total da nota
      end;

      Form7.spdNFeDataSets.Campo('cEANTrib_I12').Value := 'SEM GTIN'; // EAN do Produto

      if (RetornaValorDaTagNoCampo('cEANTrib', Form7.ibDataSet4.FieldByname('TAGS_').AsString) <> '') and (Form7._ecf65_ValidaGtinNFCe(RetornaValorDaTagNoCampo('cEANTrib', Form7.ibDataSet4.FieldByname('TAGS_').AsString))) then
        Form7.spdNFeDataSets.Campo('cEANTrib_I12').Value := RetornaValorDaTagNoCampo('cEANTrib', Form7.ibDataSet4.FieldByname('TAGS_').AsString)
      else
        if Form7._ecf65_ValidaGtinNFCe(Form7.ibDataSet4.FieldByname('REFERENCIA').AsString) then
          Form7.spdNFeDataSets.Campo('cEANTrib_I12').Value := LimpaNumero(Form7.ibDataSet4.FieldByname('REFERENCIA').AsString); // EAN do Produto

      // Quantidade tributável
      if RetornaValorDaTagNoCampo('uTrib',Form7.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then
      begin
        Form7.spdNFeDataSets.Campo('uTrib_I13').Value    := RetornaValorDaTagNoCampo('uTrib',Form7.ibDataSet4.FieldByname('TAGS_').AsString);

        if LimpaNumero(RetornaValorDaTagNoCampo('qTrib',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
        begin
          Form7.spdNFeDataSets.Campo('qTrib_I14').Value    := FormatFloatXML(Form7.ibDAtaset23.FieldByname('QUANTIDADE').AsFloat * StrToFloat( RetornaValorDaTagNoCampo('qTrib',Form7.ibDataSet4.FieldByname('TAGS_').AsString)  ));  // Quantidade Tributável do Item
          Form7.spdNFeDataSets.Campo('vUnTrib_I14a').Value := StrTran(Alltrim(FormatFloat('##0.'+Replicate('0',StrToInt(Form1.ConfPreco)),Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat / StrToFloat(StrTran(Form7.spdNFeDataSets.Campo('qTrib_I14').AsString,'.',',')))),',','.'); // Valor Tributável do Item
        end else
        begin
          Form7.spdNFeDataSets.Campo('qTrib_I14').Value    := StrTran(Form7.ibDAtaset23.FieldByname('QUANTIDADE').AsString,',','.');  // Quantidade Tributável do Item
          Form7.spdNFeDataSets.Campo('vUnTrib_I14a').Value := StrTran(Alltrim(FormatFloat('##0.'+Replicate('0',StrToInt(Form1.ConfPreco)),Form7.ibDAtaset23.FieldByname('UNITARIO').AsFloat)),',','.'); // Valor Tributável do Item
        end;
      end else
      begin
        if Alltrim(ConverteAcentos2(Form7.ibDataSet4.FieldByname('MEDIDA').AsString)) <> '' then Form7.spdNFeDataSets.Campo('uTrib_I13').Value    := ConverteAcentos2(Form7.ibDataSet4.FieldByname('MEDIDA').AsString) else Form7.spdNFeDataSets.Campo('uTrib_I13').Value    := 'UND'; // Unidade de Medida Tributável do Item
        Form7.spdNFeDataSets.Campo('qTrib_I14').Value    := StrTran(Form7.ibDAtaset23.FieldByname('QUANTIDADE').AsString,',','.');  // Quantidade Tributável do Item
        Form7.spdNFeDataSets.Campo('vUnTrib_I14a').Value := StrTran(Alltrim(FormatFloat('##0.'+Replicate('0',StrToInt(Form1.ConfPreco)),Form7.ibDAtaset23.FieldByname('UNITARIO').AsFloat)),',','.'); // Valor Tributável do Item
      end;

      // Combustíveis
      sCodigoANP := '';// Iniciar varíavel vazia      
      try
        if (copy(Form7.ibDAtaset23CFOP.AsString,2,2)='65') or (copy(Form7.ibDAtaset23CFOP.AsString,2,2)='66') then
        begin
          if RetornaValorDaTagNoCampo('cProdANP',Form7.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then
          begin
            sCodigoANP := RetornaValorDaTagNoCampo('cProdANP',Form7.ibDataSet4.FieldByname('TAGS_').AsString);
          end;

          while Length(sCodigoANP) <> 9 do
          begin
            sCodigoANP := LimpaNumero(Form1.Small_InputForm('Informe o Código ANP:',chr(10)+'Esta informação pode ser digitada'+chr(10)+'no controle de estoque na'+chr(10)+'aba Tags: cProdANP: 000000000', ''));
          end;

          if Length(sCodigoANP) = 9 then
          begin
            if RetornaValorDaTagNoCampo('cProdANP',Form7.ibDataSet4.FieldByname('TAGS_').AsString) = '' then
            begin
              if not (Form7.ibDataSet4.State in ([dsEdit, dsInsert])) then Form7.ibDataSet4.Edit;
              Form7.ibDataSet4TAGS_.AsString := Form7.ibDataSet4TAGS_.AsString + chr(10) + '<cProdANP>'+sCodigoANP + '</cProdANP>';
              Form7.ibDataSet4.Post;
              Form7.ibDataSet4.Edit;
            end;

            Form7.spdNFeDataSets.incluirPart('L1');
            Form7.spdNFeDataSets.Campo('cProdANP_LA02').value := sCodigoANP; // Código de produto da ANP
            Form7.spdNFeDataSets.Campo('UFCons_LA06').value   := IBQUERY99.FieldByname('UF').AsString; // Sigla do Estado do Destinatário

            if Form1.sVersaoLayout = '4.00' then
            begin
              if (RetornaValorDaTagNoCampo('descANP', Form7.ibDataSet4.FieldByname('TAGS_').AsString) = '') then
              begin
                //ShowMessage('Incluir no controle de estoque na aba Tags: descANP: Descrição do produto conforme ANP'); Mauricio Parizotto 2023-10-25}
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

              if RetornaValorDaTagNoCampo('vPart', Form7.ibDataSet4.FieldByname('TAGS_').AsString) <> '' then Form7.spdNFeDataSets.Campo('vPart_LA03d').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('vPart', Form7.ibDataSet4.FieldByname('TAGS_').AsString), 0)); // Valor de partida (cProdANP=210203001)
            end;

            Form7.spdNFeDataSets.SalvarPart('L1');
          end;
        end;
      except
      end;

          
      // TAGS - ENTRADA
      GeraXmlNFeEntradaTags;


      // IPI
      if AllTrim(Form7.ibDAtaset23.FieldByname('CST_IPI').AsString) <> '' then
      begin
        // CST IPI
        //
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
        //
        if Form1.sVersaoLayout = '4.00' then
        begin
        end else
        begin
          Form7.spdNFeDataSets.Campo('clEnq_O02').Value     := 'NDA'; // Classe de enquadramento do IPI para cigarros e Bebidas
        end;

        Form7.spdNFeDataSets.Campo('CNPJProd_O03').Value  := '00000000000000'; // CNPJ do produtor quando diferente do emitente
        Form7.spdNFeDataSets.Campo('cSelo_O04').Value     := '';   // Código do celo de controle IPI
        Form7.spdNFeDataSets.Campo('qSelo_O05').Value     := '0';   // Quantidade de celo de controle
        Form7.spdNFeDataSets.Campo('cEnq_O06').Value      := '999'; // Tabela RFB - Ainda não foi criada
        Form7.spdNFeDataSets.Campo('CST_O09').Value       := Form7.ibDAtaset23.FieldByname('CST_IPI').AsString;
        Form7.spdNFeDataSets.Campo('vBC_O10').Value       := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat)),',','.'); // Valor da BC do IPI
        Form7.spdNFeDataSets.Campo('pIPI_O13').Value      := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('IPI').AsFloat)),',','.'); // Percentual do IPI
        Form7.spdNFeDataSets.Campo('vIPI_O14').Value      := StrTran(Alltrim(FormatFloat('##0.00',Arredonda2(Form7.ibDAtaset23.FieldByname('IPI').AsFloat*Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat/100,2))),',','.'); // Valor do IPI
      end;

      // PIS / COFINS
      if AllTrim(sCST_PIS_COFINS) <> '' then
      begin
        // Pega o CST PIS COFINS e o PERCENTUAL da Tabela
        Form7.spdNFeDataSets.Campo('CST_Q06').Value     := sCST_PIS_COFINS;

        if rpPIS <> 0 then
        begin
          Form7.spdNFeDataSets.Campo('vBC_Q07').Value     := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat)),',','.'); // Valor da Base de Cálculo do PIS
          Form7.spdNFeDataSets.Campo('pPIS_Q08').Value    := StrTran(Alltrim(FormatFloat('##0.00',rpPIS)),',','.'); // Alíquota em Percencual do PIS
          Form7.spdNFeDataSets.Campo('vPIS_Q09').Value    := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat*rpPIS/100)),',','.'); // Valor do PIS em Reais
          vPIS := vPIS + arredonda(Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat*rpPIS/100,2);
        end else
        begin
          Form7.spdNFeDataSets.Campo('vBC_Q07').Value     := '0.00'; // Valor da Base de Cálculo do PIS
          Form7.spdNFeDataSets.Campo('pPIS_Q08').Value    := '0.00'; // Alíquota em Percencual do PIS
          Form7.spdNFeDataSets.Campo('vPIS_Q09').Value    := '0.00'; // Valor do PIS em Reais
        end;
      end else
      begin
        if (Form7.ibDataSet4ALIQ_PIS_ENTRADA.AsFloat <> 0) then
        begin
          // Pega o CST PIS COFINS e o PERCENTUAL do iten
          Form7.spdNFeDataSets.Campo('CST_Q06').Value     := Form7.ibDataSet4CST_PIS_COFINS_ENTRADA.AsString;
          Form7.spdNFeDataSets.Campo('vBC_Q07').Value     := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat)),',','.'); // Valor da Base de Cálculo do PIS
          Form7.spdNFeDataSets.Campo('pPIS_Q08').Value    := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet4ALIQ_PIS_ENTRADA.AsFloat)),',','.'); // Alíquota em Percencual do PIS
          Form7.spdNFeDataSets.Campo('vPIS_Q09').Value    := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat*Form7.ibDataSet4ALIQ_PIS_ENTRADA.AsFloat/100)),',','.'); // Valor do PIS em Reais
          vPIS := vPIS + arredonda(Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat*Form7.ibDataSet4ALIQ_PIS_ENTRADA.AsFloat/100,2);
          // vPIS := vPIS + Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat*Form7.ibDataSet4ALIQ_PIS_ENTRADA.AsFloat/100;
        end else
        begin
          if AllTrim(Form7.ibDataSet4CST_PIS_COFINS_ENTRADA.AsString) = '' then
          begin
            Form7.spdNFeDataSets.Campo('CST_Q06').Value     := '08';   // Codigo de Situacao Tributária - ver opções no Manual
          end else
          begin
            Form7.spdNFeDataSets.Campo('CST_Q06').Value     := Form7.ibDataSet4CST_PIS_COFINS_ENTRADA.AsString;
          end;

          Form7.spdNFeDataSets.Campo('vBC_Q07').Value     := '0.00'; // Valor da Base de Cálculo do PIS
          Form7.spdNFeDataSets.Campo('pPIS_Q08').Value    := '0.00'; // Alíquota em Percencual do PIS
          Form7.spdNFeDataSets.Campo('vPIS_Q09').Value    := '0.00'; // Valor do PIS em Reais
        end;
      end;

      // COFINS
      if AllTrim(sCST_PIS_COFINS) <> '' then
      begin
        Form7.spdNFeDataSets.Campo('CST_S06').Value        := sCST_PIS_COFINS;

        if rpCOFINS <> 0 then
        begin
          Form7.spdNFeDataSets.Campo('vBC_S07').Value        := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat)),',','.'); // Valor da Base de Cálculo do COFINS
          Form7.spdNFeDataSets.Campo('pCOFINS_S08').Value    := StrTran(Alltrim(FormatFloat('##0.00',rpCOFINS)),',','.'); // Alíquota em Percencual do COFINS
          Form7.spdNFeDataSets.Campo('vCOFINS_S11').Value    := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat*rpCOFINS/100)),',','.'); // Valor do COFINS em Reais

          vCOFINS := vCOFINS + arredonda(Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat*rpCOFINS/100,2);
        end else
        begin
          Form7.spdNFeDataSets.Campo('vBC_S07').Value        := '0.00'; // Valor da Base de Cálculo do COFINS
          Form7.spdNFeDataSets.Campo('pCOFINS_S08').Value    := '0.00'; // Alíquota em Percencual do COFINS
          Form7.spdNFeDataSets.Campo('vCOFINS_S11').Value    := '0.00'; // Valor do COFINS em Reais
        end;
      end else
      begin
        if (Form7.ibDataSet4ALIQ_COFINS_ENTRADA.AsFloat <> 0) then
        begin
          // Pega o CST PIS COFINS e o PERCENTUAL do iten
          Form7.spdNFeDataSets.Campo('CST_S06').Value        := Form7.ibDataSet4CST_PIS_COFINS_ENTRADA.AsString;
          Form7.spdNFeDataSets.Campo('vBC_S07').Value        := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat)),',','.'); // Valor da Base de Cálculo do COFINS
          Form7.spdNFeDataSets.Campo('pCOFINS_S08').Value    := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet4ALIQ_COFINS_ENTRADA.AsFloat)),',','.'); // Alíquota em Percencual do COFINS
          Form7.spdNFeDataSets.Campo('vCOFINS_S11').Value    := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat*Form7.ibDataSet4ALIQ_COFINS_ENTRADA.AsFloat/100)),',','.'); // Valor do COFINS em Reais

          vCOFINS := vCOFINS + arredonda(Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat*Form7.ibDataSet4ALIQ_COFINS_ENTRADA.AsFloat/100,2);
          // vCOFINS := vCOFINS + Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat*Form7.ibDataSet4ALIQ_COFINS_ENTRADA.AsFloat/100;
        end else
        begin
          if AllTrim(Form7.ibDataSet4CST_PIS_COFINS_ENTRADA.AsString) = '' then
          begin
            Form7.spdNFeDataSets.Campo('CST_S06').Value     := '08';   // Codigo de Situacao Tributária - ver opções no Manual
          end else
          begin
            Form7.spdNFeDataSets.Campo('CST_S06').Value     := Form7.ibDataSet4CST_PIS_COFINS_ENTRADA.AsString;
          end;

          Form7.spdNFeDataSets.Campo('vBC_S07').Value        := '0.00'; // Valor da Base de Cálculo do COFINS
          Form7.spdNFeDataSets.Campo('pCOFINS_S08').Value    := '0.00'; // Alíquota em Percencual do COFINS
          Form7.spdNFeDataSets.Campo('vCOFINS_S11').Value    := '0.00'; // Valor do COFINS em Reais
        end;
      end;

      // THE END PIS/COFINS
      // Importação
      if sEx3 <> '' then
      begin
        // Controle de importação por Item
        Mais1ini := TIniFile.Create(Form1.sAtual+'\importac.ini');
        //
        sEx8   := Mais1Ini.ReadString('DI','Ex8','0');
        sEx9   := Mais1Ini.ReadString('DI','Ex9','0');
        sEx10  := Mais1Ini.ReadString('DI','Ex10','0');
        sEx11  := Mais1Ini.ReadString('DI','Ex11','0');
        sEx12  := Mais1Ini.ReadString('DI','Ex12','0');
        sEx13  := Mais1Ini.ReadString('DI','Ex13','0');
        sEx14  := Mais1Ini.ReadString('DI','Ex14','0');
        sEx18  := Mais1Ini.ReadString('DI','Ex18','0');
        //
        Form29.Label_01.Visible := True;
        Form29.Label_02.Visible := True;
        Form29.Label_03.Visible := True;
        Form29.Label_04.Visible := True;
        Form29.Label_05.Visible := True;
        Form29.Label_06.Visible := True;
        Form29.Label_07.Visible := True;
        Form29.Label_08.Visible := True;
        //
        Form29.Edit_01.Visible := True;
        Form29.Edit_02.Visible := True;
        Form29.Edit_03.Visible := True;
        Form29.Edit_04.Visible := True;
        Form29.Edit_05.Visible := True;
        Form29.Edit_06.Visible := True;
        Form29.Edit_07.Visible := True;
        Form29.Edit_08.Visible := True;
        //
        Form29.Label_01.Caption := 'Base de Calculo (BC):';
        Form29.Label_02.Caption := 'Despesas aduaneiras:';
        Form29.Label_03.Caption := 'Valor do Imposto de Importação (II):';
        Form29.Label_04.Caption := 'Valor do Imposto sobre Operações Financeiras (IOF):';
        Form29.Label_05.Caption := 'Valor da Base de Calculo do IPI:';
        Form29.Label_06.Caption := 'Valor de AFRMM (Adicional ao Frete para Renovação da Marinha Mercante):';
        Form29.Label_07.Caption := 'Número do ato concessório de Drawback:';
        Form29.Label_08.Caption := 'Via de transporte internacional informada (DI):'+chr(10)+chr(10)+
                                   '1=Marítima;'+chr(10)+
                                   '2=Fluvial;'+chr(10)+
                                   '3=Lacustre;'+chr(10)+
                                   '4=Aérea;'+chr(10)+
                                   '5=Postal;'+chr(10)+
                                   '6=Ferroviária;'+chr(10)+
                                   '7=Rodoviária;'+chr(10)+
                                   '8=Conduto / Rede Transmissão;'+chr(10)+
                                   '9=Meios Próprios;'+chr(10)+
                                   '10=Entrada / Saída ficta; 11=Courier; 12=Handcarry.';

        Form29.Edit_01.Text := sEx8;
        Form29.Edit_02.Text := sEx9;
        Form29.Edit_03.Text := sEx10;
        Form29.Edit_04.Text := sEx11;
        Form29.Edit_05.Text := sEx18;
        Form29.Edit_06.Text := sEx13;
        Form29.Edit_07.Text := sEx14;
        Form29.Edit_08.Text := sEx12;

        Form1.Small_InputForm_Dados('Importação do Item: '+Form7.ibDataSet4.FieldByname('DESCRICAO').AsString);

        sEx8   := Form29.Edit_01.Text;
        sEx9   := Form29.Edit_02.Text;
        sEx10  := Form29.Edit_03.Text;
        sEx11  := Form29.Edit_04.Text;
        sEx18  := Form29.Edit_05.Text;
        sEx13  := Form29.Edit_06.Text;
        sEx14  := Form29.Edit_07.Text;
        sEx12  := Form29.Edit_08.Text;

        try
          Form7.spdNFeDataSets.IncluirPart('DI');

          Form7.spdNFeDataSets.Campo('nDI_I19').Value            := sEx1; // Número do Documento de Importação (DI/DSI/DA)
          Form7.spdNFeDataSets.Campo('dDI_I20').Value            := sEx2; // Data de Registro da DI/DSI/DA no formato “AAAA-MM-DD”
          Form7.spdNFeDataSets.Campo('xLocDesemb_I21').Value     := sEx3; // Local de desembaraço
          Form7.spdNFeDataSets.Campo('UFDesemb_I22').Value       := sEx4; // Sigla da UF onde ocorreu o Desembaraço Aduaneiro
          Form7.spdNFeDataSets.Campo('dDesemb_I23').Value        := sEx5; // Data do Desembaraço Aduaneiro Formato “AAAA-MM-DD”
          Form7.spdNFeDataSets.Campo('cExportador_I24').Value    := sEx6; // Código do exportador
          Form7.spdNFeDataSets.Campo('tpIntermedio_I23c').Value  := '1';  // Forma de importação quanto a E I18 N 1-1 1 1=Importação por conta própria
          Form7.spdNFeDataSets.Campo('tpViaTransp_I23a').Value   := LimpaNumero(sEx12); // Via de transporte internacional informada na Declaração de Importação (DI)

          if sEx12 = '1' then
          begin
            Form7.spdNFeDataSets.Campo('vAFRMM_I23b').Value  := sEx13;      // Valor de AFRMM (Adicional ao Frete para Renovação da Marinha Mercante)
          end;

          Form7.spdNFeDataSets.SalvarPart('DI');
        except
          on E: Exception do
          begin
            {
            Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+ 'ao salvar DI'
            ),'Atenção',mb_Ok + MB_ICONWARNING);
            Mauricio Parizotto 2023-10-25}
            MensagemSistema(E.Message+chr(10)+chr(10)+ 'ao salvar DI',msgAtencao);
          end;
        end;

        try
          Form7.spdNFeDataSets.IncluirPart('adi');
          Form7.spdNFeDataSets.Campo('nAdicao_I26').Value        := sEx7;         // Numero da adição
          Form7.spdNFeDataSets.Campo('nSeqAdic_I27').Value       := IntToStr(I);  // Código sequencial
          Form7.spdNFeDataSets.Campo('cFabricante_I28').Value    := '1';
          Form7.spdNFeDataSets.Campo('nDraw_I29a').Value  := sEx14;      // Número do ato concessório de Drawback

          Form7.spdNFeDataSets.SalvarPart('adi');
        except
          on E: Exception do
          begin
            {
            Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+ 'ao salvar adi'
            ),'Atenção',mb_Ok + MB_ICONWARNING);
            Mauricio Parizotto 2023-10-25}
            MensagemSistema(E.Message+chr(10)+chr(10)+ 'ao salvar adi',msgAtencao);
          end;
        end;

        Mais1Ini.WriteString('DI','Ex8' ,sEx8);
        Mais1Ini.WriteString('DI','Ex9' ,sEx9);
        Mais1Ini.WriteString('DI','Ex10',sEx10);
        Mais1Ini.WriteString('DI','Ex11',sEx11);
        Mais1Ini.WriteString('DI','Ex12',sEx12);
        Mais1Ini.WriteString('DI','Ex13',sEx13);
        Mais1Ini.WriteString('DI','Ex14',sEx14);
        Mais1Ini.WriteString('DI','Ex15',sEx15);
        Mais1Ini.WriteString('DI','Ex18',sEx18);

        Mais1ini.Free;

        try
          Form7.spdNFeDataSets.SalvarPart('DI');
        except
          on E: Exception do
          begin
            {
            Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+ 'ao salvar DI'
            ),'Atenção',mb_Ok + MB_ICONWARNING);
            Mauricio Parizotto 2023-10-25}
            MensagemSistema(E.Message+chr(10)+chr(10)+ 'ao salvar DI',msgAtencao);
          end;
        end;

        Form7.spdNFeDataSets.Campo('vBC_P02').Value      := sEx8;  // Valor da BC do Imposto de Importação
        Form7.spdNFeDataSets.Campo('vDespAdu_P03').Value := sEx9;  // Valor das despesas aduaneiras
        Form7.spdNFeDataSets.Campo('vII_P04').Value      := sEx10; // Valor do Imposto de Importação
        Form7.spdNFeDataSets.Campo('vIOF_P05').Value     := sEx11; // Valor do Imposto sobre Operações Financeiras

        // Recalcula o IPI somando o valor do Imposto de Importação na BASE do IPI
        Form7.spdNFeDataSets.Campo('vBC_O10').Value       := StrTran(Alltrim(FormatFloat('##0.00',StrToFloat(StrTran(sEx18,'.',',')) )),',','.'); // Valor da BC do IPI
        Form7.spdNFeDataSets.Campo('vIPI_O14').Value      := StrTran(Alltrim(FormatFloat('##0.00',Arredonda2(Form7.ibDAtaset23.FieldByname('IPI').AsFloat* (StrToFloat(StrTran(sEx18,'.',',')) )/100,2))),',','.'); // Valor do IPI

        vTotalImpostoImportacao := vTotalImpostoImportacao + StrToFloat(StrTran(sEx10,'.',','));
      end;
    end else
    begin
      if copy(Form7.ibDAtaset23CFOP.AsString,2,3)='604' then
      begin
        I := I + 1;

        try
          if Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value = '9' then Form7.spdNFeDataSets.Campo('IE_E17').Value          := '';
          if Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value = '2' then Form7.spdNFeDataSets.Campo('IE_E17').Value          := '';

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
                            ,msgAtencao);
          end;
        end;

        Form7.spdNFeDataSets.IncluirItem;

        // Informações Referentes aos ITens da NFe
        Form7.spdNFeDataSets.Campo('nItem_H02').Value := IntToStr(I); // Número do Item da NFe (1 até 990)
        Form7.spdNFeDataSets.Campo('cProd_I02').Value    := 'CFOP'+Form7.ibDAtaset23CFOP.AsString; //Código do PRoduto ou Serviço
        Form7.spdNFeDataSets.Campo('xProd_I04').Value    := 'Ativo permanente - ICMS a ser apropriado';// Descrição do PRoduto
        Form7.spdNFeDataSets.Campo('NCM_I05').Value      := '00000000'; // Código do NCM - informar de acordo com o Tabela oficial do NCM
        Form7.spdNFeDataSets.Campo('CFOP_I08').Value     := Alltrim(Form7.ibDAtaset23.FieldByname('CFOP').AsString); // CFOP incidente neste Item da NF
        Form7.spdNFeDataSets.Campo('uCom_I09').Value     := 'UND';
        Form7.spdNFeDataSets.Campo('qCom_I10').Value     := '0.00'; // Quantidade Comercializada do Item
        Form7.spdNFeDataSets.Campo('vUnCom_I10a').Value  := '0.00'; // Valor Comercializado do Item
        Form7.spdNFeDataSets.Campo('vProd_I11').Value    := '0.00'; // Valor Total Bruto do Item

        // Campo obrigatório
        Form7.spdNFeDataSets.Campo('indTot_I17b').Value   := '0'; // 0 - O valor do Item NÃO compõe o valor total da nota 1 - O valor do Item compõe o valor total da nota
        Form7.spdNFeDataSets.Campo('uTrib_I13').Value     := 'UND'; // Unidade de Medida Tributável do Item

        Form7.spdNFeDataSets.Campo('qTrib_I14').Value    := '1'; // Quantidade Tributável do Item
//                    Form7.spdNFeDataSets.Campo('vUnTrib_I14a').Value := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('VBC').AsFloat)),',','.');  // Valor Tributável do Item
        Form7.spdNFeDataSets.Campo('vUnTrib_I14a').Value := StrTran(Alltrim(FormatFloat('##0.'+Replicate('0',StrToInt(Form1.ConfPreco)),Form7.ibDAtaset23.FieldByname('UNITARIO').AsFloat)),',','.'); // Valor Tributável do Item

        Form7.spdNFeDataSets.Campo('vBC_N15').Value    := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('VBC').AsFloat)),',','.');  // BC
        Form7.spdNFeDataSets.Campo('vICMS_N17').Value  := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('VICMS').AsFloat)),',','.');     // Valor do ICMS em Reais
        Form7.spdNFeDataSets.Campo('modBC_N13').Value  := '3'; // Modalidade de determinação da Base de Cálculo - ver Manual
        Form7.spdNFeDataSets.Campo('pICMS_N16').Value  := '100'; // Alíquota do ICMS em Percentual

        if (LimpaNumero(Form7.ibDataSet13.FieldByname('CRT').AsString) = '1') then
        begin
          Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value := '900';
        end;

        Form7.spdNFeDataSets.Campo('orig_N11').Value   := '0'; //Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
        Form7.spdNFeDataSets.Campo('CST_N12').Value    := '90';  // Tipo da Tributação do ICMS (00 - Integralmente) ver outras formas no Manual

        Form7.spdNFeDataSets.Campo('CST_Q06').Value     := '08';   // Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',1,2); // Codigo de Situacao Tributária - ver opções no Manual
        Form7.spdNFeDataSets.Campo('CST_S06').Value     := '08'; // Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',1,2); // Código de Situacao Tributária - ver opções no Manual
      end else
      begin
        // Comentarios no corpo da nota
        Form7.spdNFeDataSets.Campo('InfAdProd_V01').Value := AllTrim(AllTrim(Form7.spdNFeDataSets.Campo('InfAdProd_V01').Value) + ' ' + ConverteAcentos2(AllTrim(Form7.ibDAtaset23.FieldByname('DESCRICAO').AsString)));
      end;
    end;

    {Sandro Silva 2023-09-14 inicio}
    if NFeFinalidadeDevolucao(Form7.spdNFeDataSets.Campo('finNFe_B25').Value) then // Devolução
    begin
      if XmlValueToFloat(Form7.spdNFeDataSets.Campo('vICMSST_N23').Value) > 0 then   
      begin
        // Criar estes dois campos e armazenar no Form7.ibDataSet23 e recuperar na nota de devolução
        spMVAST  := '0,00';
        spICMSST := '0,00';

        // Só pede se tem Valor de ICMSST
        spMVAST  := Form1.Small_InputForm('NFe', 'Informe o pMVAST (% de margem de valor adicionado do ICMS ST) para o produto: ' + Form7.ibDataSet23.FieldByName('DESCRICAO').AsString, '0,00');
        spICMSST := Form1.Small_InputForm('NFe', 'Informe o pICMSST (% Aliquota do Imposto do ICMS ST) para o produto: ' + Form7.ibDataSet23.FieldByName('DESCRICAO').AsString, '0,00');

        Form7.spdNFeDataSets.Campo('pMVAST_N19').Value    := FormatFloatXML(StrToFloat(LimpaNumeroDeixandoAVirgula(spMVAST)));  // Percentual de margem de valor adicionado do ICMS ST
        Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   := FormatFloatXML(StrToFloat(LimpaNumeroDeixandoAVirgula(spICMSST))); // Alíquota do ICMS em Percentual

      end;
    end;
    {Sandro Silva 2023-09-14 fim}


    {Sandro Silva 2023-11-07 inicio}
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
    {Sandro Silva 2023-11-07 fim}

    Form7.ibDAtaset23.Next;
  end;
                
  try
    if Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value = '9' then Form7.spdNFeDataSets.Campo('IE_E17').Value          := '';
    if Form7.spdNFeDataSets.Campo('indIEDest_E16a').Value = '2' then Form7.spdNFeDataSets.Campo('IE_E17').Value          := '';
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
                      ,msgAtencao);
    end;
  end;

  // Totalizadores da NFe
  Form7.spdNFeDataSets.Campo('vBC_W03').Value     := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset24.FieldByname('BASEICM').AsFloat)),',','.'); //Base de Cálculo do ICMS
  Form7.spdNFeDataSets.Campo('vICMS_W04').Value   := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset24.FieldByname('ICMS').AsFloat)),',','.'); // Valor Total do ICMS

  Form7.spdNFeDataSets.Campo('vICMSDeson_W04a').Value    := '0.00'; // Desonerado

  Form7.spdNFeDataSets.Campo('vBCST_W05').Value   := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset24.FieldByname('BASESUBSTI').AsFloat)),',','.'); // Base de Cálculo do ICMS Subst. Tributária

  if Form1.sVersaoLayout = '4.00' then
  begin
    // No caso de nota fiscal de devolucao
    Form7.spdNFeDataSets.campo('vIPIDevol_W12a').Value  := '0.00'; // Valor Total do IPI devolvido
    //
    Form7.spdNFeDataSets.campo('vFCP_W04h').Value       := '0.00'; // Valor Total do FCP (Fundo de Combate à Pobreza)
    Form7.spdNFeDataSets.campo('vFCPST_W06a').Value     := '0.00'; // Valor Total do FCP (Fundo de Combate à Pobreza) retido por substituição tributária
    Form7.spdNFeDataSets.campo('vFCPSTRet_W06b').Value  := '0.00'; // Valor Total do FCP retido anteriormente por Substituição Tributária
  end;

  Form7.spdNFeDataSets.Campo('vST_W06').Value     := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset24.FieldByname('ICMSSUBSTI').AsFloat)),',','.');; // Valor Total do ICMS Sibst. Tributária

  {Sandro Silva 2023-09-04 inicio}
  Form7.spdNFeDataSets.Campo('qBCMonoRet_W06d1').Value  := FormatFloatXML(dqBCMonoRet_N43aTotal); //Valor total da quantidade tributada do ICMS monofásico retido anteriormente
  Form7.spdNFeDataSets.Campo('vICMSMonoRet_W06e').Value := FormatFloatXML(dvICMSMonoRet_N45Total); //Valor total do ICMS monofásico retido anteriormente
  {Sandro Silva 2023-09-04 fim}

  Form7.spdNFeDataSets.Campo('vProd_W07').Value   := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset24.FieldByname('MERCADORIA').AsFloat)),',','.'); // Valor Total de Produtos
  Form7.spdNFeDataSets.Campo('vFrete_W08').Value  := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset24.FieldByname('FRETE').AsFloat)),',','.'); // Valor Total do Frete
  Form7.spdNFeDataSets.Campo('vSeg_W09').Value    := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset24.FieldByname('SEGURO').AsFloat)),',','.'); // Valor Total do Seguro
  Form7.spdNFeDataSets.Campo('vDesc_W10').Value   := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset24.FieldByname('DESCONTO').AsFloat)),',','.'); // Valor Total de Desconto
  Form7.spdNFeDataSets.Campo('vII_W11').Value     := StrTran(Alltrim(FormatFloat('##0.00',vTotalImpostoImportacao )),',','.'); // Valor Total do Imposto de Importação
  Form7.spdNFeDataSets.Campo('vIPI_W12').Value    := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset24.FieldByname('IPI').AsFloat)),',','.'); // Valor Total do IPI
  Form7.spdNFeDataSets.Campo('vPIS_W13').Value    := StrTran(Alltrim(FormatFloat('##0.00',vPIS)),',','.'); // Valor Toal do PIS
  Form7.spdNFeDataSets.Campo('vCOFINS_W14').Value := StrTran(Alltrim(FormatFloat('##0.00',vCOFINS)),',','.');; // Valor Total do COFINS
  Form7.spdNFeDataSets.Campo('vOutro_W15').Value  := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset24.FieldByname('DESPESAS').AsFloat)),',','.'); // OUtras Despesas Acessórias
  Form7.spdNFeDataSets.Campo('vNF_W16').Value     := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset24.FieldByname('TOTAL').AsFloat + vTotalImpostoImportacao )),',','.'); // Valor Total da NFe

  // Dados do Transporte da NFe
  Form7.spdNFeDataSets.Campo('modFrete_X02').Value := Alltrim(Form7.ibDataSet15.FieldByname('FRETE12').AsString);

  if AllTrim(Form7.ibDAtaset24TRANSPORTA.AsString)<>'' then
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
    end;

    Form7.spdNFeDataSets.Campo('xEnder_X08').Value   := ConverteAcentos2(Form7.ibDataSet18.FieldByname('ENDERECO').AsString); // Endereço do Transportador
    Form7.spdNFeDataSets.Campo('xMun_X09').Value     := ConverteAcentos2(Form7.ibDataSet18.FieldByname('MUNICIPIO').AsString); // Nome do Município do Transportador
    Form7.spdNFeDataSets.Campo('UF_X10').Value       := Form7.ibDataSet18.FieldByname('UF').AsString; // Sigla do Estado do Transportador

    if Length(StrTran(StrTran(Form7.ibDataSet18.FieldByname('PLACA').AsString,' ',''),'-','')) = 7 then // Sandro Silva 2023-09-21 if Length(StrTran(StrTran(Form7.ibDataSet15.FieldByname('PLACA').AsString,' ',''),'-','')) = 7 then
    begin
      // Sandro Silva 2023-09-21 Form7.spdNFeDataSets.Campo('placa_X19').Value    := StrTran(StrTran(Form7.ibDataSet15.FieldByname('PLACA').AsString,' ',''),'-',''); // Placa do Veículo
      Form7.spdNFeDataSets.Campo('placa_X19').Value    := StrTran(StrTran(Form7.ibDataSet18.FieldByname('PLACA').AsString,' ',''),'-',''); // Placa do Veículo
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

  // Dados da Carga Transportada
  Form7.spdNFeDataSets.Campo('qVol_X27').Value     := LimpaNumero(Form7.ibDAtaset24.FieldByname('VOLUMES').AsString); // Quantidade de Volumes transportados
  Form7.spdNFeDataSets.Campo('esp_X28').Value      := ConverteAcentos2(Form7.ibDAtaset24.FieldByname('ESPECIE').AsString); // Espécie de Carga Transportada
  Form7.spdNFeDataSets.Campo('marca_X29').Value    := ConverteAcentos2(Form7.ibDAtaset24.FieldByname('MARCA').AsString); // MArca da Carga Transportada
  Form7.spdNFeDataSets.Campo('nVol_X30').Value     := ConverteAcentos2(Form7.ibDAtaset24.FieldByname('NVOL').AsString);; // Numeração dos Volumes transportados

  Form7.spdNFeDataSets.Campo('pesoL_X31').Value    := StrTran(Alltrim(FormatFloat('##0.000',Form7.ibDAtaset24.FieldByname('PESOLIQUI').AsFloat)),',','.'); // Peso Líquido
  Form7.spdNFeDataSets.Campo('pesoB_X32').Value    := StrTran(Alltrim(FormatFloat('##0.000',Form7.ibDAtaset24.FieldByname('PESOBRUTO').AsFloat)),',','.'); // Peso Bruto

  // Dados De Cobrança
  // 1 Fatura  - 3 Duplicatas //
  //
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
      if Copy(Uppercase(Form7.ibDataSet14.FieldByname('INTEGRACAO').AsString)+'       ',1,5) = 'PAGAR' then
      begin
//                    Form7.spdNFeDataSets.campo('indPag_YA01b').Value    := '1';   // Pagamento a prazo
//                  Form7.spdNFeDataSets.campo('tPag_YA02').Value       := '05';  // Crédito Loja
        Form7.spdNFeDataSets.campo('tPag_YA02').Value       := '14';  // Duplicata Mercantil
      end else
      begin
//                    Form7.spdNFeDataSets.campo('indPag_YA01b').Value    := '0';   // Pagamento a vista
        Form7.spdNFeDataSets.campo('tPag_YA02').Value       := '01';  // Forma de pagamento
      end;
    end;

    if Form7.spdNFeDataSets.campo('tPag_YA02').Value = '90' then
    begin
      // Sem Pagamento
      //
      Form7.spdNFeDataSets.campo('vPag_YA03').Value       := '0.00';
//                  Form7.spdNFeDataSets.campo('vTroco_YA09').Value     := '0.00';  // valor do troco
    end else
    begin
      Form7.spdNFeDataSets.campo('vPag_YA03').Value       :=  Form7.spdNFeDataSets.Campo('vNF_W16').Value;
      Form7.spdNFeDataSets.campo('vTroco_YA09').Value     := '0.00';  // valor do troco
    end;

    Form7.spdNFeDataSets.SalvarPart('YA');
  end;

  Form7.spdNFeDataSets.Y.Append; // Inclui somente nessa Parte "Y" da NFe
  Form7.spdNFeDataSets.Campo('nFat_Y03').Value  := Copy(Form7.ibDAtaset24NUMERONF.AsString,1,9); // Número da Farura
  Form7.spdNFeDataSets.Campo('vOrig_Y04').Value := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset24TOTAL.AsFloat)),',','.'); // Valor Original da Fatura

  if Form1.sVersaoLayout = '4.00' then
  begin
//                if Form7.spdNFe.Ambiente = spdNFeType.akHomologacao then
    begin
      Form7.spdNFeDataSets.Campo('vDesc_Y05').Value := '0.00'; // Valor do Desconto
    end;
  end;

  Form7.spdNFeDataSets.Campo('vLiq_Y06').Value  := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset24TOTAL.AsFloat)),',','.'); // Valor Líquido da Fatura

  J := 0;

  Form7.ibDataSet8.First;
  while not Form7.ibDataSet8.Eof do
  begin
    // Note que Os dados da Fatura se encontram no Parte "Y" da NFe que vamos
    // fazer várias inserções para a Mesma NFe como demonstracao
    // Dados da Fatura
    //
    //
    // Duplicatas
    //
    J := J + 1;

    Form7.spdNFeDataSets.IncluirCobranca;
    Form7.spdNFeDataSets.Campo('nDup_Y08').Value  := StrZero(J,3,0); // Número da parcela
    Form7.spdNFeDataSets.Campo('dVenc_Y09').Value := StrTran(DateToStrInvertida(Form7.ibDataSet8VENCIMENTO.AsDateTime),'/','-');; // Data de Vencimento da Duplicata
    Form7.spdNFeDataSets.Campo('vDup_Y10').Value  := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet8VALOR_DUPL.AsFloat)),',','.'); // Valor da Duplicata
    Form7.spdNFeDataSets.SalvarCobranca;

    Form7.ibDataSet8.Next;
  end;

  Form7.spdNFeDataSets.Y.Post; // Grava a Duplicata em questão.
  // Dados Adicionais da NFe - Observações
  Form7.spdNFeDataSets.Campo('infAdFisco_Z02').Value := ''; // INteresse do Fisco
  Form7.spdNFeDataSets.Campo('infCpl_Z03').Value     := AllTrim(ConverteAcentos2(AllTrim(Form7.ibDAtaset24COMPLEMENTO.AsString))); // Informacoes Complementares

  {Sandro Silva 2023-06-13 inicio}
  if sMensagemIcmMonofasicoSobreCombustiveis <> '' then // Sandro Silva 2023-06-16
  begin
    Form7.spdNFeDataSets.Campo('infCpl_Z03').Value := Form7.spdNFeDataSets.Campo('infCpl_Z03').Value + '|' + sMensagemIcmMonofasicoSobreCombustiveis;
  end;
  {Sandro Silva 2023-06-13 fim}

  try
    Form7.ibDAtaset24.Edit;
    Form7.ibDAtaset24MODELO.AsString    := '55';
    Form7.ibDAtaset24.Post;
  except
  end;

  FreeAndNil(IBQUERY99);
end;

procedure GeraXmlNFeEntradaTags;
var
  fAliquota: Real;
  dvICMSMonoRet_N45: Real; // Sandro Silva 2023-06-13
begin
  //////////////////// Aqui começam os Impostos Incidentes sobre o Item////////////////////////
  /// Verificar Manual pois existe uma variação nos campos de acordo com Tipo de Tribucação ////
  // ICMS
  fAliquota := 0;
  if (LimpaNumero(Form7.ibDataSet13.FieldByname('CRT').AsString) <> '1') then
  begin
    // 1 - Simples nacional
    // 2 - Simples nacional - Excesso de Sublimite de Receita Bruta
    // 3 - Regime normal
    //
    // N11 e N12 todos Tem
    //
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

    // Tem que voltar ao CFOP original da nota

    // Posiciona na tabéla de CFOP
    Form7.ibDataSet14.DisableControls;
    Form7.ibDataSet14.Close;
    Form7.ibDataSet14.SelectSQL.Clear;
    Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''1'' or  SubString(CFOP from 1 for 1) = ''2'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''3''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
    Form7.ibDataSet14.Open;
    Form7.ibDataSet14.Locate('NOME',Form7.ibDAtaset24OPERACAO.AsString,[]);
    Form7.ibDataSet14.EnableControls;

    {Sandro Silva 2023-06-13 inicio}
    if (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '61') then
    begin
      Form7.spdNFeDataSets.Campo('vBC_N15').Value   := '0.00'; // Valor da Base de Cálculo do ICMS
      Form7.spdNFeDataSets.Campo('vICMS_N17').Value := '0.00'; // Valor do ICMS em Reais
    end;
    {Sandro Silva 2023-06-13 fim}


    // TAGS
    if (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '00')
    or (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '10')
    or (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '20')
    or (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '51')
    or (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '70')
    or (Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '90') then
    begin
      if (Form7.ibDAtaset23.FieldByname('BASE').AsFloat = 0) then
      begin
        Form7.spdNFeDataSets.Campo('vBC_N15').Value   := '0'; // Valor da Base de Cálculo do ICMS
        Form7.spdNFeDataSets.Campo('vICMS_N17').Value := '0'; // Valor do ICMS em Reais
      end else
      begin
        Form7.spdNFeDataSets.Campo('vBC_N15').Value    := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('VBC').AsFloat)),',','.');  // BC
        Form7.spdNFeDataSets.Campo('vICMS_N17').Value  := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('VICMS').AsFloat)),',','.');     // Valor do ICMS em Reais
      end;
    end;

    if Form7.spdNFeDataSets.Campo('CST_N12').AssTring = '00' then
    begin
      // St 00
      Form7.spdNFeDataSets.Campo('modBC_N13').Value   := '3'; // Modalidade de determinação da Base de Cálculo - ver Manual
      Form7.spdNFeDataSets.Campo('pICMS_N16').Value  := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('ICM').AsFloat)),',','.'); // Alíquota do ICMS em Percentual
    end;

    if (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '10')
    or (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '30')
    or (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '60')
    or (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '70')
    or (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '90') then
    begin
      // St 60 só tem N21 e N23
      if Form7.ibDAtaset24BASESUBSTI.AsFloat <> 0 then
      begin
        if Form7.spdNFeDataSets.Campo('CST_N12').AsString <> '60' then
        begin
          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value      := '100'; // Percentual de margem de valor adicionado do ICMS ST
        end;

        Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('VBCST').AsFloat)),',','.');    // Valor da BC do ICMS ST
        Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('VICMSST').AsFloat)),',','.');  // VAlor do ICMS ST

        if Form7.spdNFeDataSets.Campo('CST_N12').AsString = '60' then
        begin
          // FICHA 2786
          //
          Form7.spdNFeDataSets.Campo('vbCSTRet_N26').Value          := '0.00'; // Valor cobrado anteriormente por ST Ok
          Form7.spdNFeDataSets.Campo('pST_N26a').Value              := '0.00'; // Aliquota suportada pelo consumidor
          Form7.spdNFeDataSets.Campo('vICMSSubstituto_N26b').Value  := '0.00'; // Valor do icms próprio do substituto cobrado em operação anterior
          Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value        := '0.00'; // Valor do ICMS ST em Reais
        end else
        begin
          Form7.spdNFeDataSets.Campo('vbCSTRet_N26').Value    := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('VBCST').AsFloat)),',','.');  // Valor do BC do ICMS ST retido na UF Emitente ok
          Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value  := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('VICMSST').AsFloat)),',','.');  //  Valor do ICMS ST retido na UF Emitente
        end;
      end else
      begin
        if Form7.spdNFeDataSets.Campo('CST_N12').AsString <> '60' then
        begin
          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value      := '0'; // Percentual de margem de valor adicionado do ICMS ST
        end else
        begin
          Form7.spdNFeDataSets.Campo('pST_N26a').Value      := '0.00'; // Aliquota suportada pelo consumidor
          Form7.spdNFeDataSets.Campo('vICMSSubstituto_N26b').Value  := '0.00'; // Valor do icms próprio do substituto cobrado em operação anterior
        end;

        Form7.spdNFeDataSets.Campo('vbCST_N21').Value       := '0.00'; // Valor cobrado anteriormente por ST
        Form7.spdNFeDataSets.Campo('vICMSST_N23').Value     := '0.00';  // Valor do ICMS ST em Reais

        Form7.spdNFeDataSets.Campo('vbCSTRet_N26').Value    := '0.00'; // Valor cobrado anteriormente por ST Ok
        Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value  := '0.00'; // Valor do ICMS ST em Reais
      end;
    end;

    if Form7.spdNFeDataSets.Campo('CST_N12').AsString = '10' then
    begin
      // St 10
      Form7.spdNFeDataSets.Campo('modBC_N13').Value     := '3'; // Modalidade de determinação da Base de Cálculo - ver Manual

      Form7.spdNFeDataSets.Campo('pICMS_N16').Value     := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('ICM').AsFloat)),',','.'); // Alíquota do ICMS em Percentual
      Form7.spdNFeDataSets.Campo('modBCST_N18').Value   := '4'; // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual

      if Form7.ibDAtaset23.FieldByname('VBCST').AsFloat > 0 then
        Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   := StrTran(Alltrim(FormatFloat('##0.00',((Form7.ibDAtaset23.FieldByname('VICMSST').AsFloat / Form7.ibDAtaset23.FieldByname('VBCST').AsFloat) * 100))),',','.');  // Aliquota do Imposto do ICMS ST
    end;

    if (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '40') or (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '41') or (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '50') then
    begin
//                      Form7.spdNFeDataSets.Campo('vICMS_N17').Value       := ''; // Valor do ICMS em Reais
//                      Form7.spdNFeDataSets.Campo('motDesICMS_N28').Value  := '9'; // Motivo da desoneração do ICMS
      Form7.spdNFeDataSets.Campo('vbCSTRet_N26').Value    := '';  // Valor cobrado anteriormente por ST
      Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value  := '';  // Valor do ICMS ST em Reais
      Form7.spdNFeDataSets.Campo('vBCSTDest_N31').Value   := '';  // Valor da BC do ICMS ST da UF Destino
    end;

    if (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '20') or (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '51') then
    begin
      // St 20
      Form7.spdNFeDataSets.Campo('modBC_N13').Value     := '3'; // Modalidade de determinação da Base de Cálculo - ver Manual

      if (100-Form7.ibDAtaset23.FieldByname('BASE').AsFloat) = 100 then
      begin
        Form7.spdNFeDataSets.Campo('pRedBC_N14').Value := '100'; // Percentual da redução de BC
      end else
      begin
        Form7.spdNFeDataSets.Campo('pRedBC_N14').Value := StrTran(Alltrim(FormatFloat('##0.00',100-Form7.ibDAtaset23.FieldByname('BASE').AsFloat)),',','.'); // Percentual da redução de BC
      end;

      Form7.spdNFeDataSets.Campo('pICMS_N16').Value  := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('ICM').AsFloat)),',','.'); // Alíquota do ICMS em Percentual

      if Form7.spdNFeDataSets.Campo('CST_N12').AsString = '51' then
      begin
        try
          Form7.spdNFeDataSets.Campo('vICMSOp_N16a').Value   := StrTran(Alltrim(FormatFloat('##0.00',Arredonda2(Form7.ibDAtaset23.FieldByname('ICM').AsFloat*(Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat)/100*Form7.ibDAtaset23.FieldByname('BASE').AsFloat/100,2))),',','.');
          Form7.spdNFeDataSets.Campo('pDif_N16b').Value      := '100';
          Form7.spdNFeDataSets.Campo('vICMSDif_N16c').Value  := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('ICM').AsFloat*(Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat)/100*Form7.ibDAtaset23.FieldByname('BASE').AsFloat/100)),',','.');

          // Ficha 2756
          Form7.spdNFeDataSets.Campo('vICMS_N17').Value      := '0'; // Valor do ICMS em Reais
        except
          on E: Exception do
          begin
            {
            Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+' Erro: 2756'
            ),'Atenção',mb_Ok + MB_ICONWARNING);
            Mauricio Parizotto 2023-10-25}
            MensagemSistema(E.Message+chr(10)+chr(10)+' Erro: 2756',msgErro);
          end;
        end;
      end;
    end;

    if Form7.spdNFeDataSets.Campo('CST_N12').AsString = '30' then
    begin
      // St 30
      Form7.spdNFeDataSets.Campo('modBCST_N18').Value     := '4'; // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual
      Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '100'; // Percentual de redução de BC do ICMS ST
      if Form7.ibDAtaset23.FieldByname('VBCST').AsFloat > 0 then
        Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   := StrTran(Alltrim(FormatFloat('##0.00',((Form7.ibDAtaset23.FieldByname('VICMSST').AsFloat / Form7.ibDAtaset23.FieldByname('VBCST').AsFloat) * 100))),',','.');  // Aliquota do Imposto do ICMS ST
    end;

    if Form7.spdNFeDataSets.Campo('CST_N12').AsString = '60' then
    begin
      // St 60
      Form7.spdNFeDataSets.Campo('modBCST_N18').Value     := '4'; // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual
      Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '100'; // Percentual de redução de BC do ICMS ST
      if Form7.ibDAtaset23.FieldByname('VBCST').AsFloat > 0 then Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   := StrTran(Alltrim(FormatFloat('##0.00',((Form7.ibDAtaset23.FieldByname('VICMSST').AsFloat / Form7.ibDAtaset23.FieldByname('VBCST').AsFloat) * 100))),',','.');  // Aliquota do Imposto do ICMS ST
    end;

    if (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '70')
      or  (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '90') then
    begin
      // St 70
      Form7.spdNFeDataSets.Campo('modBC_N13').Value     := '3'; // Modalidade de determinação da Base de Cálculo - ver Manual

      if (100-Form7.ibDAtaset23.FieldByname('BASE').AsFloat) = 100 then
      begin
        Form7.spdNFeDataSets.Campo('pRedBC_N14').Value := '100'; // Percentual da redução de BC
      end else
      begin
        Form7.spdNFeDataSets.Campo('pRedBC_N14').Value := StrTran(Alltrim(FormatFloat('##0.00',100-Form7.ibDAtaset23.FieldByname('BASE').AsFloat)),',','.'); // Percentual da redução de BC
      end;

      Form7.spdNFeDataSets.Campo('pICMS_N16').Value  := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('ICM').AsFloat)),',','.'); // Alíquota do ICMS em Percentual

      Form7.spdNFeDataSets.Campo('modBCST_N18').Value     := '4'; // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual
      Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '100'; // Percentual de redução de BC do ICMS ST

      if Form7.ibDAtaset23.FieldByname('VBCST').AsFloat > 0 then
        Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   := StrTran(Alltrim(FormatFloat('##0.00',((Form7.ibDAtaset23.FieldByname('VICMSST').AsFloat / Form7.ibDAtaset23.FieldByname('VBCST').AsFloat) * 100))),',','.') else Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   := '0.00';  // Aliquota do Imposto do ICMS ST
    end;

    if LimpaNumero(Form7.ibDataSet13.FieldByname('CRT').AsString) = '1' then
    begin
      Form7.spdNFeDataSets.Campo('vBC_N15').Value     := '0';  // BC
      Form7.spdNFeDataSets.Campo('vICMS_N17').Value   := '0';  // Valor do ICMS em Reais
    end;

    if (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '30') or
       (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '40') or
       (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '41') or
       (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '50') or
       (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '60') then
    begin
//                      Form7.spdNFeDataSets.Campo('vBC_N15').Value     := '0';  // BC
//                      Form7.spdNFeDataSets.Campo('vICMS_N17').Value   := '0';  // Valor do ICMS em Reais
    end;

    if (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '30') or
       (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '10') or
       (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '70') or
       (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '90') then
    begin
      Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := '100'; // Percentual de margem de valor adicionado do ICMS ST
    end;
    //
    if Form1.sVersaoLayout = '4.00' then
    begin
      if Form7.spdNFeDataSets.Campo('CST_N12').AsString = '60' then
      begin
        Form7.spdNFeDataSets.campo('pST_N26a').Value                := '0.00'; // Alíquota suportada pelo Consumidor Final
        Form7.spdNFeDataSets.Campo('vICMSSubstituto_N26b').Value    := '0.00'; // Valor do icms próprio do substituto cobrado em operação anterior
        //
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
    end;

    // Entrada empresa no Regime normal por CST
    //
    {
    if Form1.sVersaoLayout = '4.00' then
    begin
      //
      if Form7.spdNFeDataSets.Campo('CST_N12').AsString = '00' then
      begin
        //
        Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := '0.00'; // Percentual do Fundo de Combate à Pobreza (FCP)
        Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := '0.00'; // Valor do Fundo de Combate à Pobreza (FCP)
        //
      end;
      //
      if Form7.spdNFeDataSets.Campo('CST_N12').AsString = '10' then
      begin
        //
        Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := '0.00'; // Valor da Base de Cálculo do FCP
        Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := '0.00'; // Percentual do Fundo de Combate à Pobreza (FCP)
        Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := '0.00'; // Valor do Fundo de Combate à Pobreza (FCP)
        //
        Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := '0.00'; // Valor da Base de Cálculo do FCP retido por Substituição Tributária
        Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := '0.00'; // Percentual do FCP retido por Substituição Tributária
        Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := '0.00'; // Valor do FCP retido por Substituição Tributária
        //
      end;
      //
      if Form7.spdNFeDataSets.Campo('CST_N12').AsString = '20' then
      begin
        //
        Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := '0.00'; // Valor da Base de Cálculo do FCP
        Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := '0.00'; // Percentual do Fundo de Combate à Pobreza (FCP)
        Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := '0.00'; // Valor do Fundo de Combate à Pobreza (FCP)
        //
      end;
      //
      if Form7.spdNFeDataSets.Campo('CST_N12').AsString = '30' then
      begin
        //
        Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := '0.00'; // Valor da Base de Cálculo do FCP retido por Substituição Tributária
        Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := '0.00'; // Percentual do FCP retido por Substituição Tributária
        Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := '0.00'; // Valor do FCP retido por Substituição Tributária
        //
      end;
      //
      if Form7.spdNFeDataSets.Campo('CST_N12').AsString = '51' then
      begin
        //
        Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := '0.00'; // Valor da Base de Cálculo do FCP
        Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := '0.00'; // Percentual do Fundo de Combate à Pobreza (FCP)
        Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := '0.00'; // Valor do Fundo de Combate à Pobreza (FCP)
        //
      end;
      //
      if Form7.spdNFeDataSets.Campo('CST_N12').AsString = '60' then
      begin
        //
        Form7.spdNFeDataSets.campo('pST_N26a').Value       := '0.00'; // Alíquota suportada pelo Consumidor Final
        //
        Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := '0.00'; // Valor da Base de Cálculo do FCP retido por Substituição Tributária
        Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := '0.00'; // Percentual do FCP retido por Substituição Tributária
        Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := '0.00'; // Valor do FCP retido por Substituição Tributária
        //
      end;
      //
      if (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '70') or (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '90') then
      begin
        //
        Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := '0.00'; // Valor da Base de Cálculo do FCP
        Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := '0.00'; // Percentual do Fundo de Combate à Pobreza (FCP)
        Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := '0.00'; // Valor do Fundo de Combate à Pobreza (FCP)
        //
        Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := '0.00'; // Valor da Base de Cálculo do FCP retido por Substituição Tributária
        Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := '0.00'; // Percentual do FCP retido por Substituição Tributária
        Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := '0.00'; // Valor do FCP retido por Substituição Tributária
        //
      end;
    end;
    }

    // FCP

  end;


  // TAGS - Simples NAcional - CSOSN
  if LimpaNumero(Form7.ibDataSet13.FieldByname('CRT').AsString) = '1' then
  begin
    // 1 - Simples nacional
    // 2 - Simples nacional - Excesso de Sublimite de Receita Bruta
    // 3 - Regime normal


    // N12a Tem em todas - e eé referencia para classificar as tags
    if AllTrim(Form7.ibDataSet14.FieldByName('CSOSN').AsString) <> '' then
    begin
      Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value  := Form7.ibDataSet14.FieldByname('CSOSN').AsString;
    end else
    begin
      Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value  := Trim(Form7.ibDataSet4.FieldByname('CSOSN').AsString);
    end;

    // N11 - Tem em todas
    try
      if AllTrim(Form7.ibDataSet14.FieldByName('CST').AsString) <> '' then
      begin
        Form7.spdNFeDataSets.Campo('orig_N11').Value   := Copy(LimpaNumero(Form7.ibDataSet14.FieldByname('CST').AsString)+'000',1,1); //Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
      end else
      begin
        Form7.spdNFeDataSets.Campo('orig_N11').Value   := Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',1,1); //Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
      end;
    except
      Form7.spdNFeDataSets.Campo('orig_N11').Value   := '0';
    end;

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
      fAliquota := 2.82;

      Form7.spdNFeDataSets.Campo('pCredSN_N29').VAlue       := StrTran(Alltrim(FormatFloat('##0.00',fAliquota)),',','.'); // Aliquota aplicave de cálculo de crédito (Simples Nacional)
      Form7.spdNFeDataSets.Campo('vCredICMSSN_N30').VAlue   := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat * fAliquota / 100)),',','.'); // VAlor de crédito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)
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
      Form7.spdNFeDataSets.Campo('modBCST_N18').Value   := '4'; // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual
      Form7.spdNFeDataSets.Campo('pMVAST_N19').Value    := '100'; // Percentual de margem de valor adicionado do ICMS ST
      Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value  := '100'; // Percentual de redução de BC do ICMS ST

      fAliquota := 2.82;

      if Form7.ibDAtaset23.FieldByname('BASE').AsFloat > 0 then
      begin
        Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('VBCST').AsFloat)),',','.');    // Valor da BC do ICMS ST
        Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('VICMSST').AsFloat)),',','.');  // VAlor do ICMS ST
      end;

      if Form7.ibDAtaset23.FieldByname('VBCST').AsFloat > 0 then Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   := StrTran(Alltrim(FormatFloat('##0.00',((Form7.ibDAtaset23.FieldByname('VICMSST').AsFloat / Form7.ibDAtaset23.FieldByname('VBCST').AsFloat) * 100))),',','.');  // Aliquota do Imposto do ICMS ST
      Form7.spdNFeDataSets.Campo('pCredSN_N29').VAlue     := StrTran(Alltrim(FormatFloat('##0.00',fAliquota)),',','.'); // Aliquota aplicave de cálculo de crédito (Simples Nacional)
      Form7.spdNFeDataSets.Campo('vCredICMSSN_N30').VAlue := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat * fAliquota / 100)),',','.'); // VAlor de crédito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)
    end;

    // CSOSN 202, 203 -
    if (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '202') or (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '203') then
    begin
      Form7.spdNFeDataSets.Campo('modBCST_N18').Value     := '4'; // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual
      Form7.spdNFeDataSets.Campo('pMVAST_N19').Value      := '100'; // Percentual de margem de valor adicionado do ICMS ST
      Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '100'; // Percentual de redução de BC do ICMS ST

      if Form7.ibDAtaset23.FieldByname('BASE').AsFloat > 0 then
      begin
        Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('VBCST').AsFloat)),',','.');    // Valor da BC do ICMS ST
        Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('VICMSST').AsFloat)),',','.');  // VAlor do ICMS ST
      end;

      if Form7.ibDAtaset23.FieldByname('VBCST').AsFloat > 0 then Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   := StrTran(Alltrim(FormatFloat('##0.00',((Form7.ibDAtaset23.FieldByname('VICMSST').AsFloat / Form7.ibDAtaset23.FieldByname('VBCST').AsFloat) * 100))),',','.');  // Aliquota do Imposto do ICMS ST
    end;

    // CSOSN 500
    if (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '500') then
    begin
      Form7.spdNFeDataSets.Campo('pST_N26a').Value                  := '0.00'; // Aliquota suportada pelo consumidor
      Form7.spdNFeDataSets.Campo('vICMSSubstituto_N26b').Value      := '0.00'; // Valor do icms próprio do substituto cobrado em operação anterior
      Form7.spdNFeDataSets.Campo('vbCSTRet_N26').Value              := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('VBCST').AsFloat)),',','.');  // Valor do BC do ICMS ST retido na UF Emitente ok
      Form7.spdNFeDataSets.Campo('vICMSSTRet_N27').Value            := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('VICMSST').AsFloat)),',','.');  //  Valor do ICMS ST retido na UF Emitente
    end;

    // CSOSN 900
    if (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '900') then
    begin
      // 900 – Outros – Classificam-se neste código as demais operações que não se enquadrem nos códigos 101, 102, 103, 201, 202, 203, 300, 400 e 500.
      //
      // N11 - Já está preenchido acima - todos tem
      // N12a - Já está preenchido acima - todos tem
      Form7.spdNFeDataSets.Campo('modBC_N13').Value  := '3'; // Modalidade de determinação da Base de Cálculo - ver Manual

      if (Form7.ibDAtaset23.FieldByname('BASE').AsFloat = 0) then
      begin
        Form7.spdNFeDataSets.Campo('vBC_N15').Value   := '0'; // Valor da Base de Cálculo do ICMS
        Form7.spdNFeDataSets.Campo('vICMS_N17').Value := '0'; // Valor do ICMS em Reais
      end else
      begin
        Form7.spdNFeDataSets.Campo('vBC_N15').Value    := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('VBC').AsFloat)),',','.');  // BC
        Form7.spdNFeDataSets.Campo('vICMS_N17').Value  := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('VICMS').AsFloat)),',','.');     // Valor do ICMS em Reais
      end;

      if (100-Form7.ibDAtaset23.FieldByname('BASE').AsFloat) <> 0 then
      begin
        Form7.spdNFeDataSets.Campo('pRedBC_N14').Value := StrTran(Alltrim(FormatFloat('##0.00',100-Form7.ibDAtaset23.FieldByname('BASE').AsFloat)),',','.'); // Percentual da redução de BC
      end else
      begin
        // Form7.spdNFeDataSets.Campo('pRedBC_N14').Value := '100';
      end;

      Form7.spdNFeDataSets.Campo('pICMS_N16').Value  := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('ICM').AsFloat)),',','.'); // Alíquota do ICMS em Percentual

      Form7.spdNFeDataSets.Campo('modBCST_N18').Value   := '4'; // Modalidade de determinação da Base de Cálculo do ICMS ST - ver Manual

      if Form7.ibDataSet4PIVA.AsFloat > 0 then
      begin
        if Form7.ibDAtaset23.FieldByname('BASE').AsFloat > 0 then
        begin
          // (1.3 * 100) - 100

          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := StrTran(Alltrim(FormatFloat('##0.00', (Form7.ibDataSet4PIVA.AsFloat*100)-100 )),',','.'); // Percentual de margem de valor adicionado do ICMS ST
        end else
        begin
          Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := '100'; // Percentual de margem de valor adicionado do ICMS ST
        end;
      end else
      begin
        Form7.spdNFeDataSets.Campo('pMVAST_N19').Value := '100'; // Percentual de margem de valor adicionado do ICMS ST
      end;
      Form7.spdNFeDataSets.Campo('pREDBCST_N20').Value    := '100'; // Percentual de redução de BC do ICMS ST
      //
      if Form7.ibDAtaset23.FieldByname('VBCST').AsFloat > 0 then
      begin
        try
          Form7.spdNFeDataSets.Campo('vbCST_N21').Value     := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('VBCST').AsFloat)),',','.');    // Valor da BC do ICMS ST
          Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   := StrTran(Alltrim(FormatFloat('##0.00',((Form7.ibDAtaset23.FieldByname('VICMSST').AsFloat / Form7.ibDAtaset23.FieldByname('VBC').AsFloat) * 100))),',','.');  // Aliquota do Imposto do ICMS ST
          Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('VICMSST').AsFloat)),',','.');  // VAlor do ICMS ST
        except
          Form7.spdNFeDataSets.Campo('vbCST_N21').Value     :=  '0'; // Valor da BC do ICMS ST
          Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   :=  '0'; // Aliquota do Imposto do ICMS ST
          Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   :=  '0'; // VAlor do ICMS ST
        end;
      end else
      begin
        Form7.spdNFeDataSets.Campo('vbCST_N21').Value     :=  '0'; // Valor da BC do ICMS ST
        Form7.spdNFeDataSets.Campo('pICMSST_N22').Value   :=  '0'; // Aliquota do Imposto do ICMS ST
        Form7.spdNFeDataSets.Campo('vICMSST_N23').Value   :=  '0'; // VAlor do ICMS ST
      end;

      Form7.spdNFeDataSets.Campo('pCredSN_N29').VAlue       := StrTran(Alltrim(FormatFloat('##0.00',fAliquota)),',','.'); // Aliquota aplicave de cálculo de crédito (Simples Nacional)
      Form7.spdNFeDataSets.Campo('vCredICMSSN_N30').VAlue  := StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDAtaset23.FieldByname('TOTAL').AsFloat * fAliquota / 100)),',','.'); // VAlor de crédito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)

      {Sandro Silva 2023-05-09 inicio
      if Form1.sVersaoLayout = '4.00' then
      begin
        // Nf de entrada Entrada Simples Nacinal

        if fPercentualFCP <> 0 then
        begin
          if Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '201' then
          begin
            Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := '0.00'; // Valor da Base de Cálculo do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := '0.00'; // Percentual do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := '0.00'; // Valor do FCP retido por Substituição Tributária
          end;

          if (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '202') or (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '203') then
          begin
            Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := '0.00'; // Valor da Base de Cálculo do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := '0.00'; // Percentual do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := '0.00'; // Valor do FCP retido por Substituição Tributária
          end;

          if (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '900') then
          begin
            Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := '0.00'; // Valor da Base de Cálculo do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := '0.00'; // Percentual do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := '0.00'; // Valor do FCP retido por Substituição Tributária
          end;
        end;

      end;
      }

      if Form7.spdNFeDataSets.Campo('CST_N12').AsString = '00' then
      begin

        if (Form7.ibDataSet23.FieldByname('PFCP').AsFloat) <> 0 then
        begin
          Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(Form7.ibDataSet23.FieldByname('PFCP').AsFloat); // Percentual do Fundo de Combate à Pobreza (FCP)
          Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(Form7.ibDataSet23.FieldByname('VFCP').AsFloat); // Valor do Fundo de Combate à Pobreza (FCP)
        end;

      end;

      if Form7.spdNFeDataSets.Campo('CST_N12').AsString = '10' then
      begin

        if (Form7.ibDataSet23.FieldByname('PFCP').AsFloat) <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := FormatFloatXML(Form7.ibDataSet23.FieldByname('VBCFCP').AsFloat);// Valor da Base de Cálculo do FCP
          Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(Form7.ibDataSet23.FieldByname('PFCP').AsFloat); // Percentual do Fundo de Combate à Pobreza (FCP)
          Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(Form7.ibDataSet23.FieldByname('VFCP').AsFloat); // Valor do Fundo de Combate à Pobreza (FCP)
        end;

        if Form7.ibDataSet23.FieldByname('PFCPST').AsFloat <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(Form7.ibDataSet23.FieldByname('VBCFCPST').AsFloat); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
          Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(Form7.ibDataSet23.FieldByname('PFCPST').AsFloat); // Percentual do FCP retido por Substituição Tributária

          if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML(Form7.ibDataSet23.FieldByname('VFCPST').AsFloat); // Valor do FCP retido por Substituição Tributária
          end else
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML(Form7.ibDataSet23.FieldByname('VFCPST').AsFloat); // Valor do FCP retido por Substituição Tributária
          end;
        end;

      end;

      if Form7.spdNFeDataSets.Campo('CST_N12').AsString = '20' then
      begin

        if Form7.ibDataSet23.FieldByname('PFCP').AsFloat <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := FormatFloatXML(Form7.ibDataSet23.FieldByname('VBCFCP').AsFloat); // Valor da Base de Cálculo do FCP
          Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(Form7.ibDataSet23.FieldByname('PFCP').AsFloat); // Percentual do Fundo de Combate à Pobreza (FCP)
          Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(Form7.ibDataSet23.FieldByname('VFCP').AsFloat); // Valor do Fundo de Combate à Pobreza (FCP)
        end;

      end;

      if Form7.spdNFeDataSets.Campo('CST_N12').AsString = '30' then
      begin

        if Form7.ibDataSet23.FieldByname('PFCPST').AsFloat <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(Form7.ibDataSet23.FieldByname('VBCFCPST').AsFloat); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
          Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(Form7.ibDataSet23.FieldByname('PFCPST').AsFloat); // Percentual do FCP retido por Substituição Tributária
          Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML(Form7.ibDataSet23.FieldByname('VFCPST').AsFloat); // Valor do FCP retido por Substituição Tributária
        end;

      end;

      if Form7.spdNFeDataSets.Campo('CST_N12').AsString = '51' then
      begin

        if Form7.ibDataSet23PFCP.AsFloat <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := FormatFloatXML(Form7.ibDataSet23.FieldByname('VBCFCP').AsFloat); // Valor da Base de Cálculo do FCP
          Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(Form7.ibDataSet23.FieldByname('PFCP').AsFloat); // Percentual do Fundo de Combate à Pobreza (FCP)
          Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(Form7.ibDataSet23.FieldByname('VFCP').AsFloat); // Valor do Fundo de Combate à Pobreza (FCP)
        end;

      end;

      if Form7.spdNFeDataSets.Campo('CST_N12').AsString = '60' then
      begin
        //                          Form7.spdNFeDataSets.campo('vBCFCPSTRet_N27a').Value := '0.00'; // Valor da Base de Cálculo do FCP retido anteriormente por ST
        //                          Form7.spdNFeDataSets.campo('pFCPSTRet_N27b').Value   := '0.00'; // Percentual do FCP retido anteriormente por Substituição Tributária
        //                          Form7.spdNFeDataSets.campo('vFCPSTRet_N27d').Value   := '0.00'; // Valor do FCP retido por Substituição Tributária
      end;

      if (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '70') or (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '90') then
      begin

        if Form7.ibDataSet23.FieldByname('PFCP').AsFloat <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCP_N17a').Value   := FormatFloatXML(Form7.ibDataSet23.FieldByname('VBCFCP').AsFloat); // Valor da Base de Cálculo do FCP
          Form7.spdNFeDataSets.campo('pFCP_N17b').Value     := FormatFloatXML(Form7.ibDataSet23.FieldByname('PFCP').AsFloat); // Percentual do Fundo de Combate à Pobreza (FCP)
          Form7.spdNFeDataSets.campo('vFCP_N17c').Value     := FormatFloatXML(Form7.ibDataSet23.FieldByname('VFCP').AsFloat); // Valor do Fundo de Combate à Pobreza (FCP)
        end;

        if Form7.ibDataSet23.FieldByname('PFCPST').AsFloat <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(Form7.ibDataSet23.FieldByname('VBCFCPST').AsFloat); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
          Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(Form7.ibDataSet23.FieldByname('PFCPST').AsFloat); // Percentual do FCP retido por Substituição Tributária

          if (UpperCase(Form7.ibDAtaset2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value  := FormatFloatXML(Form7.ibDataSet23.FieldByname('VFCPST').AsFloat); // Valor do FCP retido por Substituição Tributária
          end else
          begin
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value  := FormatFloatXML(Form7.ibDataSet23.FieldByname('VFCPST').AsFloat); // Valor do FCP retido por Substituição Tributária
          end;
        end;

      end;

    end; // if (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '900') then


    // FCP
    try

      if Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '201' then
      begin

        if Form7.ibDataSet23PFCPST.AsFloat <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(Form7.ibDataSet23VBCFCPST.AsFloat); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
          Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(Form7.ibDataSet23PFCPST.AsFloat); // Percentual do FCP retido por Substituição Tributária
          Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML(Form7.ibDataSet23VFCPST.AsFloat); // Valor do FCP retido por Substituição Tributária
        end;
      end;

      if (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '202') or (Form7.spdNFeDataSets.Campo('CSOSN_N12a').Value = '203') then
      begin
        if Form7.ibDataSet23PFCPST.AsFloat <> 0 then
        begin
          Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(Form7.ibDataSet23VBCFCPST.AsFloat); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
          Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(Form7.ibDataSet23PFCPST.AsFloat); // Percentual do FCP retido por Substituição Tributária
          Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML(Form7.ibDataSet23VFCPST.AsFloat); // Valor do FCP retido por Substituição Tributária
        end;
      end;

      if (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '500') then
      begin
        //                            Form7.spdNFeDataSets.campo('vBCFCPSTRet_N27a').Value := '0.00'; // Valor da Base de Cálculo do FCP retido anteriormente por ST
        //                            Form7.spdNFeDataSets.campo('pFCPSTRet_N27b').Value   := '0.00'; // Percentual do FCP retido anteriormente por Substituição Tributária
        //                            Form7.spdNFeDataSets.campo('vFCPSTRet_N27d').Value   := '0.00'; // Valor do FCP retido por Substituição Tributária
      end;

      if (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '900') or (Form7.ibDataSet14.FieldByname('CSOSN').AsString = '900') then
      begin
        try
          if Form7.ibDataSet23PFCPST.AsFloat <> 0 then
          begin
            Form7.spdNFeDataSets.campo('vBCFCPST_N23a').Value  := FormatFloatXML(Form7.ibDataSet23VBCFCPST.AsFloat); // Valor da Base de Cálculo do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('pFCPST_N23b').Value    := FormatFloatXML(Form7.ibDataSet23PFCPST.AsFloat); // Percentual do FCP retido por Substituição Tributária
            Form7.spdNFeDataSets.campo('vFCPST_N23d').Value    := FormatFloatXML(Form7.ibDataSet23VFCPST.AsFloat); // Valor do FCP retido por Substituição Tributária

          end;
        except
          on E: Exception do
          begin
            //Application.MessageBox(pChar(E.Message + chr(10) + chr(10) + 'ao calcular Percentual do FCP retido por Substituição Tributária CSOSN 900'), 'Atenção', mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
            MensagemSistema(E.Message + chr(10) + chr(10) + 'ao calcular Percentual do FCP retido por Substituição Tributária CSOSN 900',msgAtencao);
          end;
        end;
      end;
    except
      on E: Exception do
      begin
        //Application.MessageBox(pChar(E.Message + chr(10) + chr(10) + 'ao calcular FCP 2.'), 'Atenção', mb_Ok + MB_ICONWARNING);  Mauricio Parizotto 2023-10-25
        MensagemSistema(E.Message + chr(10) + chr(10) + 'ao calcular FCP 2.',msgAtencao);
      end;
    end;

    {Sandro Silva 2023-06-13 inicio}
    if (Form7.spdNFeDataSets.Campo('CSOSN_N12a').AsString = '61') then
    begin
      Form7.spdNFeDataSets.Campo('CSOSN_N12a').Clear;
      Form7.spdNFeDataSets.Campo('CST_N12').AsString := '61';
      Form7.spdNFeDataSets.Campo('vBC_N15').Value   := '0.00'; // Valor da Base de Cálculo do ICMS
      Form7.spdNFeDataSets.Campo('vICMS_N17').Value := '0.00'; // Valor do ICMS em Reais
    end;
    {Sandro Silva 2023-06-13 fim}

  end;
  // Fim SIMPLES NACIONAL

  {Sandro Silva 2023-06-13 inicio}
  // Não é posssível informar CSOSN 61. Para CSOSN 61 será criado no grupo imposto a tag CST
  if (Form7.spdNFeDataSets.Campo('CST_N12').AsString = '61') then
  begin

    sMensagemIcmMonofasicoSobreCombustiveis := 'ICMS monofásico sobre combustíveis cobrado anteriormente conforme Convênio ICMS 199/2022;';

    Form7.spdNFeDataSets.Campo('vBC_N15').Value     := '0.00';  // BC
    Form7.spdNFeDataSets.Campo('vICMS_N17').Value   := '0.00';  // Valor do ICMS em Reais

    Form7.spdNFeDataSets.Campo('qBCMonoRet_N43a').Value  := Form7.spdNFeDataSets.Campo('qCom_I10').Value;
    dqBCMonoRet_N43aTotal := dqBCMonoRet_N43aTotal + XmlValueToFloat(Form7.spdNFeDataSets.Campo('qCom_I10').Value); // Sandro Silva 2023-09-04

    Form7.spdNFeDataSets.Campo('adRemICMSRet_N44').Value := FormatFloatXML(StrToFloatDef(RetornaValorDaTagNoCampo('adRemICMSRet', Form7.ibDataSet4.FieldByname('TAGS_').AsString), 0.00), 4);
    dvICMSMonoRet_N45     := XmlValueToFloat(Form7.spdNFeDataSets.Campo('qBCMonoRet_N43a').AsString) * XmlValueToFloat(Form7.spdNFeDataSets.Campo('adRemICMSRet_N44').AsString);

    Form7.spdNFeDataSets.Campo('vICMSMonoRet_N45').Value := FormatFloatXML(dvICMSMonoRet_N45);

    dvICMSMonoRet_N45Total := dvICMSMonoRet_N45Total + XmlValueToFloat(Form7.spdNFeDataSets.Campo('vICMSMonoRet_N45').Value); // Sandro Silva 2023-09-04

  end;
  {Sandro Silva 2023-06-13 fim}
end;

end.
