unit uImprimeNaImpressoraDoWindows;

interface

uses
  Vcl.Printers, Vcl.Graphics, System.SysUtils, System.Classes;

  procedure ImprimeNaImpressoraDoWindows(sTexto : string);
  procedure ImprimePaginaNaImpressoraDoWindows(Paginas: TArray<TStringList>; iFsize : integer = 7; iTamLinha : double = 3);

implementation

uses uDialogs, smallfunc_xe;


procedure ImprimeNaImpressoraDoWindows(sTexto : string);
var
  I, iLinha, iTamanho: Integer;
  sLinha: String;
  iMargemLeft: Integer;// Sandro Silva Controla a margem a esquerda onde inicia a impress�o
begin
  try
    if VerificaSeTemImpressora() then
    begin
      iMargemLeft := 5; // Sandro Silva 2015-05-06
      if Printer.PageWidth <= 464 then // Sandro Silva 2018-03-26
        iMargemLeft := 15;
      Printer.Canvas.Pen.Width  := 1;             // Largura da linha  //
      Printer.Canvas.Font.Name  := 'Courier New'; // Tipo da fonte     //
      Printer.Canvas.Font.Size  := 7;             // Tamanho da fonte
      if Printer.PageWidth <= 464 then // Sandro Silva 2018-03-26
        Printer.Canvas.Font.Size  := 5;
      Printer.Canvas.Font.Style := [fsBold];      // Coloca em negrito
      Printer.Canvas.Font.Color := clBlack;

      //Sandro Silva 2015-05-06 "a" impresso ocupa menos espa�o que "W" iTamanho := Printer.Canvas.TextWidth('a') * 3;   // Tamanho que cada caractere ocupa na impress�o em pontos
      iTamanho := Printer.Canvas.TextWidth('W') * 3;   // Tamanho que cada caractere ocupa na impress�o em pontos

      if Printer.PageWidth <= 464 then // Sandro Silva 2018-03-26
        iTamanho := Trunc(Printer.Canvas.TextWidth('W') * 2.5);   // Tamanho que cada caractere ocupa na impress�o em pontos // Sandro Silva 2018-03-23  iTamanho := Printer.Canvas.TextWidth('W') * 4;   // Tamanho que cada caractere ocupa na impress�o em pontos
      Printer.Title := 'Relat�rio Gerencial';          // Este t�tulo � visto no spoool da impressora
      Printer.BeginDoc;                                // Inicia o documento de impress�o

      //iLinha := 1; Mauricio Parizotto 2024-11-05
      iLinha := 0;

      for I := 1 to Length(sTexto) do
      begin
        if Copy(sTexto,I,1) <> chr(10) then
        begin
          sLinha := sLinha+Copy(sTexto,I,1);
        end else
        begin
          Printer.Canvas.TextOut(iMargemLeft, iLinha * iTamanho,sLinha);  // Impress�o da linha
          iLinha := iLinha + 1;
          sLinha:='';
          //A partir da posi��o vertical atual do canvas + a altura da fonte verifica se � maior que a altura da p�gina da impressora padr�o
          if (Printer.Canvas.PenPos.Y + Printer.Canvas.TextHeight('�g')) >= (Printer.PageHeight - (Printer.Canvas.TextHeight('�g') * 3)) then // Controla avan�o de p�ginas
          begin
            Printer.NewPage;
            //iLinha := 1; Mauricio Parizotto 2024-11-05
            iLinha := 0;
          end;
        end;
      end;

      Printer.Canvas.TextOut(iMargemLeft, (iLinha+1) * iTamanho,' ');
      Printer.Canvas.TextOut(iMargemLeft, (iLinha+2) * iTamanho,' ');

      Printer.EndDoc;
    end else
    begin
      MensagemSistema('N�o h� impressora instalada no windows!',msgAtencao);
    end;
  except
    on E: Exception do
    begin
      MensagemSistema('Erro ao imprimir! '+E.Message,msgErro);
    end;
  end;
end;

procedure ImprimePaginaNaImpressoraDoWindows(Paginas: TArray<TStringList>; iFsize : integer = 7; iTamLinha : double = 3);
var
  I, iPg, iLinha, iTamanho: Integer;
  sLinha: String;
  iMargemLeft: Integer;// Sandro Silva Controla a margem a esquerda onde inicia a impress�o
begin
  try
    if VerificaSeTemImpressora() then
    begin
      iMargemLeft := 5;
      if Printer.PageWidth <= 464 then
        iMargemLeft := 15;
      Printer.Canvas.Pen.Width  := 1;             // Largura da linha  //
      Printer.Canvas.Font.Name  := 'Courier New'; // Tipo da fonte     //
      Printer.Canvas.Font.Size  := iFsize;
      Printer.Canvas.Font.Color := clBlack;

      //Sandro Silva 2015-05-06 "a" impresso ocupa menos espa�o que "W" iTamanho := Printer.Canvas.TextWidth('a') * 3;   // Tamanho que cada caractere ocupa na impress�o em pontos
      iTamanho :=  Trunc(Printer.Canvas.TextWidth('W') * iTamLinha);


      if Printer.PageWidth <= 464 then // Sandro Silva 2018-03-26
        iTamanho := Trunc(Printer.Canvas.TextWidth('W') * 2.5);   // Tamanho que cada caractere ocupa na impress�o em pontos // Sandro Silva 2018-03-23  iTamanho := Printer.Canvas.TextWidth('W') * 4;   // Tamanho que cada caractere ocupa na impress�o em pontos
      Printer.Title := 'Relat�rio';          // Este t�tulo � visto no spoool da impressora
      Printer.BeginDoc;                      // Inicia o documento de impress�o


      for iPg := Low(Paginas) to High(Paginas) do
      begin
        iLinha := 0;

        for I := 1 to Length(Paginas[iPg].Text) do
        begin
          if Copy(Paginas[iPg].Text,I,1) <> chr(10) then
          begin
            sLinha := sLinha+Copy(Paginas[iPg].Text,I,1);
          end else
          begin
            Printer.Canvas.TextOut(iMargemLeft, iLinha * iTamanho,sLinha);
            iLinha := iLinha + 1;
            sLinha:='';
          end;
        end;

        if iPg <> High(Paginas) then
          Printer.NewPage;
      end;

      Printer.EndDoc;
    end else
    begin
      MensagemSistema('N�o h� impressora instalada no windows!',msgAtencao);
    end;
  except
    on E: Exception do
    begin
      MensagemSistema('Erro ao imprimir! '+E.Message,msgErro);
    end;
  end;
end;


end.
