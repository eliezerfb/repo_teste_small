unit uPagamentoPix;

interface

uses
  IBX.IBCustomDataSet, System.SysUtils, System.IniFiles, IBX.IBQuery,
  IBX.IBDatabase;

  function FormaPagamentoPix(DataSet : TibDataSet; TipoPix:string) : integer;

  //Pix Estático
  function PagamentoPixEstatico(Valor : double; IDTransacao : string; out InstituicaoFinanceira : string; IBTRANSACTION: TIBTransaction):boolean;
  //function GeraChavePixEstatica(pixtitular,municipio,pixchave,pixTipochave,IDTransacao : string; Valor : Double ):string;

  //Pix Dinamico Itaú
  function PagamentoPixDinamico(Valor : double; IDTransacao, NumeroNF, Caixa : string;
            out InstituicaoFinanceira : string; IBTRANSACTION: TIBTransaction):boolean;
  procedure GravaTransacaoItau(NumeroNF, Caixa, OrderID, Status : string; Valor : Double; IBDatabase: TIBDatabase);
  procedure AtualizaStatusTransacaoItau(OrderID, Status : string; IBDatabase: TIBDatabase);

implementation

{$R-} //Desativa Range check error

uses
  uConectaBancoSmall
  , ufrmSelecionarPIX
  , ufrmQRCodePixEst
  , ufrmQRCodePixDin
  , uDialogs
  , smallfunc_xe
  , uIntegracaoItau
  , uGeraChavePix
  , uTypesRecursos
  , uValidaRecursos
  , uSmallConsts;


function CRC16CCITT(texto: string): WORD;
const
  polynomial = $1021;
var
  crc: WORD;
  i, j: Integer;
  b: Byte;
  bit, c15: Boolean;
begin
  crc := $FFFF;
  for i := 1 to length(texto) do
  begin
    b := Byte(texto[i]);
    for j := 0 to 7 do
    begin
      bit := (((b shr (7 - j)) and 1) = 1);
      c15 := (((crc shr 15) and 1) = 1);
      crc := crc shl 1;
      if (c15 xor bit) then
        crc := crc xor polynomial;
    end;
  end;
  Result := crc and $FFFF;
end;

function FormaPagamentoPix(DataSet : TibDataSet; TipoPix:string) : integer;
var
  i : integer;
  CampoV : string;
  FrenteIni: TIniFile;
begin
  Result := 0;

  try
    FrenteIni  := TIniFile.Create('FRENTE.INI');

    for I := 1 to 8 do
    begin
      CampoV := 'VALOR0'+IntToStr(i);

      //Verifica se a forma foi usada
      if DataSet.FieldByName(CampoV).AsFloat > 0 then
      begin
        //Verifica se a forma está configurada como PIX
        if Copy(FrenteIni.ReadString('NFCE', 'Ordem forma extra '+I.ToString, '99'), 1, 2) = '17' then
        begin
          //Verifica o Tipo Mauricio Parizotto 2024-06-14
          if FrenteIni.ReadString('NFCE', 'Tipo Pix '+I.ToString, '') = TipoPix then
            Result := i;
        end;
      end;
    end;
  finally
    FreeAndNil(FrenteIni);
  end;
end;

function PagamentoPixEstatico(Valor : double; IDTransacao : string; out InstituicaoFinanceira : string; IBTRANSACTION: TIBTransaction):boolean;
var
  ibqBancos: TIBQuery;
  ChaveQRCode : string;
begin
  Result := False;

  try
    ibqBancos := CriaIBQuery(IBTRANSACTION);
    ibqBancos.SQL.Text := ' Select '+
                          '   B.REGISTRO,'+
                          ' 	B.NOME,'+
                          ' 	B.INSTITUICAOFINANCEIRA,'+
                          ' 	B.PIXTIPOCHAVE,'+
                          ' 	B.PIXTITULAR,'+
                          ' 	B.PIXCHAVE,'+
                          ' 	E.MUNICIPIO'+
                          ' From BANCOS B'+
                          ' 	Left Join EMITENTE E on 1=1'+
                          ' Where PIXESTATICO = ''S'' ';
    ibqBancos.Open;
    ibqBancos.Last; //Para funcionar RecordCount

    //Nenhum banco configurado com pix estático
    if ibqBancos.IsEmpty then
    begin
      MensagemSistema('Nenhum banco com PIX habilitado!',msgAtencao);
      Exit;
    end;

    //Se tiver mais que um configurado abre tela para selecionar
    if ibqBancos.RecordCount > 1 then
    begin
      ibqBancos.First;

      if not SelecionaChavePIX(ibqBancos) then
        Exit;
    end;

    ChaveQRCode := GeraChavePixEstatica(ibqBancos.FieldByName('PIXTITULAR').AsString,
                                        ibqBancos.FieldByName('MUNICIPIO').AsString,
                                        ibqBancos.FieldByName('PIXCHAVE').AsString,
                                        ibqBancos.FieldByName('PIXTIPOCHAVE').AsString,
                                        IDTransacao,
                                        Valor
                                       );

    if PagamentoQRCodePIX(ChaveQRCode,Valor) then
    begin
      InstituicaoFinanceira := ibqBancos.FieldByName('INSTITUICAOFINANCEIRA').AsString;
      Result := True;
    end;
  finally
    FreeAndNil(ibqBancos);
  end;
