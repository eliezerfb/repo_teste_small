unit uDialogs;

interface

uses
  SysUtils
  , Windows
  , Forms
  , Controls, Vcl.Dialogs, Vcl.StdCtrls
//  , StdCtrls
//  , Dialogs
  ;

type
  TmensagemSis = (msgInformacao,msgAtencao,msgErro,msgPergunta);

  procedure MensagemSistema(Mensagem:string; Tipo : TmensagemSis = msgInformacao); //Mauricio Parizotto 2023-10-24
  function MensagemSistemaPergunta(AcMensagem:string; AaFlags: array of Longint): Integer; overload; // Dailon Parisotto 2023-02-01
  function MensagemSistemaPerguntaCustom(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; Captions: array of string): Integer; //Mauricio Parizotto 2024-06-13
//  function MensagemSistemaPergunta(AcMensagem: String; AaOpcoes: array of String): Integer; overload; // Dailon Parisotto 2023-02-01

implementation

function RetornarTituloMsg(AenTipo : TmensagemSis = msgInformacao): String;
begin
  case AenTipo of
    msgAtencao: Result := 'Atenção';
    msgErro: Result := 'Erro';
    msgPergunta: Result := RetornarTituloMsg(msgAtencao);
    else Result := 'Informação';
  end;
end;

function RetornarIconTipoMensagem(AenTipo : TmensagemSis = msgInformacao): Integer;
begin
  case AenTipo of
    msgAtencao: Result := MB_ICONWARNING;
    msgErro: Result := MB_ICONERROR;
    msgPergunta: Result := MB_ICONQUESTION;
    else Result := MB_ICONINFORMATION;
  end;
end;

procedure MensagemSistema(Mensagem:string; Tipo : TmensagemSis = msgInformacao);
begin
  Application.MessageBox(pChar(Mensagem), Pchar(RetornarTituloMsg(Tipo)), mb_Ok + RetornarIconTipoMensagem(Tipo));
end;

function MensagemSistemaPergunta(AcMensagem: String; AaFlags: array of Longint): Integer;
var
  i: Integer;
  nSomaFlags: Longint;
begin
  nSomaFlags := 0;
  for i := 0 to Pred(Length(AaFlags)) do
  begin
    // Nao soma se for MB_ICONQUESTION, depois e colocado automaticamente
    if AaFlags[i] <> MB_ICONQUESTION then
      nSomaFlags := nSomaFlags + AaFlags[i];
  end;
  // Adiciona MB_ICONQUESTION
  nSomaFlags := nSomaFlags + RetornarIconTipoMensagem(msgPergunta);

  Result := Application.MessageBox(PChar(AcMensagem), PChar(RetornarTituloMsg(msgPergunta)), nSomaFlags);
end;


// IMPLEMENTAR NO FUTURO - Mensagem com opções personalizadas
{
function MensagemSistemaPergunta(AcMensagem: String; AaOpcoes: array of String): Integer; overload;
var
  ofrmMsg: TForm;
  nBotoes: TMsgDlgButtons;
  oBotaoSim, oBotaoNao, oBotaoCancela: TButton;
begin
  nBotoes := mbYesNo;
  if Length(AaOpcoes) = 3 then
    nBotoes := mbYesNoCancel;

  ofrmMsg := CreateMessageDialog(AcMensagem, mtConfirmation, mbYesNoCancel);
  try
    ofrmMsg.Caption := RetornarTituloMsg(msgPergunta);
    ofrmMsg.Position := Self.Position;

    oBotaoSim := TButton(ofrmMsg.FindChildControl('Yes'));
    oBotaoSim.Caption := 'Federal';
    oBotaoSim.Width := Canvas.TextWidth(oBotaoSim.Caption) + 32;

    oBotaoNao := TButton(ofrmMsg.FindChildControl('No'));
    oBotaoNao.Caption := 'Estadual';
    oBotaoNao.Left := oBotaoSim.Left + oBotaoSim.Width + 16;
    oBotaoNao.Width := Canvas.TextWidth(oBotaoNao.Caption) + 32;

    if nBotoes = mbYesNoCancel then
    begin
      oBotaoCancela := TButton(ofrmMsg.FindChildControl('Cancel'));
      oBotaoCancela.Caption := 'Cancelar';
      oBotaoCancela.Left := oBotaoNao.Left + oBotaoNao.Width + 16;
      oBotaoCancela.Width := Canvas.TextWidth(oBotaoCancela.Caption) + 32;
    end;

    if ofrmMsg.Width < (oBotaoCancela.Left + oBotaoCancela.Width + oBotaoSim.Left) then
      ofrmMsg.Width := oBotaoCancela.Left + oBotaoCancela.Width + oBotaoSim.Left;

    Result := ofrmMsg.ShowModal;
  finally
    FreeAndNil(ofrmMsg);
  end;
end;

}

(*Sandro Silva 2024-07-24 inicio
Customizado o título a partir do tipo de mensagem
function MensagemSistemaPerguntaCustom(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; Captions: array of string): Integer;
var
  aMsgDlg: TForm;
  i: Integer;
  dlgButton: TButton;
  CaptionIndex: Integer;
begin
  { Criar o dialogo }
  aMsgDlg := CreateMessageDialog(Msg, DlgType, Buttons);
  aMsgDlg.Caption := 'Informação';

  CaptionIndex := 0;
  { Faz um loop varrendo os objetos do dialogo }
  for i := 0 to pred(aMsgDlg.ComponentCount) do
  begin
    if (aMsgDlg.Components[i] is TButton) then
    begin
      { Apenas entra na condição se o objeto for um button }
      dlgButton := TButton(aMsgDlg.Components[i]);
      if CaptionIndex > High(Captions) then //Captura o Index dos captions dos buttons criado no array
         Break;
      dlgButton.Caption := Captions[CaptionIndex];
      Inc(CaptionIndex);
    end;
  end;
  Result := aMsgDlg.ShowModal;
end;
*)
function MensagemSistemaPerguntaCustom(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; Captions: array of string): Integer;
var
  aMsgDlg: TForm;
  i: Integer;
  dlgButton: TButton;
  CaptionIndex: Integer;
begin
  { Criar o dialogo }
  aMsgDlg := CreateMessageDialog(Msg, DlgType, Buttons);
  aMsgDlg.BorderStyle := bsSizeable;
  aMsgDlg.BorderIcons := [];
  case DlgType of
    TMsgDlgType.mtConfirmation: aMsgDlg.Caption := 'Confirme';
    TMsgDlgType.mtError       : aMsgDlg.Caption := 'Erro';
    TMsgDlgType.mtInformation : aMsgDlg.Caption := 'Informação';
    TMsgDlgType.mtWarning     : aMsgDlg.Caption := 'Atenção';
  else
    aMsgDlg.Caption := '';
  end;

  CaptionIndex := 0;
  { Faz um loop varrendo os objetos do dialogo }
  for i := 0 to pred(aMsgDlg.ComponentCount) do
  begin
    if (aMsgDlg.Components[i] is TButton) then
    begin
      { Apenas entra na condição se o objeto for um button }
      dlgButton := TButton(aMsgDlg.Components[i]);
      if CaptionIndex > High(Captions) then //Captura o Index dos captions dos buttons criado no array
         Break;
      dlgButton.Caption := Captions[CaptionIndex];
      Inc(CaptionIndex);
    end;
  end;
  Result := aMsgDlg.ShowModal;
end;

end.
