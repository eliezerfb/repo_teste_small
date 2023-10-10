unit uRelatorioVendasClliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFormRelatorioPadrao, StdCtrls, ComCtrls, Buttons, ExtCtrls,
  uIEstruturaTipoRelatorioPadrao, CheckLst;

type
  TfrmRelVendasPorCliente = class(TfrmRelatorioPadrao)
    pnlSelOperacoes: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    chkOperacoes: TCheckListBox;
    btnMarcarTodosOper: TBitBtn;
    btnDesmarcarTodosOper: TBitBtn;
    pnlPrincipal: TPanel;
    Label2: TLabel;
    dtInicial: TDateTimePicker;
    Label3: TLabel;
    dtFinal: TDateTimePicker;
    gbTipoRelatorio: TGroupBox;
    cbNota: TCheckBox;
    cbCupom: TCheckBox;
    cbItemAItem: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnMarcarTodosOperClick(Sender: TObject);
    procedure btnDesmarcarTodosOperClick(Sender: TObject);
    procedure btnAvancarClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FlsItensOperacoes: TStringList;
    function FazValidacoes: Boolean;
    procedure AjustaLayout;
    function RetornarItensMarcadosOperacao: TStringList;
  public
  protected
    function Estrutura: IEstruturaTipoRelatorioPadrao; override;
  end;

var
  frmRelVendasPorCliente: TfrmRelVendasPorCliente;

implementation

uses
  SmallFunc, uEstruturaRelVendasPorCliente, uSmallResourceString,
  uRetornaOperacoesRelatorio, uUsuarioSections;

{$R *.dfm}

{ TfrmRelVendasPorCliente }

function TfrmRelVendasPorCliente.Estrutura: IEstruturaTipoRelatorioPadrao;
begin
  Result := TEstruturaRelVendasPorCliente.New
                                         .setUsuario(Usuario)
                                         .SetDataBase(DataBase)
                                         .setItemAItem(cbItemAItem.Checked)
                                         .setDataInicial(dtInicial.Date)
                                         .setDataFinal(dtFinal.Date)
                                         .setOperacoes(RetornarItensMarcadosOperacao)
                                         .ImprimeNota(cbNota.Checked)
                                         .ImprimeCupom(cbCupom.Checked)
                                         .Estrutura;
end;

procedure TfrmRelVendasPorCliente.FormShow(Sender: TObject);
begin
  inherited;
  AjustaLayout;  
  dtInicial.Date := FoArquivoDAT.Usuario.Outros.PeriodoInicial;
  dtFinal.Date   := FoArquivoDAT.Usuario.Outros.PeriodoFinal;
end;

function TfrmRelVendasPorCliente.FazValidacoes: Boolean;
begin
  Result := False;

  if ((dtInicial.Date = 0) or (dtFinal.Date = 0)) or (dtInicial.Date > dtFinal.Date) then
  begin
    ShowMessage(_cPeriodoDataInvalida);
    dtInicial.SetFocus;
    Exit;
  end;
  if (not cbNota.Checked) and (not cbCupom.Checked) then
  begin
    ShowMessage(_cSemDocumentoMarcadoImpressao);
    cbNota.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TfrmRelVendasPorCliente.btnMarcarTodosOperClick(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to chkOperacoes.Items.Count -1 do
    chkOperacoes.Checked[i] := True;
end;

procedure TfrmRelVendasPorCliente.AjustaLayout;
begin
  pnlPrincipal.Top := 16;
  pnlSelOperacoes.Left := 184;
  pnlSelOperacoes.Top  := pnlPrincipal.Top;
  pnlSelOperacoes.Left := pnlPrincipal.Left;
end;

procedure TfrmRelVendasPorCliente.btnDesmarcarTodosOperClick(
  Sender: TObject);
var
  i : integer;
begin
  for i := 0 to chkOperacoes.Items.Count -1 do
    chkOperacoes.Checked[i] := False;
end;

procedure TfrmRelVendasPorCliente.btnAvancarClick(Sender: TObject);
begin
  if (pnlSelOperacoes.Visible) or (not cbNota.Checked) then
    inherited
  else
  begin
    if (pnlPrincipal.Visible) and (cbNota.Checked) then
    begin
      if not FazValidacoes then
        Exit;
      pnlPrincipal.Visible := False;
      pnlSelOperacoes.Visible := True;
      TRetornaOperacoesRelatorio.New
                                .setDataBase(DataBase)
                                .setOperacaoVenda
                                .CarregaDados
                                .DefineItens(chkOperacoes);
    end;
    btnVoltar.Enabled := (not pnlPrincipal.Visible);
  end;
end;

function TfrmRelVendasPorCliente.RetornarItensMarcadosOperacao: TStringList;
var
  i: Integer;
begin
  Result := FlsItensOperacoes;

  if not cbNota.Checked then
    Exit;

  for I := 0 to Pred(chkOperacoes.Items.Count) do
  begin
    if chkOperacoes.Checked[I] then
      Result.Add(chkOperacoes.Items[I]);
  end;
end;

procedure TfrmRelVendasPorCliente.btnVoltarClick(Sender: TObject);
begin
  if pnlSelOperacoes.Visible then
  begin
    pnlSelOperacoes.Visible := False;
    pnlPrincipal.Visible    := True;
  end;

  btnVoltar.Enabled := (not pnlPrincipal.Visible);
  inherited;
end;

procedure TfrmRelVendasPorCliente.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FoArquivoDAT.Usuario.Outros.PeriodoInicial := dtInicial.Date;
  FoArquivoDAT.Usuario.Outros.PeriodoFinal   := dtFinal.Date;
  inherited;
end;

procedure TfrmRelVendasPorCliente.FormCreate(Sender: TObject);
begin
  inherited;
  FlsItensOperacoes := TStringList.Create;
end;

procedure TfrmRelVendasPorCliente.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FlsItensOperacoes);
  inherited;
end;

end.
