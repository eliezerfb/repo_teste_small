unit uDrawCellGridModulos;

interface

uses
  Winapi.Windows, Vcl.DBGrids, Vcl.Grids, System.SysUtils, Vcl.Graphics;

  procedure DrawCell_Receber(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
  procedure DrawCell_Pagar(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
  procedure DrawCell_Estoque(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
  procedure DrawCell_Vendas(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
  procedure DrawCell_NaturezaOP(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
  procedure DrawCell_Clientes(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
  procedure DrawCell_Compras(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
  procedure DrawCell_Caixa(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
  procedure DrawCell_Bancos(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);

implementation

uses unit7, smallfunc_xe, uSmallConsts;

procedure DrawCell_Receber(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  //Mauricio Parizotto 2024-01-03
  if Form7.sModulo = 'RECEBER' then
  begin
    if Column.Field.Name = 'ibDataSet7ATIVO' then
    begin
      if (Form7.ibDataSet7VALOR_RECE.Asfloat = 0) or (FORM7.ibDataSet7ATIVO.AsFloat >= 5) then
      begin
        if Form7.ibDataSet7ATIVO.AsFloat >= 5 then
          Form7.dbGrid1.Canvas.Draw(Rect.Left +1,Rect.Top + 1,Form7.imgChk.Picture.Graphic)
        else
          Form7.dbGrid1.Canvas.Draw(Rect.Left +1,Rect.Top + 1,Form7.imgUnChk.Picture.Graphic);
      end else
      begin
        Form7.dbGrid1.Canvas.Draw(Rect.Left +1,Rect.Top + 1,Form7.Image18.Picture.Graphic);
      end;
    end;
  end;

  if Column.Field.Name = 'ibDataSet7VENCIMENTO' then
  begin
    if (DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 1) or (DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 7) then
      Form7.DBGrid1.Canvas.Font.Color   := clRed
    else
      Form7.DBGrid1.Canvas.Font.Color   := clBlack;
    Form7.dbGrid1.Canvas.TextOut(Rect.Left+Form7.dbGrid1.Canvas.TextWidth('99/99/9999_'),Rect.Top+2,Copy(DiaDaSemana(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,3) );
  end;

  if Column.Field.Name = 'ibDataSet7MOVIMENTO' then
  begin
    if Form7.ibDataSet7MOVIMENTO.AsString <> '' then
    begin
      if (DayOfWeek(Form7.ibDataSet7MOVIMENTO.AsDateTime) = 1) or (DayOfWeek(Form7.ibDataSet7MOVIMENTO.AsDateTime) = 7) then
        Form7.DBGrid1.Canvas.Font.Color   := clRed
      else
        Form7.DBGrid1.Canvas.Font.Color   := clBlack;
      Form7.dbGrid1.Canvas.TextOut(Rect.Left + Form7.dbGrid1.Canvas.TextWidth('99/99/9999_'), Rect.Top + 2, Copy(DiaDaSemana(Form7.ibDataSet7MOVIMENTO.AsDateTime), 1, 3) );
    end;
  end;
end;

procedure DrawCell_Pagar(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if Form7.sModulo = 'PAGAR' then
  begin
    if Column.Field.Name = 'ibDataSet8ATIVO' then
    begin
      if (Form7.ibDataSet8VALOR_PAGO.Asfloat = 0) or (Form7.ibDataSet8ATIVO.AsFloat >= 5) then
      begin
        if Form7.ibDataSet8ATIVO.AsFloat >= 5 then
          Form7.dbGrid1.Canvas.Draw(Rect.Left +1,Rect.Top + 1,Form7.imgChk.Picture.Graphic)
        else
          Form7.dbGrid1.Canvas.Draw(Rect.Left +1,Rect.Top + 1,Form7.imgUnChk.Picture.Graphic);
      end else
      begin
        Form7.dbGrid1.Canvas.Draw(Rect.Left +1,Rect.Top + 1,Form7.Image18.Picture.Graphic);
      end;
    end;
  end;
end;

procedure DrawCell_Estoque(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if Form7.sModulo = 'ESTOQUE' then
  begin
    if Column.Field.Name = 'ibDataSet4MARKETPLACE' then
    begin
      if (Form7.ibDataSet4MARKETPLACE.AsString = '1') then
      begin
        Form7.dbGrid1.Canvas.Draw(Rect.Left +1,Rect.Top + 1,Form7.imgChk.Picture.Graphic);
      end else
      begin
        Form7.dbGrid1.Canvas.Draw(Rect.Left +1,Rect.Top + 1,Form7.imgUnChk.Picture.Graphic);
      end;
    end;
  end;
end;

procedure DrawCell_Vendas(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  yRect : tREct;
begin
  if Column.Field.Name = 'ibDataSet15STATUS' then
  begin
    yRect := Rect;
    YRect.Left       := Rect.Right - 20;
    YRect.Bottom     := Rect.Top + 40;

    if Form7.sRPS = 'S' then
    begin
      if Pos('ChaveDeCancelamento',Form7.ibDataSet15RECIBOXML.AsString) <> 0 then
      begin
        Form7.dbGrid1.Canvas.Draw(yRect.Left,yRect.Top,Form7.Image9.Picture.Graphic);
      end else
      begin
        Form7.dbGrid1.Canvas.Draw(yRect.Left,yRect.Top,Form7.image8.Picture.Graphic);
      end
    end else
    begin
      if Form7.ibDataSet15EMITIDA.AsString = 'X' then
      begin
        Form7.dbGrid1.Canvas.Draw(yRect.Left,yRect.Top,Form7.Image1.Picture.Graphic)
      end else
      begin
        if Pos('<nfeProc',Form7.ibDataSet15NFEXML.AsString) = 0 then
        begin
          Form7.dbGrid1.Canvas.Draw(yRect.Left,yRect.Top,Form7.image8.Picture.Graphic);
        end else
        begin
          Form7.dbGrid1.Canvas.Draw(yRect.Left,yRect.Top,Form7.Image9.Picture.Graphic);
        end;
      end;
    end;
  end;

  if Column.Field.Name = 'ibDataSet15EMISSAO' then
  begin
    if (DayOfWeek(Form7.ibDataSet15EMISSAO.AsDateTime) = 1) or (DayOfWeek(Form7.ibDataSet15EMISSAO.AsDateTime) = 7) then
      Form7.DBGrid1.Canvas.Font.Color   := clRed
    else
      Form7.DBGrid1.Canvas.Font.Color   := clBlack;
    Form7.DBGrid1.Canvas.TextOut(Rect.Left + Form7.dbGrid1.Canvas.TextWidth('99/99/9999_'), Rect.Top + 2, Copy(DiaDaSemana(Form7.ibDataSet15EMISSAO.AsDateTime), 1, 3) );
  end;
end;

procedure DrawCell_NaturezaOP(Sender: TObject; const Rect: TRect;
    DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if (Column.Field.Name = 'ibDataSet14SOBREIPI') or
     (Column.Field.Name = 'ibDataSet14SOBREFRETE') or
     (Column.Field.Name = 'ibDataSet14SOBRESEGURO') or
     (Column.Field.Name = 'ibDataSet14SOBREOUTRAS') or
     (Column.Field.Name = 'ibDataSet14IPISOBREOUTRA') or //Mauricio Parizotto 2024-04-22
     (Column.Field.Name = 'ibDataSet11PIXESTATICO') or //Mauricio Parizotto 2024-05-27
     (Column.Field.Name = 'ibDataSet14FRETESOBREIPI')  then
  begin
    Form7.dbGrid1.Canvas.FillRect(Rect);
    Form7.dbGrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,'          ');

    if (Copy(Form7.ibDataSet14CFOP.AsString,1,1) = '5') or (Copy(Form7.ibDataSet14CFOP.AsString,1,1) = '6') then
    begin
      if Column.Field.Name = 'ibDataSet14SOBREIPI' then
      begin
        if (Alltrim(Form7.ibDataSet14SOBREIPI.AsString) = 'S') then
          Form7.dbGrid1.Canvas.StretchDraw(Rect,Form7.imgCheck.Picture.Graphic)
        else
          Form7.dbGrid1.Canvas.StretchDraw(Rect,Form7.Image11.Picture.Graphic);
      end;

      if Column.Field.Name = 'ibDataSet14SOBREFRETE' then
      begin
        if (Alltrim(Form7.ibDataSet14SOBREFRETE.AsString) = 'S') then
          Form7.dbGrid1.Canvas.StretchDraw(Rect,Form7.imgCheck.Picture.Graphic)
        else
          Form7.dbGrid1.Canvas.StretchDraw(Rect,Form7.Image11.Picture.Graphic);
      end;

      if Column.Field.Name = 'ibDataSet14SOBRESEGURO' then
      begin
        if (Alltrim(Form7.ibDataSet14SOBRESEGURO.AsString) = 'S') then
          Form7.dbGrid1.Canvas.StretchDraw(Rect,Form7.imgCheck.Picture.Graphic)
        else
          Form7.dbGrid1.Canvas.StretchDraw(Rect,Form7.Image11.Picture.Graphic);
      end;

      if Column.Field.Name = 'ibDataSet14SOBREOUTRAS' then
      begin
        if (Alltrim(Form7.ibDataSet14SOBREOUTRAS.AsString) = 'S') then
          Form7.dbGrid1.Canvas.StretchDraw(Rect,Form7.imgCheck.Picture.Graphic)
        else
          Form7.dbGrid1.Canvas.StretchDraw(Rect,Form7.Image11.Picture.Graphic);
      end;


      if Column.Field.Name = 'ibDataSet14FRETESOBREIPI' then
      begin
        if (Alltrim(Form7.ibDataSet14FRETESOBREIPI.AsString) = 'S') then
          Form7.dbGrid1.Canvas.StretchDraw(Rect,Form7.imgCheck.Picture.Graphic)
        else
          Form7.dbGrid1.Canvas.StretchDraw(Rect,Form7.Image11.Picture.Graphic);
      end;

      //Mauricio Parizotto 2024-04-22
      if Column.Field.Name = 'ibDataSet14IPISOBREOUTRA' then
      begin
        if (Alltrim(Form7.ibDataSet14IPISOBREOUTRA.AsString) = 'S') then
          Form7.dbGrid1.Canvas.StretchDraw(Rect,Form7.imgCheck.Picture.Graphic)
        else
          Form7.dbGrid1.Canvas.StretchDraw(Rect,Form7.Image11.Picture.Graphic);
      end;
    end;

    //Mauricio Parizotto 2024-05-27
    if Column.Field.Name = 'ibDataSet11PIXESTATICO' then
    begin
      with (Sender as TDBGrid).Canvas do
      begin
        if (gdSelected in State) then
        begin
          Brush.Color := clWhite;
          FillRect(Rect);
          (Sender as TDBGrid).DefaultDrawColumnCell(Rect, DataCol, Column, State);
        end;
      end;

      if (Alltrim(Form7.ibDataSet11PIXESTATICO.AsString) = 'S') then
      begin
        Form7.dbGrid1.Canvas.Draw(Rect.Left +20,Rect.Top + 1,Form7.imgChk.Picture.Graphic);
      end else
      begin
        Form7.dbGrid1.Canvas.Draw(Rect.Left +20,Rect.Top + 1,Form7.imgUnChk.Picture.Graphic);
      end;
    end;
  end;

  if (Column.Field.Name = 'ibDataSet14'+UpperCase(Form7.ibDataSet13ESTADO.AsString)) or
    (Column.Field.Name = 'ibDataSet14'+UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_') then
  begin
    Form7.dbGrid1.Canvas.Font.Color   := clRed;
    Form7.dbGrid1.Canvas.FillRect(Rect);
    Form7.dbGrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.AsString);
  end;

end;

procedure DrawCell_Clientes(Sender: TObject; const Rect: TRect;
    DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  yRect : tREct;
begin
  if Pos('WHATSAPP',UpperCase(Column.Field.DisplayLabel)) <> 0 then
  begin
    yRect := Rect;
    YRect.Left   := Rect.Right - 40;
    YREct.Bottom := Rect.Top   + 40;

    if LimpaNumero(Column.Field.AsString) <> '' then
      Form7.dbGrid1.Canvas.Draw(yRect.Left,yRect.Top,Form7.ImageWhatsApp.Picture.Graphic);
  end;
end;

procedure DrawCell_Compras(Sender: TObject; const Rect: TRect;
    DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  yRect : tREct;
begin
  if Column.Field.Name = 'ibDataSet24MDESTINXML' then
  begin
    yRect := Rect;
    YRect.Left   := Rect.Right - 20;
    YREct.Bottom := Rect.Top   + 40;

    Form7.dbGrid1.Canvas.FillRect(Rect);

    if Pos('<tpEvento>210200',Form7.ibDataSet24MDESTINXML.AsString)<>0 then
    begin
      Form7.DBGrid1.Canvas.Font.Color   := _COR_AZUL;//$00EAB231;
      Form7.dbGrid1.Canvas.StretchDraw(yRect,Form7.Positivo.Picture.Graphic);  // Positivo
      Form7.dbGrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,'Operação confirmada');
    end else
    begin
      if (Pos('<tpEvento>210210',Form7.ibDataSet24MDESTINXML.AsString)<>0)  then
      begin
        if (Length(LimpaNumero(Form7.ibDataSet24NFEID.AsString)) = 44) and (Pos('<nfeProc',Form7.ibDataSet24NFEXML.AsString)=0) and (Form7.ibDataSet24MERCADORIA.Asfloat = 0) then
        begin
          // Ciência da operação
          Form7.DBGrid1.Canvas.Font.Color   := clMaroon;
          Form7.dbGrid1.Canvas.StretchDraw(yRect,Form7.PositivoDownloadXML.Picture.Graphic);
          Form7.dbGrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,'Ciencia da Operacao - Importe o XML');
        end else
        begin
          // 210210 – Ciência da Operação
          Form7.DBGrid1.Canvas.Font.Color   := clGreen;
          Form7.dbGrid1.Canvas.StretchDraw(yRect,Form7.PositivoVerde.Picture.Graphic);  // Positivo
          Form7.dbGrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,'Ciente da Operação');
        end;
      end else
      begin
        if (Pos('<tpEvento>21020',Form7.ibDataSet24MDESTINXML.AsString)<>0) then
        begin
          // 210220 – Desconhecimento da Operação
          Form7.DBGrid1.Canvas.Font.Color := clSilver;
          Form7.dbGrid1.Canvas.StretchDraw(yRect,Form7.PositivoDownloadXML.Picture.Graphic);  // Positivo
          Form7.dbGrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,'Desconhecimento da Operação');
        end else
        begin
          if (Pos('<tpEvento>210240',Form7.ibDataSet24MDESTINXML.AsString)<>0) then
          begin
            // 210240 – Operação não Realizada
            Form7.DBGrid1.Canvas.Font.Color := clSilver;
            Form7.dbGrid1.Canvas.StretchDraw(yRect,Form7.PositivoDownloadXML.Picture.Graphic);  // Positivo
            Form7.dbGrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,'Operação não Realizada');
          end else
          begin
            // Manifestar ciencia
            if (Length(LimpaNumero(Form7.ibDataSet24NFEID.AsString)) = 44) then
            begin
              Form7.DBGrid1.Canvas.Font.Color   := clRed;
              Form7.dbGrid1.Canvas.StretchDraw(yRect,Form7.PositivoVermelho.Picture.Graphic);  // Positivo
              Form7.dbGrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,'Manifeste Ciência');
            end else
            begin
              Form7.DBGrid1.Canvas.Font.Color   := clBlack;
              Form7.dbGrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,'NF Manual (Guarde o Doc)');
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure DrawCell_Caixa(Sender: TObject; const Rect: TRect;
    DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if Column.Field.Name = 'ibDataSet1NOME' then
    begin
      if Form7.ibDataSet1NOME.AsString = '' then
      begin
        Form7.dbGrid1.Canvas.FillRect(Rect);
        Form7.DBGrid1.Canvas.Font.Color   := clRed;
        Form7.dbGrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,'<Plano de Contas>');
      end;
    end;

  if Column.Field.Name = 'ibDataSet1DATA' then
  begin
    if (DayOfWeek(Form7.ibDataSet1DATA.AsDateTime) = 1) or (DayOfWeek(Form7.ibDataSet1DATA.AsDateTime) = 7) then
      Form7.DBGrid1.Canvas.Font.Color   := clRed
    else
      Form7.DBGrid1.Canvas.Font.Color   := clBlack;
    Form7.DBGrid1.Canvas.TextOut(Rect.Left+Form7.dbGrid1.Canvas.TextWidth('99/99/9999_'),Rect.Top+2,Copy(DiaDaSemana(Form7.ibDataSet1DATA.AsDateTime),1,3) );
  end;
end;

procedure DrawCell_Bancos(Sender: TObject; const Rect: TRect;
    DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if Column.Field.Name = 'ibDataSet5COMPENS' then
  begin
    if Form7.ibDataSet5COMPENS.AsString = '' then
    begin
      Form7.dbGrid1.Canvas.FillRect(Rect);
      Form7.DBGrid1.Canvas.Font.Color   := clRed;
      Form7.dbGrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,'<Clique Duplo>');
    end;
  end;
end;

end.








