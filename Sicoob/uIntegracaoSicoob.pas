unit uIntegracaoSicoob;

interface

uses
  System.SysUtils, REST.JSON, System.Generics.Collections, REST.Json.Types,
  Vcl.Forms, REST.Types, IBX.IBDatabase, IBX.IBQuery,
  System.Classes, Winapi.Windows, Data.DB, System.Variants, System.StrUtils;

  const URL_SICOOB   = 'https://api.eclipp.com.br/api/pix/';

  function RegistraContaSicoob(name,identifier,token, idBank,
                               description, pixMerchantName, pixMerchantCity,
                               apiPixClientId, apiPixCertificate, apiPixPwdCertificate: string;
                               out id_api_pix : integer;
                               out Mensagem:string):boolean;
  function GetCertificateSicoobPem(IBTRANSACTION: TIBTransaction) : string;
  function GeraChavePixISicoob(idBankAccount : integer; description : string;
                             Valor : double; out ChaveQRCode, order_id, Mensagem : string):boolean;
  function GetStatusPixSicoob(txId:string; IdBankAccount : integer; out CodigoAutorizacao:string):string;


implementation

uses
  uFuncoesBancoDados
  , uChaveCertificado
  , uWebServiceSicoob
  , uClassesSicoob
  , uLogSistema
  , smallfunc_xe;

function RegistraContaSicoob(name,identifier,token, idBank,
                             description, pixMerchantName, pixMerchantCity,
                             apiPixClientId, apiPixCertificate, apiPixPwdCertificate: string;
                             out id_api_pix : integer;
                             out Mensagem:string):boolean;
var
  sRetorno : string;
  StatusCode : integer;
  Campos : TCamposApi;
  RetornoBankAccount : TRetornoBankAccount;
begin
  Result := False;

  try
    {$Region'//// Carrega campos envio ////'}
    Campos := TCamposApi.Create;
    SetLength(Campos.CamposApi,10);

    Campos.CamposApi[0] := TCampoApi.Create;
    Campos.CamposApi[0].Descricao := 'name';
    Campos.CamposApi[0].Valor     := name;

    Campos.CamposApi[1] := TCampoApi.Create;
    Campos.CamposApi[1].Descricao := 'identifier';
    Campos.CamposApi[1].Valor     := identifier;

    Campos.CamposApi[2] := TCampoApi.Create;
    Campos.CamposApi[2].Descricao := 'idBank';
    Campos.CamposApi[2].Valor     := idBank;

    Campos.CamposApi[3] := TCampoApi.Create;
    Campos.CamposApi[3].Descricao := 'description';
    Campos.CamposApi[3].Valor     := description;

    Campos.CamposApi[4] := TCampoApi.Create;
    Campos.CamposApi[4].Descricao := 'pixMerchantName';
    Campos.CamposApi[4].Valor     := pixMerchantName;

    Campos.CamposApi[5] := TCampoApi.Create;
    Campos.CamposApi[5].Descricao := 'pixMerchantCity';
    Campos.CamposApi[5].Valor     := pixMerchantCity;

    Campos.CamposApi[6] := TCampoApi.Create;
    Campos.CamposApi[6].Descricao := 'apiPixClientId';
    Campos.CamposApi[6].Valor     := apiPixClientId;

    Campos.CamposApi[7] := TCampoApi.Create;
    Campos.CamposApi[7].Descricao := 'pixKey';
    Campos.CamposApi[7].Valor     := identifier;

    Campos.CamposApi[8] := TCampoApi.Create;
    Campos.CamposApi[8].Descricao := 'apiPixPwdCertificate';
    Campos.CamposApi[8].Valor     := apiPixPwdCertificate;

    Campos.CamposApi[9] := TCampoApi.Create;
    Campos.CamposApi[9].Descricao := 'apiPixClientSecret';
    Campos.CamposApi[9].Valor     := apiPixClientId;
    {$Endregion}

    if RequisicaoSicoob(rmPOST,
                        URL_SICOOB+'bank-account',
                        '',
                        token,
                        apiPixCertificate,
                        Campos,
                        sRetorno,
                        StatusCode) then
    begin
      RetornoBankAccount  := TJson.JsonToObject<TRetornoBankAccount>(sRetorno);

      id_api_pix := RetornoBankAccount.idBankAccount;

      Result := True;
    end else
    begin
      LogSistema('Falha na criação da conta. '+'Código: '+StatusCode.ToString+' '+sRetorno);

      Mensagem := 'Falha na criação da conta.'+#13#10+
                  'Verifique com o suporte técnico!'+#13#10+
                  'Código: '+StatusCode.ToString;
    end;
  finally
    FreeAndNil(Campos);
  end;
