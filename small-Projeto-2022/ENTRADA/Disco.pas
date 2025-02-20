unit Disco;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls;

type
  TBtnBottomDlg = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BtnBottomDlg: TBtnBottomDlg;

implementation

{$R *.DFM}

procedure TBtnBottomDlg.OKBtnClick(Sender: TObject);
begin
    close;
end;

end.
