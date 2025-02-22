unit usmallwebservice;

interface

uses
  Windows, SysUtils, Classes,
  {$IFDEF VER150}
  CAPICOM_TLB,
  {$ELSE}
  CAPICOM_TLB_xe,
  {$ENDIF }
  wininet, synautil;

function SmallStr(AString: String ): String;

type
  { ESmallHTTPReqResp }

  ESmallHTTPReqResp = class(Exception)
  public
    constructor Create(const Msg: String);
  end;

  { TSmallHTTPReqResp }

  TSmallHTTPReqResp = class
  private
    FCertificate: ICertificate2;
    FCertSerialNumber: String;
    FCertStoreName: String;
    FEncodeDataToUTF8: Boolean;
    FInternalErrorCode: Integer;
    FSOAPAction: String;
    FMimeType: String; // (ex.: 'application/soap+xml' ou 'text/xml' - que � o Content-Type)
    FCharsets: String; //  (ex.: 'ISO-8859-1,utf-8' - que � o Accept-Charset)
    FData: AnsiString;
    FProxyHost: String;
    FProxyPass: String;
    FProxyPort: String;
    FProxyUser: String;
    FHTTPResultCode: Integer;
    FTimeOut: Integer;
    FUrl: String;
    FShowCertStore: Boolean;

    function GetWinInetError(ErrorCode: cardinal): String;
    function OpenCertStore: String;

    procedure UpdateErrorCodes(ARequest: HINTERNET);
  protected

  public
    constructor Create;

    property SOAPAction: String read FSOAPAction write FSOAPAction;
    property MimeType: String read FMimeType write FMimeType;
    property Charsets: String read FCharsets write FCharsets;
    property Url: String read FUrl write FUrl;
    property Data: AnsiString read FData write FData;
    property ProxyHost: String read FProxyHost write FProxyHost;
    property ProxyPort: String read FProxyPort write FProxyPort;
    property ProxyUser: String read FProxyUser write FProxyUser;
    property ProxyPass: String read FProxyPass write FProxyPass;
    property CertStoreName: String read FCertStoreName write FCertStoreName;
    property ShowCertStore: Boolean read FShowCertStore write FShowCertStore;
    property EncodeDataToUTF8: Boolean read FEncodeDataToUTF8 write FEncodeDataToUTF8;
    property TimeOut: Integer read FTimeOut write FTimeOut;

    property HTTPResultCode: Integer read FHTTPResultCode;
    property InternalErrorCode: Integer read FInternalErrorCode;

    procedure SetCertificate(pCertSerialNumber: String); overload;
    procedure SetCertificate(pCertificate: ICertificate2); overload;
    procedure Execute(Resp: TStream); overload;
    procedure Execute(const DataMsg: String; Resp: TStream); overload;
  end;

  {$EXTERNALSYM CERT_CONTEXT}
  _CERT_CONTEXT = record
    dwCertEncodingType: longword;
    pbCertEncoded: ^byte;
    cbCertEncoded: longword;
    pCertInfo: Pointer;
    hCertStore: Pointer;
  end;

  {$EXTERNALSYM _CERT_CONTEXT}
  CERT_CONTEXT = _CERT_CONTEXT;

type
  { TSmallWebService }

  TSmallWebService = class(TComponent)
  private

  protected

  published

  public

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Smallsoft', [TSmallWebService]);
end;

function SmallStr(AString: String ): String;
begin // Compatibilidade entre compiladores Pascal
{$IFDEF UNICODE}
  {$IFDEF FPC}
    Result := CP1252ToUTF8(AString);
  {$ELSE}
    Result := String(AString);
  {$ENDIF}
{$ELSE}
  Result := AString;
{$ENDIF}
end;

{ TSmallHTTPReqResp }

constructor TSmallHTTPReqResp.Create;
begin
  FMimeType         := 'application/soap+xml';
  FCharsets         := 'utf-8';
  FSOAPAction       := '';
  FCertStoreName    := 'My';
  FCertSerialNumber := '';
  FCertificate      := nil;
  FShowCertStore    := False;
  FHTTPResultCode   := 0;
  FEncodeDataToUTF8 := False;   
end;

procedure TSmallHTTPReqResp.Execute(Resp: TStream);
const
  INTERNET_OPTION_CLIENT_CERT_CONTEXT = 84;
var
  aBuffer: array[0..4096] of AnsiChar;
  BytesRead: cardinal;
  pSession: HINTERNET;
  pConnection: HINTERNET;
  pRequest: HINTERNET;
  flags, flagsLen: longword;

  Store: IStore;
  Certs: ICertificates;
  Cert2: ICertificate2;
  CertContext: ICertContext;

  Ok, UseSSL, UseCertificate: Boolean;
  i, AccessType, HCertContext: Integer;
  ANone, AHost, AProt, APort, APath, pProxy, Header: String;
