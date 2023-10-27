unit uFrmPesquisaOrcamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmGridPesquisaPadrao, DB, IBCustomDataSet, IBQuery, StdCtrls,
  Buttons, Grids, DBGrids, ComCtrls;

type
  TFrmPesquisaOrcamento = class(TFrmGridPesquisaPadrao)
    IBQPESQUISAPEDIDO: TIBStringField;
    IBQPESQUISADATA: TDateField;
    IBQPESQUISACLIFOR: TIBStringField;
    IBQPESQUISAVENDEDOR: TIBStringField;
    IBQPESQUISATOTAL: TFloatField;
    IBQPESQUISANUMERONF: TIBStringField;
    procedure btnOKClick(Sender: TObject);
    procedure dbGridPrincipalDblClick(Sender: TObject);
    procedure dbGridPrincipalDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
  private
    { Private declarations }
    procedure SelecionaPesquisa; override;
  public
    { Public declarations }
  end;

  function PesquisaNumeroOrcamento(Titulo:string):string;

var
  FrmPesquisaOrcamento: TFrmPesquisaOrcamento;

implementation

uses uFuncoesBancoDados
  , SmallFunc
  , Unit7
  , uFuncoesRetaguarda
  , uSmallConsts
  ;

{$R *.dfm}

function PesquisaNumeroOrcamento(Titulo:string):string;
begin
  Result := '';

  try
    FrmPesquisaOrcamento := TFrmPesquisaOrcamento.create(nil);
    FrmPesquisaOrcamento.lblTitulo1.Caption := Titulo;
    if FrmPesquisaOrcamento.ShowModal = mrOk then
    begin
      Result := FrmPesquisaOrcamento.FIdSelecionado;
    end;
  finally
    FreeAndNil(FrmPesquisaOrcamento);
  end;
end;

{ TFrmPesquisaOrcamento }

procedure TFrmPesquisaOrcamento.SelecionaPesquisa;
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
      vFiltro := ' Where PEDIDO like '+QuotedStr('%'+edPesquisa.Text+'%');
    end else
    begin
      vFiltro := vFiltro +
                 ' and ('+
                 '   Upper(CLIFOR) like '+QuotedStr('%'+UpperCase(edPesquisa.Text)+'%')+
                 '   or Upper(VENDEDOR) like '+QuotedStr('%'+UpperCase(edPesquisa.Text)+'%')+
                 ' )';
    end;
  end;

  IBQPESQUISA.Close;
  IBQPESQUISA.SQL.Text := ' Select'+
                          ' 	PEDIDO, '+
                          ' 	DATA, '+
                          ' 	CLIFOR, '+
                          ' 	VENDEDOR, '+
                          ' 	TOTALBRUTO TOTAL, '+
                          ' 	NUMERONF'+
                          ' From'+
                          ' ('+SqlEstoqueOrcamentos(False)+' ) O'+
                          vFiltro+
                          ' Order By DATA desc, PEDIDO desc ';
  IBQPESQUISA.Open;
end;

procedure TFrmPesquisaOrcamento.btnOKClick(Sender: TObject);
begin
  FrmPesquisaOrcamento.FIdSelecionado := IBQPESQUISA.FieldByName('PEDIDO').AsString;
  inherited;
end;

procedure TFrmPesquisaOrcamento.dbGridPrincipalDblClick(Sender: TObject);
begin
  FrmPesquisaOrcamento.FIdSelecionado := IBQPESQUISA.FieldByName('PEDIDO').AsString;
  inherited;
end;

procedure TFrmPesquisaOrcamento.dbGridPrincipalDrawColumnCell(
  Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;

  if IBQPESQUISANUMERONF.AsString <> '' then
  begin
    (Sender As TDBGrid).Canvas.Font.Color := _COR_AZUL;
  end;

  (Sender as TDBGrid).DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

end.
