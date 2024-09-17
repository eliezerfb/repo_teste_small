unit ufrmRelatorioMovItensPeriodo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFormRelatorioPadrao, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TfrmRelatorioMovItensPeriodo = class(TfrmRelatorioPadrao)
    pnlPrincipal: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    dtInicial: TDateTimePicker;
    dtFinal: TDateTimePicker;
    procedure btnAvancarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function FazValidacoes: Boolean;
  public
  end;

var
  frmRelatorioMovItensPeriodo: TfrmRelatorioMovItensPeriodo;

implementation

{$R *.dfm}

uses
  uDialogs, uSmallResourceString, uSmallConsts, uVisualizaCadastro;

procedure TfrmRelatorioMovItensPeriodo.btnAvancarClick(Sender: TObject);
begin
  if not FazValidacoes then
    Exit;

  GeraVisualizacaoFichaCadastro;

  Self.Close;
end;

function TfrmRelatorioMovItensPeriodo.FazValidacoes: Boolean;
begin
  Result := False;

  if ((dtInicial.Date = 0) or (dtFinal.Date = 0)) or (dtInicial.Date > dtFinal.Date) then
  begin
    MensagemSistema(_cPeriodoDataInvalida,msgAtencao);
    dtInicial.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TfrmRelatorioMovItensPeriodo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FoArquivoDAT.Usuario.Outros.PeriodoInicial := dtInicial.Date;
  FoArquivoDAT.Usuario.Outros.PeriodoFinal   := dtFinal.Date;
  inherited;
end;

procedure TfrmRelatorioMovItensPeriodo.FormShow(Sender: TObject);
begin
  inherited;

  dtInicial.Date := FoArquivoDAT.Usuario.Outros.PeriodoInicial;
  dtFinal.Date   := FoArquivoDAT.Usuario.Outros.PeriodoFinal;
end;

end.
