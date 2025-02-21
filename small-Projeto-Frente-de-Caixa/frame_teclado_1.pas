unit frame_teclado_1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFrame_teclado = class(TFrame)
    PAnel1: TPanel;
    Image4: TImage;
    touch_backspace: TImage;
    Label15: TLabel;
    Label2: TLabel;
    touch_menos: TImage;
    Label24: TLabel;
    Label17: TLabel;
    touch_9: TImage;
    Label16: TLabel;
    touch_8: TImage;
    Label3: TLabel;
    touch_7: TImage;
    touch_4: TImage;
    Label25: TLabel;
    Label26: TLabel;
    touch_5: TImage;
    Label27: TLabel;
    touch_6: TImage;
    touch_1: TImage;
    Label29: TLabel;
    touch_2: TImage;
    Label30: TLabel;
    Label31: TLabel;
    touch_3: TImage;
    Label32: TLabel;
    touch_0: TImage;
    Label33: TLabel;
    touch_virgula: TImage;
    touch_enter: TImage;
    Label28: TLabel;
    touch_asterisco: TImage;
    Label1: TLabel;
    Image1: TImage;
    Label4: TLabel;
    Image2: TImage;
    Label5: TLabel;
    Image3: TImage;
    Label6: TLabel;
    Image5: TImage;
    Label7: TLabel;
    Image6: TImage;
    Label8: TLabel;
    Image7: TImage;
    Image8: TImage;
    Label9: TLabel;
    Label10: TLabel;
    Image9: TImage;
    Label11: TLabel;
    Image10: TImage;
    Label12: TLabel;
    Image11: TImage;
    Image12: TImage;
    Label13: TLabel;
    Label14: TLabel;
    Image13: TImage;
    Label18: TLabel;
    Label19: TLabel;
    Image14: TImage;
    Label20: TLabel;
    Image15: TImage;
    Label21: TLabel;
    Image16: TImage;
    Image17: TImage;
    Label22: TLabel;
    Label23: TLabel;
    Image18: TImage;
    Label34: TLabel;
    Image19: TImage;
    Label35: TLabel;
    Image20: TImage;
    Label36: TLabel;
    Image21: TImage;
    Label37: TLabel;
    Image22: TImage;
    Label38: TLabel;
    Image23: TImage;
    Image24: TImage;
    Label39: TLabel;
    Image25: TImage;
    Label40: TLabel;
    Image26: TImage;
    Label41: TLabel;
    Image27: TImage;
    Label42: TLabel;
    Image28: TImage;
    Label43: TLabel;
    Image29: TImage;
    Label44: TLabel;
    Image30: TImage;
    Label45: TLabel;
    Image31: TImage;
    Image32: TImage;
    Label46: TLabel;
    Label47: TLabel;
    Image33: TImage;
    Label48: TLabel;
    Image34: TImage;
    Label49: TLabel;
    Image35: TImage;
    Label50: TLabel;
    Image36: TImage;
    Label51: TLabel;
    Image37: TImage;
    Label52: TLabel;
    Image38: TImage;
    Label53: TLabel;
    Image39: TImage;
    Label54: TLabel;
    Image40: TImage;
    Label55: TLabel;
    Image41: TImage;
    Label56: TLabel;
    Image42: TImage;
    Label57: TLabel;
    Image43: TImage;
    Label58: TLabel;
    Image44: TImage;
    Label59: TLabel;
    Image45: TImage;
    Label60: TLabel;
    Image46: TImage;
    Label61: TLabel;
    Image47: TImage;
    Label62: TLabel;
    Image48: TImage;
    Image49: TImage;
    Image_led_verde: TImage;
    Image_led_vermelho: TImage;
    Timer1: TTimer;
    Led_FISCAL: TImage;
    Led_ECF: TImage;
    Led_REDE: TImage;
    ImageFundo2: TImage;
    procedure touch_backspaceClick(Sender: TObject);
    procedure touch_menosClick(Sender: TObject);
    procedure touch_7Click(Sender: TObject);
    procedure touch_8Clic(Sender: TObject);
    procedure touch_9Click(Sender: TObject);
    procedure touch_asteriscoClick(Sender: TObject);
    procedure touch_enterClick(Sender: TObject);
    procedure touch_4Click(Sender: TObject);
    procedure touch_5Click(Sender: TObject);
    procedure touch_6Click(Sender: TObject);
    procedure touch_1Click(Sender: TObject);
    procedure touch_2Click(Sender: TObject);
    procedure touch_3Click(Sender: TObject);
    procedure touch_0Click(Sender: TObject);
    procedure touch_virgulaClick(Sender: TObject);
    procedure Image24Click(Sender: TObject);
    procedure Image16Click(Sender: TObject);
    procedure Image17Click(Sender: TObject);
    procedure Image18Click(Sender: TObject);
    procedure Image19Click(Sender: TObject);
    procedure Image20Click(Sender: TObject);
    procedure Image21Click(Sender: TObject);
    procedure Image22Click(Sender: TObject);
    procedure Image27Click(Sender: TObject);
    procedure Image28Click(Sender: TObject);
    procedure Image29Click(Sender: TObject);
    procedure Image30Click(Sender: TObject);
    procedure Image31Click(Sender: TObject);
    procedure Image32Click(Sender: TObject);
    procedure Image33Click(Sender: TObject);
    procedure Image34Click(Sender: TObject);
    procedure Image35Click(Sender: TObject);
    procedure Image38Click(Sender: TObject);
    procedure Image39Click(Sender: TObject);
    procedure Image40Click(Sender: TObject);
    procedure Image41Click(Sender: TObject);
    procedure Image42Click(Sender: TObject);
    procedure Image43Click(Sender: TObject);
    procedure Image44Click(Sender: TObject);
    procedure Image49Click(Sender: TObject);
    procedure Image25Click(Sender: TObject);
    procedure Image14Click(Sender: TObject);
    procedure Image15Click(Sender: TObject);
    procedure Image45Click(Sender: TObject);
    procedure Image46Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure Image8Click(Sender: TObject);
    procedure Image9Click(Sender: TObject);
    procedure Image10Click(Sender: TObject);
    procedure Image11Click(Sender: TObject);
    procedure Image12Click(Sender: TObject);
    procedure Image13Click(Sender: TObject);
    procedure Image48Click(Sender: TObject);
    procedure Image23Click(Sender: TObject);
    procedure Image36Click(Sender: TObject);
    procedure Image26Click(Sender: TObject);
    procedure Image37Click(Sender: TObject);
    procedure Image47Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    //procedure ImageFundo2Click(Sender: TObject);
  private
    { Private declarations }
    procedure CMShowingChanged(var M: TMessage); message CM_SHOWINGCHANGED;
  public
    { Public declarations }
  end;

