Program small22;

{$R 'smallmanifest.res' 'smallmanifest.rc'}

uses
  Forms,
  Windows,
  Messages,
  SysUtils,
  ShellApi,
  MAIS in 'MAIS.PAS' {Form1},
  Mais3 in 'Mais3.pas' {Senhas},
  UNIT2 in 'UNIT2.PAS' {Form2},
  unit7 in 'unit7.pas' {Form7},
  UNIT9 in 'UNIT9.PAS' {Form9},
  UNIT14 in 'UNIT14.PAS' {Form14},
  UNIT12 in 'UNIT12.PAS' {Form12},
  UNIT48 in 'UNIT48.PAS' {Form48},
  Unit16 in 'Unit16.pas' {Form16},
  Unit17 in 'Unit17.pas' {Form17},
  uFrmParcelas in 'uFrmParcelas.pas' {FrmParcelas},
  Unit19 in 'Unit19.pas' {Form19},
  uFrmAssistenteProcura in 'uFrmAssistenteProcura.pas' {FrmAssistenteProcura},
  Unit21 in 'Unit21.pas' {Form21},
  Unit22 in 'Unit22.pas' {Form22},
  Unit25 in 'Unit25.pas' {Form25},
  Unit26 in 'Unit26.pas' {Form26},
  uFrmRelatorioFluxoCaixa in 'uFrmRelatorioFluxoCaixa.pas' {FrmRelatorioFluxoCaixa},
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
  unit24 in 'unit24.pas' {Form24},
  Unit30 in 'Unit30.pas' {Form30},
  Unit40 in 'Unit40.pas' {Form40},
  Unit15 in 'Unit15.pas' {Form15},
  Unit35 in 'Unit35.pas' {Form35},
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
  SMALL_DBEDIT in '..\..\..\componentes\Smallsoft\SMALL_DBEDIT.PAS',
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
  uITestaEmail in '..\..\unit_compartilhada\interfaces\uITestaEmail.pas',
  uTestaEmail in '..\..\unit_compartilhada\uTestaEmail.pas',
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
  uRecursosSistema in '..\..\unit_compartilhada\uRecursosSistema.pas',
  uTypesRecursos in '..\..\unit_compartilhada\uTypesRecursos.pas',
  uConectaBancoCommerce in 'uConectaBancoCommerce.pas',
  uFuncoesBancoDados in '..\..\unit_compartilhada\uFuncoesBancoDados.pas',
  uSmallConsts in '..\..\unit_compartilhada\uSmallConsts.pas',
  uRelatorioVendasClliente in 'units\uRelatorioVendasClliente.pas' {frmRelVendasPorCliente},
  uChamaRelVendasCliente in 'units\uChamaRelVendasCliente.pas',
  uIChamaRelatorioCommerceFactory in 'interfaces\uIChamaRelatorioCommerceFactory.pas',
  uChamaRelatorioCommerceFactory in 'units\uChamaRelatorioCommerceFactory.pas',
  uSmallEnumerados in '..\..\unit_compartilhada\uSmallEnumerados.pas',
  uIAssinaturaDigital in '..\..\unit_compartilhada\interfaces\uIAssinaturaDigital.pas',
  uAssinaturaDigital in '..\..\unit_compartilhada\uAssinaturaDigital.pas',
  uIEstruturaRelVendasPorCliente in 'interfaces\uIEstruturaRelVendasPorCliente.pas',
  uEstruturaRelVendasPorCliente in 'units\uEstruturaRelVendasPorCliente.pas',
  uIEstruturaRelGenerico in 'interfaces\uIEstruturaRelGenerico.pas',
  uEstruturaRelGenerico in 'units\uEstruturaRelGenerico.pas',
  uEstruturaRelVendasPorClienteNota in 'units\uEstruturaRelVendasPorClienteNota.pas',
  uIDadosVendasPorClienteFactory in 'interfaces\uIDadosVendasPorClienteFactory.pas',
  uEstruturaRelVendasPorClienteCupom in 'units\uEstruturaRelVendasPorClienteCupom.pas',
  uIRetornaOperacoesRelatorio in 'interfaces\uIRetornaOperacoesRelatorio.pas',
  uRetornaOperacoesRelatorio in 'units\uRetornaOperacoesRelatorio.pas',
  uFiltrosRodapeRelatorioVendasClienteNota in 'units\uFiltrosRodapeRelatorioVendasClienteNota.pas',
  uFiltrosRodapeRelatorioVendasClienteCupom in 'units\uFiltrosRodapeRelatorioVendasClienteCupom.pas',
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
  smallfunc_xe in '..\..\unit_compartilhada\smallfunc_xe.pas',
  uChamaRelResumoVendas in 'units\uChamaRelResumoVendas.pas',
  uRelatorioResumoVendas in 'units\uRelatorioResumoVendas.pas' {frmRelResumoVendas},
  uEstruturaRelResumoVendas in 'units\uEstruturaRelResumoVendas.pas',
  uFiltrosRodapeRelatorioPadrao in 'units\uFiltrosRodapeRelatorioPadrao.pas',
  uEstruturaRelResumoVendasNaoList in 'units\uEstruturaRelResumoVendasNaoList.pas',
  uIDuplicaProduto in 'interfaces\uIDuplicaProduto.pas',
  uDuplicaProduto in 'units\uDuplicaProduto.pas',
  uIDuplicaOrcamento in 'interfaces\uIDuplicaOrcamento.pas',
  uDuplicaOrcamento in 'units\uDuplicaOrcamento.pas',
  uFrenteSections in '..\..\unit_compartilhada\DAT\uFrenteSections.pas',
  uNFeSections in '..\..\unit_compartilhada\DAT\uNFeSections.pas',
  uNFSeSections in '..\..\unit_compartilhada\DAT\uNFSeSections.pas',
  uSmallComSections in '..\..\unit_compartilhada\uSmallComSections.pas',
  uEstoqueSections in '..\..\unit_compartilhada\DAT\uEstoqueSections.pas',
  uUsuarioSections in '..\..\unit_compartilhada\DAT\uUsuarioSections.pas',
  uFrmProdutosDevolucao in 'uFrmProdutosDevolucao.pas' {FrmProdutosDevolucao},
  uFrmSmallImput in 'uFrmSmallImput.pas' {FrmSmallImput},
  uFrmGridPesquisaPadrao in 'uFrmGridPesquisaPadrao.pas' {FrmGridPesquisaPadrao},
  uImportaOrcamento in 'units\uImportaOrcamento.pas',
  uFrmPesquisaOrcamento in 'uFrmPesquisaOrcamento.pas' {FrmPesquisaOrcamento},
  uGeraCNAB240 in 'units\uGeraCNAB240.pas',
  uGeraCNAB400 in 'units\uGeraCNAB400.pas',
  uDialogs in '..\..\unit_compartilhada\uDialogs.pas',
  uImportaOrdemServico in 'units\uImportaOrdemServico.pas',
  uFrmPesquisaOrdemServico in 'uFrmPesquisaOrdemServico.pas' {FrmPesquisaOrdemServico},
  uFrmConfigEmailAutContabilidade in 'uFrmConfigEmailAutContabilidade.pas' {frmConfigEmailAutContab},
  ufrmOrigemCombustivel in 'ufrmOrigemCombustivel.pas' {FrmOrigemCombustivel},
  MSXML2_TLB in '..\..\unit_compartilhada\MSXML2_TLB.pas',
  uIRetornaSQLGerencialInventario in '..\..\unit_compartilhada\interfaces\uIRetornaSQLGerencialInventario.pas',
  uRetornaSQLGerencialInventario in '..\..\unit_compartilhada\uRetornaSQLGerencialInventario.pas',
  uFrmPrecificacaoProduto in 'uFrmPrecificacaoProduto.pas' {FrmPrecificacaoProduto},
  uParcelasReceber in 'uParcelasReceber.pas',
  uRaterioDiferencaEntreParcelasReceber in 'uRaterioDiferencaEntreParcelasReceber.pas',
  uFrmPerfilTributacao in 'uFrmPerfilTributacao.pas' {FrmPerfilTributacao},
  uFrmNaturezaOperacao in 'uFrmNaturezaOperacao.pas' {FrmNaturezaOperacao},
  uFrmSituacaoOS in 'uFrmSituacaoOS.pas' {FrmSituacaoOS},
  uOrdemServico in 'units\uOrdemServico.pas',
  uFuncaoMD5 in '..\..\unit_compartilhada\uFuncaoMD5.pas',
  uFrmAnexosOS in 'uFrmAnexosOS.pas' {FrmAnexosOS},
  uRelatorioTotalGeralVenda in 'units\uRelatorioTotalGeralVenda.pas' {frmRelTotalizadorGeralVenda},
  uIGeraRelatorioTotalizadorGeralVenda in 'interfaces\uIGeraRelatorioTotalizadorGeralVenda.pas',
  uGeraRelatorioTotalizadorGeralVenda in 'units\uGeraRelatorioTotalizadorGeralVenda.pas',
  uChamaRelTotalizadorVendasGeral in 'units\uChamaRelTotalizadorVendasGeral.pas',
  uEstruturaRelTotalizadorGeralVenda in 'units\uEstruturaRelTotalizadorGeralVenda.pas',
  uEstruturaRelVendasNotaFiscal in 'units\uEstruturaRelVendasNotaFiscal.pas',
  uRelatorioVendasNotaFiscal in 'units\uRelatorioVendasNotaFiscal.pas' {frmRelVendasNotaFiscal},
  udmRelTotalizadorVendasGeral in 'units\udmRelTotalizadorVendasGeral.pas' {dmRelTotalizadorVendasGeral: TDataModule},
  uLogSistema in '..\..\unit_compartilhada\uLogSistema.pas',
  uDrawCellGridModulos in 'units\uDrawCellGridModulos.pas',
  uEmail in '..\..\unit_compartilhada\uEmail.pas',
  uDesenhaBoleto in 'units\uDesenhaBoleto.pas',
  ufrmRelatorioProdMonofasicoCupom in 'ufrmRelatorioProdMonofasicoCupom.pas' {frmRelProdMonofasicoCupom},
  uIGeraRelatorioProdMonofasico in 'interfaces\uIGeraRelatorioProdMonofasico.pas',
  uGeraRelatorioProdMonofasicoCupom in 'units\uGeraRelatorioProdMonofasicoCupom.pas',
  uEstruturaRelProdMonofasicoCupom in 'units\uEstruturaRelProdMonofasicoCupom.pas',
  udmRelProdMonofasicoCupom in 'units\udmRelProdMonofasicoCupom.pas' {dmRelProdMonofasicoCupom: TDataModule},
  ufrmRelatorioProdMonofasicoNota in 'ufrmRelatorioProdMonofasicoNota.pas' {frmRelProdMonofasicoNota},
  uGeraRelatorioProdMonofasicoNota in 'units\uGeraRelatorioProdMonofasicoNota.pas',
  udmRelProdMonofasicoNota in 'units\udmRelProdMonofasicoNota.pas' {dmRelProdMonofasicoNota: TDataModule},
  uEstruturaRelProdMonofasicoNota in 'units\uEstruturaRelProdMonofasicoNota.pas',
  uIGeraRelatorioProdMonofasicoCupomNota in 'interfaces\uIGeraRelatorioProdMonofasicoCupomNota.pas',
  uGeraRelatorioProdMonofasicoCupomNota in 'units\uGeraRelatorioProdMonofasicoCupomNota.pas',
  uSistema in 'units\uSistema.pas',
  uObjetoConsultaCEP in 'units\uObjetoConsultaCEP.pas',
  uIConsultaCEP in 'interfaces\uIConsultaCEP.pas',
  uConsultaCEP in 'units\uConsultaCEP.pas',
  uFrmConversaoCFOP in 'uFrmConversaoCFOP.pas' {FrmConversaoCFOP},
  uConfiguracaoTEFCommerce in 'uConfiguracaoTEFCommerce.pas' {frmConfiguracaoTEFCommerce},
  uFuncoesTEF in 'units\uFuncoesTEF.pas',
  uclassetransacaocartao in '..\..\unit_compartilhada\uclassetransacaocartao.pas',
  uSelecionaTEF in 'uSelecionaTEF.pas' {frmSelecionaTEF},
  uframeConfiguraTEF in 'frames\uframeConfiguraTEF.pas' {frameConfiguraTEF: TFrame},
  uValidaRecursos in '..\..\unit_compartilhada\uValidaRecursos.pas',
  uIDuplicaNFSe in 'interfaces\uIDuplicaNFSe.pas',
  uDuplicaNFSe in 'units\uDuplicaNFSe.pas',
  uFrmConvenio in 'uFrmConvenio.pas' {FrmConvenio},
  uFrmCaixa in 'uFrmCaixa.pas' {FrmCaixa},
  uFrmGrupoMercadoria in 'uFrmGrupoMercadoria.pas' {FrmGrupoMercadoria},
  uFrmTransportadora in 'uFrmTransportadora.pas' {FrmTransportadora},
  uFrmPlanoContas in 'uFrmPlanoContas.pas' {FrmPlanoContas},
  uFrmBanco in 'uFrmBanco.pas' {FrmBanco},
  uFrmContaBancaria in 'uFrmContaBancaria.pas' {FrmContaBancaria},
  uFrmContaReceber in 'uFrmContaReceber.pas' {FrmContaReceber},
  uFrmContaPagar in 'uFrmContaPagar.pas' {FrmContaPagar},
  uFrmIntegracaoItau in 'uFrmIntegracaoItau.pas' {FrmIntegracaoItau},
  uFrmIntegracaoSicoob in 'uFrmIntegracaoSicoob.pas' {FrmIntegracaoSicoob},
  uMobile in 'units\uMobile.pas',
  uPermissaoUsuario in 'uPermissaoUsuario.pas',
  uFrmCadastro in 'uFrmCadastro.pas' {FrmCadastro},
  uImprimeNaImpressoraDoWindows in '..\..\unit_compartilhada\uImprimeNaImpressoraDoWindows.pas',
  uFrmTecnico in 'uFrmTecnico.pas' {FrmTecnico},
  uTypesImpressao in '..\..\unit_compartilhada\uTypesImpressao.pas',
  uIntegracaoItau in '..\..\unit_compartilhada\Itau\uIntegracaoItau.pas',
  uClassesItau in '..\..\unit_compartilhada\Itau\uClassesItau.pas',
  uWebServiceItau in '..\..\unit_compartilhada\Itau\uWebServiceItau.pas',
  uFrmTelaProcessamento in '..\..\unit_compartilhada\uFrmTelaProcessamento.pas' {FrmTelaProcessamento},
  uFrmEstoque in 'uFrmEstoque.pas' {FrmEstoque},
  uFrmMsgNovoLayout in 'uFrmMsgNovoLayout.pas' {FrmMsgNovoLayout},
  ufrmRelatorioNotasFaltantes in 'units\ufrmRelatorioNotasFaltantes.pas' {frmRelatorioNotasFaltantes},
  uEstruturaRelNotasFaltantes in 'units\uEstruturaRelNotasFaltantes.pas',
  uChaveCertificado in '..\..\unit_compartilhada\uChaveCertificado.pas',
  uIntegracaoSicoob in '..\..\unit_compartilhada\Sicoob\uIntegracaoSicoob.pas',
  uWebServiceSicoob in '..\..\unit_compartilhada\Sicoob\uWebServiceSicoob.pas',
  uClassesSicoob in '..\..\unit_compartilhada\Sicoob\uClassesSicoob.pas',
  uFrmEstoqueIVA in 'uFrmEstoqueIVA.pas' {FrmEstoqueIVA},
  uIRetornaCustoMedio in 'interfaces\uIRetornaCustoMedio.pas',
  uRetornaCustoMedio in 'units\uRetornaCustoMedio.pas',
  ufrmInformarDrawback in 'ufrmInformarDrawback.pas' {frmInformarDrawback},
  ufrmInformacoesExportacaoNFe in 'ufrmInformacoesExportacaoNFe.pas' {frmInformacoesExportacaoNFe},
  ufrmInformacoesImportacaoNFe in 'ufrmInformacoesImportacaoNFe.pas' {frmInformacoesImportacaoNFe},
  uFrmIntegracaoIMendes in 'uFrmIntegracaoIMendes.pas' {FrmIntegracaoIMendes},
  uClassesIMendes in 'units\uClassesIMendes.pas',
  uIMendesSections in '..\..\unit_compartilhada\DAT\uIMendesSections.pas',
  uFrmSaneamentoIMendes in 'uFrmSaneamentoIMendes.pas' {FrmSaneamentoIMendes},
  uEstruturaRelRankingProdutosVendidos in 'units\uEstruturaRelRankingProdutosVendidos.pas',
  ufrmRelatorioMovItensPeriodo in 'units\ufrmRelatorioMovItensPeriodo.pas' {frmRelatorioMovItensPeriodo},
  uWebServiceIMendes in 'units\uWebServiceIMendes.pas',
  uFrmProdutosIMendes in 'uFrmProdutosIMendes.pas' {FrmProdutosIMendes},
  uFrenteSectionsBD in '..\..\unit_compartilhada\DAT\uFrenteSectionsBD.pas',
  uImendes in 'units\uImendes.pas',
  uCalculaImpostos in 'uCalculaImpostos.pas',
  uListaToJson in '..\..\unit_compartilhada\DAT\uListaToJson.pas',
  uDashboardSections in '..\..\unit_compartilhada\DAT\uDashboardSections.pas',
  uDashboard in 'units\uDashboard.pas',
  uFrmDashboard in 'uFrmDashboard.pas' {FrmDashboard},
  uClassesDadosDash in 'units\uClassesDadosDash.pas',
  uClassesDashboard in 'units\uClassesDashboard.pas',
  uDiagnosticoIA in 'units\uDiagnosticoIA.pas',
  uAtorInteressado in 'uAtorInteressado.pas' {fmAtorInteressado},
  uWebServiceSmall in 'units\uWebServiceSmall.pas',
  uTransferConfigIniToDB in 'uTransferConfigIniToDB.pas',
  uMinhasNotas in '..\..\unit_compartilhada\MinhasNotas\uMinhasNotas.pas',
  uWebServiceMinhasNotas in '..\..\unit_compartilhada\MinhasNotas\uWebServiceMinhasNotas.pas',
  uSmallZip in '..\..\unit_compartilhada\uSmallZip.pas';

