unit uFrmPesquisaOrcamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmGridPesquisaPadrao, DB, IBCustomDataSet, IBQuery, StdCtrls,
  Buttons, Grids, DBGrids, ComCtrls;

type
  TFrmPesquisaOrcamento = class(TFrmGripPesquisaPadrao)
    IBQPESQUISAPEDIDO: TIBStringField;
    IBQPESQUISADATA: TDateField;
    IBQPESQUISACLIFOR: TIBStringField;
    IBQPESQUISAVENDEDOR: TIBStringField;
    IBQPESQUISATOTAL: TFloatField;
    IBQPESQUISANUMERONF: TIBStringField;
    procedure btnOKClick(Sender: TObject);
    procedure dbGridPrincipalDblClick(Sender: TObject);
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

uses uFuncoesBancoDados, SmallFunc, Unit7, uFuncoesRetaguarda;

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

  vFiltro := ' Where DATA < '+ QuotedStr(DateToBD(dtpFiltro.Date));

  if Trim(edPesquisa.Text) <> '' then
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
                          ' Order By DATA desc';
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

end.
