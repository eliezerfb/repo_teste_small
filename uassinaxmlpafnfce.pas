unit uassinaxmlpafnfce;

interface

uses
  CAPICOM_TLB
  , MSXML2_TLB
  , ActiveX
  , StrUtils
  , SysUtils
  , ComObj
  , ufuncoesfrente
  ;

const PAF_NFC_E_ESPECIFICACAO_XML                    = '<?xml version="1.0" encoding="utf-8" ?>';

function AssinarMSXMLPafNfce(XML: String; sCNPJ: String;
  Certificado: ICertificate2; URI: String): String;

implementation

function AssinarMSXMLPafNfce(XML: String; sCNPJ: String;
  Certificado: ICertificate2; URI: String): String;
const
  DSIGNS = 'xmlns:ds="http://www.w3.org/2000/09/xmldsig#"';
  SignatureNodes =
    '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">' +
      '<SignedInfo>' +
        '<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />' +
        '<SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256" />' +
        '<Reference URI="">' +
          '<Transforms>' +
            '<Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />' +
            '<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />' +
          '</Transforms>' +
          '<DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />' +
          '<DigestValue />' +
        '</Reference>' +
      '</SignedInfo>' +
      '<SignatureValue></SignatureValue>' +
      '<KeyInfo></KeyInfo>' +
    '</Signature>';
var
  iCert: Integer;
  XMLAssinado: String;
  XMLBody: String;

  xmldoc: IXMLDOMDocument3;
  xmldsig: IXMLDigitalSignature;
  dsigKey: IXMLDSigKey;
  signedKey: IXMLDSigKey;

  CertStore: IStore3;
  CertStoreMem: IStore3;
  PrivateKey: IPrivateKey;
  NumCertCarregado: String;
  Certs{, Store}: OleVariant;
  CertificadoAssina: ICertificate2;
