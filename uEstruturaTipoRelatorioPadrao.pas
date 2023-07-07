unit uEstruturaTipoRelatorioPadrao;

interface

uses
  uIEstruturaTipoRelatorioPadrao, uSmallEnumerados, uArquivosDAT,
  Classes, Dialogs, IBQuery, DB, Windows, uIEstruturaRelatorioPadrao,
  SysUtils, DateUtils, Forms, Controls;

type
  TEstruturaTipoRelatorioPadrao = class(TInterfacedObject, IEstruturaTipoRelatorioPadrao)
  private
    FoArquivoDAT: TArquivosDAT;
    FoEstruturaRel: IEstruturaRelatorioPadrao;
    FcTitulo: String;
    FQryDados: TIBQuery;
    FlsImpressao: TStringList;
    FcNomeArquivo: String;
    FdInicio: TDateTime;
    constructor Create;
    procedure ImprimirHTML;
    procedure ImprimirTXT;
    procedure ImprimirPDF;
    function RetornarCabecalho: String;
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
  public
    destructor Destroy; override;
    class function New: IEstruturaTipoRelatorioPadrao;
    function setUsuario(AcUsuario: String): IEstruturaTipoRelatorioPadrao;
    function GerarImpressao(AoEstruturaRel: IEstruturaRelatorioPadrao): IEstruturaTipoRelatorioPadrao;
    function Imprimir: IEstruturaTipoRelatorioPadrao;
  end;

implementation

uses SmallFunc, uAssinaturaDigital, ShellApi, Math, uDadosEmitente,
  uIDadosEmitente, uSmallResourceString;

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

procedure TEstruturaTipoRelatorioPadrao.SalvarArquivoHTML;
begin
  if FileExists(FcNomeArquivo+'.HTM') then
    DeleteFile(FcNomeArquivo+'.HTM');

  FlsImpressao.SaveToFile(FcNomeArquivo + '.HTM');
end;

procedure TEstruturaTipoRelatorioPadrao.ImprimirHTML;
begin
  SalvarArquivoHTML;

  ShellExecute( 0, 'Open',pChar(FcNomeArquivo+'.HTM'),'', '', SW_SHOWMAXIMIZED);
end;

procedure TEstruturaTipoRelatorioPadrao.ImprimirTXT;
begin
  FlsImpressao.Add(EmptyStr);
  Sleep(100);
  FlsImpressao.Text := TAssinaturaDigital.New
                                    .AssinarTexto(FlsImpressao.Text);
  Sleep(100);
  FlsImpressao.SaveToFile(FcNomeArquivo + '.txt');

  ShellExecute(0, 'Open',pChar(FcNomeArquivo+'.txt'),'', '', SW_SHOW);
end;

