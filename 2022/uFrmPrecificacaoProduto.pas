unit uFrmPrecificacaoProduto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, StdCtrls, Buttons, Grids, DBGrids, DBClient,
  Provider, DB, IBCustomDataSet, pngimage, ExtCtrls;

type
  TFrmPrecificacaoProduto = class(TFrmPadrao)
    btnCancelar: TBitBtn;
    btnOK: TBitBtn;
    dbgPrincipal: TDBGrid;
    DSProdutos: TDataSource;
    ibdProdutosNota: TIBDataSet;
    dspProdutosNota: TDataSetProvider;
    cdsProdutosNota: TClientDataSet;
    ibdProdutosNotaPRODUTO: TIBStringField;
    ibdProdutosNotaPRECO_CUSTO: TFloatField;
    ibdProdutosNotaPRECO_VENDA: TFloatField;
    ibdProdutosNotaPERC_LUC: TFloatField;
    ibdProdutosNotaPRECO_NOVO: TFloatField;
    cdsProdutosNotaPRODUTO: TStringField;
    cdsProdutosNotaPRECO_CUSTO: TFloatField;
    cdsProdutosNotaPRECO_VENDA: TFloatField;
    cdsProdutosNotaPERC_LUC: TFloatField;
    cdsProdutosNotaPRECO_NOVO: TFloatField;
    edtPercGeral: TEdit;
    lblTitulo: TLabel;
    ibdProdutosNotaREGISTRO: TIBStringField;
    cdsProdutosNotaREGISTRO: TStringField;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtPercGeralKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtPercGeralExit(Sender: TObject);
    procedure edtPercGeralKeyPress(Sender: TObject; var Key: Char);
    procedure cdsProdutosNotaPERC_LUCSetText(Sender: TField;
      const Text: String);
    procedure cdsProdutosNotaAfterInsert(DataSet: TDataSet);
    procedure cdsProdutosNotaBeforeDelete(DataSet: TDataSet);
    procedure dbgPrincipalKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgPrincipalDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure cdsProdutosNotaPRECO_NOVOSetText(Sender: TField;
      const Text: String);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrecificacaoProduto: TFrmPrecificacaoProduto;

implementation

uses Unit7
  , uArquivosDAT
  , Mais
  , SmallFunc
  , uDialogs, uFuncoesRetaguarda, uFuncoesBancoDados;

{$R *.dfm}

procedure TFrmPrecificacaoProduto.btnOKClick(Sender: TObject);
begin
  try
    try
      cdsProdutosNota.DisableControls;
      Form7.ibDataSet23.DisableControls;
      //LogRetaguarda('ufrmPrecificacaoProduto ibDataSet23.DisableControls 76'); // Sandro Silva 2023-12-04
      
      cdsProdutosNota.First;

      while not cdsProdutosNota.Eof do
      begin
        if Form7.ibDataSet23.Locate('REGISTRO',cdsProdutosNotaREGISTRO.AsString,[]) then
        begin
          Form7.ibDataSet23.Edit;
          Form7.ibDataSet23LISTA.AsFloat := cdsProdutosNotaPRECO_NOVO.AsFloat;
          Form7.ibDataSet23.Post;
        end;

        cdsProdutosNota.Next;
      end;

      Form7.ibDataSet23.First;
      cdsProdutosNota.First;
    finally
      Form7.ibDataSet23.EnableControls;
      //LogRetaguarda('ufrmPrecificacaoProduto ibDataSet23.EnableControls 95'); // Sandro Silva 2023-12-04
      cdsProdutosNota.EnableControls;
    end;
  except
  end;

  Close;
end;

procedure TFrmPrecificacaoProduto.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmPrecificacaoProduto.FormShow(Sender: TObject);
var
  CasasPreco: integer;
  Mascara : string;
  oArqDat: TArquivosDAT;
begin
  oArqDat := TArquivosDAT.Create(Usuario);
  try
    CasasPreco  := oArqDat.SmallCom.Outros.CasasDecimaisPreco;
  finally
    FreeAndNil(oArqDat);
  end;

  Mascara := MontaMascaraCasaDec(CasasPreco);

  cdsProdutosNotaPRECO_CUSTO.DisplayFormat := Mascara;
  cdsProdutosNotaPRECO_VENDA.DisplayFormat := Mascara;
  cdsProdutosNotaPRECO_NOVO.DisplayFormat  := Mascara;
  cdsProdutosNotaPRECO_NOVO.EditFormat     := Mascara;

  cdsProdutosNota.Open;

  try
    dbgPrincipal.SetFocus;
    dbgPrincipal.SelectedIndex := 3;
  except
  end;
