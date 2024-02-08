unit uDesenhaBoleto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mask, DBCtrls, SMALL_DBEdit, smallfunc_xe, IniFiles, Printers, ShellApi, jpeg, TnPdf;

  procedure DesenhaBoletoLayoutPadrao(Impressao: TCanvas; CodBanco, sAgencia, sCodCedente, sConvenio, sCarteira, sNossoNumero, sMascara : string);
  procedure DesenhaBoletoLayoutCarne(Impressao: TCanvas; CodBanco, sAgencia, sCodCedente, sConvenio, sCarteira, sNossoNumero, sMascara : string; Posicao:integer);

implementation

uses Unit25, unit7;

function Largura(MM : Double) : Longint;
var
  mmPointX : Real;
  PageSize, OffSetUL : TPoint;
begin
  if Form25.Tag = 0 then
  begin
    MM := MM + 5;
    mmPointX := Printer.PageWidth / GetDeviceCaps(Printer.Handle,HORZSIZE);
    Escape (Printer.Handle,GETPRINTINGOFFSET,0,nil,@OffSetUL);
    Escape (Printer.Handle,GETPHYSPAGESIZE,0,nil,@PageSize);
    if MM > 0 then Result := round ((MM * mmPointX) - OffSetUL.X) else Result := round (MM * mmPointX);
    Result := round(Result * 1.1);
  end else
  begin
    // Em PDF
    Result := Round(MM * 3.8);
  end;
end;


function Altura(MM : Double) : Longint;
var
  mmPointY : Real;
  PageSize, OffSetUL : TPoint;
begin
  if Form25.Tag = 0 then  // Impressão na impressora
  begin
    mmPointY := Printer.PageHeight / GetDeviceCaps(Printer.Handle,VERTSIZE);
    Escape(Printer.Handle,GETPRINTINGOFFSET,0,nil,@OffSetUL);
    Escape(Printer.Handle,GETPHYSPAGESIZE,0,nil,@PageSize);
    if MM > 0 then Result := round((MM * mmPointY) - OffSetUL.Y) else Result := round(MM * mmPointY);
    Result := round(Result * 1.45);
  end else
  begin
    // Em PDF
    Result := Round(MM  * 5);
  end;
end;

procedure DesenhaBoletoLayoutPadrao(Impressao: TCanvas; CodBanco, sAgencia, sCodCedente, sConvenio, sCarteira, sNossoNumero, sMascara : string);
var
  rRect : Trect;
  ivia, I, J : Integer;
  sBanco : String;
  NumBancoBoleto : string;
