unit uFrmSmallImput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, StdCtrls, Buttons, smallfunc_xe;

type
  TTipoCampo = (tpString,tpData,tpInteger,tpFloat);

type
  TFrmSmallImput = class(TFrmPadrao)
    btnOK: TBitBtn;
    edtValor: TEdit;
    lblDescricao: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtValorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtValorKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    TipoCamp : TTipoCampo;
  public
    { Public declarations }
  end;

var  
  vRetorno : string;

  function ImputBoxSmall(Titulo, Descricao:string;Valor:string;TipoCampo:TTipoCampo):string;

var
  FrmSmallImput: TFrmSmallImput;

implementation

{$R *.dfm}

function ImputBoxSmall(Titulo, Descricao:string;Valor:string;TipoCampo:TTipoCampo):string;
begin
  Result := '';
  vRetorno := '';

  try
    FrmSmallImput := TFrmSmallImput.Create(nil);
    FrmSmallImput.Caption := Titulo;
    FrmSmallImput.lblDescricao.Caption := Descricao;
    FrmSmallImput.edtValor.Text := Valor;
    FrmSmallImput.TipoCamp := TipoCampo;
    FrmSmallImput.ShowModal;
  finally
    Result := vRetorno;
    FreeAndNil(FrmSmallImput);
  end;
end;

procedure TFrmSmallImput.btnOKClick(Sender: TObject);
begin
  vRetorno := edtValor.Text;
  Close;
end;

procedure TFrmSmallImput.FormShow(Sender: TObject);
begin
  edtValor.SetFocus;
end;

procedure TFrmSmallImput.edtValorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Perform(Wm_NextDlgCtl,0,0);
end;

procedure TFrmSmallImput.edtValorKeyPress(Sender: TObject; var Key: Char);
begin
  if TipoCamp = tpInteger then
    ValidaValor(Sender,Key,'I');

  if TipoCamp = tpfloat then
    ValidaValor(Sender,Key,'F');
end;


end.
