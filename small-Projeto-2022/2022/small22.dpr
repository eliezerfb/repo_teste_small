Program small22;

{$R 'smallmanifest.res' 'smallmanifest.rc'}

uses
  Forms,
  Windows,
  Messages,
  SysUtils,
  ShellApi,
  Mais in 'MAIS.PAS' {Form1},
  Mais3 in 'MAIS3.PAS' {Senhas},
  Unit2 in 'UNIT2.PAS' {Form2},
  Unit7 in 'unit7.pas' {Form7},
  Unit9 in 'UNIT9.PAS' {Form9},
  Unit14 in 'UNIT14.PAS' {Form14},
  Unit12 in 'UNIT12.PAS' {Form12},
  Unit48 in 'UNIT48.PAS' {Form48},
  Unit10 in 'Unit10.pas' {Form10},
  Unit16 in 'Unit16.pas' {Form16},
  Unit17 in 'Unit17.pas' {Form17},
  Unit99 in 'unit99.pas' {Form99},
  Unit18 in 'Unit18.pas' {Form18},
  Unit19 in 'Unit19.pas' {Form19},
  Unit20 in 'Unit20.pas' {Form20},
  Unit21 in 'Unit21.pas' {Form21},
  Unit22 in 'Unit22.pas' {Form22},
  Unit25 in 'Unit25.pas' {Form25},
  Unit26 in 'Unit26.pas' {Form26},
  Unit27 in 'Unit27.pas' {Form27},
  Unit31 in 'Unit31.pas' {Form31},
  Unit32 in 'Unit32.pas' {Form32},
  Unit33 in 'Unit33.pas' {Form33},
  Unit34 in 'Unit34.pas' {Form34},
  Unit37 in 'Unit37.pas' {Form37},
  Unit38 in 'Unit38.pas' {Form38},
  Unit39 in 'Unit39.pas' {Form39},
  Unit41 in 'Unit41.pas' {Form41},
  Unit43 in 'Unit43.pas' {Form43},
  Unit4 in 'Unit4.pas' {Form4},
  Unit13 in 'Unit13.pas' {Form13},
  Unit3 in 'UNIT3.PAS' {Senhas2},
  Unit24 in 'unit24.pas' {Form24},
  Unit30 in 'Unit30.pas' {Form30},
  Unit40 in 'Unit40.pas' {Form40},
  Unit15 in 'Unit15.pas' {Form15},
  Unit35 in 'Unit35.pas' {Form35},
  Unit8 in 'Unit8.pas' {Form8},
  uExportaXML in 'uExportaXML.pas' {frmExportaXML},
  SelecionaCertificado in 'SelecionaCertificado.pas' {frmSelectCertificate},
  Unit23 in 'Unit23.pas' {Form23},
  Unit6 in 'Unit6.pas' {Form6},
  Unit11 in 'Unit11.pas' {Form11},
  Unit36 in 'Unit36.pas' {Form36},
  Unit5 in 'Unit5.pas' {Form5},
  Unit29 in 'Unit29.pas' {Form29},
  Unit45 in 'Unit45.pas' {Form45},
  ugeraxmlnfe in 'ugeraxmlnfe.pas',
  uFrmInformacoesRastreamento in 'uFrmInformacoesRastreamento.pas' {FrmInformacoesRastreamento},
  uFuncoesRetaguarda in 'uFuncoesRetaguarda.pas',
  uconstantes_chaves_privadas in '..\..\..\uconstantes_chaves_privadas.pas',
  uRateioVendasBalcao in 'uRateioVendasBalcao.pas',
  uAtualizaNovoCampoItens001CSOSN in 'uAtualizaNovoCampoItens001CSOSN.pas',
  uSmallNFeUtils in 'uSmallNFeUtils.pas',
  SMALL_DBEdit in '..\..\..\componentes\Smallsoft\SMALL_DBEDIT.PAS',
  ucredencialtecnospeed in '..\..\..\componentes\Smallsoft\ucredencialtecnospeed.pas',
  uListaCnaes in 'uListaCnaes.pas',
  uGeraXmlNFeEntrada in 'uGeraXmlNFeEntrada.pas',
  uGeraXmlNFeSaida in 'uGeraXmlNFeSaida.pas',
  uAtualizaBancoDados in 'uAtualizaBancoDados.pas',
  uFuncoesFiscais in 'uFuncoesFiscais.pas',
  uTransmiteNFSe in 'uTransmiteNFSe.pas',
  uClientesFornecedores in 'uClientesFornecedores.pas',
  uFazerBackup in '..\..\unit_compartilhada\uFazerBackup.pas',
  uNotaFiscalEletronica in 'uNotaFiscalEletronica.pas',
  uNotaFiscalEletronicaCalc in 'uNotaFiscalEletronicaCalc.pas',
  uImportaNFe in 'uImportaNFe.pas',
  uIRetornaBuildEXE in 'interfaces\uIRetornaBuildEXE.pas',
  uRetornaBuildEXE in 'units\uRetornaBuildEXE.pas',
  uIRetornaEmailsPessoa in 'interfaces\uIRetornaEmailsPessoa.pas',
  uRetornaEmailsPessoa in 'units\uRetornaEmailsPessoa.pas',
  uIRetornaCaptionEmailPopUpDocs in 'interfaces\uIRetornaCaptionEmailPopUpDocs.pas',
  uRetornaCaptionEmailPopUpDocs in 'units\uRetornaCaptionEmailPopUpDocs.pas',
  uITestaEmail in 'interfaces\uITestaEmail.pas',
  uTestaEmail in 'units\uTestaEmail.pas',
  uIItensInativosImpXMLEntrada in 'interfaces\uIItensInativosImpXMLEntrada.pas',
  uItensInativosImpXMLEntrada in 'units\uItensInativosImpXMLEntrada.pas',
  uframePesquisaPadrao in 'frames\uframePesquisaPadrao.pas' {framePesquisaPadrao: TFrame},
  uframePesquisaProduto in 'frames\uframePesquisaProduto.pas' {framePesquisaProduto: TFrame},
  uframeCampo in 'frames\uframeCampo.pas' {fFrameCampo: TFrame},
  uITestaProdutoExiste in 'interfaces\uITestaProdutoExiste.pas',
  uFrmTermosUso in 'uFrmTermosUso.pas' {FrmTermosUso},
  uTestaProdutoExiste in 'units\uTestaProdutoExiste.pas',
  uCriptografia in '..\..\unit_compartilhada\uCriptografia.pas',
  uITextoEmail in 'interfaces\uITextoEmail.pas',
  uTextoEmailNFe in 'units\uTextoEmailNFe.pas',
  uITextoEmailFactory in 'interfaces\uITextoEmailFactory.pas',
  uTextoEmailFactory in 'units\uTextoEmailFactory.pas',
  uTextoEmailCCe in 'units\uTextoEmailCCe.pas',
  uSmallResourceString in '..\..\unit_compartilhada\uSmallResourceString.pas',
  uITestaClienteDevendo in 'interfaces\uITestaClienteDevendo.pas',
  uTestaClienteDevendo in 'units\uTestaClienteDevendo.pas',
  uIRetornaLimiteDisponivel in 'interfaces\uIRetornaLimiteDisponivel.pas',
  uRetornaLimiteDisponivel in 'units\uRetornaLimiteDisponivel.pas',
  uValidaRecursosDelphi7 in '..\..\unit_compartilhada\uValidaRecursosDelphi7.pas',
  uRecursosSistema in '..\..\unit_compartilhada\uRecursosSistema.pas',
  uTypesRecursos in '..\..\unit_compartilhada\uTypesRecursos.pas',
  uConectaBancoCommerce in 'uConectaBancoCommerce.pas',
  uFuncoesBancoDados in 'uFuncoesBancoDados.pas',
  uSmallConsts in '..\..\unit_compartilhada\uSmallConsts.pas',
  uRelatorioVendasClliente in 'units\uRelatorioVendasClliente.pas' {frmRelVendasPorCliente},
  uChamaRelVendasCliente in 'units\uChamaRelVendasCliente.pas',
  uIChamaRelatorioCommerceFactory in 'interfaces\uIChamaRelatorioCommerceFactory.pas',
  uChamaRelatorioCommerceFactory in 'units\uChamaRelatorioCommerceFactory.pas',
  uSmallEnumerados in '..\..\unit_compartilhada\uSmallEnumerados.pas',
  uArquivosDAT in '..\..\unit_compartilhada\uArquivosDAT.pas',
  uArquivoDATINFPadrao in '..\..\unit_compartilhada\uArquivoDATINFPadrao.pas',
  uEstoqueDAT in '..\..\unit_compartilhada\uEstoqueDAT.pas',
  uFrenteINI in '..\..\unit_compartilhada\uFrenteINI.pas',
  uSectionDATPadrao in '..\..\unit_compartilhada\uSectionDATPadrao.pas',
  uSectionFrentedeCaixaINI in '..\..\unit_compartilhada\uSectionFrentedeCaixaINI.pas',
  uSectionGeralDAT in '..\..\unit_compartilhada\uSectionGeralDAT.pas',
  uSectionGeralUsuarioINF in '..\..\unit_compartilhada\uSectionGeralUsuarioINF.pas',
  uSmallComINF in '..\..\unit_compartilhada\uSmallComINF.pas',
  uUsuarioINF in '..\..\unit_compartilhada\uUsuarioINF.pas',
  uSectionHTMLUsuarioINF in '..\..\unit_compartilhada\uSectionHTMLUsuarioINF.pas',
  uIAssinaturaDigital in '..\..\unit_compartilhada\interfaces\uIAssinaturaDigital.pas',
  uAssinaturaDigital in '..\..\unit_compartilhada\uAssinaturaDigital.pas',
  uIEstruturaRelVendasPorCliente in 'interfaces\uIEstruturaRelVendasPorCliente.pas',
  uEstruturaRelVendasPorCliente in 'units\uEstruturaRelVendasPorCliente.pas',
  uEstruturaRelVendasPorClienteNota in 'units\uEstruturaRelVendasPorClienteNota.pas',
  uIDadosVendasPorClienteFactory in 'interfaces\uIDadosVendasPorClienteFactory.pas',
  uEstruturaRelVendasPorClienteCupom in 'units\uEstruturaRelVendasPorClienteCupom.pas',
  uIRetornaOperacoesRelatorio in 'interfaces\uIRetornaOperacoesRelatorio.pas',
  uRetornaOperacoesRelatorio in 'units\uRetornaOperacoesRelatorio.pas',
  uFiltrosRodapeRelatorioVendasClienteNota in 'units\uFiltrosRodapeRelatorioVendasClienteNota.pas',
  uFiltrosRodapeRelatorioVendasClienteCupom in 'units\uFiltrosRodapeRelatorioVendasClienteCupom.pas',
  uSectionOutrosUsuarioINF in '..\..\unit_compartilhada\uSectionOutrosUsuarioINF.pas',
  uNFeINI in '..\..\unit_compartilhada\uNFeINI.pas',
  uSectionsNFeINI in '..\..\unit_compartilhada\uSectionsNFeINI.pas',
  uNFSeINI in '..\..\unit_compartilhada\uNFSeINI.pas',
  uSectionsNFSeINI in '..\..\unit_compartilhada\uSectionsNFSeINI.pas',
  uRelatorioCatalogoProdudos in 'units\uRelatorioCatalogoProdudos.pas' {frmRelatorioCatalogoProduto},
  uEstruturaRelCatalogoProdutos in 'units\uEstruturaRelCatalogoProdutos.pas',
  uFiltrosRodapeRelatorioCatalogoProdutos in 'units\uFiltrosRodapeRelatorioCatalogoProdutos.pas',
  uLayoutHTMLRelatorio in 'units\uLayoutHTMLRelatorio.pas',
  uIChamaRelatorioPadrao in 'interfaces\uIChamaRelatorioPadrao.pas',
  uIEstruturaTipoRelatorioPadrao in 'interfaces\uIEstruturaTipoRelatorioPadrao.pas',
  uDadosEmitente in 'units\uDadosEmitente.pas',
  uDadosRelatorioPadraoDAO in 'units\uDadosRelatorioPadraoDAO.pas',
  uEstruturaTipoRelatorioPadrao in 'units\uEstruturaTipoRelatorioPadrao.pas',
  uFormRelatorioPadrao in 'units\uFormRelatorioPadrao.pas' {frmRelatorioPadrao},
  uIEstruturaRelatorioPadrao in 'interfaces\uIEstruturaRelatorioPadrao.pas',
  uIDadosImpressaoDAO in 'interfaces\uIDadosImpressaoDAO.pas',
  uIFiltrosRodapeRelatorio in 'interfaces\uIFiltrosRodapeRelatorio.pas',
  uIDadosEmitente in 'interfaces\uIDadosEmitente.pas',
  uParametroTributacao in 'uParametroTributacao.pas',
  uframePesquisaServico in 'frames\uframePesquisaServico.pas' {framePesquisaServico: TFrame},
  uAtualizaTributacaoPerfilTrib in 'uAtualizaTributacaoPerfilTrib.pas',
  uSectionsSmallComINF in '..\..\unit_compartilhada\uSectionsSmallComINF.pas',
  uFrmPadrao in 'uFrmPadrao.pas' {FrmPadrao},
  uFrmFichaPadrao in 'uFrmFichaPadrao.pas' {FrmFichaPadrao},
  uIconesSistema in 'uIconesSistema.pas',
  uFrmParametroTributacao in 'uFrmParametroTributacao.pas' {FrmParametroTributacao},
  uVisualizaCadastro in 'units\uVisualizaCadastro.pas',
  uIImpressaoOrcamento in '..\..\unit_compartilhada\interfaces\uIImpressaoOrcamento.pas',
  uIRetornaImpressaoOrcamento in '..\..\unit_compartilhada\interfaces\uIRetornaImpressaoOrcamento.pas',
  uImpressaoOrcamento in '..\..\unit_compartilhada\uImpressaoOrcamento.pas',
  uRetornaImpressaoOrcamento in '..\..\unit_compartilhada\uRetornaImpressaoOrcamento.pas',
  uConectaBancoSmall in '..\..\unit_compartilhada\uConectaBancoSmall.pas',
  uTextoEmailOrcamento in 'units\uTextoEmailOrcamento.pas',
  uConverteHtmlToPDF in '..\..\unit_compartilhada\uConverteHtmlToPDF.pas',
  uSalvaXMLContabilFactory in 'units\uSalvaXMLContabilFactory.pas',
  uSalvaXMLContabilNFeSaida in 'units\uSalvaXMLContabilNFeSaida.pas',
  uSalvaXMLContabilNFeEntrada in 'units\uSalvaXMLContabilNFeEntrada.pas',
  uSalvaXMLContabilNFCeSAT in '..\..\unit_compartilhada\uSalvaXMLContabilNFCeSAT.pas',
  uISalvaXMLDocsEletronicosContabil in '..\..\unit_compartilhada\interfaces\uISalvaXMLDocsEletronicosContabil.pas',
  uISalvaXMLContabilFactory in 'interfaces\uISalvaXMLContabilFactory.pas',
  smallfunc_xe in '..\..\unit_compartilhada\smallfunc_xe.pas';

