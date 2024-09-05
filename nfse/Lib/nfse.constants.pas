unit nfse.constants;

interface

const
  ENDPOINT_PING_HOM = 'http://192.168.212.75/rpc/v1/consumers.ping';
  ENDPOINT_PING_PROD = 'http://webserver/rpc/v1/consumers.ping';

  CONS_SEARCHSITUATION = 'search-situation';
  CONS_SEARCHBATCH = 'search-batch';
  CONS_SEARCHNFSERPS = 'search-nfserps';
  CONS_SEND = 'send';
  CONS_CANCEL = 'cancel';
  CONS_STATUS = 'ping';

  ENDPOINT_ENVIA_XML = 'http://webserver/rpc/v1/consumers.send-nfse-xml';
  ENDPOINT_SEARCH = 'http://webserver/rpc/v1/consumers.consult-nfse-queue';
  ENDPOINT_CANCEL = 'http://webserver/rpc/v1/consumers.cancel-nfse-queue';
  ENDPOINT_SEND = 'http://webserver/rpc/v1/consumers.post-transmission-nfse-queue';

  NOME_XMLCON_SIT = '-con-sit.xml';
  NOME_XMLCON_SIT_SOAP = '-con-sit-soap.xml';
  NOME_XMLCON_LOT = '-con-lot-soap.xml';
  NOME_XMLCON_LOT_SOAP = '-con-lot-soap.xml';
  NOME_XMLCON_LISTA_NFSE_CON_LOT_SOAP = '-lista_nfse_con_lot_soap.xml';
  NOME_XML_ON_LISTA_NFSE_CON_LOT = '-lista_nfse_con_lot.xml';

  METODO_AUTOMATICO = 0;
  METODO_LOTEASSINCRONO = 1;
  METODO_LOTESINCRONO = 2;
  METODO_UNITARIO = 3;
  METODO_TESTE = 4;

  {$IFDEF MSWINDOWS}
  INI_CONFIG_FILE = 'c:\clipp360-nfse-bin.ini';
  {$ENDIF}
  {$IFDEF LINUX}
  INI_CONFIG_FILE = '/home/clipp360-nfse-bin.ini';
  {$ENDIF}
  INI_PATH_SCHEMAS = 'PATH_SCHEMAS';
  INI_ARQUIVO_PFX = 'ARQUIVO_PFX';
  INI_ENDPOINT_ENVIA_XML_TEST = 'ENDPOINT_ENVIA_XML_TEST';
  INI_ENDPOINT_SEARCH_TEST = 'ENDPOINT_SEARCH_TEST';
  INI_ENDPOINT_CANCEL_TEST = 'ENDPOINT_CANCEL_TEST';
  INI_ENDPOINT_SEND_TEST = 'ENDPOINT_SEND_TEST';

implementation

end.