begin
  Impressao.Pen.Color   := clBlack;
  Impressao.Pen.Width   := 1;                 // Largura da Linha + (J * 40 * Tamanho)

  for J := 1 to 2 do
  begin
    Impressao.Font.Name   := 'Times New Roman';      // Fonte
    Impressao.Font.sTyle  := [fsBold];             // Estilo da fonte

    if Form25.Tag = 0 then  // Impressão na impressora
    begin
      if J = 1 then
        iVia := 6
      else
        ivia := 105 + 4;
      Impressao.Font.Size   := 13;             // Tamanho da Fonte
    end else
    begin
      if J = 1 then
        iVia := 0
      else
        ivia := 105;
      Impressao.Font.Size   := 12;             // Tamanho da Fonte
    end;

    Impressao.TextOut(largura(63),altura(6+iVia),Form25.FormataCodBarra(Form25.GeraCodBarra(CodBanco)));

    Impressao.Font.Name   := 'Times New Roman';      // Fonte
    Impressao.Font.Size   := 12;          // Tamanho da Fonte
    Impressao.Font.sTyle  := [fsBold];    // Estilo da fonte

    sBanco := 'banco'+CodBanco+'.bmp'; // banco001.bmp = Banco do Brasil; banco237.bmp = Bradesco

    if FileExists(sBanco) then
    begin
      Form25.Image7.Picture.LoadFromFile(sBanco);

      if Form25.Tag = 0 then  // Impressão na impressora
      begin
        rRect.Top     := Altura(iVia+3);
        rRect.Left    := Largura(1);
        rRect.Bottom  := rRect.Top  + (40 * Round(Printer.PageWidth / GetDeviceCaps(Printer.Handle,HORZSIZE) / 4));
        rRect.Right   := rRect.Left + (168 * Round(Printer.PageWidth / GetDeviceCaps(Printer.Handle,HORZSIZE) / 4));
      end else
      begin
        rRect.Top     := Altura(iVia+2);
        rRect.Left    := Largura(0);
        rRect.Bottom  := rRect.Top  + Form25.Image7.Picture.Graphic.Height;
        rRect.Right   := rRect.Left + Form25.Image7.Picture.Graphic.Width;
      end;

      Impressao.StretchDraw(rRect,Form25.Image7.Picture.Graphic);
    end else
    begin
      Impressao.TextOut(largura(-8+8),altura(5+iVia),Copy(AllTrim(Form7.ibDataSet11NOME.AsString)+Replicate(' ',26),1,26)); // Nome do banco
    end;

    Impressao.Font.Size   := 14;          // Tamanho da Fonte

    NumBancoBoleto := CodBanco;
    if NumBancoBoleto = '136' then
      NumBancoBoleto := '136-8';

    if Length(LimpaNumero(NumBancoBoleto)) = 3 then
    begin
      Impressao.TextOut(largura(-8+58),altura(6+iVia),Copy(NumBancoBoleto,1,3));   // Código do banco mais o dígito verificador
    end else
    begin
      Impressao.TextOut(largura(-8-2+58),altura(6+iVia),NumBancoBoleto);   // Código do banco mais o dígito verificador
    end;

    Impressao.Font.Size   := 8;          // Tamanho da Fonte
    Impressao.Font.sTyle  := [];         // Estilo da fonte

    Impressao.TextOut(largura(-8+009),altura(11+iVia),'Local de pagamento');
    Impressao.TextOut(largura(-8+151-8),altura(11+iVia),'Vencimento');
    Impressao.TextOut(largura(-8+009),altura(18+iVia),'Beneficiário');
    Impressao.TextOut(largura(-8+106-8),altura(18+iVia),'CNPJ/CPF');
    Impressao.TextOut(largura(-8+151-8),altura(18+iVia),'Agência/Código Beneficiário');

    Impressao.TextOut(largura(-8+009),altura(25+iVia),'Data do documento');
    Impressao.TextOut(largura(-8+037),altura(25+iVia),'Nr. do documento');
    Impressao.TextOut(largura(-8+068),altura(25+iVia),'Espécie doc.');
    Impressao.TextOut(largura(-8+088),altura(25+iVia),'Aceite');
    Impressao.TextOut(largura(-8+098),altura(25+iVia),'Data processamento');
    Impressao.TextOut(largura(-8+151-8),altura(25+iVia),'Nosso número');

    Impressao.TextOut(largura(-8+009),altura(32+iVia),'Uso do banco');
    Impressao.TextOut(largura(-8+037),altura(32+iVia),'Carteira');
    Impressao.TextOut(largura(-8+058),altura(32+iVia),'Espécie Moeda');
    Impressao.TextOut(largura(-8+078),altura(32+iVia),'Quantidade');

    Impressao.TextOut(largura(-8+116-8),altura(32+iVia),'Valor');
    Impressao.TextOut(largura(-8+151-8),altura(32+iVia),'(=)Valor do documento');

    if (J = 1) then
    begin
      Impressao.TextOut(largura(-8+009),altura(39+iVia),'Nome do Beneficiário/CPF/CNPJ/Endereço');
    end else
    begin
      //Impressao.TextOut(largura(-8+009),altura(39+iVia),'Instruções: (Todas as informações deste bloqueto são de exclusiva responsabilidade do Beneficiário)'); // Mauricio Parizotto 2023-10-02
      Impressao.TextOut(largura(-8+009),altura(39+iVia),'Instruções: (Todas as informações deste boleto são de exclusiva responsabilidade do Beneficiário)');
    end;

    Impressao.TextOut(largura(-8+151-8),altura(39+iVia),'(-)Desconto');

    Impressao.TextOut(largura(-8+151-8),altura(45+iVia),'(-)Outras deduções/Abatimento');
    Impressao.TextOut(largura(-8+151-8),altura(51+iVia),'(+)Mora/Multa/Juros');
    Impressao.TextOut(largura(-8+151-8),altura(57+iVia),'(+)Outros acrécimos');

    Impressao.TextOut(largura(-8+009),altura(63+iVia),'Nome do Pagador/CPF/CNPJ/Endereço');
    Impressao.TextOut(largura(-8+151-8),altura(63+iVia),'(=)Valor cobrado');
    Impressao.TextOut(largura(-8+009),altura(78+iVia),'Sacador Avalista');
    Impressao.TextOut(largura(-8+151-8),altura(70+iVia),'Cod. Baixa:');

    if Form25.Tag = 0 then  // Impressão na impressora
    begin
      if J = 1 then Impressao.TextOut(largura(-8+135-10+9),altura(78+iVia),'Autenticação mecânica/RECIBO DO Pagador');
      if J = 2 then Impressao.TextOut(largura(-8+135-10),altura(78+iVia),'Autenticação mecânica/FICHA DE COMPENSAÇÃO');
    end else
    begin
      if J = 1 then Impressao.TextOut(largura(-8+135-20+10),altura(78+iVia),'Autenticação mecânica/RECIBO DO Pagador');
      if J = 2 then Impressao.TextOut(largura(-8+135-20),altura(78+iVia),'Autenticação mecânica/FICHA DE COMPENSAÇÃO');
    end;

    // Preenchimento
    Impressao.Font.Name   := 'Courier New';  // Fonte
    Impressao.Font.Size   := 11;             // Tamanho da Fonte

    Impressao.TextOut(largura(-8+009),altura(14+iVia),AllTrim(Form25.Edit1.Text));                        // Local de pagamento

    // Data atualizada com juros de mora
    if (Form25.chkDataAtualizadaJurosMora.Checked) and (Form7.ibDataSet7VENCIMENTO.AsDAteTime < Date) then // Sandro Silva 2022-12-28 if (Form25.CheckBox1.Checked) and (Form7.ibDataSet7VENCIMENTO.AsDAteTime < Date) then
    begin
      Impressao.TextOut(largura(-8+151-8),altura(14+iVia),Right(Replicate(' ',30)+DateToStr(DATE),16)); // Vencimento
    end else
    begin
      Impressao.TextOut(largura(-8+151-8),altura(14+iVia),Right(Replicate(' ',30)+Form7.ibDataSet7VENCIMENTO.AsString,16)); // Vencimento
    end;

    Impressao.TextOut(largura(-8+009),altura(21+iVia),AllTrim(Copy(Form7.ibDataSet13NOME.AsString+Replicate(' ',35),1,35))); // Beneficiário
    Impressao.TextOut(largura(-8+98),altura(21+iVia),AllTrim(Form7.ibDataSet13CGC.AsString));        // CNPJ

    // Código do Beneficiário
    Impressao.TextOut(largura(-8+151-8),altura(21+iVia),Right(Replicate(' ',30)+AllTrim(sAgencia)+'/'+AllTrim(sCodCedente),16));

    Impressao.TextOut(largura(-8+009),altura(28+iVia),Form7.ibDataSet7EMISSAO.AsString); // Data do documento
    Impressao.TextOut(largura(-8+040),altura(28+iVia),AllTrim(Form7.ibDataset7DOCUMENTO.AsString));
    Impressao.TextOut(largura(-8+073),altura(28+iVia),'DM');            // DM
    Impressao.TextOut(largura(-8+090),altura(28+iVia),'N');             // N
    Impressao.TextOut(largura(-8+105),altura(28+iVia),Form7.ibDataSet7EMISSAO.AsString); // Data do processamento

    // Nosso Número / Cód. Documento
    if (CodBanco = '033') or (CodBanco = '353') then // SANTANDER
    begin
      // Módulo 11 para cálculo de dígito verificador de agência, código de Beneficiário e nosso-número
      // do banco do brasil conforme http://www.bb.com.br/appbb/portal/emp/ep/srv/CobrancaIntegrBB.jsp#6
      Form25.sNossoNum := Copy(StrZero(StrToFloat('0'+LimpaNumero(Form7.ibDataSet7NN.AsString)),7,0),1,07)+'-'+Modulo_11(LimpaNumero(Form7.ibDataSet7NN.AsString));
      //
      Impressao.Font.Size   := 10;             // Tamanho da Fonte
      Impressao.TextOut(largura(-8+151-6),altura(28+iVia),Right(Replicate(' ',30)+Form25.sNossoNum,13+3));
      Impressao.Font.Size   := 11;             // Tamanho da Fonte
    end else
    begin
      if CodBanco = '001' then // Banco do Brasil
      begin
        // Módulo 11 para cálculo de dígito verificador de agência, código de Beneficiário e nosso-número
        // do banco do brasil conforme http://www.bb.com.br/appbb/portal/emp/ep/srv/CobrancaIntegrBB.jsp#6
        Form25.sNossoNum := Copy(Right('000000'+LimpaNumero(sConvenio),7),1,7)+Copy(StrZero(StrToFloat('0'+LimpaNumero(Form7.ibDataSet7NN.AsString)),10,0),1,010);

        Impressao.Font.Size   := 10;             // Tamanho da Fonte
        Impressao.TextOut(largura(-8+151-6),altura(28+iVia), Right(Replicate(' ',30)+Form25.sNossoNum,17));
        Impressao.Font.Size   := 11;             // Tamanho da Fonte
      end else
      begin
        if CodBanco = '341' then // Itaú ITAU
        begin
          Form25.sNossoNum := AllTrim(LimpaNumero(sCarteira)) + '/'
            + StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),8,0) +'-'+
            Modulo_10(Copy(sAgencia+'0000',1,4)+Copy(sCodCedente+'00000',1,5)+Copy(sCarteira+'000',1,3)+Right('00000000'+sNossoNumero,8));
          Impressao.TextOut(largura(-8+151-8),altura(28+iVia),Form25.sNossoNum);
        end else
        begin
          if CodBanco = '237' then // BRADESCO
          begin
            Form25.sNossoNum := AllTrim(LimpaNumero(sCarteira)) + '/' + '0'+ sNossoNumero + '-' + Modulo_11_bradesco(LimpaNumero(sCarteira)+'0'+LimpaNumero(sNossoNumero));
            Impressao.TextOut(largura(-8+151-8),altura(28+iVia),Form25.sNossoNum);
          end else
          begin
            if CodBanco = '041' then // Banrisul
            begin
              Form25.sNossoNum := (StrZero(0,3,0) + StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),5,0)) +'-'+
                Modulo_Duplo_Digito_Banrisul((StrZero(0,3,0)+StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),5,0)));

              Impressao.TextOut(largura(-8+151-8),altura(28+iVia),Right(Replicate(' ',30)+Form25.sNossoNum,16));
            end else
            begin
              if CodBanco = '104' then // CAIXA
              begin
                Form25.sNossoNum := AllTrim(LimpaNumero(sCarteira)) + '/'
                  + StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),15,0) +'-'+
                  Modulo_11((
                    StrZero(StrtoInt('0'+LimpaNumero(sCarteira)),2,0)+
                    StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),15,0)
                    ));

                Impressao.Font.Size   := 9;             // Tamanho da Fonte
                Impressao.TextOut(largura(-8+151-8)+4,altura(28+iVia), Right(Replicate(' ',30)+Form25.sNossoNum,20));
                Impressao.Font.Size   := 11;             // Tamanho da Fonte
              end else
              begin
                if CodBanco = '756' then // SICOOB
                begin
                  Form25.sNossoNum := Right(Replicate(' ',30)+
                    StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),7,0)+'-'+
                    Modulo_sicoob(
                      Copy(sAgencia,1,4)+
                      StrZero(StrtoInt('0'+LimpaNumero(sCodCedente)),10,0)+
                      StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),7,0))
                      ,16);

                  Impressao.TextOut(largura(-8+151-8),altura(28+iVia), Right(Replicate(' ',30)+Form25.sNossoNum,16));
                end else
                begin
                  if CodBanco = '748' then // SICREDI
                  begin
                    Form25.sNossoNum := Copy(IntToStr(Year(Form7.ibDataSet7EMISSAO.AsDateTime)),3,2)+'/2'+Copy(Form7.ibDataSet7NN.AsString,6,5)+'-'+Modulo_11(LimpaNumero(sAgencia)+LimpaNumero(sCodCedente)+Copy(IntToStr(Year(Form7.ibDataSet7EMISSAO.AsDateTime)),3,2)+'2'+Right(StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),15,0),5));

                    Impressao.TextOut(largura(-8+151-8),altura(28+iVia), Right(Replicate(' ',30)+Form25.sNossoNum,16));
                  end else
                  begin
                    if CodBanco = '085' then // AILOS
                    begin
                      Form25.sNossoNum := Right('00000000'+LimpaNumero(sCodCedente),8) + Right('00000000'+LimpaNumero(sNossoNumero),9);

                      Impressao.Font.Size   := 10;             // Tamanho da Fonte
                      Impressao.TextOut(largura(-8+151-6),altura(28+iVia), Right(Replicate(' ',30)+Form25.sNossoNum,17));
                      Impressao.Font.Size   := 11;             // Tamanho da Fonte
                    end else
                    begin
                      //Mauricio Parizotto 2023-12-07
                      if CodBanco = '136' then // Unicred
                      begin
                        Form25.sNossoNum := sNossoNumero;

                        Impressao.Font.Size   := 10;             // Tamanho da Fonte
                        Impressao.TextOut(largura(-8+151-6),altura(28+iVia), Right(Replicate(' ',30)+Form25.sNossoNum,17));
                        Impressao.Font.Size   := 11;             // Tamanho da Fonte
                      end else
                      begin
                        Form25.sNossoNum := (AllTrim(LimpaNumero(sCarteira)) + '/'
                        + (StrZero(StrtoInt('0'+LimpaNumero(sConvenio)),3,0)+StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),5,0)) +'-'+
                        Modulo_11((StrZero(StrtoInt('0'+LimpaNumero(sConvenio)),3,0)+StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),5,0))));

                        Impressao.TextOut(largura(-8+151-8),altura(28+iVia),Right(Replicate(' ',30)+Form25.sNossoNum,16));
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;

    if ((AllTrim(sCarteira) = '24') or (AllTrim(sCarteira) = '14'))  and (CodBanco = '104') then
    begin
      if sMascara <> 'CCCCCCC00020004NNNNNNNNND' then
      begin
        Impressao.TextOut(largura(-8+039),altura(35+iVia),'RG');
      end else
      begin
        Impressao.TextOut(largura(-8+039),altura(35+iVia),'SR');
      end;
    end else
    begin
      Impressao.TextOut(largura(-8+039),altura(35+iVia),Copy(sCarteira+'  ',1,3));
    end;

    Impressao.TextOut(largura(-8+062),altura(35+iVia),'R$');
    Impressao.TextOut(largura(-8+151-8),altura(35+iVia),Right(Replicate(' ',30)+Format('%12.2n',[Form7.ibDataSet7VALOR_DUPL.AsFloat]),16)); // Valor do documento

    // Data atualizada com juros de mora
    if (Form25.chkDataAtualizadaJurosMora.Checked) and (Form7.ibDataSet7VENCIMENTO.AsDAteTime < Date) then // Sandro Silva 2022-12-28 if (Form25.CheckBox1.Checked) and (Form7.ibDataSet7VENCIMENTO.AsDAteTime < Date) then
    begin
      if (Form7.ibDataSet7VALOR_JURO.AsFloat - Form7.ibDataSet7VALOR_DUPL.AsFloat) >= 0.01 then
      begin
        Impressao.TextOut(Largura(-8+151-8),Altura(54+iVia)-3,Right(Replicate(' ',30)+Format('%12.2n',[Form7.ibDataSet7VALOR_JURO.AsFloat-Form7.ibDataSet7VALOR_DUPL.AsFloat]),16)); // Data atualizada com juros de mora
        Impressao.TextOut(Largura(-8+151-8),Altura(66+iVia),Right(Replicate(' ',30)+Format('%12.2n',[Form7.ibDataSet7VALOR_JURO.AsFloat]),16)); // Valor cobrado
      end;
    end;

    Impressao.Font.Size   := 9;              // Tamanho da Fonte

    if (J = 1) then
    begin
      Impressao.TextOut(largura(-8+010),altura(43+iVia),AllTrim(Copy(Form7.ibDataSet13NOME.AsString+Replicate(' ',35),1,35))+' CNPJ/CPF: '+Form7.ibDataSet13CGC.AsString);
      Impressao.TextOut(largura(-8+010),altura(46+iVia),AllTrim(Form7.ibDataSet13ENDERECO.AsString) + ' - ' + AllTrim(Form7.ibDataSet13COMPLE.AsString)); // CEP e Cidade do emitente
      Impressao.TextOut(largura(-8+010),altura(49+iVia),AllTrim(Form7.ibDataSet13CEP.AsString)+' '+AllTrim(Form7.ibDataSet13MUNICIPIO.AsString)+' '+AllTrim(Form7.ibDataSet13ESTADO.AsString)); // Endereço do emitente
    end else
    begin
      Impressao.TextOut(largura(-8+010),altura(43+iVia),Form25.Edit4.Text); // Texto
      Impressao.TextOut(largura(-8+010),altura(46+iVia),Form25.Edit5.Text); // Texto
      Impressao.TextOut(largura(-8+010),altura(49+iVia),Form25.Edit6.Text); // Texto

      // RENEGOCIACAO
      if Copy(Form7.ibDataSet7HISTORICO.AsString,1,16) = 'CODIGO DO ACORDO' then
      begin
        Form25.Edit7.Visible := False;
        Impressao.TextOut(largura(-8+010),altura(52+iVia),Form7.ibDataSet7HISTORICO.AsString); // Texto
      end else
      begin
        // Data atualizada com juros de mora
        if (Form25.chkDataAtualizadaJurosMora.Checked) and (Form7.ibDataSet7VENCIMENTO.AsDAteTime < Date) then // Sandro Silva 2022-12-28 if (Form25.CheckBox1.Checked) and (Form7.ibDataSet7VENCIMENTO.AsDAteTime < Date) then
        begin
          Impressao.TextOut(largura(-8+010),altura(52+iVia),'VENCIMENTO ORIGINAL: '+Form7.ibDataSet7VENCIMENTO.AsString); // Texto
          Form25.Edit7.Visible := False;
        end else
        begin
          Impressao.TextOut(largura(-8+010),altura(52+iVia),Form25.Edit7.Text); // Texto
          Form25.Edit7.Visible := True;
        end;
      end;
    end;

    Impressao.TextOut(largura(-8+010),altura(64+3+iVia),AllTrim(Copy(Form7.ibDataSet2NOME.AsString+Replicate(' ',35),1,35))+' CNPJ/CPF: '+Form7.ibDataSet2CGC.AsString);
    Impressao.TextOut(largura(-8+010),altura(67+3+iVia),AllTrim(Form7.ibDataSet2ENDERE.AsString) + ' - ' + AllTrim(Form7.ibDataSet2COMPLE.AsString)); // CEP e Cidade do Pagador
    Impressao.TextOut(largura(-8+010),altura(70+3+iVia),AllTrim(Form7.ibDataSet2CEP.AsString)+' '+AllTrim(Form7.ibDataSet2CIDADE.AsString)+' '+AllTrim(Form7.ibDataSet2ESTADO.AsString)); // Endereço do Pagador

    if (J = 1) and (CodBanco = '104') then
    begin
      Impressao.TextOut(Largura(002),Altura(81+2+iVia),'SAC CAIXA: 0800 726 0101 (informações, reclamações, sugestões e elogios)');
      Impressao.TextOut(Largura(002),Altura(84+2+iVia),'Para pessoas com deficiência auditiva ou de fala: 0800 726 2492');
      Impressao.TextOut(Largura(002),Altura(87+2+iVia),'Ouvidoria: 0800 725 7474 www.caixa.gov.br');
    end;

    if (J = 1) and (CodBanco = '041') then
    begin
      Impressao.TextOut(Largura(002),Altura(81+2+iVia),'SAC BANRISUL - 0800 646 1515');
      Impressao.TextOut(Largura(002),Altura(84+2+iVia),'OUVIDORIA BANRISUL - 0800 644 2200');
    end;

    if J = 2 then
    begin
      Impressao.Font.Name   := 'Interleaved 2of5 Text';   // Fonte
      Impressao.Font.Size   := 19;                        // Tamanho da Fonte
      Impressao.Font.sTyle  := [];                        // Estilo da fonte

      Impressao.TextOut(largura(-8+009),altura(081+4+iVia),'('+SMALL_2of5(Form25.sNumero)+')');
      Impressao.TextOut(largura(-8+009),altura(084+4+iVia),'('+SMALL_2of5(Form25.sNumero)+')');
      Impressao.TextOut(largura(-8+009),altura(86.5+4+iVia),'('+SMALL_2of5(Form25.sNumero)+')');

      Impressao.Font.Name   := 'Microsoft Sans Serif';               // Fonte
      Impressao.Font.Size   := 6;                       // Tamanho da Fonte
      Impressao.TextOut(largura(-8+009),altura(90+4+iVia),Replicate(' ',200));
    end;

    Impressao.Pen.Width   := 2;
    Impressao.MoveTo(largura(-8+055),altura(06+iVia)); // Linha mais larga ao lado do código do banco
    Impressao.Lineto(largura(-8+055),altura(11+iVia)); //
    Impressao.MoveTo(largura(-8+069),altura(06+iVia)); //
    Impressao.Lineto(largura(-8+069),altura(11+iVia)); //
    Impressao.Pen.Width   := 1;                     // Largura da Linha

    // Traço inferior da 1 linha //
    Impressao.MoveTo(largura(-8+008),altura(18+iVia));        //
    Impressao.Lineto(largura(-8+200-18),altura(18+iVia));        //

    // Traço inferior da 2 linha //
    Impressao.MoveTo(largura(-8+008),altura(25+iVia));        //
    Impressao.Lineto(largura(-8+200-18),altura(25+iVia));        //

    // Traço inferior da 3 linha //
    Impressao.MoveTo(largura(-8+008),altura(32+iVia));        //
    Impressao.Lineto(largura(-8+200-18),altura(32+iVia));        //

    // Traço inferior da 4 linha //
    Impressao.MoveTo(largura(-8+008),altura(39+iVia));        //
    Impressao.Lineto(largura(-8+200-18),altura(39+iVia));        //

    // Traço inferior do texto livre //
    Impressao.MoveTo(largura(-8+008),altura(63+iVia));        //
    Impressao.Lineto(largura(-8+200-18),altura(63+iVia));        //

    // Traço inferior da 4 linha //
    Impressao.MoveTo(largura(-8+150-8),altura(45+iVia));        //
    Impressao.Lineto(largura(-8+200-18),altura(45+iVia));        //

    // Traço inferior da 4 linha //
    Impressao.MoveTo(largura(-8+150-8),altura(51+iVia));        //
    Impressao.Lineto(largura(-8+200-18),altura(51+iVia));        //

    // Traço inferior da 4 linha //
    Impressao.MoveTo(largura(-8+150-8),altura(57+iVia));        //
    Impressao.Lineto(largura(-8+200-18),altura(57+iVia));        //

    // Traço que corta em frete ao Nr. do documento e carteira  //
    Impressao.MoveTo(largura(-8+36),altura(25+iVia));         //
    Impressao.Lineto(largura(-8+36),altura(39+iVia));         //

    // Traço que corta em frente ao Espécie doc.                //
    Impressao.MoveTo(largura(-8+67),altura(25+iVia));         //
    Impressao.Lineto(largura(-8+67),altura(32+iVia));         //

    // Traço que corta em frente ao Aceite                      //
    Impressao.MoveTo(largura(-8+87),altura(25+iVia));         //
    Impressao.Lineto(largura(-8+87),altura(32+iVia));         //

    // Traço que corta em frente a data processamento           //
    Impressao.MoveTo(largura(-8+97),altura(25+iVia));         //
    Impressao.Lineto(largura(-8+97),altura(32+iVia));         //

    // Traço que corta em frente a Espécie                      //
    Impressao.MoveTo(largura(-8+57),altura(32+iVia));         //
    Impressao.Lineto(largura(-8+57),altura(39+iVia));         //

    // Traço que corta em frente a Quantidade                   //
    Impressao.MoveTo(largura(-8+77),altura(32+iVia));         //
    Impressao.Lineto(largura(-8+77),altura(39+iVia));         //

    // Traço que corta                                          //
    Impressao.MoveTo(largura(-8+107),altura(32+iVia));         //
    Impressao.Lineto(largura(-8+107),altura(39+iVia));         //

    // Retangulo principal //
    Impressao.MoveTo(largura(-8+008),altura(11+iVia));           // Linha da Margem Superior
    Impressao.Lineto(largura(-8+200-18),altura(11+iVia));           // Linha da Margem Superior
    Impressao.Lineto(largura(-8+200-18),altura(78+iVia));           // Linha da Margem Direita
    Impressao.Lineto(largura(-8+008),altura(78+iVia));           // Linha da Margem Inferior
    Impressao.Lineto(largura(-8+008),altura(11+iVia));           // Linha da Margem Esquerda

    // Retangulo do valor e data //
    Impressao.MoveTo(largura(-8+150-8),altura(11+iVia));   //
    Impressao.Lineto(largura(-8+150-8),altura(70+iVia));   //
    Impressao.Lineto(largura(-8+150-8),altura(70+iVia));   //
    Impressao.Lineto(largura(-8+200-18),altura(70+iVia));   //

    if J = 2 then
    begin
      // Picote //
      Impressao.Pen.Width   := 1;                     // Largura da Linha

      // Picote
      for I := 1 to (170 div 2) do
      begin
        Impressao.MoveTo(largura(1+(I*2)),altura(-6+iVia));  //
        Impressao.Lineto(largura(1+(I*2)+1),altura(-6+iVia));  //
      end;

      // Tesourinha
      Impressao.Font.Name   := 'Wingdings';             // Fonte
      Impressao.Font.Size   := 15;                      // Tamanho da Fonte
      Impressao.TextOut(largura(1),altura(-8+iVia),'#');
    end;
  end;
