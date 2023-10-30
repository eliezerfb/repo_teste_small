unit uFrmPesquisaOrdemServico;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmGridPesquisaPadrao, DB, IBCustomDataSet, IBQuery, StdCtrls,
  Buttons, Grids, DBGrids, ComCtrls;

type
  TFrmPesquisaOrdemServico = class(TFrmGridPesquisaPadrao)
    IBQPESQUISANUMERO: TIBStringField;
    IBQPESQUISADATA: TDateField;
    IBQPESQUISACLIENTE: TIBStringField;
    IBQPESQUISATECNICO: TIBStringField;
    IBQPESQUISATOTAL_OS: TFloatField;
    IBQPESQUISANF: TIBStringField;
    procedure dbGridPrincipalDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure dbGridPrincipalDblClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    procedure SelecionaPesquisa; override;
  public
    { Public declarations }
  end;

  function PesquisaNumeroOrdemServico(Titulo:string):string;

var
  FrmPesquisaOrdemServico: TFrmPesquisaOrdemServico;

implementation

uses uSmallConsts
  , SmallFunc
  , uFuncoesBancoDados
  ;

{$R *.dfm}

function PesquisaNumeroOrdemServico(Titulo:string):string;
begin
  Result := '';

  try
    FrmPesquisaOrdemServico := TFrmPesquisaOrdemServico.create(nil);
    FrmPesquisaOrdemServico.lblTitulo1.Caption := Titulo;
    if FrmPesquisaOrdemServico.ShowModal = mrOk then
    begin
      Result := FrmPesquisaOrdemServico.FIdSelecionado;
    end;
  finally
    FreeAndNil(FrmPesquisaOrdemServico);
  end;
end;

procedure TFrmPesquisaOrdemServico.dbGridPrincipalDrawColumnCell(
  Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;

  if IBQPESQUISANF.AsString <> '' then
  begin
    (Sender As TDBGrid).Canvas.Font.Color := _COR_AZUL;
  end;

  (Sender as TDBGrid).DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TFrmPesquisaOrdemServico.dbGridPrincipalDblClick(
  Sender: TObject);
begin
  FrmPesquisaOrdemServico.FIdSelecionado := IBQPESQUISA.FieldByName('NUMERO').AsString;
  inherited;
end;

procedure TFrmPesquisaOrdemServico.btnOKClick(Sender: TObject);
begin
  FrmPesquisaOrdemServico.FIdSelecionado := IBQPESQUISA.FieldByName('NUMERO').AsString;
  inherited;
end;

procedure TFrmPesquisaOrdemServico.SelecionaPesquisa;
var
  vFiltro : string;
begin
  inherited;

  vFiltro := ' Where DATA <= '+ QuotedStr(DateToBD(dtpFiltro.Date));

  if trim(edPesquisa.Text) <> '' then
  begin
    if edPesquisa.Text = LimpaNumero(edPesquisa.Text) then
    begin
      //Pesquisa só pelo pedido
      vFiltro := ' Where NUMERO like '+QuotedStr('%'+edPesquisa.Text+'%');
    end else
    begin
      vFiltro := vFiltro +
                 ' and ('+
                 '   Upper(CLIENTE) like '+QuotedStr('%'+UpperCase(edPesquisa.Text)+'%')+
                 '   or Upper(TECNICO) like '+QuotedStr('%'+UpperCase(edPesquisa.Text)+'%')+
                 ' )';
    end;
  end;

  IBQPESQUISA.Close;
  IBQPESQUISA.SQL.Text := ' Select'+
                          ' 	NUMERO, '+
                          ' 	DATA, '+
                          ' 	CLIENTE, '+
                          ' 	TECNICO, '+
                          ' 	TOTAL_OS, '+
                          ' 	NF'+
                          ' From OS'+
                          vFiltro+
                          ' Order By DATA desc, NUMERO desc ';
  IBQPESQUISA.Open;
end;

end.