end;

procedure TFrmPrecificacaoProduto.edtPercGeralKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    dbgPrincipal.SetFocus;

  dbgPrincipal.SelectedIndex := 3;
end;

procedure TFrmPrecificacaoProduto.edtPercGeralExit(Sender: TObject);
begin
  edtPercGeral.Text := FormatFloat('##0.00', StrToFloatDef(edtPercGeral.Text,0));

  if StrToFloatDef(edtPercGeral.Text,0) <= 0 then
    Exit;

  try
    cdsProdutosNota.DisableConstraints;
    cdsProdutosNota.First;
    while not cdsProdutosNota.Eof do
    begin
      cdsProdutosNota.Edit;
      cdsProdutosNotaPERC_LUC.AsFloat := StrToFloatDef(edtPercGeral.Text,0);
      cdsProdutosNotaPRECO_NOVO.AsFloat := cdsProdutosNotaPRECO_CUSTO.AsFloat + (cdsProdutosNotaPRECO_CUSTO.AsFloat * (cdsProdutosNotaPERC_LUC.AsFloat / 100));
      cdsProdutosNota.Post;
      cdsProdutosNota.Next;
    end;
  finally
    cdsProdutosNota.First;
    cdsProdutosNota.EnableConstraints;
  end;
end;

procedure TFrmPrecificacaoProduto.edtPercGeralKeyPress(Sender: TObject;
  var Key: Char);
begin
  ValidaValor(Sender,Key,'F');
end;

procedure TFrmPrecificacaoProduto.cdsProdutosNotaPERC_LUCSetText(
  Sender: TField; const Text: String);
begin
  cdsProdutosNotaPRECO_NOVO.AsFloat := cdsProdutosNotaPRECO_CUSTO.AsFloat + (cdsProdutosNotaPRECO_CUSTO.AsFloat * (StrToFloatDef(Text,0) / 100));

  Sender.AsString := Text;
end;

procedure TFrmPrecificacaoProduto.cdsProdutosNotaAfterInsert(
  DataSet: TDataSet);
begin
  inherited;
  cdsProdutosNota.Cancel;
end;

procedure TFrmPrecificacaoProduto.cdsProdutosNotaBeforeDelete(
  DataSet: TDataSet);
begin
  inherited;
  Abort;
end;

procedure TFrmPrecificacaoProduto.dbgPrincipalKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if dbgPrincipal.SelectedIndex = 4 then
    begin
      cdsProdutosNota.Next;
      dbgPrincipal.SelectedIndex := 3;

      if cdsProdutosNota.Eof then
      begin
        btnOK.SetFocus;
      end;

    end else
      dbgPrincipal.SelectedIndex := dbgPrincipal.SelectedIndex +1;
    begin
    end;
  end;
end;

procedure TFrmPrecificacaoProduto.dbgPrincipalDrawColumnCell(
  Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if Column.Field.Name = 'cdsProdutosNotaPRECO_NOVO' then
  begin
    if cdsProdutosNotaPRECO_VENDA.AsFloat <> cdsProdutosNotaPRECO_NOVO.AsFloat then
      TDBGrid(Sender).Canvas.Font.Style := [fsBold]
    else
      TDBGrid(Sender).Canvas.Font.Style := [];

    dbgPrincipal.Canvas.FillRect(Rect);
    dbgPrincipal.DefaultDrawColumnCell(Rect,DataCol,Column,State);
  end;
end;

procedure TFrmPrecificacaoProduto.cdsProdutosNotaPRECO_NOVOSetText(
  Sender: TField; const Text: String);
begin
  cdsProdutosNotaPERC_LUC.AsFloat :=  ( (( StrToFloatDef(Text,0) / cdsProdutosNotaPRECO_CUSTO.AsFloat ) - 1) *100) ;

  Sender.AsString := Text;
end;

procedure TFrmPrecificacaoProduto.FormCreate(Sender: TObject);
var
  SizeDescricaoProd : integer;
begin
  SizeDescricaoProd := TamanhoCampoFB(Form7.IBDatabase1,'ESTOQUE','DESCRICAO');
  cdsProdutosNotaPRODUTO.Size := SizeDescricaoProd;
  ibdProdutosNotaPRODUTO.Size := SizeDescricaoProd;
end;

end.
