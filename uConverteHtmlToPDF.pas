(************************************************************************)
(*                                                                      *)
(* Unit com método para converter arquivo HTML para PDF                 *)
(* Usada nos projetos em Delphi 7, Alexandria ou superiores             *)
(*                                                                      *)
(************************************************************************)

unit uConverteHtmlToPDF;

interface

uses
  {$IFDEF VER150}
  SysUtils
  , Windows
  , ShellAPI
  {$ELSE}
  System.SysUtils
  , Winapi.Windows
  , Winapi.ShellAPI
  , smallfunc_xe
  {$ENDIF}
  , Forms
  ;

function HtmlToPDF(AcArquivo: String): Boolean;

implementation

function HtmlToPDF(AcArquivo: String): Boolean;
var
  cCaminhoEXE: String;
begin
  cCaminhoEXE := ExtractFilePath(Application.ExeName); // Sandro Silva 2023-10-09 cCaminhoEXE := GetCurrentDir;
  try
    while FileExists(pChar(AcArquivo+'.pdf')) do
    begin
      try
        DeleteFile(pChar(AcArquivo+'.pdf'));
        DeleteFile(pChar(AcArquivo+'_.pdf'));
      except end;
      Sleep(10);
    end;
    chdir(pChar(cCaminhoEXE + 'HTMLtoPDF')); // Sandro Silva 2023-10-09 chdir(pChar(cCaminhoEXE+'\HTMLtoPDF'));
    while FileExists(pChar('tempo_ok.pdf')) do
    begin
      DeleteFile(pChar('tempo_ok.pdf'));
      Sleep(10);
    end;
    while FileExists(pChar('tempo.pdf')) do
    begin
      DeleteFile(pChar('tempo.pdf'));
      Sleep(10);
    end;
    // Sandro Silva 2019-09-25 inicio
    // Ref. ficha depuração 4713
    // Precisa excluir o orçamento*.pdf antigo para ser substituído pelo novo com os dados atualizados
    // Tenta renomear se falhar a exclusão por estar aberto no visualizador de pdf
    if FileExists(pChar(cCaminhoEXE + AcArquivo + '.pdf')) then // Sandro Silva 2023-10- 09 if FileExists(pChar(cCaminhoEXE+'\'+AcArquivo+'.pdf')) then
    begin
      if DeleteFile(pChar(cCaminhoEXE + AcArquivo + '.pdf')) = False then // Sandro Silva 2023-10-09 if DeleteFile(pChar(cCaminhoEXE+'\'+AcArquivo+'.pdf')) = False then
      begin
        RenameFile(pChar(cCaminhoEXE + AcArquivo + '.pdf'), pChar(cCaminhoEXE + AcArquivo + '_' + LimpaNumero(TimeToStr(Time)) + '.pdf')); // Sandro Silva 2023-10-09RenameFile(pChar(cCaminhoEXE+'\'+AcArquivo+'.pdf'), pChar(cCaminhoEXE+'\'+AcArquivo+'_'+LimpaNumero(TimeToStr(Time))+'.pdf'));
      end;
    end;
    // Sandro Silva 2019-09-25 fim

    ShellExecute(0, 'runas', pChar('html2pdf'), pchar('"'+cCaminhoEXE + AcArquivo + '.htm" "tempo.pdf"'), '', SW_HIDE); // Sandro Silva 2023-10-09ShellExecute( 0, 'runas', pChar('html2pdf'),pchar('"'+cCaminhoEXE+'\'+AcArquivo+'.htm" "tempo.pdf"'), '', SW_HIDE);
    Sleep(10);
    while not FileExists(pChar(cCaminhoEXE + 'HTMLtoPDF\tempo_ok.pdf')) do // Sandro Silva 2023-10-09 while not FileExists(pChar(cCaminhoEXE+'\HTMLtoPDF\tempo_ok.pdf')) do
    begin
      RenameFile(pChar(cCaminhoEXE + 'HTMLtoPDF\tempo.pdf'),pChar(cCaminhoEXE+'\HTMLtoPDF\tempo_ok.pdf')); // Sandro Silva 2023-10-09 RenameFile(pChar(cCaminhoEXE+'\HTMLtoPDF\tempo.pdf'),pChar(cCaminhoEXE+'\HTMLtoPDF\tempo_ok.pdf'));
      Sleep(10);
    end;
    chdir(pChar(cCaminhoEXE));
    CopyFile(pChar(cCaminhoEXE + 'HTMLtoPDF\tempo_ok.pdf'), pChar(cCaminhoEXE+'\'+AcArquivo+'_.pdf'),False); // Sandro Silva 2023-10-09 CopyFile(pChar(cCaminhoEXE+'\HTMLtoPDF\tempo_ok.pdf'), pChar(cCaminhoEXE+'\'+AcArquivo+'_.pdf'),False);
    while not FileExists(pChar(cCaminhoEXE + AcArquivo + '.pdf')) do // Sandro Silva 2023-10-09 while not FileExists(pChar(cCaminhoEXE+'\'+AcArquivo+'.pdf')) do
    begin
      RenameFile(pChar(cCaminhoEXE + AcArquivo + '_.pdf'), pChar(cCaminhoEXE + AcArquivo + '.pdf')); // Sandro Silva 2023-10-09 RenameFile(pChar(cCaminhoEXE+'\'+AcArquivo+'_.pdf'), pChar(cCaminhoEXE+'\'+AcArquivo+'.pdf'));
      Sleep(10);
    end;
  except end;
  Result := True;
end;

end.