{$R *.RES}

var
  oHwnd: THandle;
  // Procura no Caption se contem o Texto.
  function FindWindowCaptionParcial(AcTextoProcurar: string): THandle;
  var
    oHwnd: THandle;
    nLength: Integer;
    cTitletemp: array [0..254] of Char;
    cTituloTemporario: string;
  begin
    Result := 0;

    oHwnd := FindWindow('TForm1', nil);
    while oHwnd <> 0 do begin
      nLength := GetWindowText(oHwnd, cTitletemp, 255);
      cTituloTemporario := cTitletemp;
      cTituloTemporario := AnsiUpperCase(Copy(cTituloTemporario, 1, nLength));
      AcTextoProcurar := AnsiUpperCase(AcTextoProcurar);
      if Pos(AcTextoProcurar, cTituloTemporario) <> 0 then
      begin
        Result := oHwnd;
        Break;
      end;
      oHwnd := GetWindow(oHwnd, GW_HWNDNEXT);
    end;
  end;
begin
  {$IFDEF DEBUG}
  //ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  //Mauricio Parizotto 2024-08-08
  Application.HintHidePause := 6000;

  oHwnd := FindWindowCaptionParcial('Small Commerce - [ ');

  if oHwnd = 0 then
  begin
    oHwnd := FindWindowCaptionParcial('Small Start - [ ');
  end;

  if oHwnd = 0 then
  begin
    oHwnd := FindWindowCaptionParcial('Small Mei - [ ');
  end;

  if oHwnd = 0 then
  begin
    oHwnd := FindWindowCaptionParcial('Small Go - [ ');
  end;

  try
    if oHwnd = 0 then
    begin
      Form22 := TForm22.Create(Application);
      Form22.Show;
      Form22.Update;

      Application.Title := 'Small Commerce';
      Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TSenhas, Senhas);
  Application.CreateForm(TForm24, Form24);
  Application.CreateForm(TForm30, Form30);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm9, Form9);
  Application.CreateForm(TForm14, Form14);
  Application.CreateForm(TForm19, Form19);
  Application.CreateForm(TForm12, Form12);
  Application.CreateForm(TForm48, Form48);
  Application.CreateForm(TForm16, Form16);
  Application.CreateForm(TFrmAssistenteProcura, FrmAssistenteProcura);
  Application.CreateForm(TForm21, Form21);
  Application.CreateForm(TForm25, Form25);
  Application.CreateForm(TForm26, Form26);
  Application.CreateForm(TFrmRelatorioFluxoCaixa, FrmRelatorioFluxoCaixa);
  Application.CreateForm(TForm31, Form31);
  Application.CreateForm(TForm38, Form38);
  Application.CreateForm(TForm39, Form39);
  Application.CreateForm(TForm41, Form41);
  Application.CreateForm(TForm43, Form43);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm13, Form13);
  Application.CreateForm(TForm40, Form40);
  Application.CreateForm(TForm15, Form15);
  Application.CreateForm(TForm35, Form35);
  Application.CreateForm(TfrmSelectCertificate, frmSelectCertificate);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm11, Form11);
  Application.CreateForm(TForm36, Form36);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm29, Form29);
  Application.CreateForm(TForm45, Form45);
  Application.CreateForm(TForm37, Form37);
  Application.CreateForm(TFrmOrigemCombustivel, FrmOrigemCombustivel);
  Application.Run;
    end else
    begin
      if not IsWindowVisible(oHwnd) then PostMessage(oHwnd, wm_User,0,0);
      SetForegroundWindow(oHwnd);
    end;
  except
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
    Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
    Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
    FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
  end;
end.