procedure TEstruturaTipoRelatorioPadrao.ImprimirPDF;
begin
  if FileExists(FcNomeArquivo+'.pdf') then
    DeleteFile(FcNomeArquivo+'.pdf');

  SalvarArquivoHTML;

  Screen.Cursor            := crHourGlass;
  HtmlToPDF(FcNomeArquivo);
  ShellExecute( 0, 'Open',pChar(FcNomeArquivo+'.pdf'),'', '', SW_SHOWMAXIMIZED);
  Screen.Cursor            := crDefault;
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
  if Trim(FlsImpressao.Text) = EmptyStr then
    DefineInicialHTML
  else
    FlsImpressao.Add('<br>');

  FlsImpressao.Add('<br><font size=4 color=#000000><b>' + FcTitulo + '</b></font><br></center><br>');
  FlsImpressao.Add('<center>');
  FlsImpressao.Add('<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
  FlsImpressao.Add(' <tr>');
  //Colunas
  for i := 0 to Pred(FQryDados.Fields.Count) do
    FlsImpressao.Add('  <td bgcolor=#EBEBEB><font face="Microsoft Sans Serif" size=1><b>' + FQryDados.Fields[i].FieldName + '</td>');
  FlsImpressao.Add(' </tr>');
  while not FQryDados.Eof do
  begin
    FlsImpressao.Add('   <tr>');
    cAux := EmptyStr;
    for i := 0 to Pred(FQryDados.Fields.Count) do
    begin
      if TestarFieldValor(FQryDados.Fields[i]) then
      begin
        cAux := 'align=Right ';
        bTemColunaValor := True;        
      end;
      FlsImpressao.Add('    <td ' + cAux + 'bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>' + RetornarTextoValorQuery(FQryDados.Fields[i], True) + '</td>');
    end;
    FlsImpressao.Add('   </tr>');
    FQryDados.Next;
  end;

  if bTemColunaValor then
  begin
    FlsImpressao.Add('   <tr bgcolor=#EBEBEB >');
    for i := 0 to Pred(FQryDados.Fields.Count) do
    begin
      if (TestarFieldValor(FQryDados.Fields[i])) and (Pos(';' + FQryDados.Fields[i].FieldName + ';',cCamposNaoTot) <= 0) then
      begin
        cTotal := FormataCulunaValor(SomarValor(FQryDados.Fields[i]), (FQryDados.Fields[i] as TBCDField).Size);
        FlsImpressao.Add('    <td nowrap valign=top align=right><font face="Microsoft Sans Serif" size=1><b>' + cTotal);
      end else
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

  for i := 0 to Pred(FQryDados.Fields.Count) do
  begin
    cLinha := cLinha + Replicate('-', RetornarTamanhoField(FQryDados.Fields[i]));
    if TestarFieldValor(FQryDados.Fields[i]) then
      cLinhaTotal := cLinhaTotal + Replicate('-', RetornarTamanhoField(FQryDados.Fields[i]))
    else
      cLinhaTotal := cLinhaTotal + Replicate(' ', RetornarTamanhoField(FQryDados.Fields[i]));

    if i < Pred(FQryDados.Fields.Count) then
    begin
      cLinha := cLinha + Replicate(' ', _nTamanhoEntreColuna);
      cLinhaTotal := cLinhaTotal + Replicate(' ', _nTamanhoEntreColuna);
    end;
  end;

  if FlsImpressao.Text <> EmptyStr then
    FlsImpressao.Add(EmptyStr);
    
  FlsImpressao.Add(FcTitulo);
  FlsImpressao.Add(EmptyStr);

  FlsImpressao.Add(RetornarCabecalho);
  FlsImpressao.Add(cLinha);

  while not FQryDados.Eof do
  begin
    cLinhaTemp := EmptyStr;
    for i := 0 to Pred(FQryDados.Fields.Count) do
    begin
      cTexto := RetornarTextoValorQuery(FQryDados.Fields[i]);
      cLinhaTemp := cLinhaTemp + cTexto
                    + Replicate(' ', (RetornarTamanhoField(FQryDados.Fields[i]) - Length(cTexto)));
      if i < Pred(FQryDados.Fields.Count) then
        cLinhaTemp := cLinhaTemp + Replicate(' ', _nTamanhoEntreColuna);
    end;

    FlsImpressao.Add(cLinhaTemp);

    FQryDados.Next;
  end;

  // Linha para totalizar colunas de valor
  if Trim(cLinhaTotal) <> EmptyStr then
  begin
    FlsImpressao.Add(cLinhaTotal);
    cLinhaTotal := EmptyStr;
    for i := 0 to Pred(FQryDados.Fields.Count) do
    begin
      if (TestarFieldValor(FQryDados.Fields[i])) and (Pos(';' + FQryDados.Fields[i].FieldName + ';',cCamposNaoTot) <= 0) then
      begin
        cTotal := FormataCulunaValor(SomarValor(FQryDados.Fields[i]), (FQryDados.Fields[i] as TBCDField).Size);

        cTotal := Replicate(' ', (RetornarTamanhoField(FQryDados.Fields[i]) - Length(cTotal))) + cTotal;
        cLinhaTotal := cLinhaTotal + cTotal;

      end else
        cLinhaTotal := cLinhaTotal + Replicate(' ', RetornarTamanhoField(FQryDados.Fields[i]));

      if i < Pred(FQryDados.Fields.Count) then
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

  FQryDados.First;
  while not FQryDados.Eof do
  begin
    Result := Result + AoField.AsCurrency;

    FQryDados.Next;
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
  Result := FQryDados.FieldByname(AoField.FieldName).AsString;

  if TestarFieldValor(AoField) then
  begin
    Result := FormataCulunaValor(FQryDados.FieldByname(AoField.FieldName).AsCurrency, (AoField as TBCDField).Size);

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
  FreeAndNil(FQryDados);
  FreeAndNil(FoArquivoDAT);
  inherited;
end;

function TEstruturaTipoRelatorioPadrao.RetornarCabecalho: String;
var
  i: Integer;
  nTamanho: Integer;
begin
  for i := 0 to Pred(FQryDados.Fields.Count) do
  begin
    nTamanho := RetornarTamanhoField(FQryDados.Fields[i]);

    if i < Pred(FQryDados.Fields.Count) then
      nTamanho := nTamanho + _nTamanhoEntreColuna;

    nTamanho := (nTamanho - Length(FQryDados.Fields[i].FieldName));

    Result := Result + FQryDados.Fields[i].FieldName + Replicate(' ', nTamanho)
  end;
end;

function TEstruturaTipoRelatorioPadrao.RetornarTamanhoField(AoField: TField): Integer;
begin
  Result := AoField.Size;

  if (Result <= 0) and ((AoField is TDateField) or (AoField is TDateTimeField))then
    Result := 10;
  if TestarFieldValor(AoField) then
    Result := 18;

  if Result < Length(AoField.FieldName) then
    Result := Length(AoField.FieldName);
end;

function TEstruturaTipoRelatorioPadrao.TestarFieldValor(AoField: TField): Boolean;
begin
  Result := ((AoField is TFloatField) or (AoField is TBCDField) or (AoField is TCurrencyField));
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
  AoEstruturaRel.getQuery(FQryDados);

  MontarDados;
end;

procedure TEstruturaTipoRelatorioPadrao.DefineFinalArquivo;
var
  QryEmitente: TIBQuery;
  cDataExtenso: String;
  cTempo: String;
begin
  QryEmitente := TDadosEmitente.New
                                .setDataBase(FQryDados.Database)
                                .getQuery;

  cDataExtenso := Copy(DateTimeToStr(Date),1,2) + ' de '
                    + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
                    + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time);

  cTempo := TimeToStr(Time - FdInicio);

  if FoArquivoDAT.Usuario.Html.TipoRelatorio in [ttiHTML, ttiPDF] then
  begin
    FlsImpressao.Add('<center><br><font face="Microsoft Sans Serif" size=1>Gerado em ' + Trim(QryEmitente.FieldByName('MUNICIPIO').AsString) + ', ' + cDataExtenso+'</font><br>');

    if (Alltrim(QryEmitente.FieldByName('HP').AsString) = '') then
    begin
      FlsImpressao.Add('<font face="verdana" size=1><center>Relatório gerado pelo sistema Smallsoft, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
    end else
    begin
      FlsImpressao.Add('<font face="verdana" size=1><center><a href="http://' + QryEmitente.FieldByName('HP').AsString + '">' + QryEmitente.FieldByName('HP').AsString + '</a><font>');
    end;

    FlsImpressao.Add('<font face="Microsoft Sans Serif" size=1><center>Tempo para gerar este relatório: ' + cTempo + '</center>');
    if FoArquivoDAT.Usuario.Html.TipoRelatorio = ttiHTML then
      FlsImpressao.Add('<a href="http://www.smallsoft.com.br/meio_ambiente.htm"><center><font face="Webdings" size=5 color=#215E21>P<font face="Microsoft Sans Serif" size=1 color=#215E21> Antes de imprimir, pense no meio ambiente.</center></a>');
    FlsImpressao.Add('</html>');
  end else
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
  if FQryDados.IsEmpty then
    Exit;
    
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
                                  .setDataBase(FQryDados.Database)
                                  .getQuery;

    FlsImpressao.Add('<html><head><title>'+AllTrim(QryEmitente.FieldByName('NOME').AsString) + '</title></head>');
    FlsImpressao.Add('<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>');
    FlsImpressao.Add('<img src="logotip.jpg" alt="'+AllTrim(QryEmitente.FieldByName('NOME').AsString)+'">');
    FlsImpressao.Add('<br><font size=3 color=#000000><b>'+AllTrim(QryEmitente.FieldByName('NOME').AsString)+'</b></font>');
  end;
end;

end.
