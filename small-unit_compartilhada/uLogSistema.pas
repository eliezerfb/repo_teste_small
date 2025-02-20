unit uLogSistema;

interface

uses
  SysUtils
  , Windows
  , Forms
  , uArquivosDAT
  {$IFDEF VER150}
  , SmallFunc
  {$ELSE}
  , smallfunc_xe
  {$ENDIF}
  ;

var
  GeraLogSistema : Boolean; //Deve ser alimentada essa variavel ao iniciar sistema

type
    TLogSistema = (lgInformacao,lgAtencao,lgErro);

    procedure LogSistema(Log:string; Tipo : TLogSistema = lgErro); //Mauricio Parizotto 2023-11-27

implementation

uses uDialogs;

procedure LogSistema(Log:string; Tipo : TLogSistema = lgErro);
var
  TipoL, LogFormatado, DirArquivo, NomeArquivo : string;
  arq: TextFile;
begin
  //Verifica se precisa ser gerado
  if not GeraLogSistema then
    Exit;

  case Tipo of
    lgInformacao:  TipoL := 'Informação';
    lgAtencao:     TipoL := 'Atenção';
    lgErro:        TipoL := 'Erro';
  end;

  //Remove quebras de linha
  Log := StringReplace(Log,#13,'',[rfReplaceAll]);
  Log := StringReplace(Log,#10,'',[rfReplaceAll]);

  LogFormatado := FormatDateTime('dd/mm/yyyy HH:nn:ss.zzzz', Now)+';'+TipoL+';'+Log;

  DirArquivo := ExtractFileDir(Application.ExeName)+'\log\sistema\';

  try
    if not DirectoryExists(DirArquivo) then
      CreateDir(DirArquivo);

    NomeArquivo := 'Log_'+SysComputerName+'_'+FormatDateTime('yyyy-mm-dd', Date)+'.txt';

    AssignFile(arq,DirArquivo+NomeArquivo);

    {$I-} // desativa a diretiva de Input

    if FileExists(DirArquivo+NomeArquivo) then
      Append(arq) // Abre o arquivo texto
    else
      Rewrite(arq); // Cria arquivo

    {$I+} // ativa a diretiva de Input
    
    if (IOResult <> 0) then // verifica o resultado da operação de abertura
    begin
      MensagemSistema('Problema ao salvar log do sistema. '+#13#10+
                      Log
                      ,msgAtencao);
    end else
    begin
      WriteLn (arq, LogFormatado); //lê uma linha do arquivo
      CloseFile(arq); //fecha o arquivo
    end;


  except
    on e:exception do
      MensagemSistema('Erro ao salvar log do sistema. '+#13#10+
                      Log+#13#10+
                      e.Message
                      ,msgErro);
  end;
end;


end.