begin

  AProt        := '';
  APort        := '';
  APath        := '';
  HCertContext := 0;

  ParseURL(FUrl, AProt, ANone, ANone, AHost, APort, APath, ANone);

  UseSSL := (UpperCase(AProt) = 'HTTPS');

  if UseSSL then
  begin
    // Ainda n�o tem Certificado, pode pedir para selecionar ?
    if ((FCertSerialNumber = '') and ShowCertStore) then
      OpenCertStore;

    if (FCertSerialNumber = '') then
      FCertificate := nil
    else
    begin
      // Procura pelo Certificado com o Numero de S�rie "CertSerialNumber"
      if (FCertificate = nil) then
      begin
        Store := CoStore.Create;
        try
          Store.Open(CAPICOM_CURRENT_USER_STORE, WideString(FCertStoreName),
                     CAPICOM_STORE_OPEN_READ_ONLY);

          Certs := Store.Certificates as ICertificates2;

          for i := 1 to Certs.Count do
          begin
            Cert2 := IInterface(Certs.Item[i]) as ICertificate2;
            if String(Cert2.SerialNumber) = FCertSerialNumber then
            begin
              FCertificate := Cert2;
              break;
            end;
          end;
        finally
          {$IFDEF VER150}
          FreeAndNil(Store);
          {$ENDIF}
        end;
      end;
    end;

    UseCertificate := Assigned( FCertificate ) ;
  end
  else
    UseCertificate := False;   // Uso de Certificado exige SSL

  if FProxyHost <> '' then
  begin
    AccessType := INTERNET_OPEN_TYPE_PROXY;
    if (FProxyPort <> '') and (FProxyPort <> '0') then
      pProxy := FProxyHost + ':' + FProxyPort
    else
      pProxy := FProxyHost;
  end
  else
    AccessType := INTERNET_OPEN_TYPE_PRECONFIG;

  //DEBUG
  //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Abrindo sess�o');

  if UseCertificate then
  begin
    CertContext := FCertificate as ICertContext;
    CertContext.Get_CertContext(HCertContext);
  end;

  pSession := InternetOpen(PChar('Borland SOAP 1.2'), AccessType, PChar(pProxy), nil, 0);

  try
    if not Assigned(pSession) then
      raise ESmallHTTPReqResp.Create('Erro: Internet Open or Proxy');

    //DEBUG
    //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Ajustando TimeOut: '+IntToStr(FTimeOut));

    if not InternetSetOption(pSession, INTERNET_OPTION_CONNECT_TIMEOUT, @FTimeOut, SizeOf(FTimeOut)) then
      raise ESmallHTTPReqResp.Create('Erro ao definir TimeOut de Conex�o');

    if not InternetSetOption(pSession, INTERNET_OPTION_SEND_TIMEOUT, @FTimeOut, SizeOf(FTimeOut)) then
      raise ESmallHTTPReqResp.Create('Erro ao definir TimeOut de Envio');

    if not InternetSetOption(pSession, INTERNET_OPTION_DATA_SEND_TIMEOUT, @FTimeOut, SizeOf(FTimeOut)) then
      raise ESmallHTTPReqResp.Create('Erro ao definir TimeOut de Envio');

    if not InternetSetOption(pSession, INTERNET_OPTION_RECEIVE_TIMEOUT, @FTimeOut, SizeOf(FTimeOut)) then
      raise ESmallHTTPReqResp.Create('Erro ao definir TimeOut de Recebimento');

    if not InternetSetOption(pSession, INTERNET_OPTION_DATA_RECEIVE_TIMEOUT, @FTimeOut, SizeOf(FTimeOut)) then
      raise ESmallHTTPReqResp.Create('Erro ao definir TimeOut de Recebimento');

    if APort = '' then
    begin
      if (UseSSL) then
        APort := IntToStr(INTERNET_DEFAULT_HTTPS_PORT)
      else
        APort := IntToStr(INTERNET_DEFAULT_HTTP_PORT);
    end;

    //Debug, TimeOut Test
    //AHost := 'www.google.com';
    //port := 81;

    //DEBUG
    //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Abrindo Conex�o: '+AHost+':'+APort);

    pConnection := InternetConnect(pSession, PChar(AHost), StrToInt(APort),
                                   PChar(FProxyUser), PChar(FProxyPass),
                                   INTERNET_SERVICE_HTTP,
                                   0, 0{cardinal(Self)});
    if not Assigned(pConnection) then
      raise ESmallHTTPReqResp.Create('Erro: Internet Connect or Host');

    try
      if (UseSSL) then
      begin
        flags := INTERNET_FLAG_KEEP_CONNECTION or INTERNET_FLAG_NO_CACHE_WRITE;
        flags := flags or INTERNET_FLAG_SECURE;

        if (UseCertificate) then
          flags := flags or (INTERNET_FLAG_IGNORE_CERT_CN_INVALID or
                             INTERNET_FLAG_IGNORE_CERT_DATE_INVALID);
      end
      else
        flags := INTERNET_SERVICE_HTTP;

      //DEBUG
      //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Fazendo POST: '+APath);

      pRequest := HttpOpenRequest(pConnection, PChar('POST'),
                                  PChar(APath), nil, nil, nil, flags, 0);

      if not Assigned(pRequest) then
        raise ESmallHTTPReqResp.Create('Erro: Open Request');

      UpdateErrorCodes(pRequest);

      try
        if ( (APort <> IntToStr(INTERNET_DEFAULT_HTTP_PORT)) and (not UseSSL) ) or
           ( (APort <> IntToStr(INTERNET_DEFAULT_HTTPS_PORT)) and (UseSSL) ) then
          AHost := AHost +':'+ APort;

        Header := 'Host: ' + AHost + sLineBreak +
                  'Content-Type: ' + FMimeType + '; charset=' + FCharsets + SLineBreak +
                  'Accept-Charset: ' + FCharsets + SLineBreak;

        if FSOAPAction <> '' then
          Header := Header +'SOAPAction: "' + FSOAPAction + '"' +SLineBreak;

        if (UseCertificate) then
        begin
          if not InternetSetOption(pRequest, INTERNET_OPTION_CLIENT_CERT_CONTEXT,
                                   Pointer(HCertContext), SizeOf(CERT_CONTEXT)) then
            raise ESmallHTTPReqResp.Create('Erro: Problema ao inserir o certificado')
        end
        else
        begin
          flags := 0;
          flagsLen := SizeOf(flags);
          if not InternetQueryOption(pRequest, INTERNET_OPTION_SECURITY_FLAGS, @flags, flagsLen) then
            raise ESmallHTTPReqResp.Create('InternetQueryOption erro ao ler wininet flags.' + GetWininetError(GetLastError));

          flags := flags or SECURITY_FLAG_IGNORE_UNKNOWN_CA or
                            SECURITY_FLAG_IGNORE_CERT_DATE_INVALID or
                            SECURITY_FLAG_IGNORE_CERT_CN_INVALID or
                            SECURITY_FLAG_IGNORE_REVOCATION;
          if not InternetSetOption(pRequest, INTERNET_OPTION_SECURITY_FLAGS, @flags, flagsLen) then
            raise ESmallHTTPReqResp.Create('InternetQueryOption erro ao ajustar INTERNET_OPTION_SECURITY_FLAGS' + GetWininetError(GetLastError));
        end;

        if trim(FProxyUser) <> '' then
          if not InternetSetOption(pRequest, INTERNET_OPTION_PROXY_USERNAME,
                                   PChar(FProxyUser), Length(FProxyUser)) then
            raise ESmallHTTPReqResp.Create('Erro: Proxy User');

        if trim(FProxyPass) <> '' then
          if not InternetSetOption(pRequest, INTERNET_OPTION_PROXY_PASSWORD,
                                   PChar(FProxyPass), Length(FProxyPass)) then
            raise ESmallHTTPReqResp.Create('Erro: Proxy Password');

        HttpAddRequestHeaders(pRequest, PChar(Header), Length(Header), HTTP_ADDREQ_FLAG_ADD);

        if FEncodeDataToUTF8 then
          FData := UTF8Encode(FData);

        //DEBUG
        //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Enviando Dados: '+APath);
        //WriteToTXT('c:\temp\httpreqresp.log', FData);

        Ok := False;
        Resp.Size := 0;
        if HttpSendRequest(pRequest, nil, 0, Pointer(FData), Length(FData)) then
        begin
          BytesRead := 0;
          //DEBUG
          //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Lendo Dados');

          while InternetReadFile(pRequest, @aBuffer, SizeOf(aBuffer), BytesRead) do
          begin
            //DEBUG
            //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Bytes Lido: '+IntToStr(BytesRead));

            if (BytesRead = 0) then
              Break;

            Resp.Write(aBuffer, BytesRead);
          end;

          if Resp.Size > 0 then
          begin
            Resp.Position := 0;

            //DEBUG
            //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Total Lido: '+IntToStr(Resp.Size));
            //Resp.Position := 0;
            //FData := ReadStrFromStream(Resp, Resp.Size);
            //Resp.Position := 0;
            //WriteToTXT('c:\temp\httpreqresp.log', FData);

            Ok := True;
          end;
        end;

        if not OK then
        begin
          UpdateErrorCodes(pRequest);

          //DEBUG
          //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+
          //   ' - Erro WinNetAPI: '+IntToStr(InternalErrorCode)+' HTTP: '+IntToStr(HTTPResultCode));

          raise ESmallHTTPReqResp.Create('Erro: Requisi��o n�o enviada.' +
            sLineBreak + IntToStr(InternalErrorCode) + ' - ' + GetWinInetError(InternalErrorCode));
        end;
      finally

        InternetCloseHandle(pRequest);
      end;
    finally
      InternetCloseHandle(pConnection);
    end;
  finally
    InternetCloseHandle(pSession);

    if (HCertContext <> 0) then
      CertContext.FreeContext(HCertContext);
  end;
  {Sandro Silva 2018-08-30 inicio}
  if Store <> nil then
    Store := nil;
  {Sandro Silva 2018-08-30 fim}