end;

function GetCertificateSicoobPem(IBTRANSACTION: TIBTransaction) : string;
var
  sDir : string;
  ibqSicoob: TIBQuery;
  sDirArquivo, sDirCertificado : string;
  mErro : string;
begin
  Result := '';

  sDir := ExtractFilePath(Application.ExeName)+'Certificado\SicoobCertificado.pem';

  if FileExists(sDir) then
  begin
    Result := sDir;
  end else
  begin
    //Refaz arquivos com informações do bando de dados
    try
      ibqSicoob := CriaIBQuery(IBTRANSACTION);
      ibqSicoob.SQL.Text :=  ' Select'+
                             '   CERTIFICADO,'+
                             '   CERTIFICADOSENHA'+
                             ' From CONFIGURACAOSICOOB';
      ibqSicoob.Open;

      if VarIsNull(ibqSicoob.FieldByName('CERTIFICADO').AsVariant) then
        Exit;

      sDirCertificado := SalvaArquivoTemp(ibqSicoob.FieldByName('CERTIFICADO') ,'Certificado.pfx');

      //Extrai arquivos
      sDirArquivo := ExtractFilePath(Application.ExeName)+'Certificado\';
      if not DirectoryExists(sDirArquivo) then
        CreateDir(sDirArquivo);

      if ExtraiChavesCertificado(sDirCertificado,
                                 ibqSicoob.FieldByName('CERTIFICADOSENHA').AsString,
                                 sDirArquivo+'SicoobChavePrivada.key',
                                 sDirArquivo+'SicoobCertificado.pem',
                                 mErro) then
      begin
        Result := sDirArquivo+'SicoobCertificado.pem';
      end;
    finally
      FreeAndNil(ibqSicoob);
    end;
  end;
end;



function GeraChavePixISicoob(idBankAccount : integer; description : string;
                             Valor : double; out ChaveQRCode, order_id, Mensagem : string):boolean;
var
  sJson, sJsonRet : string;
  StatusCode : integer;
  PixGenerate : TPixGenerate;
  RetPixGenerate : TRetPixGenerate;
  RetErro : TRetErro;
begin
  Result := False;

  try
    PixGenerate := TPixGenerate.Create;
    PixGenerate.Description := description;
    PixGenerate.IdBankAccount := idBankAccount;
    PixGenerate.Value := Valor;
    PixGenerate.DaysToExpire := 1;

    sJson := TJson.ObjectToJsonString(PixGenerate);

    if RequisicaoSicoob(rmPOST,URL_SICOOB+'generate',sJson,'','',nil,sJsonRet,StatusCode) then
    begin
      try
        RetPixGenerate  := TJson.JsonToObject<TRetPixGenerate>(sJsonRet);

        ChaveQRCode := RetPixGenerate.payloadQrCode;
        order_id    := RetPixGenerate.TxId;
      finally
        FreeAndNil(RetPixGenerate);
      end;

      Result := True;
    end else
    begin
      LogSistema('Falha ao gerar chave PIX. '+'Código: '+StatusCode.ToString+' '+sJsonRet);

      try
        RetErro  := TJson.JsonToObject<TRetErro>(sJsonRet);
        Mensagem := 'Falha ao gerar chave PIX.'+#13#10+
                    RetErro.Message+#13#10+
                    'Código: '+StatusCode.ToString;

        FreeAndNil(RetErro);
      except
        Mensagem := 'Falha ao gerar chave PIX.'+#13#10+
                    'Verifique com o suporte técnico!'+#13#10+
                    'Código: '+StatusCode.ToString;
      end;

    end;
  finally
    FreeAndNil(PixGenerate);
  end;
end;

function GetStatusPixSicoob(txId:string; IdBankAccount : integer; out CodigoAutorizacao:string):string;
var
  sJson, sJsonRet : string;
  StatusCode : integer;
  GetStatus : TGetStatus;
  RetPixGenerate : TRetPixGenerate;
begin
  Result := '';

  try
    GetStatus := TGetStatus.Create;
    GetStatus.IdBankAccount := IdBankAccount;
    GetStatus.TxId := txId;

    sJson := TJson.ObjectToJsonString(GetStatus);

    if RequisicaoSicoob(rmPOST,URL_SICOOB+'get',sJson,'','',nil,sJsonRet,StatusCode) then
    begin
      RetPixGenerate  := TJson.JsonToObject<TRetPixGenerate>(sJsonRet);

      if RetPixGenerate.PaidOut then
      begin
        Result := 'approved';
        CodigoAutorizacao := RetPixGenerate.EndToEndId;
      end;
    end;
  finally
    FreeAndNil(GetStatus);
  end;
end;


end.
