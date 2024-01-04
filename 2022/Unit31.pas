unit Unit31;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ExtCtrls, IniFiles, smallfunc_xe;

type
  TForm31 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    MaskEdit1: TMaskEdit;
    MaskEdit2: TMaskEdit;
    MaskEdit3: TMaskEdit;
    MaskEdit4: TMaskEdit;
    MaskEdit5: TMaskEdit;
    MaskEdit6: TMaskEdit;
    MaskEdit7: TMaskEdit;
    MaskEdit8: TMaskEdit;
    MaskEdit21: TMaskEdit;
    MaskEdit22: TMaskEdit;
    MaskEdit23: TMaskEdit;
    MaskEdit24: TMaskEdit;
    MaskEdit25: TMaskEdit;
    MaskEdit26: TMaskEdit;
    MaskEdit27: TMaskEdit;
    MaskEdit28: TMaskEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    MaskEdit9: TMaskEdit;
    MaskEdit10: TMaskEdit;
    procedure MaskEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form31: TForm31;

implementation

uses Mais, Unit7;

{$R *.DFM}


procedure TForm31.MaskEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_DOWN   then Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_UP     then Perform(Wm_NextDlgCtl,1,0);
end;

procedure TForm31.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Mais1Ini: TIniFile;
begin
  try
    Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
    Mais1Ini.WriteString(Form7.Caption,'Dígitos no ano','0'+LimpaNumero(Form31.MaskEdit9.Text)); //      valor -  2
    Mais1Ini.WriteString(Form7.Caption,'Página','0'+LimpaNumero(Form31.MaskEdit10.Text)); //      valor -  30
    Mais1Ini.Free;
  except end;
  //
end;

end.



//   LinhaValor:=1;
//   ColunaValor:=60;
//   LinhaExtenso1:=4;
//   ColunaExtenso1:=12;
//   LinhaExtenso2:=6;
//   ColunaExtenso2:=5;
//   LinhaNominal:=8;
//   ColunaNominal:=5;
//   LinhaCidade:=10;
//   ColunaCidade:=31;
//   LinhaDia:=10;
//   ColunaDia:=52;
//   LinhaMes:=10;
//   ColunaMes:=58;
//   LinhaAno:=10;
//   ColunaAno:=75;

