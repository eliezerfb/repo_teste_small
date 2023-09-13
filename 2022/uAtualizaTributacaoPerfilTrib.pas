unit uAtualizaTributacaoPerfilTrib; //Mauricio Parizotto 2023-09-12

interface

uses
  SysUtils
  , Forms
  , Controls
  , IBCustomDataSet
  , DB
  ;

  function AtualizaTibutacaoProduto(IDPerfil:integer; out ProdutosErro : string):Boolean;

implementation

uses Unit7, uFuncoesBancoDados;

function AtualizaTibutacaoProduto(IDPerfil:integer; out ProdutosErro : string):Boolean;
var
  ibdEstoque : TIBDataSet;
begin
  Result := False;
  Screen.Cursor            := crHourGlass;

  ibdEstoque := CriaIDataSet(Form7.ibDataSet4.Transaction);

  ibdEstoque.ModifySQL  := Form7.ibDataSet4.ModifySQL;
  ibdEstoque.RefreshSQL := Form7.ibDataSet4.RefreshSQL;

  try
    ibdEstoque.DisableControls;
    ibdEstoque.Close;
    ibdEstoque.SelectSQL.Text := ' Select * '+
                                 ' From ESTOQUE '+
                                 ' Where IDPERFILTRIBUTACAO = '+IntToStr(IDPerfil);
    ibdEstoque.Open;

    while not ibdEstoque.Eof do
    begin
      try
        ibdEstoque.Edit;

        ibdEstoque.FieldByName('TIPO_ITEM').AsString               := Form7.ibdPerfilTributaTIPO_ITEM.AsString;
        ibdEstoque.FieldByName('IPPT').AsString                    := Form7.ibdPerfilTributaIPPT.AsString;
        ibdEstoque.FieldByName('IAT').AsString                     := Form7.ibdPerfilTributaIAT.AsString;
        ibdEstoque.FieldByName('PIVA').AsString                    := Form7.ibdPerfilTributaPIVA.AsString;
        ibdEstoque.FieldByName('CST').AsString                     := Form7.ibdPerfilTributaCST.AsString;
        ibdEstoque.FieldByName('CSOSN').AsString                   := Form7.ibdPerfilTributaCSOSN.AsString;
        ibdEstoque.FieldByName('ST').AsString                      := Form7.ibdPerfilTributaST.AsString;
        ibdEstoque.FieldByName('CFOP').AsString                    := Form7.ibdPerfilTributaCFOP.AsString;
        ibdEstoque.FieldByName('CST_NFCE').AsString                := Form7.ibdPerfilTributaCST_NFCE.AsString;
        ibdEstoque.FieldByName('CSOSN_NFCE').AsString              := Form7.ibdPerfilTributaCSOSN_NFCE.AsString;
        ibdEstoque.FieldByName('ALIQUOTA_NFCE').AsString           := Form7.ibdPerfilTributaALIQUOTA_NFCE.AsString;
        ibdEstoque.FieldByName('CST_IPI').AsString                 := Form7.ibdPerfilTributaCST_IPI.AsString;
        ibdEstoque.FieldByName('IPI').AsString                     := Form7.ibdPerfilTributaIPI.AsString;
        ibdEstoque.FieldByName('ENQ_IPI').AsString                 := Form7.ibdPerfilTributaENQ_IPI.AsString;
        ibdEstoque.FieldByName('CST_PIS_COFINS_SAIDA').AsString    := Form7.ibdPerfilTributaCST_PIS_COFINS_SAIDA.AsString;
        ibdEstoque.FieldByName('ALIQ_PIS_SAIDA').AsString          := Form7.ibdPerfilTributaALIQ_PIS_SAIDA.AsString;
        ibdEstoque.FieldByName('ALIQ_COFINS_SAIDA').AsString       := Form7.ibdPerfilTributaALIQ_COFINS_SAIDA.AsString;
        ibdEstoque.FieldByName('CST_PIS_COFINS_ENTRADA').AsString  := Form7.ibdPerfilTributaCST_PIS_COFINS_ENTRADA.AsString;
        ibdEstoque.FieldByName('ALIQ_COFINS_ENTRADA').AsString     := Form7.ibdPerfilTributaALIQ_COFINS_ENTRADA.AsString;
        ibdEstoque.FieldByName('ALIQ_PIS_ENTRADA').AsString        := Form7.ibdPerfilTributaALIQ_PIS_ENTRADA.AsString;

        AssinaRegistro('ESTOQUE',ibdEstoque, True);
        ibdEstoque.post;
      except
        ProdutosErro := ProdutosErro+ibdEstoque.FieldByName('DESCRICAO').AsString+#13#10;
      end;

      ibdEstoque.Next;
    end;

  finally
    FreeAndNil(ibdEstoque);
    Screen.Cursor            := crDefault;
  end;

  Result := ProdutosErro = '';

  AgendaCommit(true);
end;

end.
