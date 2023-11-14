unit urelatoriosgerenciais;

interface

uses
  SysUtils
  , StrUtils
  , Controls
  , DateUtils
  , Dialogs
  , Classes
  , IBQuery
  , Forms
  , Variants
  , ComCtrls
  , msxml
  , CheckLst
;

procedure RelatorioConferenciaDeMesa;
procedure RelatorioMeiosDePagamento;
function CabecalhoRelatoriosGerenciais: String;
procedure RelatorioImpressaoOrcamento;
procedure RelatorioMovimentoDia;
procedure RelatorioNFCeNoPeriodo;
procedure DocumentosNoPeriodo(dtInicio, dtFinal: TDate);
procedure RelatorioResumoDasVendas;
procedure VendasPorNFCe(dtInicio: TDate; dtFinal: TDate;
  sCaixa: String; sCliente: String; sFormaPagto: String);
procedure RelatorioTotalDiario;
procedure TotalDiario(dtInicio, dtFinal: TDate; sCaixa: String;
  sModelo: String);
procedure RelatorioFechamentoDeCaixa;
function ListaCaixasSelecionados(Lista: TCheckListBox): String;
procedure FechamentoDeCaixa(bNaHora: Boolean);

implementation

uses
  SmallFunc
  , ufuncoesfrente
  , fiscal
  , unit7
  , unit11
  , upafecfmenufiscal
  , _small_2
  , _small_3
  , _small_15
  , _small_17
  , _small_59
  , _small_65
  , _Small_99
;

procedure RelatorioConferenciaDeMesa;
var
  sCupomfiscalVinculado : String;
  iConferirMesa : Integer;
  iCER : Integer;
  iCCF: Integer; // 2022-03-29
  bRetornoComando: Boolean; //2015-10-21
  sSEQUENCIALCONTACLIENTEOS: String; // Sandro Silva 2017-12-15
  sContaClienteOS: String; // Sandro Silva 2017-12-15
  sDescricao: String; // Sandro Silva 2018-03-21
  function FormataTextoImprimir(sTexto: String; iCaracterPorLinha: Integer = 45): String;
  var
    iCarac: Integer;
    iConta: Integer;
  begin
    iConta := 0;
    Result := '';
    for iCarac := 1 to Length(sTexto) do
    begin
      Inc(iConta);
      Result := Result + Copy(sTexto, iCarac, 1);
      if iConta > iCaracterPorLinha then
      begin
        Result := Result + Chr(10);
        iConta := 0;
      end;
    end;
  end;
begin

  //
  // CONSUMO
  //
  //
  if Form1.iMesaAberta = 0 then
  begin
    if Copy(Form1.sConcomitante,1,2) = 'OS' then
    begin
      sContaClienteOS := LimpaNumero(Form1.Small_InputBox('Conferência de '+Form1.sMesaOuConta,'Conferência de '+Form1.sMesaOuConta+' número: ',''));
      if Length(sContaClienteOS) = 10 then// Sandro Silva 2017-12-27 Polimig  if Length(sContaClienteOS) = 13 then
      begin
        Form1.IBQuery2.Close;
        Form1.IBQuery2.SQL.Clear;
        Form1.IBQuery2.SQL.Add('select max(PEDIDO) as PEDIDO from ALTERACA where (TIPO=''MESA'' or TIPO=''DEKOL'') and SEQUENCIALCONTACLIENTEOS='+QuotedStr(Right('00000000000' + sContaClienteOS, 10))+' ');
        Form1.IBQuery2.Open;
        iConferirMesa := StrToIntDef(Form1.IBQuery2.FieldByName('PEDIDO').AsString, 0);
      end
      else
        iConferirMesa := StrToIntDef(Copy(sContaClienteOS, 1, 3), 0);
    end
    else
      iConferirMesa := StrToInt('0'+Form1.Small_InputBox('Conferência de '+Form1.sMesaOuConta,'Conferência de '+Form1.sMesaOuConta+' número: ',''));

    Form1.Repaint;
  end else
  begin
    Commitatudo(False); // Conferencia de mesas
    // 2015-10-30  Não precisa Form1.ibDataSet27.Edit;
    Form1.sModeloECF := Form1.sModeloECF_Reserva;
    iConferirMesa    := Form1.iMesaAberta;
  end;
  //
  if (iConferirMesa <=0) or (iConferirMesa>StrToInt(Form1.sMesas)) then
  begin
    SmallMsg(Form1.sMesaOuConta+' inválida');
  end else
  begin

    if Copy(Form1.sConcomitante,1,2) = 'OS' then
    begin
      Form1.IBQuery2.Close;
      Form1.IBQuery2.SQL.Clear;
      Form1.IBQuery2.SQL.Add('select max(SEQUENCIALCONTACLIENTEOS) as SEQUENCIALCONTACLIENTEOS from ALTERACA where (TIPO=''MESA'' or TIPO=''DEKOL'') and PEDIDO='+QuotedStr(FormataNumeroDoCupom(iConferirMesa))+' '); // Sandro Silva 2021-12-01 Form1.IBQuery2.SQL.Add('select max(SEQUENCIALCONTACLIENTEOS) as SEQUENCIALCONTACLIENTEOS from ALTERACA where (TIPO=''MESA'' or TIPO=''DEKOL'') and PEDIDO='+QuotedStr(StrZero(iConferirMesa,6,0))+' ');
      Form1.IBQuery2.Open;
      sSEQUENCIALCONTACLIENTEOS := Form1.IBQuery2.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString;
    end;

    //
    Form1.IBQuery2.Close;
    Form1.IBQuery2.SQL.Clear;
    Form1.IBQuery2.SQL.Add('select * from ALTERACA where (TIPO=''MESA'' or TIPO=''DEKOL'') and PEDIDO='+QuotedStr(FormataNumeroDoCupom(iConferirMesa))+' order by ITEM'); // Sandro Silva 2021-12-01 Form1.IBQuery2.SQL.Add('select * from ALTERACA where (TIPO=''MESA'' or TIPO=''DEKOL'') and PEDIDO='+QuotedStr(StrZero(iConferirMesa,6,0))+' order by ITEM');
    Form1.IBQuery2.Open;
    Form1.IBQuery2.Last;

    //2015-09-01 - Imprime a conferência pela opção do menu ou quando abre uma mesa com itens lançados
    if (Form1.bImprimeConferencia = False) or (Form1.bImprimeConferencia and (Trim(Form1.IBQuery2.FieldByName('DESCRICAO').AsString) <> '')) then
    begin
      //
      if Pos('OS', Form1.sConcomitante) > 0 then
      begin// OS mínimo 10 para número da conta

        sCupomFiscalVinculado := ' '+chr(10)+'CONFERENCIA DE '+UpperCase(Form1.sMesaOuConta)+' '+ sSEQUENCIALCONTACLIENTEOS +chr(10);//sCupomFiscalVinculado := ' '+chr(10)+'CONFERENCIA DE '+UpperCase(sMesaOuConta)+' '+ Right(StrZero(iConferirMesa,6,0), 3) + sSEQUENCIALCONTACLIENTEOS +chr(10);

      end
      else
      begin
        sCupomFiscalVinculado := ' '+chr(10)
        +'CONFERENCIA DE '+UpperCase(Form1.sMesaOuConta)+' '+StrZero(iConferirMesa,6,0)+chr(10);
      end;

      if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99') then
      begin
        sCupomFiscalVinculado := CabecalhoRelatoriosGerenciais + sCupomFiscalVinculado;

        if (Form1.sModeloECF = '99') then
          sCupomFiscalVinculado := sCupomFiscalVinculado + ImprimeTracos()+Chr(10) + 'NÃO É DOCUMENTO FISCAL'+chr(10);

      end;


      sCupomFiscalVinculado := sCupomFiscalVinculado
      +ImprimeTracos()+Chr(10) // Sandro Silva 2018-03-21  +'-----------------------------------------------'+chr(10)
      +'IT  DESCRICAO         QTD     R$ UNIT  R$ TOTAL'+chr(10)
      +'--- ----------------- ------- -------- --------'+chr(10);
      //
      Form1.fTotal := 0;
      //
      Form1.IBQuery2.First;
      while not Form1.IBQuery2.Eof do
      begin
        //
        sDescricao := Copy(Form1.IBQuery2.FieldByName('DESCRICAO').AsString+Replicate(' ',19),1,17);
        if (Form1.sModeloECF_Reserva = '59') or (Form1.sModeloECF_Reserva = '65') or (Form1.sModeloECF_Reserva = '99') then
          sDescricao := Copy(Form1.IBQuery2.FieldByName('DESCRICAO').AsString+Replicate(' ',19),1,16);

        sCupomFiscalVinculado := sCupomFiscalVinculado
        + Right(Form1.IBQuery2.FieldByName('ITEM').AsString,3)
        + ' ' + sDescricao// Sandro Silva 2018-03-21  + ' ' + Copy(Form1.IBQuery2.FieldByName('DESCRICAO').AsString+Replicate(' ',19),1,17)
        + Right('         '+ FloatToStr(Form1.IBQuery2.FieldByName('QUANTIDADE').AsFloat) ,8)
        + ' ' + Format('%8.2n',[Form1.IBQuery2.FieldByName('UNITARIO').AsFloat])
        + ' ' + Format('%8.2n',[Form1.IBQuery2.FieldByName('TOTAL').AsFloat])
        +  Chr(10);
        if Form1.IBQuery2.FieldByName('VENDEDOR').AsString <> '<cancelado>' then
          Form1.fTotal := Form1.fTotal + Form1.IBQuery2.FieldByName('TOTAL').AsFloat;

        if Form1.IBQuery2.FieldByName('VENDEDOR').AsString = '<cancelado>' then
        begin
          sCupomFiscalVinculado := sCupomFiscalVinculado
          + ' - cancelado item ' + Right(Form1.IBQuery2.FieldByName('ITEM').AsString,3) // Daruma imprime caracteres estranhos quando usa sinal de menor < : <cancelado> è0¶ Sandro Silva 2020-09-03 + '<cancelado> item ' + Right(Form1.IBQuery2.FieldByName('ITEM').AsString,3)
          +  Chr(10);
        end;
        //
        if Alltrim(Form1.IBQuery2.FieldByName('DAV').AsString)<>'' then
        begin
          //
          sCupomFiscalVinculado := sCupomFiscalVinculado
          +'Item '+Right(Form1.IBQuery2.FieldByName('ITEM').AsString,3)+' Transferido da '+Alltrim(Copy(Form1.sMesaOuConta,1,5))+' '+Right(Form1.IBQuery2.FieldByName('DAV').AsString,3)+chr(10);
          //
        end;
        //
        Form1.IBQuery2.Next;
      end;

      //
      if (Form1.sModeloECF_Reserva = '59') or (Form1.sModeloECF_Reserva = '65') or (Form1.sModeloECF_Reserva = '99') then
      begin
        sCupomFiscalVinculado := sCupomFiscalVinculado
        +ImprimeTracos()+Chr(10)
        +Right(Replicate(' ', 46) + 'TOTAL R$' + Format('%8.2n',[Form1.fTotal]), 46) + Chr(10);
      end
      else
      begin
        sCupomFiscalVinculado := sCupomFiscalVinculado
        +'-----------------------------------------------'+chr(10)
        +'                               TOTAL R$' + Format('%8.2n',[Form1.fTotal]) + Chr(10);
      end;
      //
      if Form1.sConcomitante = 'OS'+LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString) then
      begin
        //
        Form11.CarregaInformacoesConta(iConferirMesa);// Sandro Silva 2018-03-21 Quando o imprime pelo menu F10 não tem uma conta aberta (Form1.iCupom = 0)  Form11.FormShow(Sender);
        sCupomFiscalVinculado := sCupomFiscalVinculado+
        '-----------------------------------------------'+chr(10)+
        FormataTextoImprimir(Form11.Label1.Caption + ': '+Form11.Edit1.Text)+chr(10)+ // Sandro Silva 2018-09-13   Form11.Label1.Caption + ': '+Form11.Edit1.Text+chr(10)+
        FormataTextoImprimir(Form11.Label2.Caption + ': '+Form11.Edit2.Text)+chr(10)+ // Sandro Silva 2018-09-13   Form11.Label2.Caption + ': '+Form11.Edit2.Text+chr(10)+
        FormataTextoImprimir(Form11.Label3.Caption + ': '+Form11.Edit3.Text)+chr(10)+ // Sandro Silva 2018-09-13   Form11.Label3.Caption + ': '+Form11.Edit3.Text+chr(10)+
        FormataTextoImprimir(Form11.Label4.Caption + ': '+Form11.Edit4.Text)+chr(10)+ // Sandro Silva 2018-09-13   Form11.Label4.Caption + ': '+Form11.Edit4.Text+chr(10)+
        FormataTextoImprimir(Form11.Label5.Caption + ': '+Form11.Edit5.Text)+chr(10)+ // Sandro Silva 2018-09-13   Form11.Label5.Caption + ': '+Form11.Edit5.Text+chr(10)+
        '-----------------------------------------------'+chr(10)
        //
      end;
      //
      if (Form1.sModeloECF_Reserva <> '99') then // Sandro Silva 2020-09-29
      begin
        if PAFNFCe then
          sCupomFiscalVinculado := sCupomFiscalVinculado
            +'AGUARDE A EMISSAO DO CUPOM FISCAL'+chr(10)
        else
          sCupomFiscalVinculado := sCupomFiscalVinculado
            +'AGUARDE A EMISSAO '+UpperCase(Form1.sTipoDocumento)+chr(10);
      end;
      //
      bRetornoComando := Form1.PDV_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado));
      //
      if bRetornoComando then
        Form1.Demais('CM');
      //
      if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99') then
      begin
        iCCF := 0;
        if PAFNFCe then
        begin
          iCCF := StrToInt(_ecf65_ContadorGRG(Form1.ibDataSet27.Transaction.DefaultDatabase, Form1.sCaixa, 0));
        end;
      end
      else
        iCCF := StrToInt(Form1.PDV_NumeroDoCupom(False));
      if (Form1.sModeloECF = '03') or (Form1.sModeloECF = '17') then
        iCCF := iCCF - 1;
      //
      iCER := Form1.iCupom;
      //
      if AllTrim(UpperCase(Form1.sMesaOuConta)) <> 'MESA' then
      begin
        //
        // True e conta
        //
        if Form1.sModeloECF = '02' then iCER := StrToInt('0'+Limpanumero(_ecf02_CER(True)));
        if Form1.sModeloECF = '03' then iCER := StrToInt('0'+Limpanumero(_ecf03_CER(True)));
        if Form1.sModeloECF = '15' then iCER := StrToIntDef(Limpanumero(_ecf15_CER(sCupomfiscalVinculado)), 0);
        if Form1.sModeloECF = '17' then iCER := StrToInt('0'+Limpanumero(_ecf17_CER(True)));
      end else
      begin
        //
        // false é mesa
        //
        if Form1.sModeloECF = '02' then iCER := StrToInt('0'+Limpanumero(_ecf02_CER(False)));
        if Form1.sModeloECF = '03' then iCER := StrToInt('0'+Limpanumero(_ecf03_CER(False)));
        if Form1.sModeloECF = '15' then iCER := StrToIntDef(Limpanumero(_ecf15_CER(sCupomfiscalVinculado)), 0);
        if Form1.sModeloECF = '17' then iCER := StrToInt('0'+Limpanumero(_ecf17_CER(False)));
      end;
      //
      CommitaTudo(False); // Conferencia de mesas
      //
      if ((Form1.sModeloECF <> '59') and (Form1.sModeloECF <> '65') and (Form1.sModeloECF <> '99')) or (PAFNFCe) then // Sandro Silva 2020-12-09 if (Form1.sModeloECF <> '59') and (Form1.sModeloECF <> '65') and (Form1.sModeloECF <> '99') then
      begin // Para NFCe estava gravando o número do cupom anterior no COO do atual
        Form1.ibDataSet27.Close;
        Form1.ibDataSet27.SelectSQL.Text  :=
          'select * ' +
          'from ALTERACA ' +
          'where (TIPO = ''MESA'' or TIPO = ''DEKOL'') ' +
          'and PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(iConferirMesa));// Sandro Silva 2021-12-01 'and PEDIDO = ' + QuotedStr(StrZero(iConferirMesa,6,0));
        Form1.ibDataSet27.Open;
        while Form1.ibDataSet27.Eof = False do
        begin
          Form1.ibDataSet27.Edit;
          Form1.ibDataSet27.FieldByName('CAIXA').AsString := Form1.sCaixa;
          Form1.ibDataSet27.FieldByName('CCF').AsString   := FormataNumeroDoCupom(iCER); // Sandro Silva 2021-12-01 Form1.ibDataSet27.FieldByName('CCF').AsString   := strZero(iCER,6,0);
          Form1.ibDataSet27.FieldByName('COO').AsString   := FormataNumeroDoCupom(iCCF); // Sandro Silva 2021-12-01 Form1.ibDataSet27.FieldByName('COO').AsString   := strZero(iCCF,6,0);
          Form1.ibDataSet27.Post;
          Form1.ibDataSet27.Next;
        end;
        Form1.ibDataSet27.Close;
        //
        CommitaTudo(True); // Conferencia de mesas. Exibir itens lançados nas mesas por 2 terminais diferentes. Um não exibe os dados do outro na primeira abertura da mesa. Ver com Gian/Fernanda
      end;
      Sleep(1000);
      //
    end;
  end;
  //
  if not (Form1.iMesaAberta = 0) then
  begin
    Form1.sModeloECF := '01';
  end;
  //
  Form1.ibQuery1.Close;
  //
  //
end;

procedure RelatorioMeiosDePagamento;
var
  I : Integer;
  // fSuprimento,
  fTotal : Real;
  // sSuprimento, sFORMA,
  sTipoDocumentoPAF, sCupomfiscalVinculado : String;
  bRetornoComando: Boolean;
  sCaixa: String; // 2016-01-18
  dTotalCaixa: Double; // 2016-01-18
  sImportadoNFe: String;
  sForma: String;