{$R *.RES}

var
  Hwnd: THandle;
begin
  Hwnd := FindWindow('TForm1', 'Small Commerce');

  if Hwnd = 0 then
  begin
    Hwnd := FindWindow('TForm1', 'Small Start');
  end;

  if Hwnd = 0 then
  begin
    Hwnd := FindWindow('TForm1', 'Small Mei');
  end;

  if Hwnd = 0 then
  begin
    Hwnd := FindWindow('TForm1', 'Small Go');
  end;

  try
    if Hwnd = 0 then
    begin
      Form22 := TForm22.Create(Application);
      Form22.Show;
      Form22.Update;

      Application.Title := 'Small Commerce';

      Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TSenhas, Senhas);
  Application.CreateForm(TSenhas2, Senhas2);
  Application.CreateForm(TForm24, Form24);
  Application.CreateForm(TForm30, Form30);
  Application.CreateForm(TSenhas2, Senhas2);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm9, Form9);
  Application.CreateForm(TForm14, Form14);
  Application.CreateForm(TForm19, Form19);
  Application.CreateForm(TForm12, Form12);
  Application.CreateForm(TForm48, Form48);
  Application.CreateForm(TForm10, Form10);
  Application.CreateForm(TForm16, Form16);
  Application.CreateForm(TForm99, Form99);
  Application.CreateForm(TForm18, Form18);
  Application.CreateForm(TForm20, Form20);
  Application.CreateForm(TForm21, Form21);
  Application.CreateForm(TForm25, Form25);
  Application.CreateForm(TForm26, Form26);
  Application.CreateForm(TForm27, Form27);
  Application.CreateForm(TForm31, Form31);
  Application.CreateForm(TForm32, Form32);
  Application.CreateForm(TForm38, Form38);
  Application.CreateForm(TForm39, Form39);
  Application.CreateForm(TForm41, Form41);
  Application.CreateForm(TForm43, Form43);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm13, Form13);
  Application.CreateForm(TForm40, Form40);
  Application.CreateForm(TForm15, Form15);
  Application.CreateForm(TForm35, Form35);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TfrmSelectCertificate, frmSelectCertificate);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm11, Form11);
  Application.CreateForm(TForm36, Form36);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm29, Form29);
  Application.CreateForm(TForm45, Form45);
  Application.CreateForm(TForm37, Form37);
  Application.Run;
    end else
    begin
      if not IsWindowVisible(Hwnd) then PostMessage(Hwnd, wm_User,0,0);
      SetForegroundWindow(Hwnd);
    end;
  except
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
  end;
end.
