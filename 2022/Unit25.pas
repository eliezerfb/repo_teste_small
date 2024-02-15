unit Unit25;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, synPDF,
  ExtCtrls, StdCtrls, Mask, DBCtrls, SMALL_DBEdit, smallfunc_xe, IniFiles, Printers, ShellApi, jpeg, DB,
  Buttons;

type
  TForm25 = class(TForm)
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    PrinterSetupDialog1: TPrinterSetupDialog;
    Edit1: TEdit;
    Edit2: TEdit;
    Image1: TImage;
    Image7: TImage;
    Image2: TImage;
    Panel1: TPanel;
    btnConfigurarBoleto: TBitBtn;
    btnAnterior: TBitBtn;
    btnProximo: TBitBtn;
    btnImprimir: TBitBtn;
    btnImprimirTodos: TBitBtn;
    btnEnviaEmail: TBitBtn;
    btnEnviaEmailTodos: TBitBtn;
    btnCriaImagemBoleto: TBitBtn;
    chkDataAtualizadaJurosMora: TCheckBox;
    PrintDialog1: TPrintDialog;
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnProximoClick(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnConfigurarBoletoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure btnImprimirTodosClick(Sender: TObject);
    procedure btnCriaImagemBoletoClick(Sender: TObject);
    procedure btnEnviaEmailClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chkDataAtualizadaJurosMoraClick(Sender: TObject);
    procedure btnEnviaEmailTodosClick(Sender: TObject);
//    procedure btnCNAB400Click(Sender: TObject); Mauricio Parizotto 2023-10-03 uGeraCNAB400
//    procedure btnCNAB240Click(Sender: TObject); Mauricio Parizotto 2023-10-03 uGeraCNAB240
  private
    { Private declarations }
    bOk : Boolean; // Sandro Silva 2023-06-20
    sInstituicaoFinanceira : string;
    sTipoMulta : string;
    vMulta : Double;
    procedure ImprimirBoleto;
    procedure ValidaEmailPagador;
  public
    { Public declarations }
    sNossoNum : String;
    sNumero   : String;
    procedure GravaPortadorNossoNumCodeBar;
    function GeraCodBarra(codBanco:string): string;
    function FormataCodBarra(codBarra: string): string;
  end;

var
// Sandro Silva 2023-06-20  bOk : Boolean;
  Form25: TForm25;
  vCampo:  array [1..20]  of String;    // Cria uma matriz com 20 elementos
  vLinha:  array [1..65]  of STring;    // Linhas

implementation

uses Unit7, Unit26, Mais, Unit22, Unit14, Unit40, uFuncoesBancoDados,
  uFuncoesRetaguarda, uDialogs, uEmail;

{$R *.DFM}

function FatorDeVencimento(D: TdateTime) : TdateTime;
begin
  if D < StrToDate('22/02/2025') then
  begin
    Result := StrToDate('07/10/1997');
  end else
  begin
    Result := StrToDate('22/02/2025') - 1000;
  end;
end;

function CriaBoletoJpg(FileNameJpg: String) :Boolean;
var
  jp: TJPEGImage;  //Requires the "jpeg" unit added to "uses" clause.
  rRect: Trect;
  jpgTemp: String; // Sandro Silva 2022-12-28
begin
  try
    jpgTemp := 'boleto_temp_' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '.tmp'; // Sandro Silva 2022-12-28

    Form25.Image2.Width  := (Form25.Image1.Width  + 40) * 1;
    Form25.Image2.Height := (Form25.Image1.Height + 40) * 1;

    rRect.Top    := 20;
    rRect.Left   := 20;
    rRect.Bottom := rRect.Top  + Form25.Image1.Picture.Graphic.Height;
    rRect.Right  := rRect.Left + Form25.Image1.Picture.Graphic.Width;

    Form25.Image2.Canvas.StretchDraw(rRect, Form25.Image1.Picture.Graphic);

    jp := TJPEGImage.Create;
    jp.Assign(Form25.Image2.Picture.Bitmap);
    jp.CompressionQuality := 100;
    jp.SaveToFile(jpgTemp);
    jp.Free;

    if Form1.DisponivelSomenteParaNos then
      Sleep(250);

    while FileExists(FileNameJpg) do
      DeleteFile(FileNameJpg);

    RenameFile(jpgTemp, FileNameJpg); // Sandro Silva 2022-12-28
  except
  end;

  Result := True;
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

function PointX(MM : Double) : Longint;
begin
  Result := Round(Printer.PageWidth / GetDeviceCaps(Printer.Handle,HORZSIZE));
end;

function GeraImagemDoBoletoComOCodigoDeBarras(bP1: Boolean{; bGravaPortadorNossoNumCodeBar: Boolean}): Boolean;
var
  rRect : Trect;
  ivia, I, J: Integer;
  sBanco, sPortador : String;
  Impressao: TCanvas;
  Device : array[0..255] of char;
  Driver : array[0..255] of char;
  Port   : array[0..255] of char;
  hDMode : THandle;
  PDMode : PDEVMODE;
  NumBancoBoleto : string;
  codBarrasSemDV, DV : string;
begin
  Form7.ibDataSet11.Active := True;
  Form7.ibDataSet11.First;

  while (AllTrim(Copy(Form1.sEscolhido+Replicate(' ',40),23,40)) <> AllTrim(Form7.ibDataSet11NOME.AsString)) and (not Form7.ibDataSet11.EOF) do
    Form7.ibDataSet11.Next;

  if AllTrim(Form26.MaskEdit42.Text) = '' then
  begin
    if Pos('AILOS',UpperCase(Form7.ibDataSet11NOME.AsString))    <> 0 then Form26.MaskEdit42.Text := '085';
    if Pos('SICREDI',UpperCase(Form7.ibDataSet11NOME.AsString))  <> 0 then Form26.MaskEdit42.Text := '748';
    if Pos('SICOOB',UpperCase(Form7.ibDataSet11NOME.AsString))   <> 0 then Form26.MaskEdit42.Text := '756';
    if Pos('BRADESCO',UpperCase(Form7.ibDataSet11NOME.AsString)) <> 0 then Form26.MaskEdit42.Text := '237';
    if Pos('BRASIL',UpperCase(Form7.ibDataSet11NOME.AsString))   <> 0 then Form26.MaskEdit42.Text := '001';
    if Pos('UNIBANCO',UpperCase(Form7.ibDataSet11NOME.AsString)) <> 0 then Form26.MaskEdit42.Text := '409';
    if Pos('ITAU',UpperCase(Form7.ibDataSet11NOME.AsString))     <> 0 then Form26.MaskEdit42.Text := '341';
    if Pos('ITAÚ',UpperCase(Form7.ibDataSet11NOME.AsString))     <> 0 then Form26.MaskEdit42.Text := '341';
    if Pos('ITAÚ',AnsiUpperCase(Form7.ibDataSet11NOME.AsString)) <> 0 then Form26.MaskEdit42.Text := '341';
    if Pos('CAIXA',UpperCase(Form7.ibDataSet11NOME.AsString))    <> 0 then Form26.MaskEdit42.Text := '104';
    if Pos('BANRISUL',UpperCase(Form7.ibDataSet11NOME.AsString)) <> 0 then Form26.MaskEdit42.Text := '041';
    if Pos('SANTANDER',UpperCase(Form7.ibDataSet11NOME.AsString))<> 0 then Form26.MaskEdit42.Text := '033';
    if Pos('Unicred',UpperCase(Form7.ibDataSet11NOME.AsString))  <> 0 then Form26.MaskEdit42.Text := '136'; //Mauricio Parizotto 2023-12-07
  end;

  try
    // Nosso Número
    Form7.ibDataSet7.Edit;
    if AllTrim(Form7.ibDataSet7DOCUMENTO.AsString) = '' then
    begin
      Form7.ibDataSet7DOCUMENTO.AsString := StrZero(Form7.ibDataSet7.Recno,6,0)+'0';
    end;

    if Form7.ibDataSet7NN.AsString = '' then
    begin
      Form7.ibDataSet99.Close;
      Form7.ibDataSet99.SelectSql.Clear;
      Form7.ibDataset99.SelectSql.Add('select gen_id(G_NN,1) from rdb$database');
      Form7.ibDataset99.Open;
      Form7.ibDataSet7.Edit;
      Form7.ibDataSet7NN.AsString := strZero(StrToInt(Form7.ibDataSet99.FieldByname('GEN_ID').AsString),10,0);

      Form7.ibDataSet7.Post;
      Form7.ibDataset99.Close;
    end;

    if (Form25.chkDataAtualizadaJurosMora.Checked) and (Form7.ibDataSet7VENCIMENTO.AsDAteTime < Date) then // Sandro Silva 2022-12-28 if (Form25.CheckBox1.Checked) and (Form7.ibDataSet7VENCIMENTO.AsDAteTime < Date) then
    begin
      // Data atualizada com juros de mora
      Form26.MaskEdit49.Text := StrZero( DATE - StrtoDate('01/01/'+InttoStr(Year(Date))),3,0)+Right(IntToStr(Year(DAte)),2);
    end else
    begin
      Form26.MaskEdit49.Text := StrZero( Form7.ibDataSet7VENCIMENTO.AsDAteTime - StrtoDate('01/01/'+InttoStr(Year(Date))),3,0)+Right(IntToStr(Year(DAte)),2);
    end;

    Form26.MaskEdit47.Text := Form7.ibDataSet7NN.AsString;

    if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '136' then // Unicred
    begin
      Form26.MaskEdit47.Text := Right('00000000000'+LimpaNumero( Form7.ibDataSet7NN.AsString),10) +'-'+Modulo_11_Febraban(LimpaNumero( Form7.ibDataSet7NN.AsString)); 
    end;

    Form26.MaskEdit43.Text := Form26.MaskEdit43.Text + Modulo_11_febraban(LimpaNumero(Form26.MaskEdit43.Text));  // Modulo 11
    Form25.sNumero         := '';

    if Length(Form26.MaskEdit45.Text) <> 25 then
      Form26.MaskEdit45.Text := '0000000000000000000000000';

    {
    if (Form25.chkDataAtualizadaJurosMora.Checked) and (Form7.ibDataSet7VENCIMENTO.AsDAteTime < Date) then // Sandro Silva 2022-12-28 if (Form25.CheckBox1.Checked) and (Form7.ibDataSet7VENCIMENTO.AsDAteTime < Date) then
    begin
      Form25.sNumero := LimpaNumero(
                          Copy(Form26.MaskEdit42.Text,1,3))+'9'+
                          Modulo_11_febraban(LimpaNumero(Copy(Form26.MaskEdit42.Text,1,3))+'9'+ StrZero(DATE-FatorDeVencimento(DATE),4,0)+ StrZero(Form7.ibDataSet7VALOR_JURO.AsFloat*100,10,0) +LimpaNumero(Form26.MaskEdit48.Text))+
                          StrZero(DATE-FatorDeVencimento(DATE),4,0)+ StrZero(Form7.ibDataSet7VALOR_JURO.AsFloat*100,10,0) +LimpaNumero(Form26.MaskEdit48.Text);
    end else
    begin
      Form25.sNumero := LimpaNumero(
                          Copy(Form26.MaskEdit42.Text,1,3))+'9'+
                          Modulo_11_febraban(LimpaNumero(Copy(Form26.MaskEdit42.Text,1,3))+'9'+
                          StrZero(StrToDate(Form7.ibDataSet7VENCIMENTO.AsString)-FatorDeVencimento(StrToDate(Form7.ibDataSet7VENCIMENTO.AsString)),4,0)+
                          StrZero(Form7.ibDataSet7VALOR_DUPL.AsFloat*100,10,0) +LimpaNumero(Form26.MaskEdit48.Text))+StrZero(StrToDate(Form7.ibDataSet7VENCIMENTO.AsString)-FatorDeVencimento(StrToDate(Form7.ibDataSet7VENCIMENTO.AsString)),4,0)+ StrZero(Form7.ibDataSet7VALOR_DUPL.AsFloat*100,10,0) +LimpaNumero(Form26.MaskEdit48.Text);
    end;
    Mauricio Parizotto 2023-12-08}

    if (Form25.chkDataAtualizadaJurosMora.Checked) and (Form7.ibDataSet7VENCIMENTO.AsDAteTime < Date) then // Sandro Silva 2022-12-28 if (Form25.CheckBox1.Checked) and (Form7.ibDataSet7VENCIMENTO.AsDAteTime < Date) then
    begin
      codBarrasSemDV := LimpaNumero(Copy(Form26.MaskEdit42.Text,1,3))+ // Banco
                        '9'+//Moeda
                        StrZero(DATE-FatorDeVencimento(DATE),4,0)+//Vencimento
                        StrZero(Form7.ibDataSet7VALOR_JURO.AsFloat*100,10,0) +//Valor título
                        LimpaNumero(Form26.MaskEdit48.Text);//Mascara

      DV := Modulo_11_febraban(codBarrasSemDV);
      Form25.sNumero := copy(codBarrasSemDV,1,4)+DV+copy(codBarrasSemDV,5,39);
    end else
    begin
      codBarrasSemDV := LimpaNumero(Copy(Form26.MaskEdit42.Text,1,3))+ //Banco
                        '9'+//Moeda
                        StrZero(StrToDate(Form7.ibDataSet7VENCIMENTO.AsString)-FatorDeVencimento(StrToDate(Form7.ibDataSet7VENCIMENTO.AsString)),4,0)+//Vencimento
                        StrZero(Form7.ibDataSet7VALOR_DUPL.AsFloat*100,10,0) +//Valor título
                        LimpaNumero(Form26.MaskEdit48.Text);//Mascara

      DV := Modulo_11_febraban(codBarrasSemDV);
      Form25.sNumero := copy(codBarrasSemDV,1,4)+DV+copy(codBarrasSemDV,5,39);
    end;


    sPortador        := Copy(Form1.sEscolhido+replicate(' ',35),23,35);
    Form25.sNossoNum := '';
    // --------------------------------------------------- //
    // inicio da impressão do Boleto em Código de Barras //
    // --------------------------------------------------- /

    if bP1 then
    begin
      Printer.PrinterIndex := Printer.PrinterIndex;
      Printer.GetPrinter(Device, Driver, Port, hDMode);

      if hDMode <> 0 then begin
        pDMode := GlobalLock(hDMode);
        if pDMode <> nil then
        begin
          // papel A4
          pDMode^.dmFields := pDMode^.dmFields or dm_PaperSize;
          pDMode^.dmPaperSize := DMPAPER_A4;

          //Printer.Title              := 'Bloqueto de cobrança bancária';  // Este título é visto no spoool da impressora
          Printer.Title              := 'Boleto de cobrança bancária';  // Este título é visto no spoool da impressora
          Printer.BeginDoc;                                // Inicia o documento de impressão
        end;
      end;

      Impressao        := Printer.Canvas;
    end else
    begin
      Form25.Image1.Height := 1039;
      Impressao            := Form25.Image1.Canvas;
      Impressao.Pen.Color  := clWhite;
      Impressao.Rectangle(0,0,Form25.Image1.Width,1200);
    end;

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

      {Mauricio Parizotto 2023-12-07
      Impressao.TextOut(largura(63),altura(6+iVia),
        Copy(Form26.MaskEdit42.Text,1,3)+ // Identificação do banco
        '9'+                              // Moeda
        Copy(Form25.sNumero,20,1)+               // Campo Livre 20 a 21 do código de barras
        '.'+                              // Ponto para facilitar a digitação
        Copy(Form25.sNumero,21,4)+               // Campo Livre 21 a 24 do código de barras
        Modulo_10(Copy(Form26.MaskEdit42.Text,1,3)+'9'+Copy(Form25.sNumero,20,1)+Copy(Form25.sNumero,21,4))+ // Digito verificador dos 10 primeiros numeros
        //
        '  '+
        Copy(Form25.sNumero,25,5)+               // Campo Livre 25 a 29 do código de barras
        '.'+                              // Ponto para facilitar a digitação
        Copy(Form25.sNumero,30,5)+               // Campo Livre 30 a 34 do código de barras
        Modulo_10(Copy(Form25.sNumero,25,10))+   // Digito verificador
        '  '+
        Copy(Form25.sNumero,35,5)+               // Campo Livre 35 a 39 do código de barras
        '.'+                              // Ponto para facilitar a digitação
        Copy(Form25.sNumero,40,5)+               // Campo Livre 40 a 44 do código de barras
        Modulo_10(Copy(Form25.sNumero,35,10))+   // Digito verificador
        //
        '  '+
        Copy(Form25.sNumero,5,1)+                // Dígito de verificação geral posição 5 do codebat
        '  '+
        Copy(Form25.sNumero,6,4)+                // 6 a 9 do código de barras - fator de vencimento
        Copy(Form25.sNumero,10,10));             // 10 a 19 do código de barras - valor nominal
      }
      Impressao.TextOut(largura(63),altura(6+iVia),Form25.FormataCodBarra(Form25.GeraCodBarra(Copy(Form26.MaskEdit42.Text,1,3))));

      Impressao.Font.Name   := 'Times New Roman';      // Fonte
      Impressao.Font.Size   := 12;          // Tamanho da Fonte
      Impressao.Font.sTyle  := [fsBold];    // Estilo da fonte

      sBanco := 'banco'+Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+'.bmp'; // banco001.bmp = Banco do Brasil; banco237.bmp = Bradesco

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

      {Mauricio Parizotto 2023-12-07 Inicio
      if Length(LimpaNumero(Form26.MaskEdit42.Text)) = 3 then
      begin
        Impressao.TextOut(largura(-8+58),altura(6+iVia),Copy(Form26.MaskEdit42.Text,1,3));   // Código do banco mais o dígito verificador
      end else
      begin
        Impressao.TextOut(largura(-8-2+58),altura(6+iVia),Form26.MaskEdit42.Text);   // Código do banco mais o dígito verificador
      end;
      }

      NumBancoBoleto := trim(Form26.MaskEdit42.Text);
      if NumBancoBoleto = '136' then
        NumBancoBoleto := '136-8';

      if Length(LimpaNumero(NumBancoBoleto)) = 3 then
      begin
        Impressao.TextOut(largura(-8+58),altura(6+iVia),Copy(NumBancoBoleto,1,3));   // Código do banco mais o dígito verificador
      end else
      begin
        Impressao.TextOut(largura(-8-2+58),altura(6+iVia),NumBancoBoleto);   // Código do banco mais o dígito verificador
      end;

      {Mauricio Parizotto 2023-12-07 Fim}

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
      Impressao.TextOut(largura(-8+151-8),altura(21+iVia),Right(Replicate(' ',30)+AllTrim(Form26.MaskEdit44.Text)+'/'+AllTrim(Form26.MaskEdit46.Text),16));

      Impressao.TextOut(largura(-8+009),altura(28+iVia),Form7.ibDataSet7EMISSAO.AsString); // Data do documento
      Impressao.TextOut(largura(-8+040),altura(28+iVia),AllTrim(Form7.ibDataset7DOCUMENTO.AsString));
      Impressao.TextOut(largura(-8+073),altura(28+iVia),'DM');            // DM
      Impressao.TextOut(largura(-8+090),altura(28+iVia),'N');             // N
      Impressao.TextOut(largura(-8+105),altura(28+iVia),Form7.ibDataSet7EMISSAO.AsString); // Data do processamento

      // Nosso Número / Cód. Documento
      if (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '033') or (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '353') then // SANTANDER
      begin
        // Módulo 11 para cálculo de dígito verificador de agência, código de Beneficiário e nosso-número
        // do banco do brasil conforme http://www.bb.com.br/appbb/portal/emp/ep/srv/CobrancaIntegrBB.jsp#6
        //
        Form25.sNossoNum := Copy(StrZero(StrToFloat('0'+LimpaNumero(Form7.ibDataSet7NN.AsString)),7,0),1,07)+'-'+Modulo_11(LimpaNumero(Form7.ibDataSet7NN.AsString));
        //
        Impressao.Font.Size   := 10;             // Tamanho da Fonte
        Impressao.TextOut(largura(-8+151-6),altura(28+iVia),Right(Replicate(' ',30)+Form25.sNossoNum,13+3));
        Impressao.Font.Size   := 11;             // Tamanho da Fonte
      end else
      begin
        if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '001' then // Banco do Brasil
        begin
          // Módulo 11 para cálculo de dígito verificador de agência, código de Beneficiário e nosso-número
          // do banco do brasil conforme http://www.bb.com.br/appbb/portal/emp/ep/srv/CobrancaIntegrBB.jsp#6
          Form25.sNossoNum := Copy(Right('000000'+LimpaNumero(Form26.MaskEdit50.Text),7),1,7)+Copy(StrZero(StrToFloat('0'+LimpaNumero(Form7.ibDataSet7NN.AsString)),10,0),1,010);

          Impressao.Font.Size   := 10;             // Tamanho da Fonte
          Impressao.TextOut(largura(-8+151-6),altura(28+iVia), Right(Replicate(' ',30)+Form25.sNossoNum,17));
          Impressao.Font.Size   := 11;             // Tamanho da Fonte
        end else
        begin
          if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '341' then // Itaú ITAU
          begin
            Form25.sNossoNum := AllTrim(LimpaNumero(Form26.MaskEdit43.Text)) + '/'
              + StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit47.Text)),8,0) +'-'+
              Modulo_10(Copy(Form26.MaskEdit44.Text+'0000',1,4)+Copy(Form26.MaskEdit46.Text+'00000',1,5)+Copy(Form26.MaskEdit43.Text+'000',1,3)+Right('00000000'+Form26.MaskEdit47.Text,8));
            Impressao.TextOut(largura(-8+151-8),altura(28+iVia),Form25.sNossoNum);
          end else
          begin
            if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '237' then // BRADESCO
            begin
              Form25.sNossoNum := AllTrim(LimpaNumero(Form26.MaskEdit43.Text)) + '/' + '0'+ Form26.MaskEdit47.Text + '-' + Modulo_11_bradesco(LimpaNumero(Form26.MaskEdit43.Text)+'0'+LimpaNumero(Form26.MaskEdit47.Text));
              Impressao.TextOut(largura(-8+151-8),altura(28+iVia),Form25.sNossoNum);
            end else
            begin
              if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '041' then // Banrisul
              begin
                {
                Form25.sNossoNum := (StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit50.Text)),3,0)+StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit47.Text)),5,0)) +'-'+
                  Modulo_Duplo_Digito_Banrisul((StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit50.Text)),3,0)+StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit47.Text)),5,0)));
                Mauricio Parizotto 2023-11-09}

                Form25.sNossoNum := (StrZero(0,3,0) + StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit47.Text)),5,0)) +'-'+
                  Modulo_Duplo_Digito_Banrisul((StrZero(0,3,0)+StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit47.Text)),5,0)));

                Impressao.TextOut(largura(-8+151-8),altura(28+iVia),Right(Replicate(' ',30)+Form25.sNossoNum,16));
              end else
              begin
                if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '104' then // CAIXA
                begin
                  Form25.sNossoNum := AllTrim(LimpaNumero(Form26.MaskEdit43.Text)) + '/'
                    + StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit47.Text)),15,0) +'-'+
                    Modulo_11((
                      StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit43.Text)),2,0)+
                      StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit47.Text)),15,0)
                      ));

                  Impressao.Font.Size   := 9;             // Tamanho da Fonte
                  Impressao.TextOut(largura(-8+151-8)+4,altura(28+iVia), Right(Replicate(' ',30)+Form25.sNossoNum,20));
                  Impressao.Font.Size   := 11;             // Tamanho da Fonte
                end else
                begin
                  if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '756' then // SICOOB
                  begin
                    Form25.sNossoNum := Right(Replicate(' ',30)+
                      StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit47.Text)),7,0)+'-'+
                      Modulo_sicoob(
                        Copy(Form26.MaskEdit44.Text,1,4)+
                        StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit46.Text)),10,0)+
                        StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit47.Text)),7,0))
                        ,16);

                    Impressao.TextOut(largura(-8+151-8),altura(28+iVia), Right(Replicate(' ',30)+Form25.sNossoNum,16));
                  end else
                  begin
                    if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '748' then // SICREDI
                    begin
                      Form25.sNossoNum := Copy(IntToStr(Year(Form7.ibDataSet7EMISSAO.AsDateTime)),3,2)+'/2'+Copy(Form7.ibDataSet7NN.AsString,6,5)+'-'+Modulo_11(LimpaNumero(Form26.MaskEdit44.Text)+LimpaNumero(Form26.MaskEdit46.Text)+Copy(IntToStr(Year(Form7.ibDataSet7EMISSAO.AsDateTime)),3,2)+'2'+Right(StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit47.Text)),15,0),5));

                      Impressao.TextOut(largura(-8+151-8),altura(28+iVia), Right(Replicate(' ',30)+Form25.sNossoNum,16));
                    end else
                    begin
                      if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '085' then // AILOS
                      begin
                        Form25.sNossoNum := Right('00000000'+LimpaNumero(Form26.MaskEdit46.Text),8) + Right('00000000'+LimpaNumero(Form26.MaskEdit47.Text),9);

                        Impressao.Font.Size   := 10;             // Tamanho da Fonte
                        Impressao.TextOut(largura(-8+151-6),altura(28+iVia), Right(Replicate(' ',30)+Form25.sNossoNum,17));
                        Impressao.Font.Size   := 11;             // Tamanho da Fonte
                      end else
                      begin
                        //Mauricio Parizotto 2023-12-07
                        if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '136' then // Unicred
                        begin
                          Form25.sNossoNum := Form26.MaskEdit47.Text;

                          Impressao.Font.Size   := 10;             // Tamanho da Fonte
                          Impressao.TextOut(largura(-8+151-6),altura(28+iVia), Right(Replicate(' ',30)+Form25.sNossoNum,17));
                          Impressao.Font.Size   := 11;             // Tamanho da Fonte
                        end else
                        begin
                          Form25.sNossoNum := (AllTrim(LimpaNumero(Form26.MaskEdit43.Text)) + '/'
                          + (StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit50.Text)),3,0)+StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit47.Text)),5,0)) +'-'+
                          Modulo_11((StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit50.Text)),3,0)+StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit47.Text)),5,0))));

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

      if ((AllTrim(Form26.MaskEdit43.Text) = '24') or (AllTrim(Form26.MaskEdit43.Text) = '14'))  and ((Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '104')) then
      begin
        if Form26.MaskEdit45.Text <> 'CCCCCCC00020004NNNNNNNNND' then
        begin
          Impressao.TextOut(largura(-8+039),altura(35+iVia),'RG');
        end else
        begin
          Impressao.TextOut(largura(-8+039),altura(35+iVia),'SR');
        end;
      end else
      begin
        Impressao.TextOut(largura(-8+039),altura(35+iVia),Copy(Form26.MaskEdit43.Text+'  ',1,3));
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

      if (J = 1) and ((Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '104')) then
      begin
        Impressao.TextOut(Largura(002),Altura(81+2+iVia),'SAC CAIXA: 0800 726 0101 (informações, reclamações, sugestões e elogios)');
        Impressao.TextOut(Largura(002),Altura(84+2+iVia),'Para pessoas com deficiência auditiva ou de fala: 0800 726 2492');
        Impressao.TextOut(Largura(002),Altura(87+2+iVia),'Ouvidoria: 0800 725 7474 www.caixa.gov.br');
      end;

      if (J = 1) and ((Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '041')) then
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
      ///////////////////////////////
      // Traço inferior da 1 linha //
      ///////////////////////////////
      Impressao.MoveTo(largura(-8+008),altura(18+iVia));        //
      Impressao.Lineto(largura(-8+200-18),altura(18+iVia));        //
      ///////////////////////////////
      // Traço inferior da 2 linha //
      ///////////////////////////////
      Impressao.MoveTo(largura(-8+008),altura(25+iVia));        //
      Impressao.Lineto(largura(-8+200-18),altura(25+iVia));        //
      ///////////////////////////////
      // Traço inferior da 3 linha //
      ///////////////////////////////
      Impressao.MoveTo(largura(-8+008),altura(32+iVia));        //
      Impressao.Lineto(largura(-8+200-18),altura(32+iVia));        //
      ///////////////////////////////
      // Traço inferior da 4 linha //
      ///////////////////////////////
      Impressao.MoveTo(largura(-8+008),altura(39+iVia));        //
      Impressao.Lineto(largura(-8+200-18),altura(39+iVia));        //
      ///////////////////////////////////
      // Traço inferior do texto livre //
      ///////////////////////////////////
      Impressao.MoveTo(largura(-8+008),altura(63+iVia));        //
      Impressao.Lineto(largura(-8+200-18),altura(63+iVia));        //
      ///////////////////////////////
      // Traço inferior da 4 linha //
      ///////////////////////////////
      Impressao.MoveTo(largura(-8+150-8),altura(45+iVia));        //
      Impressao.Lineto(largura(-8+200-18),altura(45+iVia));        //
      ///////////////////////////////
      // Traço inferior da 4 linha //
      ///////////////////////////////
      Impressao.MoveTo(largura(-8+150-8),altura(51+iVia));        //
      Impressao.Lineto(largura(-8+200-18),altura(51+iVia));        //
      ///////////////////////////////
      // Traço inferior da 4 linha //
      ///////////////////////////////
      Impressao.MoveTo(largura(-8+150-8),altura(57+iVia));        //
      Impressao.Lineto(largura(-8+200-18),altura(57+iVia));        //
      //////////////////////////////////////////////////////////////
      // Traço que corta em frete ao Nr. do documento e carteira  //
      //////////////////////////////////////////////////////////////
      Impressao.MoveTo(largura(-8+36),altura(25+iVia));         //
      Impressao.Lineto(largura(-8+36),altura(39+iVia));         //
      //////////////////////////////////////////////////////////////
      // Traço que corta em frente ao Espécie doc.                //
      //////////////////////////////////////////////////////////////
      Impressao.MoveTo(largura(-8+67),altura(25+iVia));         //
      Impressao.Lineto(largura(-8+67),altura(32+iVia));         //
      //////////////////////////////////////////////////////////////
      // Traço que corta em frente ao Aceite                      //
      //////////////////////////////////////////////////////////////
      Impressao.MoveTo(largura(-8+87),altura(25+iVia));         //
      Impressao.Lineto(largura(-8+87),altura(32+iVia));         //
      //////////////////////////////////////////////////////////////
      // Traço que corta em frente a data processamento           //
      //////////////////////////////////////////////////////////////
      Impressao.MoveTo(largura(-8+97),altura(25+iVia));         //
      Impressao.Lineto(largura(-8+97),altura(32+iVia));         //
      //////////////////////////////////////////////////////////////
      // Traço que corta em frente a Espécie                      //
      //////////////////////////////////////////////////////////////
      Impressao.MoveTo(largura(-8+57),altura(32+iVia));         //
      Impressao.Lineto(largura(-8+57),altura(39+iVia));         //
      //////////////////////////////////////////////////////////////
      // Traço que corta em frente a Quantidade                   //
      //////////////////////////////////////////////////////////////
      Impressao.MoveTo(largura(-8+77),altura(32+iVia));         //
      Impressao.Lineto(largura(-8+77),altura(39+iVia));         //
      //////////////////////////////////////////////////////////////
      // Traço que corta                                          //
      //////////////////////////////////////////////////////////////
      Impressao.MoveTo(largura(-8+107),altura(32+iVia));         //
      Impressao.Lineto(largura(-8+107),altura(39+iVia));         //
      /////////////////////////
      // Retangulo principal //
      /////////////////////////
      Impressao.MoveTo(largura(-8+008),altura(11+iVia));           // Linha da Margem Superior
      Impressao.Lineto(largura(-8+200-18),altura(11+iVia));           // Linha da Margem Superior
      Impressao.Lineto(largura(-8+200-18),altura(78+iVia));           // Linha da Margem Direita
      Impressao.Lineto(largura(-8+008),altura(78+iVia));           // Linha da Margem Inferior
      Impressao.Lineto(largura(-8+008),altura(11+iVia));           // Linha da Margem Esquerda
      ///////////////////////////////
      // Retangulo do valor e data //
      ///////////////////////////////
      Impressao.MoveTo(largura(-8+150-8),altura(11+iVia));   //
      Impressao.Lineto(largura(-8+150-8),altura(70+iVia));   //
      Impressao.Lineto(largura(-8+150-8),altura(70+iVia));   //
      Impressao.Lineto(largura(-8+200-18),altura(70+iVia));   //

      if J = 2 then
      begin
        ////////////
        // Picote //
        ////////////
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

      // -------------------------------------------------- //
      // Final da Impressão do Bloqueto em Código de Barras //
      // -------------------------------------------------- //
    end;

    // final da impressao das vias controlado pelo J
    if bP1 then
    begin
      Printer.EndDoc;
    end else
    begin
      Form25.Image1.Refresh;
      Form25.Image1.Top := -525;
    end;

    Result     := True;
  except
    on E: Exception do
    begin
      {Sandro Silva 2022-12-28 inicio}
      if Form1.DisponivelSomenteParaNos then
      begin
        try
          with TStringList.Create do
          begin

            if DirectoryExists(Form1.sAtual + '\log\Boletos') = False then
              ForceDirectories(Form1.sAtual + '\log\Boletos');

            Text := FormatDateTime('dd-mm-yyyy HH-nn-ss-zzz', Now) + ' Doc ' + Form7.ibDataSet7DOCUMENTO.AsString + ' ' + E.Message;
            SaveToFile(Form1.sAtual + '\log\Boletos\' + FormatDateTime('dd-mm-yyyy HH-nn-ss-zzz', Now) + '-log-gerando-boleto-' + Form7.ibDataSet7DOCUMENTO.AsString + '.txt');
            Free;

          end;
        except
        end;
      end;
      {Sandro Silva 2022-12-28 fim}
      Result     := False;
    end;
  end;

  {Sandro Silva 2022-12-23 inicio
  if bGravaPortadorNossoNumCodeBar then
  begin
    Form25.GravaPortadorNossoNumCodeBar;
  end;
  {Sandro Silva 2022-12-23 fim}
end;


procedure TForm25.btnAnteriorClick(Sender: TObject);
begin

  Form7.ibDataSet7.MoveBy(-1);

  {Sandro Silva 2023-06-20 inicio
  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet7NOME.AsString)+' ');  //
  Form7.ibDataSet2.Open;
  //
  FormActivate(Sender);
  }
  ValidaEmailPagador;
  Form25.btnCriaImagemBoletoClick(Sender); // Sandro Silva 2022-12-23 Form25.Button2Click(Sender);