begin
  CommitaTudo(True); // MeiosdePagto1Click// 2015-09-12
  //
  Form1.sAjuda := 'ecf_cotepe.htm#Meios de Pagto.';
  //
  Form7.sMfd  := '9';
  Form7.Label1.Caption := 'Informe o período para o relatório de Meios ' +
                          'de Pagamento e <Avançar> para continuar.';
  //Form7.Label2.Caption := 'de Pagamento e <Avançar> para continuar.';
  Form7.DateTimePicker1.Visible := True;
  Form7.DateTimePicker2.Visible := True;
  Form7.MaskEdit1.Visible       := False;
  Form7.MaskEdit2.Visible       := False;
  Form7.CheckBox1.Visible       := False;
  Form7.Label3.Caption          := 'Data inicial:';
  Form7.Label5.Caption          := 'Data final:';
  Form7.Caption := 'Meios de pagamento por data';
  Form7.checkMeioPagamento.Visible := True; // Sandro Silva 2017-12-15
  Form1.Timer2.Enabled := False; // Sandro Silva 2016-03-23
  Form7.ShowModal;
  if Form7.ModalResult = mrOK then
  begin
    Form1.Repaint;
    //
    if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99') then
    begin
      sCupomFiscalVinculado :=
      CabecalhoRelatoriosGerenciais  + Chr(10) +// Sandro Silva 2020-07-07
      'Relatório de Meios de Pagamento' + Chr(10) +
                               'Período Solicitado: de '+DateToStr(Form7.DateTimePicker1.Date)+' a '+DateToStr(Form7.DateTimePicker2.Date)+Chr(10);

      if (Form1.sModeloECF = '65') and (Form1.UsaIntegradorFiscal() = False) then // Sandro Silva 2019-10-16 if (Form1.sModeloECF = '65') then 
      begin
        if _ecf65_VerificaContingenciaPendentedeTransmissao(Form7.DateTimePicker1.Date, Form7.DateTimePicker2.Date, Form1.sCaixa) then
          sCupomFiscalVinculado := sCupomFiscalVinculado + ALERTA_CONTINGENCIA_NAO_TRANSMITIDA + Chr(10);
      end;

    end
    else
      sCupomFiscalVinculado := 'Período Solicitado: de '+DateToStr(Form7.DateTimePicker1.Date)+' a '+DateToStr(Form7.DateTimePicker2.Date)+Chr(10);

    //
    for I := 0 to DaysBetween(Form7.DateTimePicker2.Date, Form7.DateTimePicker1.Date) do
    begin
      //
      Form1.ibDataSet99.Close;
      Form1.ibDataSet99.SelectSQL.Clear;
      Form1.ibDataSet99.SelectSQL.Add('select PEDIDO, DATA, FORMA, VALOR from PAGAMENT where DATA='+QuotedStr( DateToStrInvertida(Form7.DateTimePicker1.Date+I))+ ' and DATA<='+QuotedStr( DateToStrInvertida(Form7.DateTimePicker2.Date ))+' and FORMA<>''13 Troco'' and FORMA<>''00 Total'' and coalesce(CLIFOR,''X'')<>''Sangria'' and coalesce(CLIFOR,''X'')<>''Suprimento'' order by DATA, REGISTRO');
      if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') then //or (Form1.sModeloECF = '99') then
        Form1.ibDataSet99.SelectSQL.Text :=
          'select P.PEDIDO, P.DATA, P.CAIXA, P.FORMA, ' +
          'case when substring(P.forma from 1 for 2) = ''13'' then (P.valor * -1) else P.VALOR end as VALOR ' + // Sandro Silva 2018-06-19  'P.VALOR ' +
          'from PAGAMENT P ' +
          'left join NFCE on NFCE.NUMERONF = P.PEDIDO and NFCE.CAIXA = P.CAIXA ' + // Sandro Silva 2018-08-15
          'where P.DATA = ' + QuotedStr(DateToStrInvertida(Form7.DateTimePicker1.Date + I)) +
          ' and P.DATA <= ' + QuotedStr(DateToStrInvertida(Form7.DateTimePicker2.Date)) +
          ' and P.FORMA<>''00 Total'' ' +// Sandro Silva 2018-06-19  ' and P.FORMA<>''13 Troco'' and P.FORMA<>''00 Total'' ' +
          ' and coalesce(P.CLIFOR,''X'')<>''Sangria'' ' +
          ' and coalesce(P.CLIFOR,''X'')<>''Suprimento'' ' +
          ' and P.FORMA not containing ''Entrada'' ' + // Sandro Silva 2016-03-14 POLIMIG homologa gerando nf-e entrada listando no REGISTROS DO PAF A2
          ' and P.FORMA not containing ''NF-e'' ' + // Sandro Silva 2016-07-13 Não listar as NF-e emitidas pelo Small Commerce
          ' and (NFCE.STATUS containing ''Autorizad'' or NFCE.STATUS containing ''Emitido com sucesso'' or NFCE.STATUS containing ' + QuotedStr(NFCE_EMITIDA_EM_CONTINGENCIA) + ' or NFCE.STATUS containing ' + QuotedStr(VENDA_GERENCIAL_FINALIZADA) + ' or NFCE.STATUS containing ' + QuotedStr(VENDA_MEI_ANTIGA_FINALIZADA) + ') ' + // Sandro Silva 2021-09-09 Ficha 5499 ' and (NFCE.STATUS containing ''Autorizad'' or NFCE.STATUS containing ''Emitido com sucesso'') ' + // Sandro Silva 2018-08-15
          ' order by P.DATA, P.CAIXA, P.REGISTRO';
      if (Form1.sModeloECF = '99') then
        Form1.ibDataSet99.SelectSQL.Text :=
          'select PEDIDO, DATA, FORMA, VALOR, CAIXA from PAGAMENT where DATA='+QuotedStr( DateToStrInvertida(Form7.DateTimePicker1.Date+I))+ ' and DATA<='+QuotedStr( DateToStrInvertida(Form7.DateTimePicker2.Date ))+' and FORMA<>''13 Troco'' and FORMA<>''00 Total'' and coalesce(CLIFOR,''X'')<>''Sangria'' and coalesce(CLIFOR,''X'')<>''Suprimento'' order by DATA, REGISTRO';
      Form1.ibDataSet99.Open;
      Form1.ibDataSet99.First;
      //
      fTotal := 0;
      dTotalCaixa := 0;
      //
      sCaixa := Form1.ibDataSet99.FieldByName('CAIXA').AsString;
      while not Form1.ibDataSet99.Eof do
      begin
        //
        sTipoDocumentoPAF := 'CF';
        if (Form1.sModeloECF <> '99') then // Sandro Silva 2020-09-24 
          sTipoDocumentoPAF := '';

        if (Form1.sModeloECF <> '59') and (Form1.sModeloECF <> '65') and (Form1.sModeloECF <> '99') or (Form1.ibDataSet99.FieldByName('VALOR').AsFloat <> 0) then //  Sandro Silva 2018-06-19
        begin // Quando for PAF-ECF ou valor diferente de Zero (Troco tem valor negativo para diminuir do recebido)
        //
          if Pos('NF-e',Form1.ibDataSet99.FieldByName('FORMA').AsString) <> 0 then sTipoDocumentoPAF := 'NF';
          if Pos('NFC-e',Form1.ibDataSet99.FieldByName('FORMA').AsString) <> 0 then sTipoDocumentoPAF := 'NF';

          // Sandro Silva 2016-07-14  Aguardando ficha com sugestão do cliente
          // Se for 59 sTipoDocumentoPAF = 'CF-e-SAT';
          // Se for 65 sTipoDocumentoPAF = 'NCF-e';
          if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99') then
          begin
            Form1.IBDataSet999.Close;
            Form1.IBDataSet999.SelectSQL.Text :=
              'select NUMERONF, MODELO ' +
              'from NFCE ' +
              'where NUMERONF = ' + QuotedStr(Form1.ibDataSet99.FieldByName('PEDIDO').AsString) +
              ' and CAIXA = ' + QuotedStr(Form1.ibDataSet99.FieldByName('CAIXA').AsString);
            Form1.IBDataSet999.Open;
            if Form1.IBDataSet999.FieldByName('NUMERONF').AsString = Form1.ibDataSet99.FieldByName('PEDIDO').AsString then
            begin
              if Form1.IBDataSet999.FieldByName('MODELO').AsString = '59' then
                sTipoDocumentoPAF := 'CF-e'; // Sandro Silva 2018-03-21 'CF-e-SAT';
              if Form1.IBDataSet999.FieldByName('MODELO').AsString = '65' then
                sTipoDocumentoPAF := 'NFC-e';
              if Form1.IBDataSet999.FieldByName('MODELO').AsString = '99' then
                sTipoDocumentoPAF := 'Doc.';
            end;
            Form1.IBDataSet999.Close;
          end;

          if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99') then
          begin
            // Identifica as vendas importadas para NF-e. Ficha 3243
            Form1.IBQuery65.Close;
            Form1.IBQuery65.SQL.Text :=
              'select first 1 A.VALORICM ' +
              'from ALTERACA A ' +
              'where A.PEDIDO = ' + QuotedStr(Form1.ibDataSet99.FieldByName('PEDIDO').AsString) +
              ' and A.CAIXA = ' + QuotedStr(Form1.ibDataSet99.FieldByName('CAIXA').AsString) +
              ' and A.DATA = ' +  QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.ibDataSet99.FieldByName('DATA').AsDateTime)) +
              ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''VENDA'') ' +
              ' and coalesce(A.VALORICM, 0) > 0 ';
            Form1.IBQuery65.Open;
            if Form1.IBQuery65.FieldByName('VALORICM').AsFloat > 0 then
            begin
              sCupomFiscalVinculado := sCupomFiscalVinculado + '*';
              sImportadoNFe := sImportadoNFe + Form1.ibDataSet99.FieldByName('CAIXA').AsString + ' ' + Form1.ibDataSet99.FieldByName('PEDIDO').AsString + ' ' + Form1.ibDataSet99.FieldByName('DATA').AsString + ' ' + Format('%9.2n',[Form1.ibDataSet99.FieldByName('VALOR').AsFloat]) + chr(10);
            end;
          end;

          sForma := Copy(StringReplace(StringReplace(Trim(Copy(Form1.ibDataSet99.FieldByName('FORMA').AsString, 4, 30)), ' NF-e', '', [rfReplaceAll]), ' NFC-e', '', [rfReplaceAll]) + Replicate(' ', 19), 1, 13) + ' ' + Copy(sTipoDocumentoPAF + '    ', 1, 5);
          if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99') then
          begin
            dTotalCaixa := dTotalCaixa + Form1.ibDataSet99.FieldByName('VALOR').AsFloat;
            sCupomFiscalVinculado := sCupomFiscalVinculado + Form1.ibDataSet99.FieldByName('CAIXA').AsString + ' ' + Form1.ibDataSet99.FieldByName('DATA').AsString + ' ' + sForma + ' ' + ' ' + Format('%9.2n',[Form1.ibDataSet99.FieldByName('VALOR').AsFloat]) + chr(10)
          end
          else
          begin
            sCupomFiscalVinculado := sCupomFiscalVinculado + Form1.ibDataSet99.FieldByName('DATA').AsString + ' ' + sForma +' - '+ Format('%9.2n',[Form1.ibDataSet99.FieldByName('VALOR').AsFloat]) + chr(10);
          end;
          fTotal := fTotal + Form1.ibDataSet99.FieldByName('VALOR').AsFloat;

        end;// if (Form1.sModeloECF <> '59') and (Form1.sModeloECF <> '65') or (Form1.ibDataSet99.FieldByName('VALOR').AsFloat > 0) then

        Form1.ibDataSet99.Next;

        if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99') then
        begin
          if (sCaixa <> Form1.ibDataSet99.FieldByName('CAIXA').AsString) or (Form1.ibDataSet99.Eof) then
          begin
            sCupomFiscalVinculado := sCupomFiscalVinculado + 'Total Caixa: ' + sCaixa + ' ' + Format('%9.2n',[dTotalCaixa]) + Chr(10);
            sCaixa                := Form1.ibDataSet99.FieldByName('CAIXA').AsString;
            dTotalCaixa           := 0.00;
          end;
        end;
        //
      end;
      //
      if fTotal <> 0 then sCupomFiscalVinculado := sCupomFiscalVinculado + 'SOMA DO DIA '+DatetoStr(Form7.DateTimePicker1.Date+I)+' = '+ Format('%9.2n',[fTotal])+chr(10);
      //
    end; // for I := 0 to DaysBetween(Form7.DateTimePicker2.Date, Form7.DateTimePicker1.Date) do
    //
    sCupomFiscalVinculado := sCupomFiscalVinculado + 'TOTAL DO PERÍODO SOLICITADO:'+chr(10);
    //
    Form1.ibDataSet99.Close;
    Form1.ibDataSet99.SelectSQL.Clear;

    Form1.ibDataSet99.SelectSql.Text :=
      'select P.CAIXA, replace(P.FORMA, '' NFC-e'', '' NF-e'') as FORMA, sum(P.VALOR) as VTOT ' +
      'from PAGAMENT P ' +
      'where P.DATA between ' + QuotedStr(DateToStrInvertida(Form7.DateTimePicker1.Date)) + ' and  ' + QuotedStr(DateToStrInvertida(Form7.DateTimePicker2.Date)) +
      ' and P.FORMA<>''13 Troco'' ' +
      ' and P.FORMA<>''00 Total'' ' +
      ' and coalesce(P.CLIFOR,''X'')<>''Sangria'' ' +
      ' and coalesce(P.CLIFOR,''X'')<>''Suprimento'' ' +
      ' group by P.CAIXA, replace(P.FORMA, '' NFC-e'', '' NF-e'') ' +
      ' order by 1';

    if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') then // or (Form1.sModeloECF = '99') then
    begin
      Form1.ibDataSet99.SelectSql.Text :=
        'select P.CAIXA, replace(P.FORMA, '' NFC-e'', '' NF-e'') as FORMA, ' +
        'sum(case when substring(P.forma from 1 for 2) = ''13'' then (P.valor * -1) else P.VALOR end) as VTOT ' + // Sandro Silva 2018-06-19  'sum(P.VALOR) as VTOT ';
        'from PAGAMENT P ' +
        'left join NFCE on NFCE.NUMERONF = P.PEDIDO and NFCE.CAIXA = P.CAIXA ' + // Sandro Silva 2018-08-15
        'where P.DATA between ' + QuotedStr(DateToStrInvertida(Form7.DateTimePicker1.Date)) + ' and  ' + QuotedStr(DateToStrInvertida(Form7.DateTimePicker2.Date)) +
        ' and P.FORMA<>''00 Total'' ' +
        ' and coalesce(P.CLIFOR,''X'')<>''Sangria'' ' +
        ' and coalesce(P.CLIFOR,''X'')<>''Suprimento'' ' +
        ' and P.FORMA not containing ''NF-e'' ' + // Sandro Silva 2016-07-13 Não listar as NF-e emitidas pelo Small Commerce
        ' and (NFCE.STATUS containing ''Autorizad'' or NFCE.STATUS containing ''Emitido com sucesso'' or NFCE.STATUS containing ' + QuotedStr(NFCE_EMITIDA_EM_CONTINGENCIA) + ') ' + // Sandro Silva 2021-09-09 Ficha 5499 ' and (NFCE.STATUS containing ''Autorizad'' or NFCE.STATUS containing ''Emitido com sucesso'') ' + // Sandro Silva 2018-08-15        
        ' group by P.CAIXA, replace(P.FORMA, '' NFC-e'', '' NF-e'') ' +
        ' order by 1, 2';
    end;

    Form1.ibDataSet99.Open;
    Form1.ibDataSet99.First;
    //
    fTotal := 0;
    //
    while not Form1.ibDataSet99.Eof do
    begin
      //
      sTipoDocumentoPAF := 'CF';
      if (Form1.sModeloECF <> '99') then // Sandro Silva 2020-09-24 
        sTipoDocumentoPAF := '';

      //
      if Pos('NF-e',Form1.ibDataSet99.FieldByName('FORMA').AsString) <> 0 then sTipoDocumentoPAF := 'NF';
      if Pos('NFC-e',Form1.ibDataSet99.FieldByName('FORMA').AsString) <> 0 then sTipoDocumentoPAF := 'NF';

      Form1.IBDataSet999.Close;
      Form1.IBDataSet999.SelectSQL.Text :=
        'select CAIXA, MODELO ' +
        'from NFCE ' +
        'where CAIXA = ' + QuotedStr(Form1.ibDataSet99.FieldByName('CAIXA').AsString);
      Form1.IBDataSet999.Open;
      if Form1.IBDataSet999.FieldByName('CAIXA').AsString = Form1.ibDataSet99.FieldByName('CAIXA').AsString then
      begin
        if Form1.IBDataSet999.FieldByName('MODELO').AsString = '59' then
          sTipoDocumentoPAF := 'CF-e'; // Sandro Silva 2018-03-21 'CF-e-SAT';
        if Form1.IBDataSet999.FieldByName('MODELO').AsString = '65' then
          sTipoDocumentoPAF := 'NFC-e';
        if Form1.IBDataSet999.FieldByName('MODELO').AsString = '99' then
          sTipoDocumentoPAF := 'Doc.';
      end;
      Form1.IBDataSet999.Close;

      //
      if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99') then
        sCupomFiscalVinculado := sCupomFiscalVinculado + Form1.ibDataSet99.FieldByName('CAIXA').AsString + ' ';
      sForma := Copy(StringReplace(StringReplace(Trim(Copy(Form1.ibDataSet99.FieldByName('FORMA').AsString, 4, 30)), ' NF-e', '', [rfReplaceAll]), ' NFC-e', '', [rfReplaceAll]) + Replicate(' ', 19), 1, 13);
      sCupomFiscalVinculado := sCupomFiscalVinculado + sForma + ' ' + Copy(sTipoDocumentoPAF + '     ', 1, 5) + ' ' + Format('%9.2n', [Form1.ibDataSet99.FieldByName('VTOT').AsFloat]) + chr(10);
      fTotal := fTotal + Form1.ibDataSet99.FieldByName('VTOT').AsFloat;

      Form1.ibDataSet99.Next;
      //
    end;
    //
    sCupomFiscalVinculado := sCupomFiscalVinculado + 'SOMA TOTAL:'+ Format('%9.2n',[fTotal])+chr(10)+chr(10)+chr(10);

    if sImportadoNFe <> '' then
    begin
      sCupomFiscalVinculado := sCupomFiscalVinculado + 'Cupons importados para NF-e' + Chr(10) + sImportadoNFe + Chr(10) + Chr(10) + Chr(10);
    end;

    //
    // SmallMsg(sCupomFiscalVinculado);
    //
    if fTotal <> 0 then
    begin
      //
      bRetornoComando := False; // Sandro Silva 2018-07-18
      if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99') then// Sandro Silva 2018-03-22  if Form1.sModeloECF = '65' then
      begin
        if (Form1.sModeloECF = '65') then
          bRetornoComando := _ecf65_ImpressaoNaoSujeitoaoICMS(sCupomFiscalVinculado, Form7.checkMeioPagamento.Checked);
        if (Form1.sModeloECF = '59') then
          bRetornoComando := _ecf59_ImpressaoNaoSujeitoaoICMS(sCupomFiscalVinculado, Form7.checkMeioPagamento.Checked);
        if (Form1.sModeloECF = '99') then
          bRetornoComando := _ecf99_ImpressaoNaoSujeitoaoICMS(sCupomFiscalVinculado, Form7.checkMeioPagamento.Checked);
      end
      else
        bRetornoComando := Form1.PDV_ImpressaoNaoSujeitoaoICMS(sCupomFiscalVinculado);
      //
      if bRetornoComando then // 2015-10-06
        Form1.Demais('RG');
      //
    end
    else
    begin
      {Sandro Silva 2021-08-10 inicio}
      if ((Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99')) and (PAFNFCE = False) then
      begin
        //Form1.ExibePanelMensagem('Não houve movimento no período informado'); // Sandro Silva 2021-08-10
        Form1.Display('Não houve movimento no período informado', 'Não houve movimento no período informado');
        Sleep(3000);
        Form1.Display(Form1.sStatusECF, Form1.sF);
      end;
      {Sandro Silva 2021-08-10 fim}
    end;
  end;
  //
  //
  //
  if Form1.ImportarvendasdoSmallMobile1.Checked then // Sandro Silva 2016-03-23
    Form1.Timer2.Enabled := True;
  Form7.checkMeioPagamento.Visible := False; // Sandro Silva 2017-12-15
end;

function CabecalhoRelatoriosGerenciais: String;
begin
  Result := Form1.ibDataSet13.FieldByName('NOME').AsString  + chr(10)
    + 'CNPJ: ' + Form1.ibDataSet13.FieldByName('CGC').AsString // Sandro Silva 2020-07- 07  + chr(10)
    + '  IE: ' + Form1.ibDataSet13.FieldByName('IE').AsString  + chr(10)
    + 'Data: ' + FormatDateTime('dd/mm/yyyy HH:nn:ss', Now) + Chr(10); // Sandro Silva 2020-07-07
end;

procedure RelatorioImpressaoOrcamento;
var
  sCupom, sCodigo, sOrcame, sCupomFiscalVinculado : String;
  fDesconto, fTotal : Real;
  bRetornoComando: Boolean;
  bReimpressaoPermitida: Boolean;
begin
  bReimpressaoPermitida := True;
  CommitaTudo(True);// Form1.Imprimiroramento1Click Atualizar informações gravadas por outros módulos
  //----------------------------------------- //
  //                                          //
  //           O R Ç A M E N T O              //
  //                                          //
  //  Imprime um DAV Orçamento no ECF, este   //
  //  parametro deve ser configurado no arq.  //
  //  auxiliar criptografado, inacessível.    //
  //----------------------------------------- //
  if (Form1.sModeloECF = '59') or ((Form1.sModeloECF = '65') and (PAFNFCe = False)) or (Form1.sModeloECF = '99') then // Sandro Silva 2020-12-15 if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99') then
    sOrcame := Form1.ImportarDaPesquisa(tpPesquisaOrca) // Sandro Silva 2019-07-12
  else
    sOrcame := StrZero(StrToInt('0'+Limpanumero(Form1.Small_InputBox('Imprimir orçamento...','Número do orçamento:',''))),10,0);
  //
  Form1.Repaint;
  //
  Form1.ibDataSet37.Close;
  Form1.ibDataSet37.SelectSql.Clear;
  Form1.ibDataSet37.SelectSQL.Add('select * from ORCAMENT where PEDIDO='+QuotedStr(sOrcame)+' and PEDIDO<>'+QuotedStr('0000000000')+' ');
  Form1.ibDataSet37.Open;
  Form1.ibDataSet37.First;

  if PAFNFCe then
  begin
    if Form1.ibDataSet37.FieldByName('NUMERONF').AsString <> '' then
      bReimpressaoPermitida := False;
  end;

  //
  if bReimpressaoPermitida then
  begin
    if not Form1.ibDataSet37.Eof then
    begin
      //
      Form1.IBQuery1.Close;
      Form1.IBQuery1.SQL.Clear;
      Form1.IBQuery1.SQL.Add('select * from CLIFOR where NOME='+QuotedStr(Form1.ibDataSet37.FieldByName('CLIFOR').AsString)+'');
      Form1.IBQuery1.Open;
      //
      sCupomFiscalVinculado :=
      'DOCUMENTO AUXILIAR DE VENDA (DAV) - ORCAMENTO'+chr(10)+
      'NÃO É DOCUMENTO FISCAL'+chr(10)+
      'NÃO É VÁLIDO COMO RECIBO E COMO GARANTIA DE'+chr(10)+
      'MERCADORIA - NÃO COMPROVA PAGAMENTO'+chr(10)+
      '------------------------------------------------'+chr(10);

      if (Form1.sModeloECF_Reserva = '59') or (Form1.sModeloECF_Reserva = '65') or (Form1.sModeloECF_Reserva = '99') then
        sCupomFiscalVinculado := sCupomFiscalVinculado + 'Data: ' + FormatDateTime('dd/mm/yyyy', Form1.ibDataSet37.FieldByName('DATA').AsDateTime) + Chr(10); // Sandro Silva 2017-02-02

      sCupomFiscalVinculado := sCupomFiscalVinculado +
      'Emitente:'+char(10)+
      'Denominação: '+ Copy(Form1.ibDataSet13.FieldByName('NOME').AsString + Replicate(' ',40-13),1,40-13)+chr(10)+
      'CNPJ: ' + Form1.ibDataSet13.FieldByName('CGC').AsString+chr(10);
      if (Form1.sModeloECF_Reserva = '59') or (Form1.sModeloECF_Reserva = '65') or (Form1.sModeloECF_Reserva = '99') then
        sCupomFiscalVinculado := sCupomFiscalVinculado + 'Telefone: ' + Form1.ibDataSet13.FieldByName('TELEFO').AsString+chr(10); // Sandro Silva 2017-02-02

      sCupomFiscalVinculado := sCupomFiscalVinculado +
      '-----------------------------------------------'+chr(10)+
      'Destinatário:'+char(10)+
      'Denominação: '+ Copy(Form1.IBQuery1.FieldByName('NOME').AsString + Replicate(' ',40-13),1,40-13)+chr(10)+
      'CNPJ: '+ Form1.IBQuery1.FieldByName('CGC').AsString +chr(10)+
      '-----------------------------------------------'+chr(10)+
      'Número do Orçamento: '+Form1.ibDataSet37.FieldByName('PEDIDO').AsString+chr(10)+
      'Número do Documento Fiscal: '+Form1.ibDataSet37.FieldByName('NUMERONF').AsString+chr(10)+
      //
      '-----------------------------------------------'+chr(10)+
      'CÓDIGO        DESCRIÇÃO                         '+ Chr(10)+ // 2016-01-19
      'QTD         UNITARIO      TOTAL'+chr(10)+ // 2016-01-19
      '------------------------------------------------'+chr(10)+'';
      //
      fTotal := 0;
      fdesconto := 0;
      //
      while not Form1.ibDataSet37.Eof do
      begin
        //
        if (Form1.ibDataSet37.FieldByName('PEDIDO').AsString = sOrcame) then
        begin
          //
          if UpperCase(AllTrim(Form1.ibDataSet37.FieldByName('DESCRICAO').AsString))  = 'DESCONTO' then
          begin
            //
            fDesconto := fDesconto + Form1.ibDataSet37.FieldByName('TOTAL').AsFloat;
            //
          end else
          begin
            //
            Form1.ibDataSet4.Close;
            Form1.ibDataSet4.SelectSQL.Clear;
            Form1.ibDataSet4.SelectSQL.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(Alltrim(Form1.ibDataSet37.FieldByName('DESCRICAO').AsString))+' and coalesce(ATIVO,0)=0 ');
            Form1.ibDataSet4.Open;
            //
            if (AllTrim(Form1.ibDataSet4.FieldByName('DESCRICAO').AsString) = Alltrim(Form1.ibDataSet37.FieldByName('DESCRICAO').AsString))
              and (Form1.ibDataSet4.FieldByName('DESCRICAO').AsString <> '') then
            begin
              //
              if (Length(AllTrim(Form1.ibDataSet4.FieldByName('REFERENCIA').AsString)) = 13)
              or (Length(AllTrim(Form1.ibDataSet4.FieldByName('REFERENCIA').AsString)) = 14)
              or (Length(AllTrim(Form1.ibDataSet4.FieldByName('REFERENCIA').AsString)) = 12)
              or (Length(AllTrim(Form1.ibDataSet4.FieldByName('REFERENCIA').AsString)) = 8)
                then sCodigo := Form1.ibDataSet4.FieldByName('REFERENCIA').AsString
                  else sCodigo := StrZero(StrToInt(Form1.ibDataSet4.FieldByName('CODIGO').AsString),14,0);

              sCupomFiscalVinculado := sCupomFiscalVinculado + sCodigo + ' ' + Copy(Form1.ibDataSet37.FieldByName('DESCRICAO').AsString+Replicate(' ',30),1,30)+chr(10)+
              Format('%10.2n',[Form1.ibDataSet37.FieldByName('QUANTIDADE').AsFloat])+'X'+
              Format('%10.2n',[Form1.ibDataSet37.FieldByName('UNITARIO').AsFloat])+' '+
              Format('%10.2n',[Form1.ibDataSet37.FieldByName('TOTAL').AsFloat])+chr(10);
              //
              fTotal := fTotal +  Form1.ibDataSet37.FieldByName('TOTAL').AsFloat;
              //
            end else
            begin
              sCupomFiscalVinculado := sCupomFiscalVinculado + '               ' + Copy(Form1.ibDataSet37.FieldByName('DESCRICAO').AsString+Replicate(' ',30),1,30)+chr(10);
              if Copy(Form1.ibDataSet37.FieldByName('DESCRICAO').AsString, 31, 15) <> '' then
                sCupomFiscalVinculado := sCupomFiscalVinculado + '               ' + Copy(Copy(Form1.ibDataSet37.FieldByName('DESCRICAO').AsString, 31, 15)+Replicate(' ',30),1,30)+chr(10);
            end;
          end;
          //
          Form1.ibDataSet37.Next;
          //
        end;
      end;
      //
      sCupomFiscalVinculado := sCupomFiscalVinculado + '------------------------------------------------'+chr(10)+
      'SUB TOTAL                           '+Format('%10.2n',[fTotal])+chr(10)+
      'DESCONTO                            '+Format('%10.2n',[fDesconto])+chr(10)+
      'TOTAL                               '+Format('%10.2n',[fTotal-fDesconto])+chr(10)+
      'É vedada a autenticação deste documento'+chr(10)+chr(10);


      //
      if Length(sCupomfiscalVinculado) > 80 then
      begin
        bRetornoComando := Form1.PDV_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado));
        //
        if bRetornoComando then // 2015-10-06
          Form1.Demais('RG');
        //
      end;
    end else
    begin
      SmallMsg('Orçamento não encontrado.');
    end;
  end
  else
  begin
    ShowMessage('É vedada a reimpressão quando emitido Documento Fiscal'); // Sandro Silva 2020-12-07  
  end; // if bReimpressaoPermitida then
  
  //
  if (Form1.sModeloECF <> '59') and (Form1.sModeloECF <> '65') and (Form1.sModeloECF <> '99') then
  begin
    sCupom := FormataNumeroDoCupom(StrToInt(Form1.PDV_NumeroDoCupom(False))); // Sandro Silva 2021-12-02 sCupom := StrZero(StrToInt(Form1.PDV_NumeroDoCupom(False)), 6, 0);
    //
    try
      Form1.IBQuery1.Close;
      Form1.IBQuery1.SQL.Clear;
      Form1.IBQuery1.SQL.Add('update ORCAMENT set COO='+QuotedStr(sCupom)+' where PEDIDO='+QuotedStr(sOrcame)+' and PEDIDO<>'+QuotedStr('0000000000')+' ');
      Form1.IBQuery1.ExecSQL;
    except

    end;
  end;
  //
  Commitatudo(True); // RelatorioImpressaoOrcamento Sandro Silva 2016-08-22

  // após imprimir esse, faz a impressão DAV Relatório gerencial: "Field ESTADO too small DATA"

  //
  ////////////////
  //            //
  // Orçamento  //
  //            //
  ////////////////
