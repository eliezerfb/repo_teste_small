inherited framePesquisaProduto: TframePesquisaProduto
  inherited pnlPrincipal: TPanel
    inherited dbgItensPesq: TDBGrid
      OnKeyDown = dbgItensPesqKeyDown
      Columns = <
        item
          Expanded = False
          FieldName = 'DESCRICAO'
          Visible = True
        end>
    end
  end
end
