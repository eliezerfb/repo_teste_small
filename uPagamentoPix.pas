unit uPagamentoPix;

interface

uses
  IBX.IBCustomDataSet, System.SysUtils, System.IniFiles, IBX.IBQuery,
  IBX.IBDatabase;

  function FormaPagamentoPix(DataSet : TibDataSet) : integer;
  function PagamentoPixEstatico(Valor : double; IDTransacao : string; out InstituicaoFinanceira : string; IBTRANSACTION: TIBTransaction):boolean;
  function GeraChavePixEstatica(pixtitular,municipio,pixchave,pixTipochave,IDTransacao : string; Valor : Double ):string;

implementation

{$R-} //Desativa Range check error

uses
  uConectaBancoSmall
  , ufrmSelecionarPIX
  , ufrmQRCodePixEst, uDialogs, smallfunc_xe;


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

function FormaPagamentoPix(DataSet : TibDataSet) : integer;
var
  i : integer;
  CampoV : string;
  FrenteIni: TIniFile;
begin
  Result := 0;

  for I := 1 to 8 do
  begin
    CampoV := 'VALOR0'+IntToStr(i);

    //Verifica se forma foi usada
    if DataSet.FieldByName(CampoV).AsFloat > 0 then
    begin
      //Verifica se a forma está configurada como PIX
      try
        FrenteIni  := TIniFile.Create('FRENTE.INI');

        if Copy(FrenteIni.ReadString('NFCE', 'Ordem forma extra '+I.ToString, '99'), 1, 2) = '17' then
          Result := i;
      finally
        FreeAndNil(FrenteIni);
      end;
    end;
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
    municipio  := ConverteAcentos(municipio);

    PayloadFormat         := '000201';
    MerchantAccount       := '0014BR.GOV.BCB.PIX'+'01'+TamanhoTexto(pixchave)+pixchave;
    MerchantAccount       := '26'+TamanhoTexto(MerchantAccount)+MerchantAccount;
    MerchantCategoryCode  := '52040000';
    TransactionCurrency   := '5303986'; //Real Brasileiro
    TransactionAmount     :=  StringReplace(FormatFloat( '#,##0.00', Valor) , ',','.',[rfReplaceAll]);
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

end.
