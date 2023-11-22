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
    imgEdit: TImage;
    edtPercGeral: TEdit;
    lblTitulo: TLabel;
    ibdProdutosNotaREGISTRO: TIBStringField;
    cdsProdutosNotaREGISTRO: TStringField;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbgPrincipalDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure dbgPrincipalDblClick(Sender: TObject);
    procedure dbgPrincipalCellClick(Column: TColumn);
    procedure edtPercGeralKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtPercGeralExit(Sender: TObject);
    procedure edtPercGeralKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    CampoSel : string;
  public
    { Public declarations }
  end;

var
  FrmPrecificacaoProduto: TFrmPrecificacaoProduto;

implementation

uses Unit7
  , uArquivosDAT
  , Mais
  , uFrmSmallImput
  , SmallFunc
  , uDialogs;

{$R *.dfm}

procedure TFrmPrecificacaoProduto.btnOKClick(Sender: TObject);
begin
  try
    try
      cdsProdutosNota.DisableControls;
      Form7.ibDataSet23.DisableControls;
      
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
end;

procedure TFrmPrecificacaoProduto.dbgPrincipalDrawColumnCell(
  Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if Column.Field.Name =  'cdsProdutosNotaPERC_LUC' then
  begin
    dbgPrincipal.Canvas.Draw(Rect.Left +1,Rect.Top + 1,imgEdit.Picture.Graphic)
  end;

  if Column.Field.Name =  'cdsProdutosNotaPRECO_NOVO' then
  begin
    dbgPrincipal.Canvas.Draw(Rect.Left +1,Rect.Top + 1,imgEdit.Picture.Graphic)
  end;
end;

procedure TFrmPrecificacaoProduto.dbgPrincipalDblClick(Sender: TObject);
var
  retorno : string;
begin
  if CampoSel = 'PERC_LUC' then
  begin
    retorno := ImputBoxSmall('Informe o percentual de lucro',
                             cdsProdutosNotaPERC_LUC.Text,
                             FormatFloat(cdsProdutosNotaPERC_LUC.DisplayFormat, cdsProdutosNotaPERC_LUC.AsFloat),
                             tpFloat
                             );

    if retorno <> '' then
    begin
      if StrToFloatDef(retorno,0) < 0 then
      begin
        MensagemSistema('Não pode ser informado quantidade negativa.',msgAtencao);
        Exit;
      end;

      cdsProdutosNota.Edit;
      cdsProdutosNotaPERC_LUC.AsFloat := StrToFloatDef(retorno,0);
      cdsProdutosNota.Post;
    end;
  end;

  if CampoSel = 'PRECO_NOVO' then
  begin
    retorno := ImputBoxSmall('Informe o novo preço',
                             cdsProdutosNotaPRECO_NOVO.Text,
                             FormatFloat(cdsProdutosNotaPRECO_NOVO.DisplayFormat, cdsProdutosNotaPRECO_NOVO.AsFloat),
                             tpFloat
                             );

    if retorno <> '' then
    begin
      if StrToFloatDef(retorno,0) < 0 then
      begin
        MensagemSistema('Não pode ser informado valor negativo.',msgAtencao);
        Exit;
      end;

      cdsProdutosNota.Edit;
      cdsProdutosNotaPRECO_NOVO.AsFloat := StrToFloatDef(retorno,0);
      cdsProdutosNota.Post;
    end;
  end;

end;

procedure TFrmPrecificacaoProduto.dbgPrincipalCellClick(Column: TColumn);
begin
  CampoSel := Column.FieldName;
end;

procedure TFrmPrecificacaoProduto.edtPercGeralKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Perform(Wm_NextDlgCtl,0,0);
end;

procedure TFrmPrecificacaoProduto.edtPercGeralExit(Sender: TObject);
begin
  edtPercGeral.Text := FormatFloat('##0.00', StrToFloatDef(edtPercGeral.Text,0));
end;

procedure TFrmPrecificacaoProduto.edtPercGeralKeyPress(Sender: TObject;
  var Key: Char);
begin
  ValidaValor(Sender,Key,'F');
end;

end.
