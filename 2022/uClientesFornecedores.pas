unit uClientesFornecedores;

interface

uses
  SysUtils
  , Dialogs
  , IBDatabase
  , IBQuery
  ,uFuncoesBancoDados
  //,MD5
;

  //Mauricio Parizotto 2023-05-04
  function AtualizaDescricaoCliFor(sNomeNovo, sNomeAtual :string; Banco: TIBDatabase):Boolean;

implementation

uses Unit7, Mais, uFuncoesRetaguarda, uDialogs, uFuncaoMD5;

function AtualizaDescricaoCliFor(sNomeNovo, sNomeAtual :string; Banco: TIBDatabase):Boolean;
var
  vMensagem : string;
  IBTRANSACTION: TIBTransaction;
begin
  Result := True;

  IBTRANSACTION := CriaIBTransaction(Banco);

  try
    try
      // CODEBAR
      if not ExecutaComando(' update CODEBAR set FORNECEDOR='+QuotedStr(sNomeNovo)+
                            ' where FORNECEDOR='+QuotedStr(sNomeAtual),
                            IBTRANSACTION) then
      begin
        Result := False;
        vMensagem := #13#10+'Código Barras Fornecedor';
        Exit;
      end;

      // RECEBER
      if not ExecutaComando(' update RECEBER set NOME='+QuotedStr(sNomeNovo)+
                            ' where NOME='+QuotedStr(sNomeAtual),
                            IBTRANSACTION) then
      begin
        Result := False;
        vMensagem := #13#10+'Contas a Receber';
        Exit;
      end;

      // RECEBER.INSTITUICAOFINANCEIRA
      if not ExecutaComando(' update RECEBER set INSTITUICAOFINANCEIRA='+QuotedStr(sNomeNovo)+
                            ' where INSTITUICAOFINANCEIRA='+QuotedStr(sNomeAtual),
                            IBTRANSACTION) then
      begin
        Result := False;
        vMensagem := #13#10+'Contas a Receber - Instituição';
        Exit;
      end;

      // BANCOS.INSTITUICAOFINANCEIRA
      if not ExecutaComando(' update BANCOS set INSTITUICAOFINANCEIRA='+QuotedStr(sNomeNovo)+
                            ' where INSTITUICAOFINANCEIRA='+QuotedStr(sNomeAtual),
                            IBTRANSACTION) then
      begin
        Result := False;
        vMensagem := #13#10+'Contas Bancárias - Instituição';
        Exit;
      end;

      // PAGAR
      if not ExecutaComando(' update PAGAR set NOME='+QuotedStr(sNomeNovo)+
                            ' where NOME='+QuotedStr(sNomeAtual),
                            IBTRANSACTION) then
      begin
        Result := False;
        vMensagem := #13#10+'Contas a Pagar';
        Exit;
      end;

      // OS
      if not ExecutaComando(' update OS set CLIENTE='+QuotedStr(sNomeNovo)+
                            ' where CLIENTE='+QuotedStr(sNomeAtual),
                            IBTRANSACTION)then
      begin
        Result := False;
        vMensagem := #13#10+'Ordem de Serviço';
        Exit;
      end;

      // VENDAS
      if not ExecutaComando(' update VENDAS set CLIENTE='+QuotedStr(sNomeNovo)+
                            //'  , ENCRYPTHASH='+QuotedStr(Form7.LbBlowfish1.EncryptString(MD5Print(MD5String(Form1.sPasta))))+
                            '  , ENCRYPTHASH='+QuotedStr(Form7.LbBlowfish1.EncryptString(MD5String(Form1.sPasta)))+
                            ' where CLIENTE='+QuotedStr(sNomeAtual),
                            IBTRANSACTION) then
      begin
        Result := False;
        vMensagem := #13#10+'Vendas';
        Exit;
      end;

      // COMPRAS
      if not ExecutaComando(' update COMPRAS set FORNECEDOR='+QuotedStr(sNomeNovo)+
                            ' where FORNECEDOR='+QuotedStr(sNomeAtual),
                            IBTRANSACTION) then
      begin
        Result := False;
        vMensagem := #13#10+'Compras';
        Exit;
      end;

      // ITENS DE COMPRA
      if not ExecutaComando(' update ITENS002 set FORNECEDOR='+QuotedStr(sNomeNovo)+
                            ' where FORNECEDOR='+QuotedStr(sNomeAtual),
                            IBTRANSACTION) then
      begin
        Result := False;
        vMensagem := #13#10+'Itens Compras';
        Exit;
      end;

      // ESTOQUE
      if not ExecutaComando(' update ESTOQUE set FORNECEDOR='+QuotedStr(sNomeNovo)+
                            ' where FORNECEDOR='+QuotedStr(sNomeAtual),
                            IBTRANSACTION) then
      begin
        Result := False;
        vMensagem := #13#10+'Estoque';
        Exit;
      end;

      // ORCAMENTO
      if not ExecutaComando(' update ORCAMENT set CLIFOR='+QuotedStr(sNomeNovo)+
                            //'   , ENCRYPTHASH='+QuotedStr(Form7.LbBlowfish1.EncryptString(MD5Print(MD5String(Form1.sPasta))))+
                            '   , ENCRYPTHASH='+QuotedStr(Form7.LbBlowfish1.EncryptString(MD5String(Form1.sPasta)))+
                            ' where CLIFOR='+QuotedStr(sNomeAtual),
                            IBTRANSACTION) then
      begin
        Result := False;
        vMensagem := #13#10+'Orçamento';
        Exit;
      end;

      // ALTERACA
      if not ExecutaComando(' update ALTERACA set CLIFOR='+QuotedStr(sNomeNovo)+
                            //'  , ENCRYPTHASH='+QuotedStr(Form7.LbBlowfish1.EncryptString(MD5Print(MD5String(Form1.sPasta))))+
                            '  , ENCRYPTHASH='+QuotedStr(Form7.LbBlowfish1.EncryptString(MD5String(Form1.sPasta)))+
                            ' where CLIFOR='+QuotedStr(sNomeAtual),
                            IBTRANSACTION) then
      begin
        Result := False;
        vMensagem := #13#10+'Vendas - PDV';
      end;

     finally
      if Result = False then
      begin
        //Se não conseguir alterar em algum lugar cancela tudo
        {
        ShowMessage('Não foi possível alterar o nome para '+sNomeNovo+'.'#13#10+
                    'Registro em uso no seguinte local:'+#13#10+vMensagem);
        Mauricio Parizotto 2023-10-25}
        MensagemSistema('Não foi possível alterar o nome para '+sNomeNovo+'.'#13#10+
                        'Registro em uso no seguinte local:'+#13#10+vMensagem
                        ,msgAtencao);

        IBTRANSACTION.Rollback;
      end else
      begin
        IBTRANSACTION.Commit;
      end;
    end;
  except
  end;

  FreeAndNil(IBTRANSACTION);
end;

end.