begin
  Result := XML;

  CoInitialize(nil); // PERMITE O USO DE THREAD // Sandro Silva 2019-04-17

  xmldoc  := CoDOMDocument50.Create;// capicom.dll e msxml5.dll copiar e registrar (como administrador) para system32 e syswow64
  xmldsig := CoMXDigitalSignature50.Create;

  try
    XMLBody := XML;

    if AnsiContainsText(XMLBody, '<SignedInfo>') then
    begin
      // xml já está assinado
      XMLBody := Copy(XMLBody, 1, Pos('<Signature', XMLBody) - 1) + '<Signature />' + Copy(XMLBody, Pos('</Signature>', XMLBody) + Length('</Signature>'), Length(XMLBody));
    end;

    XMLBody := StringReplace(XMLBody, '<Signature />', SignatureNodes, [rfReplaceAll]);

    // Lendo Header antes de assinar //
    //XMLBodyHeaderAntes := '' ;
    //I := pos('?>',XMLBody) ;
    //if I > 0 then
    //  XMLBodyHeaderAntes := copy(XMLBody,1,I+1) ;

    xmldoc.async              := False;
    xmldoc.validateOnParse    := False;
    xmldoc.preserveWhiteSpace := True;

    StringReplace(XMLBody, '#D3#D4', '', [rfReplaceAll]);

    if (not xmldoc.loadXML(XMLBody)) then
      raise Exception.Create('Não foi possível carregar o arquivo: ' + XML);

    if XMLBody <> '' then
    begin
      XMLBody := StringReplace(XMLBody, #10, '', [rfReplaceAll]);
      XMLBody := StringReplace(XMLBody, #13, '', [rfReplaceAll]);
    end;

    xmldoc.setProperty('SelectionNamespaces', DSIGNS);

    xmldsig.signature := xmldoc.selectSingleNode('.//ds:Signature');

    if (xmldsig.signature = nil) then
      raise Exception.Create('É preciso carregar o template antes de assinar.');

    if CertStoreMem = nil then
    begin

      CertStore := CoStore.Create;
      CertStore.Open(CAPICOM_CURRENT_USER_STORE, 'My', CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);

      CertStoreMem := CoStore.Create;
      CertStoreMem.Open(CAPICOM_MEMORY_STORE, 'Memoria', CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);

      Certs := CertStore.Certificates as ICertificates2;
      for iCert := 1 to Certs.Count do
      begin

        CertificadoAssina := IInterface(Certs.Item[iCert]) as ICertificate2;

        if
          (AnsiContainsText(CertificadoAssina.SubjectName, Copy(scnpj, 1, 8))) // O CNPJ do emitente está no nome do certificado
          //AnsiContainsText(CertificadoAssina.SubjectName, 'CN=SMALLSOFT TECNOLOGIA EM INFORMATICA LTDA:07426598000124,')
        then
        begin

          CertStoreMem.Add(CertificadoAssina);
          NumCertCarregado := CertificadoAssina.Thumbprint;
          Break; // 2016-02-05  Sandro Silva

        end;

      end;
      
    end;

    //ShowMessage('Teste Num certificado: ' + NumCertCarregado); // Sandro Silva 2022-02-22

    OleCheck(IDispatch(Certificado.PrivateKey).QueryInterface(IPrivateKey, PrivateKey));
    xmldsig.store := CertStoreMem;

    try

      dsigKey := xmldsig.createKeyFromCSP(PrivateKey.ProviderType, PrivateKey.ProviderName, PrivateKey.ContainerName, 0);

      if (dsigKey = nil) then
        raise Exception.Create('Erro ao criar a chave do CSP.');

      // Deve usar CERTIFICATES = $00000002 para gerar todos grupos tags de assinatura (SignatureValue, X509Certificate). Outro valor não gera todas as tags
      signedKey := xmldsig.sign(dsigKey, CERTIFICATES);

      if (signedKey <> nil) then
      begin

        //ShowMessage('Teste adicionando assinatura no xml '); // Sandro Silva 2022-02-22

        XMLAssinado := xmldoc.xml;
        XMLAssinado := StringReplace(XMLAssinado, '<?xml version="1.0"?>', PAF_NFC_E_ESPECIFICACAO_XML, [rfReplaceAll]);
        XMLAssinado := StringReplace(XMLAssinado, #13#10, '', [rfReplaceAll]);
        XMLAssinado := StringReplace(XMLAssinado, #13, '', [rfReplaceAll]); // Sandro Silva 2019-04-22         
        XMLAssinado := StringReplace(XMLAssinado, '<KeyInfo><X509Data><X509Certificate></X509Certificate></X509Data></KeyInfo>', '', [rfReplaceAll]);
        // 2016-02-05 Sandro Silva Elimina Espaços em branco nas tags de assinatura
        XMLAssinado := StringReplace(XMLAssinado, xmlNodeValue(XMLAssinado, '//SignatureValue'), Trim(StringReplace(xmlNodeValue(XMLAssinado, '//SignatureValue'), #32, '', [rfReplaceAll])), [rfReplaceAll]);
        XMLAssinado := StringReplace(XMLAssinado, xmlNodeValue(XMLAssinado, '//X509Certificate'), Trim(StringReplace(xmlNodeValue(XMLAssinado, '//X509Certificate'), #32, '', [rfReplaceAll])), [rfReplaceAll]);
        {Sandro Silva 2019-02-26 inicio}
        while AnsiContainsText(XMLAssinado, '<SignatureValue> ') do
          XMLAssinado := StringReplace(XMLAssinado, '<SignatureValue> ', '<SignatureValue>', [rfReplaceAll]);

        while AnsiContainsText(XMLAssinado, ' </SignatureValue>') do
          XMLAssinado := StringReplace(XMLAssinado, ' </SignatureValue>', '</SignatureValue>', [rfReplaceAll]);

        while AnsiContainsText(XMLAssinado, '<X509Certificate>  ') do
          XMLAssinado := StringReplace(XMLAssinado, '<X509Certificate>  ', '<X509Certificate>', [rfReplaceAll]);

        while AnsiContainsText(XMLAssinado, ' </X509Certificate>') do
          XMLAssinado := StringReplace(XMLAssinado, ' </X509Certificate>', '</X509Certificate>', [rfReplaceAll]);

        while AnsiContainsText(XMLAssinado, '<X509Data> ') do
          XMLAssinado := StringReplace(XMLAssinado, '<X509Data> ', '<X509Data>', [rfReplaceAll]);

        while AnsiContainsText(XMLAssinado, ' </X509Data>') do
          XMLAssinado := StringReplace(XMLAssinado, ' </X509Data>', '</X509Data>', [rfReplaceAll]);

        while AnsiContainsText(XMLAssinado, '<KeyInfo> ') do
          XMLAssinado := StringReplace(XMLAssinado, '<KeyInfo> ', '<KeyInfo>', [rfReplaceAll]);

        while AnsiContainsText(XMLAssinado, ' </KeyInfo>') do
          XMLAssinado := StringReplace(XMLAssinado, ' </KeyInfo>', '</KeyInfo>', [rfReplaceAll]);
        {Sandro Silva 2019-02-26 fim}
      end
      else
        raise Exception.Create('Assinatura Falhou.');
    except
      on E: Exception do
      begin
        if DirectoryExists('log') then
        begin
          with TArquivo.Create do
          begin
            Texto := FormatDateTime('dd/mm/yyyy HH:nn:ss.zzz', Now) + E.Message;
            SalvarArquivo('log\BlocoX\log_' + FormatDateTime('dd-mm-yyyy-HH-nn-ss-zzz', Now) + '.txt');// Sandro Silva 2021-02-19 SalvarArquivo('log_' + FormatDateTime('dd-mm-yyyy-HH-nn-ss-zzz', Now) + '.txt');
            Free;
          end;
        end;
      end;
    end;

    Result := XMLAssinado;

  finally
    if dsigKey <> nil then
      dsigKey := nil;
    if signedKey <> nil then
      signedKey := nil;
    if xmldoc <> nil then
      xmldoc := nil;
    if xmldsig <> nil then
      xmldsig := nil;
    if CertStore <> nil then
      CertStore := nil;
    if CertStoreMem <> nil then
      CertStoreMem := nil;
    {Sandro Silva 2019-06-19 inicio}
    if CertificadoAssina <> nil then
      CertificadoAssina := nil;
    {Sandro Silva 2019-06-19 fim}
  end;
end;

end.
