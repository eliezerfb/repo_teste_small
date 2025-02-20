unit uRelatorioTotalGeralVenda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFormRelatorioPadrao, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  uIEstruturaTipoRelatorioPadrao, DB, DBClient;

type
  TfrmRelTotalizadorGeralVenda = class(TfrmRelatorioPadrao)
    pnlPrincipal: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    dtInicial: TDateTimePicker;
    dtFinal: TDateTimePicker;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAvancarClick(Sender: TObject);
  private
    function FazValidacoes: Boolean;
  public
  protected
    function Estrutura: IEstruturaTipoRelatorioPadrao; override;
  end;

var
  frmRelTotalizadorGeralVenda: TfrmRelTotalizadorGeralVenda;

implementation

{$R *.dfm}

uses
  uGeraRelatorioTotalizadorGeralVenda, uDialogs, uSmallResourceString;

function TfrmRelTotalizadorGeralVenda.Estrutura: IEstruturaTipoRelatorioPadrao;
begin
  Result := TGeraRelatorioTotalizadorGeralVenda.New
                                               .setTransaction(Transaction)
                                               .setPeriodo(dtInicial.Date, dtFinal.Date)
                                               .setUsuario(Usuario)
                                               .GeraRelatorio
                                               .getEstruturaRelatorio;
end;

function TfrmRelTotalizadorGeralVenda.FazValidacoes: Boolean;
begin
  Result := False;

  if ((dtInicial.Date = 0) or (dtFinal.Date = 0)) or (dtInicial.Date > dtFinal.Date) then
  begin
    MensagemSistema(_cPeriodoDataInvalida, msgAtencao);
    dtInicial.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TfrmRelTotalizadorGeralVenda.FormShow(Sender: TObject);
begin
  inherited;

  dtInicial.Date := FoArquivoDAT.Usuario.Outros.PeriodoInicial;
  dtFinal.Date   := FoArquivoDAT.Usuario.Outros.PeriodoFinal;  
end;

procedure TfrmRelTotalizadorGeralVenda.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FoArquivoDAT.Usuario.Outros.PeriodoInicial := dtInicial.Date;
  FoArquivoDAT.Usuario.Outros.PeriodoFinal   := dtFinal.Date;
  
  inherited;
end;

procedure TfrmRelTotalizadorGeralVenda.btnAvancarClick(Sender: TObject);
begin
  try
    btnAvancar.Enabled := False;
    if not FazValidacoes then
      Exit;
    inherited;
  finally
    btnAvancar.Enabled := True;
  end;
end;

end.
