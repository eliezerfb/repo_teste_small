unit uEstruturaTipoRelatorioPadrao;

interface

uses
  uIEstruturaTipoRelatorioPadrao, uSmallEnumerados, uArquivosDAT,
  Classes, Dialogs, DB, Windows, uIEstruturaRelatorioPadrao, IBQuery,
  SysUtils, DateUtils, Forms, Controls, IBDatabase
  , uConverteHtmlToPDF
  ;

type
  TEstruturaTipoRelatorioPadrao = class(TInterfacedObject, IEstruturaTipoRelatorioPadrao)
  private
    FoDataBase: TIBDatabase;
    FoArquivoDAT: TArquivosDAT;
    FoEstruturaRel: IEstruturaRelatorioPadrao;
    FcTitulo: String;
    FDataSetDados: TDataSet;
    FlsImpressao: TStringList;
    FcNomeArquivo: String;
    FdInicio: TDateTime;
    constructor Create;
    procedure ImprimirHTML(AbImprimir: Boolean = True);
    procedure ImprimirTXT(AbImprimir: Boolean = True);
    procedure ImprimirPDF(AbImprimir: Boolean = True);
    function RetornarLinhaTextoColunasTXT: String;
    function RetornarTamanhoField(AoField: TField): Integer;
    function TestarFieldValor(AoField: TField): Boolean;
    function RetornarTextoValorQuery(AoField: TField; AbSemBrancos: Boolean = False): String;
    function SomarValor(AoField: TField): Currency;
    function FormataCulunaValor(AnValor: Currency; AnCasasDecimais: Integer = 2): String;
    procedure MontaDadosTXT;
    procedure MontarDados;
    procedure MontaDadosHTML;
    procedure SalvarArquivoHTML;
    procedure DefineFinalArquivo;
    procedure DefineInicialHTML;
    procedure MontarCabecalhoHTML;
    procedure MontarCabecalho;
    procedure MontarCabecalhoTXT;
  public
    destructor Destroy; override;
    class function New: IEstruturaTipoRelatorioPadrao;
    function setUsuario(AcUsuario: String): IEstruturaTipoRelatorioPadrao;
    function GerarImpressao(AoEstruturaRel: IEstruturaRelatorioPadrao): IEstruturaTipoRelatorioPadrao;
    function GerarImpressaoAgrupado(AoEstruturaRel: IEstruturaRelatorioPadrao; AcTitulo: String): IEstruturaTipoRelatorioPadrao;
    function GerarImpressaoCabecalho(AoEstruturaRel: IEstruturaRelatorioPadrao): IEstruturaTipoRelatorioPadrao;
    function Imprimir: IEstruturaTipoRelatorioPadrao;
    function Salvar: IEstruturaTipoRelatorioPadrao;
  end;

implementation

uses SmallFunc, uAssinaturaDigital, ShellApi, Math, uDadosEmitente,
  uIDadosEmitente, uSmallResourceString, uLayoutHTMLRelatorio;

const
  _nTamanhoEntreColuna = 2;

{ TEstruturaTipoRelatorioPadrao }

function TEstruturaTipoRelatorioPadrao.Imprimir: IEstruturaTipoRelatorioPadrao;
begin
  if Trim(FlsImpressao.Text) = EmptyStr then
  begin
    ShowMessage(_cSemDadosParaImprimir);
    Exit;
  end;

  DefineFinalArquivo;

  case FoArquivoDAT.Usuario.Html.TipoRelatorio of
    ttiHTML: ImprimirHTML;
    ttiTXT: ImprimirTXT;
    ttiPDF: ImprimirPDF;
  end;
end;

function TEstruturaTipoRelatorioPadrao.Salvar: IEstruturaTipoRelatorioPadrao;
begin
  if Trim(FlsImpressao.Text) = EmptyStr then
  begin
    ShowMessage(_cSemDadosParaImprimir);
    Exit;
  end;

  DefineFinalArquivo;

  case FoArquivoDAT.Usuario.Html.TipoRelatorio of
    ttiHTML: ImprimirHTML(False);
    ttiTXT: ImprimirTXT(False);
    ttiPDF: ImprimirPDF(False);
  end;
end;