end;

procedure RelatorioMovimentoDia;
// Resumo Movimento do dia
// Totaliza os valores nos arrays
// Usando StringList para criar e ordenar as linhas a serem impressas,
// no início de cada linha é atribuído o código para ordenar as linhas
var
  IBQALTERACA: TIBQuery;
  IBQDESCONTOITEM: TIBQuery;
  IBQDESCONTOCUPOM: TIBQuery;
  IBQACRESCIMOCUPOM: TIBQuery;
  IBQTOTALCUPOM: TIBQuery;
  IBQCANCELADOS: TIBQuery;
  IBQNFCE: TIBQuery;
  IBQTOTALITENS: TIBQuery;
  IBQCANCELADOSSEMFATURA: TIBQuery;
  aAliquota: array of TAliquota;
  aCFOP: array of TCFOP;
  aCST: array of TCST;
  aCSOSN: array of TCSOSN;
  aForma: array of TForma;
  bAChouAliq: Boolean;
  iAliq: Integer;
  sAliquota: String;
  sCFOP: String;
  sCST: String;
  sCSOSN: String;
  slMovimento: TStringList;
  sCupomfiscalVinculado : String;
  sAliqISS: String;
  sObs: String;
  dTotal: Double;
  dTotalICMS: Double;
  dTotalISS: Double;
  dTotalNaoTrib: Double;
  dTotalAcrescimo: Double;
  dTotalDesconto: Double;
  dImposto: Double;
  dTotalImposto: Double;
  dDescontoItem: Double;
  dRateioDescontoItem: Double;
  dRateioAcrescimoItem: Double;
  dVendaLiquida: Double; // Sandro Silva 2018-08-15
  bNaHora: Boolean; // Sandro Silva 2018-11-30
  dCancelaSemFatura: Double; // Sandro Silva 2019-06-13
  //CDSALIQUOTA: TClientDataSet;
  //CDSCFOP: TClientDataSet;
