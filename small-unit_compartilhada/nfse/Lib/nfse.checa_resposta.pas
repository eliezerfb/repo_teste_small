unit nfse.checa_resposta;

interface

uses
  System.SysUtils,

  ACBrNFSeX,
  ACBrDFeSSL,
  pcnConversao,
  ACBrNFSeXConversao,
  ACBrDFeUtil,

  nfse.classe.retorno;

type
  TCheckAnswer = class
  public
    class procedure ChecarResposta(AcbrNFSe: TACBrNFSeX;
      classRetorno: TNFSeRetorno; aMetodo: TMetodo);
  end;

implementation

{ TCheckAnswer }

class procedure TCheckAnswer.ChecarResposta(AcbrNFSe: TACBrNFSeX;
  classRetorno: TNFSeRetorno; aMetodo: TMetodo);
const
  StartTAG_XML = 'starttag: invalid element name';
var
  i: Integer;
  cancelamento : boolean;
  statusTemp : string;

function getNumeroNfse: String;
begin
  if (AcbrNFSe.Configuracoes.Geral.Provedor = proIPM) then
    Exit(classRetorno.Numero_origem);

  if (AcbrNFSe.Configuracoes.Geral.Provedor = proISSJoinville) then
    Exit(classRetorno.Numero);

  Exit(AcbrNFSe.NotasFiscais.Items[0].NFSe.Numero);
end;

