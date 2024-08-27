unit uTransmiteNFSe;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages,
  Classes, Graphics, Controls,
  Forms, Dialogs, Grids, DBGrids, DB,
  ExtCtrls, Menus,
  IniFiles,
  smallfunc_xe, Mask, DBCtrls,
  shellapi,
  IBTable, IBQuery, IBDatabaseInfo,
  Math, pngimage, strUtils, Buttons;

  function GetCidadeUF: String; // Sandro Silva 2023-10-02
  function CalculaValorISS(sPadrao: String; dTotal: Double; dAliquota: Double;
    dBase: Double): Real;
  function TransmiteNFSE : boolean;
  procedure LimpaNFSE;

implementation

uses Unit7, Mais, uSmallConsts, unit29, StdCtrls, uDialogs, uArquivosDAT;

function GetCidadeUF: String;
begin
  Result := AnsiUpperCase(StringReplace(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString),' ','', [rfReplaceAll]) + Form7.ibDAtaset13ESTADO.AsString);
end;

{Sandro Silva 2023-10-02 inicio}
function CalculaValorISS(sPadrao: String; dTotal: Double; dAliquota: Double; dBase: Double): Real;
begin
  Result := (dTotal * dAliquota) / 100 * dBase / 100;
  if (sPadrao = 'ISSNETONLINE20') and (GetCidadeUF = 'ITAUNAMG') then
    Result := (Int(Result * 100)) / 100 // Trunca duas casas decimais
  else
    Result := StrToFloat(FormatFloat('0.00', Result)); // Arredonda duas casas decimais
end;
{Sandro Silva 2023-10-02 fim}

{Sandro Silva 2024-04-24 inicio}
function CalculaValorISSRetido(sPadrao: String; dTotal: Double; dAliquota: Double; dBase: Double): Real;
begin
  Result := (dTotal * dAliquota) / 100 * dBase / 100;

  if (sPadrao = 'ISSNETONLINE20') and (GetCidadeUF = 'ITAUNAMG') then
    Result := (Int(Result * 100)) / 100 // Trunca duas casas decimais
  else
    Result := StrToFloat(FormatFloat('0.00', Result)); // Arredonda duas casas decimais
end;
{Sandro Silva 2024-04-24 fim}

function TransmiteNFSE : boolean;
var
  Mais1Ini : tIniFile;
  _file1, _file, _XML : TStringList;

  vRegistro : string;

  nLengthEdit1, nLengthEdit2: Integer;

  bMultiplosServicos : Boolean;
  sDescricaoDosServicos, sPadraoCidade, sCodigoCnae, sCodigoLocalPrestacao, sRetornoNFse, sArquivoXML : String;
  sCodigoCnaePrestador: String; // Sandro Silva 2023-02-28

  F: TextFile;
  I, J: Integer;

  fValorISSRetido, fValorImpostosFederaisRetidos : Real;
  sPadraoSistema, sTipoPagamentoAPrazo: String;
  sResponsavelRetencao: String; // Sandro Silva 2023-01-19
  ComplementoOBS : string;//Mauricio Parizotto 2023-09-12


  sCpfCnpjTomador: String;
  sRazaoSocialTomador: String;
  sInscricaoEstadualTomador: String;
  sInscricaoMunicipalTomador: String;
  sTipoLogradouroTomador: String;
  sEnderecoTomador: String;
  sNumeroTomador: String;
  sComplementoTomador: String;
  sBairroTomador: String;

  sCodigoCidadeTomador: String;
  sDescricaoCidadeTomador: String;
  sUfTomador: String;
  sCepTomador: String;
  sPaisTomador: String;

  sDDDTomador: String;
  sTelefoneTomador: String;
  sEmailTomador: String;

  ConfSistema : TArquivosDAT;
  sObsNaDescricao : Boolean;
  sCalculoDoDescontoPeloProvedor: String; // Sandro Silva 2024-03-25
  bNaoDescontarIssQuandoRetido: Boolean; // Sandro Silva 2024-04-24
  dValorLiquidoNfse: Double; // Sandro Silva 2024-04-24

  procedure InformaCodVerificadorAutenticidadeParaIPM;
  begin
    if Pos('Codigo de autenticacao da NFSe',Form7.ibDAtaSet15RECIBOXML.AsString) <> 0 then
    begin
      Writeln(F,'<NumeroDaNFSe>'+LimpaNumero(Copy(Form7.ibDAtaSet15RECIBOXML.AsString,Pos('Codigo de autenticacao da NFSe',Form7.ibDAtaSet15RECIBOXML.AsString)+32,16))+'</NumeroDaNFSe>');
    end else
    begin
      if RetornaValorDaTagNoCampo('cod_verificador_autenticidade',Form7.ibDAtaSet15RECIBOXML.AsString) <> '' then
        Writeln(F,'<NumeroDaNFSe>'  + RetornaValorDaTagNoCampo('cod_verificador_autenticidade',Form7.ibDAtaSet15RECIBOXML.AsString) + '</NumeroDaNFSe>')
      else
        Writeln(F,'<NumeroDaNFSe>'+AllTrim(StrTran(Form7.ibDAtaSet15NFEPROTOCOLO.AsString,'/001',''))+'</NumeroDaNFSe>');
    end;
  end;

  //Identifica se existe configuração de como o desconto será aplicado no total da NFSe ao ser transitido
  procedure CriaConfiguracaoDeComoDescontoSeraAplicado;
  begin
    if ((sPadraoSistema = 'SAATRI') and (GetCidadeUF = 'BOAVISTARR'))
              or ((sPadraoSistema = 'EL20') and (GetCidadeUF = 'PETROLINAPE')) then
    begin
      if ConfSistema.BD.NFSe.CalculoDoDescontoPeloProvedor = '' then
        ConfSistema.BD.NFSe.CalculoDoDescontoPeloProvedor := 'Sim';
    end;
  end;

