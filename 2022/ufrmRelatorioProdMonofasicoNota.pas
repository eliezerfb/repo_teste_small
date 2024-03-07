unit ufrmRelatorioProdMonofasicoNota;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFormRelatorioPadrao, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls, uIEstruturaTipoRelatorioPadrao;

type
  TfrmRelProdMonofasicoNota = class(TfrmRelatorioPadrao)
    pnlPrincipal: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    dtInicial: TDateTimePicker;
    dtFinal: TDateTimePicker;
    procedure btnAvancarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    function FazValidacoes: Boolean;
  public
  protected
    function Estrutura: IEstruturaTipoRelatorioPadrao; override;
  end;

var
  frmRelProdMonofasicoNota: TfrmRelProdMonofasicoNota;

implementation

{$R *.dfm}

uses
  uDialogs, uSmallResourceString, uGeraRelatorioProdMonofasicoNota;

procedure TfrmRelProdMonofasicoNota.btnAvancarClick(Sender: TObject);
begin
  if not FazValidacoes then
    Exit;
  inherited;
end;

function TfrmRelProdMonofasicoNota.Estrutura: IEstruturaTipoRelatorioPadrao;
begin
  Result := TGeraRelatorioProdMonofasicoNota.New
                                            .setTransaction(Transaction)
                                            .setPeriodo(dtInicial.Date, dtFinal.Date)
                                            .SetUsuario(Usuario)
                                            .GeraRelatorio
                                            .getEstruturaRelatorio;
end;

function TfrmRelProdMonofasicoNota.FazValidacoes: Boolean;
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

procedure TfrmRelProdMonofasicoNota.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FoArquivoDAT.Usuario.Outros.PeriodoInicial := dtInicial.Date;
  FoArquivoDAT.Usuario.Outros.PeriodoFinal   := dtFinal.Date;

  inherited;
end;

procedure TfrmRelProdMonofasicoNota.FormShow(Sender: TObject);
begin
  inherited;

  dtInicial.Date := FoArquivoDAT.Usuario.Outros.PeriodoInicial;
  dtFinal.Date   := FoArquivoDAT.Usuario.Outros.PeriodoFinal;
end;

end.
