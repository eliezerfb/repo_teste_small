unit uAtualizaTributacaoPerfilTrib;

interface

uses SysUtils;

  function AtualizaTibutacaoProduto(IDPerfil:integer; out ProdutosErro : string):Boolean;

implementation

uses Unit7;

function AtualizaTibutacaoProduto(IDPerfil:integer; out ProdutosErro : string):Boolean;
var
  BufferAntes : integer;
begin
  Result := False;

  try
    BufferAntes := Form7.ibDataSet4.BufferChunks;
    Form7.ibDataSet4.BufferChunks := 10;

    Form7.ibDataSet4.DisableControls;
    Form7.ibDataSet4.Close;
    Form7.ibDataSet4.SelectSQL.Text := ' Select * '+
                                       ' From ESTOQUE '+
                                       ' Where IDPERFILTRIBUTACAO = '+IntToStr(IDPerfil);
    Form7.ibDataSet4.Open;

    while not Form7.ibDataSet4.Eof do
    begin
      try
        Form7.ibDataSet4.Edit;

        Form7.ibDataSet4TIPO_ITEM.AsString               := Form7.ibdPerfilTributaTIPO_ITEM.AsString;
        Form7.ibDataSet4IPPT.AsString                    := Form7.ibdPerfilTributaIPPT.AsString;
        Form7.ibDataSet4IAT.AsString                     := Form7.ibdPerfilTributaIAT.AsString;
        Form7.ibDataSet4PIVA.AsString                    := Form7.ibdPerfilTributaPIVA.AsString;
        Form7.ibDataSet4CST.AsString                     := Form7.ibdPerfilTributaCST.AsString;
        Form7.ibDataSet4CSOSN.AsString                   := Form7.ibdPerfilTributaCSOSN.AsString;
        Form7.ibDataSet4ST.AsString                      := Form7.ibdPerfilTributaST.AsString;
        Form7.ibDataSet4CFOP.AsString                    := Form7.ibdPerfilTributaCFOP.AsString;
        Form7.ibDataSet4CST_NFCE.AsString                := Form7.ibdPerfilTributaCST_NFCE.AsString;
        Form7.ibDataSet4CSOSN_NFCE.AsString              := Form7.ibdPerfilTributaCSOSN_NFCE.AsString;
        Form7.ibDataSet4ALIQUOTA_NFCE.AsString           := Form7.ibdPerfilTributaALIQUOTA_NFCE.AsString;
        Form7.ibDataSet4CST_IPI.AsString                 := Form7.ibdPerfilTributaCST_IPI.AsString;
        Form7.ibDataSet4IPI.AsString                     := Form7.ibdPerfilTributaIPI.AsString;
        Form7.ibDataSet4ENQ_IPI.AsString                 := Form7.ibdPerfilTributaENQ_IPI.AsString;
        Form7.ibDataSet4CST_PIS_COFINS_SAIDA.AsString    := Form7.ibdPerfilTributaCST_PIS_COFINS_SAIDA.AsString;
        Form7.ibDataSet4ALIQ_PIS_SAIDA.AsString          := Form7.ibdPerfilTributaALIQ_PIS_SAIDA.AsString;
        Form7.ibDataSet4ALIQ_COFINS_SAIDA.AsString       := Form7.ibdPerfilTributaALIQ_COFINS_SAIDA.AsString;
        Form7.ibDataSet4CST_PIS_COFINS_ENTRADA.AsString  := Form7.ibdPerfilTributaCST_PIS_COFINS_ENTRADA.AsString;
        Form7.ibDataSet4ALIQ_COFINS_ENTRADA.AsString     := Form7.ibdPerfilTributaALIQ_COFINS_ENTRADA.AsString;
        Form7.ibDataSet4ALIQ_PIS_ENTRADA.AsString        := Form7.ibdPerfilTributaALIQ_PIS_ENTRADA.AsString;

        Form7.ibDataSet4.post;
      except
        ProdutosErro := ProdutosErro+#13#10;
      end;

      Form7.ibDataSet4.Next;
    end;

  finally
    Form7.ibDataSet4.BufferChunks := BufferAntes;
    Form7.ibDataSet4.EnableControls;
  end;

  Result := ProdutosErro = '';
end;

end.
