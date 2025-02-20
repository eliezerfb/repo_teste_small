unit uRelatorioPisCofins;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uReportScreenBase, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.CheckLst;

type
  TRelatorioPisCofinsType = (rtNFe, rtCumpomFiscal);

  TfrmRelatorioPisCofins = class(TfrmReportScreenBase)
    tbsFilter: TTabSheet;
    PanelFilter: TPanel;
    CheckListBoxCST: TCheckListBox;
    SpeedButtonCheckAll: TSpeedButton;
    SpeedButtonUncheckAll: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButtonCheckAllClick(Sender: TObject);
    procedure SpeedButtonUncheckAllClick(Sender: TObject);
  private
    { Private declarations }
    FFilterByCSTPisCofins: String;
    FRelatorioPisCofinsType: TRelatorioPisCofinsType;
    procedure RelatorioPisCofinsNfe(var F: TextFile; dInicio,
      dFinal : TdateTime);
    procedure RelatorioPisCofinsCupom(var F: TextFile; dInicio,
      dFinal: TdateTime);
    procedure Print(); override;
    function Validate(var AMsg: string): Boolean; override;
  public
    { Public declarations }
    class function Execute(AInfoReportBase: TInfoReportBase;
      ARelatorioPisCofinsType: TRelatorioPisCofinsType): Boolean;
  end;

var
  frmRelatorioPisCofins: TfrmRelatorioPisCofins;

implementation

{$R *.dfm}

uses
  uRateioVendasBalcao, uAtualizaNovoCampoItens001CSOSN, uSmallConsts, Unit7,
  Smallfunc_xe;

{ TfrmRelatorioPisCofins }

class function TfrmRelatorioPisCofins.Execute(AInfoReportBase: TInfoReportBase;
  ARelatorioPisCofinsType: TRelatorioPisCofinsType): Boolean;
function getTitlePrefix(): string;
begin
  Result := '(NF-e)';
  if ARelatorioPisCofinsType = rtCumpomFiscal then
    Exit('(Cupom Fiscal)');
end;
begin
  with TfrmRelatorioPisCofins.Create(nil, AInfoReportBase) do
  try
    FRelatorioPisCofinsType := ARelatorioPisCofinsType;
    Title := Format('Relatório de PIS/COFINS %s', [getTitlePrefix()]);
    Result := (ShowModal = mrOk) and not(Canceled);
  finally
    Free;
  end;
end;


procedure TfrmRelatorioPisCofins.FormCreate(Sender: TObject);
begin
  inherited;
  ListOfPanelsToStyle.AddRange([PanelFilter]);
  CheckListBoxCST.CheckAll(cbChecked);
end;

procedure TfrmRelatorioPisCofins.Print;
begin
  FFilterByCSTPisCofins := '';
  var CountChecked := 0;
  for var i := 0 to CheckListBoxCST.Count - 1 do
  begin
    if not(CheckListBoxCST.Checked[i]) then
      Continue;

    inc(CountChecked);

    if not(FFilterByCSTPisCofins = '') then
      FFilterByCSTPisCofins := FFilterByCSTPisCofins+' or ';

    FFilterByCSTPisCofins := FFilterByCSTPisCofins+' CST_PIS_COFINS = '+
      QuotedStr(Copy(CheckListBoxCST.Items[i], 1, 2));
  end;

  if CountChecked = CheckListBoxCST.Count then
    FFilterByCSTPisCofins := '';

  if not(FFilterByCSTPisCofins = '') then
  begin
    FFilterByCSTPisCofins := ' and ('+FFilterByCSTPisCofins+')';
    FFilterByCSTPisCofins := FFilterByCSTPisCofins+
      ' and CST_PIS_COFINS is not null ';
  end;


  inherited;

  if FRelatorioPisCofinsType = rtNFe then
    RelatorioPisCofinsNfe(
      TextFileBaseReport,
      DateTimePickerStart.Date,
      DateTimePickerEnd.Date
    )
  else
    RelatorioPisCofinsCupom(
      TextFileBaseReport,
      DateTimePickerStart.Date,
      DateTimePickerEnd.Date
    );
end;

procedure TfrmRelatorioPisCofins.RelatorioPisCofinsCupom(var F: TextFile;
  dInicio, dFinal: TdateTime);
var
  fRateioDoDesconto, fTotal1, ftotal2, ftotal3 : Real;
  sCFOP: String;
  bAchouItem: Boolean;
  iItem: Integer;
  aCFOP: array of TCFOP;
  aCSTCSOSN: array of TCSTCSOSN;
  sCSTPISCOFINS: String;
  sCSTCSOSN: String;
  dTotalCFOP: Double;
  dTotalCSTCSOSN: Double;
  dTotalCFOPCSTPISCOFINS: Double;
  dTotalPISCOFINSCSTCSOSN: Double;

  Rateio: TRateioBalcao;
  sCaixa: String;
  sPedido: String;