begin
  if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99') then
  begin
    //CDSALIQUOTA := CriaCDSALIQ;
    //CDSCFOP     := CriaCDSCFOP;

    //CDSALIQUOTA.Open;
    //CDSCFOP.Open;

    try
      slMovimento := TStringList.Create;// Usando StringList para ordenar os dados na impressão
      Form1.Timer2.Enabled := False;
      Form7.bMovimentoDia := True;
      Form7.ShowModal;
      if Form7.ModalResult = mrOk then
      begin

        Commitatudo(True); // MovimentoDia1Click()
        Screen.Cursor := crHourGlass;

        bNaHora := (Form7.chkMovimentoDiaHoraI.Checked) and (Form7.chkMovimentoDiaHoraF.Checked); // Sandro Silva 2018-11-30

        sAliqISS := Form1.AliquotaISSConfigura;

        IBQALTERACA            := CriaIBQuery(Form1.ibDataSet27.Transaction);
        IBQDESCONTOITEM        := CriaIBQuery(Form1.ibDataSet27.Transaction);
        IBQDESCONTOCUPOM       := CriaIBQuery(Form1.ibDataSet27.Transaction);
        IBQACRESCIMOCUPOM      := CriaIBQuery(Form1.ibDataSet27.Transaction);
        IBQCANCELADOS          := CriaIBQuery(Form1.ibDataSet27.Transaction); // Sandro Silva 2018-03-13
        IBQTOTALCUPOM          := CriaIBQuery(Form1.ibDataSet27.Transaction);
        IBQNFCE                := CriaIBQuery(Form1.ibDataSet27.Transaction);
        IBQTOTALITENS          := CriaIBQuery(Form1.ibDataSet27.Transaction); // Acumulado de (total - desconto) dos itens  Sandro Silva 2018-08-15
        IBQCANCELADOSSEMFATURA := CriaIBQuery(Form1.ibDataSet27.Transaction); // Seleciona os item cancelados que não são listados no xml das vendas Sandro Silva 2019-06-13

        IBQCANCELADOSSEMFATURA.Close;
        IBQCANCELADOSSEMFATURA.SQL.Text := // Itens cancelados durante venda e que não são listados no xml por estarem cancelados
          'select A.CODIGO, A.REGISTRO, A.ITEM, A.TIPO, A.DATA, NFCE.NUMERONF, A.CAIXA, E.DESCRICAO as ESTOQUE_DESCRICAO, A.CODIGO, A.QUANTIDADE, A.UNITARIO, A.TOTAL, NFCE.STATUS ' +
          'from ALTERACA A ' +
          'join NFCE on NFCE.NUMERONF = A.PEDIDO and NFCE.CAIXA = A.CAIXA ' +
          'left join ESTOQUE E on E.CODIGO = A.CODIGO ' +
          'where (A.TIPO = ''CANCEL'' or A.TIPO = ''CANLOK'' or A.TIPO = ''KOLNAC'') ' +
          ' and (NFCE.STATUS containing ''autoriza'' or NFCE.STATUS containing ''Emitido com sucesso'' or coalesce(NFCE.STATUS, '''') = '''' or NFCE.STATUS containing ' + QuotedStr(NFCE_EMITIDA_EM_CONTINGENCIA) + ' or NFCE.STATUS containing ' + QuotedStr(VENDA_GERENCIAL_FINALIZADA) + ' or NFCE.STATUS containing ' + QuotedStr(VENDA_MEI_ANTIGA_FINALIZADA) + ' ) ' + // Sandro Silva 2021-09-09 Ficha 5499 ' and (NFCE.STATUS containing ''autoriza'' or NFCE.STATUS containing ''Emitido com sucesso'' or coalesce(NFCE.STATUS, '''') = '''' or NFCE.STATUS containing ' + QuotedStr(VENDA_GERENCIAL_FINALIZADA) + ' ) ' +
          ' and A.DESCRICAO <> ''Desconto'' ' +
          ' and A.DESCRICAO <> ''Acréscimo'' ';

        if bNaHora then
          IBQCANCELADOSSEMFATURA.SQL.Add(' and cast(A.DATA || '' '' || A.HORA as timestamp) between cast(' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpMovimentoDia.Date)) + ' || '' '' || ' + QuotedStr(FormatDateTime('HH:nn:00', Form7.dtpMovimentoHoraI.Time)) + ' as timestamp) and cast(' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpMovimentoDiaF.Date)) + ' || '' '' || ' + QuotedStr(FormatDateTime('HH:nn:59', Form7.dtpMovimentoHoraF.Time)) + ' as timestamp) ')
        else
          IBQCANCELADOSSEMFATURA.SQL.Add(' and A.DATA >= ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpMovimentoDia.Date)) + ' and A.DATA <= ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpMovimentoDiaF.Date)));

        if Form7.edMovimentoDia.Text <> '' then // Sandro Silva 2018-04-13
          IBQCANCELADOSSEMFATURA.SQL.Add(' and NFCE.CAIXA = ' + QuotedStr(Form7.edMovimentoDia.Text));
        IBQCANCELADOSSEMFATURA.SQL.Add(' order by A.DATA, A.PEDIDO, A.ITEM, coalesce(A.CODIGO, '''') desc ');
        IBQCANCELADOSSEMFATURA.Open;

        IBQCANCELADOS.Close;
        IBQCANCELADOS.SQL.Text :=
          'select sum(A.TOTAL) as TOTALCANCELADO ' +
          'from NFCE ' +
          'join ALTERACA A on A.PEDIDO = NFCE.NUMERONF and A.CAIXA = NFCE.CAIXA ' +
          'where (NFCE.MODELO = ''59'' or NFCE.MODELO = ''65'' or NFCE.MODELO = ''99'') ' + // Sandro Silva 2020-09-28 'where (NFCE.MODELO = ''59'' or NFCE.MODELO = ''65'') ' + 
          ' and NFCE.STATUS containing ''cancela'' ';
        if Form7.edMovimentoDia.Text <> '' then // Sandro Silva 2018-04-13
          IBQCANCELADOS.SQL.Add(' and NFCE.CAIXA = ' + QuotedStr(Form7.edMovimentoDia.Text));

        if bNaHora then
          IBQCANCELADOS.SQL.Add(' and cast(NFCE.DATA || '' '' || A.HORA as timestamp) between cast(' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpMovimentoDia.Date)) + ' || '' '' || ' + QuotedStr(FormatDateTime('HH:nn:00', Form7.dtpMovimentoHoraI.Time)) + ' as timestamp) and cast(' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpMovimentoDiaF.Date)) + ' || '' '' || ' + QuotedStr(FormatDateTime('HH:nn:59', Form7.dtpMovimentoHoraF.Time)) + ' as timestamp) ')
        else
          IBQCANCELADOS.SQL.Add(' and NFCE.DATA >= ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpMovimentoDia.Date)) + ' and NFCE.DATA <= ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpMovimentoDiaF.Date)));

        IBQCANCELADOS.SQL.Add(' and A.DESCRICAO <> ''<CANCELADO>'' ' +
                              ' and A.TIPO <> ''KOLNAC'' ' + // Sandro Silva 2019-03-26 Registro fica em Dead Lock e o TIPO = KOLNAC até ser destravado e processado
                              ' and A.TIPO = ''CANCEL'' ');
        IBQCANCELADOS.Open;

        IBQNFCE.Close;
        {Sandro Silva 2021-09-09 inicio 
        if bNaHora then
          IBQNFCE.SQL.Text :=
            'select distinct NFCE.DATA, NFCE.CAIXA, NFCE.NUMERONF, NFCE.MODELO ' +
            'from NFCE ' +
            'join ALTERACA A on A.PEDIDO = NFCE.NUMERONF and A.CAIXA = NFCE.CAIXA ' +
            'where (NFCE.STATUS containing ''Autorizad'' or NFCE.STATUS containing ''Emitido com sucesso'' or NFCE.STATUS containing ' + QuotedStr(NFCE_EMITIDA_EM_CONTINGENCIA) + ' or NFCE.STATUS containing ' + QuotedStr(VENDA_GERENCIAL_FINALIZADA) + ') ' + // Sandro Silva 2021-09-09 'where (NFCE.STATUS containing ''Autorizad'' or NFCE.STATUS containing ''Emitido com sucesso'' or NFCE.STATUS containing ' + QuotedStr(VENDA_GERENCIAL_FINALIZADA) + ') ' +
            ' and cast(NFCE.DATA || '' '' || A.HORA as timestamp) between cast(' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpMovimentoDia.Date)) + ' || '' '' || ' + QuotedStr(FormatDateTime('HH:nn:00', Form7.dtpMovimentoHoraI.Time)) + ' as timestamp) and cast(' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpMovimentoDiaF.Date)) + ' || '' '' || ' + QuotedStr(FormatDateTime('HH:nn:59', Form7.dtpMovimentoHoraF.Time)) + ' as timestamp) '
        else
          IBQNFCE.SQL.Text :=
            'select NFCE.DATA, NFCE.CAIXA, NFCE.NUMERONF ' +
            'from NFCE ' +
            'where (NFCE.STATUS containing ''Autorizad'' or NFCE.STATUS containing ''Emitido com sucesso'' or NFCE.STATUS containing ' + QuotedStr(NFCE_EMITIDA_EM_CONTINGENCIA) + ' or NFCE.STATUS containing ' + QuotedStr(VENDA_GERENCIAL_FINALIZADA) + ') ' + // Sandro Silva 2021-09-09 'where (NFCE.STATUS containing ''Autorizad'' or NFCE.STATUS containing ''Emitido com sucesso'' or NFCE.STATUS containing ' + QuotedStr(VENDA_GERENCIAL_FINALIZADA) + ') ' +
            ' and NFCE.DATA >= ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpMovimentoDia.Date)) + ' and NFCE.DATA <= ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpMovimentoDiaF.Date));
        }
        IBQNFCE.SQL.Text :=
          'select distinct NFCE.DATA, NFCE.CAIXA, NFCE.NUMERONF, NFCE.MODELO ' +
          'from NFCE ' +
          'join ALTERACA A on A.PEDIDO = NFCE.NUMERONF and A.CAIXA = NFCE.CAIXA ' +
          'where (NFCE.STATUS containing ''Autorizad'' or NFCE.STATUS containing ''Emitido com sucesso'' or NFCE.STATUS containing ' + QuotedStr(NFCE_EMITIDA_EM_CONTINGENCIA) + ' or NFCE.STATUS containing ' + QuotedStr(VENDA_GERENCIAL_FINALIZADA) + ' or NFCE.STATUS containing ' + QuotedStr(VENDA_MEI_ANTIGA_FINALIZADA) + ') ';

        if bNaHora then
          IBQNFCE.SQL.Add(' and cast(NFCE.DATA || '' '' || A.HORA as timestamp) between cast(' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpMovimentoDia.Date)) + ' || '' '' || ' + QuotedStr(FormatDateTime('HH:nn:00', Form7.dtpMovimentoHoraI.Time)) + ' as timestamp) and cast(' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpMovimentoDiaF.Date)) + ' || '' '' || ' + QuotedStr(FormatDateTime('HH:nn:59', Form7.dtpMovimentoHoraF.Time)) + ' as timestamp) ')
        else
          IBQNFCE.SQL.Add(' and NFCE.DATA >= ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpMovimentoDia.Date)) + ' and NFCE.DATA <= ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpMovimentoDiaF.Date)));

        if Form7.edMovimentoDia.Text <> '' then // Sandro Silva 2018-04-13
          IBQNFCE.SQL.Add(' and NFCE.CAIXA = ' + QuotedStr(Form7.edMovimentoDia.Text));
        IBQNFCE.SQL.Add(' order by NFCE.REGISTRO');
        IBQNFCE.Open;

        slMovimento.Clear;

        while IBQNFCE.Eof = False do
        begin

          //Seleciona o total dos itens menos os seus descontos, para usar no rateio
          IBQTOTALITENS.Close;
          IBQTOTALITENS.SQL.Text :=
              'select sum(cast(TOTAL as numeric(18,2))) as TOTAL ' +
              'from ALTERACA ' +
              'where PEDIDO = ' + QuotedStr(IBQNFCE.FieldByName('NUMERONF').AsString) +
              ' and CAIXA = ' + QuotedStr(IBQNFCE.FieldByName('CAIXA').AsString) +
              ' and DESCRICAO <> ''<CANCELADO>'' ' +
              ' and TIPO <> ''KOLNAC'' ' + // Sandro Silva 2019-03-26 Registro fica em dead lock, com TIPO = KOLNAC até que seja destravado e processado 
              ' and coalesce(ITEM,''XX'') <> ''XX'' ';
          IBQTOTALITENS.Open;

          // Seleciona os descontos concedidos específicos aos itens
          IBQDESCONTOITEM.Close;
          IBQDESCONTOITEM.SQL.Text :=
            'select A.PEDIDO, A.CODIGO, A.ALIQUICM, A.ITEM, A.TOTAL as DESCONTO ' +
            'from ALTERACA A ' +
            'where A.DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', IBQNFCE.FieldByName('DATA').AsDateTime));
          if Form7.edMovimentoDia.Text <> '' then // Sandro Silva 2018-04-13
            IBQDESCONTOITEM.SQL.Add(' and A.CAIXA = ' + QuotedStr(IBQNFCE.FieldByName('CAIXA').AsString));
          IBQDESCONTOITEM.SQL.Add(' and A.PEDIDO = ' + QuotedStr(IBQNFCE.FieldByName('NUMERONF').AsString) +
                                  ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
                                  ' and A.DESCRICAO = ''Desconto'' ' +
                                  ' and coalesce(A.ITEM, '''') <> '''' ' +
                                  ' order by A.ITEM'); // Que tenha número do item informado no campo ALTERACA.ITEM
          IBQDESCONTOITEM.Open;

          // Seleciona os descontos lançados para o cupom
          IBQDESCONTOCUPOM.Close;
          IBQDESCONTOCUPOM.SQL.Text :=
            'select A.PEDIDO, sum(A.TOTAL) as DESCONTOCUPOM ' +
            'from ALTERACA A ' +
            'where A.DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', IBQNFCE.FieldByName('DATA').AsDateTime));
          if Form7.edMovimentoDia.Text <> '' then // Sandro Silva 2018-04-13
            IBQDESCONTOCUPOM.SQL.Add(' and A.CAIXA = ' + QuotedStr(IBQNFCE.FieldByName('CAIXA').AsString));
          IBQDESCONTOCUPOM.SQL.Add(' and A.PEDIDO = ' + QuotedStr(IBQNFCE.FieldByName('NUMERONF').AsString) +
                                   ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
                                   ' and A.DESCRICAO = ''Desconto'' ' +
                                   ' and coalesce(A.ITEM, '''') = '''' ' +
                                   ' group by A.PEDIDO ' +
                                   ' order by PEDIDO');
          IBQDESCONTOCUPOM.Open;

          // Seleciona os acréscimos lançados para o cupom
          IBQACRESCIMOCUPOM.Close;
          IBQACRESCIMOCUPOM.SQL.Text :=
            'select A.PEDIDO, sum(A.TOTAL) as ACRESCIMOCUPOM ' +
            'from ALTERACA A ' +
            'where A.DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', IBQNFCE.FieldByName('DATA').AsDateTime));
          if Form7.edMovimentoDia.Text <> '' then // Sandro Silva 2018-04-13
            IBQACRESCIMOCUPOM.SQL.Add(' and A.CAIXA = ' + QuotedStr(IBQNFCE.FieldByName('CAIXA').AsString));
          IBQACRESCIMOCUPOM.SQL.Add(' and A.PEDIDO = ' + QuotedStr(IBQNFCE.FieldByName('NUMERONF').AsString) +
                                    ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
                                    ' and A.DESCRICAO = ''Acréscimo'' ' +
                                    ' and coalesce(A.ITEM, '''') = '''' ' +
                                    ' group by A.PEDIDO ' +
                                    ' order by PEDIDO');
          IBQACRESCIMOCUPOM.Open;

          // Seleciona o total do cupom
          IBQTOTALCUPOM.Close;
          IBQTOTALCUPOM.SQL.Text :=
            'select A.PEDIDO, sum(A.TOTAL) as TOTALCUPOM ' +
            'from ALTERACA A ' +
            'where A.DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', IBQNFCE.FieldByName('DATA').AsDateTime));
          if Form7.edMovimentoDia.Text <> '' then // Sandro Silva 2018-04-13
            IBQTOTALCUPOM.SQL.Add(' and A.CAIXA = ' + QuotedStr(IBQNFCE.FieldByName('CAIXA').AsString));
          IBQTOTALCUPOM.SQL.Add(' and A.PEDIDO = ' + QuotedStr(IBQNFCE.FieldByName('NUMERONF').AsString) +
                                ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
                                ' and (A.DESCRICAO <> ''<CANCELADO>'') '  +
                                ' and (A.DESCRICAO <> ''Desconto'') ' +
                                ' and (A.DESCRICAO <> ''Acréscimo'') ' +
                                ' group by A.PEDIDO ' +
                                ' order by PEDIDO');
          IBQTOTALCUPOM.Open;

          IBQALTERACA.Close;
          IBQALTERACA.SQL.Text :=
            'select A.PEDIDO, A.ITEM, A.CODIGO, A.CST_ICMS, coalesce(A.ALIQUICM, '''') as ALIQUICM, A.CST_PIS_COFINS, ' +
            'A.ALIQ_PIS, A.ALIQ_COFINS, A.CFOP, coalesce(A.TOTAL, 0) as VL_ITEM, A.CSOSN, ' +
            'E.CSOSN as ESTOQUE_CSOSN, E.CFOP as ESTOQUE_CFOP, E.ALIQUOTA_NFCE, E.CSOSN_NFCE, E.CST_NFCE, E.CEST ' +
            'from ALTERACA A ' +
            'left join ESTOQUE E on E.CODIGO = A.CODIGO ' +
            'where A.DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', IBQNFCE.FieldByName('DATA').AsDateTime));
          if Form7.edMovimentoDia.Text <> '' then // Sandro Silva 2018-04-13
            IBQALTERACA.SQL.Add(' and A.CAIXA = ' + QuotedStr(IBQNFCE.FieldByName('CAIXA').AsString));
          IBQALTERACA.SQL.Add(' and A.PEDIDO = ' + QuotedStr(IBQNFCE.FieldByName('NUMERONF').AsString) +
                              ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
                              ' and (A.DESCRICAO <> ''<CANCELADO>'' ' +
                              ' and A.DESCRICAO <> ''Desconto'' ' +
                              ' and A.DESCRICAO <> ''Acréscimo'') ' +
                              ' and coalesce(A.ITEM, '''') <> '''' ' + // Que tenha número do item informado no campo ALTERACA.ITEM
                              ' order by A.REGISTRO');
          IBQALTERACA.Open;

          dTotal := 0.00;

          while IBQALTERACA.Eof = False do
          begin

            dDescontoItem := 0;
            if IBQDESCONTOITEM.Locate('PEDIDO;ITEM', VarArrayOf([IBQALTERACA.FieldByName('PEDIDO').AsString, IBQALTERACA.FieldByName('ITEM').AsString]), []) then
              dDescontoItem := IBQDESCONTOITEM.FieldByName('DESCONTO').AsFloat;

            dRateioDescontoItem  := 0.00;
            dRateioAcrescimoItem := 0.00;
            if IBQTOTALCUPOM.Locate('PEDIDO', IBQALTERACA.FieldByName('PEDIDO').AsString, []) then
            begin
              // Não arredondar os valores individuais, somente no momento de imprimir o total do array
              if IBQDESCONTOCUPOM.Locate('PEDIDO', IBQALTERACA.FieldByName('PEDIDO').AsString, []) then
                dRateioDescontoItem := (IBQDESCONTOCUPOM.FieldByName('DESCONTOCUPOM').AsFloat / IBQTOTALITENS.FieldByName('TOTAL').AsFloat) * (IBQALTERACA.FieldByName('VL_ITEM').AsFloat + dDescontoItem);

              if IBQACRESCIMOCUPOM.Locate('PEDIDO', IBQALTERACA.FieldByName('PEDIDO').AsString, []) then
                dRateioAcrescimoItem := (IBQACRESCIMOCUPOM.FieldByName('ACRESCIMOCUPOM').AsFloat / IBQTOTALITENS.FieldByName('TOTAL').AsFloat) * (IBQALTERACA.FieldByName('VL_ITEM').AsFloat + dDescontoItem);

            end;
            dTotal := dTotal + IBQALTERACA.FieldByName('VL_ITEM').AsFloat + dRateioAcrescimoItem;

            sAliquota := AnsiUpperCase(Trim(IBQALTERACA.FieldByName('ALIQUICM').AsString));
            if sAliquota = '' then // Sandro Silva 2016-04-14
              sAliquota := '0000';

            sCST := Trim(IBQALTERACA.FieldByName('CST_ICMS').AsString);
            if (sCST = '') and (Trim(IBQALTERACA.FieldByName('CST_NFCE').AsString) <> '') then
              sCST := Trim(IBQALTERACA.FieldByName('CST_NFCE').AsString);
            sCST := Right('000' + sCST, 3);

            sCSOSN := Trim(IBQALTERACA.FieldByName('CSOSN').AsString); // CSOSN de ALTERACA
            if (sCSOSN = '') and (Trim(IBQALTERACA.FieldByName('CSOSN_NFCE').AsString) <> '') then
              sCSOSN := Trim(IBQALTERACA.FieldByName('CSOSN_NFCE').AsString); // CSOSN de ESTOQUE para NFCE
            if sCSOSN = '' then
              sCSOSN := Trim(IBQALTERACA.FieldByName('ESTOQUE_CSOSN').AsString); // CSOSN de ESTOQUE geral

            if AnsiUpperCase(IBQALTERACA.FieldByName('ALIQUICM').AsString) = 'ISS' then
              sCSOSN := 'ISS';

            if (sAliquota <> 'ISS') then
            begin
              if (LimpaNumero(Form1.ibDAtaset13.FieldByname('CRT').AsString) <> '1') then
              begin
                if (Right(sCST, 2) = '40') then //I - Isento
                  sAliquota := 'I';
                if (Right(sCST, 2) = '41') then // N - Não trib.
                  sAliquota := 'N';
                if (Right(sCST, 2) = '60') then // F - Substituíção
                  sAliquota := 'F';
              end
              else
              begin
                if (sCSOSN = '300') then //I - Isento
                  sAliquota := 'I';
                if (sCSOSN = '400') then // N - Não trib.
                  sAliquota := 'N';
                if (sCSOSN = '500') then // F - Substituíção
                  sAliquota := 'F';
              end;
            end;

            if (sAliquota <> '') then
            begin
              bAChouAliq := False;
              if ((Copy(sAliquota, 1, 1) = 'I') or (Copy(sAliquota, 1, 1) = 'F') or (Copy(sAliquota, 1, 1) = 'N')) then
              begin
                if (sAliquota = 'ISS') then
                begin
                  sAliquota := 'S' + FormatFloat('00.00', StrtoIntDef(LimpaNumero(sAliqISS), 0) / 100) + '%';
                end
                else
                begin
                  sAliquota := Copy(sAliquota, 1, 1);
                end;
              end
              else
              begin
                sAliquota := FormatFloat('00.00', StrtoIntDef(LimpaNumero(sAliquota), 0) / 100) + '%';
              end;
              sAliquota := Copy(sAliquota + '       ', 1, 7);

              //{Sandro Silva 2021-11-16 inicio
              for iAliq := 0 to Length(aAliquota) - 1 do
              begin
                if aAliquota[iAliq].Aliquota = sAliquota then
                begin
                  bAChouAliq := True;
                  Break;
                end;
              end;

              if bAChouAliq = False then
              begin
                SetLength(aAliquota, Length(aAliquota) + 1);
                iAliq := High(aAliquota);
                aAliquota[High(aAliquota)] := TAliquota.Create; // Sandro Silva 2019-06-13
                aAliquota[High(aAliquota)].Aliquota  := sAliquota;
              end;

              aAliquota[iAliq].Valor     := aAliquota[iAliq].Valor + IBQALTERACA.FieldByName('VL_ITEM').AsFloat + dDescontoItem + dRateioDescontoItem + dRateioAcrescimoItem;
              aAliquota[iAliq].Acrescimo := aAliquota[iAliq].Acrescimo + dRateioAcrescimoItem;
              aAliquota[iAliq].Desconto  := aAliquota[iAliq].Desconto + dDescontoItem + dRateioDescontoItem;


              {
              CDSALIQUOTA.Filter := 'ALIQUOTA = ' + QuotedStr(Trim(sAliquota));
              CDSALIQUOTA.Filtered := True;
              if CDSALIQUOTA.IsEmpty then
              begin
                CDSALIQUOTA.Append;
                CDSALIQUOTA.FieldByName('ALIQUOTA').AsString := sAliquota;
              end
              else
                CDSALIQUOTA.Edit;
              CDSALIQUOTA.FieldByName('VALOR').AsFloat     := CDSALIQUOTA.FieldByName('VALOR').AsFloat + IBQALTERACA.FieldByName('VL_ITEM').AsFloat + dDescontoItem + dRateioDescontoItem + dRateioAcrescimoItem;
              CDSALIQUOTA.FieldByName('ACRESCIMO').AsFloat := CDSALIQUOTA.FieldByName('ACRESCIMO').AsFloat + dRateioAcrescimoItem;
              CDSALIQUOTA.FieldByName('DESCONTO').AsFloat  := CDSALIQUOTA.FieldByName('DESCONTO').AsFloat + dDescontoItem + dRateioDescontoItem;
              CDSALIQUOTA.Post;
              {Sandro Silva 2021-11-16 fim}

            end;

            sCFOP := Trim(IBQALTERACA.FieldByName('CFOP').AsString);
            if sCFOP = '' then
              sCFOP := Trim(IBQALTERACA.FieldByName('ESTOQUE_CFOP').AsString);

            //{Sandro Silva 2021-11-16 inicio
            bAChouAliq := False;
            for iAliq := 0 to Length(aCFOP) - 1 do
            begin
              if aCFOP[iAliq].CFOP = sCFOP then
              begin
                bAChouAliq := True;
                Break;
              end;
            end;

            if bAChouAliq = False then
            begin
              SetLength(aCFOP, Length(aCFOP) + 1);
              iAliq := High(aCFOP);
              aCFOP[High(aCFOP)] := TCFOP.Create; // Sandro Silva 2019-06-13
              aCFOP[High(aCFOP)].CFOP      := sCFOP;
            end;
            aCFOP[iAliq].Valor     := aCFOP[iAliq].Valor + IBQALTERACA.FieldByName('VL_ITEM').AsFloat + dDescontoItem + dRateioDescontoItem + dRateioAcrescimoItem;
            aCFOP[iAliq].Acrescimo := aCFOP[iAliq].Acrescimo + dRateioAcrescimoItem;
            aCFOP[iAliq].Desconto  := aCFOP[iAliq].Desconto + dDescontoItem + dRateioDescontoItem;
            //}
            {
            CDSCFOP.Filter := 'CFOP = ' + QuotedStr(Trim(sCFOP));
            CDSCFOP.Filtered := True;

            if CDSCFOP.IsEmpty then
            begin
              CDSCFOP.Append;
              CDSCFOP.FieldByName('CFOP').AsString := sCFOP;
            end
            else
              CDSCFOP.Edit;
            CDSCFOP.FieldByName('VALOR').AsFloat     := CDSCFOP.FieldByName('VALOR').AsFloat + IBQALTERACA.FieldByName('VL_ITEM').AsFloat + dDescontoItem + dRateioDescontoItem + dRateioAcrescimoItem;
            CDSCFOP.FieldByName('ACRESCIMO').AsFloat := CDSCFOP.FieldByName('ACRESCIMO').AsFloat + dRateioAcrescimoItem;
            CDSCFOP.FieldByName('DESCONTO').AsFloat  := CDSCFOP.FieldByName('DESCONTO').AsFloat + dDescontoItem + dRateioDescontoItem;
            CDSCFOP.Post;
            {Sandro Silva 2021-11-16 fim}

            if AnsiUpperCase(IBQALTERACA.FieldByName('ALIQUICM').AsString) = 'ISS' then
              sCST := 'ISS';
            bAChouAliq := False;
            for iAliq := 0 to Length(aCST) - 1 do
            begin
              if aCST[iAliq].CST = sCST then
              begin
                bAChouAliq := True;
                Break;
              end;
            end;
            if bAChouAliq = False then
            begin
              SetLength(aCST, Length(aCST) + 1);
              iAliq := High(aCST);
              aCST[High(aCST)] := TCST.Create; // Sandro Silva 2019-06-13
              aCST[High(aCST)].CST      := sCST;
            end;

            aCST[iAliq].Valor     := aCST[iAliq].Valor + IBQALTERACA.FieldByName('VL_ITEM').AsFloat + dDescontoItem + dRateioDescontoItem + dRateioAcrescimoItem;
            aCST[iAliq].Acrescimo := aCST[iAliq].Acrescimo + dRateioAcrescimoItem;
            aCST[iAliq].Desconto  := aCST[iAliq].Desconto + dDescontoItem + dRateioDescontoItem;

            bAChouAliq := False;
            for iAliq := 0 to Length(aCSOSN) - 1 do
            begin
              if aCSOSN[iAliq].CSOSN = sCSOSN then
              begin
                bAChouAliq := True;
                Break;
              end;
            end;
            if bAChouAliq = False then
            begin
              SetLength(aCSOSN, Length(aCSOSN) + 1);
              iAliq := High(aCSOSN);
              aCSOSN[High(aCSOSN)] := TCSOSN.Create; // Sandro Silva 2019-06-13 
              aCSOSN[High(aCSOSN)].CSOSN     := sCSOSN;
            end;

            aCSOSN[iAliq].Valor     := aCSOSN[iAliq].Valor + IBQALTERACA.FieldByName('VL_ITEM').AsFloat + dDescontoItem + dRateioDescontoItem + dRateioAcrescimoItem;
            aCSOSN[iAliq].Acrescimo := aCSOSN[iAliq].Acrescimo + dRateioAcrescimoItem;
            aCSOSN[iAliq].Desconto  := aCSOSN[iAliq].Desconto + dDescontoItem + dRateioDescontoItem;

            IBQALTERACA.Next;
          end; // while IBQALTERACA.Eof = False do

          // Seleciona Formas de pagamento
          IBQALTERACA.Close;
          IBQALTERACA.SQL.Text :=
            'select trim(replace(replace(substring(P.FORMA from 4 for 30), ''NFC-e'', ''''), ''NF-e'', '''')) as FORMA, ' +
            'sum(case when substring(P.forma from 1 for 2) = ''13'' then (P.valor * -1) else P.VALOR end) as TOTAL ' + // Sandro Silva 2018-06-19  'sum(P.VALOR) as TOTAL ' +
            'from PAGAMENT P ' +
            'where P.DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', IBQNFCE.FieldByName('DATA').AsDateTime));
          if Form7.edMovimentoDia.Text <> '' then // Sandro Silva 2018-04-13
            IBQALTERACA.SQL.Add(' and P.CAIXA = ' + QuotedStr(IBQNFCE.FieldByName('CAIXA').AsString));
          IBQALTERACA.SQL.Add(' and P.PEDIDO = ' + QuotedStr(IBQNFCE.FieldByName('NUMERONF').AsString) +
                              // Sandro Silva 2018-06-19  ' and P.FORMA <> ''13 Troco'' ' +
                              ' and P.FORMA <> ''00 Total'' ' +
                              ' and coalesce(P.CLIFOR, ''X'') <> ''Sangria'' ' +
                              ' and coalesce(P.CLIFOR, ''X'') <> ''Suprimento'' ' +
                              ' and (coalesce(P.CAIXA, '''') = '''' or P.PEDIDO in (select A.PEDIDO from ALTERACA A where A.PEDIDO = P.PEDIDO and A.CAIXA = P.CAIXA and A.DATA = P.DATA and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'' or TIPO = ''VENDA''))) ' +
                              ' group by trim(replace(replace(substring(P.FORMA from 4 for 30), ''NFC-e'', ''''), ''NF-e'', '''')) ' +
                              ' order by substring(1 from 4 for 20)');
          IBQALTERACA.Open;

          IBQALTERACA.Last;
          if IBQALTERACA.RecordCount = 0 then
            sObs := sObs + Chr(10) + 'Sem pagamento Nota ' + IBQNFCE.FieldByName('NUMERONF').AsString + ' Caixa ' + IBQNFCE.FieldByName('CAIXA').AsString ;
          IBQALTERACA.First;

          //dTotal := 0.00;
          while IBQALTERACA.Eof = False do
          begin
            bAChouAliq := False;
            for iAliq := 0 to Length(aForma) - 1 do
            begin
              if aForma[iAliq].FORMA = IBQALTERACA.FieldByName('FORMA').AsString then
              begin
                bAChouAliq := True;
                Break;
              end;
            end;
            if bAChouAliq = False then
            begin
              SetLength(aForma, Length(aForma) + 1);
              iAliq := High(aForma);
              aForma[High(aForma)] := TForma.Create; // Sandro Silva 2019-06-13
              aForma[High(aForma)].FORMA := IBQALTERACA.FieldByName('FORMA').AsString;
            end;

            aForma[iAliq].Valor        := aForma[iAliq].Valor + IBQALTERACA.FieldByName('TOTAL').AsFloat;

            IBQALTERACA.Next;
          end; // while IBQALTERACA.Eof = False do

          IBQNFCE.Next;
        end; // while IBQNFCE

        // Utiliza o StringList para ordenar e agrupar as informações a serem impressas
        // No momento da implementação da rotina não encontrei outra solução para ordenar os grupos de informações impressas

        slMovimento.Add('010');
        slMovimento.Add('010-Venda líquida por alíquota');
        slMovimento.Add('011-' + ImprimeTracos());
        slMovimento.Add('012-Totalizador            Base            Imposto');
        slMovimento.Add('013-' + ImprimeTracos());

        dTotalAcrescimo := 0.00;
        dTotalDesconto  := 0.00;
        dTotalImposto   := 0.00;
        dTotalISS       := 0.00;
        dTotalICMS      := 0.00;
        dTotalNaoTrib   := 0.00;
        dVendaLiquida   := 0.00; // Sandro Silva 2018-08-15

        //{Sandro Silva 2021-11-16 inicio
        for iAliq := 0 to Length(aAliquota) - 1 do
        begin
          dVendaLiquida   := dVendaLiquida + aAliquota[iAliq].Valor; // Sandro Silva 2018-08-15
          dTotalAcrescimo := dTotalAcrescimo + aAliquota[iAliq].Acrescimo;
          dTotalDesconto  := dTotalDesconto + aAliquota[iAliq].Desconto;
          dImposto := aAliquota[iAliq].Valor * StrToFloatDef(LimpaNumero(aAliquota[iAliq].Aliquota),0) / 100 / 100;
          dTotalImposto := dTotalImposto + dImposto;
          if Pos('S', aAliquota[iAliq].Aliquota) = 1 then                //%20s -> %17
          begin
            slMovimento.Add('016-' + aAliquota[iAliq].Aliquota + Format('%20s', [FormatFloat(',0.00', aAliquota[iAliq].Valor)]) + Format('%19s', [FormatFloat(',0.00', dImposto)]));
            dTotalISS := dTotalISS + aAliquota[iAliq].Valor;
          end
          else
            if ((Copy(aAliquota[iAliq].Aliquota, 1, 1) = 'I') or (Copy(aAliquota[iAliq].Aliquota, 1, 1) = 'F') or (Copy(aAliquota[iAliq].Aliquota, 1, 1) = 'N')) then
            begin
              slMovimento.Add('015-' + aAliquota[iAliq].Aliquota + Format('%20s', [FormatFloat(',0.00', aAliquota[iAliq].Valor)]) + Format('%19s', [FormatFloat(',0.00', dImposto)]));
              dTotalNaoTrib := dTotalNaoTrib + aAliquota[iAliq].Valor;
            end
            else
            begin
              slMovimento.Add('014-' + aAliquota[iAliq].Aliquota + Format('%20s', [FormatFloat(',0.00', aAliquota[iAliq].Valor)]) + Format('%19s', [FormatFloat(',0.00', dImposto)]));
              dTotalICMS := dTotalICMS + aAliquota[iAliq].Valor;
            end;
        end;

        {
        CDSALIQUOTA.Filtered := False;
        CDSALIQUOTA.First;
        while CDSALIQUOTA.Eof = False do
        begin

          dVendaLiquida   := dVendaLiquida + CDSALIQUOTA.FieldByName('VALOR').AsFloat;// Valor; // Sandro Silva 2018-08-15
          dTotalAcrescimo := dTotalAcrescimo + CDSALIQUOTA.FieldByName('ACRESCIMO').AsFloat;// aAliquota[iAliq].Acrescimo;
          dTotalDesconto  := dTotalDesconto + CDSALIQUOTA.FieldByName('DESCONTO').AsFloat;// aAliquota[iAliq].Desconto;
          dImposto := CDSALIQUOTA.FieldByName('VALOR').AsFloat * StrToFloatDef(LimpaNumero(CDSALIQUOTA.FieldByName('ALIQUOTA').AsString),0) / 100 / 100;// aAliquota[iAliq].Valor * StrToFloatDef(LimpaNumero(aAliquota[iAliq].Aliquota),0) / 100 / 100;
          dTotalImposto := dTotalImposto + dImposto;
          if Pos('S', CDSALIQUOTA.FieldByName('ALIQUOTA').AsString) = 1 then                //%20s -> %17
          begin
            slMovimento.Add('016-' + CDSALIQUOTA.FieldByName('ALIQUOTA').AsString + Format('%20s', [FormatFloat(',0.00', CDSALIQUOTA.FieldByName('VALOR').AsFloat)]) + Format('%19s', [FormatFloat(',0.00', dImposto)]));
            dTotalISS := dTotalISS + CDSALIQUOTA.FieldByName('VALOR').AsFloat;
          end
          else
            if ((Copy(CDSALIQUOTA.FieldByName('ALIQUOTA').AsString, 1, 1) = 'I') or (Copy(CDSALIQUOTA.FieldByName('ALIQUOTA').AsString, 1, 1) = 'F') or (Copy(CDSALIQUOTA.FieldByName('ALIQUOTA').AsString, 1, 1) = 'N')) then
            begin
              slMovimento.Add('015-' + CDSALIQUOTA.FieldByName('ALIQUOTA').AsString + Format('%20s', [FormatFloat(',0.00', CDSALIQUOTA.FieldByName('VALOR').AsFloat)]) + Format('%19s', [FormatFloat(',0.00', dImposto)]));
              dTotalNaoTrib := dTotalNaoTrib + CDSALIQUOTA.FieldByName('VALOR').AsFloat;
            end
            else
            begin
              slMovimento.Add('014-' + CDSALIQUOTA.FieldByName('ALIQUOTA').AsString + Format('%20s', [FormatFloat(',0.00', CDSALIQUOTA.FieldByName('VALOR').AsFloat)]) + Format('%19s', [FormatFloat(',0.00', dImposto)]));
              dTotalICMS := dTotalICMS + CDSALIQUOTA.FieldByName('VALOR').AsFloat;
            end;

          CDSALIQUOTA.Next;
        end;
        {Sandro Silva 2021-11-16 fim}

        slMovimento.Add('017-' + ImprimeTracos());
        slMovimento.Add('018-Total' + Format('%22s', [FormatFloat(',0.00', dTotalISS + dTotalICMS + dTotalNaoTrib)]) + Format('%19s', [FormatFloat(',0.00', dTotalImposto)]));

        IBQCANCELADOSSEMFATURA.First;
        dCancelaSemFatura := 0.00;
        while IBQCANCELADOSSEMFATURA.Eof = False do
        begin
          dCancelaSemFatura := dCancelaSemFatura + IBQCANCELADOSSEMFATURA.FieldByName('TOTAL').AsFloat;
          IBQCANCELADOSSEMFATURA.Next;
        end; // while IBQCANCELADOSSEMFATURA.Eof = False do

        slMovimento.Add('000-' + ImprimeTracos());
        slMovimento.Add('000-Venda líquida '            + Format('%32s', [FormatFloat(',0.00', dVendaLiquida)])); // Sandro Silva 2018-08-15 slMovimento.Add('000-Venda líquida ' + Format('%32s', [FormatFloat(',0.00', dTotalISS + dTotalICMS + dTotalNaoTrib)]));
        slMovimento.Add('001-Acréscimos    '            + Format('%32s', [FormatFloat(',0.00', dTotalAcrescimo)]));
        slMovimento.Add('002-Descontos     '            + Format('%32s', [FormatFloat(',0.00', Abs(dTotalDesconto))]));
        slMovimento.Add('003-Cancelamentos '            + Format('%32s', [FormatFloat(',0.00', Abs(IBQCANCELADOS.FieldByName('TOTALCANCELADO').AsFloat))])); // Sandro Silva 2018-03-13
        slMovimento.Add('004-Cancelamentos sem faturar' + Format('%21s', [FormatFloat(',0.00', Abs(dCancelaSemFatura))])); // Sandro Silva 2019-06-13
        slMovimento.Add('005-'                          + ImprimeTracos()); // Sandro Silva 2019-06-13 slMovimento.Add('004-' + ImprimeTracos());

        // Seleciona Sangria e suprimento

        IBQALTERACA.Close;
        if bNaHora then
          IBQALTERACA.SQL.Text :=
            'select CLIFOR as OPNF, sum(VALOR) AS VALOR ' +
            'from PAGAMENT ' +
            'where cast(DATA || '' '' || HORA as timestamp) between cast(' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpMovimentoDia.Date)) + ' || '' '' || ' + QuotedStr(FormatDateTime('HH:nn:00', Form7.dtpMovimentoHoraI.Time)) + ' as timestamp) and cast(' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpMovimentoDiaF.Date)) + ' || '' '' || ' + QuotedStr(FormatDateTime('HH:nn:59', Form7.dtpMovimentoHoraF.Time)) + ' as timestamp) '
        else
          IBQALTERACA.SQL.Text :=
            'select CLIFOR as OPNF, sum(VALOR) AS VALOR ' +
            'from PAGAMENT ' +
            'where DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpMovimentoDia.Date));
        if Form7.edMovimentoDia.Text <> '' then // Sandro Silva 2018-04-13
          IBQALTERACA.SQL.Add(' and CAIXA = ' + QuotedStr(Form7.edMovimentoDia.Text));
        IBQALTERACA.SQL.Add(' and (CLIFOR = ''Suprimento'' or CLIFOR = ''Sangria'') ' +
                            ' group by CLIFOR ' +
                            ' order by OPNF');
        IBQALTERACA.Open;

        slMovimento.Add('030');
        slMovimento.Add('030-Totalizador operações não-fiscais');
        slMovimento.Add('031-' + ImprimeTracos());
        slMovimento.Add('032-Totalizador' + Replicate(' ', 30) + 'Valor');
        slMovimento.Add('033-' + ImprimeTracos());
        dTotal := 0.00;
        if IBQALTERACA.FieldByName('OPNF').AsString = '' then
        begin
          slMovimento.Add('034-Sangria   ' + Format('%36s', ['0.00']));
          slMovimento.Add('034-Suprimento' + Format('%36s', ['0.00']));
        end
        else
        begin
          while IBQALTERACA.Eof = False do
          begin
            slMovimento.Add('035-' + Copy(IBQALTERACA.FieldByName('OPNF').AsString + '   ', 1, 10) + Format('%36s', [FormatFloat(',0.00', IBQALTERACA.FieldByName('VALOR').AsFloat)]));
            dTotal := dTotal + IBQALTERACA.FieldByName('VALOR').AsFloat;
            IBQALTERACA.Next;
          end; // while IBQALTERACA.Eof = False do
        end;
        slMovimento.Add('036-' + ImprimeTracos());
        slMovimento.Add('037-Total' + Replicate(' ', 25) + Format('%16s', [FormatFloat(',0.00', dTotal)]));

        // Totaliza formas pagamento
        slMovimento.Add('040-');
        slMovimento.Add('040-Formas de Pagamento');
        slMovimento.Add('041-' + ImprimeTracos());
        slMovimento.Add('042-Forma' + Replicate(' ', 36) + 'Valor');
        slMovimento.Add('043-' + ImprimeTracos());

        dTotal := 0;
        for iAliq := 0 to Length(aForma) - 1 do
        begin
          slMovimento.Add('044-' + Copy(aForma[iAliq].FORMA + Replicate(' ', 30), 1, 30) + Format('%16s', [FormatFloat(',0.00', aForma[iAliq].Valor)]));
          dTotal := dTotal + aForma[iAliq].Valor;
        end;
        slMovimento.Add('045-' + ImprimeTracos());
        slMovimento.Add('046-Total' + Replicate(' ', 25) + Format('%16s', [FormatFloat(',0.00', dTotal)]));

        if (LimpaNumero(Form1.ibDAtaset13.FieldByname('CRT').AsString) <> '1') then
        begin
          // Totaliza por CST ICMS
          slMovimento.Add('060-');
          slMovimento.Add('060-Venda líquida por CST ICMS');
          slMovimento.Add('061-' + ImprimeTracos());
          slMovimento.Add('062-CST' + Replicate(' ', 38) + 'Valor');
          slMovimento.Add('063-' + ImprimeTracos());

          dTotal := 0;
          for iAliq := 0 to Length(aCST) - 1 do
          begin
            dTotal := dTotal + aCST[iAliq].Valor;
            slMovimento.Add('064-' + Copy(aCST[iAliq].CST + '   ', 1, 3) + Format('%43s', [FormatFloat(',0.00', aCST[iAliq].Valor)]));
          end;
          slMovimento.Add('065-' + ImprimeTracos());
          slMovimento.Add('066-Total' + Format('%41s', [FormatFloat(',0.00', dTotal)]));
        end
        else
        begin
          // Totaliza por CST ICMS
          slMovimento.Add('070-');
          slMovimento.Add('070-Venda líquida por CSOSN');
          slMovimento.Add('071-' + ImprimeTracos());
          slMovimento.Add('072-CSOSN' + Replicate(' ', 36) + 'Valor');
          slMovimento.Add('073-' + ImprimeTracos());

          dTotal := 0;
          for iAliq := 0 to Length(aCSOSN) - 1 do
          begin
            dTotal := dTotal + aCSOSN[iAliq].Valor;
            slMovimento.Add('074-' + Copy(aCSOSN[iAliq].CSOSN + '    ', 1, 4) + Format('%42s', [FormatFloat(',0.00', aCSOSN[iAliq].Valor)]));
          end;
          slMovimento.Add('075-' + ImprimeTracos());
          slMovimento.Add('076-Total' + Format('%41s', [FormatFloat(',0.00', dTotal)]));
        end;

        // Totaliza por CFOP
        slMovimento.Add('050-');
        slMovimento.Add('050-Venda líquida por CFOP');
        slMovimento.Add('051-' + ImprimeTracos());
        slMovimento.Add('052-CFOP' + Replicate(' ', 37) + 'Valor');
        slMovimento.Add('053-' + ImprimeTracos());

        dTotal := 0;

        //{Sandro Silva 2021-11-16 inicio
        for iAliq := 0 to Length(aCFOP) - 1 do
        begin
          dTotal := dTotal + aCFOP[iAliq].Valor;
          slMovimento.Add('056-' + Copy(aCFOP[iAliq].CFOP + '    ', 1, 4) + Format('%42s', [FormatFloat(',0.00', aCFOP[iAliq].Valor)]));
        end;
        {
        CDSCFOP.Filtered := False;
        CDSCFOP.First;
        while CDSCFOP.Eof = False do
        begin
          dTotal := dTotal + CDSCFOP.FieldByName('VALOR').AsFloat;
          slMovimento.Add('056-' + Copy(CDSCFOP.FieldByName('CFOP').AsString + '    ', 1, 4) + Format('%42s', [FormatFloat(',0.00', CDSCFOP.FieldByName('VALOR').AsFloat)]));
          CDSCFOP.Next;
        end;
        {Sandro Silva 2021-11-16 fim}
        slMovimento.Add('057-' + ImprimeTracos());
        slMovimento.Add('058-Total' + Format('%41s', [FormatFloat(',0.00', dTotal)]));

        // Itens cancelados antes de fechar a venda
        slMovimento.Add('090-');
        slMovimento.Add('090-Itens cancelados (sem faturamento)');
        slMovimento.Add('091-' + ImprimeTracos());
        slMovimento.Add('092-N.Venda Caixa Item' + Replicate(' ', 22) + 'Valor');
        slMovimento.Add('093-' + ImprimeTracos());

        IBQCANCELADOSSEMFATURA.First;
        while IBQCANCELADOSSEMFATURA.Eof = False do
        begin
          if IBQCANCELADOSSEMFATURA.FieldByName('CODIGO').AsString = '' then // Desconto de um item. Observar detalhe entre as linhas que garante que o desconto seja exibido depois do item cancelado
            slMovimento.Add('094-' + Format('%6s', [IBQCANCELADOSSEMFATURA.FieldByName('NUMERONF').AsString]) + Format('%5s', [IBQCANCELADOSSEMFATURA.FieldByName('CAIXA').AsString]) + '  ' + Copy(RightStr(IBQCANCELADOSSEMFATURA.FieldByName('ITEM').AsString, 3) + '-Desconto do item' + DupeString(' ', 22), 1, 22) + Format('%11s', [FormatFloat(',0.00', IBQCANCELADOSSEMFATURA.FieldByName('TOTAL').AsFloat)]))
          else
            slMovimento.Add('094-' + Format('%6s', [IBQCANCELADOSSEMFATURA.FieldByName('NUMERONF').AsString]) + Format('%5s', [IBQCANCELADOSSEMFATURA.FieldByName('CAIXA').AsString]) + '  ' + Copy(RightStr(IBQCANCELADOSSEMFATURA.FieldByName('ITEM').AsString, 3) + ' ' + IBQCANCELADOSSEMFATURA.FieldByName('ESTOQUE_DESCRICAO').AsString + DupeString(' ', 22), 1, 22) + Format('%11s', [FormatFloat(',0.00', IBQCANCELADOSSEMFATURA.FieldByName('TOTAL').AsFloat)]));
          IBQCANCELADOSSEMFATURA.Next;
        end; // while IBQCANCELADOSSEMFATURA.Eof = False do

        slMovimento.Add('097-' + ImprimeTracos());
        slMovimento.Add('098-Total' + Format('%41s', [FormatFloat(',0.00', dCancelaSemFatura)]));

        // Ordena informações
        slMovimento.Sorted := True;
        slMovimento.Sort;

        {Sandro Silva 2023-06-23 inicio}
        if Form1.sModeloECF_Reserva = '99' then
        begin
          slMovimento.Text := StringReplace(slMovimento.Text, 'Venda ', 'Movim.', [rfReplaceAll]);  
        end;
        {Sandro Silva 2023-06-23 fim}

        sCupomFiscalVinculado := CabecalhoRelatoriosGerenciais
          // Sandro Silva 2018-03-21  + '-----------------------------------------------' + Chr(10)
          + ImprimeTracos() + Chr(10)
          + 'Movimento do dia: ' + FormatDateTime('dd/mm/yyyy', Form7.dtpMovimentoDia.Date) + ' a ' + FormatDateTime('dd/mm/yyyy', Form7.dtpMovimentoDiaF.Date) + chr(10);

        if bNaHora then
          sCupomFiscalVinculado := sCupomFiscalVinculado + 'Horário: ' + FormatDateTime('HH:nn', Form7.dtpMovimentoHoraI.Date) + ' a ' + FormatDateTime('HH:nn', Form7.dtpMovimentoHoraF.Date) + Chr(10);

        if Form7.edMovimentoDia.Text <> '' then // Sandro Silva 2018-04-13
          sCupomFiscalVinculado := sCupomFiscalVinculado + 'Caixa: ' + Form7.edMovimentoDia.Text + Chr(10)
        else
          sCupomFiscalVinculado := sCupomFiscalVinculado + 'Caixa: TODOS' + Chr(10);

        if Form1.sModeloECF = '65' then
        begin
          if _ecf65_VerificaContingenciaPendentedeTransmissao(Form7.dtpMovimentoDia.Date, Form7.dtpMovimentoDia.Date, Form7.edMovimentoDia.Text) then
            sCupomFiscalVinculado := sCupomFiscalVinculado + ALERTA_CONTINGENCIA_NAO_TRANSMITIDA + Chr(10);
        end;

        for iAliq := 0 to slMovimento.Count -1 do
          sCupomFiscalVinculado := sCupomFiscalVinculado + Copy(slMovimento.Strings[iAliq], 5, Length(slMovimento.Strings[iAliq])) + Chr(10);

        if sObs <> '' then
          sCupomFiscalVinculado := sCupomFiscalVinculado + Chr(10) + sObs;

        if Form1.sModeloECF = '59' then
          _ecf59_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado), Form7.checkMovimendoDiaPDF.Checked); // Sandro Silva 2018-03-22 _ecf59_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado));
        if Form1.sModeloECF = '65' then
          _ecf65_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado), Form7.checkMovimendoDiaPDF.Checked);

        if Form1.sModeloECF = '99' then
          _ecf99_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado), Form7.checkMovimendoDiaPDF.Checked);

      end; // if Form7.ModalResult = mrOk then

    finally
      slMovimento.Clear; // Sandro Silva 2019-06-13
      FreeAndNil(slMovimento);
      FreeAndNil(IBQDESCONTOITEM);
      FreeAndNil(IBQDESCONTOCUPOM);
      FreeAndNil(IBQACRESCIMOCUPOM);
      FreeAndNil(IBQTOTALCUPOM);
      FreeAndNil(IBQALTERACA);
      FreeAndNil(IBQCANCELADOS);// Sandro Silva 2018-03-13
      FreeAndNil(IBQNFCE);// Sandro Silva 2018-03-13
      FreeAndNil(IBQCANCELADOSSEMFATURA); // Sandro Silva 2019-06-13

      Screen.Cursor := crDefault;
      Form7.bMovimentoDia := False;
      
      for iAliq := 0 to High(aAliquota) do
        FreeAndNil(aAliquota[iAliq]);
      for iAliq := 0 to High(aCFOP) do
        FreeAndNil(aCFOP[iAliq]);
      for iAliq := 0 to High(aCST) do
        FreeAndNil(aCST[iAliq]);
      for iAliq := 0 to High(aCSOSN) do
        FreeAndNil(aCSOSN[iAliq]);
      for iAliq := 0 to High(aForma) do
        FreeAndNil(aForma[iAliq]);

      //FreeAndNil(CDSALIQUOTA);
      //FreeAndNil(CDSCFOP);
    end;
  end;
