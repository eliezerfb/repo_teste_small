unit uFrmTransacoesItau;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Buttons, IBX.IBCustomDataSet, IBX.IBQuery, IBX.IBDatabase;

type
  TFrmTransacoesItau = class(TForm)
    DBGrid1: TDBGrid;
    btnOK: TBitBtn;
    btnAtualizar: TBitBtn;
    btnCancelar: TBitBtn;
    btnEstornar: TBitBtn;
    DSTransacoes: TDataSource;
    ibqTransacoes: TIBDataSet;
    ibqTransacoesIDTRANSACAO: TIntegerField;
    ibqTransacoesNUMERONF: TIBStringField;
    ibqTransacoesCAIXA: TIBStringField;
    ibqTransacoesORDERID: TIBStringField;
    ibqTransacoesDATAHORA: TDateTimeField;
    ibqTransacoesSTATUS: TIBStringField;
    ibqTransacoesVALOR: TIBBCDField;
    ibtTransacoes: TIBTransaction;
    procedure btnOKClick(Sender: TObject);
    procedure DSTransacoesDataChange(Sender: TObject; Field: TField);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnEstornarClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmTransacoesItau: TFrmTransacoesItau;

  procedure ListaTransacoesItau(sCaixa : string; AOwner : TComponent);

implementation

{$R *.dfm}

uses FISCAL
  , uIntegracaoItau
  , uDialogs;


procedure ListaTransacoesItau(sCaixa : string; AOwner : TComponent);
begin
  try
    if not CarregaInformacoesItau(Form1.IBTransaction1) then
      Exit;

    FrmTransacoesItau := TFrmTransacoesItau.Create(AOwner);
    FrmTransacoesItau.ibqTransacoes.SelectSQL.Add(' Where CAIXA = '+QuotedStr(sCaixa));
    FrmTransacoesItau.ibqTransacoes.SelectSQL.Add(' Order By 1 desc ');
    FrmTransacoesItau.ibqTransacoes.Open;
    FrmTransacoesItau.ShowModal;

    FrmTransacoesItau.ibtTransacoes.Commit;
  finally
    FreeAndNil(FrmTransacoesItau);
  end;
end;

procedure TFrmTransacoesItau.btnAtualizarClick(Sender: TObject);
var
  sStatus, sNovoStatus : string;
  CodigoAutorizacao : string;
begin
  sStatus := GetStatusOrder(ibqTransacoesORDERID.AsString,CodigoAutorizacao);

  if sStatus = 'expired' then
    sNovoStatus := 'Expirado';

  if sStatus = 'cancelled' then
    sNovoStatus := 'Cancelado';

  if sStatus = 'approved' then
    sNovoStatus := 'Aprovado';

  if sStatus = 'pending' then
    sNovoStatus := 'Pendente';

  if sStatus = 'refunded' then
    sNovoStatus := 'Estornado';

  if (sNovoStatus <> '') and (sNovoStatus <> ibqTransacoesSTATUS.AsString) then
  begin
    ibqTransacoes.Edit;
    ibqTransacoesSTATUS.AsString := sNovoStatus;
    ibqTransacoes.Post;
  end;
end;

procedure TFrmTransacoesItau.btnCancelarClick(Sender: TObject);
begin
  if CancelOrder(ibqTransacoesORDERID.AsString) then
  begin
    ibqTransacoes.Edit;
    ibqTransacoesSTATUS.AsString := 'Cancelado';
    ibqTransacoes.Post;
  end;
end;

procedure TFrmTransacoesItau.btnEstornarClick(Sender: TObject);
begin
  if EstornaOrder(ibqTransacoesORDERID.AsString) then
  begin
    ibqTransacoes.Edit;
    ibqTransacoesSTATUS.AsString := 'Estornado';
    ibqTransacoes.Post;
  end;
end;

procedure TFrmTransacoesItau.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmTransacoesItau.DSTransacoesDataChange(Sender: TObject;
  Field: TField);
begin
  btnCancelar.Enabled := ibqTransacoesSTATUS.AsString = 'Pendente';
  btnEstornar.Enabled := ibqTransacoesSTATUS.AsString = 'Aprovado';
end;


end.
