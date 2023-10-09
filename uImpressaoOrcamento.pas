unit uImpressaoOrcamento;

interface

uses
  uIImpressaoOrcamento, uIRetornaImpressaoOrcamento, uArquivosDAT,
  Classes, IBDataBase,
  {$IFDEF VER150}
  SmallFunc,
  {$ELSE}
  smallfunc_xe,
  {$ENDIF}
  uConverteHtmlToPDF,
  Forms, Controls, ShellAPI,
  Windows, uSmallEnumerados, Printers, Graphics, Dialogs;

type
  TImpressaoOrcamento = class(TInterfacedObject, IImpressaoOrcamento)
  private
    FoRetornaTexto: IRetornaImpressaoOrcamento;
    FslImpressao: TStringList;
    FoArquivoDAT: TArquivosDAT;
    FcNumeroOrcamento: String;
    constructor Create;
    procedure MontarImpressao;
    function RetornarExtensaoArq: String;
    function RetornarCaminhoArquivo: String;
    procedure ImprimeNaImpressoraDoWindows;
    function RetornarNomeArquivo: String;
  public
    destructor Destroy; override;
    class function New: IImpressaoOrcamento;
    function SetTransaction(AoTransaction: TIBTransaction): IImpressaoOrcamento;
    function SetNumeroOrcamento(AcNumeroOrcamento: String): IImpressaoOrcamento;
    function GetCaminhoImpressao(var AcCaminho: String): IImpressaoOrcamento;
    procedure Imprimir;
    procedure Salvar;
  end;

implementation

uses SysUtils, uRetornaImpressaoOrcamento, uSmallConsts;

{ TImpressaoOrcamento }

constructor TImpressaoOrcamento.Create;
begin
  FoArquivoDAT   := TArquivosDAT.Create(EmptyStr);
  FslImpressao   := TStringList.Create;
  FoRetornaTexto := TRetornaImpressaoOrcamento.New
                                              .SetDecimais(FoArquivoDAT.SmallCom.Outros.CasasDecimaisQuantidade
                                                           , FoArquivoDAT.SmallCom.Outros.CasasDecimaisPreco);
end;

destructor TImpressaoOrcamento.Destroy;
begin
  FreeAndNil(FoArquivoDAT);
  FreeAndNil(FslImpressao);
  inherited;
end;

procedure TImpressaoOrcamento.Imprimir;
var
  cExtensao: String;
begin
  MontarImpressao;

  Self.Salvar;

  cExtensao := RetornarExtensaoArq;
  case FoArquivoDAT.Frente.Orcamento.Porta of
    ttioPDF, ttioHTML:
    begin
      if (FoArquivoDAT.Frente.Orcamento.Porta = ttioPDF) then
        cExtensao := '.pdf';
            
      ShellExecute( 0, 'Open', pChar(RetornarCaminhoArquivo + cExtensao), '', '', SW_SHOWMAXIMIZED);
    end;
    ttioTXT:
    begin
      if Length(FslImpressao.Text) > 80 then
        ShellExecute( 0, 'Open', pChar(RetornarCaminhoArquivo + cExtensao), '', '', SW_SHOWMAXIMIZED);
    end;
    else
    begin
      if Length(FslImpressao.Text) > 80 then
        ImprimeNaImpressoraDoWindows;
    end;
  end;
end;

procedure TImpressaoOrcamento.ImprimeNaImpressoraDoWindows;
var
  I, iLinha, iTamanho: Integer;
  sLinha: String;
  iMargemLeft: Integer;// Sandro Silva Controla a margem a esquerda onde inicia a impressão