end;

procedure TSmallHTTPReqResp.Execute(const DataMsg: String; Resp: TStream);
begin
  Data := DataMsg;
  Execute(Resp);
end;

function TSmallHTTPReqResp.GetWinInetError(ErrorCode: cardinal): String;
const
  winetdll = 'wininet.dll';
var
  Len: integer;
  Buffer: PChar;
begin
  Len := FormatMessage(FORMAT_MESSAGE_FROM_HMODULE or
                       FORMAT_MESSAGE_FROM_SYSTEM or
                       FORMAT_MESSAGE_ALLOCATE_BUFFER or
                       FORMAT_MESSAGE_IGNORE_INSERTS or
                       FORMAT_MESSAGE_ARGUMENT_ARRAY, Pointer(GetModuleHandle(winetdll)),
    ErrorCode, 0, @Buffer, SizeOf(Buffer), nil);
  try
    while (Len > 0) and
     {$IFDEF DELPHI12_UP}
      (CharInSet(Buffer[Len - 1], [#0..#32, '.']))
     {$ELSE}
      (Buffer[Len - 1] in [#0..#32, '.'])
     {$ENDIF}
      do
    begin
      Dec(Len);
    end;

    SetString(Result, Buffer, Len);
  finally
    LocalFree(HLOCAL(Buffer));
  end;
end;

function TSmallHTTPReqResp.OpenCertStore: String;
var
  Store: IStore3;
  Certs, CertsSel: ICertificates2;
begin
  Store := CoStore.Create;
  try
    Store.Open(CAPICOM_CURRENT_USER_STORE, WideString(FCertStoreName), CAPICOM_STORE_OPEN_READ_ONLY);

    Certs := Store.Certificates as ICertificates2;

    CertsSel := Certs.Select(WideString(SmallStr('Certificados Digitais dispon�vel')),
                             WideString('Selecione o Certificado Digital para uso no aplicativo'),
                             False);

    if not (CertsSel.Count = 0) then
    begin
      FCertificate := IInterface(CertsSel.Item[1]) as ICertificate2;
      FCertSerialNumber := String(FCertificate.SerialNumber);
    end;
  finally
    try
      // Sandro Silva 2017-03-17  FreeAndNil(Store);
    except
    end;
  end;

  Store := nil; // Sandro Silva 2018-08-30
   
  Result := FCertSerialNumber;
end;

procedure TSmallHTTPReqResp.SetCertificate(pCertificate: ICertificate2);
begin
  if FCertificate = pCertificate then
    Exit;

  FCertificate := pCertificate;

  if Assigned(FCertificate) then
    FCertSerialNumber := String(FCertificate.SerialNumber)
  else
    FCertSerialNumber := '';
end;

procedure TSmallHTTPReqResp.SetCertificate(pCertSerialNumber: String);
begin
  if FCertSerialNumber = pCertSerialNumber then
    Exit;

  FCertSerialNumber := pCertSerialNumber;
  FCertificate := nil;  // For�a a busca do Certificado no pr�ximo "Execute"
end;

procedure TSmallHTTPReqResp.UpdateErrorCodes(ARequest: HINTERNET);
Var
  dummy, bufLen: DWORD;
  aBuffer: array [0..512] of AnsiChar;
begin
  FInternalErrorCode := GetLastError;

  dummy  := 0;
  bufLen := Length(aBuffer);
  if not HttpQueryInfo(ARequest, HTTP_QUERY_STATUS_CODE, @aBuffer, bufLen, dummy ) then
    FHTTPResultCode := 4
  else
    FHTTPResultCode := StrToIntDef( {$IFDEF DELPHIXE4_UP}AnsiStrings.{$ENDIF}StrPas(aBuffer), 0);
end;

{ ESmallHTTPReqResp }

constructor ESmallHTTPReqResp.Create(const Msg: String);
begin
  inherited Create(SmallStr(Msg));
end;

end.
