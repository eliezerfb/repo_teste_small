unit uImprimeNaImpressoraDoWindows;

interface

uses
  Vcl.Printers, Vcl.Graphics, System.SysUtils;

  procedure ImprimeNaImpressoraDoWindows(sTexto : string);

implementation

uses uDialogs, smallfunc_xe;


procedure ImprimeNaImpressoraDoWindows(sTexto : string);
var
  I, iLinha, iTamanho: Integer;
  sLinha: String;
  iMargemLeft: Integer;// Sandro Silva Controla a margem a esquerda onde inicia a impressão
begin
  try
    if VerificaSeTemImpressora() then
    begin
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

      iLinha := 1;

      for I := 1 to Length(sTexto) do
      begin
        if Copy(sTexto,I,1) <> chr(10) then
        begin
          sLinha := sLinha+Copy(sTexto,I,1);
        end else
        begin
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

      Printer.Canvas.TextOut(iMargemLeft, (iLinha+1) * iTamanho,' ');
      Printer.Canvas.TextOut(iMargemLeft, (iLinha+2) * iTamanho,' ');

      Printer.EndDoc;
    end else
    begin
      MensagemSistema('Não há impressora instalada no windows!',msgAtencao);
    end;
  except
    on E: Exception do
    begin
      MensagemSistema('Erro ao imprimir! '+E.Message,msgErro);
    end;
  end;
end;

end.