begin
  //
  try
    //
    if VerificaSeTemImpressora() then
    begin
      //
      iMargemLeft := 5; // Sandro Silva 2015-05-06
      if Printer.PageWidth <= 464 then // Sandro Silva 2018-03-26
        iMargemLeft := 15;
      Printer.Canvas.Pen.Width  := 1;             // Largura da linha  //
      Printer.Canvas.Font.Name  := 'Courier New'; // Tipo da fonte     //
      Printer.Canvas.Font.Size  := 7;             // Tamanho da fonte  //
      if Printer.PageWidth <= 464 then // Sandro Silva 2018-03-26
        Printer.Canvas.Font.Size  := 5;
      Printer.Canvas.Font.Style := [fsBold];      // Coloca em negrito //
      Printer.Canvas.Font.Color := clBlack;
      //Sandro Silva 2015-05-06 "a" impresso ocupa menos espaço que "W" iTamanho := Printer.Canvas.TextWidth('a') * 3;   // Tamanho que cada caractere ocupa na impressão em pontos
      iTamanho := Printer.Canvas.TextWidth('W') * 3;   // Tamanho que cada caractere ocupa na impressão em pontos
      if Printer.PageWidth <= 464 then // Sandro Silva 2018-03-26
        iTamanho := Trunc(Printer.Canvas.TextWidth('W') * 2.5);   // Tamanho que cada caractere ocupa na impressão em pontos // Sandro Silva 2018-03-23  iTamanho := Printer.Canvas.TextWidth('W') * 4;   // Tamanho que cada caractere ocupa na impressão em pontos
      Printer.Title := 'Relatório Gerencial';          // Este título é visto no spoool da impressora
      Printer.BeginDoc;                                // Inicia o documento de impressão
      //
      iLinha := 1;
      //
      for I := 1 to Length(FslImpressao.Text) do
      begin
        //
        if Copy(FslImpressao.Text,I,1) <> chr(10) then
        begin
          sLinha := sLinha+Copy(FslImpressao.Text,I,1);
        end else
        begin
          //
          Printer.Canvas.TextOut(iMargemLeft, iLinha * iTamanho,sLinha);  // Impressão da linha
          iLinha := iLinha + 1;
          sLinha:='';
          {Sandro Silva 2014-08-27 inicio}
          //A partir da posição vertical atual do canvas + a altura da fonte verifica se é maior que a altura da página da impressora padrão
          if (Printer.Canvas.PenPos.Y + Printer.Canvas.TextHeight('Ég')) >= (Printer.PageHeight - (Printer.Canvas.TextHeight('Ég') * 3)) then // Controla avanço de páginas
          begin
            Printer.NewPage;
            iLinha := 1;
          end;
          {Sandro Silva 2014-08-27 final}
        end;
      end;
      //
      Printer.Canvas.TextOut(iMargemLeft, (iLinha+1) * iTamanho,' ');  //
      Printer.Canvas.TextOut(iMargemLeft, (iLinha+2) * iTamanho,' ');  //
      //
      Printer.EndDoc;
      //
    end else
    begin
      ShowMessage('Não há impressora instalada no windows!');
    end;
    //
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao imprimir! '+E.Message);
    end;
  end;
end;

procedure TImpressaoOrcamento.MontarImpressao;
begin
  FslImpressao.Clear;
  FoRetornaTexto.CarregaDados;

  if (FoArquivoDAT.Frente.Orcamento.Porta in [ttioPDF, ttioHTML]) then
    FoRetornaTexto.MontarHTML
  else
    FoRetornaTexto.MontarTXT;

  FslImpressao.Text := FoRetornaTexto.RetornarTexto;

  if FoArquivoDAT.Frente.Orcamento.Porta = ttioTXT then
    FslImpressao.Text := ConverteAcentos(FslImpressao.Text);
end;

class function TImpressaoOrcamento.New: IImpressaoOrcamento;
begin
  Result := Create;
end;

procedure TImpressaoOrcamento.Salvar;
begin
  if Trim(FslImpressao.Text) = EmptyStr then
    MontarImpressao;

  FslImpressao.SaveToFile(RetornarCaminhoArquivo + RetornarExtensaoArq);

  if (FoArquivoDAT.Frente.Orcamento.Porta = ttioPDF) then
  begin
    Screen.Cursor := crHourGlass;
    try
      HtmlToPDF(RetornarNomeArquivo);
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

function TImpressaoOrcamento.SetNumeroOrcamento(AcNumeroOrcamento: String): IImpressaoOrcamento;
begin
  Result := Self;

  FcNumeroOrcamento := AcNumeroOrcamento;
  FoRetornaTexto.SetNumeroOrcamento(FcNumeroOrcamento);
end;

function TImpressaoOrcamento.SetTransaction(AoTransaction: TIBTransaction): IImpressaoOrcamento;
begin
  Result := Self;
  
  FoRetornaTexto.SetTransaction(AoTransaction);
end;

function TImpressaoOrcamento.RetornarExtensaoArq: String;
begin
  case FoArquivoDAT.Frente.Orcamento.Porta of
    ttioPDF, ttioHTML: Result  := 'htm';
    else Result := 'txt';
  end;
  Result := '.' + Result;
end;

function TImpressaoOrcamento.RetornarCaminhoArquivo: String;
begin
  Result := ExtractFilePath(Application.ExeName) + RetornarNomeArquivo; // Sandro Silva 2023-10-09 Result := GetCurrentDir + '\' + RetornarNomeArquivo;
end;

function TImpressaoOrcamento.RetornarNomeArquivo: String;
begin
  Result := 'ORCAMENTOS\' + 'Orçamento ' + FcNumeroOrcamento;
end;

function TImpressaoOrcamento.GetCaminhoImpressao(
  var AcCaminho: String): IImpressaoOrcamento;
var
  cExtensao: String;
begin
  Result := Self;
  
  cExtensao := RetornarExtensaoArq;
  if FoArquivoDAT.Frente.Orcamento.Porta = ttioPDF then
    cExtensao := '.pdf';

  AcCaminho := RetornarCaminhoArquivo + cExtensao;
end;

end.
