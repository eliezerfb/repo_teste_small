//     local de pagamento ---> 1    4
//             vencimento ---> 1   51
//         data documento ---> 5    4
//              documento ---> 5   15
//      espécie documento ---> 5   32
//                 aceite ---> 5   36
//             processado ---> 5   39
//     valor do documento ---> 6   52
// linha 1 das instruções ---> 10   4
// linha 1 das instruções ---> 10   4
// linha 1 das instruções ---> 10   4
// linha 1 das instruções ---> 10   4
// linha 1 das instruções ---> 10   4
//         nome do sacado ---> 15   8
//     endereço do sacado ---> 15   8
//             CEP sacado ---> 15   8
//       cidade do sacado ---> 15   8
//       estado do sacado ---> 15   8
//          CGC do sacado ---> 15   8


unit Unit26;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ExtCtrls;

type
  TForm26 = class(TForm)
    Button2: TButton;
    Label27: TLabel;
    MaskEdit41: TMaskEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MaskEdit1: TMaskEdit;
    Label10: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    MaskEdit2: TMaskEdit;
    MaskEdit3: TMaskEdit;
    MaskEdit4: TMaskEdit;
    MaskEdit5: TMaskEdit;
    MaskEdit6: TMaskEdit;
    MaskEdit7: TMaskEdit;
    MaskEdit8: TMaskEdit;
    MaskEdit9: TMaskEdit;
    MaskEdit10: TMaskEdit;
    MaskEdit11: TMaskEdit;
    MaskEdit12: TMaskEdit;
    MaskEdit13: TMaskEdit;
    MaskEdit14: TMaskEdit;
    MaskEdit15: TMaskEdit;
    MaskEdit16: TMaskEdit;
    MaskEdit17: TMaskEdit;
    MaskEdit18: TMaskEdit;
    MaskEdit19: TMaskEdit;
    MaskEdit20: TMaskEdit;
    MaskEdit21: TMaskEdit;
    MaskEdit22: TMaskEdit;
    MaskEdit23: TMaskEdit;
    MaskEdit24: TMaskEdit;
    MaskEdit25: TMaskEdit;
    MaskEdit26: TMaskEdit;
    MaskEdit27: TMaskEdit;
    MaskEdit28: TMaskEdit;
    MaskEdit29: TMaskEdit;
    MaskEdit30: TMaskEdit;
    MaskEdit31: TMaskEdit;
    MaskEdit32: TMaskEdit;
    MaskEdit33: TMaskEdit;
    MaskEdit34: TMaskEdit;
    MaskEdit35: TMaskEdit;
    MaskEdit36: TMaskEdit;
    MaskEdit37: TMaskEdit;
    MaskEdit38: TMaskEdit;
    MaskEdit39: TMaskEdit;
    MaskEdit40: TMaskEdit;
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form26: TForm26;

implementation

uses Unit25;

{$R *.DFM}



procedure TForm26.FormActivate(Sender: TObject);
begin
  Form26.Caption := 'Configuração dos '+Form25.Caption;
end;


procedure TForm26.Button2Click(Sender: TObject);
begin
  Close;
end;





















end.