begin
  cancelamento := False;

  with AcbrNFSe.WebService do
  begin
    case aMetodo of
      tmRecepcionar,
      tmTeste:
        begin
          with Emite do
          begin
            classRetorno.Protocolo          := Protocolo;
            classRetorno.Numero             := NumeroNota;
            classRetorno.Numero_origem      := NumeroNota;
            classRetorno.Url                := Link;
            classRetorno.CodigoVerificacao  := CodigoVerificacao;
            classRetorno.Mensagem           := DescSituacao;
            classRetorno.Sucesso            := Sucesso;
            classRetorno.Data               := Data;

            statusTemp :=
              'Protocolo: '+Protocolo +
              ' Numero: '+NumeroNota+ 'Link: '+Link+
              'Cód verificação: '+CodigoVerificacao+' Situação: '+Situacao+
              ' Mensagem: '+DescSituacao+ ' Sucesso: '+BoolToStr(Sucesso);

            if not(NumeroNota = '') and
              (AcbrNFSe.Configuracoes.Geral.Provedor in (
                [proISSSaoPaulo, proSiapSistemas, proSystemPro, proISSGoiania]
              ))
            then begin
              classRetorno.Situacao := 4;
              classRetorno.Mensagem := 'Processado com sucesso';
            end;

            if (Sucesso) and
               (Erros.Count <= 0) and
               (NumeroNota <> EmptyStr) and
               (ACBrNFSe.Configuracoes.Geral.Provedor in [proISSNet,
                  proIPM,
                  proSoftPlan,
                  proBetha]) then
            begin
              classRetorno.Situacao := 4;
              classRetorno.Mensagem := 'Processado com sucesso';
            end;

            if Erros.Count > 0 then
            begin
              classRetorno.Situacao   := 3;
              for i := 0 to Erros.Count -1 do
              begin
                classRetorno.Mensagem := Erros[i].Descricao;
                classRetorno.Correcao := Erros[i].Correcao;

                if (Pos(StartTAG_XML, AnsiLowerCase(classRetorno.Mensagem)) > 0) and
                   (AcbrNFSe.Configuracoes.Geral.Provedor = proBetha) then
                begin
                  classRetorno.Correcao := Trim(classRetorno.Correcao +
                                              ' Acesse o portal do provedor e consulte o resultado do processamento desse RPS');
                end;
                if (pos(classRetorno.Mensagem,classRetorno.mensagemCompleta) = 0) and
                   (pos('(ListaNfse)',classRetorno.Mensagem) = 0) then
                  classRetorno.mensagemCompleta := classRetorno.mensagemCompleta +
                                                    ' Erro: '+ classRetorno.Mensagem+#13+
                                                    ' Correção:'+classRetorno.Correcao+#13;
              end;
            end;

            if classRetorno.Situacao <> 4 then
            begin
              if Alertas.Count > 0 then
              begin
                for i := 0 to Alertas.Count -1 do
                begin
                  classRetorno.Mensagem := Erros[i].Descricao;
                  classRetorno.Correcao := Erros[i].Correcao;
                  if (pos(classRetorno.Mensagem, classRetorno.mensagemCompleta) = 0) then
                    classRetorno.mensagemCompleta := classRetorno.mensagemCompleta +
                                                    ' Erro: '+ Erros[i].Descricao+#13+
                                                    ' Correção :'+Erros[i].Correcao+#13;
                end;
              end;
            end;
          end;

          if AcbrNFSe.Configuracoes.Geral.ConsultaLoteAposEnvio and
            ((Emite.Protocolo <> '') or (Emite.NumeroLote <> '')) then
          begin
            if AcbrNFSe.Provider.ConfigGeral.ConsultaSitLote then
            begin
              with ConsultaSituacao do
              begin
                classRetorno.Situacao        := StrToIntDef(Situacao,0);
                classRetorno.Protocolo       := Protocolo;
                classRetorno.Numero          := NumeroNota;
                classRetorno.Mensagem        := DescSituacao;
                classRetorno.Sucesso         := Sucesso;
                classRetorno.Data            := Data;
                if classRetorno.Situacao = 4 then
                  classRetorno.Mensagem      := 'Processado com sucesso';

                statusTemp := 'Protocolo: '+Protocolo + ' Numero: '+NumeroNota+ ' Link: '+Link+ ' Situação: '+Situacao+
                          ' Mensagem: '+DescSituacao+ ' Sucesso: '+BoolToStr(Sucesso);
                if Erros.Count > 0 then
                begin
                  for i := 0 to Erros.Count -1 do
                  begin
                    if (pos('(ListaNfse)',Erros[i].Descricao) = 0) then
                    begin
                      classRetorno.Situacao   := 3;
                      classRetorno.Mensagem := Erros[i].Descricao;
                      classRetorno.Correcao := Erros[i].Correcao;
                      if pos(classRetorno.Mensagem, classRetorno.mensagemCompleta) = 0 then
                        classRetorno.mensagemCompleta :=
                          classRetorno.mensagemCompleta +
                          ' Erro: '+ Erros[i].Descricao+#13+
                          ' Correção :'+Erros[i].Correcao+#13;
                    end;
                  end;
                end;

                if ((Alertas.Count > 0) and (AcbrNFSe.Configuracoes.Geral.Provedor <> proInfisc)) or
                  ((AcbrNFSe.Configuracoes.Geral.Provedor = proInfisc) and (classRetorno.Situacao <> 4)) then
                begin
                  for i := 0 to Alertas.Count -1 do
                  begin
                    if (pos('(ListaNfse)',Erros[i].Descricao) = 0) then
                    begin
                      classRetorno.Mensagem := Alertas[i].Descricao;
                      classRetorno.Correcao := Alertas[i].Correcao;
                      if pos(classRetorno.Mensagem,classRetorno.mensagemCompleta) = 0 then
                        classRetorno.mensagemCompleta :=
                          classRetorno.mensagemCompleta +
                          ' Erro: '+ Alertas[i].Descricao+#13+
                          ' Correção :'+Alertas[i].Correcao+#13;
                    end;
                  end;
                end;
              end;
            end;

            if (AcbrNFSe.Provider.ConfigGeral.ConsultaLote) then
            begin
              with ConsultaLoteRps do
              begin
                if (classRetorno.Situacao =  2) and (Situacao <>  '') then
                  classRetorno.Situacao        := StrToIntDef(Situacao,0);
                if classRetorno.Protocolo = EmptyStr then
                  classRetorno.Protocolo       := Protocolo;
                if (classRetorno.Numero = EmptyStr) or ((classRetorno.Numero = '0')) then
                  classRetorno.Numero          := NumeroNota;
                classRetorno.Mensagem        := DescSituacao;
                classRetorno.Sucesso         := Sucesso;
                statusTemp                   := Situacao;
                if classRetorno.Situacao = 4 then
                  classRetorno.Mensagem      := 'Processado com sucesso';

                statusTemp := 'Protocolo: '+Protocolo + ' Numero: '+NumeroNota+ 'Link: '+Link+ 'Cód verificação: '+CodigoVerificacao+
                          ' Situação: '+Situacao+ ' Mensagem: '+DescSituacao+ ' Sucesso: '+BoolToStr(Sucesso);

                if Resumos.Count > 0 then
                begin
                  for i := 0 to Resumos.Count -1 do
                  begin
                    classRetorno.Numero         := Resumos[i].NumeroNota;
                    classRetorno.CodigoVerificacao := Resumos[i].CodigoVerificacao;
                  end;
                end;

                if Erros.Count > 0 then
                begin
                  for i := 0 to erros.Count -1 do
                  begin
                    if (pos('(ListaNfse)',Erros[i].Descricao) = 0) then
                    begin
                      classRetorno.Situacao   := 3;
                      classRetorno.Mensagem := Erros[i].Descricao;
                      classRetorno.Correcao := Erros[i].Correcao;
                      if pos(classRetorno.Mensagem,classRetorno.mensagemCompleta) = 0 then
                        classRetorno.mensagemCompleta :=
                          classRetorno.mensagemCompleta +
                          ' Erro: '+ Erros[i].Descricao+#13+
                          ' Correção :'+Erros[i].Correcao+#13;
                    end;
                  end;
                end;

                if Alertas.Count > 0 then
                begin
                  for I := 0 to Alertas.count - 1 do
                  begin
                    if (pos('(ListaNfse)',Erros[i].Descricao) = 0) then
                    begin
                      classRetorno.Mensagem := Alertas[i].Descricao;
                      classRetorno.Correcao := Alertas[i].Correcao;
                      if pos(classRetorno.Mensagem, classRetorno.mensagemCompleta) = 0 then
                        classRetorno.mensagemCompleta :=
                          classRetorno.mensagemCompleta +
                          ' Erro: '+ Alertas[i].Descricao+#13+
                          ' Correção :'+Alertas[i].Correcao+#13;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      tmRecepcionarSincrono,
      tmGerar:
        begin
          with Emite do
          begin
            classRetorno.Protocolo       := Protocolo;
            classRetorno.Numero          := NumeroNota;
            classRetorno.Url                := Link;
            classRetorno.CodigoVerificacao  := CodigoVerificacao;
            classRetorno.Mensagem        := DescSituacao;
            classRetorno.Data            := Data;
            classRetorno.Sucesso         := Sucesso;
            statusTemp                   := Situacao;
            if Sucesso then
            begin
              classRetorno.Situacao        := 4;
              classRetorno.Mensagem      := 'Processado com sucesso';
            end
            else
              classRetorno.Situacao        := 3;


            if Erros.Count > 0 then
            begin
              for I := 0 to Erros.count - 1 do
              begin
                if (pos('(ListaNfse)',Erros[i].Descricao) = 0) then
                begin
                  classRetorno.Mensagem := Erros[i].Descricao;
                  classRetorno.Correcao := Erros[i].Correcao;
                  if pos(classRetorno.Mensagem, classRetorno.mensagemCompleta) = 0 then
                    classRetorno.mensagemCompleta := classRetorno.mensagemCompleta +
                                                      ' Erro: '+ Erros[i].Descricao+#13+
                                                      ' Correção :'+Erros[i].Correcao+#13;
                end;
              end;
            end;

            if Alertas.Count > 0 then
            begin
              for I := 0 to Alertas.count -1 do
              begin
                if (pos('(ListaNfse)',Erros[i].Descricao) = 0) then
                begin
                  classRetorno.Mensagem := Alertas[i].Descricao;
                  classRetorno.Correcao := Alertas[i].Correcao;
                  if pos(classRetorno.Mensagem,classRetorno.mensagemCompleta) = 0 then
                    classRetorno.mensagemCompleta := classRetorno.mensagemCompleta +
                                                      ' Erro: '+ Alertas[i].Descricao+#13+
                                                      ' Correção :'+Alertas[i].Correcao+#13;
                end;
              end;
            end;
          end;
        end;

      tmConsultarSituacao:
        begin
          with ConsultaSituacao do
          begin
            classRetorno.Protocolo       := Protocolo;
            classRetorno.Situacao        := StrToIntDef(situacao,0);
            classRetorno.Mensagem        := DescSituacao;
            classRetorno.Sucesso         := Sucesso;
            statusTemp                   := Situacao;

            if Erros.Count > 0 then
            begin
              for I := 0 to Erros.Count - 1 do
              begin
                if (pos('(ListaNfse)',Erros[i].Descricao) = 0) then
                begin
                  classRetorno.Mensagem := Erros[i].Descricao;
                  classRetorno.Correcao := Erros[i].Correcao;
                  if pos(classRetorno.Mensagem,classRetorno.mensagemCompleta) = 0 then
                    classRetorno.mensagemCompleta := classRetorno.mensagemCompleta +
                                                      ' Erro: '+ Erros[i].Descricao+#13+
                                                      ' Correção :'+Erros[i].Correcao+#13;
                end;
              end;
            end;

            if Alertas.Count > 0 then
            begin
              for I := 0 to Alertas.Count - 1 do
              begin
                if (pos('(ListaNfse)',Erros[i].Descricao) = 0) then
                begin
                  classRetorno.Mensagem := Alertas[i].Descricao;
                  classRetorno.Correcao := Alertas[i].Correcao;
                  if pos(classRetorno.Mensagem,classRetorno.mensagemCompleta) = 0 then
                    classRetorno.mensagemCompleta := classRetorno.mensagemCompleta +
                                                      ' Erro: '+ Alertas[i].Descricao+#13+
                                                      ' Correção :'+Alertas[i].Correcao+#13;
                end;
              end;
            end;
          end;
        end;

      tmConsultarLote:
        begin
          with ConsultaLoteRps do
          begin
            classRetorno.Protocolo       := Protocolo;
            classRetorno.Numero          := NumeroNota;
            classRetorno.Url             := Link;
            classRetorno.Situacao        := StrToIntDef(Situacao,0);
            classRetorno.Mensagem        := DescSituacao;
            classRetorno.Sucesso         := Sucesso;
            statusTemp                   := Situacao;

            if AcbrNFSe.Configuracoes.Geral.Provedor = proInfisc then
            begin
              if AcbrNFSe.NotasFiscais.Count > 0 then
              begin
                classRetorno.Numero := AcbrNFSe.NotasFiscais.Items[0].NFSe.Numero;
                ClassRetorno.Chave   := AcbrNFSe.NotasFiscais.Items[0].NFSe.refNF;
              end;
              if Situacao = '200' then
                classRetorno.Situacao := 3
              else
              if Situacao = '100' then
              begin
                classRetorno.Situacao := 4;
                classRetorno.Mensagem := 'Processo com sucesso';
                classRetorno.Sucesso  := True;
              end
              else
              if Situacao = '217' then
                classRetorno.Situacao := 2;
            end;

            if Erros.Count > 0 then
            begin
              for I := 0 to Erros.Count - 1 do
              begin
                if classRetorno.Situacao = 200 then
                  classRetorno.Situacao := 3;
                if (pos('(ListaNfse)',Erros[i].Descricao) = 0) then
                begin
                  classRetorno.Mensagem := Erros[i].Descricao;
                  classRetorno.Correcao := Erros[i].Correcao;
                  if pos(classRetorno.Mensagem,classRetorno.mensagemCompleta) = 0 then
                  begin
                    if Pos('accessing address',(Erros[i].Descricao)) = 0  then
                      classRetorno.mensagemCompleta := classRetorno.mensagemCompleta +
                                                      ' Erro: '+ Erros[i].Descricao+#13+
                                                      ' Correção :'+Erros[i].Correcao+#13
                    else
                      classRetorno.mensagemCompleta := 'Erro não identificado no processamento da NFS-e. Verifique no site da sua prefeitura.';
                  end;
                end;
                statusTemp := Erros[i].Descricao +Erros[i].Correcao;
                if Pos('foi emitida',LowerCase(Erros[i].Descricao +Erros[i].Correcao)) > 0 then
                begin
                  classRetorno.Situacao := 4;
                  classRetorno.Mensagem := 'Processo com sucesso';
                  classRetorno.Sucesso  := True;
                end;
              end;
            end;

            if Alertas.Count > 0 then
            begin
              for I := 0 to Alertas.Count -1 do
              begin
                if (pos('(ListaNfse)',Alertas[i].Descricao) = 0) then
                begin
                classRetorno.Mensagem := Alertas[i].Descricao;
                classRetorno.Correcao := Alertas[i].Correcao;
                if pos(classRetorno.Mensagem,classRetorno.mensagemCompleta) = 0 then
                  classRetorno.mensagemCompleta := classRetorno.mensagemCompleta +
                                                    ' Erro: '+ Alertas[i].Descricao+#13+
                                                    ' Correção :'+Alertas[i].Correcao+#13;
                end;
              end;
            end;
            if classRetorno.Situacao = 4 then
              classRetorno.Mensagem  := 'Processado com sucesso';
          end;
        end;

      tmConsultarNFSePorRps:
        begin
          with ConsultaNFSeporRps do
          begin
            classRetorno.Protocolo       := Protocolo;
            classRetorno.Numero          := NumeroNota;
            classRetorno.Url             := Link;
            classRetorno.CodigoVerificacao  := CodigoVerificacao;
            classRetorno.Situacao           := StrToIntDef(Situacao,0);
            classRetorno.Mensagem           := DescSituacao;

            statusTemp := 'Protocolo: '+Protocolo + ' Numero: '+NumeroNota+ 'Link: '+Link+ 'Cód verificação: '+CodigoVerificacao+
                          ' Situação: '+Situacao+ ' Mensagem: '+DescSituacao+ ' Sucesso: '+BoolToStr(Sucesso) + ' Data cancelamento: '+DateToStr(DataCanc);
            if (DataCanc > 13/10/2023) or (Pos('cancelada',LowerCase(DescSituacao))> 0 ) then
              classRetorno.Cancelada := True;
            if Sucesso = true then
            begin
              classRetorno.Situacao := 4;
              classRetorno.Mensagem := 'Processado com sucesso';
            end;

            if Erros.Count > 0 then
            begin
              for I := 0 to Erros.Count - 1 do
              begin
                if (pos('(ListaNfse)',Erros[i].Descricao) = 0) then
                begin
                  classRetorno.Mensagem := Erros[i].Descricao;
                  classRetorno.Correcao := Erros[i].Correcao;
                  if pos(classRetorno.Mensagem,classRetorno.mensagemCompleta) = 0 then
                    classRetorno.mensagemCompleta := classRetorno.mensagemCompleta +
                                                      ' Erro: '+ Erros[i].Descricao+#13+
                                                      ' Correção :'+Erros[i].Correcao+#13;
                end;
              end;
            end;

            if Alertas.Count > 0 then
            begin
              for I := 0 to Alertas.Count - 1 do
              begin
                if (pos('(ListaNfse)',Erros[i].Descricao) = 0) then
                begin
                  classRetorno.Mensagem := Alertas[i].Descricao;
                  classRetorno.Correcao := Alertas[i].Correcao;
                  if pos(classRetorno.Mensagem,classRetorno.mensagemCompleta) = 0 then
                    classRetorno.mensagemCompleta := classRetorno.mensagemCompleta +
                                                      ' Erro: '+ Alertas[i].Descricao+#13+
                                                      ' Correção :'+Alertas[i].Correcao+#13;
                end;
              end;
            end;
          end;
        end;

      tmConsultarNFSe,
      tmConsultarNFSePorFaixa,
      tmConsultarNFSeServicoPrestado,
      tmConsultarNFSeServicoTomado:
        begin
          with ConsultaNFSe do
          begin
            if Sucesso = true then
              classRetorno.Situacao        := 4
            else
              classRetorno.Situacao        := 3;

            if Erros.Count > 0 then
            begin
              for I := 0 to Erros.Count - 1 do
              begin
                classRetorno.Mensagem := Erros[i].Descricao;
                classRetorno.Correcao := Erros[i].Correcao;
                if pos(classRetorno.Mensagem,classRetorno.mensagemCompleta) = 0 then
                  classRetorno.mensagemCompleta := classRetorno.mensagemCompleta +
                                                    ' Erro: '+ Erros[i].Descricao+#13+
                                                    ' Correção :'+Erros[i].Correcao+#13;
              end;
            end;

            if Alertas.Count > 0 then
            begin
              for I := 0 to Alertas.Count - 1 do
              begin
                classRetorno.Mensagem := Alertas[i].Descricao;
                classRetorno.Correcao := Alertas[i].Correcao;
                if pos(classRetorno.Mensagem,classRetorno.mensagemCompleta) = 0 then
                  classRetorno.mensagemCompleta := classRetorno.mensagemCompleta +
                                                    ' Erro: '+ Alertas[i].Descricao+#13+
                                                    ' Correção :'+Alertas[i].Correcao+#13;
              end;
            end;
          end;
        end;

      tmCancelarNFSe:
        begin
          cancelamento := true;
          with CancelaNFSe do
          begin
            classRetorno.Url             := RetCancelamento.Link;
            classRetorno.Situacao        := StrToIntDef(RetCancelamento.Situacao,0);
            classRetorno.Data            := RetCancelamento.DataHora;
            classRetorno.Mensagem        := RetCancelamento.MsgCanc;
            classRetorno.Sucesso         := StrToBoolDef(RetCancelamento.Sucesso, false);
            statusTemp                   := Situacao;
            if Sucesso then
            begin
              classRetorno.Situacao        := 4;
              classRetorno.Mensagem        := 'NFS-e Cancelada';
              classRetorno.Cancelada       := True;
            end;
            if Erros.Count > 0 then
            begin
              for I := 0 to Erros.Count - 1 do
              begin
                classRetorno.Mensagem := Erros[i].Descricao;
                classRetorno.Correcao := Erros[i].Correcao;
                if pos(classRetorno.Mensagem,classRetorno.mensagemCompleta) = 0 then
                  classRetorno.mensagemCompleta := classRetorno.mensagemCompleta +
                                                    ' Erro: '+ Erros[i].Descricao+#13+
                                                    ' Correção :'+Erros[i].Correcao+#13;
              end;
            end;

            if Alertas.Count > 0 then
            begin
              for I := 0 to Alertas.Count - 1 do
              begin
                classRetorno.Mensagem := Alertas[i].Descricao;
                classRetorno.Correcao := Alertas[i].Correcao;
                if pos(classRetorno.Mensagem,classRetorno.mensagemCompleta) = 0 then
                  classRetorno.mensagemCompleta := classRetorno.mensagemCompleta +
                                                    ' Erro: '+ Alertas[i].Descricao+#13+
                                                    ' Correção :'+Alertas[i].Correcao+#13;
              end;
            end;
          end;

          if AcbrNFSe.Configuracoes.Geral.ConsultaAposCancelar and
             AcbrNFSe.Provider.ConfigGeral.ConsultaNFSe then
          begin
            with ConsultaNFSe do
            begin
              if Sucesso = true then
                classRetorno.Situacao        := 4
              else
                classRetorno.Situacao        := 3;

              if Erros.Count > 0 then
              begin
                 for I := 0 to Erros.Count - 1 do
                begin
                  classRetorno.Mensagem := Erros[i].Descricao;
                  classRetorno.Correcao := Erros[i].Correcao;
                  if pos(classRetorno.Mensagem,classRetorno.mensagemCompleta) = 0 then
                    classRetorno.mensagemCompleta := classRetorno.mensagemCompleta +
                                                      ' Erro: '+ Erros[i].Descricao+#13+
                                                      ' Correção :'+Erros[i].Correcao+#13;
                end;
              end;

              if Alertas.Count > 0 then
              begin
                for I := 0 to Alertas.Count - 1 do
                begin
                  classRetorno.Mensagem := Alertas[i].Descricao;
                  classRetorno.Correcao := Alertas[i].Correcao;
                  if pos(classRetorno.Mensagem,classRetorno.mensagemCompleta) = 0 then
                    classRetorno.mensagemCompleta := classRetorno.mensagemCompleta +
                                                      ' Erro: '+ Alertas[i].Descricao+#13+
                                                      ' Correção :'+Alertas[i].Correcao+#13;
                end;
              end;
            end;
          end;
        end;

      tmSubstituirNFSe:
        begin
          with SubstituiNFSe do
          begin
            classRetorno.Url             := RetCancelamento.Link;
            classRetorno.Situacao        := StrToIntDef(RetCancelamento.Situacao,0);
            classRetorno.Mensagem        := DescSituacao;
            statusTemp                   := Situacao;


            if Erros.Count > 0 then
            begin
              for I := 0 to Erros.Count - 1 do
              begin
                classRetorno.Mensagem := Erros[i].Descricao;
                classRetorno.Correcao := Erros[i].Correcao;
                if pos(classRetorno.Mensagem,classRetorno.mensagemCompleta) = 0 then
                  classRetorno.mensagemCompleta := classRetorno.mensagemCompleta +
                                                    ' Erro: '+ Erros[i].Descricao+#13+
                                                    ' Correção :'+Erros[i].Correcao+#13;
              end;
            end;

            if Alertas.Count > 0 then
            begin
              for I := 0 to Alertas.Count - 1 do
              begin
                classRetorno.Mensagem := Alertas[i].Descricao;
                classRetorno.Correcao := Alertas[i].Correcao;
                if pos(classRetorno.Mensagem,classRetorno.mensagemCompleta) = 0 then
                  classRetorno.mensagemCompleta := classRetorno.mensagemCompleta +
                                                    ' Erro: '+ Alertas[i].Descricao+#13+
                                                    ' Correção :'+Alertas[i].Correcao+#13;
              end;
            end;
          end;
        end;

      tmAbrirSessao:
        begin
        end;

      tmFecharSessao:
        begin
        end;
      tmEnviarEvento:
      begin
        with EnviarEvento do
        begin
          if Sucesso then
          begin
            classRetorno.Situacao  := 4;
            classRetorno.Cancelada := True;
            classRetorno.Mensagem  := 'Nota cancelada com sucesso.';
          end;
          if Erros.Count > 0 then
          begin
            for i := 0 to Erros.Count -1 do
            begin
              classRetorno.Mensagem := Erros[i].Descricao;
              classRetorno.Correcao := Erros[i].Correcao;
              statusTemp := classRetorno.Mensagem;
              if pos('já existe um documento fiscal eletrônico identificado com este id',LowerCase(classRetorno.Mensagem)) > 0 then
              begin
                classRetorno.Situacao  := 4;
                classRetorno.Cancelada := True;
              end;
            end;
          end;

          if Alertas.Count > 0 then
          begin
            for i := 0 to Alertas.Count -1 do
            begin
              classRetorno.Mensagem := Alertas[i].Descricao;
              classRetorno.Correcao := Alertas[i].Correcao;
            end;
          end;
        end;
      end;

    tmConsultarEvento:
      begin
        with ConsultarEvento do
        begin
          if Sucesso then
             classRetorno.Situacao       := 4;
          classRetorno.Data              := Data;

          if Erros.Count > 0 then
          begin
            for i := 0 to Erros.Count -1 do
            begin
              classRetorno.Mensagem := Erros[i].Descricao;
              classRetorno.Correcao := Erros[i].Correcao;
            end;
          end;

          if Alertas.Count > 0 then
          begin
            for i := 0 to Alertas.Count -1 do
            begin
              classRetorno.Mensagem := Alertas[i].Descricao;
              classRetorno.Correcao := Alertas[i].Correcao;
            end;
          end;
        end;
      end;
    end;

  end;
  try
    if aMetodo in [tmRecepcionar, tmGerar, tmGerarLote, tmRecepcionarSincrono ] then
    begin
      statusTemp := AcbrNFSe.NotasFiscais.Items[0].NFSe.Numero + 'Protocolo: ' +AcbrNFSe.WebService.Emite.Protocolo+
                    'Situacao: '+IntToStr(classRetorno.Situacao) + AcbrNFSe.NotasFiscais.Items[0].NFSe.CodigoVerificacao +
                    AcbrNFSe.NotasFiscais.Items[0].NFSe.Numero;

      if ((AcbrNFSe.NotasFiscais.Items[0].NFSe.Numero <> '') and
         (AcbrNFSe.WebService.Emite.Protocolo <> '') and
         (classRetorno.Situacao = 4)) or
         ((AcbrNFSe.NotasFiscais.Items[0].NFSe.CodigoVerificacao <> '') and
         (AcbrNFSe.NotasFiscais.Items[0].NFSe.Numero <> '') and
         (AcbrNFSe.Configuracoes.Geral.Provedor in ([proISSGoiania,proISSNet]))) then
      begin
        classRetorno.Protocolo       := AcbrNFSe.WebService.Emite.Protocolo;
        classRetorno.Numero          := getNumeroNfse;
        classRetorno.Data            := AcbrNFSe.NotasFiscais.Items[0].NFSe.DataEmissao;
        classRetorno.Url             := AcbrNFSe.NotasFiscais.Items[0].NFSe.Link;
        classRetorno.CodigoVerificacao  := AcbrNFSe.NotasFiscais.Items[0].NFSe.CodigoVerificacao;
        classRetorno.Situacao        := 4;
        classRetorno.Mensagem        := 'Processado com sucesso';

        if AcbrNFSe.NotasFiscais.Items[0].XmlNfse = '' then
        begin
          AcbrNFSe.NotasFiscais.Items[0].GravarXML(classRetorno.Numero+'-nfse.xml',
                                                    AcbrNFSe.Configuracoes.Arquivos.PathNFSe+'\Notas',
                                                    txmlRPS);
        end;
      end;
    end;
  Except

  end;

  if (AcbrNFSe.Configuracoes.Geral.Provedor = proIPM) and
     (classRetorno.mensagemCompleta = '') and
     (classRetorno.Situacao = 1) then
    classRetorno.Situacao := 4;

  (*Para provedor Pronim foi colocado esse tratamento para considerar como nfse autorizada - 2024-04-02 - Renan*)
  if (AcbrNFSe.Configuracoes.Geral.Provedor = proPronim) and
     (classRetorno.mensagemCompleta = '') and
     (AcbrNFSe.NotasFiscais.Items[0].NFSe.Numero <> '') then
    classRetorno.Situacao := 4;

  if (aMetodo in [tmRecepcionar, tmGerar, tmGerarLote, tmRecepcionarSincrono ]) and
     (classRetorno.situacao = 4) and ((classRetorno.Numero = '') or (classRetorno.Numero = '0') and (cancelamento = false)) then
  begin
    try
      if ((AcbrNFSe.Configuracoes.Geral.Provedor = proISSJoinville) or
          (AcbrNFSe.Configuracoes.Geral.Provedor = proABase) or
          (AcbrNFSe.Configuracoes.Geral.Provedor = proSigep)) and (aMetodo = tmRecepcionar) then
      begin
        Exit();
      end;

      classRetorno.Numero := AcbrNFSe.NotasFiscais.Items[0].NFSe.Numero;
    Except

    end;
  end;

  if ((AcbrNFSe.Configuracoes.Geral.Provedor = proISSJoinville) or
      (AcbrNFSe.Configuracoes.Geral.Provedor = proABase) or
      (AcbrNFSe.Configuracoes.Geral.Provedor = proSigep)) and
     (aMetodo = tmConsultarNFSePorRps) and
     (classRetorno.Protocolo = '') then
  begin
//    classRetorno.Protocolo := classRetorno.Protocolo_Origem;
//    classRetorno.Protocolo_Origem := '';
  end;

end;

end.