end;

{
function GeraChavePixEstatica(pixtitular,municipio,pixchave,pixTipochave,IDTransacao : string; Valor : Double ):string;
var
  Payload : string;
  PayloadFormat, MerchantAccount, MerchantCategoryCode, MerchantName,
  MerchantCity, CountryCode, Additional, TransactionCurrency,
  TransactionAmount, CRC16  : string;

  function TamanhoTexto(texto : string) : string;
  begin
    Result := Format('%2.2d',[ Length(texto)]);
  end;

  function CRC16CCITT(texto: string): WORD;
  const
    polynomial = $1021;
  var
    crc: WORD;
    i, j: Integer;
    b: Byte;
    bit, c15: Boolean;
  begin
    crc := $FFFF;
    for i := 1 to length(texto) do
    begin
      b := Byte(texto[i]);
      for j := 0 to 7 do
      begin
        bit := (((b shr (7 - j)) and 1) = 1);
        c15 := (((crc shr 15) and 1) = 1);
        crc := crc shl 1;
        if (c15 xor bit) then
          crc := crc xor polynomial;
      end;
    end;
    Result := crc and $FFFF;
  end;
begin
  try
    if pixTipochave = 'CNPJ/CPF' then
      pixchave := LimpaNumero(pixchave);

    if pixTipochave = 'Celular' then
      pixchave := '+55'+LimpaNumero(pixchave);

    pixtitular := ConverteAcentos(pixtitular);
    pixtitular := Copy(pixtitular,1,25);
    municipio  := ConverteAcentos(municipio);
    municipio  := Copy(municipio,1,15);

    PayloadFormat         := '000201';
    MerchantAccount       := '0014BR.GOV.BCB.PIX'+'01'+TamanhoTexto(pixchave)+pixchave;
    MerchantAccount       := '26'+TamanhoTexto(MerchantAccount)+MerchantAccount;
    MerchantCategoryCode  := '52040000';
    TransactionCurrency   := '5303986'; //Real Brasileiro
    TransactionAmount     :=  StringReplace( StringReplace(  FormatFloat( '#,##0.00', Valor)  ,'.','',[rfReplaceAll])    , ',','.',[rfReplaceAll]);
    TransactionAmount     := '54'+TamanhoTexto(TransactionAmount)+TransactionAmount;
    CountryCode           := '5802BR';
    MerchantName          := '59'+TamanhoTexto(pixtitular)+pixtitular;
    MerchantCity          := '60'+TamanhoTexto(municipio)+municipio;

    if IDTransacao = '' then
    begin
      Additional            := '62070503***'
    end else
    begin
      Additional            := TamanhoTexto(IDTransacao)+IDTransacao;
      Additional            := '62'+TamanhoTexto('05'+Additional)+'05'+Additional;
    end;

    CRC16                 := '6304';

    Payload  := PayloadFormat+
                MerchantAccount+
                MerchantCategoryCode+
                TransactionCurrency+
                TransactionAmount+
                CountryCode+
                MerchantName+
                MerchantCity+
                Additional+
                CRC16;

    Result := Payload+IntToHex(CRC16CCITT(Payload));
  except
    Result := '';
  end;
end;
}

function PagamentoPixDinamico(Valor : double; IDTransacao, NumeroNF, Caixa : string;
  out InstituicaoFinanceira : string; IBTRANSACTION: TIBTransaction):boolean;
var
  ibqItau: TIBQuery;
  ChaveQRCode, order_id, Mensagem : string;

  bLiberado : Boolean;
  dLimiteRecurso : Tdate;
