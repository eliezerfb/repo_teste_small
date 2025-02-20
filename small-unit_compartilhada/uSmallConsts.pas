unit uSmallConsts;

interface

const
  _cSenhaSair = '#####';
  _cUsuarioAdmin = 'Administrador';
  _cRecebPagto = 'Caixa';

  _cSim = 'Sim';
  _cNao = 'Não';
  _cOKUpper  = 'OK';
  _cOkCamel  = 'Ok';
  _cMedidaKU = 'KU';
  _cMedidaKG = 'KG';

  _cAmbienteHomologacao = 'Homologacao';
  _cAmbienteProducao = 'Producao';  

  //Incrementar a cada alteração do termo
  _cVersaoTermoUso = 2; // Sandro Silva 2023-09-11 _cVersaoTermoUso = 1;

  // SECTION Geral (EST0QUE.DAT)
  _cSectionGeral          = 'Geral';
  _cIdentGeralRede        = 'Rede';
  _cIdentGeralBuild       = 'Build';
  _cIdentGeralBuild2020   = _cIdentGeralBuild + ' 2020';
  _cIdentGeralBuild2023   = _cIdentGeralBuild + ' 2023';

  // SECTION USO (smallcom.inf)
  _cSectionUso = 'Uso';
  _cIdentUso   = 'Uso';

  // SECTION USUARIO ({USUARIO}.INF)
  _cSectionGeralUsuario           = 'GERAL';
  _cSectionHtml                   = 'Html';  
  _cSectionOutros                 = 'Outros';
  _cIdentGeralUsuMarketPlaceAtivo = 'MARKETPLACE ATIVO';
  _cIdentGeralUsuMobileAtivo      = 'MOBILE ATIVO';
  _cIdentHtmlHtml1        = _cSectionHtml+'1';
  _cIdentHtmlCor          = 'Cor';
  _cIdentPeriodoInicial   = 'Período Inicial';
  _cIdentPeriodoFinal     = 'Período Final';
  
  //SECTION Frente de Caixa (FRENTE.INI)
  _cSectionFrenteCaixa = 'Frente de Caixa';
  _cIdentFrenteCaixaTipoEtiqueta = 'Tipo etiqueta';

  //SECTION NFE (NFe.ini)
  _cSectionNFE = 'NFE';
  _cIdentNFEAmbiente = 'Ambiente';

  //SECTION NFE (NFSe.ini)
  _cSectionNFSE = 'NFSE';
  _cIdentNFSEAmbiente = 'Ambiente';

  _cPrivateKeyExponent = '75C2624A448186B59016FE623' +
                         'EF23ED97137C8D5F273C15EE813D2AEFD322C2AFBF868ADBB5096A78CD' +
                         'EA9D678CA9370EE0C79FAD21FEC0ECE440149D09367077B46A33F829B3' +
                         '28CAFF49F0B884AA672F9F65D632F44A492D4E92D9B33526CB8DD84416' +
                         '9240235E8F49F74C8CD1B4626A423009FC777935B091CB751895E5F6A';
  _cPrivateKeyModulus = '656B072B31EF964B1C3D31F8BC' +
                        '9BD945E7A675307DEB790B748B1197B0DFC4E4D1064ECCD625C3248970'+
                        'E4F29FC6D8F0D0385A53A9A3E7DB20C258C982CFC47B798E54EE655D55'+
                        '92269559B8DDB864E57D46ECFBFE594A572C0C9E3DA8DD2BDEBE63BDD2'+
                        '9583C66553B3969F73602CF3CAC29C78A6F3DC491507AD2C4F818077';

implementation

end.
