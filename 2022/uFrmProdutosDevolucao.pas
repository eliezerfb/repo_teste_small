unit uFrmProdutosDevolucao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, StdCtrls, Grids, DBGrids, Buttons, DB,
  IBCustomDataSet, DBClient, Provider, ExtCtrls, pngimage, SmallFunc;

type
  TFrmProdutosDevolucao = class(TFrmPadrao)
    dbgPrincipal: TDBGrid;
    lblTitulo: TLabel;
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    DSProdutos: TDataSource;
    cdsProdutosNota: TClientDataSet;
    ibdProdutosNota: TIBDataSet;
    ibdProdutosNotaMARCADO: TIBStringField;
    ibdProdutosNotaNUMERONF: TIBStringField;
    ibdProdutosNotaCODIGO: TIBStringField;
    ibdProdutosNotaDESCRICAO: TIBStringField;
    ibdProdutosNotaST: TIBStringField;
    ibdProdutosNotaIPI: TFloatField;
    ibdProdutosNotaICM: TFloatField;
    ibdProdutosNotaBASE: TFloatField;
    ibdProdutosNotaMEDIDA: TIBStringField;
    ibdProdutosNotaQUANTIDADE: TFloatField;
    ibdProdutosNotaUNITARIO: TFloatField;
    ibdProdutosNotaTOTAL: TFloatField;
    ibdProdutosNotaPESO: TFloatField;
    ibdProdutosNotaCST_PIS_COFINS: TIBStringField;
    ibdProdutosNotaALIQ_PIS: TIBBCDField;
    ibdProdutosNotaVICMS: TIBBCDField;
    ibdProdutosNotaVBC: TIBBCDField;
    ibdProdutosNotaVICMSST: TIBBCDField;
    ibdProdutosNotaVIPI: TIBBCDField;
    ibdProdutosNotaCST_IPI: TIBStringField;
    ibdProdutosNotaCST_ICMS: TIBStringField;
    ibdProdutosNotaVBCFCP: TIBBCDField;
    ibdProdutosNotaPFCP: TIBBCDField;
    ibdProdutosNotaVFCP: TIBBCDField;
    ibdProdutosNotaVBCFCPST: TIBBCDField;
    ibdProdutosNotaPFCPST: TIBBCDField;
    ibdProdutosNotaVFCPST: TIBBCDField;
    ibdProdutosNotaICMS_DESONERADO: TIBBCDField;
    dspProdutosNota: TDataSetProvider;
    cdsProdutosNotaMARCADO: TStringField;
    cdsProdutosNotaNUMERONF: TStringField;
    cdsProdutosNotaCODIGO: TStringField;
    cdsProdutosNotaDESCRICAO: TStringField;
    cdsProdutosNotaST: TStringField;
    cdsProdutosNotaIPI: TFloatField;
    cdsProdutosNotaICM: TFloatField;
    cdsProdutosNotaBASE: TFloatField;
    cdsProdutosNotaMEDIDA: TStringField;
    cdsProdutosNotaQUANTIDADE: TFloatField;
    cdsProdutosNotaUNITARIO: TFloatField;
    cdsProdutosNotaTOTAL: TFloatField;
    cdsProdutosNotaPESO: TFloatField;
    cdsProdutosNotaCST_PIS_COFINS: TStringField;
    cdsProdutosNotaALIQ_PIS: TBCDField;
    cdsProdutosNotaVICMS: TBCDField;
    cdsProdutosNotaVBC: TBCDField;
    cdsProdutosNotaVICMSST: TBCDField;
    cdsProdutosNotaVIPI: TBCDField;
    cdsProdutosNotaCST_IPI: TStringField;
    cdsProdutosNotaCST_ICMS: TStringField;
    cdsProdutosNotaVBCFCP: TBCDField;
    cdsProdutosNotaPFCP: TBCDField;
    cdsProdutosNotaVFCP: TBCDField;
    cdsProdutosNotaVBCFCPST: TBCDField;
    cdsProdutosNotaPFCPST: TBCDField;
    cdsProdutosNotaVFCPST: TBCDField;
    cdsProdutosNotaICMS_DESONERADO: TBCDField;
    ibdProdutosNotaVBCST: TIBBCDField;
    cdsProdutosNotaVBCST: TBCDField;
    imgCheck: TImage;
    imgUnCheck: TImage;
    BitBtn1: TBitBtn;
    imgEdit: TImage;
    ibdProdutosNotaQUANTIDADE_ANT: TFloatField;
    ibdProdutosNotaVIPI_ANT: TIBBCDField;
    ibdProdutosNotaICM_ANT: TFloatField;
    ibdProdutosNotaVICMS_ANT: TIBBCDField;
    ibdProdutosNotaVBC_ANT: TIBBCDField;
    ibdProdutosNotaVBCST_ANT: TIBBCDField;
    ibdProdutosNotaVICMSST_ANT: TIBBCDField;
    ibdProdutosNotaVBCFCPST_ANT: TIBBCDField;
    ibdProdutosNotaVFCPST_ANT: TIBBCDField;
    cdsProdutosNotaQUANTIDADE_ANT: TFloatField;
    cdsProdutosNotaVIPI_ANT: TBCDField;
    cdsProdutosNotaICM_ANT: TFloatField;
    cdsProdutosNotaVICMS_ANT: TBCDField;
    cdsProdutosNotaVBC_ANT: TBCDField;
    cdsProdutosNotaVBCST_ANT: TBCDField;
    cdsProdutosNotaVICMSST_ANT: TBCDField;
    cdsProdutosNotaVBCFCPST_ANT: TBCDField;
    cdsProdutosNotaVFCPST_ANT: TBCDField;
    procedure dbgPrincipalCellClick(Column: TColumn);
    procedure dbgPrincipalDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure BitBtn1Click(Sender: TObject);
    procedure cdsProdutosNotaAfterInsert(DataSet: TDataSet);
    procedure cdsProdutosNotaQUANTIDADEChange(Sender: TField);
    procedure dbgPrincipalDblClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cdsProdutosNotaBeforeDelete(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure dbgPrincipalKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    CampoSel : string;
    procedure DevolveNF;
    procedure AtualizaValoresItem;
  public
    { Public declarations }
  end;

var
  FrmProdutosDevolucao: TFrmProdutosDevolucao;

implementation

uses uFrmParametroTributacao
  , Mais
  , uFrmSmallImput
  , Unit7
  , Unit12
  , uFuncoesRetaguarda
  , uDialogs
  , uArquivosDAT
  , uSmallComINF, uSmallComSections, uFuncoesBancoDados;

{$R *.dfm}

procedure TFrmProdutosDevolucao.dbgPrincipalCellClick(Column: TColumn);
begin
  if Column.FieldName = 'MARCADO' then
  begin
    cdsProdutosNota.Edit;

    if (cdsProdutosNotaMARCADO.AsString = 'S') then
      cdsProdutosNotaMARCADO.AsString := 'N'
    else
      cdsProdutosNotaMARCADO.AsString := 'S';

    cdsProdutosNota.Post;
  end;

  CampoSel := Column.FieldName;
end;

procedure TFrmProdutosDevolucao.dbgPrincipalDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if Column.Field.Name = 'cdsProdutosNotaMARCADO' then
  begin
    if (gdSelected in State) or (gdFocused in State) then
      TDBGrid(Sender).Canvas.Brush.Color:= clWhite;

    dbgPrincipal.Canvas.FillRect(Rect);
    dbgPrincipal.DefaultDrawColumnCell(Rect,DataCol,Column,State);

    if (cdsProdutosNotaMARCADO.AsString = 'S') then
      dbgPrincipal.Canvas.Draw(Rect.Left +1,Rect.Top + 1,imgCheck.Picture.Graphic)
    else
      dbgPrincipal.Canvas.Draw(Rect.Left +1,Rect.Top + 1,imgUnCheck.Picture.Graphic);
  end;

  if Column.Field.Name =  'cdsProdutosNotaQUANTIDADE' then
  begin
    dbgPrincipal.Canvas.Draw(Rect.Left +1,Rect.Top + 1,imgEdit.Picture.Graphic)
  end;
end;

procedure TFrmProdutosDevolucao.BitBtn1Click(Sender: TObject);
begin
  try
    cdsProdutosNota.DisableControls;

    cdsProdutosNota.First;
    while not cdsProdutosNota.Eof do
    begin
      cdsProdutosNota.Edit;
      cdsProdutosNotaMARCADO.AsString := 'N';
      cdsProdutosNota.Post;
      
      cdsProdutosNota.Next;
    end;
  finally
    cdsProdutosNota.First;
    cdsProdutosNota.EnableControls;
  end;
end;

procedure TFrmProdutosDevolucao.cdsProdutosNotaAfterInsert(
  DataSet: TDataSet);
begin
  inherited;
  cdsProdutosNota.Cancel;
end;

procedure TFrmProdutosDevolucao.cdsProdutosNotaQUANTIDADEChange(
  Sender: TField);
begin
  AtualizaValoresItem;
end;

procedure TFrmProdutosDevolucao.dbgPrincipalDblClick(Sender: TObject);
var
  retorno : string;
begin
  if CampoSel = 'QUANTIDADE' then
  begin
    retorno := ImputBoxSmall('Informe a quantidade',
                             cdsProdutosNotaDESCRICAO.Text,
                             FormatFloat(cdsProdutosNotaQUANTIDADE.DisplayFormat, cdsProdutosNotaQUANTIDADE.AsFloat),
                             tpFloat
                             );

    if retorno <> '' then
    begin
      if StrToFloatDef(retorno,0) <= 0 then
      begin
        MensagemSistema('Não pode ser informado quantidade zerada do produto.',msgAtencao);
        Exit;
      end;

      if StrToFloatDef(retorno,0) <= cdsProdutosNotaQUANTIDADE_ANT.AsFloat then
      begin
        cdsProdutosNota.Edit;
        cdsProdutosNotaQUANTIDADE.AsFloat := StrToFloatDef(retorno,0);
        cdsProdutosNota.Post;
      end else
      begin
        MensagemSistema('Não pode ser informado uma quantidade maior que a da Nota Fiscal de origem.'+#13#10+
                        'Nota Fiscal: '+FormatFloat('#,##0.00', cdsProdutosNotaQUANTIDADE_ANT.AsFloat)
                        ,msgAtencao);
      end;
    end;
  end;
end;

procedure TFrmProdutosDevolucao.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmProdutosDevolucao.btnOKClick(Sender: TObject);
var
  QtdDevol : Real;
begin
  //Verifica se tem pelo menos um item marcado
  QtdDevol := 0;

  try
    cdsProdutosNota.DisableControls;
    cdsProdutosNota.First;

    while not cdsProdutosNota.Eof do
    begin
      if (AllTrim(cdsProdutosNotaCODIGO.AsString) <> '') and (cdsProdutosNotaMARCADO.AsString = 'S') then
        QtdDevol := QtdDevol + cdsProdutosNotaQUANTIDADE.AsFloat;

      cdsProdutosNota.Next;
    end;
  finally
    cdsProdutosNota.First;
    cdsProdutosNota.EnableControls;
  end;

  if QtdDevol > 0 then
  begin
    DevolveNF;
    Close;
  end else
  begin
    MensagemSistema('Deve ser selecionado pelo menos um produto para devolver.');
  end;
end;

procedure TFrmProdutosDevolucao.DevolveNF;
begin
  try
    Form1.imgVendasClick(Form1.imgVendas);
    Form7.Image101Click(Form7.imgNovo);

    Form7.ibDataSet2.Close;
    Form7.ibDataSet2.Selectsql.Text := ' Select * '+
                                       ' From CLIFOR '+
                                       ' Where NOME='+QuotedStr(Form7.ibDataSet24FORNECEDOR.AsString);
    Form7.ibDataSet2.Open;

    Form7.ibDataSet15CLIENTE.AsString     := Form7.ibDataSet2NOME.AsString;
    Form7.ibDataSet15DESCONTO.AsFloat     := Form7.ibDataSet24DESCONTO.AsFloat;
    Form7.ibDataSet15COMPLEMENTO.AsString := 'ID da NF-e referenciada:' + Form7.ibDataSet24NFEID.AsString;

    Form7.ibDataSet14.Close;
    Form7.ibDataSet14.SelectSQL.Text := ' Select *'+
                                        ' From ICM '+
                                        ' Where SubString(CFOP from 1 for 1) = ''5'' '+
                                        '   or  SubString(CFOP from 1 for 1) = ''6'' '+
                                        '   or SubString(CFOP from 1 for 1) = ''7'' '+
                                        ' Order by upper(NOME)';
    Form7.ibDataSet14.Open;

    Form7.ibDataSet14.Locate('NOME','DEVOLU',[loCaseInsensitive, loPartialKey]);

    if pos('DEVOLU',UpperCase(Form7.ibDataSet14NOME.AsString)) = 0  then
    begin
      Form7.ibDataSet14.Append;
      Form7.ibDataSet14CFOP.AsString := '6202';
      Form7.ibDataSet14NOME.AsString := 'Devolução';
      Form7.ibDataSet14.Post;
    end;

    Form12.Edit2.Text := '4-Devolução de mercadoria';
    Form7.ibDataSet15OPERACAO.AsString := Form7.ibDataSet14NOME.AsString;
    Form7.ibDataSet15FINNFE.AsString   := '4';
    Form12.ExibeColunasFCPST(True);
    Form12.ExibeColunaCSOSN(False);
    
    if Form7.ibDataSet13CRT.AsString = '1' then
    begin
      Form12.ExibeColunaCSOSN(True);
      Form12.ExibeColunaCSTICMS('4', Form7.ibDataSet13CRT.AsString);
    end;

    Form7.Tag := 999;

    try
      Form7.ibDataSet15.Post;
      Form7.ibDataSet15.Edit;

      Application.ProcessMessages; 

      cdsProdutosNota.First;

      while not cdsProdutosNota.Eof do
      begin
        Form12.vNotaFiscal.Calculando := True;

        if (AllTrim(cdsProdutosNotaCODIGO.AsString) <> '')
          and (cdsProdutosNotaMARCADO.AsString = 'S') then
        begin
          Form7.ibDataSet4.Close;
          Form7.ibDataSet4.Selectsql.Text := ' Select * '+
                                             ' From ESTOQUE '+
                                             ' Where CODIGO='+QuotedStr(cdsProdutosNotaCODIGO.AsString);
          Form7.ibDataSet4.Open;

          if cdsProdutosNotaCODIGO.AsString = Form7.ibDataSet4CODIGO.AsString then
          begin
            Form7.ibDataSet16.Append;
            Form7.ibDataSet16CODIGO.AsString    := Form7.ibDataSet4CODIGO.AsString;
            Form7.ibDataSet16ST.AsString        := Form7.ibDataSet4ST.AsString;
            Form7.ibDataSet16PESO.AsFloat       := Form7.ibDataSet4PESO.AsFloat;
            Form7.ibDataSet16CUSTO.AsFloat      := Form7.ibDataSet4CUSTOCOMPR.AsFloat;
            Form7.ibDataSet16LISTA.AsFloat      := Form7.ibDataSet4PRECO.AsFloat;
            Form7.ibDataSet16MEDIDA.AsString    := Form7.ibDataSet4MEDIDA.AsString;

            // Acerta os tributos e o CFOP
            Form1.bFlag := True;
            Form7.sModulo                       := 'VENDA';
            Form7.ibDataSet16DESCRICAO.AsString := cdsProdutosNotaDESCRICAO.AsString;
            Form1.bFlag := False;

            Form7.ibDataSet16.Edit;
            Form7.ibDataSet16QUANTIDADE.AsFloat := cdsProdutosNotaQUANTIDADE.AsFloat;
            Form7.ibDataSet16.Edit;
            Form7.ibDataSet16UNITARIO.AsFloat   := cdsProdutosNotaUNITARIO.AsFloat;
            Form7.ibDataSet16IPI.AsFloat        := cdsProdutosNotaIPI.AsFloat;

            Form7.ibDataSet16VIPI.AsFloat       := Arredonda2(cdsProdutosNotaVIPI.AsFloat,2);
            Form7.ibDataSet16ICM.Asfloat        := cdsProdutosNotaICM.Asfloat;
            Form7.ibDataSet16CST_ICMS.AsString  := cdsProdutosNotaCST_ICMS.AsString;
            Form7.ibDataSet16CFOP.AsString      := Form7.ibDataSet14CFOP.AsString;
            Form7.ibDataSet16VICMS.AsFloat      := cdsProdutosNotaVICMS.AsFloat;
            Form7.ibDataSet16VBC.AsFloat        := cdsProdutosNotaVBC.AsFloat;
            Form7.ibDataSet16VBCST.AsFloat      := cdsProdutosNotaVBCST.AsFloat;
            Form7.ibDataSet16VICMSST.AsFloat    := cdsProdutosNotaVICMSST.AsFloat;
            Form7.ibDataSet16VBCFCPST.AsFloat   := cdsProdutosNotaVBCFCPST.AsFloat;
            Form7.ibDataSet16PFCPST.AsFloat     := cdsProdutosNotaPFCPST.AsFloat;
            //F-7824 Sandro Silva 2024-01-17 Form7.ibDataSet16VFCPST.AsFloat     := cdsProdutosNotaVFCPST.AsFloat;
          end;
        end;

        cdsProdutosNota.Next;
      end;
    except
    end;

    Form7.Tag := 0;

    Form7.sModulo := 'VENDA';
    Form7.ibDataSet16.Edit;
    Form7.ibDataSet16.Post;
    Form7.sModulo := 'OS';
    Form7.ibDataSet16.Edit;

    Form7.ibDataSet16.EnableControls;
    Form7.ibDataSet16.MoveBy(-1);
    Form7.ibDataSet16.MoveBy(1);
    Form12.DBGrid1.Update;
    
    if Form12.vNotaFiscal <> nil then
    begin
      Form12.vNotaFiscal.Calculando := False; 
      Form12.vNotaFiscal.CalculaValores(Form7.ibDataSet15, Form7.ibDataSet16);
    end;

    // Força o cálculo de totais e de impostos
    Form7.ibDataSet15MERCADORIAChange(Form7.ibDataSet15MERCADORIA);

    {Sandro Silva 2023-05-15 inicio}
    // Para exibir os dados do destinatário na tela de lançamento da nota
    Form7.ibDataSet2.Close;
    Form7.ibDataSet2.Selectsql.Text := ' Select *'+
                                       ' From CLIFOR'+
                                       ' Where NOME='+QuotedStr(Form7.ibDataSet15CLIENTE.AsString);
    Form7.ibDataSet2.Open;
    {Sandro Silva 2023-05-15 fim}
  finally

  end;

  Form12.dbGrid1.SetFocus;
end;

procedure TFrmProdutosDevolucao.AtualizaValoresItem;
var
  vQtdNova, vQtdAntes : Real;
begin
  try
    vQtdNova  := cdsProdutosNotaQUANTIDADE.AsFloat;
    vQtdAntes := cdsProdutosNotaQUANTIDADE_ANT.AsFloat;

    cdsProdutosNotaTOTAL.AsFloat      := vQtdNova * cdsProdutosNotaUNITARIO.AsFloat;
    cdsProdutosNotaVIPI.AsFloat       := vQtdNova * (cdsProdutosNotaVIPI_ANT.AsFloat / vQtdAntes);
    cdsProdutosNotaICM.Asfloat        := vQtdNova * (cdsProdutosNotaICM_ANT.Asfloat / vQtdAntes);
    cdsProdutosNotaVICMS.AsFloat      := vQtdNova * (cdsProdutosNotaVICMS_ANT.AsFloat / vQtdAntes);
    cdsProdutosNotaVBC.AsFloat        := vQtdNova * (cdsProdutosNotaVBC_ANT.AsFloat / vQtdAntes);
    cdsProdutosNotaVBCST.AsFloat      := vQtdNova * (cdsProdutosNotaVBCST_ANT.AsFloat / vQtdAntes);
    cdsProdutosNotaVICMSST.AsFloat    := vQtdNova * (cdsProdutosNotaVICMSST_ANT.AsFloat / vQtdAntes);
    cdsProdutosNotaVBCFCPST.AsFloat   := vQtdNova * (cdsProdutosNotaVBCFCPST_ANT.AsFloat / vQtdAntes);
    //F-7824 Sandro Silva 2024-01-17 cdsProdutosNotaVFCPST.AsFloat     := vQtdNova * (cdsProdutosNotaVFCPST_ANT.AsFloat / vQtdAntes);
  except
    MensagemSistema('Problema ao calcular valores. Verifique',msgErro);
  end;
end;

procedure TFrmProdutosDevolucao.FormShow(Sender: TObject);
var
  CasasQtd, CasasPreco: integer;

  oArqDat: TArquivosDAT;
begin
  oArqDat := TArquivosDAT.Create(Usuario);
  try
    CasasQtd    := oArqDat.SmallCom.Outros.CasasDecimaisQuantidade;
    CasasPreco  := oArqDat.SmallCom.Outros.CasasDecimaisPreco;
  finally
    FreeAndNil(oArqDat);
  end;

  case CasasQtd of
    0: cdsProdutosNotaQUANTIDADE.DisplayFormat := '#,##0';
    1: cdsProdutosNotaQUANTIDADE.DisplayFormat := '#,##0.0';
    2: cdsProdutosNotaQUANTIDADE.DisplayFormat := '#,##0.00';
    3: cdsProdutosNotaQUANTIDADE.DisplayFormat := '#,##0.000';
    4: cdsProdutosNotaQUANTIDADE.DisplayFormat := '#,##0.0000';
    5: cdsProdutosNotaQUANTIDADE.DisplayFormat := '#,##0.00000';
    6: cdsProdutosNotaQUANTIDADE.DisplayFormat := '#,##0.000000';
    7: cdsProdutosNotaQUANTIDADE.DisplayFormat := '#,##0.0000000';
    8: cdsProdutosNotaQUANTIDADE.DisplayFormat := '#,##0.00000000';
    9: cdsProdutosNotaQUANTIDADE.DisplayFormat := '#,##0.000000000';
  end;

  case CasasPreco of
    0: cdsProdutosNotaUNITARIO.DisplayFormat := '#,##0';
    1: cdsProdutosNotaUNITARIO.DisplayFormat := '#,##0.0';
    2: cdsProdutosNotaUNITARIO.DisplayFormat := '#,##0.00';
    3: cdsProdutosNotaUNITARIO.DisplayFormat := '#,##0.000';
    4: cdsProdutosNotaUNITARIO.DisplayFormat := '#,##0.0000';
    5: cdsProdutosNotaUNITARIO.DisplayFormat := '#,##0.00000';
    6: cdsProdutosNotaUNITARIO.DisplayFormat := '#,##0.000000';
    7: cdsProdutosNotaUNITARIO.DisplayFormat := '#,##0.0000000';
    8: cdsProdutosNotaUNITARIO.DisplayFormat := '#,##0.00000000';
    9: cdsProdutosNotaUNITARIO.DisplayFormat := '#,##0.000000000';
  end;

  case CasasPreco of
    0: cdsProdutosNotaTOTAL.DisplayFormat := '#,##0';
    1: cdsProdutosNotaTOTAL.DisplayFormat := '#,##0.0';
    2: cdsProdutosNotaTOTAL.DisplayFormat := '#,##0.00';
    3: cdsProdutosNotaTOTAL.DisplayFormat := '#,##0.000';
    4: cdsProdutosNotaTOTAL.DisplayFormat := '#,##0.0000';
    5: cdsProdutosNotaTOTAL.DisplayFormat := '#,##0.00000';
    6: cdsProdutosNotaTOTAL.DisplayFormat := '#,##0.000000';
    7: cdsProdutosNotaTOTAL.DisplayFormat := '#,##0.0000000';
    8: cdsProdutosNotaTOTAL.DisplayFormat := '#,##0.00000000';
    9: cdsProdutosNotaTOTAL.DisplayFormat := '#,##0.000000000';
  end;

  cdsProdutosNota.Open;
end;

procedure TFrmProdutosDevolucao.cdsProdutosNotaBeforeDelete(
  DataSet: TDataSet);
begin
  Abort;
end;

procedure TFrmProdutosDevolucao.FormCreate(Sender: TObject);
var
  SizeDescricaoProd : integer;
begin
  SizeDescricaoProd := TamanhoCampoFB(Form7.IBDatabase1,'ESTOQUE','DESCRICAO'); // Mauricio Parizotto 2023-12-21
  cdsProdutosNotaDESCRICAO.Size := SizeDescricaoProd;
  ibdProdutosNotaDESCRICAO.Size := SizeDescricaoProd;
end;

procedure TFrmProdutosDevolucao.dbgPrincipalKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  DBGridCopiarCampo((Sender as TDBGrid), Key, Shift); // Mauricio Parizotto 2023-12-26
end;

end.