begin
  bLiberado := (RecursoLiberado(IBTRANSACTION.DefaultDatabase,rcIntegracaoItau,dLimiteRecurso));

  if not bLiberado then
  begin
    MensagemSistema('Integração Itaú não está disponível para esta licença' + Chr(10) + Chr(10) +
                    _RecursoIndisponivel
                    ,msgAtencao);
    Exit;
  end;


  Result := False;

  try
    ibqItau := CriaIBQuery(IBTRANSACTION);
    ibqItau.SQL.Text := ' Select '+
                        ' 	I.USUARIO,'+
                        ' 	I.SENHA,'+
                        ' 	I.CLIENTID,'+
                        ' 	B.INSTITUICAOFINANCEIRA'+
                        ' From CONFIGURACAOITAU I'+
                        ' 	Left Join BANCOS B on B.IDBANCO = I.IDBANCO'+
                        ' Where I.HABILITADO = ''S'' ';
    ibqItau.Open;

    //Nenhum banco configurado com pix estático
    if ibqItau.IsEmpty then
    begin
      MensagemSistema('Nenhuma integração habilitada!',msgAtencao);
      Exit;
    end;

    if GeraChavePixItau(ibqItau.FieldByName('CLIENTID').AsString,
                        ibqItau.FieldByName('USUARIO').AsString,
                        ibqItau.FieldByName('SENHA').AsString,
                        IDTransacao,
                        Valor,
                        ChaveQRCode,
                        order_id,
                        Mensagem) then
    begin
      //Grava
      GravaTransacaoItau(NumeroNF,
                         Caixa,
                         order_id,
                         'Pendente',
                         Valor,
                         IBTRANSACTION.DefaultDatabase);
    end else
    begin
      MensagemSistema(Mensagem,msgAtencao);
      Exit;
    end;

    if PagamentoQRCodePIXDin(ChaveQRCode,
                             order_id,
                             Valor,
                             IBTRANSACTION.DefaultDatabase) then
    begin
      InstituicaoFinanceira := ibqItau.FieldByName('INSTITUICAOFINANCEIRA').AsString;
      Result := True;
    end;
  finally
    FreeAndNil(ibqItau);
  end;
end;

procedure GravaTransacaoItau(NumeroNF, Caixa, OrderID, Status : string; Valor : Double; IBDatabase: TIBDatabase);
var
  IBTSALVA: TIBTransaction;
  IBQSALVA: TIBQuery;
  sValor : string;
begin
  IBTSALVA    := CriaIBTransaction(IBDatabase);
  IBQSALVA    := CriaIBQuery(IBTSALVA);

  sValor := StringReplace(Valor.ToString,'.','',[rfReplaceAll]);
  sValor := StringReplace(sValor,',','.',[rfReplaceAll]);

  try
    IBQSALVA.SQL.Text := ' Insert into ITAUTRANSACAO(IDTRANSACAO,NUMERONF,CAIXA,ORDERID,DATAHORA,STATUS,VALOR)'+
                         ' Values('+
                         '(Select gen_id(G_ITAUTRANSACAO,1) From rdb$database),'+
                         QuotedStr(NumeroNF)+','+
                         QuotedStr(Caixa)+','+
                         QuotedStr(OrderID)+','+
                         'CURRENT_TIMESTAMP,'+
                         QuotedStr(Status)+','+
                         sValor+
                         ')' ;
    IBQSALVA.ExecSQL;
    IBTSALVA.Commit;
  finally
    FreeAndNil(IBQSALVA);
    FreeAndNil(IBTSALVA);
  end;
end;

procedure AtualizaStatusTransacaoItau(OrderID, Status : string; IBDatabase: TIBDatabase);
var
  IBTSALVA: TIBTransaction;
  IBQSALVA: TIBQuery;
begin
  IBTSALVA    := CriaIBTransaction(IBDatabase);
  IBQSALVA    := CriaIBQuery(IBTSALVA);

  try
    IBQSALVA.SQL.Text := ' Update ITAUTRANSACAO '+
                         '   set STATUS = '+ QuotedStr(Status)+
                         ' Where ORDERID = '+ QuotedStr(OrderID) ;
    IBQSALVA.ExecSQL;
    IBTSALVA.Commit;
  finally
    FreeAndNil(IBQSALVA);
    FreeAndNil(IBTSALVA);
  end;
end;

end.