procedure TEstruturaTipoRelatorioPadrao.SalvarArquivoHTML;
begin
  if FileExists(FcNomeArquivo+'.HTM') then
    DeleteFile(FcNomeArquivo+'.HTM');

  FlsImpressao.SaveToFile(FcNomeArquivo + '.HTM');
end;

procedure TEstruturaTipoRelatorioPadrao.ImprimirHTML(AbImprimir: Boolean = True);
begin
  SalvarArquivoHTML;

  if AbImprimir then
    ShellExecute( 0, 'Open',pChar(FcNomeArquivo+'.HTM'),'', '', SW_SHOWMAXIMIZED);
end;

procedure TEstruturaTipoRelatorioPadrao.ImprimirTXT(AbImprimir: Boolean = True);
begin
  FlsImpressao.Add(EmptyStr);
  Sleep(100);
  FlsImpressao.Text := TAssinaturaDigital.New
                                    .AssinarTexto(FlsImpressao.Text);
  Sleep(100);
  FlsImpressao.SaveToFile(FcNomeArquivo + '.txt');

  if AbImprimir then
    ShellExecute(0, 'Open',pChar(FcNomeArquivo+'.txt'),'', '', SW_SHOW);
end;

procedure TEstruturaTipoRelatorioPadrao.ImprimirPDF(AbImprimir: Boolean = True);
begin
  if FileExists(FcNomeArquivo+'.pdf') then
    DeleteFile(FcNomeArquivo+'.pdf');

  SalvarArquivoHTML;

  Screen.Cursor            := crHourGlass;
  HtmlToPDF(FcNomeArquivo);
  if AbImprimir then
    ShellExecute( 0, 'Open',pChar(FcNomeArquivo+'.pdf'),'', '', SW_SHOWMAXIMIZED);
  Screen.Cursor            := crDefault;
end;

procedure TEstruturaTipoRelatorioPadrao.MontarCabecalho;
begin
  case FoArquivoDAT.Usuario.Html.TipoRelatorio of
    ttiHTML, ttiPDF: MontarCabecalhoHTML;
    ttiTXT: MontarCabecalhoTXT;
  end;
end;