implementation

uses fiscal;

{$R *.dfm}

procedure TFrame_teclado.touch_backspaceClick(Sender: TObject);
begin
  Inherited;
  keybd_event(vk_back, 0, 0, 0);
  keybd_event(vk_back, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.touch_menosClick(Sender: TObject);
begin
  Inherited;
  Screen.ActiveForm.ActiveControl.Perform(WM_CHAR, 45, 0);
end;

procedure TFrame_teclado.touch_7Click(Sender: TObject);
begin
  Inherited;
  keybd_event(55, 0, 0, 0);
  keybd_event(55, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.touch_8Clic(Sender: TObject);
begin
  Inherited;
  keybd_event(56, 0, 0, 0);
  keybd_event(56, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.touch_9Click(Sender: TObject);
begin
  Inherited;
  keybd_event(57, 0, 0, 0);
  keybd_event(57, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.touch_asteriscoClick(Sender: TObject);
begin
  Inherited;
  Screen.ActiveForm.ActiveControl.Perform(WM_CHAR, 42, 0);
end;


procedure TFrame_teclado.touch_enterClick(Sender: TObject);
begin
  Inherited;
  keybd_event(VK_RETURN, 0, 0, 0);
  keybd_event(VK_RETURN, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.touch_4Click(Sender: TObject);
begin
  Inherited;
  keybd_event(52, 0, 0, 0);
  keybd_event(52, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.touch_5Click(Sender: TObject);
begin
  Inherited;
  keybd_event(53, 0, 0, 0);
  keybd_event(53, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.touch_6Click(Sender: TObject);
begin
  Inherited;
  keybd_event(54, 0, 0, 0);
  keybd_event(54, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.touch_1Click(Sender: TObject);
begin
  Inherited;
  keybd_event(49, 0, 0, 0);
  keybd_event(49, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.touch_2Click(Sender: TObject);
begin
  Inherited;
  keybd_event(50, 0, 0, 0);
  keybd_event(50, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.touch_3Click(Sender: TObject);
begin
  Inherited;
  keybd_event(51, 0, 0, 0);
  keybd_event(51, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.touch_0Click(Sender: TObject);
begin
  Inherited;
  keybd_event(48, 0, 0, 0);
  keybd_event(48, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.touch_virgulaClick(Sender: TObject);
begin
  Inherited;
  Screen.ActiveForm.ActiveControl.Perform(WM_CHAR, 44, 0);
end;

procedure TFrame_teclado.Image24Click(Sender: TObject);
begin
  Inherited;
  keybd_event(VK_ESCAPE, 0, 0, 0);
  keybd_event(VK_ESCAPE, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image16Click(Sender: TObject);
begin
  Inherited;
  keybd_event(69, 0, 0, 0);
  keybd_event(69, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image17Click(Sender: TObject);
begin
  Inherited;
  keybd_event(84, 0, 0, 0);
  keybd_event(84, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image18Click(Sender: TObject);
begin
  Inherited;
  keybd_event(89, 0, 0, 0);
  keybd_event(89, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image19Click(Sender: TObject);
begin
  Inherited;
  keybd_event(85, 0, 0, 0);
  keybd_event(85, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image20Click(Sender: TObject);
begin
  Inherited;
  keybd_event(73, 0, 0, 0);
  keybd_event(73, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image21Click(Sender: TObject);
begin
  Inherited;
  keybd_event(79, 0, 0, 0);
  keybd_event(79, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image22Click(Sender: TObject);
begin
  Inherited;
  keybd_event(80, 0, 0, 0);
  keybd_event(80, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image27Click(Sender: TObject);
begin
  Inherited;
  keybd_event(65, 0, 0, 0);
  keybd_event(65, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image28Click(Sender: TObject);
begin
  Inherited;
  keybd_event(83, 0, 0, 0);
  keybd_event(83, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image29Click(Sender: TObject);
begin
  Inherited;
  keybd_event(68, 0, 0, 0);
  keybd_event(68, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image30Click(Sender: TObject);
begin
  Inherited;
  keybd_event(70, 0, 0, 0);
  keybd_event(70, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image31Click(Sender: TObject);
begin
  Inherited;
  keybd_event(71, 0, 0, 0);
  keybd_event(71, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image32Click(Sender: TObject);
begin
  Inherited;
  keybd_event(72, 0, 0, 0);
  keybd_event(72, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image33Click(Sender: TObject);
begin
  Inherited;
  keybd_event(74, 0, 0, 0);
  keybd_event(74, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image34Click(Sender: TObject);
begin
  Inherited;
  keybd_event(75, 0, 0, 0);
  keybd_event(75, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image35Click(Sender: TObject);
begin
  Inherited;
  keybd_event(76, 0, 0, 0);
  keybd_event(76, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image38Click(Sender: TObject);
begin
  Inherited;
  keybd_event(90, 0, 0, 0);
  keybd_event(90, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image39Click(Sender: TObject);
begin
  Inherited;
  keybd_event(88, 0, 0, 0);
  keybd_event(88, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image40Click(Sender: TObject);
begin
  Inherited;
  keybd_event(67, 0, 0, 0);
  keybd_event(67, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image41Click(Sender: TObject);
begin
  Inherited;
  keybd_event(86, 0, 0, 0);
  keybd_event(86, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image42Click(Sender: TObject);
begin
  Inherited;
  keybd_event(66, 0, 0, 0);
  keybd_event(66, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image43Click(Sender: TObject);
begin
  Inherited;
  keybd_event(78, 0, 0, 0);
  keybd_event(78, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image44Click(Sender: TObject);
begin
  Inherited;
  keybd_event(77, 0, 0, 0);
  keybd_event(77, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image49Click(Sender: TObject);
begin
  Inherited;
  keybd_event(32, 0, 0, 0);
  keybd_event(32, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image25Click(Sender: TObject);
begin
  Inherited;
  keybd_event(82, 0, 0, 0);
  keybd_event(82, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image14Click(Sender: TObject);
begin
  Inherited;
  keybd_event(81, 0, 0, 0);
  keybd_event(81, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image15Click(Sender: TObject);
begin
  Inherited;
  keybd_event(87, 0, 0, 0);
  keybd_event(87, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image45Click(Sender: TObject);
begin
  Inherited;
  keybd_event(44, 0, 0, 0);
  keybd_event(44, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image46Click(Sender: TObject);
begin
  Inherited;
  keybd_event(46, 0, 0, 0);
  keybd_event(46, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image1Click(Sender: TObject);
begin
  Inherited;
  keybd_event(33, 0, 0, 0);
  keybd_event(33, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image2Click(Sender: TObject);
begin
  Inherited;
  keybd_event(64, 0, 0, 0);
  keybd_event(64, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image3Click(Sender: TObject);
begin
  Inherited;
  keybd_event(35, 0, 0, 0);
  keybd_event(35, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image5Click(Sender: TObject);
begin
  Inherited;
  keybd_event(36, 0, 0, 0);
  keybd_event(36, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image6Click(Sender: TObject);
begin
  Inherited;
  keybd_event(37, 0, 0, 0);
  keybd_event(37, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image7Click(Sender: TObject);
begin
  Inherited;
  keybd_event(58, 0, 0, 0);
  keybd_event(58, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);

end;

procedure TFrame_teclado.Image8Click(Sender: TObject);
begin
  Inherited;
  keybd_event(38, 0, 0, 0);
  keybd_event(38, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);

end;

procedure TFrame_teclado.Image9Click(Sender: TObject);
begin
  Inherited;
  keybd_event(42, 0, 0, 0);
  keybd_event(42, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image10Click(Sender: TObject);
begin
  Inherited;
  keybd_event(40, 0, 0, 0);
  keybd_event(40, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image11Click(Sender: TObject);
begin
  Inherited;
  keybd_event(41, 0, 0, 0);
  keybd_event(41, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image12Click(Sender: TObject);
begin
  Inherited;
  keybd_event(45, 0, 0, 0);
  keybd_event(45, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);

end;

procedure TFrame_teclado.Image13Click(Sender: TObject);
begin
  Inherited;
  keybd_event(61, 0, 0, 0);
  keybd_event(61, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);

end;

procedure TFrame_teclado.Image48Click(Sender: TObject);
begin
  Inherited;
  keybd_event(63, 0, 0, 0);
  keybd_event(63, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image23Click(Sender: TObject);
begin
  Inherited;
  keybd_event(39, 0, 0, 0);
  keybd_event(39, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image36Click(Sender: TObject);
begin
  Inherited;
  keybd_event(126, 0, 0, 0);
  keybd_event(126, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image26Click(Sender: TObject);
begin
  Inherited;
  keybd_event(VK_TAB, 0, 0, 0);
  keybd_event(VK_TAB, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Image37Click(Sender: TObject);
begin
  Inherited;
  keybd_event(VK_SHIFT, 0, 0, 0);
end;

procedure TFrame_teclado.Image47Click(Sender: TObject);
begin
  Inherited;
  keybd_event(VK_CAPITAL, 0, 0, 0);
  keybd_event(VK_CAPITAL, 0, KEYEVENTF_KEYUP, 0); keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TFrame_teclado.Timer1Timer(Sender: TObject);
begin
  //
  if GetKeyState(VK_CAPITAL) <> 0 then
  begin
    Image_Led_Verde.Visible    := False;
    Image_Led_vermelho.Visible := True;
  end else
  begin
    Image_Led_vermelho.Visible := False;
    Image_Led_Verde.Visible    := True;
  end;
  //
end;

procedure TFrame_teclado.CMShowingChanged(var M: TMessage);
var
  iObj: Integer;
  //iAltura: Integer;
begin
 inherited;

  {Sandro Silva 2016-08-15 inicio}
  if Showing then
  begin
    // Put your OnShow logic here.
    // When this is called, the frame's window handle has already
    // been created, as have the handles for the controls on the
    // frame - so you can do most anything you need to do.
    Image4.Picture             := Form1.Frame_teclado1.Image4.Picture;
    Image_led_vermelho.Picture := Form1.Frame_teclado1.Image_led_vermelho.Picture;
    Image_led_verde.Picture    := Form1.Frame_teclado1.Image_led_verde.Picture;

    {Sandro Silva 2016-08-18 inicio}
    //if FileExists(Form1.sAtual+'\inicial\frente\'+IntToStr(Screen.Width)+'x'+IntToStr(Screen.Height)+'\fundo1.bmp') then
    if FileExists(Form1.sAtual+'\inicial\frente\fundo_b_'+IntToStr(Screen.Width)+'x'+IntToStr(Screen.Height)+'.bmp') then
    begin
      Image_led_vermelho.Transparent := True;
      Image_led_verde.Transparent    := True;
      Led_FISCAL.Transparent         := True;
      Led_ECF.Transparent            := True;
      Led_REDE.Transparent           := True;
    end;

    // Sandro Silva 2017-10-23  iAltura := Label4.Canvas.TextHeight('@') + 2;
    for iObj := 0 to Panel1.Parent.ComponentCount - 1 do
    begin
      if Panel1.Parent.Components[iObj].ClassType = TLabel then
      begin
        TLabel(Panel1.Parent.Components[iObj]).AutoSize := True; // Sandro Silva 2017-10-23
        // Sandro Silva 2017-10-23  TLabel(Panel1.Parent.Components[iObj]).Height := iAltura; //Form1.AjustaAltura(iAltura);
      end;
    end;
    {Sandro Silva 2016-08-18 final}

    {Sandro Silva 2021-08-06 inicio}
    // Led são quadrados, AjustaResolucao() distorce quando são ajustados
    Led_FISCAL.Height := Led_FISCAL.Width;
    Led_ECF.Height    := Led_ECF.Width;
    Led_REDE.Height   := Led_REDE.Width;
    Image_led_vermelho.Height := Image_led_vermelho.Width;
    Image_led_verde.Height    := Image_led_verde.Width;     
    {Sandro Silva 2021-08-06 fim}

  end
  else
  begin
    // Put your OnHide logic here, but see the caveats below.
  end;
  {Sandro Silva 2016-08-15 final}
end;

{
procedure TFrame_teclado.ImageFundo2Click(Sender: TObject);
var
  r1: tRect;
begin
  if FileExists(Form1.sAtual+'\inicial\frente\'+IntToStr(Screen.Width)+'x'+IntToStr(Screen.Height)+'\fundo2.bmp') then
  begin
    //
    (Sender as TImage).Picture.LoadFromFile(Form1.sAtual+'\inicial\frente\'+IntToStr(Screen.Width)+'x'+IntToStr(Screen.Height)+'\fundo2.bmp');
    //
    //  Lê as imagens Fundo principal
    //
    r1.Left    := Form1.AjustaLargura(29);
    r1.Top     := Form1.AjustaAltura(458); // Sandro Silva 2016-08-18  Form1.AjustaAltura(460);
    r1.Right   := Form1.AjustaLargura(29 + 980);
    r1.Bottom  := Form1.AjustaAltura(458 + 290); // Sandro Silva 2016-08-18  Form1.AjustaAltura(460 + 290);
    //
    Image4.Picture  := (Sender as TImage).Picture;
    Image4.AutoSize := False;
    Image4.Stretch  := False;
    //
    Image4.Width    := r1.Right - r1.Left;
    Image4.Height   := r1.Bottom - r1.Top;
    //
    Image4.Picture.Bitmap := Form1.CortarImagem(Image4.Picture.Graphic, Bounds(0,0,Image4.Width,Image4.Height));
    Image4.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,Image4.Width,Image4.Height),(Sender as TImage).Picture.Bitmap.Canvas,R1);
    //
  end;
end;
}

end.
