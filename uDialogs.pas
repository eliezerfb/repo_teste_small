unit uDialogs;

interface

uses
  SysUtils
  , Windows
  , Forms
  ;

type
    TmensagemSis = (msgInformacao,msgAtencao,msgErro);

  procedure MensagemSistema(Mensagem:string; Tipo : TmensagemSis = msgInformacao); //Mauricio Parizotto 2023-10-24

implementation

procedure MensagemSistema(Mensagem:string; Tipo : TmensagemSis = msgInformacao);
begin
  case Tipo of
    msgInformacao:  Application.MessageBox(pChar(Mensagem), 'Informação', mb_Ok + MB_ICONINFORMATION);
    msgAtencao:     Application.MessageBox(pChar(Mensagem), 'Atenção', mb_Ok + MB_ICONWARNING);
    msgErro:        Application.MessageBox(pChar(Mensagem), 'Erro', mb_Ok + MB_ICONERROR);
  end;
end;

end.