end;

procedure TForm25.btnProximoClick(Sender: TObject);
begin
  Form7.ibDataSet7.MoveBy(1);

  {Sandro Silva 2023-06-20 inicio
  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet7NOME.AsString)+' ');  //
  Form7.ibDataSet2.Open;
  //
  FormActivate(Sender);
  }
  ValidaEmailPagador;
  Form25.btnCriaImagemBoletoClick(Sender); // Sandro Silva 2022-12-23 Form25.Button2Click(Sender);

end;

procedure TForm25.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;

  if Key = VK_UP then
  begin
    Perform(Wm_NextDlgCtl,1,0);
  end;

  if Key = VK_DOWN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;

procedure TForm25.btnConfigurarBoletoClick(Sender: TObject);
begin
  Form26.ShowModal;
end;  

procedure TForm25.FormShow(Sender: TObject);
var
  Mais1Ini: TIniFile;
  I: Integer;
begin
  //Mauricio Parizotto 2023-06-16
  if Form1.sBancoBoleto <> '' then
  begin
    try
      sInstituicaoFinanceira := ExecutaComandoEscalar(Form7.ibDataSet7.Transaction.DefaultDatabase,
                                                      ' Select Coalesce(INSTITUICAOFINANCEIRA,'''') From BANCOS '+
                                                      ' Where NOME ='+QuotedStr(Form1.sBancoBoleto));
    except
      sInstituicaoFinanceira := '';
    end;
  end else
  begin
    sInstituicaoFinanceira := '';
  end;

  try
    //Form25.Caption := StrTran(Form1.sEscolhido,'Boleto','Bloqueto'); Mauricio Parizotto 2023-10-02
    Form25.Caption := Form1.sEscolhido;

    for I:= 1 to 65 do vLinha[I]  := ' ';
    for I:= 1 to 20 do vLinha[I]  := ' ';
    for I:= 1 to 20 do vCampo[I]  := ' ';

    if Trim(Form1.sEscolhido) <> '' then // Sandro Silva 2022-12-22 Só entra se o
    begin
      // Carrega as configurações para boleto conforme o portador setado em Form1.sEscolhido
      Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');

      Form26.MaskEdit1.Text  := Mais1Ini.ReadString(Form1.sEscolhido,'L1','1');   //     local de pagamento ---> 1    4
      Form26.MaskEdit2.Text  := Mais1Ini.ReadString(Form1.sEscolhido,'L2','1');   //             vencimento ---> 1   51
      Form26.MaskEdit3.Text  := Mais1Ini.ReadString(Form1.sEscolhido,'L3','5');   //         data documento ---> 5    4
      Form26.MaskEdit4.Text  := Mais1Ini.ReadString(Form1.sEscolhido,'L4','5');   //              documento ---> 5   15
      Form26.MaskEdit5.Text  := Mais1Ini.ReadString(Form1.sEscolhido,'L5','5');   //      espécie documento ---> 5   32
      Form26.MaskEdit6.Text  := Mais1Ini.ReadString(Form1.sEscolhido,'L6','5');   //                 aceite ---> 5   36
      Form26.MaskEdit7.Text  := Mais1Ini.ReadString(Form1.sEscolhido,'L7','5');   //             processado ---> 5   39
      Form26.MaskEdit8.Text  := Mais1Ini.ReadString(Form1.sEscolhido,'L8','6');   //     valor do documento ---> 6   52
      Form26.MaskEdit9.Text  := Mais1Ini.ReadString(Form1.sEscolhido,'L9', '10');  // linha 1 das instruções ---> 10   4
      Form26.MaskEdit10.Text := Mais1Ini.ReadString(Form1.sEscolhido,'L10','11'); // linha 1 das instruções ---> 10   4
      Form26.MaskEdit11.Text := Mais1Ini.ReadString(Form1.sEscolhido,'L11','12'); // linha 1 das instruções ---> 10   4
      Form26.MaskEdit12.Text := Mais1Ini.ReadString(Form1.sEscolhido,'L12','13'); // linha 1 das instruções ---> 10   4
      Form26.MaskEdit13.Text := Mais1Ini.ReadString(Form1.sEscolhido,'L13','14'); // linha 1 das instruções ---> 10   4
      Form26.MaskEdit14.Text := Mais1Ini.ReadString(Form1.sEscolhido,'L14','15'); //         nome do Pagador ---> 15   8
      Form26.MaskEdit15.Text := Mais1Ini.ReadString(Form1.sEscolhido,'L15','16'); //     endereço do Pagador ---> 15   8
      Form26.MaskEdit16.Text := Mais1Ini.ReadString(Form1.sEscolhido,'L16','17'); //             CEP Pagador ---> 15   8
      Form26.MaskEdit17.Text := Mais1Ini.ReadString(Form1.sEscolhido,'L17','17'); //       cidade do Pagador ---> 15   8
      Form26.MaskEdit18.Text := Mais1Ini.ReadString(Form1.sEscolhido,'L18','17'); //       estado do Pagador ---> 15   8
      Form26.MaskEdit19.Text := Mais1Ini.ReadString(Form1.sEscolhido,'L19','15'); //          CGC do Pagador ---> 15   8
      Form26.MaskEdit20.Text := Mais1Ini.ReadString(Form1.sEscolhido,'L20','00'); //          Valor extenso ---> 00   0

      Form26.MaskEdit21.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C1','4');  //     local de pagamento ---> 1    4
      Form26.MaskEdit22.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C2','51'); //             vencimento ---> 1   51
      Form26.MaskEdit23.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C3','04'); //         data documento ---> 5    4
      Form26.MaskEdit24.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C4','15'); //              documento ---> 5   15
      Form26.MaskEdit25.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C5','32'); //      espécie documento ---> 5   32
      Form26.MaskEdit26.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C6','36'); //                 aceite ---> 5   36
      Form26.MaskEdit27.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C7','39'); //             processado ---> 5   39
      Form26.MaskEdit28.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C8','52'); //     valor do documento ---> 6   52
      Form26.MaskEdit29.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C9','4');  // linha 1 das instruções ---> 10   4
      Form26.MaskEdit30.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C10','4'); // linha 1 das instruções ---> 10   4
      Form26.MaskEdit31.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C11','4'); // linha 1 das instruções ---> 10   4
      Form26.MaskEdit32.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C12','4'); // linha 1 das instruções ---> 10   4
      Form26.MaskEdit33.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C13','4'); // linha 1 das instruções ---> 10   4
      Form26.MaskEdit34.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C14','8'); //         nome do Pagador ---> 15   8
      Form26.MaskEdit35.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C15','8'); //     endereço do Pagador ---> 15   8
      Form26.MaskEdit36.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C16','8'); //             CEP Pagador ---> 15   8
      Form26.MaskEdit37.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C17','18'); //       cidade do Pagador ---> 15   8
      Form26.MaskEdit38.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C18','50'); //       estado do Pagador ---> 15   8
      Form26.MaskEdit39.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C19','50'); //          CGC do Pagador ---> 15   8
      Form26.MaskEdit40.Text := Mais1Ini.ReadString(Form1.sEscolhido,'C20','0'); //          Valor extenso ---> 00   0
      Form26.MaskEdit41.Text := Mais1Ini.ReadString(Form1.sEscolhido,'Altura','24');   //  tamanho da página ---> 24

      Form26.MaskEdit400.Text := AllTrim(Mais1Ini.ReadString(Form1.sEscolhido,'Tamanho do valor por extenso','00')); // Valor extenso ---> 00   0

      Form26.MaskEdit51.Text  := Mais1Ini.ReadString(Form1.sEscolhido,'Repetir a 2 coluna em','00');  //     Repetir a 2 coluna em

      Edit1.Text := Mais1Ini.ReadString(Form1.sEscolhido,'Local','');      //     local de pagamento ---> 1    4
      Edit2.Text := Mais1Ini.ReadString(Form1.sEscolhido,'Espécie','DM');  //      espécie documento ---> 5   32
      Edit3.Text := Mais1Ini.ReadString(Form1.sEscolhido,'Aceite','');     //                 aceite ---> 5   36

      Edit4.Text := Mais1Ini.ReadString(Form1.sEscolhido,'Instruções1','');  // linha 1 das instruções ---> 10   4
      Edit5.Text := Mais1Ini.ReadString(Form1.sEscolhido,'Instruções2','');  // linha 2 das instruções ---> 10   4
      Edit6.Text := Mais1Ini.ReadString(Form1.sEscolhido,'Instruções3','');  // linha 3 das instruções ---> 10   4
      Edit7.Text := Mais1Ini.ReadString(Form1.sEscolhido,'Instruções4','');  // linha 4 das instruções ---> 10   4

      Form26.MaskEdit42.Text := Mais1Ini.ReadString(Form1.sEscolhido,'Código do banco','');
      Form26.MaskEdit43.Text := Mais1Ini.ReadString(Form1.sEscolhido,'Carteria','');
      Form26.MaskEdit50.Text := Mais1Ini.ReadString(Form1.sEscolhido,'Código do convênio','');
      Form26.MaskEdit44.Text := Mais1Ini.ReadString(Form1.sEscolhido,'Agência','');
      Form26.MaskEdit46.Text := Mais1Ini.ReadString(Form1.sEscolhido,'Conta','');
      Form26.MaskEdit45.Text := Mais1Ini.ReadString(Form1.sEscolhido,'Livre','0000000000000000000000000');

      if Form26.MaskEdit45.Text = 'XXXXXXccccccccNNNNNNNNNKK' then Form26.cboBancos.ItemIndex := Form26.cboBancos.Items.IndexOf('AILOS');
      if Form26.MaskEdit45.Text = '11YY2NNNNNVAAAAAACCCCC10D' then Form26.cboBancos.ItemIndex := Form26.cboBancos.Items.IndexOf('SICREDI');
      if Form26.MaskEdit45.Text = '1aaaa01cccccccnnnnnnnS0PP' then Form26.cboBancos.ItemIndex := Form26.cboBancos.Items.IndexOf('SICOOB');
      if Form26.MaskEdit45.Text = 'CCCCCCC00010004NNNNNNNNND' then Form26.cboBancos.ItemIndex := Form26.cboBancos.Items.IndexOf('Caixa Econômica');
      if Form26.MaskEdit45.Text = '000000xxxxxxxnnnnnnnnnnkk' then Form26.cboBancos.ItemIndex := Form26.cboBancos.Items.IndexOf('Banco do Brasil 7 posições');
      if Form26.MaskEdit45.Text = 'XXXXXXnnnnnaaaa000ccccckk' then Form26.cboBancos.ItemIndex := Form26.cboBancos.Items.IndexOf('Banco do Brasil 6 posições');
      if Form26.MaskEdit45.Text = 'AAAAKKNNNNNNNNNNNCCCCCCC0' then Form26.cboBancos.ItemIndex := Form26.cboBancos.Items.IndexOf('Bradesco');
      if Form26.MaskEdit45.Text = '9ccccccc0000nnnnnnnnd0kkk' then Form26.cboBancos.ItemIndex := Form26.cboBancos.Items.IndexOf('Santander');
      if Form26.MaskEdit45.Text = '21aaaacccccccnnnnnnnn40bb' then Form26.cboBancos.ItemIndex := Form26.cboBancos.Items.IndexOf('Banrisul');
      if Form26.MaskEdit45.Text = 'KKKNNNNNNNNmAAAACCCCCC000' then Form26.cboBancos.ItemIndex := Form26.cboBancos.Items.IndexOf('Itaú');
      if Form26.MaskEdit45.Text = '5???????00NNNNNNNNNNNNNNd' then Form26.cboBancos.ItemIndex := Form26.cboBancos.Items.IndexOf('Unibanco');
      if Form26.MaskEdit45.Text = 'AAAACCCCCCCCCCNNNNNNNNNNN' then Form26.cboBancos.ItemIndex := Form26.cboBancos.Items.IndexOf('Unicred'); //Mauricio Parizotto 202-12-07

      if Mais1Ini.ReadString(Form1.sEscolhido,'CNAB400','') = 'Sim' then
        Form26.chkCNAB400.State := cbChecked
      else
        Form26.chkCNAB400.State := cbUnchecked;

      if Mais1Ini.ReadString(Form1.sEscolhido,'CNAB240','') = 'Sim' then
        Form26.chkCNAB240.State := cbChecked
      else
        Form26.chkCNAB240.State := cbUnchecked;

      // Data atualizada com juros de mora
      if Mais1Ini.ReadString(Form1.sEscolhido,'Mora','Não') = 'Sim' then
      begin
        Form25.chkDataAtualizadaJurosMora.Checked := True; // Sandro Silva 2022-12-28 Form25.CheckBox1.Checked := True;
      end else
      begin
        Form25.chkDataAtualizadaJurosMora.Checked := False; // Sandro Silva 2022-12-28 Form25.CheckBox1.Checked := False;
      end;


      //Mauricio Parizotto 2023-10-02
      sTipoMulta := Mais1Ini.ReadString('Outros','Tipo multa','Percentual');
      vMulta := Mais1Ini.ReadFloat('Outros','Multa',0);

      Mais1Ini.Free;
    end;
  except

  end;

  if btnImprimirTodos.CanFocus then // Sandro Silva 2022-12-23 if Button4.CanFocus then
    btnImprimirTodos.SetFocus; // Sandro Silva 2022-12-23 Button4.SetFocus;
end;

procedure TForm25.FormActivate(Sender: TObject);
{Sandro Silva 2023-06-20 inicio
var
  sEmail : String;
begin
  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet7NOME.AsString)+' ');  //
  Form7.ibDataSet2.Open;

  sEmail := Form7.ibDataSet2EMAIL.AsString; // XML POR EMAIL

  if validaEmail(sEmail) then
  begin
    btnEnviaEmail.Visible := True; // Sandro Silva 2022-12-23 Button7.Visible := True;
  end else
  begin
    btnEnviaEmail.Visible := False; // Sandro Silva 2022-12-23 Button7.Visible := False;
  end;
  //
}
begin
  ValidaEmailPagador;
  Form25.btnCriaImagemBoletoClick(Sender); // Sandro Silva 2022-12-23 Form25.Button2Click(Sender);
end;

procedure TForm25.btnImprimirClick(Sender: TObject);
begin
  if not Form25.PrintDialog1.Execute then
    Exit;
  ImprimirBoleto;
end;

procedure TForm25.btnImprimirTodosClick(Sender: TObject);
begin
  try
    bOk := True; // No caso de um Except

    Form7.ibDataSet7.First;

    begin
      if (LimpaNumero(Form26.MaskEdit42.Text) = '') then
      begin
        bOk := False;
        //ShowMessage('Configure o código do banco.'); Mauricio Parizotto 2023-10-25
        MensagemSistema('Configure o código do banco.');
      end;
    end;

    try
      if not Form25.PrintDialog1.Execute then
        Exit;
      while (not Form7.ibDataSet7.EOF) and (bOk) do
      begin
        //
        {Sandro Silva 2023-06-20 inicio
        Form25.btnImprimirClick(Sender);// Sandro Silva 2022-12-23 Form25.Button6Click(Sender);
        Form25.btnProximoClick(Sender); // Form7.ibDataSet7.Next; // Sandro Silva 2022-12-23 Form25.Button1Click(Sender); // Form7.ibDataSet7.Next;
        }
        if FormaDePagamentoGeraBoleto(Form7.ibDataSet7FORMADEPAGAMENTO.AsString) then
        begin
          ImprimirBoleto; // Sandro Silva 2023-06-20 Form25.btnImprimirClick(Sender);// Sandro Silva 2022-12-23 Form25.Button6Click(Sender);
          //Form25.btnProximoClick(Sender);
          ValidaEmailPagador;
          Form25.btnCriaImagemBoletoClick(Sender); // Sandro Silva 2022-12-23 Form25.Button2Click(Sender);
        end;
        Form7.ibDataSet7.Next;
        {Sandro Silva 2023-06-20 fim}
      end;
    except
      //ShowMessage('Erro na impressão do boleto.'); Mauricio Parizotto 2023-10-25
      MensagemSistema('Erro na impressão do boleto.',msgErro);
    end;
  except
  end;
end;

procedure TForm25.btnCriaImagemBoletoClick(Sender: TObject);
begin
  Form25.Tag := 1; // Para saber se é impressão em PDF
  GeraImagemDoBoletoComOCodigoDeBarras(False);
  Form25.Tag := 0; // Para saber se é impressão é na impressora
  CriaBoletoJPG('boleto_'+AllTrim(Form7.ibDataSet7DOCUMENTO.AsString)+'.jpg');
end;

procedure TForm25.btnEnviaEmailClick(Sender: TObject);
var
  sEmail : String;
//  PDF: TPrintPDF;
  PDF :TPdfDocumentGDI;
  PAGE : TPdfPage;
begin
  sEmail := Form7.ibDataSet2EMAIL.AsString; // XML POR EMAIL

  if validaEmail(sEmail) then
  begin
    if (UpperCase(Copy(AllTrim(Form7.ibDataSet7PORTADOR.AsString),1,7)) <> 'BANCO (') or (Pos('('+Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+')',Form7.ibDataSet7PORTADOR.AsString)<>0) then
    begin
      // Apaga o PDF anterior
      while FileExists(Form1.sAtual+'\boleto_'+AllTrim(Form7.ibDataSet7DOCUMENTO.AsString)+'.pdf') do
      begin
        DeleteFile(Form1.sAtual+'\boleto_'+AllTrim(Form7.ibDataSet7DOCUMENTO.AsString)+'.pdf');
        sleep(1000);
      end;

      // Cria o PDF

      {Mauricio Parizotto 2024-02-15 Inicio
      PDF := TPrintPDF.Create(Self);

      // Configurações do documento
      PDF.TITLE       := 'Boletos';
      PDF.Creator     := 'Small Commerce';
      PDF.Author      := 'Small Commerce';
      PDF.Keywords    := 'Small Commerce';
      PDF.Producer    := 'Small Commerce';
      PDF.Subject     := 'Boletos de cobrança';
      PDF.JPEGQuality := 100;
      PDF.Compress    := False;

      // Tamanho do A4 21,0 cm x 29,7 cm
      PDF.PageWidth   :=  735;
      PDF.PageHeight  :=  1039;

      // Nome do arquivo para salvar
      PDF.FileName    := Form1.sAtual+'\boleto_'+AllTrim(Form7.ibDataSet7DOCUMENTO.AsString)+'.pdf';// sFileCFeSAT;

      // Inicia o documento pdf
      PDF.BeginDoc;

      PDF.DrawJPEG(0, 0, Form25.Image2.Picture.Bitmap);

      // PDF.DrawBitmap(0,0, Form25.Image2.Picture.Bitmap);
      PDF.EndDoc;
      }

      try
        PDF:=TPdfDocumentGDI.Create();
        PDF.Info.Author       := 'Small';
        PDF.Info.Creator      := 'Small';
        PDF.Info.Title        := 'Boletos';
        PDF.Info.Subject      := 'Boletos de cobrança';
        PDF.Info.CreationDate := now;
        PDF.DefaultPaperSize := psA4; //Tamanho A4
        PDF.ForceJPEGCompression := 0;

        PAGE := pdf.AddPage;
        PAGE.PageLandscape := False;

        PDF.VCLCanvas.Draw(0,0,Form25.Image2.Picture.Graphic);

        PDF.SaveToFile(Form1.sAtual+'\boleto_'+AllTrim(Form7.ibDataSet7DOCUMENTO.AsString)+'.pdf');
      finally
        FreeAndNil(PDF);
      end;

      {Mauricio Parizotto 2024-02-15 Fim}


      // Fecha o documento pdf
      if FileExists(Form1.sAtual+'\boleto_'+AllTrim(Form7.ibDataSet7DOCUMENTO.AsString)+'.pdf') then
      begin
        if UpperCase(Copy(AllTrim(Form7.ibDataSet7PORTADOR.AsString),1,7)) <> 'BANCO (' then
        begin
          try
            GravaPortadorNossoNumCodeBar;
          except
          end;
        end;

        Unit7.EnviarEMail('',sEmail,'','Boleto','Boleto',pChar(Form1.sAtual+'\boleto_'+AllTrim(Form7.ibDataSet7DOCUMENTO.AsString)+'.pdf'), False);
      end;
    end else
    begin
      MensagemSistema('Não é possível imprimir este boleto.'+chr(10)+'Esta conta já foi enviada para o '+Form7.ibDataSet7PORTADOR.AsString
                      +chr(10)+chr(10)+'Para enviar para outro banco clique ao contrário sobre a conta e no menu clique em "Baixar esta conta no banco".'
                      +chr(10)+'Em seguida gere o arquivo de remessa e envie para o banco.'
                      ,msgAtencao);

    end;
  end;
end;

procedure TForm25.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Mais1Ini: TIniFile;
begin
  try
    Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');

    Mais1Ini.WriteString(Form1.sEscolhido,'Local',AllTrim(Edit1.Text));    //     local de pagamento ---> 1    4
    Mais1Ini.WriteString(Form1.sEscolhido,'Espécie',AllTrim(Edit2.Text));                 //      espécie documento ---> 5   32
    Mais1Ini.WriteString(Form1.sEscolhido,'Aceite',AllTrim(Edit3.Text));   //                 aceite ---> 5   36

    Mais1Ini.WriteString(Form1.sEscolhido,'Instruções1',AllTrim(Edit4.Text));  // linha 1 das instruções ---> 10   4
    Mais1Ini.WriteString(Form1.sEscolhido,'Instruções2',AllTrim(Edit5.Text));  // linha 2 das instruções ---> 10   4
    Mais1Ini.WriteString(Form1.sEscolhido,'Instruções3',AllTrim(Edit6.Text));  // linha 3 das instruções ---> 10   4
    Mais1Ini.WriteString(Form1.sEscolhido,'Instruções4',AllTrim(Edit7.Text));  // linha 4 das instruções ---> 10   4
    
    Mais1Ini.WriteString(Form1.sEscolhido,'Código do banco',AllTrim(Form26.MaskEdit42.Text));  //     Repetir a 2 coluna em

    Mais1Ini.WriteString(Form1.sEscolhido,'Carteria',AllTrim(Form26.MaskEdit43.Text));  //     Repetir a 2 coluna em
    Mais1Ini.WriteString(Form1.sEscolhido,'Código do convênio',AllTrim(Form26.MaskEdit50.Text));  //     Repetir a 2 coluna em

    Mais1Ini.WriteString(Form1.sEscolhido,'Agência',AllTrim(Form26.MaskEdit44.Text));  //     Repetir a 2 coluna em
    Mais1Ini.WriteString(Form1.sEscolhido,'Conta',AllTrim(Form26.MaskEdit46.Text));  //     Repetir a 2 coluna em
    Mais1Ini.WriteString(Form1.sEscolhido,'Livre',AllTrim(Form26.MaskEdit45.Text));  //     Campo livre
    Mais1Ini.WriteString(Form1.sEscolhido,'Mora','Não');

    if Form26.chkCNAB400.State = cbChecked then
      Mais1Ini.WriteString(Form1.sEscolhido,'CNAB400','Sim')
    else
      Mais1Ini.WriteString(Form1.sEscolhido,'CNAB400','Não');
    if Form26.chkCNAB240.State = cbChecked then
      Mais1Ini.WriteString(Form1.sEscolhido,'CNAB240','Sim')
    else
      Mais1Ini.WriteString(Form1.sEscolhido,'CNAB240','Não');

    // Data atualizada com juros de mora
    if (chkDataAtualizadaJurosMora.Checked) then // Sandro Silva 2022-12-28 if (CheckBox1.Checked) then
    begin
      Mais1Ini.WriteString(Form1.sEscolhido,'Mora','Sim');
    end else
    begin
      Mais1Ini.WriteString(Form1.sEscolhido,'Mora','Não');
    end;

    Mais1Ini.Free;
  except
  end;
end;

procedure TForm25.chkDataAtualizadaJurosMoraClick(Sender: TObject);
begin
  Form25.btnCriaImagemBoletoClick(Sender); // Sandro Silva 2022-12-23 Form25.Button2Click(Sender);
end;

procedure TForm25.btnEnviaEmailTodosClick(Sender: TObject);
var
  sArquivo: String;
  sEmail : String;
//  PDF: TPrintPDF;
  YY : Integer;
  PDF :TPdfDocumentGDI;
  PAGE : TPdfPage;
begin
  sEmail := Form7.ibDataSet2EMAIL.AsString; // XML POR EMAIL

  if validaEmail(sEmail) then
  begin
    // Apaga o PDF anterior
    sArquivo := Copy(AllTrim(Form7.ibDataSet7DOCUMENTO.AsString)+'XXXXXXXXX',1,9)+'_.pdf';

    while FileExists(Form1.sAtual+'\'+sArquivo) do
    begin
      DeleteFile(Form1.sAtual+'\'+sArquivo);
      sleep(1000);
    end;

    // Cria o PDF
    {
    PDF := TPrintPDF.Create(Self);

    // Configurações do documento
    PDF.TITLE       := 'Boletos'+StrTran(StrTran(sArquivo,'/',''),'.','');
    PDF.Creator     := 'Small';
    PDF.Author      := 'Small';
    PDF.Keywords    := 'Small';
    PDF.Producer    := 'Small';
    PDF.Subject     := 'Boletos de cobrança';
    PDF.JPEGQuality := 100;
    PDF.Compress    := False;

    // Tamanho do A4 21,0 cm x 29,7 cm
    PDF.PageWidth   :=  735;
    PDF.PageHeight  :=  1039;

    // Nome do arquivo para salvar
    PDF.FileName    := sArquivo;

    // Inicia o documento pdf
    PDF.BeginDoc;
    }

    try
      PDF:=TPdfDocumentGDI.Create();
      PDF.Info.Author       := 'Small';
      PDF.Info.Creator      := 'Small';
      PDF.Info.Title        := 'Boletos';
      PDF.Info.Subject      := 'Boletos de cobrança';
      PDF.Info.CreationDate := now;
      PDF.DefaultPaperSize := psA4; //Tamanho A4
      PDF.ForceJPEGCompression := 0;


      YY := 0;
      //
      Form7.ibDataSet7.First;
      while not Form7.ibDataSet7.Eof do
      begin
        if Form7.ibDataSet7NOME.AsString = Form7.ibDataSet2NOME.AsString then
        begin
          if Form7.ibDataSet7VALOR_RECE.AsFloat = 0 then
          begin
            while FileExists(Form1.sAtual+'\boleto_'+AllTrim(Form7.ibDataSet7DOCUMENTO.AsString)+'.jpg') do
            begin
              DeleteFile(pChar(Form1.sAtual+'\boleto_'+AllTrim(Form7.ibDataSet7DOCUMENTO.AsString)+'.jpg'));
              sleep(1000);
            end;

            Form25.Show;
            Form25.btnCriaImagemBoletoClick(Sender);

            //while not FileExists(Form1.sAtual+'\boleto_'+AllTrim(Form7.ibDataSet7DOCUMENTO.AsString)+'.jpg') do
            begin
              Sleep(1000);
            end;

            // Print Image
            YY := YY + 1;
//            if YY >= 2 then
  //            PDF.NewPage; // Add New Page

  //          PDF.DrawJPEG(0, 0, Form25.Image2.Picture.Bitmap);

            PAGE := pdf.AddPage;
            PAGE.PageLandscape := False;

            PDF.VCLCanvas.Draw(0,0,Form25.Image2.Picture.Graphic);
          end;
        end;

        if UpperCase(Copy(AllTrim(Form7.ibDataSet7PORTADOR.AsString),1,7)) <> 'BANCO (' then
        begin
          GravaPortadorNossoNumCodeBar;
        end;

        Screen.Cursor            := crHourGlass;

        Form25.btnProximoClick(Sender); // Form7.ibDataSet7.Next; // Sandro Silva 2022-12-23 Form25.Button1Click(Sender); // Form7.ibDataSet7.Next;
        Form7.Repaint;
      end;

      //PDF.EndDoc;
      PDF.SaveToFile(Form1.sAtual+'\'+sArquivo);
    finally
      FreeAndNil(PDF);
    end;

    {Mauricio Parizotto 2024-02-15 Fim}

    // Fecha o documento pdf
    if FileExists(Form1.sAtual+'\'+sArquivo) then
    begin
      Unit7.EnviarEMail('',sEmail,'','Boleto','Boleto',pChar(Form1.sAtual+'\'+sArquivo), False);
    end;
  end;

  Screen.Cursor            := crDefault;
end;


procedure TForm25.GravaPortadorNossoNumCodeBar;
begin
  // Precisa estar posicionado no registro certo
  Form7.ibDataSet7.Edit;
  Form7.ibDataSet7PORTADOR.AsString  := 'REMESSA ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')';
  Form7.ibDataSet7NOSSONUM.AsString  := sNossoNum;
  {Mauricio Parizotto 2023-12-07
  Form7.ibDataSet7CODEBAR.AsString   := LimpaNumero(Copy(Form26.MaskEdit42.Text,1,3)+ // Identificação do banco
                                        '9'+                                          // Moeda
                                        Copy(Form25.sNumero,20,1)+                    // Campo Livre 20 a 21 do código de barras
                                        '.'+                                          // Ponto para facilitar a digitação
                                        Copy(Form25.sNumero,21,4)+                    // Campo Livre 21 a 24 do código de barras
                                        Modulo_10(Copy(Form26.MaskEdit42.Text,1,3)+'9'+Copy(Form25.sNumero,20,1)+Copy(Form25.sNumero,21,4))+ // Digito verificador dos 10 primeiros numeros
                                        //
                                        '  '+
                                        Copy(Form25.sNumero,25,5)+                    // Campo Livre 25 a 29 do código de barras
                                        '.'+                                          // Ponto para facilitar a digitação
                                        Copy(Form25.sNumero,30,5)+                    // Campo Livre 30 a 34 do código de barras
                                        Modulo_10(Copy(Form25.sNumero,25,10))+        // Digito verificador
                                        '  '+
                                        Copy(Form25.sNumero,35,5)+                    // Campo Livre 35 a 39 do código de barras
                                        '.'+                                          // Ponto para facilitar a digitação
                                        Copy(Form25.sNumero,40,5)+                    // Campo Livre 40 a 44 do código de barras
                                        Modulo_10(Copy(Form25.sNumero,35,10))+        // Digito verificador
                                        //
                                        '  '+
                                        Copy(Form25.sNumero,5,1)+                     // Dígito de verificação geral posição 5 do codebat
                                        '  '+
                                        Copy(Form25.sNumero,6,4)+                     // 6 a 9 do código de barras - fator de vencimento
                                        Copy(Form25.sNumero,10,10)                  // 10 a 19 do código de barras - valor nominal
                                        );
  }
  Form7.ibDataSet7CODEBAR.AsString := LimpaNumero(GeraCodBarra(Copy(Form26.MaskEdit42.Text,1,3)) );
                                        
  //Mauricio Parizotto 2023-06-16
  if sInstituicaoFinanceira <> '' then
    Form7.ibDataSet7INSTITUICAOFINANCEIRA.AsString   := sInstituicaoFinanceira;

  Form7.ibDataSet7FORMADEPAGAMENTO.AsString := 'Boleto Bancário'; // Sandro Silva 2023-07-13 Form7.ibDataSet7FORMADEPAGAMENTO.AsString := '15-Boleto Bancário';

  {Mauricio Parizotto 2023-10-02 Inicio}
  if sTipoMulta = 'Percentual' then
  begin
    Form7.ibDataSet7PERCENTUAL_MULTA.AsFloat  := vMulta;
    Form7.ibDataSet7VALOR_MULTA.AsString      := '';
  end else
  begin
    Form7.ibDataSet7VALOR_MULTA.AsFloat       := vMulta;
    Form7.ibDataSet7PERCENTUAL_MULTA.AsString := '';
  end;
  {Mauricio Parizotto 2023-10-02 Fim}
    
  Form7.ibDataSet7.Post;
end;

procedure TForm25.ImprimirBoleto;
begin
  if (UpperCase(Copy(AllTrim(Form7.ibDataSet7PORTADOR.AsString),1,7)) <> 'BANCO (') or (Pos('('+Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+')',Form7.ibDataSet7PORTADOR.AsString)<>0) then
  begin
    if GeraImagemDoBoletoComOCodigoDeBarras(True) then
    begin
      if UpperCase(Copy(AllTrim(Form7.ibDataSet7PORTADOR.AsString),1,7)) <> 'BANCO (' then
      begin
        GravaPortadorNossoNumCodeBar;
      end;
    end;
  end else
  begin
    {
    ShowMessage('Não é possível imprimir este boleto.'+chr(10)+'Esta conta já foi enviada para o '+Form7.ibDataSet7PORTADOR.AsString
    +chr(10)+chr(10)+'Para enviar para outro banco clique ao contrário sobre a conta e no menu clique em "Baixar esta conta no banco".'
    +chr(10)+'Em seguida gere o arquivo de remessa e envie para o banco.');
    Mauricio Parizotto 2023-10-25}
    MensagemSistema('Não é possível imprimir este boleto.'+chr(10)+'Esta conta já foi enviada para o '+Form7.ibDataSet7PORTADOR.AsString
                    +chr(10)+chr(10)+'Para enviar para outro banco clique ao contrário sobre a conta e no menu clique em "Baixar esta conta no banco".'
                    +chr(10)+'Em seguida gere o arquivo de remessa e envie para o banco.'
                    ,msgAtencao);
  end;
end;

procedure TForm25.ValidaEmailPagador;
var
  sEmail : String;
begin
  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet7NOME.AsString)+' ');  //
  Form7.ibDataSet2.Open;
  //
  sEmail := Form7.ibDataSet2EMAIL.AsString; // XML POR EMAIL
  //
  if validaEmail(sEmail) then
  begin
    btnEnviaEmail.Visible := True; // Sandro Silva 2022-12-23 Button7.Visible := True;
  end else
  begin
    btnEnviaEmail.Visible := False; // Sandro Silva 2022-12-23 Button7.Visible := False;
  end;
end;

function TForm25.GeraCodBarra(codBanco:string):string;
var
  codBarrasSemDV : string;
  DV : string;
begin
  Result := '';

  try
    Result := Copy(Form26.MaskEdit42.Text,1,3)+ // Identificação do banco
              '9'+                                          // Moeda
              Copy(Form25.sNumero,20,1)+                    // Campo Livre 20 a 21 do código de barras
              Copy(Form25.sNumero,21,4)+                    // Campo Livre 21 a 24 do código de barras
              Modulo_10(Copy(Form26.MaskEdit42.Text,1,3)+'9'+Copy(Form25.sNumero,20,1)+Copy(Form25.sNumero,21,4))+ // Digito verificador dos 10 primeiros numeros
              Copy(Form25.sNumero,25,5)+                    // Campo Livre 25 a 29 do código de barras
              Copy(Form25.sNumero,30,5)+                    // Campo Livre 30 a 34 do código de barras
              Modulo_10(Copy(Form25.sNumero,25,10))+        // Digito verificador
              Copy(Form25.sNumero,35,5)+                    // Campo Livre 35 a 39 do código de barras
              Copy(Form25.sNumero,40,5)+                    // Campo Livre 40 a 44 do código de barras
              Modulo_10(Copy(Form25.sNumero,35,10))+        // Digito verificador
              Copy(Form25.sNumero,5,1)+                     // Dígito de verificação geral posição 5 do codebat
              Copy(Form25.sNumero,6,4)+                     // 6 a 9 do código de barras - fator de vencimento
              Copy(Form25.sNumero,10,10);                   // 10 a 19 do código de barras - valor nominal
  except
  end;
end;

function TForm25.FormataCodBarra(codBarra : string):string;
var
  CodFormatado : string;
begin
  CodFormatado := copy(codBarra,1,5)+'.'+copy(codBarra,6,5)+' '+copy(codBarra,11,5)+'.'+copy(codBarra,16,6)+' '+copy(codBarra,22,5)+'.'+copy(codBarra,27,6)+' '+copy(codBarra,33,1)+' '+copy(codBarra,34,14);
  Result := CodFormatado;
end;

end.