end;

procedure RelatorioNFCeNoPeriodo;
begin
  try
    // Já faz em DocumentosNoPeriodo() CommitaTudo(True); // Vendaspor1Click
    Form1.Timer2.Enabled := False;
    Form7.bDocumentoEmitidoPeriodo := True;
    Form7.Caption                  := Form1.sTipoDocumento2 + ' no período';
    Form7.Label25.Caption          := Form1.sTipoDocumento2 + ' no período';
    Form7.ShowModal;
    if Form7.ModalResult = mrOk then
    begin
      DocumentosNoPeriodo(Form7.DateTimePicker4.Date, Form7.DateTimePicker5.Date);
    end;
  finally
    Form7.bDocumentoEmitidoPeriodo := False;
    if Form1.ImportarvendasdoSmallMobile1.Checked then // Sandro Silva 2016-03-23
      Form1.Timer2.Enabled := True;
  end;
end;

procedure DocumentosNoPeriodo(dtInicio, dtFinal: TDate);
var
  IBQNFCE: TIBQuery;
  sCupomFiscalVinculado: String;
  sStatus: String;
  sTituloRelat: String; // Sandro Silva 2018-12-03
  sl: TStringList;
  slNFCe: TStringList;
  sDirAtual: String;
  iInutil: Integer;
  RE: TRichEdit;
  iSeqInutil: Integer;
  sDataInutil: String;
  XMLNFE: IXMLDOMDocument;
  xNodePag: IXMLDOMNodeList;
  iNode: Integer;
  iNaoTransmitido: Integer;
  iAutorizado: Integer;
  iContingencia: Integer;
  iCancelado: Integer;
  iInutilizado: Integer;
  iRejeitado: Integer;
  iOutros: Integer;
  sContingenciaPendente: String;
  dTotalVenda: Double;
  dTotalContingencia: Double; // Sandro Silva 2021-09-09 Ficha 5499
