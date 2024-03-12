unit uConfiguracaoTEFCommerce;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmPadrao, uframeConfiguraTEF,
  Vcl.StdCtrls;

type
  TfrmConfiguracaoTEFCommerce = class(TFrmPadrao)
    frameConfiguracao: TframeConfiguraTEF;
    procedure frameConfiguraTEF1btnCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure frameConfiguracaobtnOKClick(Sender: TObject);
  private
  public
  end;

var
  frmConfiguracaoTEFCommerce: TfrmConfiguracaoTEFCommerce;

implementation

{$R *.dfm}

procedure TfrmConfiguracaoTEFCommerce.FormCreate(Sender: TObject);
begin
  inherited;

  frameConfiguracao.CriarObjetos;
end;

procedure TfrmConfiguracaoTEFCommerce.FormDestroy(Sender: TObject);
begin
  frameConfiguracao.LimparObjetos;
  inherited;
end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaobtnOKClick(
  Sender: TObject);
begin
  frameConfiguracao.btnOKClick(Sender);

  if frameConfiguracao.Salvou then
    Close;
end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguraTEF1btnCancelarClick(
  Sender: TObject);
begin
  inherited;
  Self.Close;
end;

end.