procedure TEstruturaTipoRelatorioPadrao.MontarCabecalhoHTML;
begin
  if Trim(FlsImpressao.Text) = EmptyStr then
    DefineInicialHTML
  else
    FlsImpressao.Add('<br>');

  FlsImpressao.Add('<br><font size=4 color=#000000><b>' + FcTitulo + '</b></font><br></center><br>');
  FlsImpressao.Add('<center>');
  FlsImpressao.Add('<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
  FlsImpressao.Add(' <tr>');
end;

procedure TEstruturaTipoRelatorioPadrao.MontaDadosHTML;
var
  i: Integer;
  bTemColunaValor: Boolean;
  cAux: String;
  cTotal: String;
  cCamposNaoTot: String;
begin
  bTemColunaValor := False;

  FoEstruturaRel.getColunasNaoTotalizar(cCamposNaoTot);
  MontarCabecalhoHTML;

  //Colunas
  for i := 0 to Pred(FDataSetDados.Fields.Count) do
  begin
    if FDataSetDados.Fields[i].Visible then
    begin
      if FDataSetDados.Fields[i].DisplayLabel <> EmptyStr then
        FlsImpressao.Add('  <td bgcolor=#EBEBEB><font face="Microsoft Sans Serif" size=1><b>' + FDataSetDados.Fields[i].DisplayLabel + '</td>')
      else
        FlsImpressao.Add('  <td bgcolor=#EBEBEB><font face="Microsoft Sans Serif" size=1><b>' + FDataSetDados.Fields[i].FieldName + '</td>');
    end;
  end;
  FlsImpressao.Add(' </tr>');
  while not FDataSetDados.Eof do
  begin
    FlsImpressao.Add('   <tr>');
    cAux := EmptyStr;
    for i := 0 to Pred(FDataSetDados.Fields.Count) do
    begin
      if not FDataSetDados.Fields[i].Visible then
        Continue;

      if TestarFieldValor(FDataSetDados.Fields[i]) then
      begin
        cAux := 'align=Right ';
        bTemColunaValor := True;
      end
      else
      begin
        if FDataSetDados.Fields[i].DataType = ftInteger then
          cAux := 'align=Center ';
      end;

      FlsImpressao.Add('    <td ' + cAux + 'bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>' + RetornarTextoValorQuery(FDataSetDados.Fields[i], True) + '</td>');
    end;
    FlsImpressao.Add('   </tr>');
    FDataSetDados.Next;
  end;

  if (bTemColunaValor) or (FDataSetDados.IsEmpty) then
  begin
    FlsImpressao.Add('   <tr bgcolor=#EBEBEB >');
    for i := 0 to Pred(FDataSetDados.Fields.Count) do
    begin
      if not FDataSetDados.Fields[i].Visible then
        Continue;    
      if (TestarFieldValor(FDataSetDados.Fields[i])) and (Pos(';' + FDataSetDados.Fields[i].FieldName + ';',cCamposNaoTot) <= 0) then
      begin
        if FDataSetDados.Fields[i].DataType in [ftBCD, ftFMTBcd] then
        begin
          if FDataSetDados.Fields[i].DataType = ftBCD then
            cTotal := FormataCulunaValor(SomarValor(FDataSetDados.Fields[i]), (FDataSetDados.Fields[i] as TBCDField).Size);
          if FDataSetDados.Fields[i].DataType = ftFMTBcd then
            cTotal := FormataCulunaValor(SomarValor(FDataSetDados.Fields[i]), (FDataSetDados.Fields[i] as TFMTBCDField).Size);
        end
        else
          cTotal := FormataCulunaValor(SomarValor(FDataSetDados.Fields[i]), 2);
          
        FlsImpressao.Add('    <td nowrap valign=top align=right><font face="Microsoft Sans Serif" size=1><b>' + cTotal);
      end
      else
        FlsImpressao.Add('    <td nowrap valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font>');

      FlsImpressao.Add('    </td>');
    end;
    FlsImpressao.Add('   </tr>');    
  end;

  FlsImpressao.Add('</table>');

  if Assigned(FoEstruturaRel.FiltrosRodape) then
  begin
    if FoEstruturaRel.FiltrosRodape.getItens.Count > 0 then
    begin
      FlsImpressao.Add('   <table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
      FlsImpressao.Add('    <tr bgcolor=#FFFFFF align=left>');
      FlsImpressao.Add('     <td><P><font face="Microsoft Sans Serif" size=1><b>'+FoEstruturaRel.FiltrosRodape.getTitulo+'</b><br>');


      for I := 0 to Pred(FoEstruturaRel.FiltrosRodape.getItens.Count) do
        FlsImpressao.Add('     <br><font face="Microsoft Sans Serif" size=1>'+AllTrim(FoEstruturaRel.FiltrosRodape.getItens[I]));

      FlsImpressao.Add('');
      FlsImpressao.Add('      </td><br>');
      FlsImpressao.Add('     </td>');
      FlsImpressao.Add('    </table>');
    end;
    if (FoEstruturaRel.FiltrosRodape.getFiltroData <> EmptyStr) then
      FlsImpressao.Add('<br><font face="Microsoft Sans Serif" size=1>'+FoEstruturaRel.FiltrosRodape.getFiltroData+'</font>');
  end;
end;

procedure TEstruturaTipoRelatorioPadrao.MontarCabecalhoTXT;
begin
  if FlsImpressao.Text = EmptyStr then
    FlsImpressao.Add(TDadosEmitente.New
                                   .setDataBase(FoDataBase)
                                   .getQuery.FieldByName('NOME').AsString
                    );

  if FlsImpressao.Text <> EmptyStr then
    FlsImpressao.Add(EmptyStr);

  FlsImpressao.Add(FcTitulo);
  FlsImpressao.Add(EmptyStr);
end;

procedure TEstruturaTipoRelatorioPadrao.MontaDadosTXT;
var
  i: Integer;
  cLinha, cLinhaTotal: string;
  cLinhaTemp: String;
  cTotal: String;
  cTexto: String;
  cCamposNaoTot: String;
begin
  if FcNomeArquivo = EmptyStr then
    FcNomeArquivo := Copy(FcTitulo,1,5);

  if FileExists(FcNomeArquivo+'.txt') then
    DeleteFile(FcNomeArquivo+'.txt');

  FoEstruturaRel.getColunasNaoTotalizar(cCamposNaoTot);

  for i := 0 to Pred(FDataSetDados.Fields.Count) do
  begin
    if not FDataSetDados.Fields[i].Visible then
      Continue;
    cLinha := cLinha + Replicate('-', RetornarTamanhoField(FDataSetDados.Fields[i]));
    if TestarFieldValor(FDataSetDados.Fields[i]) and (Pos(';' + FDataSetDados.Fields[i].FieldName + ';',cCamposNaoTot) <= 0) then
      cLinhaTotal := cLinhaTotal + Replicate('-', RetornarTamanhoField(FDataSetDados.Fields[i]))
    else
      cLinhaTotal := cLinhaTotal + Replicate(' ', RetornarTamanhoField(FDataSetDados.Fields[i]));

    if i < Pred(FDataSetDados.Fields.Count) then
    begin
      cLinha := cLinha + Replicate(' ', _nTamanhoEntreColuna);
      cLinhaTotal := cLinhaTotal + Replicate(' ', _nTamanhoEntreColuna);
    end;
  end;

  MontarCabecalhoTXT;

  FlsImpressao.Add(RetornarLinhaTextoColunasTXT);
  FlsImpressao.Add(cLinha);

  while not FDataSetDados.Eof do
  begin
    cLinhaTemp := EmptyStr;
    for i := 0 to Pred(FDataSetDados.Fields.Count) do
    begin
      if not FDataSetDados.Fields[i].Visible then
        Continue;

      cTexto := RetornarTextoValorQuery(FDataSetDados.Fields[i]);
      cLinhaTemp := cLinhaTemp + cTexto
                    + Replicate(' ', (RetornarTamanhoField(FDataSetDados.Fields[i]) - Length(cTexto)));
      if i < Pred(FDataSetDados.Fields.Count) then
        cLinhaTemp := cLinhaTemp + Replicate(' ', _nTamanhoEntreColuna);
    end;

    FlsImpressao.Add(cLinhaTemp);

    FDataSetDados.Next;
  end;

  // Linha para totalizar colunas de valor
  if Trim(cLinhaTotal) <> EmptyStr then
  begin
    FlsImpressao.Add(cLinhaTotal);
    cLinhaTotal := EmptyStr;
    for i := 0 to Pred(FDataSetDados.Fields.Count) do
    begin
      if not FDataSetDados.Fields[i].Visible then
        Continue;

      if (TestarFieldValor(FDataSetDados.Fields[i])) and (Pos(';' + FDataSetDados.Fields[i].FieldName + ';',cCamposNaoTot) <= 0) then
      begin
        if FDataSetDados.Fields[i].DataType in [ftBCD, ftFMTBcd] then
        begin
          if FDataSetDados.Fields[i].DataType = ftBCD then
            cTotal := FormataCulunaValor(SomarValor(FDataSetDados.Fields[i]), (FDataSetDados.Fields[i] as TBCDField).Size);
          if FDataSetDados.Fields[i].DataType = ftFMTBcd then
            cTotal := FormataCulunaValor(SomarValor(FDataSetDados.Fields[i]), (FDataSetDados.Fields[i] as TFMTBCDField).Size);
        end
        else
          cTotal := FormataCulunaValor(SomarValor(FDataSetDados.Fields[i]), 2);

        cTotal := Replicate(' ', (RetornarTamanhoField(FDataSetDados.Fields[i]) - Length(cTotal))) + cTotal;
        cLinhaTotal := cLinhaTotal + cTotal;

      end else
        cLinhaTotal := cLinhaTotal + Replicate(' ', RetornarTamanhoField(FDataSetDados.Fields[i]));

      if i < Pred(FDataSetDados.Fields.Count) then
        cLinhaTotal := cLinhaTotal + Replicate(' ', _nTamanhoEntreColuna);
    end;
    FlsImpressao.Add(cLinhaTotal);
  end;

  if Assigned(FoEstruturaRel.FiltrosRodape) then
  begin
    if FoEstruturaRel.FiltrosRodape.getItens.Count > 0 then
    begin
      FlsImpressao.Add(EmptyStr);
      if FoEstruturaRel.FiltrosRodape.getTitulo <> EmptyStr then
        FlsImpressao.Add(FoEstruturaRel.FiltrosRodape.getTitulo);

      for I := 0 to Pred(FoEstruturaRel.FiltrosRodape.getItens.Count) do
        FlsImpressao.Add(AllTrim(FoEstruturaRel.FiltrosRodape.getItens[I]));
    end;
    if (FoEstruturaRel.FiltrosRodape.getFiltroData <> EmptyStr) then
      FlsImpressao.Add(FoEstruturaRel.FiltrosRodape.getFiltroData);
  end;
end;

function TEstruturaTipoRelatorioPadrao.SomarValor(AoField: TField) : Currency;
begin
  Result := 0;

  FDataSetDados.First;
  while not FDataSetDados.Eof do
  begin
    Result := Result + AoField.AsCurrency;

    FDataSetDados.Next;
  end;
end;

function TEstruturaTipoRelatorioPadrao.FormataCulunaValor(AnValor: Currency; AnCasasDecimais: Integer = 2): String;
var
  nDecimais: Integer;
begin
  nDecimais := AnCasasDecimais;
  if nDecimais <= 0 then
    nDecimais := 2;
  Result := Trim(Format('%10.'+IntToStr(nDecimais)+'n', [AnValor]));
end;

function TEstruturaTipoRelatorioPadrao.RetornarTextoValorQuery(AoField: TField; AbSemBrancos: Boolean = False): String;
begin
  Result := FDataSetDados.FieldByname(AoField.FieldName).AsString;

  if TestarFieldValor(AoField) then
  begin
    if AoField.DataType in [ftBCD, ftFMTBcd] then
    begin
      if AoField.DataType = ftBCD then
        Result := FormataCulunaValor(FDataSetDados.FieldByname(AoField.FieldName).AsCurrency, (AoField as TBCDField).Size);
      if AoField.DataType = ftFMTBcd then
        Result := FormataCulunaValor(FDataSetDados.FieldByname(AoField.FieldName).AsCurrency, (AoField as TFMTBCDField).Size);
    end
    else
      Result := FormataCulunaValor(FDataSetDados.FieldByname(AoField.FieldName).AsCurrency, 2);
      
    if not AbSemBrancos then
      Result := Replicate(' ', RetornarTamanhoField(AoField) - Length(Result)) + Result;
  end;
end;

class function TEstruturaTipoRelatorioPadrao.New: IEstruturaTipoRelatorioPadrao;
begin
  Result := Self.Create;
end;

destructor TEstruturaTipoRelatorioPadrao.Destroy;
begin
  FreeAndNil(FlsImpressao);
  FreeAndNil(FoArquivoDAT);
  inherited;
end;

function TEstruturaTipoRelatorioPadrao.RetornarLinhaTextoColunasTXT: String;
var
  i: Integer;
  nTamanho: Integer;
  cNome: String;
begin
  for i := 0 to Pred(FDataSetDados.Fields.Count) do
  begin
    if not FDataSetDados.Fields[i].Visible then
      Continue;
      
    nTamanho := RetornarTamanhoField(FDataSetDados.Fields[i]);

    if i < Pred(FDataSetDados.Fields.Count) then
      nTamanho := nTamanho + _nTamanhoEntreColuna;

    cNome := FDataSetDados.Fields[i].FieldName;
    if FDataSetDados.Fields[i].DisplayLabel <> EmptyStr then
      cNome := FDataSetDados.Fields[i].DisplayLabel;

    nTamanho := (nTamanho - Length(cNome));

    Result := Result + cNome + Replicate(' ', nTamanho)
  end;
end;

function TEstruturaTipoRelatorioPadrao.RetornarTamanhoField(AoField: TField): Integer;
var
  cNome: String;
begin
  Result := AoField.Size;

  if (Result <= 0) and ((AoField is TDateField) or (AoField is TDateTimeField))then
    Result := 10;
  if TestarFieldValor(AoField) then
    Result := 18;

  cNome := AoField.FieldName;
  if AoField.DisplayLabel <> EmptyStr then
    cNome := AoField.DisplayLabel;

  if Result < Length(cNome) then
    Result := Length(cNome);
end;

function TEstruturaTipoRelatorioPadrao.TestarFieldValor(AoField: TField): Boolean;
begin
  Result := (AoField.DataType in [ftBCD, ftFloat, ftCurrency, ftFMTBcd]);
end;

constructor TEstruturaTipoRelatorioPadrao.Create;
begin
  FlsImpressao := TStringList.Create;

  FdInicio := Time;
end;

function TEstruturaTipoRelatorioPadrao.GerarImpressao(AoEstruturaRel: IEstruturaRelatorioPadrao): IEstruturaTipoRelatorioPadrao;
begin
  Result := Self;

  FoEstruturaRel := AoEstruturaRel;

  AoEstruturaRel.getTitulo(FcTitulo);
  FDataSetDados := AoEstruturaRel.getDAO.getDados;
  FoDataBase := AoEstruturaRel.getDAO.getDataBase;

  MontarDados;
end;

procedure TEstruturaTipoRelatorioPadrao.DefineFinalArquivo;
var
  QryEmitente: TIBQuery;
  cDataExtenso: String;
  cTempo: String;
begin
  QryEmitente := TDadosEmitente.New
                               .setDataBase(FoDataBase)
                               .getQuery;

  cDataExtenso := Copy(DateTimeToStr(Date),1,2) + ' de '
                    + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
                    + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time);

  cTempo := TimeToStr(Time - FdInicio);

  if FoArquivoDAT.Usuario.Html.TipoRelatorio in [ttiHTML, ttiPDF] then
    FlsImpressao.Add(TLayoutHTMLRelatorio.RetornarRodape(QryEmitente.FieldByName('MUNICIPIO').AsString,
                                                         QryEmitente.FieldByName('HP').AsString,
                                                         cTempo,
                                                         FoArquivoDAT.Usuario.Html.TipoRelatorio))
  else
  begin
    FlsImpressao.Add(EmptyStr);
    FlsImpressao.Add('Gerado em '+Trim(QryEmitente.FieldByName('MUNICIPIO').AsString)+', ' + cDataExtenso);
    FlsImpressao.Add('Tempo para gerar este relatório: ' + cTempo);
  end;
end;

function TEstruturaTipoRelatorioPadrao.setUsuario(AcUsuario: String): IEstruturaTipoRelatorioPadrao;
begin
  Result := Self;

  FcNomeArquivo := AcUsuario;

  FoArquivoDAT := TArquivosDAT.Create(AcUsuario);
end;

procedure TEstruturaTipoRelatorioPadrao.MontarDados;
begin
  case FoArquivoDAT.Usuario.Html.TipoRelatorio of
    ttiHTML, ttiPDF: MontaDadosHTML;
    ttiTXT: MontaDadosTXT;
  end;
end;

procedure TEstruturaTipoRelatorioPadrao.DefineInicialHTML;
var
  QryEmitente: TIBQuery;
begin
  if FoArquivoDAT.Usuario.Html.TipoRelatorio in [ttiHTML, ttiPDF] then
  begin
    QryEmitente := TDadosEmitente.New
                                  .setDataBase(FoDataBase)
                                  .getQuery;

    FlsImpressao.Add(TLayoutHTMLRelatorio.RetornarCabecalho(QryEmitente.FieldByName('NOME').AsString));
  end;
end;

function TEstruturaTipoRelatorioPadrao.GerarImpressaoAgrupado(AoEstruturaRel: IEstruturaRelatorioPadrao; AcTitulo: String): IEstruturaTipoRelatorioPadrao;
begin
  Result := Self;

  FoEstruturaRel := AoEstruturaRel;

  FcTitulo := AcTitulo;

  FDataSetDados := AoEstruturaRel.getDAO.getDados;
  FoDataBase := AoEstruturaRel.getDAO.getDataBase;

  MontarDados;
end;

function TEstruturaTipoRelatorioPadrao.GerarImpressaoCabecalho(AoEstruturaRel: IEstruturaRelatorioPadrao): IEstruturaTipoRelatorioPadrao;
begin
  Result := Self;

  FoEstruturaRel := AoEstruturaRel;

  AoEstruturaRel.getTitulo(FcTitulo);

  FoDataBase := AoEstruturaRel.getDAO.getDataBase;

  MontarCabecalho;
end;

end.