begin
  Screen.Cursor := crHourGlass;
  GetDir(0, sDirAtual);

  Commitatudo(True); // DocumentosNoPeriodo()

  IBQNFCE := CriaIBQuery(Form1.ibDataSet27.Transaction);
  sl      := TStringList.Create;
  slNFCe  := TStringList.Create;

  RE         := TRichEdit.Create(Application);
  RE.Visible := False;
  RE.Parent  := Form1;

  XMLNFE := CoDOMDocument.Create;

  //
  try
    IBQNFCE.Close;
    // Foi adicionado o campo para armazenaro total do cupom. Não precisa somar o total da tabela ALTERACA
    IBQNFCE.SQL.Text :=
      'select MODELO, NUMERONF, CAIXA, STATUS, DATA, TOTAL, NFEID ' + // Sandro Silva 2018-08-15 Ficha 4198
      'from NFCE ' +
      ' where DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtInicio)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtFinal));
    if Pos(AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString), '|CE||SP|') > 0 then
    begin // São Paulo e Ceará pode emitir SAT e NFC-e
      if (Form7.chkCFe.Checked = False) or (Form7.chkNFCe.Checked = False) then
      begin
        if Form7.chkCFe.Checked then
          IBQNFCE.SQL.Add(' and MODELO = ' + QuotedStr('59'));
        if Form7.chkNFCe.Checked then
          IBQNFCE.SQL.Add(' and MODELO = ' + QuotedStr('65'));
      end;
    end
    else
    begin // Demais UF somente NFC-e
      IBQNFCE.SQL.Add(' and MODELO = ' + QuotedStr(Form1.sModeloECF_Reserva))
    end;

    IBQNFCE.SQL.Add(' order by NUMERONF ');

    IBQNFCE.Open;
    slNFCe.Clear;

    iNaoTransmitido    := 0;
    iAutorizado        := 0;
    iContingencia      := 0;
    iCancelado         := 0;
    iInutilizado       := 0;
    iRejeitado         := 0;
    iOutros            := 0;
    dTotalVenda        := 0.00; // Sandro Silva 2021-07-14
    dTotalContingencia := 0.00; // Sandro Silva 2021-09-09 Ficha 5499

    while IBQNFCE.Eof = False do
    begin

      sStatus := '';

      if IBQNFCE.FieldByName('MODELO').AsString = '65' then // Sandro Silva 2018-12-03 if Form1.sModeloECF_Reserva = '65' then
      begin
        if IBQNFCE.FieldByName('STATUS').AsString = '' then
        begin
          sStatus := 'Não transmitida';
          Inc(iNaoTransmitido);
        end;

        if AnsiContainsText(IBQNFCE.FieldByName('STATUS').AsString, 'Autoriza') then
        begin
          sStatus := 'Autorizada ' + IBQNFCE.FieldByName('NFEID').AsString; // Sandro Silva 2018-08-15 Ficha 4198
          Inc(iAutorizado);
          dTotalVenda := dTotalVenda + IBQNFCE.FieldByName('TOTAL').AsFloat; // Sandro Silva 2021-07-14
        end;

        if AnsiContainsText(IBQNFCE.FieldByName('STATUS').AsString, 'Conting') then
        begin
          sStatus := 'Autorizada em Contingência, não transmitida ' + IBQNFCE.FieldByName('NFEID').AsString; // Sandro Silva 2018-08-15 Ficha 4198
          Inc(iContingencia);
          dTotalContingencia := dTotalContingencia + IBQNFCE.FieldByName('TOTAL').AsFloat; // Sandro Silva 2021-09-09 Ficha 5499
          dTotalVenda := dTotalVenda + IBQNFCE.FieldByName('TOTAL').AsFloat; // Sandro Silva 2021-09-09 Ficha 5499
        end;

        if Pos('CANCEL', AnsiUpperCase(IBQNFCE.FieldByName('STATUS').AsString)) = 1 then
        begin
          sStatus := 'Cancelada  ' + IBQNFCE.FieldByName('NFEID').AsString; // Sandro Silva 2018-08-15 Ficha 4198
          Inc(iCancelado);
        end;

        if sStatus = '' then
        begin
          sStatus := Copy(IBQNFCE.FieldByName('STATUS').AsString, 1, 50);
          if Pos('REJEI', AnsiUpperCase(IBQNFCE.FieldByName('STATUS').AsString)) = 1 THEN
            Inc(iRejeitado)
          else
            Inc(iOutros);
        end;
      end;

      if IBQNFCE.FieldByName('MODELO').AsString = '59' then // Sandro Silva 2018-12-03 if Form1.sModeloECF_Reserva = '59' then
      begin
        if IBQNFCE.FieldByName('STATUS').AsString = '' then
        begin
          sStatus := 'Não transmitido';
          Inc(iNaoTransmitido);
        end;

        if AnsiContainsText(IBQNFCE.FieldByName('STATUS').AsString, 'Emitido com sucesso') then
        begin
          sStatus := 'Autorizado ' + IBQNFCE.FieldByName('NFEID').AsString; // Sandro Silva 2018-08-15 Ficha 4198
          Inc(iAutorizado);
          dTotalVenda := dTotalVenda + IBQNFCE.FieldByName('TOTAL').AsFloat; // Sandro Silva 2021-07-14
        end;

        if AnsiContainsText(IBQNFCE.FieldByName('STATUS').AsString, 'Cancelado com sucesso') then
        begin
          sStatus := 'Cancelado  ' + IBQNFCE.FieldByName('NFEID').AsString; // Sandro Silva 2018-08-15 Ficha 4198
          Inc(iCancelado);
        end;

        if sStatus = '' then
        begin
          sStatus := Copy(IBQNFCE.FieldByName('STATUS').AsString, 1, 50);
          if Pos('REJEI', AnsiUpperCase(IBQNFCE.FieldByName('STATUS').AsString)) = 1 THEN
            Inc(iRejeitado)
          else
            Inc(iOutros);
        end;

      end;

      sStatus := Copy(sStatus + DupeString(' ', 55), 1, 55); // Sandro Silva 2019-06-04 sStatus := Copy(sStatus + DupeString(' ', 50), 1, 50);
      slNFCe.Add(IBQNFCE.FieldByName('NUMERONF').AsString + ' ' + FormatDateTime('dd/mm/yyyy', IBQNFCE.FieldByName('DATA').AsDateTime) + ' ' + sStatus + ' ' + Format('%9.2n',[IBQNFCE.FieldByName('TOTAL').AsFloat]));
      IBQNFCE.Next;
    end; // while IBQ.Eof = False do

    // Lista as NFC-e inutilizadas
    if (Form1.sModeloECF_Reserva = '65') or ((Pos('|' + AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString), '|CE||SP|') > 0) and Form7.chkNFCe.Checked) then
    begin

      _ecf65_SelecionaXmlInutilizacao(sl, Form1.sAtual + '\XmlDestinatario\NFCE\*inu*.xml');

      sCupomFiscalVinculado := sCupomFiscalVinculado + Chr(10);

      for iInutil := 0 to sl.Count -1 do
      begin
        if sl.Strings[iInutil] <> '' then
        begin
          RE.Lines.LoadFromFile(Form1.sAtual + '\XmlDestinatario\NFCE\' + sl.Strings[iInutil]);
          if xmlNodeValue(RE.Text, '//infInut/cStat') = '102' then
          begin
            if (xmlNodeValue(RE.Text, '//infInut/nNFIni') <> '') and (xmlNodeValue(RE.Text, '//infInut/nNFFin') <> '') then
            begin
              sDataInutil := '';
              XMLNFE.loadXML(RE.Text);
              xNodePag := XMLNFE.selectNodes('//dhRecbto'); // Pode ter mais que 1 tag dhRecbto no xml
              for iNode := 0 to xNodePag.length -1 do
              begin
                if xmlNodeValue(xNodePag.item[iNode].xml, '//dhRecbto') <> '' then //3.10
                begin
                  sDataInutil := xmlNodeValue(xNodePag.item[iNode].xml, '//dhRecbto');
                  sDataInutil := Copy(sDataInutil, 9, 2) + '/' + Copy(sDataInutil, 6, 2) + '/' + Copy(sDataInutil, 1, 4);
                  Break;
                end
              end;
              sStatus := Copy('Inutilizada: ' + xmlNodeValue(RE.Text, '//infInut/xJust') + DupeString(' ', 70), 1, 70);

              if LimpaNumero(sDataInutil) <> '' then
              begin
                if (StrToDate(sDataInutil) >= Int(dtInicio)) and (StrToDate(sDataInutil) <= Int(dtFinal)) then // Converter para inteiro dtInicio e dtFinal porque vem do datetimepicker com fração da hora do dia
                begin
                  // Inutilização dentro do período selecionado
                  for iSeqInutil := StrToInt(xmlNodeValue(RE.Text, '//infInut/nNFIni')) to StrToInt(xmlNodeValue(RE.Text, '//infInut/nNFFin')) do
                  begin
                    // sCupomFiscalVinculado := sCupomFiscalVinculado + FormatFloat('000000', iSeqInutil) + ' ' + sDataInutil + ' ' + sStatus + Chr(10);
                    slNFCe.Add(FormataNumeroDoCupom(iSeqInutil) + ' ' + sDataInutil + ' ' + sStatus); // Sandro Silva 2021-12-02 slNFCe.Add(FormatFloat('000000', iSeqInutil) + ' ' + sDataInutil + ' ' + sStatus);
                    Inc(iInutilizado);
                  end;
                end;
              end;

            end; // if (xmlNodeValue(RE.Text, '//infInut/nNFIni') <> '') and (xmlNodeValue(RE.Text, '//infInut/nNFFin') <> '') then
          end; // if xmlNodeValue(RE.Text, '//infInut/cStat') = '102' then
        end; // if sl.Strings[iInutil] <> '' then
      end; // for iInutil := 0 to sl.Count -1 do
    end; // if Form1.sModeloECF_Reserva = '65' then

    slNFCe.Sort;
    sCupomFiscalVinculado := '';
    for iNode := 0 to slNFCe.Count -1 do
    begin
      sCupomFiscalVinculado := sCupomFiscalVinculado + slNFCe.Strings[iNode] + Chr(10);
    end;

    sCupomFiscalVinculado := sCupomFiscalVinculado + Chr(10) + 'Total de documentos: ' +  IntToStrAlignR(slNFCe.Count, 10); // Sandro Silva 2018-06-04  Ficha 4029 - Total de documentos no período
    sCupomFiscalVinculado := sCupomFiscalVinculado + Chr(10) + 'Total R$:            ' + FloatToStrAlignR(dTotalVenda, 2, 10); // Sandro Silva 2021-07-14 Ficha 5398

    {Sandro Silva 2021-09-09 inicio}
    if dTotalContingencia > 0.00 then
      sCupomFiscalVinculado := sCupomFiscalVinculado + Chr(10) + 'Total Contingencia R$:' + FloatToStrAlignR(dTotalContingencia, 2, 9);
    {Sandro Silva 2021-09-09 fim}

    if iContingencia > 0 then
      sCupomFiscalVinculado := sCupomFiscalVinculado + Chr(10) + 'Contingencia:        ' + IntToStrAlignR(iContingencia, 10);
    if iAutorizado > 0 then
      sCupomFiscalVinculado := sCupomFiscalVinculado + Chr(10) + 'Autorizado:          ' + IntToStrAlignR(iAutorizado, 10);
    if iCancelado > 0 then
      sCupomFiscalVinculado := sCupomFiscalVinculado + Chr(10) + 'Cancelado:           ' + IntToStrAlignR(iCancelado, 10);
    if iInutilizado > 0 then
      sCupomFiscalVinculado := sCupomFiscalVinculado + Chr(10) + 'Inutilizado:         ' + IntToStrAlignR(iInutilizado, 10);
    if iRejeitado > 0 then
      sCupomFiscalVinculado := sCupomFiscalVinculado + Chr(10) + 'Rejeitado:           ' + IntToStrAlignR(iRejeitado, 10);
    if iNaoTransmitido > 0 then
      sCupomFiscalVinculado := sCupomFiscalVinculado + Chr(10) + 'Nao Transmitido:     ' + IntToStrAlignR(iNaoTransmitido, 10);
    if iOutros > 0 then
      sCupomFiscalVinculado := sCupomFiscalVinculado + Chr(10) + 'Outros:              ' + IntToStrAlignR(iOutros, 10);

    if (Pos('|' + AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString), '|CE||SP|') > 0) then
    begin
      if (Form7.chkCFe.Checked = False) or (Form7.chkNFCe.Checked = False) then
      begin
        if Form7.chkCFe.Checked then
          sTituloRelat := 'CF-e no Período';
        if Form7.chkNFCe.Checked then
          sTituloRelat := 'NFC-e no Período';
      end
      else
      begin
        sTituloRelat := 'NFC-e/CF-e no Período';
      end;
    end
    else
    begin
      sTituloRelat := Form1.sTipoDocumento2 + ' no Período';
    end;

    sContingenciaPendente := '';
    if Form1.sModeloECF = '65' then
      sContingenciaPendente := IfThen(_ecf65_VerificaContingenciaPendentedeTransmissao(dtInicio, dtFinal, Form1.sCaixa), ALERTA_CONTINGENCIA_NAO_TRANSMITIDA + Chr(10), '');

    sCupomFiscalVinculado := CabecalhoRelatoriosGerenciais
      + chr(10) + sTituloRelat + chr(10) // Sandro Silva 2018-12-03 + chr(10) + Form1.sTipoDocumento2 + ' no Período' + chr(10)
      + 'Período: ' + FormatDateTime('dd/mm/yyyy', dtInicio) + ' a ' + FormatDateTime('dd/mm/yyyy', dtFinal) + chr(10) + Chr(10)
      + sContingenciaPendente
      + 'Número Data       Status     Chave de Acesso                               Valor' + Chr(10) + sCupomFiscalVinculado + Chr(10); // Sandro Silva 2019-06-04       + 'Número Data       Status     Chave de Acesso                          Valor' + Chr(10) + sCupomFiscalVinculado + Chr(10);

    if Form1.sModeloECF = '65' then
      _ecf65_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado), Form7.CheckBox3.Checked, 1680);

    if Form1.sModeloECF = '59' then
      _ecf59_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado), Form7.CheckBox3.Checked, 1680);

    if Form1.sModeloECF = '99' then
      _ecf99_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado), Form7.CheckBox3.Checked, 1680);

  finally
    FreeAndNil(IBQNFCE);
    ChDir(sDirAtual);
    sl.Free;
    slNFCe.Free;
    RE.Free;
    XMLNFE := nil;

    Screen.Cursor  := crDefault;
  end;

