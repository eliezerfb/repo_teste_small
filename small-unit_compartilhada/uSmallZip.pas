unit uSmallZip;

interface

uses
  System.Types, System.IOUtils, System.Zip, SysUtils, System.Classes;

  function CompactaArquivos(sOrigem,sDestino : string):boolean;
  function RetornarListaArquivos(AcCaminhos: String): TStringList;
  function RetornarListaArquivosTipoArq(AcCaminho: String): TStringList;
  procedure AddArquivo(AcCaminho: String; FoZip: TZipFile);
  function TestaCaminhoEhPasta(AcCaminho: String): Boolean;

implementation

function CompactaArquivos(sOrigem,sDestino : string):boolean;
var
  FoZip: TZipFile;
  lsLista, lsListaExt: TStringList;
  i, x: Integer;
  cCaminhoAtual, cArquivoZip: String;
  cCaminhoAux, cCaminhoAux2: String;
  oFiles: TStringDynArray;
begin
  Result := False;

  try
    FoZip := TZipFile.Create;
    lsLista := RetornarListaArquivos(sOrigem);

    try
      cArquivoZip := sDestino;
      if Pos('.zip', cArquivoZip) <= 0 then
        cArquivoZip := cArquivoZip + '.zip';

      // Se não tem o zip ainda deve ser zmWrite para criar o arquivo.
      // Se já existe o zip então deve ser zmReadWrite para permitir adicionar novos arquivos
      if not FileExists(cArquivoZip) then
        FoZip.Open(cArquivoZip, zmWrite)
      else
        FoZip.Open(cArquivoZip, zmReadWrite);

      for i := 0 to Pred(lsLista.Count) do
      begin
        cCaminhoAtual := lsLista[i];
        if Pos('*.', lsLista[i]) > 0 then
        begin
          //Se o caminho for todos os arquivos da extenção
          lsListaExt := RetornarListaArquivosTipoArq(cCaminhoAtual);
          try
            for x := 0 to Pred(lsListaExt.Count) do
              AddArquivo(lsListaExt[x],FoZip);
          finally
            FreeAndNil(lsListaExt);
          end;
        end
        else
        begin
          if not TestaCaminhoEhPasta(cCaminhoAtual) then
            AddArquivo(cCaminhoAtual,FoZip)
          else
          begin
            // Necessario fazer dessa forma para adicionar a PASTA (parametro) ao ZIP
            cCaminhoAtual := ExtractFileDir(cCaminhoAtual);

            oFiles := TDirectory.GetFiles(cCaminhoAtual, '*', TSearchOption.soAllDirectories);
            cCaminhoAtual := System.SysUtils.IncludeTrailingPathDelimiter(cCaminhoAtual);
            for cCaminhoAux in oFiles do
            begin
              // Se tem o caminho solicitado (parametro) no caminho do loop então adiciona para conseguir colocar a pasta
              if Pos(lsLista[i], cCaminhoAux) > 0 then
              begin
                cCaminhoAux2 := StringReplace(Copy(cCaminhoAux, Length(cCaminhoAtual) + 1, Length(cCaminhoAux)), '\', '/', [rfReplaceAll]);
                if cCaminhoAux = cArquivoZip then
                  Continue;
                FoZip.Add(cCaminhoAux, cCaminhoAux2);
              end;
            end;
          end;
        end;
      end;
      FoZip.Close;
    except
    end;
  finally
    if FoZip.Mode <> zmClosed then
      FoZip.Close;
    FreeAndNil(lsLista);
    FreeAndNil(FoZip);
  end;
end;

function RetornarListaArquivos(AcCaminhos: String): TStringList;
var
  cAux: String;
begin
  Result := TStringList.Create;

  if Pos(';', AcCaminhos) > 0 then
  begin
    while AcCaminhos <> EmptyStr do
    begin
      if Pos(';', AcCaminhos) > 0 then
        cAux := Copy(AcCaminhos, 1, Pos(';', AcCaminhos))
      else
        cAux := AcCaminhos;

      AcCaminhos := StringReplace(AcCaminhos, cAux, EmptyStr, [rfReplaceAll]);

      cAux := StringReplace(cAux, ';', EmptyStr, [rfReplaceAll]);

      Result.Add(cAux);
    end;
  end
  else
    Result.Add(AcCaminhos);
end;


function RetornarListaArquivosTipoArq(AcCaminho: String): TStringList;
var
  oSearch: TSearchRec;
  I: integer;
begin
  Result := TStringList.Create;

  I := FindFirst(AcCaminho, faAnyFile, oSearch);
  while I = 0 do
  begin
    if Pos(AnsiUpperCase(ExtractFileExt(AcCaminho)), AnsiUpperCase(oSearch.Name)) > 0 then
    begin
      if Copy(ExtractFileDir(AcCaminho), length(ExtractFileDir(AcCaminho))-1,1) = '\' then
        Result.Add(ExtractFileDir(AcCaminho) + oSearch.Name)
      else
        Result.Add(ExtractFileDir(AcCaminho) + '\' + oSearch.Name);
    end;
    I := FindNext(oSearch);
  end;
end;

procedure AddArquivo(AcCaminho: String; FoZip: TZipFile);
var
  oStream: TFileStream;
begin
  // Tem que carregar em um Stream com fmShareDenyNone para conseguir
  // compactar arquivos em uso por outra aplicação.
  oStream := TFileStream.Create(AcCaminho, fmShareDenyNone);
  try
    FoZip.Add(oStream, ExtractFileName(AcCaminho), zcDeflate);
  finally
    FreeAndNil(oStream);
  end;
end;

function TestaCaminhoEhPasta(AcCaminho: String): Boolean;
begin
  Result := (ExtractFileExt(AcCaminho) = EmptyStr);
end;


end.
