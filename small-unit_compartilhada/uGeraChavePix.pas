unit uGeraChavePix;

interface

uses
  System.SysUtils, smallfunc_xe;

  function GeraChavePixEstatica(pixtitular,municipio,pixchave,pixTipochave,IDTransacao : string; Valor : Double ):string;

implementation

{$R-} //Desativa Range check error


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


end.