end;

procedure RelatorioResumoDasVendas;
begin
  try
    CommitaTudo(True); // Vendaspor1Click
    //
    //sAjuda := 'ecf_cotepe.htm#Meios de Pagto.';
    //
    Form1.Timer2.Enabled := False;
    Form7.bVendaPorDocumento := True;
    Form7.Caption := 'Resumo de Vendas';
    Form7.ShowModal;
    if Form7.ModalResult = mrOk then
    begin
      VendasPorNFCe(Form7.dtpVendasInicial.Date, Form7.dtpVendasFinal.Date, Form7.edCaixa.Text, Form7.edCliente.Text, Form7.cbFormasPagto.Text);
    end;
  finally
    Form7.bVendaPorDocumento := False;
    if Form1.ImportarvendasdoSmallMobile1.Checked then // Sandro Silva 2016-03-23
      Form1.Timer2.Enabled := True;
  end;
end;

procedure VendasPorNFCe(dtInicio: TDate; dtFinal: TDate;
  sCaixa: String; sCliente: String; sFormaPagto: String);
// Relatório de vendas por NFC-e/CF-e-SAT
var
  IBQNFCE: TIBQuery;
  sCupomfiscalVinculado : String;
  sCupom: String;
  sData: String;
  dTotalDia: Double;
  dTotalCaixa: Double;
  dTotal: Double;
  aForma: array of TForma;
  aCaixa: array of TCaixa;
  iArray: Integer;
  sContingenciaPendente: String;
  sNotaContingencia: String; // Sandro Silva 2020-02-18
  function AchaForma(sForma: String): Integer;
  var
    iPosicao: Integer;
  begin
    Result := -1;
    for iPosicao := 0 to Length(aForma) - 1 do
    begin
      if sForma = aForma[iPosicao].Forma then // Sandro Silva 2019-06-14 if sForma = aForma[iPosicao].sForma then
      begin
        Result := iPosicao;
        Break;
      end;
    end;
  end;

  function AchaCaixa(sCaxia: String): Integer;
  var
    iPosicao: Integer;
  begin
    Result := -1;
    for iPosicao := 0 to Length(aCaixa) - 1 do
    begin
      if sCaixa = aCaixa[iPosicao].sCaixa then
      begin
        Result := iPosicao;
        Break;
      end;
    end;
  end;
begin
  sCliente    := Trim(sCliente);
  sCaixa      := Trim(sCaixa);
  sFormaPagto := Trim(sFormaPagto);
  Commitatudo(True); // VendasPorNFCe
  IBQNFCE     := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQNFCE.DisableControls; // Sandro Silva 2020-02-18

  Screen.Cursor := crHourGlass;

  sContingenciaPendente := '';
  if Form1.sModeloECF = '65' then
    sContingenciaPendente := IfThen(_ecf65_VerificaContingenciaPendentedeTransmissao(dtInicio, dtFinal, sCaixa), ALERTA_CONTINGENCIA_NAO_TRANSMITIDA + '(C)' + Chr(10), '');

  try
    sCupomFiscalVinculado := CabecalhoRelatoriosGerenciais
      + chr(10) + 'Resumo de Vendas' + chr(10)
      + 'Período: ' + FormatDateTime('dd/mm/yyyy', dtInicio) + ' a ' + FormatDateTime('dd/mm/yyyy', dtFinal) + chr(10)
      + sContingenciaPendente + Chr(10); // Sandro Silva 2019-08-14

    if sCliente <> '' then
      sCupomFiscalVinculado := sCupomFiscalVinculado
        + 'Cliente: ' + sCliente + chr(10);

    if sFormaPagto <> '' then
      sCupomFiscalVinculado := sCupomFiscalVinculado
        + 'Forma: ' + sFormaPagto + chr(10);

    if Trim(sCaixa) <> '' then
      sCupomFiscalVinculado := sCupomFiscalVinculado
        + 'Caixa: ' + sCaixa + chr(10);


    sCupomFiscalVinculado := sCupomFiscalVinculado
      + ImprimeTracos() + Chr(10)
      + 'NUMERO R$ TOTAL   FORMA               Valor    ' + Chr(10)
      + ImprimeTracos() + Chr(10);

    IBQNFCE.Close;
    IBQNFCE.SQL.Text :=
      'select N.NUMERONF, N.DATA, N.CAIXA, N.MODELO, N.STATUS, ' +
      'max(P.CLIFOR) as CLIFOR, ' +
      '(select sum(A.TOTAL) from ALTERACA A where A.PEDIDO = N.NUMERONF and A.CAIXA = N.CAIXA and A.DATA = N.DATA and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') and A.DESCRICAO <> ''<CANCELADO>'') as TOTAL, ' +
      'trim(replace(replace(substring(P.FORMA from 1 for 30), ''NFC-e'', ''''), ''NF-e'', '''')) as FORMA, ' + // Sandro Silva 2018-08-06 'trim(replace(replace(substring(P.FORMA from 4 for 30), ''NFC-e'', ''''), ''NF-e'', '''')) as FORMA, ' +
      'sum(case when substring(P.FORMA from 1 for 2) = ''13'' then (P.VALOR * (-1)) else P.VALOR end) as VALOR ' + // Quando for troco o valor deve ser negativo para descontar dos totais // Sandro Silva 2018-08-06
      'from NFCE N ' +
      'left join PAGAMENT P on P.PEDIDO = N.NUMERONF and P.CAIXA = N.CAIXA and P.DATA = N.DATA and substring(FORMA from 1 for 2) <> ''00'' ' +
                              ' and coalesce(P.CCF, '''') <> '''' ' + // Sangria e Suprimento tem CCF vazio
      'where N.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtInicio)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtFinal)) +
      // Sandro Silva 2020-09-28  ' and (N.STATUS containing ''Autoriza'' or N.STATUS containing ''Emitido com sucesso'' or N.STATUS containing ' + QuotedStr(NFCE_EMITIDA_EM_CONTINGENCIA) + ' ) ' + // Ficha 4819 Sandro Silva 2020-02-18 ' and (N.STATUS containing ''Autoriza'' or N.STATUS containing ''Emitido com sucesso'' ) ' +
      ' and (N.STATUS containing ''Autoriza'' or N.STATUS containing ''Emitido com sucesso'' or N.STATUS containing ' + QuotedStr(NFCE_EMITIDA_EM_CONTINGENCIA) + ' or N.STATUS containing ' + QuotedStr(VENDA_GERENCIAL_FINALIZADA) + ' or N.STATUS containing ' + QuotedStr(VENDA_MEI_ANTIGA_FINALIZADA) + ' ) ' + // Ficha 4819 Sandro Silva 2020-02-18 ' and (N.STATUS containing ''Autoriza'' or N.STATUS containing ''Emitido com sucesso'' ) ' +
      ' and (N.STATUS not containing ''Rejei'') ' +
      ' and coalesce(P.VALOR, 0) > 0 ';
    if sCaixa <> '' then
      IBQNFCE.SQL.Add(' and N.CAIXA = ' + QuotedStr(sCaixa));
    if sCliente <> '' then
      IBQNFCE.SQL.Add(' and upper(P.CLIFOR) = ' + QuotedStr(UpperCase(sCliente))); // Sandro Silva 2018-08-07 IBQNFCE.SQL.Add(' and upper(A.CLIFOR) = ' + QuotedStr(UpperCase(sCliente)));
    if sFormaPagto <> '' then
      IBQNFCE.SQL.Add(' and substring(P.FORMA from 4 for 30) containing ' + QuotedStr(sFormaPagto));
    IBQNFCE.SQL.Add('group by N.NUMERONF, N.DATA, N.CAIXA, N.MODELO, N.STATUS, ' +
                    'trim(replace(replace(substring(P.FORMA from 1 for 30), ''NFC-e'', ''''), ''NF-e'', '''')) ' + // Sandro Silva 2018-08-06 'trim(replace(replace(substring(P.FORMA from 4 for 30), ''NFC-e'', ''''), ''NF-e'', '''')) ' + // Sandro Silva 2017-08-28 , P.VALOR ' +
                    'order by DATA, CAIXA, MODELO, NUMERONF, FORMA' // Sandro Silva 2018-08-06 'order by DATA, CAIXA, MODELO, NUMERONF'
                   );
    IBQNFCE.Open;

    dTotal      := 0.00;
    dTotalDia   := 0.00;
    dTotalCaixa := 0.00;
    sCupom := '';
    if sCaixa <> '' then
      sCaixa := ' '; // Para quando escolher relatório por um caixa
    sData := FormatDateTime('dd/mm/yyyy', IBQNFCE.FieldByName('DATA').AsDateTime);

    while IBQNFCE.Eof = False do
    begin
      if (IBQNFCE.FieldByName('STATUS').AsString <> '') then // NFC-e/CF-e-SAT autorizados
      begin

        if sData <> FormatDateTime('dd/mm/yyyy', IBQNFCE.FieldByName('DATA').AsDateTime) then // Mudou o dia
        begin

          if dTotalCaixa <> 0.00 then // Totaliza o dia anterior
          begin
            sCupomFiscalVinculado := sCupomFiscalVinculado
              + '--------------------------' + Chr(10);

            sCupomFiscalVinculado := sCupomFiscalVinculado
              + 'Total Caixa: ' + sCaixa + ' ' + Format('%9.2n',[dTotalCaixa]) + chr(10);
            dTotalCaixa := 0.00;
          end;

          sCupomFiscalVinculado := sCupomFiscalVinculado
        + '-----------------------------------' + chr(10);

          sCupomFiscalVinculado := sCupomFiscalVinculado
            + 'Total do dia: ' + sData + '  ' + Format('%9.2n',[dTotalDia]) + chr(10);
          sData := FormatDateTime('dd/mm/yyyy', IBQNFCE.FieldByName('DATA').AsDateTime);
          dTotalDia := 0.00;
          sCaixa := ' ';
        end;

        if sCaixa <> IBQNFCE.FieldByName('CAIXA').AsString then // Mudou o caixa
        begin
          if dTotalCaixa <> 0.00 then // Totaliza o caixa
          begin
            sCupomFiscalVinculado := sCupomFiscalVinculado
              + '--------------------------' + Chr(10);

            sCupomFiscalVinculado := sCupomFiscalVinculado
              + 'Total Caixa: ' + sCaixa + ' ' + Format('%9.2n',[dTotalCaixa]) + chr(10);
            dTotalCaixa := 0.00;
          end;
          sCaixa := IBQNFCE.FieldByName('CAIXA').AsString;
          sCupomFiscalVinculado := sCupomFiscalVinculado
            + 'Caixa: ' + IBQNFCE.FieldByName('CAIXA').AsString + '  Data: ' + FormatDateTime('dd/mm/yyyy', IBQNFCE.FieldByName('DATA').AsDateTime) + chr(10);
          sCupom := '';
        end;

        if sCupom <> IBQNFCE.FieldByName('NUMERONF').AsString then // Mudou o cupom
        begin
          sCupom := IBQNFCE.FieldByName('NUMERONF').AsString;
          sNotaContingencia := ' ';
          if AnsiContainsText(IBQNFCE.FieldByName('STATUS').AsString, 'conting') then
            sNotaContingencia := 'C';

          // Ficha 4819 Sandro Silva 2020-02-18  sCupomFiscalVinculado := sCupomFiscalVinculado + Right(IBQNFCE.FieldByName('NUMERONF').AsString, 6) + '  ' + Format('%8.2n',[IBQNFCE.FieldByName('TOTAL').AsFloat]) + ' ';
          sCupomFiscalVinculado := sCupomFiscalVinculado + Right(IBQNFCE.FieldByName('NUMERONF').AsString, 6) + sNotaContingencia + ' ' + Format('%8.2n',[IBQNFCE.FieldByName('TOTAL').AsFloat]) + ' ';
        end
        else
        begin // Mesmo cupom com mais de uma forma de pagamento
          sCupomFiscalVinculado := sCupomFiscalVinculado + DupeString(' ', 17); // Sandro Silva 2018-03-23  sCupomFiscalVinculado := sCupomFiscalVinculado + DupeString(' ', 18);// + Copy(Copy(IBQNFCE.FieldByName('FORMA').AsString, 1, 20) + DupeString(' ', 18), 1, 20) + ' ' + Format('%9.2n',[IBQNFCE.FieldByName('VALOR').AsFloat]) + Chr(10);
        end;
        sCupomFiscalVinculado := sCupomFiscalVinculado + Copy(Copy(IBQNFCE.FieldByName('FORMA').AsString, 4, 20) + DupeString(' ', 18), 1, 20) + Format('%8.2n',[IBQNFCE.FieldByName('VALOR').AsFloat]) + Chr(10);

        dTotal      := dTotal + IBQNFCE.FieldByName('VALOR').AsFloat;
        dTotalDia   := dTotalDia + IBQNFCE.FieldByName('VALOR').AsFloat;
        dTotalCaixa := dTotalCaixa + IBQNFCE.FieldByName('VALOR').AsFloat;

        iArray := AchaForma(IBQNFCE.FieldByName('FORMA').AsString);
        if iArray = -1 then
        begin
          SetLength(aForma, Length(aForma) + 1);
          iArray := High(aForma);
          aForma[iArray] := TForma.Create; // Sandro Silva 2019-06-14
          aForma[iArray].Forma := IBQNFCE.FieldByName('FORMA').AsString; // Sandro Silva 2019-06-14 aForma[iArray].sForma := IBQNFCE.FieldByName('FORMA').AsString; 
        end;

        aForma[iArray].Valor := aForma[iArray].Valor + IBQNFCE.FieldByName('VALOR').AsFloat; // Sandro Silva 2019-06-14 aForma[iArray].dValor := aForma[iArray].dValor + IBQNFCE.FieldByName('VALOR').AsFloat; 

        iArray := AchaCaixa(IBQNFCE.FieldByName('CAIXA').AsString);
        if iArray = -1 then
        begin
          SetLength(aCaixa, Length(aCaixa) + 1);
          iArray := High(aCaixa);
          aCaixa[iArray] := TCaixa.Create; // Sandro Silva 2019-06-14 
          aCaixa[iArray].sCaixa := IBQNFCE.FieldByName('CAIXA').AsString;
        end;

        aCaixa[iArray].dValor := aCaixa[iArray].dValor + IBQNFCE.FieldByName('VALOR').AsFloat;// Soma das forma diferentes no mesmo cupom é igual ao total do cupom
      end; // if (IBQNFCE.FieldByName('STATUS').AsString <> '') then

      IBQNFCE.Next;
    end; // while IBQNFCE.Eof = False do

    if dTotalCaixa <> 0.00 then // Totaliza o caixa
    begin
      sCupomFiscalVinculado := sCupomFiscalVinculado
        + '--------------------------' + Chr(10);

      sCupomFiscalVinculado := sCupomFiscalVinculado
        + 'Total Caixa: ' + sCaixa + ' ' + Format('%9.2n',[dTotalCaixa]) + chr(10);
    end;

    if dTotalDia <> 0.00 then // Totaliza o dia
    begin
      sCupomFiscalVinculado := sCupomFiscalVinculado
      + ImprimeTracos() + Chr(10);// Sandro Silva 2018-03-21   + '-----------------------------------' + chr(10);

      sCupomFiscalVinculado := sCupomFiscalVinculado + 'Total do dia: ' + sData + '  ' + Format('%9.2n',[dTotalDia]) + chr(10);
    end;

    sCupomFiscalVinculado := sCupomFiscalVinculado
      + ImprimeTracos() + Chr(10)// Sandro Silva 2018-03-21  + '-----------------------------------------------' + chr(10)
      + 'TOTAL R$' + Format('%9.2n',[dTotal]) + Chr(10) + Chr(10);

    sCupomFiscalVinculado := sCupomFiscalVinculado
      // Sandro Silva 2018-03-21  + '-----------------------------------------------' + chr(10)
      + ImprimeTracos() + Chr(10)
      + 'Caixa                                Total     ' + Chr(10)
      + ImprimeTracos() + Chr(10);// Sandro Silva 2018-03-21  + '------------------------------------ ----------' + Chr(10);

    dTotal := 0.00;
    for iArray := 0 to Length(aCaixa) -1 do
    begin
      sCupomFiscalVinculado := sCupomFiscalVinculado + Copy(aCaixa[iArray].sCaixa + DupeString(' ', 36), 1, 36) + ' '  + Format('%9.2n',[aCaixa[iArray].dValor]) + Chr(10);// Sandro Silva 2018-03-23  sCupomFiscalVinculado := sCupomFiscalVinculado + Copy(aCaixa[iArray].sCaixa + DupeString(' ', 37), 1, 37) + ' '  + Format('%9.2n',[aCaixa[iArray].dValor]) + Chr(10);
      dTotal := dTotal + aCaixa[iArray].dValor;
    end;
    sCupomFiscalVinculado := sCupomFiscalVinculado
      + ImprimeTracos() + Chr(10)// Sandro Silva 2018-03-21  + '------------------------------------ ----------' + chr(10)
      + Copy('Total' + DupeString(' ', 36), 1, 36) + ' '  + Format('%9.2n',[dTotal]) + Chr(10) + Chr(10);//+ Copy('Total' + DupeString(' ', 37), 1, 37) + ' '  + Format('%9.2n',[dTotal]) + Chr(10) + Chr(10);

    sCupomFiscalVinculado := sCupomFiscalVinculado
      + ImprimeTracos() + Chr(10)// Sandro Silva 2018-03-21  + '-----------------------------------------------' + chr(10)
      + 'Forma de Pagamento                   Total     ' + Chr(10)
      + ImprimeTracos() + Chr(10);// Sandro Silva 2018-03-21  + '------------------------------------ ----------' + Chr(10);

    dTotal := 0.00;
    for iArray := 0 to Length(aForma) -1 do
    begin
      // Sandro Silva 2018-08-06  sCupomFiscalVinculado := sCupomFiscalVinculado + Copy(aForma[iArray].sForma + DupeString(' ', 36), 1, 36) + ' '  + Format('%9.2n',[aForma[iArray].dValor]) + Chr(10);// Sandro Silva 2018-03-23  sCupomFiscalVinculado := sCupomFiscalVinculado + Copy(aForma[iArray].sForma + DupeString(' ', 37), 1, 37) + ' '  + Format('%9.2n',[aForma[iArray].dValor]) + Chr(10);
      sCupomFiscalVinculado := sCupomFiscalVinculado + Copy(aForma[iArray].Forma + DupeString(' ', 36), 4, 36) + ' '  + Format('%9.2n',[aForma[iArray].Valor]) + Chr(10); // Sandro Silva 2019-06-14 sCupomFiscalVinculado := sCupomFiscalVinculado + Copy(aForma[iArray].sForma + DupeString(' ', 36), 4, 36) + ' '  + Format('%9.2n',[aForma[iArray].dValor]) + Chr(10); 
      dTotal := dTotal + aForma[iArray].Valor; // Sandro Silva 2019-06-14 dTotal := dTotal + aForma[iArray].dValor;
    end;
    sCupomFiscalVinculado := sCupomFiscalVinculado
      + '----------------------------------- ----------' + chr(10)
      + Copy('Total' + DupeString(' ', 36), 1, 36) + ' '  + Format('%9.2n',[dTotal]) + Chr(10); // Sandro Silva 2018-03-23  + Copy('Total' + DupeString(' ', 37), 1, 37) + ' '  + Format('%9.2n',[dTotal]) + Chr(10);


    if Form1.sModeloECF = '59' then
      _ecf59_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado), Form7.checkVendaPorDocumento.Checked); // Sandro Silva 2018-03-22 _ecf59_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado));

    if Form1.sModeloECF = '65' then
      _ecf65_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado), Form7.checkVendaPorDocumento.Checked);

    if Form1.sModeloECF = '99' then
      _ecf99_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado), Form7.checkVendaPorDocumento.Checked);

  finally
    FreeAndNil(IBQNFCE);
    for iArray := 0 to High(aForma) do
      FreeAndNil(aForma[iArray]);
    for iArray := 0 to High(aCaixa) do
      FreeAndNil(aCaixa[iArray]);
    Screen.Cursor  := crDefault;

  end;
