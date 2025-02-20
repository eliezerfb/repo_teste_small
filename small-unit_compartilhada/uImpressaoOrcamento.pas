unit uImpressaoOrcamento;

interface

uses
  uIImpressaoOrcamento, uIRetornaImpressaoOrcamento, uArquivosDAT,
  Classes, IBDataBase,
  {$IFDEF VER150}
  smallfunc,
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
    constructor Create(ConTransaction : TIBTransaction);
    procedure MontarImpressao;
    function RetornarExtensaoArq: String;
    function RetornarCaminhoArquivo: String;
    function RetornarNomeArquivo: String;
  public
    destructor Destroy; override;
    class function New(ConTransaction : TIBTransaction): IImpressaoOrcamento;
    function SetTransaction(AoTransaction: TIBTransaction): IImpressaoOrcamento;
    function SetNumeroOrcamento(AcNumeroOrcamento: String): IImpressaoOrcamento;
    function GetCaminhoImpressao(var AcCaminho: String): IImpressaoOrcamento;
    procedure Imprimir;
    procedure Salvar;
  end;

implementation

uses SysUtils, uRetornaImpressaoOrcamento, uSmallConsts, uDialogs,
  uImprimeNaImpressoraDoWindows;

{ TImpressaoOrcamento }

constructor TImpressaoOrcamento.Create(ConTransaction : TIBTransaction);
begin
  //FoArquivoDAT   := TArquivosDAT.Create(EmptyStr); Mauricio Parizotto 2024-10-28
  FoArquivoDAT   := TArquivosDAT.Create(EmptyStr,ConTransaction);
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
  sFormato : string;
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
        {Mauricio Parizotto 2024-10-28 Inicio
        if Length(FslImpressao.Text) > 80 then
          ImprimeNaImpressoraDoWindows;
        }
        sFormato := FoArquivoDAT.BD.Impressora.FormatoOrcamento;

        if sFormato = '80mm' then
          ImprimeNaImpressoraDoWindows(FslImpressao.Text);

        if sFormato = 'A5' then
        begin
          ImprimePaginaNaImpressoraDoWindows(FoRetornaTexto.RetornaPaginas,10,1.8);
        end;

        if sFormato = 'A5 Matricial' then
        begin
          SetConfiguracaoA5PaginaMatricial;
          ImprimePaginaNaImpressoraDoWindows(FoRetornaTexto.RetornaPaginas,10,1);
        end;

        {Mauricio Parizotto 2024-10-28}
      end;
  end;
end;


procedure TImpressaoOrcamento.MontarImpressao;
begin
  FslImpressao.Clear;
  FoRetornaTexto.CarregaDados;

  if (FoArquivoDAT.Frente.Orcamento.Porta in [ttioPDF, ttioHTML]) then
  begin
    FoRetornaTexto.MontarHTML;
  end else
  begin
    //FoRetornaTexto.MontarTXT; Mauricio Parizotto 2024-10-28

    if (FoArquivoDAT.BD.Impressora.FormatoOrcamento = '80mm')
      or (FoArquivoDAT.Frente.Orcamento.Porta = ttioTXT) then
      FoRetornaTexto.MontarTXT
    else
      FoRetornaTexto.MontarTXT_A5;
  end;

  FslImpressao.Text := FoRetornaTexto.RetornarTexto;

  if FoArquivoDAT.Frente.Orcamento.Porta = ttioTXT then
    FslImpressao.Text := ConverteAcentos(FslImpressao.Text);
end;

class function TImpressaoOrcamento.New(ConTransaction : TIBTransaction): IImpressaoOrcamento;
begin
  Result := Create(ConTransaction);
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