begin
  Result := False;

  // Zerezima
  fValorImpostosFederaisRetidos := 0;

  // Antes de tudo atualiza a data
  try
    if Form7.ibDataSet15EMITIDA.AsString <> 'S' then
    begin
      if not (Form7.ibDataset15.State in ([dsEdit, dsInsert])) then
        Form7.ibDataset15.Edit;
      Form7.ibDataSet15EMISSAO.Value       := Date;
      Form7.ibDataset15.Post;
      Form7.ibDataset15.Edit;
    end;
  except
  end;

  // Multiplos Serviços
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfseConfig.ini');

  if (Mais1Ini.ReadString('Informacoes obtidas na prefeitura','MultiplosServicos','?') = '?') or (Mais1Ini.ReadString('Informacoes obtidas na prefeitura','Padrao','?') = '?') then
  begin
    try
      _file := TStringList.Create;
      _file.LoadFromFile(pChar(Form1.sAtual+'\NFSE\CidadesHomologadas.XML'));

      sPadraoCidade        := RetornaValorDaTagNoCampo(UpperCase(StrTran(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString),' ',''))+UpperCase(Form7.ibDAtaset13ESTADO.AsString),_File.Text);

      if pos('<Multiservicos>False</Multiservicos>',sPadraoCidade) <> 0 then
      begin
        Mais1Ini.WriteString('Informacoes obtidas na prefeitura','MultiplosServicos','NAO');
        bMultiplosServicos := False;
      end else
      begin
        Mais1Ini.WriteString('Informacoes obtidas na prefeitura','MultiplosServicos','SIM');
        bMultiplosServicos := True;
      end;

      Mais1Ini.WriteString('Informacoes obtidas na prefeitura','Padrao',RetornaValorDaTagNoCampo('Padrao',sPadraoCidade));
    except
      Mais1Ini.WriteString('Informacoes obtidas na prefeitura','MultiplosServicos','NAO');
      bMultiplosServicos := False;// True;
    end;
  end else
  begin
    if Mais1Ini.ReadString('Informacoes obtidas na prefeitura','MultiplosServicos','?') = 'SIM' then
    begin
      bMultiplosServicos := True;
    end else
    begin
      bMultiplosServicos := False;
    end;
  end;

  if Mais1Ini.ReadString('Informacoes obtidas na prefeitura','IncentivadorCultural'     ,'') = '' then
    Mais1Ini.WriteString('Informacoes obtidas na prefeitura','IncentivadorCultural'     ,'2');
  if Mais1Ini.ReadString('Informacoes obtidas na prefeitura','RegimeEspecialTributacao' ,'') = '' then
    Mais1Ini.WriteString('Informacoes obtidas na prefeitura','RegimeEspecialTributacao' ,'1');
  if Mais1Ini.ReadString('Informacoes obtidas na prefeitura','NaturezaTributacao'       ,'') = '' then
    Mais1Ini.WriteString('Informacoes obtidas na prefeitura','NaturezaTributacao'       ,'1');
  if Mais1Ini.ReadString('Informacoes obtidas na prefeitura','IncentivoFiscal'          ,'') = '' then
    Mais1Ini.WriteString('Informacoes obtidas na prefeitura','IncentivoFiscal'          ,'1');
  if Mais1Ini.ReadString('Informacoes obtidas na prefeitura','TipoTributacao'           ,'') = '' then
    Mais1Ini.WriteString('Informacoes obtidas na prefeitura','TipoTributacao'           ,'6');
  if Mais1Ini.ReadString('Informacoes obtidas na prefeitura','ExigibilidadeISS'         ,'') = '' then
    Mais1Ini.WriteString('Informacoes obtidas na prefeitura','ExigibilidadeISS'         ,'1');
  if Mais1Ini.ReadString('Informacoes obtidas na prefeitura','Operacao'                 ,'') = '' then
    Mais1Ini.WriteString('Informacoes obtidas na prefeitura','Operacao'                 ,'A');
  {Sandro Silva 2023-03-22 inicio
  Ficha 6611 - não usar o CNAE da tabela emitente (CNAE para produtos) para os serviços
  if Mais1Ini.ReadString('Informacoes obtidas na prefeitura','CodigoCnae'               ,'') = '' then
    Mais1Ini.WriteString('Informacoes obtidas na prefeitura','CodigoCnae'               ,pchar(Form7.ibDataSet13CNAE.AsString) );
  }
  if Mais1Ini.ReadString('Informacoes obtidas na prefeitura','TipoPagamentoPrazo'       ,'') = '' then
    Mais1Ini.WriteString('Informacoes obtidas na prefeitura','TipoPagamentoPrazo'       ,'3');

  sPadraoSistema       := UpperCase(Mais1Ini.ReadString('Informacoes obtidas na prefeitura','Padrao','?'));

  sTipoPagamentoAPrazo := Mais1Ini.ReadString('Informacoes obtidas na prefeitura','TipoPagamentoPrazo'       ,'3');

  sResponsavelRetencao := Mais1Ini.ReadString('NFSE', 'ResponsavelRetencao', ''); // Sandro Silva 2023-01-24

  if (Mais1Ini.ReadString('NFSE','CNPJ','')<>LimpaNumero(Form7.ibDAtaset13CGC.AsString)) or
     // Sandro Silva 2023-09-05 (Mais1Ini.ReadString('NFSE','CIDADE','')<>UpperCase(StrTran(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString),' ',''))+UpperCase(Form7.ibDAtaset13ESTADO.AsString)) or
     (Mais1Ini.ReadString('NFSE','CIDADE','')<> GetCidadeUF) or
     (Mais1Ini.ReadString('NFSE','InscricaoMunicipal','')<>LimpaNumero(Form7.ibDAtaset13IM.AsString)) then
  begin
    Mais1ini.Free;
    Form1.ConfiguraesdaNFSe2Click(nil);
  end else
  begin
    Mais1ini.Free;
  end;

  {Mauricio Parizotto 2023-12-05 Inicio}
  try
    // Sandro Silva 2024-04-24 ConfSistema := TArquivosDAT.Create(Usuario,Form7.ibDataSet3.Transaction);
    ConfSistema := TArquivosDAT.Create(Usuario,Form7.ibDataSet13.Transaction);

    //Seta configuração para Padrões
    if (sPadraoSistema = 'ABACO20') and (AnsiUpperCase(StringReplace(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString), ' ', '', [rfReplaceAll]) + Form7.ibDataSet13ESTADO.AsString) = 'RIOBRANCOAC')
      or (sPadraoSistema = 'GINFES')
      or (sPadraoSistema = 'FINTEL')
      or ((sPadraoSistema = 'WEBISS20') and (AnsiUpperCase(StringReplace(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString), ' ', '', [rfReplaceAll]) + Form7.ibDataSet13ESTADO.AsString) = 'ITANHANGAMT') )
      then
    begin
      //Só vai marcar como True se não tiver configuração ainda
      if ConfSistema.BD.NFSe.ConfObsNaDescricao = '' then
        ConfSistema.BD.NFSe.ObsNaDescricao := True;
    end;

    CriaConfiguracaoDeComoDescontoSeraAplicado;
    sCalculoDoDescontoPeloProvedor := ConfSistema.BD.NFSe.CalculoDoDescontoPeloProvedor; // Sandro Silva 2024-03-25
    bNaoDescontarIssQuandoRetido   := ConfSistema.BD.NFSe.NaoDescontarIssQuandoRetido = 'Sim'; // Sandro Silva 2024-04-24

    sObsNaDescricao := ConfSistema.BD.NFSe.ObsNaDescricao;
  finally
    FreeAndNil(ConfSistema);
  end;
  {Mauricio Parizotto 2023-12-05 Fim}


  try
    if Form1.ExisteNfseExe(Form1.sAtual) then
    begin
      // Já foi autorizada
      if (Pos('ChaveDeCancelamento',Form7.ibDataSet15RECIBOXML.AsString) = 0) or (Form1.sConsultaNfse = 'SIM') then
      begin
        // Serviços Zerado
        if Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat > 0 then
        begin
          // Em Processamento
          if (RetornaValorDaTagNoCampo('Status',Form7.ibDAtaSet15RECIBOXML.AsString) = 'EM PROCESSAMENTO') or (Form1.sConsultaNfse = 'SIM') then
          begin
            AssignFile(F,pChar(Form1.sAtual+'\NFSE\smallnfse.tx2'));  // Direciona o arquivo F para EXPORTA.TXT
            Rewrite(F);
            
            Writeln(F,'<Status>EM PROCESSAMENTO</Status>');
            Writeln(F,'<tx2>'+AllTrim(RetornaValorDaTagNoCampoCRLF('tx2',Form7.ibDAtaSet15RECIBOXML.AsString))+'</tx2>');
            Writeln(F,'<XMLdeEvio>'+AllTrim(Form7.ibDAtaSet15NFEXML.AsString)+'</XMLdeEvio>');
            if RetornaValorDaTagNoCampo('Motivo'      ,Form7.ibDAtaSet15RECIBOXML.AsString) <> '' then
              Writeln(F,'<Motivo>'        + RetornaValorDaTagNoCampo('Motivo'      ,Form7.ibDAtaSet15RECIBOXML.AsString) + '</Motivo>')
            else
              Writeln(F,'<Motivo></Motivo>');
              
            begin
              if (sPadraoSistema = 'MEMORY') then
              begin
                Writeln(F,'<NumeroDaNFSe></NumeroDaNFSe>');
                // 2022-07-14 Writeln(F,'<NumeroDoRPS>'+IntToStr(StrToInt(Form7.ibDataSet15NUMERONF.AsString))+'</NumeroDoRPS>'); // Tirar os Zeros a esquerda do numero do rps
                Writeln(F,'<NumeroDoRPS>'+IntToStr(StrToInt(LimpaNumero(Form7.ibDataSet15NUMERONF.AsString)))+'</NumeroDoRPS>'); // Tirar os Zeros a esquerda do numero do rps
                Writeln(F,'<SerieDoRPS>001</SerieDoRPS>');
                Writeln(F,'<Tipo>1</Tipo>');
                Writeln(F,'<Protocolo></Protocolo>');
              end else
              begin
                if (sPadraoSistema = 'ABASE') then
                begin
                  Writeln(F,'<NumeroDaNFSe></NumeroDaNFSe>');
                  Writeln(F,'<NumeroDoRPS>'+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9)+'</NumeroDoRPS>');
                  Writeln(F,'<SerieDoRPS>001</SerieDoRPS>');
                  Writeln(F,'<Tipo>1</Tipo>');
                  Writeln(F,'<Protocolo></Protocolo>');
                end else
                begin
                  if (sPadraoSistema = 'SIL20') then
                  begin
                    Writeln(F,'<NumeroDoRPS>'+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9)+'</NumeroDoRPS>');
                    Writeln(F,'<SerieDoRPS>001</SerieDoRPS>');
                    Writeln(F,'<Tipo>1</Tipo>');
                    Writeln(F,'<Protocolo></Protocolo>');
                  end else
                  begin
                    if (sPadraoSistema = 'IPM') then
                    begin
                      InformaCodVerificadorAutenticidadeParaIPM;
                    end else
                    begin
                                            //
                      if (sPadraoSistema = 'IPM20') then
                      begin
                        InformaCodVerificadorAutenticidadeParaIPM; // Sandro Silva 2022-10-10
                        Writeln(F,'<SerieDoRPS>01</SerieDoRPS>');
                      end else
                      {Sandro Silva 2023-01-25 inicio}
                      // Sandro Silva 2023-09-05 if (sPadraoSistema = 'ISSNETONLINE20') and (AnsiUpperCase(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString) + Form7.ibDataSet13ESTADO.AsString) = 'BRASILIADF') then
                      if (sPadraoSistema = 'ISSNETONLINE20') and (GetCidadeUF = 'BRASILIADF') then
                      begin
                        if RetornaValorDaTagNoCampo('NumeroDaNFSe',Form7.ibDAtaSet15RECIBOXML.AsString) <> '' then
                          Writeln(F,'<NumeroDaNFSe>' + RetornaValorDaTagNoCampo('NumeroDaNFSe',Form7.ibDAtaSet15RECIBOXML.AsString) + '</NumeroDaNFSe>')
                        else
                          Writeln(F,'<NumeroDaNFSe>'+AllTrim(StrTran(Form7.ibDAtaSet15NFEPROTOCOLO.AsString,'/001',''))+'</NumeroDaNFSe>');
                        if StrToIntDef(LimpaNumero(RetornaValorDaTagNoCampo('NumeroDoRPS' ,Form7.ibDAtaSet15RECIBOXML.AsString)), 0) <> 0 then
                          Writeln(F,'<NumeroDoRPS>' + InttoStr(StrToIntDef(LimpaNumero(RetornaValorDaTagNoCampo('NumeroDoRPS' ,Form7.ibDAtaSet15RECIBOXML.AsString)), 0)) + '</NumeroDoRPS>') // ISSNETONLINE20 - Brasília aceita o RPS utilizando no máximo 5 dígitos
                        else
                          Writeln(F,'<NumeroDoRPS>'+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9)+'</NumeroDoRPS>');
                        if RetornaValorDaTagNoCampo('Tipo'        ,Form7.ibDAtaSet15RECIBOXML.AsString) <> '' then
                          Writeln(F,'<Tipo>'          + RetornaValorDaTagNoCampo('Tipo'        ,Form7.ibDAtaSet15RECIBOXML.AsString) + '</Tipo>')
                        else
                          Writeln(F,'<Tipo>1</Tipo>');
                        if RetornaValorDaTagNoCampo('Protocolo'   ,Form7.ibDAtaSet15RECIBOXML.AsString) <> '' then
                          Writeln(F,'<Protocolo>'     + RetornaValorDaTagNoCampo('Protocolo'   ,Form7.ibDAtaSet15RECIBOXML.AsString) + '</Protocolo>')
                        else
                          Writeln(F,'<Protocolo></Protocolo>');

                        if RetornaValorDaTagNoCampo('SerieDoRPS'  ,Form7.ibDAtaSet15RECIBOXML.AsString) <> '' then
                          Writeln(F,'<SerieDoRPS>'    + RetornaValorDaTagNoCampo('SerieDoRPS'  ,Form7.ibDAtaSet15RECIBOXML.AsString) + '</SerieDoRPS>')
                        else
                          Writeln(F,'<SerieDoRPS>3</SerieDoRPS>');
                      end
                      //else
                      {Sandro Silva 2023-01-25 fim}
                      {Sandro Silva 2023-09-05 inicio}
                      else if (sPadraoSistema = 'TECNOSISTEMAS') and (GetCidadeUF = 'SAOSEBASTIAODOCAIRS') then
                      begin
                        if RetornaValorDaTagNoCampo('NumeroDaNFSe',Form7.ibDAtaSet15RECIBOXML.AsString) <> '' then
                          Writeln(F,'<NumeroDaNFSe>'  + RetornaValorDaTagNoCampo('NumeroDaNFSe',Form7.ibDAtaSet15RECIBOXML.AsString) + '</NumeroDaNFSe>')
                        else
                          Writeln(F,'<NumeroDaNFSe>'+AllTrim(StrTran(Form7.ibDAtaSet15NFEPROTOCOLO.AsString,'/001',''))+'</NumeroDaNFSe>');
                        if RetornaValorDaTagNoCampo('NumeroDoRPS' ,Form7.ibDAtaSet15RECIBOXML.AsString) <> '' then
                          Writeln(F,'<NumeroDoRPS>'   + RetornaValorDaTagNoCampo('NumeroDoRPS' ,Form7.ibDAtaSet15RECIBOXML.AsString) + '</NumeroDoRPS>')
                        else
                          Writeln(F,'<NumeroDoRPS>'+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9)+'</NumeroDoRPS>');
                        if RetornaValorDaTagNoCampo('Tipo'        ,Form7.ibDAtaSet15RECIBOXML.AsString) <> '' then
                          Writeln(F,'<Tipo>'          + RetornaValorDaTagNoCampo('Tipo'        ,Form7.ibDAtaSet15RECIBOXML.AsString) + '</Tipo>')
                        else
                          Writeln(F,'<Tipo>1</Tipo>');
                        if RetornaValorDaTagNoCampo('Protocolo'   ,Form7.ibDAtaSet15RECIBOXML.AsString) <> '' then
                          Writeln(F,'<Protocolo>'     + RetornaValorDaTagNoCampo('Protocolo'   ,Form7.ibDAtaSet15RECIBOXML.AsString) + '</Protocolo>')
                        else
                          Writeln(F,'<Protocolo></Protocolo>');

                        if RetornaValorDaTagNoCampo('SerieDoRPS'  ,Form7.ibDAtaSet15RECIBOXML.AsString) <> '' then
                          Writeln(F,'<SerieDoRPS>'    + RetornaValorDaTagNoCampo('SerieDoRPS'  ,Form7.ibDAtaSet15RECIBOXML.AsString) + '</SerieDoRPS>')
                        else
                          Writeln(F,'<SerieDoRPS>001</SerieDoRPS>');
                      end
                      {Sandro Silva 2023-09-05 fim}
                      else
                      begin
                        if RetornaValorDaTagNoCampo('NumeroDaNFSe',Form7.ibDAtaSet15RECIBOXML.AsString) <> '' then
                          Writeln(F,'<NumeroDaNFSe>'  + RetornaValorDaTagNoCampo('NumeroDaNFSe',Form7.ibDAtaSet15RECIBOXML.AsString) + '</NumeroDaNFSe>')
                        else
                          Writeln(F,'<NumeroDaNFSe>'+AllTrim(StrTran(Form7.ibDAtaSet15NFEPROTOCOLO.AsString,'/001',''))+'</NumeroDaNFSe>');
                        if RetornaValorDaTagNoCampo('NumeroDoRPS' ,Form7.ibDAtaSet15RECIBOXML.AsString) <> '' then
                          Writeln(F,'<NumeroDoRPS>'   + RetornaValorDaTagNoCampo('NumeroDoRPS' ,Form7.ibDAtaSet15RECIBOXML.AsString) + '</NumeroDoRPS>')
                        else
                          Writeln(F,'<NumeroDoRPS>'+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9)+'</NumeroDoRPS>');
                        if RetornaValorDaTagNoCampo('Tipo'        ,Form7.ibDAtaSet15RECIBOXML.AsString) <> '' then
                          Writeln(F,'<Tipo>'          + RetornaValorDaTagNoCampo('Tipo'        ,Form7.ibDAtaSet15RECIBOXML.AsString) + '</Tipo>')
                        else
                          Writeln(F,'<Tipo>1</Tipo>');
                        if RetornaValorDaTagNoCampo('Protocolo'   ,Form7.ibDAtaSet15RECIBOXML.AsString) <> '' then
                          Writeln(F,'<Protocolo>'     + RetornaValorDaTagNoCampo('Protocolo'   ,Form7.ibDAtaSet15RECIBOXML.AsString) + '</Protocolo>')
                        else
                          Writeln(F,'<Protocolo></Protocolo>');

                        if RetornaValorDaTagNoCampo('SerieDoRPS'  ,Form7.ibDAtaSet15RECIBOXML.AsString) <> '' then
                          Writeln(F,'<SerieDoRPS>'    + RetornaValorDaTagNoCampo('SerieDoRPS'  ,Form7.ibDAtaSet15RECIBOXML.AsString) + '</SerieDoRPS>')
                        else
                          Writeln(F,'<SerieDoRPS>001</SerieDoRPS>');
                      end;
                      {Sandro Silva 2022-10-18 fim}
                    end;
                  end;
                end;
              end;
            end;
            // teste enviando o xml de envio para resolver o problema de não imprimir todos os dados no .PDF
          end else
          begin
            // Gera e envia o arquivo da NFSE
            Form7.ibDataSet14.Close;
            Form7.ibDataSet14.SelectSQL.Clear;
            Form7.ibDataSet14.SelectSQL.Add('select * from ICM where NOME='+QuotedStr(Form7.ibDataSet15OPERACAO.AsString)+' ');
            Form7.ibDataSet14.Open;

            Form7.ibDataSet2.Close;
            Form7.ibDataSet2.Selectsql.Clear;
            Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet15CLIENTE.AsString)+' ');  //
            Form7.ibDataSet2.Open;

            Form7.ibDataset99.Close;
            Form7.ibDataset99.SelectSql.Clear;
            Form7.ibDataset99.SelectSQL.Add('select * from MUNICIPIOS where NOME='+QuotedStr(Form7.ibDataSet13MUNICIPIO.AsString)+' '+' and UF='+QuotedStr(UpperCase(Form7.ibDataSet13ESTADO.AsString))+' ');
            Form7.ibDataset99.Open;

            sCodigoLocalPrestacao := Copy(Form7.ibDAtaSet99.FieldByname('CODIGO').AsString,1,7);
            
            while FileExists(Pchar(Form1.sAtual+'\NFSE\smallnfse.tx2')) do
            begin
              DeleteFile(Pchar(Form1.sAtual+'\NFSE\smallnfse.tx2'));
              Sleep(100);
            end;

            AssignFile(F,pChar(Form1.sAtual+'\NFSE\smallnfse.tx2'));  // Direciona o arquivo F para EXPORTA.TXT
            Rewrite(F);
            
            Writeln(F,'formato=tx2');
            Writeln(F,'padrao=TecnoNFSe');
            Writeln(F,'');
            Writeln(F,'INCLUIR');
            Writeln(F,'');
            
            if (sPadraoSistema = 'ABASE') or (sPadraoSistema = 'JOINVILLESC') then
            begin
              Writeln(F,'NumeroLote='+ IntToStr(StrToInt(Copy(Form7.ibDataSet15NUMERONF.AsString,3,7))) );
            end else
            {Sandro Silva 2023-01-09 inicio}
            // Sandro Silva 2023-09-05 if (sPadraoSistema = 'ISSNETONLINE20') and (AnsiUpperCase(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString) + Form7.ibDataSet13ESTADO.AsString) = 'BRASILIADF') then
            if (sPadraoSistema = 'ISSNETONLINE20') and (GetCidadeUF = 'BRASILIADF') then
            begin
              Writeln(F,'NumeroLote=' + IntToStr(StrToIntDef(Copy(Form7.ibDataSet15NUMERONF.AsString,1,9), 0)) );
            end else
            {Sandro Silva 2023-01-09 fim}
            {Sandro Silva 2023-09-05 inicio}
            if (sPadraoSistema = 'TECNOSISTEMAS') and (GetCidadeUF = 'SAOSEBASTIAODOCAIRS') then
            begin
              Writeln(F,'NumeroLote=' + IntToStr(StrToIntDef(Copy(Form7.ibDataSet15NUMERONF.AsString,1,9), 0)) );
            end else
            {Sandro Silva 2023-09-05 fim}
            begin
              Writeln(F,'NumeroLote='+ IntToStr(Trunc(Now*1000000)) );
            end;

            Writeln(F,'CPFCNPJRemetente='+LimpaNumero(Form7.ibDAtaSet13CGC.AsString));             // CNPJ do Emitente
            Writeln(F,'InscricaoMunicipalRemetente='+LimpaNumero(Form7.ibDAtaSet13IM.AsString));   // IM do Emitente

            if (sCalculoDoDescontoPeloProvedor = 'Sim') then //Sandro Silva 2024-03-25 if (sPadraoSistema = 'SAATRI') and (GetCidadeUF = 'BOAVISTARR') then
              Writeln(F,'ValorTotalServicos='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat)),',','.')) // Valor Total de serviços
            else
              Writeln(F,'ValorTotalServicos='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat)),',','.')); // Valor Total de serviços
            Writeln(F,'ValorTotalDeducoes=0.00');
            Writeln(F,'ValorTotalBaseCalculo='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat)),',','.')); // Valor Total de serviços

            Writeln(F,'SALVAR');
            Writeln(F,'');
            Writeln(F,'INCLUIRRPS');
            Writeln(F,'');
            
            {Sandro Silva 2023-01-09 inicio}
            // Sandro Silva 2023-09-05 if (sPadraoSistema = 'ISSNETONLINE20') and (AnsiUpperCase(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString) + Form7.ibDataSet13ESTADO.AsString) = 'BRASILIADF') then
            if (sPadraoSistema = 'ISSNETONLINE20') and (GetCidadeUF = 'BRASILIADF') then
            begin
              Writeln(F,'NumeroRps=' + IntToStr(StrToIntDef(Copy(Form7.ibDataSet15NUMERONF.AsString,1,9), 0)));  // Número sequencial do RPS
            end else
            {Sandro Silva 2023-01-09 fim}
            begin
              if (sPadraoSistema = 'PRESCON') and (GetCidadeUF = 'CAMPOSDOJORDAOSP') then
                Writeln(F,'NumeroRps='+Copy(Copy(Form7.ibDataSet15NUMERONF.AsString,1,9),4,6))  // Número sequencial do RPS
              else
                Writeln(F,'NumeroRps='+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9));  // Número sequencial do RPS
            end;

            if (sPadraoSistema = 'IPM20') then
            begin
              Writeln(F,'SerieRps=01');    // Série
            end else
            {Sandro Silva 2023-01-09 inicio}
            // Sandro Silva 2023-09-05 if (sPadraoSistema = 'ISSNETONLINE20') and (AnsiUpperCase(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString) + Form7.ibDataSet13ESTADO.AsString) = 'BRASILIADF') then
            if (sPadraoSistema = 'ISSNETONLINE20') and (GetCidadeUF = 'BRASILIADF') then
            begin
              Writeln(F,'SerieRps=3');    // Série   Brasília fixo 3
            end else
            {Sandro Silva 2023-01-09 fim}
            {Sandro Silva 2023-08-22 inicio}
            // Sandro Silva 2023-09-05 if (sPadraoSistema = 'ISSNETONLINE20') and (AnsiUpperCase(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString) + Form7.ibDataSet13ESTADO.AsString) = 'ITAUNAMG') then
            if (sPadraoSistema = 'ISSNETONLINE20') and (GetCidadeUF = 'ITAUNAMG') then
            begin
              Writeln(F,'SerieRps=1');    // Série Itaúna MG, padrão ISSNETONLINE20, não deve ter zeros a esquerda
            end else
            {Sandro Silva 2023-08-22 fim}
            begin
              Writeln(F,'SerieRps=001');    // Série
            end;

            Writeln(F,'TipoRps=1');      // Informar sempre 1
            Writeln(F,'SituacaoNota=1'); // Situação da nota: 1 - Normal. 2 - Cancelada.

            Writeln(F,'DataEmissao='+StrTran(DateToStrInvertida(Form7.ibDataSet15.FieldByname('EMISSAO').AsDateTime),'/','-')+'T'+TimeToStr(Time)); // Data de Emissão da Nota Fiscal
            Writeln(F,'Competencia='+StrTran(DateToStrInvertida(Form7.ibDataSet15.FieldByname('EMISSAO').AsDateTime),'/','-')); // Data da competência do RPS

            Writeln(F,'CpfCnpjPrestador='+LimpaNumero(Form7.ibDAtaSet13CGC.AsString)); // CPF / CNPJ do prestador do serviço
            Writeln(F,'InscricaoMunicipalPrestador='+LimpaNumero(Form7.ibDAtaSet13IM.AsString));  // Inscrição municipal do prestador do serviço
            Writeln(F,'RazaoSocialPrestador='+ConverteAcentos2(Form7.ibDAtaSet13NOME.AsString));  // Razão Social do prestador do serviço
            Writeln(F,'InscricaoEstadualPrestador='+LimpaNumero(Form7.ibDAtaSet13IE.AsString));   // Inscrição Estadual do prestador do serviço

            Writeln(F,'TipoLogradouroPrestador=Rua');
            {Sandro Silva 2022-10-04 inicio
            Writeln(F,'EnderecoPrestador='+ConverteAcentos2(Endereco_Sem_Numero(ibDAtaset13.FieldByname('ENDERECO').AsString))); // Logradouro do Emitente
            }
            if (sPadraoSistema = 'JOINVILLESC') then
              Writeln(F,'EnderecoPrestador='+ConverteAcentos2(Endereco_Sem_Numero(Form7.ibDAtaset13.FieldByname('ENDERECO').AsString) + ', ' + Numero_Sem_Endereco(Form7.ibDAtaset13.FieldByname('ENDERECO').AsString) + ' - ' + Form7.ibDAtaSet13COMPLE.AsString)) // Logradouro do Emitente
            else
              Writeln(F,'EnderecoPrestador='+ConverteAcentos2(Endereco_Sem_Numero(Form7.ibDAtaset13.FieldByname('ENDERECO').AsString))); // Logradouro do Emitente
            {Sandro Silva 2022-10-04 fim}
            Writeln(F,'NumeroPrestador='+Numero_Sem_Endereco(Form7.ibDAtaset13.FieldByname('ENDERECO').AsString)); // Numero do Logradouro do Emitente
            
            Writeln(F,'ComplementoPrestador='+ConverteAcentos2(Form7.ibDAtaSet13NOME.AsString)); // Complemento
            Writeln(F,'TipoBairroPrestador=');
            Writeln(F,'BairroPrestador='+ConverteAcentos2(Form7.ibDAtaSet13COMPLE.AsString)); // Bairro
            Writeln(F,'CodigoCidadePrestador='+Copy(Form7.ibDAtaSet99.FieldByname('CODIGO').AsString,1,7)); // Código da Cidade do Emitente (Tabela do IBGE)

            Writeln(F,'DescricaoCidadePrestador='+ConverteAcentos2(Form7.ibDAtaSet13MUNICIPIO.AsString)); // Municipio
            Writeln(F,'TelefonePrestador='+LimpaNumero(Form7.ibDAtaSet13TELEFO.AsString)); // Telefone
            Writeln(F,'EmailPrestador='+ConverteAcentos2(Form7.ibDAtaSet13EMAIL.AsString)); // E-mail
            Writeln(F,'CepPrestador='+LimpaNumero(Form7.ibDAtaSet13CEP.AsString));
            Writeln(F,'');

            //if Form7.ibDataSet13CRT.AsString = '1' then Mauricio Parizotto 2024-08-07
            if (Form7.ibDataSet13CRT.AsString = '1')
              or (Form7.ibDataSet13CRT.AsString = '4') then
            begin
              Writeln(F,'OptanteSimplesNacional=1');  // Indica se o prestador é optante do regime Simples Nacional	1 - SIM/ 2 -NÃO
            end else
            begin
              Writeln(F,'OptanteSimplesNacional=2');  // Indica se o prestador é optante do regime Simples Nacional	1 - SIM/ 2 -NÃO
            end;
            
            Mais1ini := TIniFile.Create(Form1.sAtual+'\nfseConfig.ini');
            Writeln(F,'IncentivadorCultural='     +Mais1Ini.ReadString('Informacoes obtidas na prefeitura','IncentivadorCultural'     ,'2')); //
            Writeln(F,'RegimeEspecialTributacao=' +Mais1Ini.ReadString('Informacoes obtidas na prefeitura','RegimeEspecialTributacao' ,'1')); //
            Writeln(F,'NaturezaTributacao='       +Mais1Ini.ReadString('Informacoes obtidas na prefeitura','NaturezaTributacao'       ,'1')); //
            Writeln(F,'IncentivoFiscal='          +Mais1Ini.ReadString('Informacoes obtidas na prefeitura','IncentivoFiscal'          ,'1')); // Campo que indica se há ou não incentivo fiscal	1 - SIM/ 2 - NÃO
            
            // Padrao BAURU
            if (sPadraoSistema = 'BAURU') then
            begin
              if (AnsiUpperCase(Form7.ibDAtaset2CIDADE.AsString)=AnsiUpperCase(Form7.ibDAtaset13MUNICIPIO.AsString)) and (Length(LimpaNumero(Form7.ibDataSet2CGC.AsString)) = 14) then
              begin
                Writeln(F,'TipoTributacao=5'); // Tipo da tributação do RPS  '1' - Isenta de ISS '2' - Imune '3' - Não Incidência no Município '4' - Não Tributável '5' - Retida '6' - Tributável dentro do município '7' - Tributável fora do município '8' – Tributável dentro do município pelo tomador
              end else
              begin
                Writeln(F,'TipoTributacao='           +Mais1Ini.ReadString('Informacoes obtidas na prefeitura','TipoTributacao'           ,'6')); // Tipo da tributação do RPS  '1' - Isenta de ISS '2' - Imune '3' - Não Incidência no Município '4' - Não Tributável '5' - Retida '6' - Tributável dentro do município '7' - Tributável fora do município '8' – Tributável dentro do município pelo tomador
              end;
            end else
            begin
              Writeln(F,'TipoTributacao='           +Mais1Ini.ReadString('Informacoes obtidas na prefeitura','TipoTributacao'           ,'6')); // Tipo da tributação do RPS  '1' - Isenta de ISS '2' - Imune '3' - Não Incidência no Município '4' - Não Tributável '5' - Retida '6' - Tributável dentro do município '7' - Tributável fora do município '8' – Tributável dentro do município pelo tomador
            end;
            
            Writeln(F,'ExigibilidadeISS='         +Mais1Ini.ReadString('Informacoes obtidas na prefeitura','ExigibilidadeISS'         ,'1')); // 1  - Exigível,  2  - Não incidência,  3  - Isenção,  4  - Exportação,   5  - Imunidade,  6  - Exigibilidade Suspensa por Decisão Judicial,  7  - Exigibilidade Suspensa por Processo Administrativo.
            Writeln(F,'Operacao='                 +Mais1Ini.ReadString('Informacoes obtidas na prefeitura','Operacao'                 ,'A')); //

            sCodigoCnae := Mais1Ini.ReadString('Informacoes obtidas na prefeitura','CodigoCnae'               ,''); // // CodigoCnae	Código do CNAE	T	 Obtido na prefeitura
            sCodigoCnaePrestador := sCodigoCnae; // CNAE do prestador Sandro Silva 2023-02-28

            {Dailon Parisotto (f-7379) 2023-09-15 Inicio}
            if (sPadraoSistema = 'GOVBR20') and (GetCidadeUF = 'DOMPEDRITORS') then
            begin
              nLengthEdit1 := Form29.Edit_01.MaxLength;
              nLengthEdit2 := Form29.Edit_02.MaxLength;
              try
                Form29.Label_01.Visible := True;
                Form29.Label_02.Visible := True;
                Form29.Label_03.Visible := False;
                Form29.Label_04.Visible := False;
                Form29.Label_05.Visible := False;
                Form29.Label_06.Visible := False;


                Form29.Edit_01.MaxLength := 15;
                Form29.Edit_02.MaxLength := 15;

                Form29.Edit_01.Visible := True;
                Form29.Edit_02.Visible := True;
                Form29.Edit_03.Visible := False;
                Form29.Edit_04.Visible := False;
                Form29.Edit_05.Visible := False;
                Form29.Edit_06.Visible := False;

                Form29.Label_01.Caption := 'Matrícula CEI/CNO da Obra:';
                Form29.Label_02.Caption := 'Anotação de responsabilidade técnica - ART:';

                Form29.Edit_01.Text := EmptyStr;
                Form29.Edit_02.Text := EmptyStr;

                Form1.Small_InputForm_Dados('Construção civil');

                if Trim(Form29.Edit_01.Text) <> EmptyStr then
                  Writeln(F,'CodigoObra=' + Copy(Form29.Edit_01.Text, 1, 15))
                else
                  Writeln(F,'CodigoObra=' + _cNaoSeAplica);
                if Trim(Form29.Edit_02.Text) <> EmptyStr then
                  Writeln(F,'Art=' + Copy(Form29.Edit_02.Text, 1, 15))
                else
                  Writeln(F,'Art=' + _cNaoSeAplica);
              finally
                Form29.Edit_01.MaxLength := nLengthEdit1;
                Form29.Edit_02.MaxLength := nLengthEdit2;
              end;
            end;
            {Dailon Parisotto (f-7379) 2023-09-15 Fim}

            Writeln(F,'');
            Mais1ini.Free;

            Form7.ibDataSet35.First;

            Form7.ibDataSet4.Close;
            Form7.ibDataSet4.Selectsql.Clear;
            Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(Form7.ibDataSet35DESCRICAO.AsString)+' ');  //
            Form7.ibDataSet4.Open;

            {Sandro Silva 2023-02-28 inicio}
            // Se tiver a tag <CNAEISSQN> preenchida na aba tags do estoque, deverá usá-la
            if Trim(RetornaValorDaTagNoCampo('CNAEISSQN', Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
              sCodigoCnae := Trim(RetornaValorDaTagNoCampo('CNAEISSQN', Form7.ibDataSet4.FieldByname('TAGS_').AsString));
            {Sandro Silva 2023-02-28 fim}
            //
            if AllTrim(RetornaValorDaTagNoCampo('CodigoTributacaoMunicipio',form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
            begin
              Writeln(F,'CodigoTributacaoMunicipio='+AllTrim(RetornaValorDaTagNoCampo('CodigoTributacaoMunicipio',form7.ibDataSet4.FieldByname('TAGS_').AsString))); // Código do item da lista de serviço.	T	 Obtido na prefeitura
            end;

            Writeln(F,'MunicipioIncidencia='+Copy(Form7.ibDAtaSet99.FieldByname('CODIGO').AsString,1,7)); // Código IBGE do município onde ocorrerá a aplicação do imposto.	T	Usado quando o serviço for retido.
            Writeln(F,'DescricaoCidadePrestacao='+ConverteAcentos2(Form7.ibDAtaSet13MUNICIPIO.AsString)); // Município onde o serviço foi prestado
            Writeln(F,'');

            {Sandro Silva 2023-09-26 inicio
            Writeln(F,'CpfCnpjTomador='+LimpaNumero(Form7.ibDAtaSet2CGC.AsString));           // CPF / CNPJ do tomador do serviço
            Writeln(F,'RazaoSocialTomador='+ConverteAcentos2(Form7.ibDAtaSet2NOME.AsString)); // Razão Social do tomador do serviço
            Writeln(F,'InscricaoEstadualTomador='+LimpaNumero(Form7.ibDAtaSet2IE.AsString)); //
            Writeln(F,'InscricaoMunicipalTomador=');
            Writeln(F,'TipoLogradouroTomador=');
            Writeln(F,'EnderecoTomador='+ConverteAcentos2(Endereco_Sem_Numero(Form7.ibDAtaset2.FieldByname('ENDERE').AsString))); // Logradouro do Emitente
            Writeln(F,'NumeroTomador='+Numero_Sem_Endereco(Form7.ibDAtaset2.FieldByname('ENDERE').AsString)); // Numero do Logradouro do Emitente
            Writeln(F,'ComplementoTomador=');
            Writeln(F,'BairroTomador='+ConverteAcentos2(Form7.ibDAtaSet2COMPLE.AsString));

            Form7.ibDataset99.Close;
            Form7.ibDataset99.SelectSql.Clear;
            Form7.ibDataset99.SelectSQL.Add('select * from MUNICIPIOS where NOME='+QuotedStr(Form7.ibDataSet2CIDADE.AsString)+' '+' and UF='+QuotedStr(UpperCase(Form7.ibDataSet2ESTADO.AsString))+' ');
            Form7.ibDataset99.Open;

            Writeln(F,'CodigoCidadeTomador='+Copy(Form7.ibDAtaSet99.FieldByname('CODIGO').AsString,1,7)); // Código da Cidade do Emitente (Tabela do IBGE)
            Writeln(F,'DescricaoCidadeTomador='+ConverteAcentos2(Form7.ibDAtaSet2CIDADE.AsString)); // Município do tomador do serviço
            Writeln(F,'UfTomador='+UpperCase(Form7.ibDataSet2ESTADO.AsString));                               // UF do tomador do serviço
            Writeln(F,'CepTomador='+LimpaNumero(Form7.ibDAtaSet2CEP.AsString));                     // CEP do tomador do serviço
            Writeln(F,'PaisTomador=1058');

            // Sandro Silva 2023-09-05 if (sPadraoSistema = 'ISSNETONLINE20') and (AnsiUpperCase(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString) + Form7.ibDataSet13ESTADO.AsString) = 'BRASILIADF') then
            if (sPadraoSistema = 'ISSNETONLINE20') and (GetCidadeUF = 'BRASILIADF') then
            begin
              Writeln(F,'DDDTomador=' + IntToStr(StrToIntDef(Copy(LimpaNumero(Form7.ibDataSet2FONE.AsString) + '000', 1, 3), 0)));
            end else
            begin
              Writeln(F,'DDDTomador='+ Copy(LimpaNumero(Form7.ibDAtaSet2FONE.AsString)+'000',1,3) );
            end;
            Writeln(F,'TelefoneTomador='+AllTrim(Copy(LimpaNumero(Form7.ibDataSet2FONE.AsString)+'             ',4,9)));
            Writeln(F,'EmailTomador='+  Copy(Form7.ibDAtaSet2EMAIL.AsString,1,Pos(';',Form7.ibDAtaSet2EMAIL.AsString+';')-1)); // somente o primeiro e-mail cadastrado
            Writeln(F,'');

            }

            sCpfCnpjTomador            := LimpaNumero(Form7.ibDAtaSet2CGC.AsString);           // CPF / CNPJ do tomador do serviço
            sRazaoSocialTomador        := ConverteAcentos2(Form7.ibDAtaSet2NOME.AsString); // Razão Social do tomador do serviço
            sInscricaoEstadualTomador  := LimpaNumero(Form7.ibDAtaSet2IE.AsString); //
            sInscricaoMunicipalTomador := '';
            sTipoLogradouroTomador     := '';
            sEnderecoTomador           := ConverteAcentos2(Endereco_Sem_Numero(Form7.ibDAtaset2.FieldByname('ENDERE').AsString)); // Logradouro do Emitente
            sNumeroTomador             := Numero_Sem_Endereco(Form7.ibDAtaset2.FieldByname('ENDERE').AsString); // Numero do Logradouro do Emitente
            sComplementoTomador        := '';
            sBairroTomador             := ConverteAcentos2(Form7.ibDAtaSet2COMPLE.AsString);

            Form7.ibDataset99.Close;
            Form7.ibDataset99.SelectSql.Clear;
            Form7.ibDataset99.SelectSQL.Add('select * from MUNICIPIOS where NOME='+QuotedStr(Form7.ibDataSet2CIDADE.AsString)+' '+' and UF='+QuotedStr(UpperCase(Form7.ibDataSet2ESTADO.AsString))+' ');
            Form7.ibDataset99.Open;

            sCodigoCidadeTomador    := Copy(Form7.ibDAtaSet99.FieldByname('CODIGO').AsString,1,7); // Código da Cidade do Emitente (Tabela do IBGE)
            sDescricaoCidadeTomador := ConverteAcentos2(Form7.ibDAtaSet2CIDADE.AsString); // Município do tomador do serviço
            sUfTomador              := UpperCase(Form7.ibDataSet2ESTADO.AsString);                               // UF do tomador do serviço
            sCepTomador             := LimpaNumero(Form7.ibDAtaSet2CEP.AsString);                     // CEP do tomador do serviço
            sPaisTomador            := '1058';

            if (sPadraoSistema = 'ISSNETONLINE20') and (GetCidadeUF = 'BRASILIADF') then
            begin
              sDDDTomador := IntToStr(StrToIntDef(Copy(LimpaNumero(Form7.ibDataSet2FONE.AsString) + '000', 1, 3), 0));
            end else
            begin
              sDDDTomador := Copy(LimpaNumero(Form7.ibDAtaSet2FONE.AsString)+'000',1,3) ;
            end;

            sTelefoneTomador        := AllTrim(Copy(LimpaNumero(Form7.ibDataSet2FONE.AsString)+'             ',4,9));
            sEmailTomador           := Copy(Form7.ibDAtaSet2EMAIL.AsString,1,Pos(';',Form7.ibDAtaSet2EMAIL.AsString+';')-1); // somente o primeiro e-mail cadastrado

            if (sPadraoSistema = 'ISSNETONLINE20') and (GetCidadeUF = 'BRASILIADF') then
            begin
              if (Trim(LimpaNumero(Form7.ibDAtaSet2CGC.AsString)) = '') and (Trim(Form7.ibDAtaset2.FieldByname('ENDERE').AsString) = '') then
              begin
                // Em Brasília é permitido NFS-e sem informar dados do cliente
                sCpfCnpjTomador            := '';           // CPF / CNPJ do tomador do serviço
                sRazaoSocialTomador        := ''; // Razão Social do tomador do serviço
                sInscricaoEstadualTomador  := ''; //
                sInscricaoMunicipalTomador := '';
                sTipoLogradouroTomador     := '';
                sEnderecoTomador           := ''; // Logradouro do Emitente
                sNumeroTomador             := ''; // Numero do Logradouro do Emitente
                sComplementoTomador        := '';
                sBairroTomador             := '';

                sCodigoCidadeTomador    := ''; // Código da Cidade do Emitente (Tabela do IBGE)
                sDescricaoCidadeTomador := ''; // Município do tomador do serviço
                sUfTomador              := '';                               // UF do tomador do serviço
                sCepTomador             := '';                     // CEP do tomador do serviço
                sPaisTomador            := '1058';
                sDDDTomador             := '';
                sTelefoneTomador        := '';
                sEmailTomador           := ''; // somente o primeiro e-mail cadastrado
              end;
            end;

            Writeln(F,'CpfCnpjTomador=' + sCpfCnpjTomador);           // CPF / CNPJ do tomador do serviço
            Writeln(F,'RazaoSocialTomador=' + sRazaoSocialTomador); // Razão Social do tomador do serviço
            Writeln(F,'InscricaoEstadualTomador=' + sInscricaoEstadualTomador); //
            Writeln(F,'InscricaoMunicipalTomador=' + sInscricaoMunicipalTomador);
            Writeln(F,'TipoLogradouroTomador=' + sTipoLogradouroTomador);
            Writeln(F,'EnderecoTomador=' + sEnderecoTomador); // Logradouro do Emitente
            Writeln(F,'NumeroTomador=' + sNumeroTomador); // Numero do Logradouro do Emitente
            Writeln(F,'ComplementoTomador=' + sComplementoTomador);
            Writeln(F,'BairroTomador=' + sBairroTomador);

            Writeln(F,'CodigoCidadeTomador=' + sCodigoCidadeTomador); // Código da Cidade do Emitente (Tabela do IBGE)
            Writeln(F,'DescricaoCidadeTomador=' + sDescricaoCidadeTomador); // Município do tomador do serviço
            Writeln(F,'UfTomador=' + sUfTomador);                               // UF do tomador do serviço
            Writeln(F,'CepTomador=' + sCepTomador);                     // CEP do tomador do serviço
            Writeln(F,'PaisTomador=' + sPaisTomador);

            Writeln(F,'DDDTomador=' + sDDDTomador);
            Writeln(F,'TelefoneTomador=' + sTelefoneTomador);
            Writeln(F,'EmailTomador=' + sEmailTomador); // somente o primeiro e-mail cadastrado
            Writeln(F,'');
            {Sandro Silva 2023-09-26 fim}
            //
            // Pis
            // Cofins
            // Inss
            // Ir
            // Csll
            //
            if Pos('(F)',Form7.ibDataset15MARCA.AsString) <> 0 then
            begin
              try if AllTrim(RetornaValorDaTagNoCampo('AliquotaPIS',form7.ibDataSet4.FieldByname('TAGS_').AsString))    <> '' then Writeln(F,'AliquotaPIS='   +AllTrim(RetornaValorDaTagNoCampo('AliquotaPIS',form7.ibDataSet4.FieldByname('TAGS_').AsString)))    else Writeln(F,'AliquotaPIS=0.00');    except end; // Pis
              try if AllTrim(RetornaValorDaTagNoCampo('AliquotaCOFINS',form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then Writeln(F,'AliquotaCOFINS='+AllTrim(RetornaValorDaTagNoCampo('AliquotaCOFINS',form7.ibDataSet4.FieldByname('TAGS_').AsString))) else Writeln(F,'AliquotaCOFINS=0.00'); except end; /// Cofins
              try if AllTrim(RetornaValorDaTagNoCampo('AliquotaINSS',form7.ibDataSet4.FieldByname('TAGS_').AsString))   <> '' then Writeln(F,'AliquotaINSS='  +AllTrim(RetornaValorDaTagNoCampo('AliquotaINSS',form7.ibDataSet4.FieldByname('TAGS_').AsString)))   else Writeln(F,'AliquotaINSS=0.00');   except end; /// Inss
              try if AllTrim(RetornaValorDaTagNoCampo('AliquotaIR',form7.ibDataSet4.FieldByname('TAGS_').AsString))     <> '' then Writeln(F,'AliquotaIR='    +AllTrim(RetornaValorDaTagNoCampo('AliquotaIR',form7.ibDataSet4.FieldByname('TAGS_').AsString)))     else Writeln(F,'AliquotaIR=0.00');     except end; /// Ir
              try if AllTrim(RetornaValorDaTagNoCampo('AliquotaCSLL',form7.ibDataSet4.FieldByname('TAGS_').AsString))   <> '' then Writeln(F,'AliquotaCSLL='  +AllTrim(RetornaValorDaTagNoCampo('AliquotaCSLL',form7.ibDataSet4.FieldByname('TAGS_').AsString)))   else Writeln(F,'AliquotaCSLL=0.00');   except end; /// Csll

              // Valor
              try if AllTrim(RetornaValorDaTagNoCampo('AliquotaPIS',form7.ibDataSet4.FieldByname('TAGS_').AsString))    <> '' then Writeln(F,'ValorPIS='   +StrTran(Alltrim(FormatFloat('##0.00',StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('AliquotaPIS',form7.ibDataSet4.FieldByname('TAGS_').AsString)))    / 100 *(Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat) )),',','.')) else Writeln(F,'ValorPIS=0.00');    except end; /// Pis
              try if AllTrim(RetornaValorDaTagNoCampo('AliquotaCOFINS',form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then Writeln(F,'ValorCOFINS='+StrTran(Alltrim(FormatFloat('##0.00',StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('AliquotaCOFINS',form7.ibDataSet4.FieldByname('TAGS_').AsString))) / 100 *(Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat) )),',','.')) else Writeln(F,'ValorCOFINS=0.00'); except end; /// Cofins
              try if AllTrim(RetornaValorDaTagNoCampo('AliquotaINSS',form7.ibDataSet4.FieldByname('TAGS_').AsString))   <> '' then Writeln(F,'ValorINSS='  +StrTran(Alltrim(FormatFloat('##0.00',StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('AliquotaINSS',form7.ibDataSet4.FieldByname('TAGS_').AsString)))   / 100 *(Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat) )),',','.')) else Writeln(F,'ValorINSS=0.00');   except end; /// Inss
              try if AllTrim(RetornaValorDaTagNoCampo('AliquotaIR',form7.ibDataSet4.FieldByname('TAGS_').AsString))     <> '' then Writeln(F,'ValorIR='    +StrTran(Alltrim(FormatFloat('##0.00',StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('AliquotaIR',form7.ibDataSet4.FieldByname('TAGS_').AsString)))     / 100 *(Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat) )),',','.')) else Writeln(F,'ValorIR=0.00');     except end; /// Ir
              try if AllTrim(RetornaValorDaTagNoCampo('AliquotaCSLL',form7.ibDataSet4.FieldByname('TAGS_').AsString))   <> '' then Writeln(F,'ValorCSLL='  +StrTran(Alltrim(FormatFloat('##0.00',StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('AliquotaCSLL',form7.ibDataSet4.FieldByname('TAGS_').AsString)))   / 100 *(Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat) )),',','.')) else Writeln(F,'ValorCSLL=0.00');   except end; /// Csll

              // acumula a variavel fValorImpostosFederaisRetidos para descontar no valor líquido
              try if AllTrim(RetornaValorDaTagNoCampo('AliquotaPIS',form7.ibDataSet4.FieldByname('TAGS_').AsString))    <> '' then fValorImpostosFederaisRetidos := fValorImpostosFederaisRetidos + Arredonda(StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('AliquotaPIS',form7.ibDataSet4.FieldByname('TAGS_').AsString)))    / 100 *(Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat),2); except end; // Pis
              try if AllTrim(RetornaValorDaTagNoCampo('AliquotaCOFINS',form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then fValorImpostosFederaisRetidos := fValorImpostosFederaisRetidos + Arredonda(StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('AliquotaCOFINS',form7.ibDataSet4.FieldByname('TAGS_').AsString))) / 100 *(Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat),2); except end; // Cofins
              try if AllTrim(RetornaValorDaTagNoCampo('AliquotaINSS',form7.ibDataSet4.FieldByname('TAGS_').AsString))   <> '' then fValorImpostosFederaisRetidos := fValorImpostosFederaisRetidos + Arredonda(StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('AliquotaINSS',form7.ibDataSet4.FieldByname('TAGS_').AsString)))   / 100 *(Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat),2); except end; // Inss
              try if AllTrim(RetornaValorDaTagNoCampo('AliquotaIR',form7.ibDataSet4.FieldByname('TAGS_').AsString))     <> '' then fValorImpostosFederaisRetidos := fValorImpostosFederaisRetidos + Arredonda(StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('AliquotaIR',form7.ibDataSet4.FieldByname('TAGS_').AsString)))     / 100 *(Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat),2); except end; // Ir
              try if AllTrim(RetornaValorDaTagNoCampo('AliquotaCSLL',form7.ibDataSet4.FieldByname('TAGS_').AsString))   <> '' then fValorImpostosFederaisRetidos := fValorImpostosFederaisRetidos + Arredonda(StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('AliquotaCSLL',form7.ibDataSet4.FieldByname('TAGS_').AsString)))   / 100 *(Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat),2); except end; // Csll
            end;

            Writeln(F,'OutrasRetencoes=0.00');
            Writeln(F,'DescontoIncondicionado='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat)),',','.'));  //
            Writeln(F,'DescontoCondicionado=0.00');
            Writeln(F,'ValorDeducoes=0.00');
            Writeln(F,'');

            Writeln(F,'AliquotaISS='+StrTran(StrZero(Form7.ibDataSet14ISS.AsFloat,1,5),',','.'));

            // ISS Retido
            if Pos('(I)',Form7.ibDataset15MARCA.AsString) <> 0 then
            begin
              Writeln(F,'IssRetido=1');
              {Sandro Silva 2024-04-24 inicio
              fValorISSRetido := (Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat)*Form7.ibDataSet14ISS.AsFloat/100;
              //ajusta para o valor do ISS Retido ficar formatado com duas casas decimais. Arredonda
              if (sPadraoSistema = 'ISSNETONLINE20') and (GetCidadeUF = 'ITAUNAMG') then
                fValorISSRetido := StrToFloat(FormatFloat('0.00', fValorISSRetido));
              }
              if (sCalculoDoDescontoPeloProvedor = 'Sim') then
                fValorISSRetido := CalculaValorISSRetido(sPadraoSistema, Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat, Form7.IBDataSet14.FieldByname('BASEISS').AsFloat, Form7.ibDataSet14ISS.AsFloat)
              else
                fValorISSRetido := CalculaValorISSRetido(sPadraoSistema, Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat - Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat, Form7.ibDataSet14ISS.AsFloat, Form7.IBDataSet14.FieldByname('BASEISS').AsFloat);
              {Sandro Silva 2024-04-24 fim}

              {Sandro Silva 2023-01-19 inicio}
              // Sandro Silva 2023-09-05 if (sPadraoSistema = 'ISSNETONLINE20') and (AnsiUpperCase(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString) + Form7.ibDataSet13ESTADO.AsString) = 'BRASILIADF') then
              if ((sPadraoSistema = 'ISSNETONLINE20') and (GetCidadeUF = 'BRASILIADF'))
                 or ((sPadraoSistema = 'ABACO20') and (GetCidadeUF = 'RIOBRANCOAC')) then
              begin
                if Trim(sResponsavelRetencao) <> '' then
                  Writeln(F,'ResponsavelRetencao=' + sResponsavelRetencao);
              end;
              {Sandro Silva 2023-01-19 fim}

            end else
            begin
              Writeln(F,'IssRetido=2');
              fValorISSRetido := 0;
            end;
            
            {Sandro Silva 2024-04-24 inicio
            Writeln(F,'ValorLiquidoNfse='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat-fValorISSRetido-fValorImpostosFederaisRetidos)),',','.'));   //
            }
            dValorLiquidoNfse := Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat - Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat - fValorISSRetido - fValorImpostosFederaisRetidos;
            if bNaoDescontarIssQuandoRetido then
              dValorLiquidoNfse := Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat - Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat - fValorImpostosFederaisRetidos;
            Writeln(F,'ValorLiquidoNfse=' + StrTran(Alltrim(FormatFloat('##0.00', dValorLiquidoNfse)), ',', '.'));   //
            {Sandro Silva 2023-10-02 inicio}


            Writeln(F,'OutrasInformacoes='+ConverteAcentos2(Form7.ibDAtaSet15COMPLEMENTO.AsString));
            Writeln(F,'CodigoCidadePrestacao='+sCodigoLocalPrestacao); // Código IBGE do município onde o serviço foi prestado
            
            Writeln(F,'');

            // A prazo
            if Form7.ibDataSet15DUPLICATAS.AsFloat >=1 then
            begin
              // 1 -> Á vista
              // 2 -> Na apresentação
              // 3 -> Á prazo
              // 4 -> Cartão débito
              // 5 -> Cartão crédito

              J := 0;

              Form7.ibDataSet7.First;
              while not Form7.ibDataSet7.Eof do
              begin
                // Duplicatas
                J := J + 1;

                Writeln(F,'INCLUIRFORMAPAGAMENTO');
                Writeln(F,'TipoPagamento='+sTipoPagamentoAPrazo);
                Writeln(F,'Parcela='+IntToStr(J));
                Writeln(F,'DataVencimentoParcela='+StrTran(DateToStrInvertida(Form7.ibDataSet7VENCIMENTO.AsDateTime),'/','-')); // DAta de vencimento formato YYYY-MM-DD 1967-09-26
                Writeln(F,'ValorParcela='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet7VALOR_DUPL.AsFloat)),',','.'));  // Valor da duplicata
                Writeln(F,'QuantidadeParcelas='+StrTran(Alltrim(FormatFloat('##0',Form7.ibDataSet15DUPLICATAS.AsFloat)),',','.'));
                Writeln(F,'SALVARFORMAPAGAMENTO');
                Writeln(F,'');
                //
                Form7.ibDataSet7.Next;
              end;
            end else
            begin
              // A vista não estou informando
            end;
            
            // Serviços
            Form7.ibDataSet35.First;

            I := 1;

            if not bMultiplosServicos then
            begin
              sDescricaoDosServicos := '';

              while not Form7.ibDataSet35.Eof do
              begin
                try
                  sDescricaoDosServicos := sDescricaoDosServicos + Form7.ibDataSet35.FieldByname('QUANTIDADE').AsString +
                                           ' - ' +
                                           Alltrim(ConverteAcentos2(Form7.ibDataSet35.FieldByname('DESCRICAO').AsString)) +
                                           ' -         R$ ' +
                                           StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet35.FieldByname('TOTAL').AsFloat)),',','.')+'|';
                except end;

                Form7.ibDataset35.Next;
              end;

              //if (sPadraoSistema = 'GINFES') or (sPadraoSistema = 'FINTEL') then Mauricio parizotto 2023-11-16
              {
              if (sPadraoSistema = 'GINFES')
                or (sPadraoSistema = 'FINTEL')
                or ((sPadraoSistema = 'WEBISS20') and (AnsiUpperCase(StringReplace(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString), ' ', '', [rfReplaceAll]) + Form7.ibDataSet13ESTADO.AsString) = 'ITANHANGAMT') ) then
              Mauricio Parizotto 2023-12-05}
              if sObsNaDescricao then
              begin
                sDescricaoDosServicos := sDescricaoDosServicos + '|' + ConverteAcentos2(Form7.ibDAtaSet15COMPLEMENTO.AsString);
              end;

              if sPadraoSistema = 'COPLAN' then
              begin
                sDescricaoDosServicos := StrTran(sDescricaoDosServicos,'|','   -   ');
              end;

              Writeln(F,'');
              Writeln(F,'DiscriminacaoServico='+sDescricaoDosServicos);
              Writeln(F,'QuantidadeServicos=1'); //
              Writeln(F,'UnidadeServico='+Alltrim(ConverteAcentos2(Form7.ibDataSet4.FieldByname('MEDIDA').AsString)));
              if sCalculoDoDescontoPeloProvedor = 'Sim' then //Sandro Silva 2024-03-25 if (sPadraoSistema = 'SAATRI') and (GetCidadeUF = 'BOAVISTARR') then
              begin
                Writeln(F,'ValorUnitarioServico='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat)),',','.'));
                Writeln(F,'ValorServicos='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat)),',','.'));
              end
              else
              begin
                Writeln(F,'ValorUnitarioServico='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat)),',','.'));
                Writeln(F,'ValorServicos='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat)),',','.'));
              end;

              // Situações tributárias obtidas na prefeitura
              if AllTrim(RetornaValorDaTagNoCampo('Tributavel',form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
              begin
                Writeln(F,'Tributavel='+AllTrim(RetornaValorDaTagNoCampo('Tributavel',form7.ibDataSet4.FieldByname('TAGS_').AsString))); // Situações tributárias obtidas na prefeitura
              end else
              begin
                if (sPadraoSistema = 'MAISISS20') then
                begin
                  Writeln(F,'Tributavel=1');
                end else
                begin
                  Writeln(F,'Tributavel=SIM');
                end;
              end;

              // Dados do 1 Serviço Vendido
              if AllTrim(RetornaValorDaTagNoCampo('cServico',form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
              begin
                Writeln(F,'CodigoItemListaServico='+AllTrim(RetornaValorDaTagNoCampo('cServico',form7.ibDataSet4.FieldByname('TAGS_').AsString))); // Código do item da lista de serviço.	T	 Obtido na prefeitura
              end else
              begin
                MensagemSistema('Entre no cadastro de produtos e serviços na aba tags e informe o código (cServico)(Obtido na prefeitura)',msgAtencao);
                Abort;
              end;

              Writeln(F,'TipoDeducao=');
              Writeln(F,'CodigoCnae='+sCodigoCnae);                 // CodigoCnae	Código do CNAE	T	 Obtido na prefeitura

              if (sPadraoSistema = 'MAISISS20') then
              begin
                Writeln(F,'ValorIss=0.00');
              end else
              begin
                {Sandro Silva 2023-10-02 inicio
                Writeln(F,'ValorIss='+StrTran(Alltrim(FormatFloat('##0.00',(Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat)*Form7.ibDataSet14ISS.AsFloat/100)),',','.'));
                }
                Writeln(F,'ValorIss=' + StrTran(Alltrim(FormatFloat('##0.00', CalculaValorISS(sPadraoSistema, (Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat), Form7.ibDataSet14ISS.AsFloat, Form7.IBDataSet14.FieldByname('BASEISS').AsFloat))), ',', '.'));
                {Sandro Silva 2023-10-02 inicio}
              end;

              Writeln(F,'ValorISSRetido='+StrTran(Alltrim(FormatFloat('##0.00',fValorISSRetido)),',','.')); // ISS Retido
              Writeln(F,'BaseCalculo='+StrTran(Alltrim(FormatFloat('##0.00',(Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat))),',','.'));   //
              Writeln(F,'CodigoCidadePrestacao='+sCodigoLocalPrestacao); // Código IBGE do município onde o serviço foi prestado
              Writeln(F,'');
            end else
            begin
              // Múltiplos serviços
              while not Form7.ibDataSet35.Eof do
              begin
                Form7.ibDataSet4.Close;
                Form7.ibDataSet4.Selectsql.Clear;
                Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(Form7.ibDataSet35DESCRICAO.AsString)+' ');  //
                Form7.ibDataSet4.Open;

                {Sandro Silva 2023-02-28 inicio}
                // Se tiver a tag <CNAEISSQN> preenchida na aba tags do estoque, deverá usá-la
                sCodigoCnae := sCodigoCnaePrestador; // Por padrão usa o CNAE do prestador ([Informacoes obtidas na prefeitura] CodigoCnae=)
                if Trim(RetornaValorDaTagNoCampo('CNAEISSQN', Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
                  sCodigoCnae := Trim(RetornaValorDaTagNoCampo('CNAEISSQN', Form7.ibDataSet4.FieldByname('TAGS_').AsString));
                {Sandro Silva 2023-02-28 fim}

                {Mauricio Parizotto 2023-09-12 inicio}
                //Verifica se é o último registro
                if Form7.ibDataSet35.RecNo = Form7.ibDataSet35.RecordCount then
                begin
                  //if (sPadraoSistema = 'ABACO20') and (AnsiUpperCase(StringReplace(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString), ' ', '', [rfReplaceAll]) + Form7.ibDataSet13ESTADO.AsString) = 'RIOBRANCOAC') then Mauricio Parizotto 2023-12-05
                  if sObsNaDescricao then
                  begin
                    ComplementoOBS := ' - '+Trim(ConverteAcentos2(Form7.ibDAtaSet15COMPLEMENTO.AsString));
                  end
                end;
                {Mauricio Parizotto 2023-09-12 fim}

                if I = 1 then
                begin
                  // Dados do 1 Serviço Vendido
                  Writeln(F,'');
                  //Writeln(F,'DiscriminacaoServico='+Alltrim(ConverteAcentos2(Form7.ibDataSet35.FieldByname('DESCRICAO').AsString))); Mauricio Parizotto 2023-09-12
                  Writeln(F,'DiscriminacaoServico='+Alltrim(ConverteAcentos2(Form7.ibDataSet35.FieldByname('DESCRICAO').AsString))+ComplementoOBS);
                  if sPadraoSistema = 'SIL' then // Sandro Silva 2022-10-24
                    Writeln(F,'QuantidadeServicos='+StrTran(Alltrim(FormatFloat('##0.' + DupeString('0', StrToIntDef(Form1.ConfCasasServ, 0)) , Form7.ibDataSet35.FieldByname('QUANTIDADE').AsFloat)),',','.')) //
                  else if (sPadraoSistema = 'ABACO20') and (AnsiUpperCase(StringReplace(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString), ' ', '', [rfReplaceAll]) + Form7.ibDataSet13ESTADO.AsString) = 'RIOBRANCOAC') then // Sandro Silva 2023-09-01
                    Writeln(F,'QuantidadeServicos='+Trim(FormatFloat('##0', Trunc(Form7.ibDataSet35.FieldByname('QUANTIDADE').AsFloat)))) // Abaco 2.0 Rio Branco - AC
                  else
                    Writeln(F,'QuantidadeServicos='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet35.FieldByname('QUANTIDADE').AsFloat)),',','.')); //
                  Writeln(F,'ValorUnitarioServico='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet35.FieldByname('UNITARIO').AsFloat)),',','.')); //
                  Writeln(F,'UnidadeServico='+Alltrim(ConverteAcentos2(Form7.ibDataSet4.FieldByname('MEDIDA').AsString)));
                  {Sandro Silva 2024-04-23 inicio
                  Writeln(F,'ValorServicos='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat)),',','.'));
                  }
                  if sCalculoDoDescontoPeloProvedor = 'Sim' then
                  begin
                    Writeln(F,'ValorServicos='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat)),',','.'));
                  end
                  else
                  begin
                    Writeln(F,'ValorServicos='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet15.FieldByname('SERVICOS').AsFloat-Form7.ibDataSet15.FieldByname('DESCONTO').AsFloat)),',','.'));
                  end;
                  {Sandro Silva 2024-04-23 fim}
                  // Situações tributárias obtidas na prefeitura
                  if AllTrim(RetornaValorDaTagNoCampo('Tributavel',form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
                  begin
                    Writeln(F,'Tributavel='+AllTrim(RetornaValorDaTagNoCampo('Tributavel',form7.ibDataSet4.FieldByname('TAGS_').AsString))); // Situações tributárias obtidas na prefeitura
                  end else
                  begin
                    if (sPadraoSistema = 'MAISISS20') then
                    begin
                      Writeln(F,'Tributavel=1');
                    end else
                    begin
                      Writeln(F,'Tributavel=SIM');
                    end;
                  end;

                  // Dados do 1 Serviço Vendido
                  if AllTrim(RetornaValorDaTagNoCampo('cServico',form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
                  begin
                    Writeln(F,'CodigoItemListaServico='+AllTrim(RetornaValorDaTagNoCampo('cServico',form7.ibDataSet4.FieldByname('TAGS_').AsString))); // Código do item da lista de serviço.	T	 Obtido na prefeitura
                  end else
                  begin
                    MensagemSistema('Entre no cadastro de produtos e serviços na aba tags e informe o código (cServico)(Obtido na prefeitura)',msgAtencao);
                    Abort;
                  end;

                  Writeln(F,'TipoDeducao=');
                  Writeln(F,'CodigoCnae='+sCodigoCnae);                 // CodigoCnae	Código do CNAE	T	 Obtido na prefeitura

                  if (sPadraoSistema = 'MAISISS20') then
                  begin
                    Writeln(F,'ValorIss=0.00');
                  end else
                  begin
                    {Sandro Silva 2023-10-02 inicio
                    Writeln(F,'ValorIss='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet35.FieldByname('TOTAL').AsFloat*Form7.ibDataSet14ISS.AsFloat/100)),',','.'));
                    }
                    Writeln(F,'ValorIss='+StrTran(Alltrim(FormatFloat('##0.00', CalculaValorISS(sPadraoSistema, Form7.ibDataSet35.FieldByname('TOTAL').AsFloat, Form7.ibDataSet14ISS.AsFloat, Form7.IBDataSet14.FieldByname('BASEISS').AsFloat))),',','.'));
                    {Sandro Silva 2023-10-02 fim}
                  end;

                  Writeln(F,'ValorISSRetido='+StrTran(Alltrim(FormatFloat('##0.00',fValorISSRetido)),',','.')); // ISS Retido
                  Writeln(F,'BaseCalculo='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet35.FieldByname('TOTAL').AsFloat)),',','.'));   //
                  Writeln(F,'CodigoCidadePrestacao='+sCodigoLocalPrestacao); // Código IBGE do município onde o serviço foi prestado
                  Writeln(F,'');
                end else
                begin
                  Writeln(F,'');
                  Writeln(F,'INCLUIRSERVICO');
                  Writeln(F,'');

                  //Writeln(F,'DiscriminacaoServico='+Alltrim(ConverteAcentos2(Form7.ibDataSet35.FieldByname('DESCRICAO').AsString))); Mauricio Parizotto 2023-09-12
                  Writeln(F,'DiscriminacaoServico='+Alltrim(ConverteAcentos2(Form7.ibDataSet35.FieldByname('DESCRICAO').AsString))+ComplementoOBS);
                  if sPadraoSistema = 'SIL' then // Sandro Silva 2022-10-24
                    Writeln(F,'QuantidadeServicos='+StrTran(Alltrim(FormatFloat('##0.' + DupeString('0', StrToIntDef(Form1.ConfCasasServ, 0)) , Form7.ibDataSet35.FieldByname('QUANTIDADE').AsFloat)),',','.')) //
                  else if (sPadraoSistema = 'ABACO20') and (AnsiUpperCase(StringReplace(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString), ' ', '', [rfReplaceAll]) + Form7.ibDataSet13ESTADO.AsString) = 'RIOBRANCOAC') then // Sandro Silva 2023-09-01
                    Writeln(F,'QuantidadeServicos='+Trim(FormatFloat('##0', Trunc(Form7.ibDataSet35.FieldByname('QUANTIDADE').AsFloat)))) // Abaco 2.0 Rio Branco - AC
                  else
                    Writeln(F,'QuantidadeServicos='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet35.FieldByname('QUANTIDADE').AsFloat)),',','.')); //
                  Writeln(F,'ValorUnitarioServico='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet35.FieldByname('UNITARIO').AsFloat)),',','.')); //
                  Writeln(F,'UnidadeServico='+Alltrim(ConverteAcentos2(Form7.ibDataSet4.FieldByname('MEDIDA').AsString)));
                  Writeln(F,'ValorServicos='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet35.FieldByname('TOTAL').AsFloat)),',','.')); //
                  Writeln(F,'ValorLiquidoServico='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet35.FieldByname('TOTAL').AsFloat)),',','.')); //

                  // Situações tributárias obtidas na prefeitura
                  if AllTrim(RetornaValorDaTagNoCampo('Tributavel',form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
                  begin
                    Writeln(F,'Tributavel='+AllTrim(RetornaValorDaTagNoCampo('Tributavel',form7.ibDataSet4.FieldByname('TAGS_').AsString))); // Situações tributárias obtidas na prefeitura
                  end else
                  begin
                    if (sPadraoSistema = 'MAISISS20') then
                    begin
                      Writeln(F,'Tributavel=1');
                    end else
                    begin
                      Writeln(F,'Tributavel=SIM');
                    end;
                  end;

                  // Dados do 1 Serviço Vendido
                  if AllTrim(RetornaValorDaTagNoCampo('cServico',form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
                  begin
                    Writeln(F,'CodigoItemListaServico='+AllTrim(RetornaValorDaTagNoCampo('cServico',form7.ibDataSet4.FieldByname('TAGS_').AsString))); // Código do item da lista de serviço.	T	 Obtido na prefeitura
                  end else
                  begin
                    Writeln(F,'CodigoItemListaServico='); // Código do item da lista de serviço.	T	 Obtido na prefeitura
                  end;

                  Writeln(F,'TipoDeducao=');
                  Writeln(F,'CodigoCnae='+sCodigoCnae);                 // CodigoCnae	Código do CNAE	T	 Obtido na prefeitura
                  Writeln(F,'ValorIss='+StrTran(Alltrim(FormatFloat('##0.00', CalculaValorISS(sPadraoSistema, Form7.ibDataSet35.FieldByname('TOTAL').AsFloat, Form7.ibDataSet14ISS.AsFloat, Form7.IBDataSet14.FieldByname('BASEISS').AsFloat))),',','.'));// Sandro Silva 2023-10-02 Writeln(F,'ValorIss='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet35.FieldByname('TOTAL').AsFloat*Form7.ibDataSet14ISS.AsFloat/100)),',','.'));
                  Writeln(F,'ValorISSRetido='+StrTran(Alltrim(FormatFloat('##0.00',fValorISSRetido)),',','.')); // ISS Retido
                  Writeln(F,'BaseCalculo='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet35.FieldByname('TOTAL').AsFloat)),',','.'));   //
                  Writeln(F,'CodigoCidadePrestacao='+sCodigoLocalPrestacao); // Código IBGE do município onde o serviço foi prestado
                  Writeln(F,'ValorServicos='+StrTran(Alltrim(FormatFloat('##0.00',Form7.ibDataSet35.FieldByname('TOTAL').AsFloat)),',','.')); //
                  Writeln(F,'AliquotaServico='+StrTran(StrZero(Form7.ibDataSet14ISS.AsFloat,1,2),',','.'));

                  Writeln(F,'');
                  Writeln(F,'SALVARSERVICO');
                  Writeln(F,'');
                end;

                I := I + 1;

                Form7.ibDataset35.Next;
              end;
            end;

            Writeln(F,'');
            Writeln(F,'SALVARRPS');
          end;

          CloseFile(F);


          // Aguarda até criar o arquivo
          while not FileExists(pChar(Form1.sAtual+'\NFSE\smallnfse.tx2')) do
          begin
            Sleep(100);
          end;

          if (Pos('ChaveDeCancelamento',Form7.ibDataSet15RECIBOXML.AsString) = 0) or (Limpanumero(Form7.ibDAtaSet15NFEPROTOCOLO.AsString) = '1') or (Limpanumero(Form7.ibDAtaSet15NFEPROTOCOLO.AsString) = '') then
          begin
            try
              //  Já grava o arquivo de envio para não perder no caso de joinvile
              _file1 := TStringList.Create;
              _file1.LoadFromFile(pChar(Form1.sAtual+'\NFSE\smallnfse.tx2'));

              if (RetornaValorDaTagNoCampo('Status',_file1.Text) <> 'EM PROCESSAMENTO') or (Form1.sConsultaNfse <> 'SIM') then
              begin
                if not (Form7.ibDataset15.State in ([dsEdit, dsInsert])) then
                  Form7.ibDataset15.Edit;

                // Para resolver o problema de Joinvile
                if AllTrim(RetornaValorDaTagNoCampoCRLF('XMLdeEvio',Form7.ibDAtaSet15RECIBOXML.AsString)) <> '' then
                begin
                  _File1.Text :=  '<XMLdeEvio>'+AllTrim(Form7.ibDAtaSet15NFEXML.AsString)+'</XMLdeEvio>' + _File1.Text;
                end;

                if AllTrim(RetornaValorDaTagNoCampoCRLF('tx2',Form7.ibDAtaSet15RECIBOXML.AsString)) <> '' then
                begin
                  _File1.Text :=  '<tx2>'+AllTrim(RetornaValorDaTagNoCampoCRLF('tx2',Form7.ibDAtaSet15RECIBOXML.AsString))+'</tx2>' + _File1.Text;
                end else
                begin
                  _File1.Text :=  '<tx2>'+AllTrim(_file1.Text)+'</tx2>';
                end;

                // End
                Form7.ibDAtaSet15RECIBOXML.AsString := _file1.Text; // Logo que o arquivo .tx2 e criado já grava no RECIBOXML
                Form7.ibDAtaSet15.Post;
                Form7.ibDAtaSet15.Edit;
              end;
            except
            end;
          end;

          //Form7.ibDataSet15.DisableControls; //Mauricio Parizotto 2024-05-07

          while FileExists(Pchar(Form1.sAtual+'\NFSE\ret.txt')) do
          begin
            DeleteFile(Pchar(Form1.sAtual+'\NFSE\ret.txt'));
            Sleep(100);
          end;

          if Form1.Debug1.Checked then
          begin
            ShellExecute( 0, 'Open',pChar(Form1.sAtual+'\NFSE\smallnfse.tx2'),'','', SW_SHOWMAXIMIZED);
            MensagemSistema('Tecle Ok para continuar');
          end;

          ShellExecute( 0, 'Open',pChar('NFSE.EXE'),'', '', SW_SHOW);

          // Aguarda fechar o NFSE.EXE
          while ConsultaProcesso('NFSE.EXE') or ConsultaProcesso('NFSE.exe') or ConsultaProcesso('nfse.exe') do
          begin
            sleep(100);
          end;

          // Verifica o retorno
          while not FileExists(Pchar(Form1.sAtual+'\NFSE\ret.txt')) do
          begin
            Sleep(100);
          end;

          if Form1.Debug1.Checked then
          begin
            ShellExecute( 0, 'Open',pChar(Form1.sAtual+'\NFSE\ret.txt'),'','', SW_SHOWMAXIMIZED);
            MensagemSistema('Tecle Ok para continuar');
          end;

          if Form1.sConsultaNfse = 'SIM' then
          begin
            _file := TStringList.Create;
            _file.LoadFromFile(pChar(Form1.sAtual+'\NFSE\ret.txt'));

            sRetornoNFse := _File.Text;

            // Quando não volta o Numero da NFE
            if (Pos('ChaveDeCancelamento',Form7.ibDataSet15RECIBOXML.AsString) = 0) or (Limpanumero(Form7.ibDAtaSet15NFEPROTOCOLO.AsString) = '1') or (Limpanumero(Form7.ibDAtaSet15NFEPROTOCOLO.AsString) = '') then
            begin
              Form1.sConsultaNfse := 'NAO';
            end else
            begin
              if RetornaValorDaTagNoCampo('Status',sRetornoNFse) <> '' then
              begin
                ShellExecute( 0, 'Open',pChar(Form1.sAtual+'\NFSE\ret.txt'),'','', SW_SHOWMAXIMIZED);
                MensagemSistema('Tecle Ok para continuar');
              end;

              if Application.MessageBox(Pchar('Gravar estas informações no recibo da NFS-e?'),'Atenção', mb_YesNo + mb_DefButton1 + MB_ICONQUESTION) = IDYES then
              begin
                Form1.sConsultaNfse := 'NAO';
              end;
            end;
          end;

          if Form1.sConsultaNfse = 'SIM' then
          begin
            Form1.sConsultaNfse := 'NAO';
          end else
          begin
            if FileExists(pChar(Form1.sAtual+'\NFSE\ret.txt')) then
            begin
              _file := TStringList.Create;
              _file.LoadFromFile(pChar(Form1.sAtual+'\NFSE\ret.txt'));

              sRetornoNFse := _File.Text;

              Form7.ibDAtaSet15.Edit;

              try
                // Quando não volta o Numero da NFE
                if (Pos('ChaveDeCancelamento',Form7.ibDataSet15RECIBOXML.AsString) = 0) or (Limpanumero(Form7.ibDAtaSet15NFEPROTOCOLO.AsString) = '1') or (Limpanumero(Form7.ibDAtaSet15NFEPROTOCOLO.AsString) = '') then
                begin
                  if (AllTrim(RetornaValorDaTagNoCampoCRLF('XMLdeEvio',_File.Text)) = '') then
                  begin
                    if AllTrim(RetornaValorDaTagNoCampoCRLF('XMLdeEvio',Form7.ibDAtaSet15RECIBOXML.AsString)) <> '' then
                    begin
                      _File.Text := '<XMLdeEvio>'+AllTrim(Form7.ibDAtaSet15NFEXML.AsString)+'</XMLdeEvio>' + chr(10) + _File.Text;
                    end;
                  end;

                  if (AllTrim(RetornaValorDaTagNoCampoCRLF('tx2',_File.Text)) = '') then
                  begin
                    if AllTrim(RetornaValorDaTagNoCampoCRLF('tx2',Form7.ibDAtaSet15RECIBOXML.AsString)) <> '' then
                    begin
                      _File.Text := '<tx2>'+AllTrim(RetornaValorDaTagNoCampoCRLF('tx2',Form7.ibDAtaSet15RECIBOXML.AsString))+'</tx2>'+ chr(10) + chr(10) + _File.Text;
                    end;
                  end;

                  Form7.ibDAtaSet15RECIBOXML.AsString := StrTran(StrTran(_File.Text,'<tx2></tx2>',''),'<XMLdeEvio></XMLdeEvio>',''); // Retorno da Prefeitura

                  Form7.ibDataSet15.Post;
                  Form7.ibDataSet15.Edit;

                  if RetornaValorDaTagNoCampo('Status',Form7.ibDAtaSet15RECIBOXML.AsString)       <> '' then
                    Form7.SetTextoCampoSTATUSNFe(AllTrim(RetornaValorDaTagNoCampo('Status',Form7.ibDAtaSet15RECIBOXML.AsString)));

                  if RetornaValorDaTagNoCampo('Situacao',Form7.ibDAtaSet15RECIBOXML.AsString)     <> '' then
                    Form7.SetTextoCampoSTATUSNFe(AllTrim(RetornaValorDaTagNoCampo('Situacao',Form7.ibDAtaSet15RECIBOXML.AsString)));

                  if RetornaValorDaTagNoCampo('numero_nfse',Form7.ibDAtaSet15RECIBOXML.AsString)  <> '' then
                    Form7.ibDAtaSet15NFEPROTOCOLO.AsString  := AllTrim(RetornaValorDaTagNoCampo('numero_nfse',Form7.ibDAtaSet15RECIBOXML.AsString))+'/'+AllTrim(RetornaValorDaTagNoCampo('serie_nfse',Form7.ibDAtaSet15RECIBOXML.AsString));

                  {Sandro Silva 2023-09-01 inicio}
                  if Form7.ibDAtaSet15NFEPROTOCOLO.AsString = '' then
                  begin
                    // Sandro Silva 2023-09-05 if (sPadraoSistema = 'ABACO20') and (AnsiUpperCase(StringReplace(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString), ' ', '', [rfReplaceAll]) + Form7.ibDataSet13ESTADO.AsString) = 'RIOBRANCOAC') then // Sandro Silva 2023-09-01
                    if ((sPadraoSistema = 'ABACO20') and (GetCidadeUF = 'RIOBRANCOAC')) or ((sPadraoSistema = 'TECNOSISTEMAS') and (GetCidadeUF = 'SAOSEBASTIAODOCAIRS')) then // Sandro Silva 2023-09-06 if (sPadraoSistema = 'ABACO20') and (GetCidadeUF = 'RIOBRANCOAC') then // Sandro Silva 2023-09-01
                    begin
                      if RetornaValorDaTagNoCampo('NumeroDaNFSe',Form7.ibDAtaSet15RECIBOXML.AsString) <> '' then
                        Form7.ibDAtaSet15NFEPROTOCOLO.AsString  := Trim(RetornaValorDaTagNoCampo('NumeroDaNFSe', Form7.ibDAtaSet15RECIBOXML.AsString)) + '/001';
                    end;
                  end;
                  {Sandro Silva 2023-09-01 fim}

                  {Sandro Silva 2023-09-01 inicio}                  
                  if Form7.ibDAtaSet15NFEPROTOCOLO.AsString = '' then
                  begin
                    // Caso não tenha encontrado o número da NFS-e procura a tag <NumeroDaNFSe> e extrai o número da NFS-e
                    if RetornaValorDaTagNoCampo('NumeroDaNFSe',Form7.ibDAtaSet15RECIBOXML.AsString) <> '' then
                      Form7.ibDAtaSet15NFEPROTOCOLO.AsString  := Trim(RetornaValorDaTagNoCampo('NumeroDaNFSe', Form7.ibDAtaSet15RECIBOXML.AsString)) + '/001';
                  end;
                  {Sandro Silva 2023-09-01 fim}

                  //BuscaNumeroNFSe(True);

                  if Pos('ChaveDeCancelamento',Form7.ibDataSet15RECIBOXML.AsString) <> 0 then
                  begin
                    Form7.ibDataSet15EMITIDA.AsString := 'S'; // Imitida
                    Form7.ibDataSet15.Post;
                    Form7.ibDataSet15.Edit;

                    // Data da última venda para o cliente
                    try
                      if  Form7.ibDataSet2ULTIMACO.AsDateTime < Form7.ibDataSet15EMISSAO.AsDateTime then
                      begin
                        Form7.ibDataSet2.Edit;
                        Form7.ibDataSet2ULTIMACO.AsDateTime := Form7.ibDataSet15EMISSAO.AsDateTime;
                        Form7.ibDataSet2.Post;
                      end;
                    except
                    end;
                  end;

                  sArquivoXML := RetornaValorDaTagNoCampo('ArquivoGeradorNfse',sRetornoNFse);

                  if AllTrim(sArquivoXML) <> '' then
                  begin
                    if Pos('\NFSE\',UpperCase(sArquivoXML)) = 0 then
                    begin
                      sArquivoXML := Form1.sAtual+'\NFSE\Log\'+sArquivoXML;
                    end else
                    begin
                      sArquivoXML := sArquivoXML;
                    end;

                    if FileExists(sArquivoXML) then
                    begin
                      _XML := TStringList.Create;
                      _XML.LoadFromFile(sArquivoXML);

                      Form7.ibDAtaSet15NFEXML.AsString    := pChar(_XML.Text);
                      Form7.ibDataSet15MODELO.AsString    := 'SV';
                    end;
                  end;
                end;
              except
                on E: Exception do
                begin
                  //Application.MessageBox(pChar(E.Message),'Erro no retorno da NFS-e: ',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
                  MensagemSistema(E.Message+' Erro no retorno da NFS-e: ',msgErro);
                  Result := False;
                end;
              end;

              Form7.ibDAtaSet15.Post;
              Form7.ibDAtaSet15.Edit;
            end;

            while FileExists(Pchar(Form1.sAtual+'\NFSE\ret.txt')) do
            begin
              DeleteFile(Pchar(Form1.sAtual+'\NFSE\ret.txt'));
              Sleep(100);
            end;
          end;

          //Form7.ibDataSet15.EnableControls; // Form7.ibDataSet15.DisableControls; acima, na linha 900 Mauricio Parizotto 2024-05-07
        end else
        begin
          Screen.Cursor            := crDefault;
          MensagemSistema('Não é possível emitir a nota de serviço com valor 0 (Zero).',msgAtencao);
          Result := False;
        end;
      end else
      begin
        Screen.Cursor            := crDefault;
        MensagemSistema('NFS-e já emitida e autorizada.',msgAtencao);
        Result := False;
      end;
    end;
  except
  end;


  //Mauricio Parizotto 2023-04-11
  Form7.ibDataSet15.DisableControls;
  vRegistro := Form7.ibDataSet15REGISTRO.AsString;

  //Commita sem refazer select
  Commitatudo(False);
  AbreArquivos(False);

  //Volta para o registro que estava
  try
    Form7.ibDataSet15.Locate('REGISTRO',vRegistro,[]);
  except
  end;

  Form7.ibDataSet15.EnableControls;
end;


procedure LimpaNFSE;
begin
  Form7.ibDataSet15.Edit;
  Form7.SetTextoCampoSTATUSNFe(EmptyStr);
  Form7.ibDataSet15NFEPROTOCOLO.AsString := '';
  Form7.ibDataSet15.Post;
end;

end.