end;

procedure RelatorioTotalDiario;
begin

  try
    // Já faz em TotalDiario() CommitaTudo(True); // Vendaspor1Click
    Form1.Timer2.Enabled := False;
    Form7.bTotalDiario := True;
    Form7.Caption := 'Total Diário';
    Form7.ShowModal;
    if Form7.ModalResult = mrOk then
    begin
      TotalDiario(Form7.dtpInicialDiario.Date, Form7.dtpFinalDiario.Date, Form7.edCaixaDiario.Text, Copy(Form7.cbModeloDiario.Text, 1, 2));
    end;
  finally
    Form7.bTotalDiario := False;
    if Form1.ImportarvendasdoSmallMobile1.Checked then // Sandro Silva 2016-03-23
      Form1.Timer2.Enabled := True;
  end;

end;

procedure TotalDiario(dtInicio, dtFinal: TDate; sCaixa: String;
  sModelo: String);
var
  IBQNFCE: TIBQuery;
  sCupomfiscalVinculado : String;
  aDiario: array of TDiario;
  sData: String;
  sCupomI: String;
  sCupomF: String;
  iDiario: Integer;
  dTotal: Double;
  dLiquido: Double;
begin
  // Solicitado por Laylton Freitas
  Commitatudo(True); // TotalDiario()
  IBQNFCE      := CriaIBQuery(Form1.ibDataSet27.Transaction);
  Screen.Cursor := crHourGlass;
  //
  dLiquido := 0;
  dTotal   := 0;
  //
  try
    sCaixa := Trim(sCaixa);

    IBQNFCE.Close;
    IBQNFCE.SQL.Text :=
      'select A.DESCRICAO, A.DATA, A.PEDIDO, A.CAIXA, A.TOTAL ' +
      'from ALTERACA A ' +
      'where A.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtInicio)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtFinal)) +
      ' and (A.TIPO = ''BALCAO'' or TIPO = ''LOKED'') ' +
      ' and A.PEDIDO in (select N.NUMERONF ' +
                        'from NFCE N ' +
                        'where (N.STATUS containing ''Autoriza'' or N.STATUS containing ''Emitido com sucesso'' or N.STATUS containing ' + QuotedStr(NFCE_EMITIDA_EM_CONTINGENCIA) + ' or N.STATUS containing ' + QuotedStr(VENDA_GERENCIAL_FINALIZADA) + ' or N.STATUS containing ' + QuotedStr(VENDA_MEI_ANTIGA_FINALIZADA) + ' ) ' + // Sandro Silva 2021-09-09 Ficha 5499 'where (N.STATUS containing ''Autoriza'' or N.STATUS containing ''Emitido com sucesso'' or N.STATUS containing ' + QuotedStr(VENDA_GERENCIAL_FINALIZADA) + ' ) ' +
                        ' and N.MODELO = ' + QuotedStr(sModelo) +
                        ' and (N.STATUS not containing ''Rejei'')) ';
    if sCaixa <> '' then
      IBQNFCE.SQL.Add(' and A.CAIXA = ' + QuotedStr(sCaixa));
    IBQNFCE.SQL.Add(' order by A.DATA, A.PEDIDO');
    IBQNFCE.Open;

    sData   := '';
    sCupomI := '';
    sCupomF := '';
    while IBQNFCE.Eof = False do
    begin
      if IBQNFCE.FieldByName('DATA').AsString <> sData then
      begin
        SetLength(aDiario, Length(aDiario) + 1);
        sData := IBQNFCE.FieldByName('DATA').AsString;
        iDiario := High(aDiario);
        aDiario[iDiario] := TDiario.Create;// Sandro Silva 2019-06-14
        aDiario[iDiario].dtData := IBQNFCE.FieldByName('DATA').AsDateTime;
      end
      else
        iDiario := High(aDiario);

      if IBQNFCE.FieldByName('DESCRICAO').AsString = 'Desconto' then
        aDiario[iDiario].dDesconto := aDiario[iDiario].dDesconto + IBQNFCE.FieldByName('TOTAL').AsFloat;

      if (IBQNFCE.FieldByName('DESCRICAO').AsString <> 'Desconto') then
        aDiario[iDiario].dTotal := aDiario[iDiario].dTotal + IBQNFCE.FieldByName('TOTAL').AsFloat;

      if (IBQNFCE.FieldByName('PEDIDO').AsString > sCupomF)
        or (sCupomF = '') then
        sCupomF := IBQNFCE.FieldByName('PEDIDO').AsString;

      if (IBQNFCE.FieldByName('PEDIDO').AsString < sCupomI)
        or (sCupomI = '') then
        sCupomI := IBQNFCE.FieldByName('PEDIDO').AsString;

      IBQNFCE.Next;
    end;

    sCupomFiscalVinculado := CabecalhoRelatoriosGerenciais
      + chr(10) + 'Total Diário' + chr(10)
      + 'Período: ' + FormatDateTime('dd/mm/yyyy', dtInicio) + ' a ' + FormatDateTime('dd/mm/yyyy', dtFinal) + chr(10);

    if Form1.sModeloECF = '65' then
    begin
      if _ecf65_VerificaContingenciaPendentedeTransmissao(dtInicio, dtFinal, sCaixa) then
        sCupomFiscalVinculado := sCupomFiscalVinculado + ALERTA_CONTINGENCIA_NAO_TRANSMITIDA + Chr(10);
    end;

    if Trim(sCaixa) <> '' then
      sCupomFiscalVinculado := sCupomFiscalVinculado
        + 'Caixa: ' + sCaixa + chr(10);

    sCupomFiscalVinculado := sCupomFiscalVinculado
      +'Documento Inicial: ' + sCupomI + Chr(10)
      +'Documento Final..: ' + sCupomF + Chr(10);

    sCupomFiscalVinculado := sCupomFiscalVinculado
      + ImprimeTracos() + Chr(10)
      + 'DIA                     R$ LIQUIDO             ' + Chr(10)
      + ImprimeTracos() + Chr(10);

    for iDiario := 0 to Length(aDiario) - 1 do
    begin
      sCupomFiscalVinculado := sCupomFiscalVinculado
        + FormatDateTime('dd/mm/yyyy', aDiario[iDiario].dtData) + DupeString(' ', 13) + Format('%9.2n',[aDiario[iDiario].dTotal + aDiario[iDiario].dAcrescimo + aDiario[iDiario].dDesconto]) + Chr(10);
      dTotal   := dTotal + aDiario[iDiario].dTotal;
      dLiquido := dLiquido + aDiario[iDiario].dTotal + aDiario[iDiario].dAcrescimo + aDiario[iDiario].dDesconto;
    end;

    sCupomFiscalVinculado := sCupomFiscalVinculado
      + ImprimeTracos() + Chr(10)
      + 'Total     ' + DupeString(' ', 13) + Format('%9.2n',[dLiquido]) + Chr(10);

    if Form1.sModeloECF = '59' then
      _ecf59_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado), Form7.checkTotalDiario.Checked); // Sandro Silva 2018-03-22 _ecf59_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado));
    if Form1.sModeloECF = '65' then
      _ecf65_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado), Form7.checkTotalDiario.Checked);
    if Form1.sModeloECF = '99' then
      _ecf99_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado), Form7.checkTotalDiario.Checked);

  finally
    FreeAndNil(IBQNFCE);
    for iDiario := 0 to High(aDiario) do
      FreeAndNil(aDiario[iDiario]);
    Screen.Cursor  := crDefault;
  end;
end;

procedure RelatorioFechamentoDeCaixa;
begin

  try
    // Já faz em TotalDiario() CommitaTudo(True); // Vendaspor1Click
    Form1.Timer2.Enabled := False;
    Form7.bFechamentoDeCaixa := True;
    Form7.Caption := '';
    Form7.ShowModal;
    if Form7.ModalResult = mrOk then
    begin
      //TotalDiario(Form7.dtpInicialDiario.Date, Form7.dtpFinalDiario.Date, Form7.edCaixaDiario.Text, Copy(Form7.cbModeloDiario.Text, 1, 2));
      FechamentoDeCaixa(Form7.chkFechamentoDeCaixaHoraI.Checked);
    end;
  finally
    Form7.bFechamentoDeCaixa := False;
    if Form1.ImportarvendasdoSmallMobile1.Checked then // Sandro Silva 2016-03-23
      Form1.Timer2.Enabled := True;
  end;

end;

function ListaCaixasSelecionados(Lista: TCheckListBox): String;
var
  iCaixa: Integer;
begin
  Result := '';
  for iCaixa := 0 to Lista.Items.Count - 1 do
  begin

    if Lista.Checked[iCaixa] then
    begin
      if Result <> '' then
        Result := Result + ', ';

      Result := Result + QuotedStr(LIsta.Items.Strings[iCaixa]);
    end;
  end;

end;

procedure FechamentoDeCaixa(bNaHora: Boolean);
var
  iCaixa: Integer;
  sListaCaixas: String;
  IBQNFCE: TIBQuery;
  sRegraNFCe: String;
  sJoinPagament: String;
  dTotalSuprimento: Double;
  dTotalDinheiro: Double;
  dTotalTroco: Double;
  dTotalSangria: Double;
  dTotal: Double;
  sCupomFiscalVinculado: String;
  sPeriodo: String;
begin
  // Solicitado por migração de concorrente
  Commitatudo(True); // TotalDiario()
  IBQNFCE      := CriaIBQuery(Form1.ibDataSet27.Transaction);
  Screen.Cursor := crHourGlass;

  try

    sListaCaixas := ListaCaixasSelecionados(Form7.chklbCaixas);

    if sListaCaixas <> '' then
      sListaCaixas := ' and coalesce(P.CAIXA, '''') in (' + sListaCaixas + ') ';

    sJoinPagament := ' join PAGAMENT P on P.PEDIDO = N.NUMERONF and P.CAIXA = N.CAIXA and P.DATA = N.DATA ';
    sRegraNFCe := ' and (N.STATUS containing ''Autoriza'' or N.STATUS containing ''Emitido com sucesso'' or N.STATUS containing ' + QuotedStr(NFCE_EMITIDA_EM_CONTINGENCIA) + ' or N.STATUS containing ' + QuotedStr(VENDA_GERENCIAL_FINALIZADA) + ' or N.STATUS containing ' + QuotedStr(VENDA_MEI_ANTIGA_FINALIZADA) + ' ) ' +
      ' and (N.STATUS not containing ''Rejei'') ';

    if bNaHora then
      sPeriodo := ' and cast(P.DATA || '' '' || P.HORA as timestamp) between cast(' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpFechamentoDeCaixaIni.Date)) + ' || '' '' || ' + QuotedStr(FormatDateTime('HH:nn:00', Form7.dtpFechamentoDeCaixaHoraI.Time)) + ' as timestamp) and cast(' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpFechamentoDeCaixaFim.Date)) + ' || '' '' || ' + QuotedStr(FormatDateTime('HH:nn:59', Form7.dtpFechamentoDeCaixaHoraF.Time)) + ' as timestamp) '
    else
      sPeriodo := ' and P.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpFechamentoDeCaixaIni.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.dtpFechamentoDeCaixaFim.Date)) + ' ';

    //'-- suprimento ' +
    IBQNFCE.Close;
    IBQNFCE.SQL.Text :=
      'select ' +
      ' sum(P.VALOR) as VALOR ' +
      'from PAGAMENT P ' +
      'where P.FORMA not like ''00%'' ' +
      'and coalesce(P.CLIFOR, '''') = ''Suprimento'' ' +
      sListaCaixas +
      sPeriodo;
    IBQNFCE.Open;
    dTotalSuprimento := IBQNFCE.FieldByName('VALOR').AsFloat;

      //'-- Dinheiro ' +
    IBQNFCE.Close;
    IBQNFCE.SQL.Text :=
      'select ' +
      ' sum(P.VALOR) as VALOR ' +
      'from NFCE N ' +
      sJoinPagament +
      ' where P.FORMA not like ''00%'' ' +
      'and (coalesce(P.CLIFOR, '''') <> ''Suprimento'') ' +
      'and P.FORMA like ''02%'' ' + /// dinheiro
      sListaCaixas + sRegraNFCe +
      sPeriodo;// +
      //'group by ''DINHEIRO'' ';
    IBQNFCE.Open;
    dTotalDinheiro := IBQNFCE.FieldByName('VALOR').AsFloat;

    //'-- Troco ' +
    IBQNFCE.Close;
    IBQNFCE.SQL.Text :=
      'select ' +
      ' sum(coalesce(P.VALOR, 0.00)) as VALOR ' +
      'from NFCE N ' +
      sJoinPagament +
      ' where P.FORMA like ''13%'' ' + // Troco
      sListaCaixas + sRegraNFCe +
      sPeriodo;// +
      //'group by ''TROCO'' ';
    IBQNFCE.Open;
    dTotalTroco := IBQNFCE.FieldByName('VALOR').AsFloat;

    //'-- Sangria ' +
    IBQNFCE.Close;
    IBQNFCE.SQL.Text :=
      'select ' +
      ' sum(P.VALOR) as VALOR ' +
      'from PAGAMENT P ' +
      'where P.FORMA not like ''00%'' ' +
      'and coalesce(P.CLIFOR, '''') = ''Sangria'' ' +
      sListaCaixas +
      //' and P.DATA between :DINI and :DFIM ' +
      sPeriodo;// +
      //'group by ''SANGRIA'' ';
//    IBQNFCE.ParamByName('DINI').AsDate := Form7.dtpFechamentoDeCaixaIni.Date;
//    IBQNFCE.ParamByName('DFIM').AsDate := Form7.dtpFechamentoDeCaixaFim.Date;
    IBQNFCE.Open;
    dTotalSangria := IBQNFCE.FieldByName('VALOR').AsFloat;


    sCupomFiscalVinculado := CabecalhoRelatoriosGerenciais;

    sCupomFiscalVinculado := sCupomFiscalVinculado + (*Form7.lbCaixaFechamentoDeCaixa.Caption*) 'Caixa(s): ' + StringReplace(ListaCaixasSelecionados(Form7.chklbCaixas), #39, '', [rfReplaceAll]) + Chr(10) +
      'Período: ' + FormatDateTime('dd/mm/yyyy', Form7.dtpFechamentoDeCaixaIni.Date) + ' à ' + FormatDateTime('dd/mm/yyyy', Form7.dtpFechamentoDeCaixaFim.Date) + Chr(10);
    if bNaHora then
      sCupomFiscalVinculado := sCupomFiscalVinculado + 'Horário: ' + FormatDateTime('HH:nn', Form7.dtpFechamentoDeCaixaHoraI.Date) + ' à ' + FormatDateTime('HH:nn', Form7.dtpFechamentoDeCaixaHoraF.Date) + Chr(10);

    sCupomFiscalVinculado := sCupomFiscalVinculado
      + ImprimeTracos() + Chr(10)
      + 'MOVIMENTAÇÃO EM DINHEIRO  ' + Chr(10)
      + ImprimeTracos() + Chr(10)
      + 'Suprimento ' + Format('%9.2n',[dTotalSuprimento]) + chr(10)
      + 'Dinheiro   ' + Format('%9.2n',[dTotalDinheiro]) + chr(10)
      + 'Troco      ' + Format('%9.2n',[dTotalTroco]) + chr(10)
      + 'Sangria    ' + Format('%9.2n',[dTotalSangria]) + chr(10)
      + ImprimeTracos() + Chr(10)
      + 'Total      ' + Format('%9.2n',[dTotalSuprimento + dTotalDinheiro - dTotalTroco - dTotalSangria]) + chr(10)
      + chr(10);

      // Totalizadores
    IBQNFCE.Close;
    IBQNFCE.SQL.Text :=
      'select replace(substring(P.FORMA from 4 for char_length(P.FORMA)), ''NFC-e'', '''') as FORMA ' +
      ', sum(P.VALOR) as VALOR ' +
      'from PAGAMENT P ' +
      'where P.FORMA not like ''00%'' ' +
      'and P.FORMA not like ''13%'' ' +
      'and (coalesce(P.CLIFOR, '''') <> ''Sangria'' and coalesce(P.CLIFOR, '''') <> ''Suprimento'') ' +
      sListaCaixas +
      sPeriodo +
      ' group by replace(substring(P.FORMA from 4 for char_length(P.FORMA)), ''NFC-e'', '''') ' +
      ' order by FORMA';
    IBQNFCE.Open;

    sCupomFiscalVinculado := sCupomFiscalVinculado
      + ImprimeTracos() + Chr(10)
      + 'TOTALIZADORES             ' + Chr(10)
      + ImprimeTracos() + Chr(10)
      ;

    dTotal := 0.00;
    while IBQNFCE.Eof = False do
    begin

      sCupomFiscalVinculado := sCupomFiscalVinculado
        + Copy(IBQNFCE.FieldByName('Forma').AsString + DupeString(' ', 31), 1, 31) + Format('%9.2n', [IBQNFCE.FieldByName('VALOR').AsFloat]) + Chr(10);
      dTotal   := dTotal + IBQNFCE.FieldByName('VALOR').AsFloat;

      IBQNFCE.Next;
    end;

    sCupomFiscalVinculado := sCupomFiscalVinculado
      + ImprimeTracos() + Chr(10)
      +  Copy('Total' + DupeString(' ', 31), 1, 31) + Format('%9.2n',[dTotal]) + Chr(10) + Chr(10);

    if Form1.sModeloECF = '59' then
      _ecf59_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado), Form7.checkFechamentoDeCaixaPDF.Checked);

    if Form1.sModeloECF = '65' then
      _ecf65_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado), Form7.checkFechamentoDeCaixaPDF.Checked);

    if Form1.sModeloECF = '99' then
      _ecf99_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado), Form7.checkFechamentoDeCaixaPDF.Checked);


  finally
    Screen.Cursor := crDefault;
    FreeAndNil(IBQNFCE);

  end;
end;

end.