begin
  fTotal1  := 0;
  fTotal2  := 0;
  fTotal3  := 0;

  if InfoReportBase.Html then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Title+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,' <tr  bgcolor=#'+InfoReportBase.HtmlColor+'   align=left>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>Data</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>Caixa</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>Cupom</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>Código</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>Descrição</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>Total</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>CST</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>% PIS</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>R$ PIS</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>% COFINS</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>R$ COFINS</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>CFOP</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>NCM</font></th>');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>CST ICMS</font></th>')
    else
      WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>CSOSN</font></th>');
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    WriteLn(F,'');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
    begin
      WriteLn(F,'Data       Caixa  Cupom     Código Descrição                              Total          CST  % PIS    R$ PIS         % COFINS R$ COFINS      CFOP NCM       CST ICMS ');
      WriteLn(F,'---------- ------ --------- ------ -------------------------------------- -------------- ---- -------- -------------- -------- -------------- ---- --------- ---------');
    end else
    begin
      WriteLn(F,'Data       Caixa  Cupom     Código Descrição                              Total          CST  % PIS    R$ PIS         % COFINS R$ COFINS      CFOP NCM       CSOSN ');
      WriteLn(F,'---------- ------ --------- ------ -------------------------------------- -------------- ---- -------- -------------- -------- -------------- ---- --------- ------');
    end;
  end;

  Form7.ibQuery99.Close;
  Form7.ibQuery99.SQL.Clear;
  Form7.ibQuery99.SQL.Add(
    'select ALTERACA.*, ESTOQUE.CF NCM '+
    ' from ALTERACA '+
    ' left join ESTOQUE on ESTOQUE.CODIGO=ALTERACA.CODIGO '+
    ' where DATA <= '+QuotedStr(DateToStrInvertida(dFinal))+
    ' and DATA >= ' + QuotedStr(DateToStrInvertida(dInicio))+
    ' and (TIPO = ' + QuotedStr('BALCAO')+
    ' or TIPO = ' + QuotedStr('VENDA')+') '+
    ' and Coalesce(CST_PIS_COFINS,''XX'')<>''XX'' '+
    ' and CST_PIS_COFINS<>'''' '+
    FFilterByCSTPisCofins+
    'order by DATA, PEDIDO'
  );
  Form7.ibQuery99.Open;
  Form7.ibQuery99.DisableControls;

  Rateio := TRateioBalcao.Create;
  Rateio.IBTransaction := Form7.ibQuery99.Transaction;
  sCaixa  := '';
  sPedido := '';
  while (not Form7.ibQuery99.Eof) do
  begin
    if Canceled then
      Break;

    if (Form7.ibQuery99.FieldByName('DESCRICAO').AsString <> 'Desconto') and
      (Form7.ibQuery99.FieldByName('DESCRICAO').AsString <> 'Acréscimo') then
    begin
      Application.ProcessMessages;

      Rateio.CalcularRateio(
        Form7.ibQuery99.FieldByName('CAIXA').AsString,
        Form7.ibQuery99.FieldByName('PEDIDO').AsString,
        Form7.ibQuery99.FieldByName('ITEM').AsString
      );

      sCSTPISCOFINS := Trim(Form7.ibQuery99.FieldByName('CST_PIS_COFINS').AsString);
      if sCSTPISCOFINS = '' then
        sCSTPISCOFINS := ' ';

      sCFOP := Trim(Form7.ibQuery99.FieldByName('CFOP').AsString);
      if sCFOP = '' then
        sCFOP := ' ';

      bAchouItem := False;
      for iItem := 0 to Length(aCFOP) - 1 do
      begin
        if (aCFOP[iItem].CFOP = sCFOP) and (aCFOP[iItem].CSTPISCOFINS = sCSTPISCOFINS) then
        begin
          bAchouItem := True;
          Break;
        end;
      end;

      if bAchouItem = False then
      begin
        SetLength(aCFOP, Length(aCFOP) + 1);
        iItem := High(aCFOP);
        aCFOP[High(aCFOP)] := TCFOP.Create;
        aCFOP[High(aCFOP)].CFOP         := sCFOP;
        aCFOP[High(aCFOP)].CSTPISCOFINS := sCSTPISCOFINS;
      end;

      aCFOP[iItem].Valor     := aCFOP[iItem].Valor + StrToFloatFormat('%10.2n', Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem);
      aCFOP[iItem].Acrescimo := aCFOP[iItem].Acrescimo + Rateio.RateioAcrescimoItem;
      aCFOP[iItem].Desconto  := aCFOP[iItem].Desconto + Rateio.DescontoItem + Rateio.RateioDescontoItem;

      if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
        sCSTCSOSN := Trim(Form7.ibQuery99.FieldByName('CST_ICMS').AsString)
      else
        sCSTCSOSN := Trim(Form7.ibQuery99.FieldByName('CSOSN').AsString);
      if sCSTCSOSN = '' then
        sCSTCSOSN := ' ';

      bAchouItem := False;
      for iItem := 0 to Length(aCSTCSOSN) - 1 do
      begin
        if (aCSTCSOSN[iItem].CSTCSOSN = sCSTCSOSN) and (aCSTCSOSN[iItem].CSTPISCOFINS = sCSTPISCOFINS) then
        begin
          bAchouItem := True;
          Break;
        end;
      end;

      if bAchouItem = False then
      begin
        SetLength(aCSTCSOSN, Length(aCSTCSOSN) + 1);
        iItem := High(aCSTCSOSN);
        aCSTCSOSN[High(aCSTCSOSN)] := TCSTCSOSN.Create;
        aCSTCSOSN[High(aCSTCSOSN)].CSTCSOSN     := sCSTCSOSN;
        aCSTCSOSN[High(aCSTCSOSN)].CSTPISCOFINS := sCSTPISCOFINS;
      end;
      aCSTCSOSN[iItem].Valor     := aCSTCSOSN[iItem].Valor + StrToFloatFormat('%10.2n', Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem);
      aCSTCSOSN[iItem].Acrescimo := aCSTCSOSN[iItem].Acrescimo + Rateio.RateioAcrescimoItem;
      aCSTCSOSN[iItem].Desconto  := aCSTCSOSN[iItem].Desconto + Rateio.DescontoItem + Rateio.RateioDescontoItem;

      if InfoReportBase.Html then
      begin
        WriteLn(F,'   <tr>');
        WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + DateToStr(Form7.ibQuery99.FieldByname('DATA').AsDateTime) + '<br></font></td>');
        WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.ibQuery99.FieldByname('CAIXA').AsString + '<br></font></td>');
        WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.ibQuery99.FieldByname('PEDIDO').AsString + '<br></font></td>');
        WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.ibQuery99.FieldByname('CODIGO').AsString + '<br></font></td>');
        WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.ibQuery99.FieldByname('DESCRICAO').AsString + '<br></font></td>');
        WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%10.2n', [Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem])+'<br></font></td>');
        WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.ibQuery99.FieldByname('CST_PIS_COFINS').AsString + '<br></font></td>');
        WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%8.4n', [Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat]) + '<br></font></td>');
        WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%7.2n', [Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat * (Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem) /100]) + '<br></font></td>');
        WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%8.4n', [Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat]) + '<br></font></td>');
        WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%7.2n', [Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat * (Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem) /100]) + '<br></font></td>');
        WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.ibQuery99.FieldByname('CFOP').AsString + '<br></font></td>');
        WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.ibQuery99.FieldByname('NCM').AsString + '<br></font></td>');
        WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + sCSTCSOSN + '<br></font></td>');
        WriteLn(F,'   </tr>');
      end else
      begin
        Write(F,DateToStr(Form7.ibQuery99.FieldByname('DATA').AsDateTime)+' ');
        Write(F,Copy(Form7.ibQuery99.FieldByname('CAIXA').AsString+Replicate(' ', 6), 1, 6) + ' ');
        Write(F,Copy(Form7.ibQuery99.FieldByname('PEDIDO').AsString+Replicate(' ', 9), 1, 9) + ' ');
        Write(F,Copy(Form7.ibQuery99.FieldByname('CODIGO').AsString+Replicate(' ', 6), 1, 6) + ' ');
        Write(F,Copy(Form7.ibQuery99.FieldByname('DESCRICAO').AsString+Replicate(' ', 38), 1, 38) + ' ');
        Write(F,Format('%14.2n',[(Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem)]) + ' ');
        Write(F,Copy(Form7.ibQuery99.FieldByname('CST_PIS_COFINS').AsString,1,3)+'   ');
        Write(F,Format('%8.4n',[Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat])+' ');
        Write(F,Format('%14.2n', [Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat * (Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem) / 100]) + ' ');
        Write(F,Format('%8.4n',[Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat]) + ' ');
        Write(F,Format('%14.2n', [Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat * (Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem) / 100]) + ' ');
        Write(F,Copy(Form7.ibQuery99.FieldByname('CFOP').AsString+Replicate(' ', 4), 1, 4) + ' ');
        Write(F,Copy(Form7.ibQuery99.FieldByname('NCM').AsString+Replicate(' ', 9), 1, 9) + ' ');
        if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
          WriteLn(F, Copy(sCSTCSOSN + Replicate(' ', 9), 1, 9) + ' ')
        else
          WriteLn(F, Copy(sCSTCSOSN + Replicate(' ', 6), 1, 6) + ' ');
      end;

      fTotal1  := fTotal1 + StrToFloatFormat('%10.2n', (Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat * (Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem) / 100));
      fTotal2  := fTotal2 + StrToFloatFormat('%10.2n', (Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat * (Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem) / 100));
      fTotal3  := Ftotal3 + StrToFloatFormat('%10.2n', (Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem));
    end;

    Form7.ibQuery99.Next;
  end;
  Form7.ibQuery99.EnableControls;

  if InfoReportBase.Html then
  begin
    WriteLn(F,'  <tr bgcolor=#' + InfoReportBase.HtmlColor + '   FF7F00>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal3]) + '<br></font></td>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal1]) + '<br></font></td>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal2]) + '<br></font></td>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'  </tr>');
    WriteLn(F,' </table>');
    WriteLn(F,'<br>');
    WriteLn(F,'<br>');
    WriteLn(F,'<br><font size=4 color=#000000><b>Acumulado por CFOP</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor=#' + InfoReportBase.HtmlColor + ' >');
    WriteLn(F,'     <th><font face="Microsoft Sans Serif" size=1>CFOP</font></th>');
    WriteLn(F,'     <th><font face="Microsoft Sans Serif" size=1>CST PIS/COFINS</font></th>');
    WriteLn(F,'     <th><font face="Microsoft Sans Serif" size=1>Total</font></th>');
    WriteLn(F,'    </tr>');

    dTotalCFOP := 0.00;
    dTotalCFOPCSTPISCOFINS := 0.00;
    sCFOP := '--';

    for iItem := 0 to Length(aCFOP) - 1 do
    begin
      if sCFOP <> aCFOP[iItem].CFOP then
      begin
        if sCFOP <> '--' then
        begin
          WriteLn(F,'  <tr bgcolor=#' + InfoReportBase.HtmlColor + '   FF7F00>');
          WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td valign=top align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [dTotalCFOPCSTPISCOFINS]) + '</font></td>');
          WriteLn(F,'    </tr>');
          dTotalCFOPCSTPISCOFINS := 0.00;
        end;
        sCFOP := aCFOP[iItem].CFOP;
      end;
      dTotalCFOP := dTotalCFOP + aCFOP[iItem].Valor;
      dTotalCFOPCSTPISCOFINS := dTotalCFOPCSTPISCOFINS + aCFOP[iItem].Valor;

      WriteLn(F,'    <tr bgcolor=#'+InfoReportBase.HtmlColor+' >');
      WriteLn(F,'     <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCFOP[iItem].CFOP + '</font></td>');
      WriteLn(F,'     <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCFOP[iItem].CSTPISCOFINS + '</font></td>');
      WriteLn(F,'     <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [aCFOP[iItem].Valor]) + '</font></td>');
      WriteLn(F,'    </tr>');
    end;
    if sCFOP <> '' then
    begin
      WriteLn(F,'  <tr bgcolor=#' + InfoReportBase.HtmlColor + '   FF7F00>');
      WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td valign=top align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [dTotalCFOPCSTPISCOFINS]) + '</font></td>');
      WriteLn(F,'    </tr>');
    end;

    WriteLn(F,'    <tr bgcolor=#' + InfoReportBase.HtmlColor + ' >');
    WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td valign=top align=right><font face="Microsoft Sans Serif" size=1><b>' + Format('%11.2n', [dTotalCFOP]) + '<br></font></td>');
    WriteLn(F,'    </tr>');
    WriteLn(F,'   </table>');
    WriteLn(F,'<br>');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      WriteLn(F,'<br><font size=4 color=#000000><b>Acumulado por CST ICMS</b></font><br></center><br>')
    else
      WriteLn(F,'<br><font size=4 color=#000000><b>Acumulado por CSOSN</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor=#'+InfoReportBase.HtmlColor+' >');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      WriteLn(F,'     <th><font face="Microsoft Sans Serif" size=1>CST ICMS</font></th>')
    else
      WriteLn(F,'     <th><font face="Microsoft Sans Serif" size=1>CSOSN</font></th>');
    WriteLn(F,'     <th><font face="Microsoft Sans Serif" size=1>CST PIS/COFINS</font></th>');
    WriteLn(F,'     <th><font face="Microsoft Sans Serif" size=1>Total</font></th>');
    WriteLn(F,'    </tr>');

    dTotalCSTCSOSN          := 0.00;
    dTotalPISCOFINSCSTCSOSN := 0.00;
    sCSTCSOSN := '--';
    for iItem := 0 to Length(aCSTCSOSN) - 1 do
    begin
      if sCSTCSOSN <> aCSTCSOSN[iItem].CSTCSOSN then
      begin
        if sCSTCSOSN <> '--' then
        begin
          WriteLn(F,'  <tr bgcolor=#' + InfoReportBase.HtmlColor + '   FF7F00>');
          WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td valign=top align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [dTotalPISCOFINSCSTCSOSN]) + '</font></td>');
          WriteLn(F,'    </tr>');
          dTotalPISCOFINSCSTCSOSN := 0.00;
        end;
        sCSTCSOSN := aCSTCSOSN[iItem].CSTCSOSN;
      end;

      dTotalCSTCSOSN := dTotalCSTCSOSN + aCSTCSOSN[iItem].Valor;
      dTotalPISCOFINSCSTCSOSN := dTotalPISCOFINSCSTCSOSN + aCSTCSOSN[iItem].Valor;
      WriteLn(F,'    <tr bgcolor=#' + InfoReportBase.HtmlColor + ' >');
      WriteLn(F,'     <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCSTCSOSN[iItem].CSTCSOSN + '</font></td>');
      WriteLn(F,'     <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCSTCSOSN[iItem].CSTPISCOFINS + '</font></td>');
      WriteLn(F,'     <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n',[aCSTCSOSN[iItem].Valor])+'</font></td>');
      WriteLn(F,'    </tr>');
    end;

    if sCSTCSOSN <> '' then
    begin
      WriteLn(F,'  <tr bgcolor=#' + InfoReportBase.HtmlColor + '   FF7F00>');
      WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td valign=top align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [dTotalPISCOFINSCSTCSOSN]) + '</font></td>');
      WriteLn(F,'    </tr>');
      dTotalPISCOFINSCSTCSOSN := 0.00;
    end;
    WriteLn(F,'    <tr bgcolor=#' + InfoReportBase.HtmlColor + ' >');
    WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1></font></td>');
    WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1></font></td>');
    WriteLn(F,'     <td valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n', [dTotalCSTCSOSN])+'<br></font></td>');
    WriteLn(F,'    </tr>');
    WriteLn(F,'   </table>');

    WriteLn(F,'<br>');
    WriteLn(F,'<br>');

    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>Período analisado, de ' + DateTimeToStr(dInicio) + ' até ' + DateTimeToStr(dFinal) + '<br>');
    WriteLn(F,'</center>');
  end else
  begin
    WriteLn(F,'                                                                              ----------                   ----------              ----------');
    WriteLn(F,'                                                                              ' + Format('%10.2n', [fTotal3]) + '                   ' + Format('%10.2n', [fTotal1]) + '              ' + Format('%10.2n', [fTotal2]));
    WriteLn(F, '');
    WriteLn(F, '');
    WriteLn(F, 'Acumulado por CFOP');
    WriteLn(F, '');
    WriteLn(F, 'CFOP  CST PIS/COFINS Total          ');
    WriteLn(F, '----- -------------- -------------- ');
    dTotalCFOP             := 0.00;
    dTotalCFOPCSTPISCOFINS := 0.00;
    sCFOP := '--';
    for iItem := 0 to Length(aCFOP) - 1 do
    begin
      if sCFOP <> aCFOP[iItem].CFOP then
      begin
        if sCFOP <> '--' then
        begin
          Write(F, Replicate(' ', 5) + ' ');
          Write(F, Replicate(' ', 14) + ' ');
          WriteLn(F, Format('%14.2n', [dTotalCFOPCSTPISCOFINS]));
          dTotalCFOPCSTPISCOFINS := 0.00;
        end;
        sCFOP := aCFOP[iItem].CFOP;
      end;

      dTotalCFOP             := dTotalCFOP + aCFOP[iItem].Valor;
      dTotalCFOPCSTPISCOFINS := dTotalCFOPCSTPISCOFINS + aCFOP[iItem].Valor;
      Write(F, Copy(aCFOP[iItem].CFOP + Replicate(' ', 5), 1, 5) + ' ');
      Write(F, Copy(aCFOP[iItem].CSTPISCOFINS + Replicate(' ', 14), 1, 14) + ' ');
      WriteLn(F, Format('%14.2n', [aCFOP[iItem].Valor]) + ' ');
    end;
    if sCFOP <> '' then
    begin
      Write(F, Replicate(' ', 5) + ' ');
      Write(F, Replicate(' ', 14) + ' ');
      WriteLn(F, Format('%14.2n', [dTotalCFOPCSTPISCOFINS]));
      dTotalCFOPCSTPISCOFINS := 0.00;
    end;
    WriteLn(F, '                     -------------- ');
    WriteLn(F, '                     ' + Format('%14.2n',[dTotalCFOP]) + ' ');
    WriteLn(F, '');
    WriteLn(F, '');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
    begin
      WriteLn(F, 'Acumulado por CST ICMS');
      WriteLn(F, '');
      WriteLn(F, 'CST ICMS CST PIS/COFINS Total          ');
    end
    else
    begin
      WriteLn(F, 'Acumulado por CSOSN');
      WriteLn(F, '');
      WriteLn(F, 'CSOSN    CST PIS/COFINS Total          ');
    end;
    WriteLn(F, '-------- -------------- -------------- ');

    dTotalCSTCSOSN := 0.00;
    dTotalPISCOFINSCSTCSOSN := 0.00;
    sCSTCSOSN := '--';
    for iItem := 0 to Length(aCSTCSOSN) - 1 do
    begin
      if sCSTCSOSN <> aCSTCSOSN[iItem].CSTCSOSN then
      begin
        if sCSTCSOSN <> '--' then
        begin
          Write(F, Replicate(' ', 8) + ' ');
          Write(F, Replicate(' ', 14) + ' ');
          WriteLn(F, Format('%14.2n', [dTotalPISCOFINSCSTCSOSN]));
          dTotalPISCOFINSCSTCSOSN := 0.00;
        end;
        sCSTCSOSN := aCSTCSOSN[iItem].CSTCSOSN;
      end;

      dTotalCSTCSOSN             := dTotalCSTCSOSN + aCSTCSOSN[iItem].Valor;
      dTotalPISCOFINSCSTCSOSN := dTotalPISCOFINSCSTCSOSN + aCSTCSOSN[iItem].Valor;
      Write(F, Copy(aCSTCSOSN[iItem].CSTCSOSN + Replicate(' ', 8), 1, 8) + ' ');
      Write(F, Copy(aCSTCSOSN[iItem].CSTPISCOFINS + Replicate(' ', 14), 1, 14) + ' ');
      WriteLn(F, Format('%14.2n', [aCSTCSOSN[iItem].Valor]) + ' ');
    end;
    if sCSTCSOSN <> '' then
    begin
      Write(F, Replicate(' ', 8) + ' ');
      Write(F, Replicate(' ', 14) + ' ');
      WriteLn(F, Format('%14.2n', [dTotalPISCOFINSCSTCSOSN]));
      dTotalPISCOFINSCSTCSOSN := 0.00;
    end;

    WriteLn(F, '                        -------------- ');
    WriteLn(F, '                        ' + Format('%14.2n', [dTotalCSTCSOSN]) + '');
    WriteLn(F,'');

    WriteLn(F,'');
    Writeln(F,'Período analisado, de ' + DateTimeToStr(dInicio) + ' até ' + DateTimeToStr(dFinal));
  end;
end;

procedure TfrmRelatorioPisCofins.RelatorioPisCofinsNfe(var F: TextFile; dInicio,
  dFinal: TdateTime);
var
  fRateioDoDesconto, fTotal1, ftotal2, ftotal3 : Real;
  sCFOP: String;
  bAchouItem: Boolean;
  iItem: Integer;
  aCFOP: array of TCFOP;
  aCSTCSOSN: array of TCSTCSOSN;
  sCSTPISCOFINS: String;
  sCSTCSOSN: String;
  dTotalCFOP: Double;
  dTotalCSTCSOSN: Double;
  dTotalCFOPCSTPISCOFINS: Double;
  dTotalPISCOFINSCSTCSOSN: Double;

begin
  try
    if AtualizaItens001CsosnFromXML(Form7.ibDataSet16.Transaction, dInicio, dFinal) then
    begin
      AgendaCommit(True);
    end;
  except
  end;

  fTotal1  := 0;
  fTotal2  := 0;
  fTotal3  := 0;

  if InfoReportBase.Html then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Title+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,' <tr  bgcolor=#'+InfoReportBase.HtmlColor+'   align=left>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>Data</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>NF</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>Código</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>Descrição</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>Total</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>CST</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>% PIS</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>R$ PIS</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>% COFINS</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>R$ COFINS</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>CFOP</font></th>');
    WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>NCM</font></th>');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>CST ICMS</font></th>')
    else
      WriteLn(F,'  <th><font face="Microsoft Sans Serif" size=1>CSOSN</font></th>');
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    WriteLn(F,'');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
    begin
      WriteLn(F,'Data       NF        Código Descrição                              Total          CST  % PIS    R$ PIS         % COFINS R$ COFINS      CFOP NCM       CST ICMS ');
      WriteLn(F,'---------- --------- ------ -------------------------------------- -------------- ---- -------- -------------- -------- -------------- ---- --------- ---------');
    end else
    begin
      WriteLn(F,'Data       NF        Código Descrição                              Total          CST  % PIS    R$ PIS         % COFINS R$ COFINS      CFOP NCM       CSOSN ');
      WriteLn(F,'---------- --------- ------ -------------------------------------- -------------- ---- -------- -------------- -------- -------------- ---- --------- ------');
    end;
  end;

  Form7.ibQuery99.Close;
  Form7.ibQuery99.SQL.Clear;
  Form7.ibQuery99.SQL.Add(
    'select ITENS001.*, VENDAS.*, ESTOQUE.CF NCM '+
    ' from ITENS001 '+
    ' inner join VENDAS on VENDAS.NUMERONF=ITENS001.NUMERONF '+
    ' left join ESTOQUE on ESTOQUE.CODIGO=ITENS001.CODIGO '+
    ' where VENDAS.EMITIDA=''S'' '+
    ' and VENDAS.EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+
    ' and VENDAS.EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+
    ' and Coalesce(CST_PIS_COFINS,''XX'')<>''XX'' '+
    FFilterByCSTPisCofins+
    ' order by VENDAS.EMISSAO, VENDAS.NUMERONF');
  Form7.ibQuery99.Open;

  while (not Form7.ibQuery99.Eof) do
  begin
    if Canceled then
      Break;

    Application.ProcessMessages;

    try
      if Form7.ibQuery99.FieldByname('DESCONTO').AsFloat <> 0 then
        fRateioDoDesconto := Arredonda((Form7.ibQuery99.FieldByname('DESCONTO').AsFloat / Form7.ibQuery99.FieldByname('MERCADORIA').AsFloat * Form7.ibQuery99.FieldByname('TOTAL').AsFloat),2)
      else
        fRateioDoDesconto := 0;
    except
      fRateioDoDesconto := 0;
    end;

    sCSTPISCOFINS := Trim(Form7.ibQuery99.FieldByName('CST_PIS_COFINS').AsString);
    if sCSTPISCOFINS = '' then
      sCSTPISCOFINS := ' ';

    sCFOP := Trim(Form7.ibQuery99.FieldByName('CFOP').AsString);
    if sCFOP = '' then
      sCFOP := ' ';

    bAchouItem := False;
    for iItem := 0 to Length(aCFOP) - 1 do
    begin
      if (aCFOP[iItem].CFOP = sCFOP) and (aCFOP[iItem].CSTPISCOFINS = sCSTPISCOFINS) then
      begin
        bAchouItem := True;
        Break;
      end;
    end;

    if bAchouItem = False then
    begin
      SetLength(aCFOP, Length(aCFOP) + 1);
      iItem := High(aCFOP);
      aCFOP[High(aCFOP)] := TCFOP.Create;
      aCFOP[High(aCFOP)].CFOP         := sCFOP;
      aCFOP[High(aCFOP)].CSTPISCOFINS := sCSTPISCOFINS;
    end;

    aCFOP[iItem].Valor     := aCFOP[iItem].Valor + StrToFloatFormat('%10.2n', (Form7.ibQuery99.FieldByName('TOTAL').AsFloat - fRateioDoDesconto));
    aCFOP[iItem].Desconto  := aCFOP[iItem].Desconto - fRateioDoDesconto;

    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      sCSTCSOSN := Trim(Form7.ibQuery99.FieldByName('CST_ICMS').AsString)
    else
      sCSTCSOSN := Trim(Form7.ibQuery99.FieldByName('CSOSN').AsString);

    if sCSTCSOSN = '' then
      sCSTCSOSN := ' ';

    bAchouItem := False;
    for iItem := 0 to Length(aCSTCSOSN) - 1 do
    begin
      if (aCSTCSOSN[iItem].CSTCSOSN = sCSTCSOSN) and (aCSTCSOSN[iItem].CSTPISCOFINS = sCSTPISCOFINS) then
      begin
        bAchouItem := True;
        Break;
      end;
    end;

    if bAchouItem = False then
    begin
      SetLength(aCSTCSOSN, Length(aCSTCSOSN) + 1);
      iItem := High(aCSTCSOSN);
      aCSTCSOSN[High(aCSTCSOSN)] := TCSTCSOSN.Create;
      aCSTCSOSN[High(aCSTCSOSN)].CSTCSOSN     := sCSTCSOSN;
      aCSTCSOSN[High(aCSTCSOSN)].CSTPISCOFINS := sCSTPISCOFINS;
    end;
    aCSTCSOSN[iItem].Valor     := aCSTCSOSN[iItem].Valor + StrToFloatFormat('%10.2n', (Form7.ibQuery99.FieldByName('TOTAL').AsFloat - fRateioDoDesconto));
    aCSTCSOSN[iItem].Desconto  := aCSTCSOSN[iItem].Desconto - fRateioDoDesconto;

    if InfoReportBase.Html then
    begin
      WriteLn(F,'   <tr>');
      WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+DateToStr(Form7.ibQuery99.FieldByname('EMISSAO').AsDateTime)+'<br></font></td>');
      WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibQuery99.FieldByname('NUMERONF').AsString,1,9)+'<br></font></td>');
      WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibQuery99.FieldByname('CODIGO').AsString+'<br></font></td>');
      WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibQuery99.FieldByname('DESCRICAO').AsString+'<br></font></td>');
      WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.2n',[Form7.ibQuery99.FieldByname('TOTAL').AsFloat - fRateioDoDesconto])+'<br></font></td>');
      WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibQuery99.FieldByname('CST_PIS_COFINS').AsString+'<br></font></td>');
      WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%8.4n',[Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat])+'<br></font></td>');
      WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.2n',[Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat * (Form7.ibQuery99.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) /100])+'<br></font></td>');
      WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%8.4n',[Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat])+'<br></font></td>');
      WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.2n',[Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat * (Form7.ibQuery99.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) /100])+'<br></font></td>');
      WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.ibQuery99.FieldByname('CFOP').AsString + '<br></font></td>');
      WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.ibQuery99.FieldByname('NCM').AsString + '<br></font></td>');
      WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + sCSTCSOSN + '<br></font></td>');
      WriteLn(F,'   </tr>');
    end else
    begin
      Write(F,DateToStr(Form7.ibQuery99.FieldByname('EMISSAO').AsDateTime)+' ');
      Write(F,Copy(Form7.ibQuery99.FieldByname('NUMERONF').AsString+Replicate(' ',9) ,1,9) + ' ');
      Write(F,Copy(Form7.ibQuery99.FieldByname('CODIGO').AsString+Replicate(' ', 6), 1, 6) + ' ');
      Write(F,Copy(Form7.ibQuery99.FieldByname('DESCRICAO').AsString+Replicate(' ',38),1,38) + ' ');
      Write(F,Format('%14.2n',[(Form7.ibQuery99.FieldByname('TOTAL').AsFloat - fRateioDoDesconto)]) + ' ');
      Write(F,Copy(Form7.ibQuery99.FieldByname('CST_PIS_COFINS').AsString,1,3)+'   ');
      Write(F,Format('%8.4n',[Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat])+' ');
      Write(F,Format('%14.2n',[Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat * (Form7.ibQuery99.FieldByname('TOTAL').AsFloat - fRateioDoDesconto) / 100]) + ' ');
      Write(F,Format('%8.4n',[Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat]) + ' ');
      Write(F,Format('%14.2n',[Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat * (Form7.ibQuery99.FieldByname('TOTAL').AsFloat - fRateioDoDesconto) / 100]) + ' ');
      Write(F,Copy(Form7.ibQuery99.FieldByname('CFOP').AsString+Replicate(' ', 4), 1, 4) + ' ');
      Write(F,Copy(Form7.ibQuery99.FieldByname('NCM').AsString+Replicate(' ', 9), 1, 9) + ' ');
      if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
        WriteLn(F, Copy(sCSTCSOSN + Replicate(' ', 9), 1, 9) + ' ')
      else
        WriteLn(F, Copy(sCSTCSOSN + Replicate(' ', 6), 1, 6) + ' ');
    end;

    fTotal1  := fTotal1 + StrToFloatFormat('%10.2n', (Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat * (Form7.ibQuery99.FieldByname('TOTAL').AsFloat - fRateioDoDesconto) / 100));
    fTotal2  := fTotal2 + StrToFloatFormat('%10.2n', (Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat * (Form7.ibQuery99.FieldByname('TOTAL').AsFloat - fRateioDoDesconto) / 100));
    fTotal3  := Ftotal3 + StrToFloatFormat('%10.2n', (Form7.ibQuery99.FieldByname('TOTAL').AsFloat - fRateioDoDesconto));

    Form7.ibQuery99.Next;
  end;

  if InfoReportBase.Html then
  begin
    WriteLn(F,'  <tr bgcolor=#'+InfoReportBase.HtmlColor+'   FF7F00>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal3])+'<br></font></td>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal1])+'<br></font></td>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal2])+'<br></font></td>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'  </tr>');
    WriteLn(F,' </table>');
    WriteLn(F,'<br>');
    WriteLn(F,'<br>');
    WriteLn(F,'<br><font size=4 color=#000000><b>Acumulado por CFOP</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor=#' + InfoReportBase.HtmlColor + ' >');
    WriteLn(F,'     <th><font face="Microsoft Sans Serif" size=1>CFOP</font></th>');
    WriteLn(F,'     <th><font face="Microsoft Sans Serif" size=1>CST PIS/COFINS</font></th>');
    WriteLn(F,'     <th><font face="Microsoft Sans Serif" size=1>Total</font></th>');
    WriteLn(F,'    </tr>');

    dTotalCFOP := 0.00;
    dTotalCFOPCSTPISCOFINS := 0.00;
    sCFOP := '--';

    for iItem := 0 to Length(aCFOP) - 1 do
    begin
      if sCFOP <> aCFOP[iItem].CFOP then
      begin
        if sCFOP <> '--' then
        begin
          WriteLn(F,'  <tr bgcolor=#' + InfoReportBase.HtmlColor + '   FF7F00>');
          WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td valign=top align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [dTotalCFOPCSTPISCOFINS]) + '</font></td>');
          WriteLn(F,'    </tr>');
          dTotalCFOPCSTPISCOFINS := 0.00;
        end;
        sCFOP := aCFOP[iItem].CFOP;
      end;
      dTotalCFOP := dTotalCFOP + aCFOP[iItem].Valor;
      dTotalCFOPCSTPISCOFINS := dTotalCFOPCSTPISCOFINS + aCFOP[iItem].Valor;

      WriteLn(F,'    <tr bgcolor=#'+InfoReportBase.HtmlColor+' >');
      WriteLn(F,'     <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCFOP[iItem].CFOP + '</font></td>');
      WriteLn(F,'     <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCFOP[iItem].CSTPISCOFINS + '</font></td>');
      WriteLn(F,'     <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [aCFOP[iItem].Valor]) + '</font></td>');
      WriteLn(F,'    </tr>');
    end;
    if sCFOP <> '' then
    begin
      WriteLn(F,'  <tr bgcolor=#' + InfoReportBase.HtmlColor + '   FF7F00>');
      WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td valign=top align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [dTotalCFOPCSTPISCOFINS]) + '</font></td>');
      WriteLn(F,'    </tr>');
    end;

    WriteLn(F,'    <tr bgcolor=#' + InfoReportBase.HtmlColor + ' >');
    WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td valign=top align=right><font face="Microsoft Sans Serif" size=1><b>' + Format('%11.2n', [dTotalCFOP]) + '<br></font></td>');
    WriteLn(F,'    </tr>');
    WriteLn(F,'   </table>');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      WriteLn(F,'<br><font size=4 color=#000000><b>Acumulado por CST ICMS</b></font><br></center><br>')
    else
      WriteLn(F,'<br><font size=4 color=#000000><b>Acumulado por CSOSN</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor=#'+InfoReportBase.HtmlColor+' >');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      WriteLn(F,'     <th><font face="Microsoft Sans Serif" size=1>CST ICMS</font></th>')
    else
      WriteLn(F,'     <th><font face="Microsoft Sans Serif" size=1>CSOSN</font></th>');
    WriteLn(F,'     <th><font face="Microsoft Sans Serif" size=1>CST PIS/COFINS</font></th>');
    WriteLn(F,'     <th><font face="Microsoft Sans Serif" size=1>Total</font></th>');
    WriteLn(F,'    </tr>');

    dTotalCSTCSOSN          := 0.00;
    dTotalPISCOFINSCSTCSOSN := 0.00;
    sCSTCSOSN := '--';
    for iItem := 0 to Length(aCSTCSOSN) - 1 do
    begin
      if sCSTCSOSN <> aCSTCSOSN[iItem].CSTCSOSN then
      begin
        if sCSTCSOSN <> '--' then
        begin
          WriteLn(F,'  <tr bgcolor=#' + InfoReportBase.HtmlColor + '   FF7F00>');
          WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td valign=top align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [dTotalPISCOFINSCSTCSOSN]) + '</font></td>');
          WriteLn(F,'    </tr>');
          dTotalPISCOFINSCSTCSOSN := 0.00;
        end;
        sCSTCSOSN := aCSTCSOSN[iItem].CSTCSOSN;
      end;

      dTotalCSTCSOSN := dTotalCSTCSOSN + aCSTCSOSN[iItem].Valor;
      dTotalPISCOFINSCSTCSOSN := dTotalPISCOFINSCSTCSOSN + aCSTCSOSN[iItem].Valor;
      WriteLn(F,'    <tr bgcolor=#' + InfoReportBase.HtmlColor + ' >');
      WriteLn(F,'     <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCSTCSOSN[iItem].CSTCSOSN + '</font></td>');
      WriteLn(F,'     <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCSTCSOSN[iItem].CSTPISCOFINS + '</font></td>');
      WriteLn(F,'     <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n',[aCSTCSOSN[iItem].Valor])+'</font></td>');
      WriteLn(F,'    </tr>');
    end;

    if sCSTCSOSN <> '' then
    begin
      WriteLn(F,'  <tr bgcolor=#' + InfoReportBase.HtmlColor + '   FF7F00>');
      WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td valign=top align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [dTotalPISCOFINSCSTCSOSN]) + '</font></td>');
      WriteLn(F,'    </tr>');
    end;

    WriteLn(F,'    <tr bgcolor=#' + InfoReportBase.HtmlColor + ' >');
    WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1></font></td>');
    WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1></font></td>');
    WriteLn(F,'     <td valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n', [dTotalCSTCSOSN])+'<br></font></td>');
    WriteLn(F,'    </tr>');
    WriteLn(F,'   </table>');
    WriteLn(F,'<br>');
    WriteLn(F,'<br>');
    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>Período analisado, de ' + DateTimeToStr(dInicio) + ' até ' + DateTimeToStr(dFinal)+'<br>');
    WriteLn(F,'</center>');
  end else
  begin
    WriteLn(F,'                                                                       ----------                   ----------              ----------');
    WriteLn(F,'                                                                       ' + Format('%10.2n', [fTotal3]) + '                   ' + Format('%10.2n', [fTotal1]) + '              ' + Format('%10.2n', [fTotal2]));
    WriteLn(F,'');
    WriteLn(F, '');
    WriteLn(F, '');
    WriteLn(F, 'Acumulado por CFOP');
    WriteLn(F, '');
    WriteLn(F, 'CFOP  CST PIS/COFINS Total          ');
    WriteLn(F, '----- -------------- -------------- ');
    dTotalCFOP             := 0.00;
    dTotalCFOPCSTPISCOFINS := 0.00;
    sCFOP := '--';
    for iItem := 0 to Length(aCFOP) - 1 do
    begin
      if sCFOP <> aCFOP[iItem].CFOP then
      begin
        if sCFOP <> '--' then
        begin
          Write(F, Replicate(' ', 5) + ' ');
          Write(F, Replicate(' ', 14) + ' ');
          WriteLn(F, Format('%14.2n', [dTotalCFOPCSTPISCOFINS]));
          dTotalCFOPCSTPISCOFINS := 0.00;
        end;
        sCFOP := aCFOP[iItem].CFOP;
      end;

      dTotalCFOP             := dTotalCFOP + aCFOP[iItem].Valor;
      dTotalCFOPCSTPISCOFINS := dTotalCFOPCSTPISCOFINS + aCFOP[iItem].Valor;
      Write(F, Copy(aCFOP[iItem].CFOP + Replicate(' ', 5), 1, 5) + ' ');
      Write(F, Copy(aCFOP[iItem].CSTPISCOFINS + Replicate(' ', 14), 1, 14) + ' ');
      WriteLn(F, Format('%14.2n', [aCFOP[iItem].Valor]) + ' ');
    end;

    if sCFOP <> '' then
    begin
      Write(F, Replicate(' ', 5) + ' ');
      Write(F, Replicate(' ', 14) + ' ');
      WriteLn(F, Format('%14.2n', [dTotalCFOPCSTPISCOFINS]));
      dTotalCFOPCSTPISCOFINS := 0.00;
    end;

    WriteLn(F, '                     -------------- ');
    WriteLn(F, '                     ' + Format('%14.2n',[dTotalCFOP]) + ' ');
    WriteLn(F, '');
    WriteLn(F, '');

    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
    begin
      WriteLn(F, 'Acumulado por CST ICMS');
      WriteLn(F, '');
      WriteLn(F, 'CST ICMS CST PIS/COFINS Total          ');
    end else
    begin
      WriteLn(F, 'Acumulado por CSOSN');
      WriteLn(F, '');
      WriteLn(F, 'CSOSN    CST PIS/COFINS Total          ');
    end;
      WriteLn(F, '-------- -------------- -------------- ');

    dTotalCSTCSOSN := 0.00;
    dTotalPISCOFINSCSTCSOSN := 0.00;
    sCSTCSOSN := '--';

    for iItem := 0 to Length(aCSTCSOSN) - 1 do
    begin
      if sCSTCSOSN <> aCSTCSOSN[iItem].CSTCSOSN then
      begin
        if sCSTCSOSN <> '--' then
        begin
          Write(F, Replicate(' ', 8) + ' ');
          Write(F, Replicate(' ', 14) + ' ');
          WriteLn(F, Format('%14.2n', [dTotalPISCOFINSCSTCSOSN]));
          dTotalPISCOFINSCSTCSOSN := 0.00;
        end;
        sCSTCSOSN := aCSTCSOSN[iItem].CSTCSOSN;
      end;

      dTotalCSTCSOSN             := dTotalCSTCSOSN + aCSTCSOSN[iItem].Valor;
      dTotalPISCOFINSCSTCSOSN := dTotalPISCOFINSCSTCSOSN + aCSTCSOSN[iItem].Valor;
      Write(F, Copy(aCSTCSOSN[iItem].CSTCSOSN + Replicate(' ', 8), 1, 8) + ' ');
      Write(F, Copy(aCSTCSOSN[iItem].CSTPISCOFINS + Replicate(' ', 14), 1, 14) + ' ');
      WriteLn(F, Format('%14.2n', [aCSTCSOSN[iItem].Valor]) + ' ');
    end;

    if sCSTCSOSN <> '' then
    begin
      Write(F, Replicate(' ', 8) + ' ');
      Write(F, Replicate(' ', 14) + ' ');
      WriteLn(F, Format('%14.2n', [dTotalPISCOFINSCSTCSOSN]));
      dTotalPISCOFINSCSTCSOSN := 0.00;
    end;

    WriteLn(F, '                        -------------- ');
    WriteLn(F, '                        ' + Format('%14.2n', [dTotalCSTCSOSN]) + '');
    WriteLn(F,'');

    Writeln(F,'Período analisado, de ' + DateTimeToStr(dInicio) + ' até ' + DateTimeToStr(dFinal));
  end;

end;

procedure TfrmRelatorioPisCofins.SpeedButtonCheckAllClick(Sender: TObject);
begin
  inherited;
  CheckListBoxCST.CheckAll(cbChecked);
end;

procedure TfrmRelatorioPisCofins.SpeedButtonUncheckAllClick(Sender: TObject);
begin
  inherited;
  CheckListBoxCST.CheckAll(cbUnchecked);
end;

function TfrmRelatorioPisCofins.Validate(var AMsg: string): Boolean;
begin
  Result := False;

  for var i := 0 to CheckListBoxCST.Count - 1 do
    if CheckListBoxCST.Checked[i] then
      Exit(True);

  AMsg := 'Por favor, selecione pelo menos um item na lista de CST.';
end;

end.
