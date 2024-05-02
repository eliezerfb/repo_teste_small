unit uPagamentoPix;

interface

uses
  IBX.IBCustomDataSet, System.SysUtils, System.IniFiles, IBX.IBQuery,
  IBX.IBDatabase;

  function FormaPagamentoPix(DataSet : TibDataSet) : integer;
  function PagamentoPixEstatico(Valor : double; out InstituicaoFinanceira : string; IBTRANSACTION: TIBTransaction):boolean;
  function GeraChavePixEstatica(pixtipochave,pixtitular,municipio,pixchave : string; Valor : Double ):string;

implementation

uses uConectaBancoSmall, ufrmSelecionarPIX, ufrmQRCodePixEst;


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

        if Copy(FrenteIni.ReadString('NFCE', 'Ordem forma extra 1', '99'), 1, 2) = '17' then
          Result := i;
      finally
        FreeAndNil(FrenteIni);
      end;
    end;
  end;
end;

function PagamentoPixEstatico(Valor : double; out InstituicaoFinanceira : string; IBTRANSACTION: TIBTransaction):boolean;
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
                          ' 	Left Join EMITENTE E on 1=1';
    ibqBancos.Open;
    ibqBancos.Last; //Para funcionar RecordCount

    //Nenhum banco configurado com pix estático
    if ibqBancos.IsEmpty then
      Exit;

    //Se tiver mais que um configurado abre tela para selecionar
    if ibqBancos.RecordCount > 1 then
    begin
      ibqBancos.First;

      if not SelecionaChavePIX(ibqBancos) then
        Exit;
    end;

    ChaveQRCode := GeraChavePixEstatica(ibqBancos.FieldByName('PIXTIPOCHAVE').AsString,
                                        ibqBancos.FieldByName('PIXTITULAR').AsString,
                                        ibqBancos.FieldByName('MUNICIPIO').AsString,
                                        ibqBancos.FieldByName('PIXCHAVE').AsString,
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

function GeraChavePixEstatica(pixtipochave,pixtitular,municipio,pixchave : string; Valor : Double ):string;
begin
  Result := pixtipochave+pixtitular+municipio+pixchave;
end;

end.