end;



procedure DesenhaBoletoLayoutCarne(Impressao: TCanvas; CodBanco, sAgencia, sCodCedente, sConvenio, sCarteira, sNossoNumero, sMascara : string; Posicao:integer);
var
  rRect : Trect;
  ivia, I : Integer;
  sBanco : String;
  NumBancoBoleto : string;
begin
  Impressao.Pen.Color   := clBlack;
  Impressao.Pen.Width   := 1;                 // Largura da Linha + (J * 40 * Tamanho)

  begin
    Impressao.Font.Name   := 'Times New Roman';      // Fonte
    Impressao.Font.sTyle  := [fsBold];             // Estilo da fonte

    case Posicao of
      1 : iVia := -2;
      2 : iVia := 64;
      3 : iVia := 130;
    end;

    Impressao.Font.Size   := 11;          // Tamanho da Fonte
    Impressao.TextOut(largura(93),altura(6+iVia),Form25.FormataCodBarra(Form25.GeraCodBarra(CodBanco)));

    Impressao.Font.Name   := 'Times New Roman';      // Fonte
    Impressao.Font.Size   := 12;          // Tamanho da Fonte
    Impressao.Font.sTyle  := [fsBold];    // Estilo da fonte

    sBanco := 'banco'+CodBanco+'.bmp'; // banco001.bmp = Banco do Brasil; banco237.bmp = Bradesco

    if FileExists(sBanco) then
    begin
      Form25.Image7.Picture.LoadFromFile(sBanco);

      rRect.Top     := Altura(iVia+5);
      rRect.Left    := Largura(39);

      if Form25.Tag = 0 then  // Impressão na impressora
      begin
        rRect.Bottom  := rRect.Top  + (40 * Round(Printer.PageWidth / GetDeviceCaps(Printer.Handle,HORZSIZE) / 4));
        rRect.Right   := rRect.Left + (168 * Round(Printer.PageWidth / GetDeviceCaps(Printer.Handle,HORZSIZE) / 4));
      end else
      begin
        rRect.Bottom  := rRect.Top  + Form25.Image7.Picture.Graphic.Height;
        rRect.Right   := rRect.Left + Form25.Image7.Picture.Graphic.Width;
      end;

      Impressao.StretchDraw(rRect,Form25.Image7.Picture.Graphic);
    end else
    begin
      Impressao.TextOut(largura(8),altura(5+iVia),Copy(AllTrim(Form7.ibDataSet11NOME.AsString)+Replicate(' ',26),1,26)); // Nome do banco
    end;

    Impressao.Font.Size   := 14;          // Tamanho da Fonte

    NumBancoBoleto := CodBanco;
    if NumBancoBoleto = '136' then
      NumBancoBoleto := '136-8';

    if Length(LimpaNumero(NumBancoBoleto)) = 3 then
    begin
      Impressao.TextOut(largura(82),altura(6+iVia),Copy(NumBancoBoleto,1,3));   // Código do banco mais o dígito verificador
    end else
    begin
      Impressao.TextOut(largura(80),altura(6+iVia),NumBancoBoleto);   // Código do banco mais o dígito verificador
    end;

    Impressao.Font.Size   := 8;          // Tamanho da Fonte
    Impressao.Font.sTyle  := [];         // Estilo da fonte

    Impressao.TextOut(largura(40),altura(11+iVia),'Local de pagamento');
    Impressao.TextOut(largura(151-8),altura(11+iVia),'Vencimento');
    Impressao.TextOut(largura(40),altura(16+iVia),'Beneficiário');
    Impressao.TextOut(largura(110),altura(16+iVia),'CNPJ/CPF');
    Impressao.TextOut(largura(151-8),altura(16+iVia),'Agência/Código Beneficiário');

    Impressao.TextOut(largura(40),altura(21+iVia),'Data do documento');
    Impressao.TextOut(largura(64),altura(21+iVia),'Nr. do documento');
    Impressao.TextOut(largura(89),altura(21+iVia),'Espécie doc.');
    Impressao.TextOut(largura(105),altura(21+iVia),'Aceite');
    Impressao.TextOut(largura(116),altura(21+iVia),'Data processamento');
    Impressao.TextOut(largura(151-8),altura(21+iVia),'Nosso número');

    Impressao.TextOut(largura(40),altura(26+iVia),'Uso do banco');
    Impressao.TextOut(largura(64),altura(26+iVia),'Carteira');
    Impressao.TextOut(largura(83),altura(26+iVia),'Espécie');
    Impressao.TextOut(largura(93),altura(26+iVia),'Quantidade');

    Impressao.TextOut(largura(116),altura(26+iVia),'Valor');
    Impressao.TextOut(largura(151-8),altura(26+iVia),'(=)Valor do documento');

    Impressao.TextOut(largura(40),altura(31+iVia),'Instruções: (Todas as informações deste boleto são de responsabilidade do Beneficiário)');

    Impressao.TextOut(largura(151-8),altura(31+iVia),'(-)Desconto/Abatimento');
    Impressao.TextOut(largura(151-8),altura(36+iVia),'(+)Mora/Multa/Juros');
    Impressao.TextOut(largura(151-8),altura(41+iVia),'(=)Valor cobrado');

    Impressao.TextOut(largura(40),altura(46+iVia),'Nome do Pagador/CPF/CNPJ/Endereço');
    Impressao.TextOut(largura(151-8),altura(46+iVia),'Cod. Baixa:');

    Impressao.TextOut(largura(147),altura(59+iVia),'Autenticação mecânica');
    Impressao.TextOut(largura(143),altura(61.2+iVia),'FICHA DE COMPENSAÇÃO');

    // Preenchimento
    Impressao.Font.Name   := 'Courier New';  // Fonte
    Impressao.Font.Size   := 9;              // Tamanho da Fonte

    Impressao.TextOut(largura(40),altura(12+iVia),AllTrim(Form25.Edit1.Text));                        // Local de pagamento

    // Data atualizada com juros de mora
    if (Form25.chkDataAtualizadaJurosMora.Checked) and (Form7.ibDataSet7VENCIMENTO.AsDAteTime < Date) then // Sandro Silva 2022-12-28 if (Form25.CheckBox1.Checked) and (Form7.ibDataSet7VENCIMENTO.AsDAteTime < Date) then
    begin
      Impressao.TextOut(largura(151-8),altura(13+iVia),Right(Replicate(' ',30)+DateToStr(DATE),16)); // Vencimento
    end else
    begin
      Impressao.TextOut(largura(151-8),altura(13+iVia),Right(Replicate(' ',30)+Form7.ibDataSet7VENCIMENTO.AsString,16)); // Vencimento
    end;

    Impressao.TextOut(largura(40),altura(18+iVia),AllTrim(Copy(Form7.ibDataSet13NOME.AsString,1,35))); // Beneficiário
    Impressao.TextOut(largura(110),altura(18+iVia),AllTrim(Form7.ibDataSet13CGC.AsString));        // CNPJ
    Impressao.TextOut(largura(151-8),altura(18+iVia),Right(Replicate(' ',30)+AllTrim(sAgencia)+'/'+AllTrim(sCodCedente),16)); // Código do Beneficiário

    Impressao.TextOut(largura(40),altura(23+iVia),Form7.ibDataSet7EMISSAO.AsString); // Data do documento
    Impressao.TextOut(largura(65),altura(23+iVia),AllTrim(Form7.ibDataset7DOCUMENTO.AsString));
    Impressao.TextOut(largura(94),altura(23+iVia),'DM');            // DM
    Impressao.TextOut(largura(108),altura(23+iVia),'N');             // N
    Impressao.TextOut(largura(116),altura(23+iVia),Form7.ibDataSet7EMISSAO.AsString); // Data do processamento

    // Nosso Número / Cód. Documento
    if (CodBanco = '033') or (CodBanco = '353') then // SANTANDER
    begin
      // Módulo 11 para cálculo de dígito verificador de agência, código de Beneficiário e nosso-número
      // do banco do brasil conforme http://www.bb.com.br/appbb/portal/emp/ep/srv/CobrancaIntegrBB.jsp#6
      Form25.sNossoNum := Copy(StrZero(StrToFloat('0'+LimpaNumero(Form7.ibDataSet7NN.AsString)),7,0),1,07)+'-'+Modulo_11(LimpaNumero(Form7.ibDataSet7NN.AsString));
      //
      Impressao.TextOut(largura(151-6),altura(23+iVia),Right(Replicate(' ',30)+Form25.sNossoNum,13+3));
    end else
    begin
      if CodBanco = '001' then // Banco do Brasil
      begin
        // Módulo 11 para cálculo de dígito verificador de agência, código de Beneficiário e nosso-número
        // do banco do brasil conforme http://www.bb.com.br/appbb/portal/emp/ep/srv/CobrancaIntegrBB.jsp#6
        Form25.sNossoNum := Copy(Right('000000'+LimpaNumero(sConvenio),7),1,7)+Copy(StrZero(StrToFloat('0'+LimpaNumero(Form7.ibDataSet7NN.AsString)),10,0),1,010);

        Impressao.TextOut(largura(151-6),altura(23+iVia), Right(Replicate(' ',30)+Form25.sNossoNum,17));
      end else
      begin
        if CodBanco = '341' then // Itaú ITAU
        begin
          Form25.sNossoNum := AllTrim(LimpaNumero(sCarteira)) + '/'
            + StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),8,0) +'-'+
            Modulo_10(Copy(sAgencia+'0000',1,4)+Copy(sCodCedente+'00000',1,5)+Copy(sCarteira+'000',1,3)+Right('00000000'+sNossoNumero,8));
          Impressao.TextOut(largura(151-8),altura(23+iVia),Form25.sNossoNum);
        end else
        begin
          if CodBanco = '237' then // BRADESCO
          begin
            Form25.sNossoNum := AllTrim(LimpaNumero(sCarteira)) + '/' + '0'+ sNossoNumero + '-' + Modulo_11_bradesco(LimpaNumero(sCarteira)+'0'+LimpaNumero(sNossoNumero));
            Impressao.TextOut(largura(151-8),altura(23+iVia),Form25.sNossoNum);
          end else
          begin
            if CodBanco = '041' then // Banrisul
            begin
              Form25.sNossoNum := (StrZero(0,3,0) + StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),5,0)) +'-'+
                Modulo_Duplo_Digito_Banrisul((StrZero(0,3,0)+StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),5,0)));

              Impressao.TextOut(largura(151-8),altura(23+iVia),Right(Replicate(' ',30)+Form25.sNossoNum,16));
            end else
            begin
              if CodBanco = '104' then // CAIXA
              begin
                Form25.sNossoNum := AllTrim(LimpaNumero(sCarteira)) + '/'
                  + StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),15,0) +'-'+
                  Modulo_11((
                    StrZero(StrtoInt('0'+LimpaNumero(sCarteira)),2,0)+
                    StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),15,0)
                    ));

                Impressao.TextOut(largura(151-8)+4,altura(23+iVia), Right(Replicate(' ',30)+Form25.sNossoNum,20));
              end else
              begin
                if CodBanco = '756' then // SICOOB
                begin
                  Form25.sNossoNum := Right(Replicate(' ',30)+
                    StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),7,0)+'-'+
                    Modulo_sicoob(
                      Copy(sAgencia,1,4)+
                      StrZero(StrtoInt('0'+LimpaNumero(sCodCedente)),10,0)+
                      StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),7,0))
                      ,16);

                  Impressao.TextOut(largura(151-8),altura(23+iVia), Right(Replicate(' ',30)+Form25.sNossoNum,16));
                end else
                begin
                  if CodBanco = '748' then // SICREDI
                  begin
                    Form25.sNossoNum := Copy(IntToStr(Year(Form7.ibDataSet7EMISSAO.AsDateTime)),3,2)+'/2'+Copy(Form7.ibDataSet7NN.AsString,6,5)+'-'+Modulo_11(LimpaNumero(sAgencia)+LimpaNumero(sCodCedente)+Copy(IntToStr(Year(Form7.ibDataSet7EMISSAO.AsDateTime)),3,2)+'2'+Right(StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),15,0),5));

                    Impressao.TextOut(largura(151-8),altura(23+iVia), Right(Replicate(' ',30)+Form25.sNossoNum,16));
                  end else
                  begin
                    if CodBanco = '085' then // AILOS
                    begin
                      Form25.sNossoNum := Right('00000000'+LimpaNumero(sCodCedente),8) + Right('00000000'+LimpaNumero(sNossoNumero),9);

                      Impressao.TextOut(largura(151-6),altura(23+iVia), Right(Replicate(' ',30)+Form25.sNossoNum,17));
                    end else
                    begin
                      //Mauricio Parizotto 2023-12-07
                      if CodBanco = '136' then // Unicred
                      begin
                        Form25.sNossoNum := sNossoNumero;

                        Impressao.TextOut(largura(151-6),altura(23+iVia), Right(Replicate(' ',30)+Form25.sNossoNum,17));
                      end else
                      begin
                        Form25.sNossoNum := (AllTrim(LimpaNumero(sCarteira)) + '/'
                        + (StrZero(StrtoInt('0'+LimpaNumero(sConvenio)),3,0)+StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),5,0)) +'-'+
                        Modulo_11((StrZero(StrtoInt('0'+LimpaNumero(sConvenio)),3,0)+StrZero(StrtoInt('0'+LimpaNumero(sNossoNumero)),5,0))));

                        Impressao.TextOut(largura(151-8),altura(23+iVia),Right(Replicate(' ',30)+Form25.sNossoNum,16));
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;

    if ((AllTrim(sCarteira) = '24') or (AllTrim(sCarteira) = '14'))  and (CodBanco = '104') then
    begin
      if sMascara <> 'CCCCCCC00020004NNNNNNNNND' then
      begin
        Impressao.TextOut(largura(70),altura(28+iVia),'RG');
      end else
      begin
        Impressao.TextOut(largura(70),altura(28+iVia),'SR');
      end;
    end else
    begin
      Impressao.TextOut(largura(70),altura(28+iVia),Copy(sCarteira+'  ',1,3));
    end;

    Impressao.TextOut(largura(85),altura(28+iVia),'R$');
    Impressao.TextOut(largura(151-8),altura(28+iVia),Right(Replicate(' ',30)+Format('%12.2n',[Form7.ibDataSet7VALOR_DUPL.AsFloat]),16)); // Valor do documento

    // Data atualizada com juros de mora
    if (Form25.chkDataAtualizadaJurosMora.Checked) and (Form7.ibDataSet7VENCIMENTO.AsDAteTime < Date) then // Sandro Silva 2022-12-28 if (Form25.CheckBox1.Checked) and (Form7.ibDataSet7VENCIMENTO.AsDAteTime < Date) then
    begin
      if (Form7.ibDataSet7VALOR_JURO.AsFloat - Form7.ibDataSet7VALOR_DUPL.AsFloat) >= 0.01 then
      begin
        Impressao.TextOut(Largura(151-8),Altura(54+iVia)-3,Right(Replicate(' ',30)+Format('%12.2n',[Form7.ibDataSet7VALOR_JURO.AsFloat-Form7.ibDataSet7VALOR_DUPL.AsFloat]),16)); // Data atualizada com juros de mora
        Impressao.TextOut(Largura(151-8),Altura(66+iVia),Right(Replicate(' ',30)+Format('%12.2n',[Form7.ibDataSet7VALOR_JURO.AsFloat]),16)); // Valor cobrado
      end;
    end;


    {if (J = 1) then
    begin
      Impressao.TextOut(largura(-8+010),altura(43+iVia),AllTrim(Copy(Form7.ibDataSet13NOME.AsString+Replicate(' ',35),1,35))+' CNPJ/CPF: '+Form7.ibDataSet13CGC.AsString);
      Impressao.TextOut(largura(-8+010),altura(46+iVia),AllTrim(Form7.ibDataSet13ENDERECO.AsString) + ' - ' + AllTrim(Form7.ibDataSet13COMPLE.AsString)); // CEP e Cidade do emitente
      Impressao.TextOut(largura(-8+010),altura(49+iVia),AllTrim(Form7.ibDataSet13CEP.AsString)+' '+AllTrim(Form7.ibDataSet13MUNICIPIO.AsString)+' '+AllTrim(Form7.ibDataSet13ESTADO.AsString)); // Endereço do emitente
    end else}
    begin
      Impressao.TextOut(largura(010),altura(43+iVia),Form25.Edit4.Text); // Texto
      Impressao.TextOut(largura(010),altura(46+iVia),Form25.Edit5.Text); // Texto
      Impressao.TextOut(largura(010),altura(49+iVia),Form25.Edit6.Text); // Texto

      // RENEGOCIACAO
      if Copy(Form7.ibDataSet7HISTORICO.AsString,1,16) = 'CODIGO DO ACORDO' then
      begin
        Form25.Edit7.Visible := False;
        Impressao.TextOut(largura(010),altura(52+iVia),Form7.ibDataSet7HISTORICO.AsString); // Texto
      end else
      begin
        // Data atualizada com juros de mora
        if (Form25.chkDataAtualizadaJurosMora.Checked) and (Form7.ibDataSet7VENCIMENTO.AsDAteTime < Date) then // Sandro Silva 2022-12-28 if (Form25.CheckBox1.Checked) and (Form7.ibDataSet7VENCIMENTO.AsDAteTime < Date) then
        begin
          Impressao.TextOut(largura(010),altura(52+iVia),'VENCIMENTO ORIGINAL: '+Form7.ibDataSet7VENCIMENTO.AsString); // Texto
          Form25.Edit7.Visible := False;
        end else
        begin
          Impressao.TextOut(largura(010),altura(52+iVia),Form25.Edit7.Text); // Texto
          Form25.Edit7.Visible := True;
        end;
      end;
    end;

    Impressao.TextOut(largura(40),altura(46+3+iVia),AllTrim(Copy(Form7.ibDataSet2NOME.AsString+Replicate(' ',35),1,35))+' CNPJ/CPF: '+Form7.ibDataSet2CGC.AsString);
    Impressao.TextOut(largura(40),altura(49+3+iVia),AllTrim(Form7.ibDataSet2ENDERE.AsString) + ' - ' + AllTrim(Form7.ibDataSet2COMPLE.AsString)); // CEP e Cidade do Pagador
    Impressao.TextOut(largura(40),altura(52+3+iVia),AllTrim(Form7.ibDataSet2CEP.AsString)+' '+AllTrim(Form7.ibDataSet2CIDADE.AsString)+' '+AllTrim(Form7.ibDataSet2ESTADO.AsString)); // Endereço do Pagador

    Impressao.Font.Name   := 'Interleaved 2of5 Text';   // Fonte
    Impressao.Font.Size   := 19;                        // Tamanho da Fonte
    Impressao.Font.sTyle  := [];                        // Estilo da fonte


    //Código de Barras
    Impressao.TextOut(largura(41),altura(060+iVia),'('+SMALL_2of5(Form25.sNumero)+')');
    Impressao.TextOut(largura(41),altura(063+iVia),'('+SMALL_2of5(Form25.sNumero)+')');
    Impressao.TextOut(largura(41),altura(65.5+iVia),'('+SMALL_2of5(Form25.sNumero)+')');
    Impressao.Font.Name   := 'Microsoft Sans Serif';               // Fonte
    Impressao.Font.Size   := 6;                       // Tamanho da Fonte
    Impressao.TextOut(largura(41),altura(69+iVia),Replicate(' ',200));


    Impressao.Pen.Width   := 2;
    Impressao.MoveTo(largura(79),altura(06+iVia)); // Linha mais larga ao lado do código do banco
    Impressao.Lineto(largura(79),altura(11+iVia)); //
    Impressao.MoveTo(largura(92),altura(06+iVia)); //
    Impressao.Lineto(largura(92),altura(11+iVia)); //
    Impressao.Pen.Width   := 1;                     // Largura da Linha

    // Traço inferior da 1 linha //
    Impressao.MoveTo(largura(39),altura(16+iVia));
    Impressao.Lineto(largura(200-18),altura(16+iVia));

    // Traço inferior da 2 linha //
    Impressao.MoveTo(largura(39),altura(21+iVia));
    Impressao.Lineto(largura(200-18),altura(21+iVia));

    // Traço inferior da 3 linha //
    Impressao.MoveTo(largura(39),altura(26+iVia));
    Impressao.Lineto(largura(200-18),altura(26+iVia));

    // Traço inferior da 4 linha //
    Impressao.MoveTo(largura(39),altura(31+iVia));
    Impressao.Lineto(largura(200-18),altura(31+iVia));

    // Traço inferior do texto livre //
    Impressao.MoveTo(largura(39),altura(46+iVia));
    Impressao.Lineto(largura(200-18),altura(46+iVia));

    // Traço inferior da 4 linha //
    Impressao.MoveTo(largura(150-8),altura(36+iVia));
    Impressao.Lineto(largura(200-18),altura(36+iVia));

    // Traço inferior da 4 linha //
    Impressao.MoveTo(largura(150-8),altura(41+iVia));
    Impressao.Lineto(largura(200-18),altura(41+iVia));

    // Traço que corta em frete ao Nr. do documento e carteira
    Impressao.MoveTo(largura(62),altura(21+iVia));
    Impressao.Lineto(largura(62),altura(31+iVia));

    // Traço que corta em frente ao Espécie doc.
    Impressao.MoveTo(largura(88),altura(21+iVia));
    Impressao.Lineto(largura(88),altura(26+iVia));

    // Traço que corta em frente ao Aceite
    Impressao.MoveTo(largura(104),altura(21+iVia));
    Impressao.Lineto(largura(104),altura(26+iVia));

    // Traço que corta em frente a data processamento
    Impressao.MoveTo(largura(115),altura(21+iVia));
    Impressao.Lineto(largura(115),altura(26+iVia));

    // Traço que corta em frente a Espécie
    Impressao.MoveTo(largura(82),altura(26+iVia));
    Impressao.Lineto(largura(82),altura(31+iVia));

    // Traço que corta em frente a Quantidade
    Impressao.MoveTo(largura(92),altura(26+iVia));
    Impressao.Lineto(largura(92),altura(31+iVia));

    // Traço que corta
    Impressao.MoveTo(largura(115),altura(26+iVia));
    Impressao.Lineto(largura(115),altura(31+iVia));

    // Retangulo principal //
    Impressao.MoveTo(largura(39),altura(11+iVia));           // Linha da Margem Superior
    Impressao.Lineto(largura(200-18),altura(11+iVia));           // Linha da Margem Superior
    Impressao.Lineto(largura(200-18),altura(59+iVia));           // Linha da Margem Direita
    Impressao.Lineto(largura(39),altura(59+iVia));           // Linha da Margem Inferior
    Impressao.Lineto(largura(39),altura(11+iVia));           // Linha da Margem Esquerda


    // Retangulo do valor e data
    Impressao.MoveTo(largura(150-8),altura(11+iVia));
    Impressao.Lineto(largura(150-8),altura(46+iVia));

    {$Region'//// Picote ////'}
    if posicao > 1 then

    begin
      Impressao.Pen.Width   := 1;                     // Largura da Linha

      // Picote
      for I := 1 to (182 div 2) do
      begin
        Impressao.MoveTo(largura((I*2)),altura(5+iVia));
        Impressao.Lineto(largura((I*2)+1),altura(5+iVia));
      end;

      // Tesourinha
      Impressao.Font.Name   := 'Wingdings';             // Fonte
      Impressao.Font.Size   := 15;                      // Tamanho da Fonte
      Impressao.TextOut(largura(0),altura(3+iVia),'#');
    end;
    {$Endregion}
  end;
end;



end.
