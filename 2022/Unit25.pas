unit Unit25;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mask, DBCtrls, SMALL_DBEdit, SmallFunc, IniFiles, Printers, ShellApi, jpeg, TnPdf, DB,
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
    btnCNAB240: TBitBtn;
    btnCNAB400: TBitBtn;
    btnCriaImagemBoleto: TBitBtn;
    chkDataAtualizadaJurosMora: TCheckBox;
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
    procedure btnCNAB400Click(Sender: TObject);
    procedure btnCNAB240Click(Sender: TObject);
  private
    { Private declarations }
    bOk : Boolean; // Sandro Silva 2023-06-20
    sInstituicaoFinanceira : string;
    procedure ImprimirBoleto;
    procedure ValidaEmailPagador;
  public
    { Public declarations }
    sNossoNum : String;
    sNumero   : String;
    procedure GravaPortadorNossoNumCodeBar;
  end;

var
// Sandro Silva 2023-06-20  bOk : Boolean;
  Form25: TForm25;
  vCampo:  array [1..20]  of String;    // Cria uma matriz com 20 elementos
  vLinha:  array [1..65]  of STring;    // Linhas

implementation

uses Unit7, Unit26, Mais, Unit22, Unit14, Unit40, uFuncoesBancoDados,
  uFuncoesRetaguarda;

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
    Form26.MaskEdit43.Text := Form26.MaskEdit43.Text + Modulo_11_febraban(LimpaNumero(Form26.MaskEdit43.Text));  // Modulo 11
    Form25.sNumero         := '';

    if Length(Form26.MaskEdit45.Text) <> 25 then
      Form26.MaskEdit45.Text := '0000000000000000000000000';
    
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


    sPortador        := Copy(Form1.sEscolhido+replicate(' ',35),23,35);
    Form25.sNossoNum := '';
    // --------------------------------------------------- //
    // inicio da impressão do Boleto em Código de Barras //
    // --------------------------------------------------- //
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
      //
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

      if Length(LimpaNumero(Form26.MaskEdit42.Text)) = 3 then
      begin
        Impressao.TextOut(largura(-8+58),altura(6+iVia),Copy(Form26.MaskEdit42.Text,1,3));   // Código do banco mais o dígito verificador
      end else
      begin
        Impressao.TextOut(largura(-8-2+58),altura(6+iVia),Form26.MaskEdit42.Text);   // Código do banco mais o dígito verificador
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
                Form25.sNossoNum := (StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit50.Text)),3,0)+StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit47.Text)),5,0)) +'-'+
                  Modulo_Duplo_Digito_Banrisul((StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit50.Text)),3,0)+StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit47.Text)),5,0)));
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

      {
      if Form26.MaskEdit45.Text = '11YY2NNNNNVAAAAAACCCCC10D' then Form26.cboBancos.Text := 'SICREDI - Com registro';
      if Form26.MaskEdit45.Text = '1aaaa02cccccccnnnnnnnS0PP' then Form26.cboBancos.Text := 'SICOOB - Sem registro';
      if Form26.MaskEdit45.Text = '1aaaa01cccccccnnnnnnnS0PP' then Form26.cboBancos.Text := 'SICOOB - Com registro';
      if Form26.MaskEdit45.Text = 'CCCCCCC00010004NNNNNNNNND' then Form26.cboBancos.Text := 'Caixa Econômica - Com registro';
      if Form26.MaskEdit45.Text = 'CCCCCCC00020004NNNNNNNNND' then Form26.cboBancos.Text := 'Caixa Econômica - Sem registro';
      if Form26.MaskEdit45.Text = '000000xxxxxxxnnnnnnnnnnkk' then Form26.cboBancos.Text := 'Banco do Brasil - Com registro 7 posições';
      if Form26.MaskEdit45.Text = 'XXXXXXnnnnnaaaa000ccccckk' then Form26.cboBancos.Text := 'Banco do Brasil - Com registro 6 posições';
      if Form26.MaskEdit45.Text = 'xxxxxxnnnnnnnnnnnnnnnnnkk' then Form26.cboBancos.Text := 'Banco do Brasil - Sem registro';
      if Form26.MaskEdit45.Text = 'AAAAKKNNNNNNNNNNNCCCCCCC0' then Form26.cboBancos.Text := 'Bradesco - Com registro';
      if Form26.MaskEdit45.Text = '9ccccccc0000nnnnnnnnd0kkk' then Form26.cboBancos.Text := 'Santander - Com registro';
      if Form26.MaskEdit45.Text = '21aaaacccccccnnnnnnnn40YY' then Form26.cboBancos.Text := 'Banrisul - Com registro';
      if Form26.MaskEdit45.Text = 'KKKNNNNNNNNmAAAACCCCCC000' then Form26.cboBancos.Text := 'Itaú - Com registro';
      if Form26.MaskEdit45.Text = '5???????00NNNNNNNNNNNNNNd' then Form26.cboBancos.Text := 'Unibanco';
      Mauricio Parizotto 2023-10-02}

      if Form26.MaskEdit45.Text = 'XXXXXXccccccccNNNNNNNNNKK' then Form26.cboBancos.Text := 'AILOS';
      if Form26.MaskEdit45.Text = '11YY2NNNNNVAAAAAACCCCC10D' then Form26.cboBancos.Text := 'SICREDI';
      if Form26.MaskEdit45.Text = '1aaaa01cccccccnnnnnnnS0PP' then Form26.cboBancos.Text := 'SICOOB';
      if Form26.MaskEdit45.Text = 'CCCCCCC00010004NNNNNNNNND' then Form26.cboBancos.Text := 'Caixa Econômica';
      if Form26.MaskEdit45.Text = '000000xxxxxxxnnnnnnnnnnkk' then Form26.cboBancos.Text := 'Banco do Brasil 7 posições';
      if Form26.MaskEdit45.Text = 'XXXXXXnnnnnaaaa000ccccckk' then Form26.cboBancos.Text := 'Banco do Brasil 6 posições';
      if Form26.MaskEdit45.Text = 'AAAAKKNNNNNNNNNNNCCCCCCC0' then Form26.cboBancos.Text := 'Bradesco';
      if Form26.MaskEdit45.Text = '9ccccccc0000nnnnnnnnd0kkk' then Form26.cboBancos.Text := 'Santander';
      if Form26.MaskEdit45.Text = '21aaaacccccccnnnnnnnn40YY' then Form26.cboBancos.Text := 'Banrisul';
      if Form26.MaskEdit45.Text = 'KKKNNNNNNNNmAAAACCCCCC000' then Form26.cboBancos.Text := 'Itaú';
      if Form26.MaskEdit45.Text = '5???????00NNNNNNNNNNNNNNd' then Form26.cboBancos.Text := 'Unibanco';

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
  {Sandro Silva 2023-06-20 inicio
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
    ShowMessage('Não é possível imprimir este bloqueto.'+chr(10)+'Esta conta já foi enviada para o '+Form7.ibDataSet7PORTADOR.AsString
    +chr(10)+chr(10)+'Para enviar para outro banco clique ao contrário sobre a conta e no menu clique em "Baixar esta conta no banco".'
    +chr(10)+'Em seguida gere o arquivo de remessa e envie para o banco.');
  end;
  }
  ImprimirBoleto;
  {Sandro Silva 2023-06-20 fim}
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
        ShowMessage('Configure o código do banco.');
      end;
    end;

    try
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

//        if Form7.ibDataSet7.Eof then Form25.Close;
        //
      end;
    except
      ShowMessage('Erro na impressão do boleto.');
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
  PDF: TPrintPDF;
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
      // Sandro Silva 2022-12-22 sDocParaGerarPDF := Copy(AllTrim(Form7.ibDataSet7DOCUMENTO.AsString)+'XXXXXXXXX',1,9);
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
      //ShowMessage('Não é possível imprimir este bloqueto.'+chr(10)+'Esta conta já foi enviada para o '+Form7.ibDataSet7PORTADOR.AsString Mauricio Parizotto 2023-10-02
      ShowMessage('Não é possível imprimir este boleto.'+chr(10)+'Esta conta já foi enviada para o '+Form7.ibDataSet7PORTADOR.AsString
      +chr(10)+chr(10)+'Para enviar para outro banco clique ao contrário sobre a conta e no menu clique em "Baixar esta conta no banco".'
      +chr(10)+'Em seguida gere o arquivo de remessa e envie para o banco.');
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
  PDF: TPrintPDF;
  YY : Integer;
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
    // Sandro Silva 2022-12-22 sDocParaGerarPDF := Copy(AllTrim(Form7.ibDataSet7DOCUMENTO.AsString)+'XXXXXXXXX',1,9);
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
          Form25.btnCriaImagemBoletoClick(Sender); // Sandro Silva 2022-12-23 Form25.Button2Click(Sender);

          while not FileExists(Form1.sAtual+'\boleto_'+AllTrim(Form7.ibDataSet7DOCUMENTO.AsString)+'.jpg') do
          begin
            Sleep(1000);
          end;

          // Print Image
          YY := YY + 1;
          if YY >= 2 then PDF.NewPage; // Add New Page

          PDF.DrawJPEG(0, 0, Form25.Image2.Picture.Bitmap);
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

    // PDF.DrawBitmap(0,0, Form25.Image2.Picture.Bitmap);
    PDF.EndDoc;

    // Fecha o documento pdf
    if FileExists(Form1.sAtual+'\'+sArquivo) then
    begin
      Unit7.EnviarEMail('',sEmail,'','Boleto','Boleto',pChar(Form1.sAtual+'\'+sArquivo), False);
    end;
  end;

  Screen.Cursor            := crDefault;
end;

procedure TForm25.btnCNAB400Click(Sender: TObject);
var
  vTotal : Real;
  I : Integer;
  F: TextFile;
  sCodigoDaCarteira, sComandoMovimento, sIdoComplemento, sIdentificacaoBanco, sParcela, sCPFOuCNPJ, sCPFOuCNPJ_EMITENTE: String;
  iReg, iRemessa : Integer;
begin
  try
    if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '756' then // SICOOB
    begin
      sIdentificacaoBanco := '756BANCOOBCED';
    end else
    begin
      if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '001' then // BANCO DO BRASIL
      begin
        sIdentificacaoBanco := '001BANCODOBRASIL';
      end else
      begin
        if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '104' then // CAIXA
        begin
          sIdentificacaoBanco := '104C ECON FEDERAL';
        end else
        begin
          if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '237' then // BRADESCO
          begin
            sIdentificacaoBanco := '237BRADESCO';
          end else
          begin
            if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '353' then // SANTANDER
            begin
              sIdentificacaoBanco := '353SANTANDER';
            end else
            begin
              if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '033' then // SANTANDER
              begin
                sIdentificacaoBanco := '033SANTANDER';
              end else
              begin
                if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '041' then // Banrisul
                begin
                  sIdentificacaoBanco := '041BANRISUL';
                end else
                begin
                  sIdentificacaoBanco := Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+'          ';
                end;
              end;
            end;
          end;
        end;
      end;
    end;

    try
      ForceDirectories(pchar(Form1.sAtual + '\remessa'));
    except end;

    if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '237' then // BRADESCO
    begin
      Form1.sArquivoRemessa := '';

      for I := 0 to 99 do
      begin
        if Form1.sArquivoRemessa = '' then
        begin
          if not FileExists(Form1.sAtual+'\remessa\'+'CB'+Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+StrZero(I,2,0)+'.rem') then
          begin
            Form1.sArquivoRemessa := 'CB'+Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+StrZero(I,2,0)+'.rem';
          end;
        end;
      end;
    end else
    begin
      Form1.sArquivoRemessa := Copy(StrTran(DateToStr(Date),'/','_')+DiaDaSemana(Date)+replicate('_',10),1,14)+StrTran(TimeToStr(Time),':','_')+'.txt';
    end;

    AssignFile(F,Form1.sAtual+'\remessa\'+Form1.sArquivoRemessa);
    Rewrite(F);   // Abre para gravação

    // Criar um generator para cada banco
    try
      try
        Form7.ibDataset99.Close;
        Form7.ibDataset99.SelectSql.Clear;
        Form7.ibDataset99.SelectSql.Add('select gen_id(G_'+Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+',1) from rdb$database');
        Form7.ibDataset99.Open;

        iRemessa := StrToInt(Form7.ibDataset99.FieldByname('GEN_ID').AsString);
      except
        try
          Form7.ibDataset99.Close;
          Form7.ibDataset99.SelectSql.Clear;
          Form7.ibDataset99.SelectSql.Add('create generator G_'+Copy(AllTrim(Form26.MaskEdit42.Text),1,3));
          Form7.ibDataset99.Open;
          
          Form7.ibDataset99.Close;
          Form7.ibDataset99.SelectSql.Clear;
          Form7.ibDataset99.SelectSql.Add('set generator G_'+Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+' to 1');
          Form7.ibDataset99.Open;

        except end;

        iRemessa := 1;
      end;
    except
      iRemessa := 1
    end;

    try
      if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '756' then
      begin
        // SICOOB HEADER
        WriteLn(F,
          Copy('0',1,001)                                                                           + // 001 ok Identificação do Registro Header: “0” (zero)
          Copy('1',1,001)                                                                           + // 002 ok Tipo de Operação: “1” (um)
          Copy('REMESSA',1,007)                                                                     + // 003 ok Identificação por Extenso do Tipo de Operação: "REMESSA"
          Copy('01',1,002)                                                                          + // 004 ok Identificação do Tipo de Serviço: “01” (um)
          Copy('COBRANÇA',1,008)                                                                    + // 005 ok Identificação por Extenso do Tipo de Serviço: “COBRANÇA”
          Copy(Replicate(' ',7),1,007)                                                              + // 006 ok Complemento do Registro: Brancos
          Copy(Copy(Form26.MaskEdit44.Text+'    ',1,4),1,004)                                       + // 007 Ok Prefixo da Cooperativa: vide planilha "Capa" deste arquivo
          Copy(Copy(Form26.MaskEdit44.Text+'    ',5,1),1,001)                                       + // 008 Ok Dígito Verificador do Prefixo: vide planilha "Capa" deste arquivo
          Copy(Right('000000000'+LimpaNumero(Form26.MaskEdit46.Text),9),1,8)                        + // 009 Ok Código do Cliente/Beneficiário: vide planilha "Capa" deste arquivo
          Copy(Right('000000000'+LimpaNumero(Form26.MaskEdit46.Text),9),9,1)                        + // 010 Ok Dígito Verificador do Código: vide planilha "Capa" deste arquivo
          Right('000000'+LimpaNumero(Form26.MaskEdit50.Text),6)                                     + // 011 Ok Número do convênio líder: Brancos
          Copy(UpperCase(Form7.IbDataSet13NOME.AsString)+Replicate(' ',30),1,030)                   + // 012 Ok Nome do Beneficiário: vide planilha "Capa" deste arquivo
          Copy(sIdentificacaoBanco+Replicate(' ',18),1,018)                                         + // 013 Ok Identificação do Banco: "756BANCOOBCED"
          Copy(Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),9,2),1,006) + // 014 ok Data da Gravação da Remessa: formato ddmmaa
          Copy(StrZero(iRemessa,7,0),1,007)                                                         + // 015 ok Seqüencial da Remessa: número seqüencial acrescido de 1 a cada remessa. Inicia com "0000001"
          Copy(Replicate(' ',287),1,287)                                                            + // 016 ok Complemento do Registro: Brancos
          Copy('000001',1,006)                                                                      + // 017 ok Seqüencial do Registro:”000001”
          ''
          );
      end else
      begin
        if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '104' then // CAIXA
        begin
          // CAIXA HEADER
          WriteLn(F,
            Copy('0',1,001)                                                                           + // 01- 001 a 001 9(001) Identificação do Registro Header: “0” (zero)
            Copy('1',1,001)                                                                           + // 02- 002 a 002 9(001) Tipo de Operação: “1” (um)
            Copy('REMESSA',1,007)                                                                     + // 03- 003 a 009 X(007) Identificação por Extenso do Tipo de Operação 01
            Copy('01',1,002)                                                                          + // 04- 010 a 011 9(002) Identificação do Tipo de Serviço: “01”
            Copy('COBRANCA',1,008)                                                                    + // 05- 012 a 019 X(008) Identificação por Extenso do Tipo de Serviço: “COBRANCA”
            Copy(Replicate(' ',7),1,007)                                                              + // 06- 020 a 026 X(007) Complemento do Registro: “Brancos”
            Copy(LimpaNumero(Form26.MaskEdit44.Text)+'    ',1,004)                                    + // 07- 027 a 030 X(004) Código da agencia
            Copy(LimpaNumero(Form26.MaskEdit46.Text)+'      ',1,006)                                  + // 08- 031 a 036 X(006) cod. Beneficiário
            Copy(Replicate(' ',10),1,10)                                                              + //
            Copy(UpperCase(Form7.IbDataSet13NOME.AsString)+Replicate(' ',30),1,030)                   + // 10- 047 a 076 X(030) Nome do Cedente
            Copy(sIdentificacaoBanco+Replicate(' ',18),1,018)                                         + // 11- 077 a 094 X(018)
            Copy(Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),9,2),1,006) + // 12- 095 a 100 9(006) Data da Gravação: Informe no formato “DDMMAA” 21
            Copy(Replicate(' ',289),1,289)                                                            + // 13- 101 a 389 Brancos
            Copy(StrZero(iRemessa,5,0),1,005)                                                         + // 14- 390 a 394 9(005) Seqüencial da Remessa 03
            Copy('000001',1,006)                                                                      + // 15- 395 a 400 9(006) Seqüencial do Registro:”000001”
            ''
            );
        end else
        begin
          if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '237' then // BRADESCO
          begin
            // BRADESCO
            WriteLn(F,
              Copy('0',1,001)                                                                           + // 01 - 001 a 001 - 9(001) Identificação do Registro (0)
              Copy('1',1,001)                                                                           + // 02 - 002 a 002 - 9(001) Identificação do Arquivo Remessa (1)
              Copy('REMESSA',1,007)                                                                     + // 03 - 003 a 009 - X(007) Literal Remessa (REMESSA)
              Copy('01',1,002)                                                                          + // 04 - 010 a 011 - 9(002) Código de Serviço (01)
              Copy('COBRANCA       ',1,015)                                                             + // 05 - 012 a 026 - X(015) Literal Serviço (COBRANCA)
              Copy(Right(Replicate('0',20)+LimpaNumero(Form26.MaskEdit50.Text),20),1,020)               + // 06 - 027 a 046 - 9(020) Código da Empresa (Será fornecido pelo Bradesco, quando do Cadastramento)
              Copy(UpperCase(ConverteAcentosPHP(Form7.IbDataSet13NOME.AsString))+Replicate(' ',30),1,030)  + // 07 - 047 a 076 - X(030) Nome da Empresa (Razão Social)
              Copy('237',1,003)                                                                         + // 08 - 077 a 079 - 9(003) Número do Bradesco na Câmara de Compensação (237)
              Copy('BRADESCO       ',1,015)                                                             + // 09 - 080 a 094 - X(015) Nome do Banco por Extenso (Bradesco)
              Copy(Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),9,2),1,006) + // 10 - 095 a 100 - 9(006) Data da Gravação do Arquivo (DDMMAA)
              Copy('        ',1,8)                                                                      + // 11 - 101 a 108 - X(008) Branco (Branco)
              Copy('MX',1,2)                                                                            + // 12 - 109 a 110 - X(002) Identificação do sistema (MX)
              Copy(StrZero(iRemessa,7,0),1,007)                                                         + // 13 - 111 a 117 - 9(007) Nº Seqüencial de Remessa (Seqüencial)
              Copy(Replicate(' ',277),1,277)                                                            + // 14 - 118 a 394 - X(277) Branco (Branco)
              Copy('000001',1,006)                                                                      + // 15 - 395 a 400 - 9(006) Nº Seqüencial do Registro de Um em Um (000001)
              ''
              );
          end else
          begin
            // ITAÚ HEADER ITAU
            if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '341' then // Itaú ITAU
            begin
              WriteLn(F,
                Copy('0',1,001)                                                                           + // 001 a 001 - 9(001) TIPO DE REGISTRO    - IDENTIFICAÇÃO DO REGISTRO HEADER             - 0
                Copy('1',1,001)                                                                           + // 002 a 002 - 9(001) OPERAÇÃO            - TIPO DE OPERAÇÃO - REMESSA                   - 1
                Copy('REMESSA',1,007)                                                                     + // 003 a 009 - X(007) LITERAL DE REMESSA  - IDENTIFICAÇÃO POR EXTENSO DO MOVIMENTO       - REMESSA
                Copy('01',1,002)                                                                          + // 010 a 011 - 9(002) CÓDIGO DO SERVIÇO   - IDENTIFICAÇÃO DO TIPO DE SERVIÇO             - 01
                Copy('COBRANCA       ',1,015)                                                             + // 012 a 026 - X(015) LITERAL DE SERVIÇO  - IDENTIFICAÇÃO POR EXTENSO DO TIPO DE SERVIÇO - COBRANCA
                Copy(LimpaNumero(Form26.MaskEdit44.Text)+'    ',1,004)                                    + // 027 a 030 - 9(004) AGÊNCIA             - AGÊNCIA MANTENEDORA DA CONTA                 -
                Copy('00',1,002)                                                                          + // 031 a 032 - 9(002) ZEROS               - COMPLEMENTO DE REGISTRO                      - 00
                Copy(LimpaNumero(Form26.MaskEdit46.Text)+'00000',1,5)                                     + // 033 a 037 - 9(005) CONTA               - NÚMERO DA CONTA CORRENTE DA EMPRESA          -
                Copy(Right('0'+LimpaNumero(Form26.MaskEdit46.Text),1),1,1)                                + // 038 a 038 - 9(001) DAC                 - DÍGITO DE AUTO CONFERÊNCIA AG/CONTA EMPRESA  -
                Copy(Replicate(' ',008),1,008)                                                            + // 039 a 046 - X(008) BRANCOS             - COMPLEMENTO DO REGISTRO                      -
                Copy(UpperCase(Form7.IbDataSet13NOME.AsString)+Replicate(' ',30),1,030)                   + // 047 a 076 - X(030) NOME DA EMPRESA     - NOME POR EXTENSO DA "EMPRESA MÃE"            -
                Copy(sIdentificacaoBanco,1,003)                                                           + // 077 a 079 - 9(003) CÓDIGO DO BANCO     - Nº DO BANCO NA CÂMARA DE COMPENSAÇÃO         - 341
                Copy('BANCO ITAU SA  ',1,015)                                                             + // 080 a 094 - X(015) NOME DO BANCO       - NOME POR EXTENSO DO BANCO COBRADOR           - BANCO ITAU SA
                Copy(Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),9,2),1,006) + // 095 a 100 - 9(006) DATA DE GERAÇÃO     - DATA DE GERAÇÃO DO ARQUIVO                   - DDMMAA
                Copy(Replicate(' ',294),1,294)                                                            + // 101 a 394 - X(294) BRANCOS             - COMPLEMENTO DO REGISTRO                      -
                Copy('000001',1,006)                                                                      + // 395 a 400 - 9(006) NÚMERO SEQÜENCIAL   - NÚMERO SEQÜENCIAL DO REGISTRO NO ARQUIVO     - 000001
                ''
                );
            end else
            begin
              // SANTANDER HEADER
              if (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '033') or (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '353') then // SANTANDER
              begin
                //
                WriteLn(F,
                  Copy('0',1,001)                                                                           + // 01 001 a 001 - 9(001) Código do registro = 0
                  Copy('1',1,001)                                                                           + // 02 002 a 002 - 9(001) Código da remessa = 1
                  Copy('REMESSA',1,007)                                                                     + // 03 003 a 009 - X(007) Literal de transmissão = REMESSA
                  Copy('01',1,002)                                                                          + // 04 010 a 011 - 9(002) Código do serviço = 01
                  Copy('COBRANCA       ',1,015)                                                             + // 05 012 a 026 - X(015) Literal de serviço = COBRANÇA
                  Copy(Right('00000000000000000000'+LimpaNumero(Form26.MaskEdit50.Text),20),1,020)          + // 06 027 a 046 - 9(020) Código de Transmissão (nota 1)
                  Copy(UpperCase(Form7.IbDataSet13NOME.AsString)+Replicate(' ',30),1,030)                   + // 07 047 a 076 - X(030) Nome do cedente
                  Copy(sIdentificacaoBanco,1,003)                                                           + // 08 077 a 079 - 9(003) Código do Banco = 353 / 033
                  Copy('SANTANDER      ',1,015)                                                             + // 09 080 a 094 - X(015) Nome do Banco = SANTANDER
                  Copy(Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),9,2),1,006) + // 10 095 a 100 - 9(006) Data de Gravação
                  Copy(Replicate('0',16),1,16)                                                              + // 11 101 a 116 - 9(016) Zeros
                  Copy(Replicate(' ',47),1,47)                                                              + // 12 117 a 163 - X(047) Mensagem 1
                  Copy(Replicate(' ',47),1,47)                                                              + // 13 164 a 210 - X(047) Mensagem 2
                  Copy(Replicate(' ',47),1,47)                                                              + // 14 211 a 257 - X(047) Mensagem 3
                  Copy(Replicate(' ',47),1,47)                                                              + // 15 258 a 304 - X(047) Mensagem 4
                  Copy(Replicate(' ',47),1,47)                                                              + // 16 305 a 351 - X(047) Mensagem 5
                  Copy(Replicate(' ',40),1,40)                                                              + // 17 352 a 391 - X(047) Mensagem 6
                  Copy(StrZero(iRemessa,3,0),1,003)                                                         + // 18 392 a 394 - 9(003) Número da versão da remessa opcional, se informada, será controlada pelo sistema
                  Copy('000001',1,006)                                                                      + // 19 395 a 400 - 9(006) Número sequencial do registro no arquivo = 000001
                  ''
                  );
              end else
              begin
                if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '041' then // Banrisul
                begin
                  // BANRISUL HEADER
                  WriteLn(F,
                    Copy('01REMESSA',1,009)                                                                   + // 01 001 a 009 -   9 (x) 01REMESSA (constante) - Campo obrigatório
                    Copy(Replicate(' ',17),1,017)                                                             + // 02 010 a 026 -  17 (x) BRANCOS
                    Copy(
                    Copy(LimpaNumero(Form26.MaskEdit44.Text)+'0000',1,004)+
                    LimpaNumero(Form26.MaskEdit46.Text)+Replicate('0',13)
                    ,1,13)                                                                                    + // 03 027 a 039 -  13 (9) CÓDIGO DE CEDENTE
                    Copy(Replicate(' ',07),1,007)                                                             + // 04 040 a 046 -   7 (x) BRANCOS
                    Copy(UpperCase(ConverteAcentosPHP(Form7.IbDataSet13NOME.AsString))+Replicate(' ',30),1,030) + // 05 047 a 076 -  30 (x) NOME DA EMPRESA
                    Copy('041BANRISUL',1,011)                                                                 + // 06 077 a 087 -  11 (x) 041BANRISUL (constante)
                    Copy(Replicate(' ',07),1,007)                                                             + // 07 088 a 094 -   7 (x) BRANCOS
                    Copy(Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),9,2),1,006) + // 08 095 a 100 -   6 (9) DATA DE GRAVAÇÃO DO ARQUIVO
                    Copy(Replicate(' ',09),1,009)                                                             + // 09 101 a 109 -   9 (x) BRANCOS
                    Copy(Replicate(' ',04),1,004)                                                             + // 10 110 a 113 -   4 (x) BRANCOS
                    Copy(Replicate(' ',01),1,001)                                                             + // 11 114 a 114 -   1 (x) BRANCOS
                    Copy(' ',1,001)                                                                           + // 12 115 a 115 -   1 (x) X – Quando for movimento para teste, P – Quando for movimento em produção
                    Copy(Replicate(' ',01),1,001)                                                             + // 13 116 a 116 -   1 (x) BRANCOS
                    Copy(Replicate(' ',10),1,010)                                                             + // 14 117 a 126 -  10 (x) CÓDIGO DO CLIENTE NO OFFICE BANKING
                    Copy(Replicate(' ',268),1,268)                                                            + // 15 127 a 394 - 268 (x) Brancos
                    Copy('000001',1,006)                                                                      + // 16 395 a 400 -   6 (x) 000001 (constante)
                    ''
                    );
                end else
                begin
                  // Banco do Brasil  HEADER
                  WriteLn(F,
                    Copy('0',1,001)                                                                           + // 01.0 001 a 001 9(001) Identificação do Registro Header: “0” (zero)
                    Copy('1',1,001)                                                                           + // 02.0 002 a 002 9(001) Tipo de Operação: “1” (um)
                    Copy('REMESSA',1,007)                                                                     + // 03.0 003 a 009 X(007) Identificação por Extenso do Tipo de Operação 01
                    Copy('01',1,002)                                                                          + // 04.0 010 a 011 9(002) Identificação do Tipo de Serviço: “01”
                    Copy('COBRANCA',1,008)                                                                    + // 05.0 012 a 019 X(008) Identificação por Extenso do Tipo de Serviço: “COBRANCA”
                    Copy(Replicate(' ',7),1,007)                                                              + // 06.0 020 a 026 X(007) Complemento do Registro: “Brancos”
                    Copy(Copy(Form26.MaskEdit44.Text+'    ',1,4),1,004)                                       + // 07.0 027 a 030 9(004) Prefixo da Agência: Número da Agência onde está cadastrado o convênio líder do cedente 02
                    Copy(Copy(AllTrim(Form26.MaskEdit44.Text)+'000000',6,1),1,001)                            + // 08.0 031 a 031 X(001) Dígito Verificador - D.V. - do Prefixo da Agência. 02
                    Copy(Right('000000000'+AllTrim(StrTran(Form26.MaskEdit46.Text,'-','')),9),1,8)            + // 09.0 032 a 039 9(008) Número da Conta Corrente: Número da conta onde está cadastrado o Convênio Líder do Cedente 02
                    Copy(Right('000000000'+AllTrim(StrTran(Form26.MaskEdit46.Text,'-','')),9),9,1)            + // 10.0 040 a 040 X(001) Dígito Verificador - D.V. – do Número da Conta Corrente do Cedente 02
                    Copy('000000',1,6)                                                                        + // 11.0 041 a 046 9(006) Complemento do Registro: “000000”
                    Copy(UpperCase(Form7.IbDataSet13NOME.AsString)+Replicate(' ',30),1,030)                   + // 12.0 047 a 076 X(030) Nome do Cedente
                    Copy(sIdentificacaoBanco+Replicate(' ',18),1,018)                                         + // 13.0 077 a 094 X(018) 001BANCODOBRASIL
                    Copy(Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),9,2),1,006) + // 14.0 095 a 100 9(006) Data da Gravação: Informe no formato “DDMMAA” 21
                    Copy(StrZero(iRemessa,7,0),1,007)                                                         + // 15.0 101 a 107 9(007) Seqüencial da Remessa 03
                    Copy(Replicate(' ',22),1,22)                                                              + // 16.0 108 a 129 X(22) Complemento do Registro: “Brancos”
                    Copy(Right('000000'+LimpaNumero(Form26.MaskEdit50.Text),7),1,7)                           + // 17.0 130 a 136 9(007) Número do Convênio Líder (numeração acima de 1.000.000 um milhão)" 04
                    Copy(Replicate(' ',258)  ,1,258)                                                          + // 18.0 137 a 394 X(258) Complemento do Registro: “Brancos”
                    Copy('000001',1,006)                                                                      + // 19.0 395 a 400 9(006) Seqüencial do Registro:”000001”
                    ''
                    );
                end;
              end;
            end;
          end;
        end;
      end;
    except
      on E: Exception do
      begin
        Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
      end;
    end;

    // Zerezima
    iReg := 1;
    vTotal := 0;

    Form7.ibDataSet7.DisableControls;
    Form7.ibDataSet7.First;

    while not Form7.ibDataSet7.Eof do
    begin
      if Form7.ibDataSet7ATIVO.AsFloat <> 1 then
      begin
        if (UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'REMESSA ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')') or
           (UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')BAIXA') or
           (UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')VENCIMENTO') or
           (UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')EXCLUIR') then
        begin
          Form7.ibDataSet2.Close;
          Form7.ibDataSet2.Selectsql.Clear;
          Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet7NOME.AsString)+' ');  //
          Form7.ibDataSet2.Open;

          try
            if Length(LimpaNumero(Form7.IBDataSet2CGC.AsString)) = 14 then sCPFOuCNPJ := '02' else sCPFOuCNPJ := '01';

            if Ord(Form7.ibDataSet7DOCUMENTO.AsString[Length(Trim(Form7.ibDataSet7DOCUMENTO.AsString))]) >= 64 then
            begin
              sParcela := StrZero((Ord(Form7.ibDataSet7DOCUMENTO.AsString[Length(Trim(Form7.ibDataSet7DOCUMENTO.AsString))])-64),2,0); //converte a letra em número
            end else
            begin
              sParcela := '01';
            end;

            iReg := iReg + 1;

            try
              // 01 = Registro de Títulos
              // 02 = Solicitação de Baixa
              // 04 = Concessão de Abatimento
              // 05 = Cancelamento de Abatimento
              // 06 = Alteração de Vencimento
              // 08 = Alteração de Seu Número
              // 09 = Instrução para Protestar
              // 10 = Instrução para Sustar Protesto
              // 11 = Instrução para Dispensar Juros
              // 12 = Alteração de Pagador
              // 31 = Alteração de Outros Dados
              // 34 = Baixa - Pagamento Direto ao Beneficiário
              // 34 = Pagamento Direto ao Beneficiário
              sComandoMovimento := '01';

              if UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text)+'000',1,3)+')BAIXA'       then sComandoMovimento := '02';
              if UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text)+'000',1,3)+')VENCIMENTO'  then sComandoMovimento := '06';
              if UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text)+'000',1,3)+')EXCLUIR'     then sComandoMovimento := '99';

              if (sComandoMovimento = '06') and (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '104') then
              begin
                sComandoMovimento := '05';
              end;

              // Altera para não ir de novo
              if UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')BAIXA' then
              begin
                Form7.ibDataSet7.Edit;
                Form7.ibDataSet7PORTADOR.AsString := 'EM CARTEIRA';
                Form7.ibDataSet7.Post;
              end else
              begin
                if Form7.ibDataSet7PORTADOR.AsString <> 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')' then
                begin
                  Form7.ibDataSet7.Edit;
                  Form7.ibDataSet7PORTADOR.AsString := 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')';
                  Form7.ibDataSet7.Post;
                end;
              end;

              try
                if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '756' then
                begin
                  // SICOOB REMESSA
                  WriteLn(F,
                    Copy('1',1,001)                                                          + // Ok 1 Identificação do Registro Detalhe: 1 (um)
                    Copy('02',1,002)                                                         + // Ok 2 "Tipo de Inscrição do Beneficiário: ""01"" = CPF ""02"" = CNPJ  "
                    Copy(LimpaNumero(Form7.IBDataSet13CGC.AsString)+Replicate(' ',14),1,014) + // Ok 3 Número do CPF/CNPJ do Beneficiário
                    Copy(Copy(Form26.MaskEdit44.Text+'    ',1,4),1,004)                      + // Ok 4 Prefixo da Cooperativa: vide planilha "Capa" deste arquivo
                    Copy(Copy(Form26.MaskEdit44.Text+'    ',5,1),1,001)                      + // Ok 5 Dígito Verificador do Prefixo: vide planilha "Capa" deste arquivo
                    Copy(Right('000000000'+LimpaNumero(Form7.ibDataSet11CONTA.AsString),9),1,8) + // ok 6 Conta Corrente: vide planilha "Capa" deste arquivo
                    Copy(Right('000000000'+LimpaNumero(Form7.ibDataSet11CONTA.AsString),9),9,1) + // 0k 7 Dígito Verificador da Conta: vide planilha "Capa" deste arquivo
                    Copy('000000',1,006)                                                     + // ok 8 Número do Convênio de Cobrança do Beneficiário: "000000"
                    Copy(Replicate(' ',25),1,025)                                            + // ok 9 Número de Controle do Participante: Brancos
                    Copy(StrZero(StrToFloat('0'+LimpaNumero(Form7.ibDataset7NOSSONUM.AsString)),12,0),1,012) + // 10 Ok Nosso Número
                    Copy(sPArcela+'00',1,002)                                                + // 11 Ok Número da Parcela: "01" se parcela única
    //              Copy('01',1,002)                                                         + // 11 Ok Número da Parcela: "01" se parcela única
                    Copy('00',1,002)                                                         + // 12 Ok Grupo de Valor: "00"
                    Copy('   ',1,003)                                                        + // 13 Ok Complemento do Registro: Brancos
                    Copy(' ',1,001)                                                          + // 14 Ok "Indicativo de Mensagem ou Sacador/Avalista: Brancos: Poderá ser informada nas posições 352 a 391 (SEQ 50) qualquer mensagem para ser impressa no boleto; “A”: Deverá ser informado nas posições 352 a 391 (SEQ 50) o nome e CPF/CNPJ do sacador"
                    Copy('001',1,003)                                                        + // 15 Ok Prefixo do Título: Brancos
                    Copy(AllTrim(LimpaNumero(Form26.MaskEdit43.Text))+'000000',3,3)          + // 16 Ok Variação da Carteira: "000"
                    Copy('0',1,001)                                                          + // 17 Ok Conta Caução: "0"
                    Copy('00000',1,005)                                                      + // 18 Ok "Número do Contrato Garantia: Para Carteira 1 preencher ""00000""; Para Carteira 3 preencher com o  número do contrato sem DV."
                    Copy('0',1,001)                                                          + // 19 Ok "DV do contrato: Para Carteira 1 preencher ""0""; Para Carteira 3 preencher com o Dígito Verificador."
                    Copy('000000',1,006)                                                     + // 20 Ok Numero do borderô: preencher em caso de carteira 3
                    Copy('    ',1,004)                                                       + // 21 Ok Complemento do Registro: Brancos
                    Copy('2',1,001)                                                          + // 22 Ok "Tipo de Emissão: 1-Cooperativa 2-Cliente"
                    Copy('01',1,002)                                                         + // 23 Ok "Carteira/Modalidade: 01 = Simples Com Registro 02 = Simples Sem Registro 03 = Garantida Caucionada"
                    Copy(sComandoMovimento,1,002)                                            + // 24 Ok "Comando/Movimento:
                    Copy(AllTrim(Form7.ibDataset7DOCUMENTO.AsString)+Replicate(' ',10),1,10) + // 25 Ok Seu Número/Número atribuído pela Empresa
                    Copy(Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,2)+Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),4,2)+Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),9,2),1,006) + // 26 Ok "Data Vencimento: Formato DDMMAA
                    Copy(StrZero((Form7.ibDataSet7VALOR_DUPL.AsFloat * 100),13,0),1,013)     + // 27 Ok Valor do Titulo
                    Copy(Form26.MaskEdit42.Text,1,003)                                       + // 28 Ok Número Banco: "756"
                    Copy(Copy(Form26.MaskEdit44.Text+'    ',1,4),1,004)                      + // 29 ok Prefixo da Cooperativa: vide planilha "Capa" deste arquivo
                    Copy(Copy(Form26.MaskEdit44.Text+'    ',5,1),1,001)                      + // 30 ok Dígito Verificador do Prefixo: vide planilha "Capa" deste arquivo
                    Copy('01',1,002)                                                         + // 31 ok "Espécie do Título
                    Copy('0',1,001)                                                          + // 32 "Aceite do Título: ""0"" = Sem aceite ""1"" = Com aceite"
                    Copy(Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),1,2)+Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),4,2)+Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),9,2),1,006) + // 33 Data de Emissão do Título: formato ddmmaa
                    Copy('01',1,002)                                                         + // 34 Ok "Primeira instrução codificada:
                    Copy('01',1,002)                                                         + // 35 Ok Segunda instrução: vide SEQ 33
                    Copy('000000',1,006)                                                     + // 36 Ok "Taxa de mora mês Ex: 022000 = 2,20%)"
                    Copy('000000',1,006)                                                     + // 37 Ok "Taxa de multa Ex: 022000 = 2,20%)"
                    Copy('2',1,001)                                                          + // 38 Ok "Tipo Distribuição 1 – Cooperativa 2 - Cliente"
                    Copy('000000',1,006)                                                     + // 39 Ok "Data primeiro desconto: Informar a data limite a ser observada pelo cliente para o pagamento do título com Desconto no formato ddmmaa.
                    Copy('0000000000000',1,013)                                              + // 40 Ok "Valor primeiro desconto: Informar o valor do desconto, com duas casa decimais. Preencher com zeros quando não for concedido nenhum desconto."
                    Copy('9000000000000',1,013)                                              + // 41 Ok "193-193 – Código da moeda
                    Copy('0000000000000',1,013)                                              + // 42 Ok Valor Abatimento
                    Copy(sCPFOuCNPJ,1,002)                                                   + // 43 Ok "Tipo de Inscrição do Pagador: ""01"" = CPF ""02"" = CNPJ "
                    Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet2CGC.AsString),14),1,014) + // 44 Ok Número do CNPJ ou CPF do Pagador
                    Copy(Form7.ibDataSet2NOME.AsString+Replicate(' ',40),1,040)              + // 45 Ok Nome do Pagador
                    Copy(Form7.ibDataSet2ENDERE.AsString+Replicate(' ',40),1,037)            + // 46 Ok Endereço do Pagador
                    Copy(Form7.ibDataSet2COMPLE.AsString+Replicate(' ',40),1,015)            + // 47 Ok Bairro do Pagador
                    Copy(LimpaNumero(Form7.ibDataSet2CEP.AsString)+Replicate('0',40),1,008)  + // 48 Ok CEP do Pagador
                    Copy(Form7.ibDataSet2CIDADE.AsString+Replicate(' ',40),1,015)            + // 49 Ok Cidade do Pagador
                    Copy(Form7.ibDataSet2ESTADO.AsString+Replicate(' ',40),1,002)            + // 50 Ok UF do Pagador
                    Copy(Replicate(' ',40),1,040)                                            + // 51 Ok "Observações/Mensagem ou Sacador/Avalista:
                    Copy('00',1,002)                                                         + // 52 Ok "Número de Dias Para Protesto:
                    Copy(' ',1,001)                                                          + // 53 Ok Complemento do Registro: Brancos
                    Copy(StrZero(iReg,6,0),1,006)                                            + // 54 Ok Seqüencial do Registro: Incrementado em 1 a cada registro
                    ''
                    );
                end else
                begin
                  if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '104' then // CAIXA
                  begin
                    // CAIXA REMESSA
                    if Length(LimpaNumero(Form7.IBDataSet13CGC.AsString)) = 14 then sCPFOuCNPJ_EMITENTE := '02' else sCPFOuCNPJ_EMITENTE := '01';

                    WriteLn(F,
                      Copy('1',1,001)                                                                          + // 01.1 - 001 a 001 - 9(001) Preencher ‘1’
                      Copy(sCPFOuCNPJ_EMITENTE,1,002)                                                          + // 02.1 - 002 a 003 - 9(002) Preencher com o tipo de Inscrição da Empresa Beneficiária: ‘01’ = CPF ou ‘02’ = CNPJ
                      Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet13CGC.AsString),14),1,014)       + // 03.1 - 004 a 017 - 9(014) Preencher com Número de inscrição da Empresa (CNPJ) ou Pessoa Física (CPF) a que se está fazendo referência, de acordo com o código do campo acima
                      Copy(LimpaNumero(Form26.MaskEdit44.Text)+'    ',1,004)                                   + // 04.1 - 018 a 021 - 9(004) Preencher com o Código da Agência de vinculação do Beneficiário, com 4 dígitos
                      Copy(LimpaNumero(Form26.MaskEdit46.Text)+'      ',1,006)                                 + // 05.1 - 022 a 027 - 9(006) Preencher com o Código que identifica a Empresa na CAIXA, fornecido pela agência de vinculação
                      Copy('2',1,001)                                                                          + // 06.1 - 028 a 028 - 9(001) Preencher com a forma de emissão do boleto desejada: ‘1’ = Banco Emite ou ‘2’ = Cliente Emite
                      Copy('0',1,001)                                                                          + // 07.1 - 029 a 029 - 9(001) Identificação da Entrega/Distribuição do Boleto
                      Copy('00',1,002)                                                                         + // 09.1 - 032 a 056 - 9(002) Taxa Permanência Informar ‘00’
                      Copy(LimpaNumero(Form7.ibDataset7NOSSONUM.AsString)+'                         ',1,025)   + // 10.1 - 057 a 058 - X(025) Preencher com Seu Número de controle do título (exemplos: nº da duplicata no caso de cobrança de duplicatas, nº da apólice, em caso de cobrança de seguros)
                      Copy(LimpaNumero(Form7.ibDataset7NOSSONUM.AsString)+'00000000000000000',1,017)           + // 11.1 - 059 a 073 - 9(017) Nosso Número
                      Copy('   ',1,003)                                                                        + // 12.1 - 074 a 076 - X(003) Preencher com espaços
                      Copy(Replicate(' ',30),1,030)                                                            + // 13.1 - 077 a 106 - X(030) Preencher com Mensagem a ser impressa no boleto
                      Copy('01',1,002)                                                                         + // 14.1 - 107 a 108 - 9(002) Preencher de acordo com a modalidade de cobrança contratada: ‘01’ = Cobrança Registrada ou ‘02’ = Cobrança Sem Registro
                      Copy(sComandoMovimento,1,002)                                                            + // 15.1 - 109 a 110 - 9(002) Código Ocorrência Preencher com a ação desejada para o título
                      Copy(AllTrim(Form7.ibDataset7DOCUMENTO.AsString)+Replicate(' ',10),1,10)                 + // 16.1 - 111 a 120 - X(010) Preencher com Seu Número de controle do título (exemplos: nº da duplicata no caso de cobrança de duplicatas, nº da apólice, em caso de cobrança de seguros)
                      Copy(Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,2)                          +
                      Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),4,2)                               +
                      Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),9,2),1,006)                        + // 17.1 - 121 a 126 - 9(006) Preencher com a Data de Vencimento do Título, no formato DDMMAA (Dia, Mês e Ano); para os vencimentos “À Vista” ou “Contra-apresentação”
                      Copy(StrZero((Form7.ibDataSet7VALOR_DUPL.AsFloat * 100),13,0),1,013)                     + // 18.1 - 127 a 139 - 9(013) Preencher com o Valor Nominal do Título, utillizando 2 decimais
                      Copy(LimpaNumero(Form26.MaskEdit42.Text)+'000',1,003)                                    + // 19.1 - 140 a 142 - 9(003) Preencher ‘104’
                      Copy('00000',1,005)                                                                      + // 20.1 - 143 a 147 - 9(005) Preencher com zeros
                      Copy('01',1,002)                                                                         + // 21.1 - 148 a 149 - 9(002) Espécie do Título: 01 DM Duplicata Mercantil
                      Copy('N',1,001)                                                                          + // 22.1 - 150 a 150 - 9(001) Identificação de Título - Aceito / Não Aceito
                      Copy(Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),1,2)                             +
                      Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),4,2)                                  +
                      Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),9,2),1,006)                           + // 23.1 - 151 a 156 - 9(006) Data da Emissão do Título
                      Copy('02',1,002)                                                                         + // 24.1 - 157 a 158 - 9(002) Primeira Instrução de Cobrança
                      Copy('00',1,002)                                                                         + // 25.1 - 159 a 160 - 9(002) ‘0’
                      Copy('0000000000000',1,013)                                                              + // 26.1 - 161 a 173 - 9(013) Juros de Mora por dia/Valor; 2 decimais
                      Copy('000000',1,006)                                                                     + // 27.1 - 174 a 179 - 9(006) Data limite para concessão do desconto
                      Copy('0000000000000',1,013)                                                              + // 28.1 - 180 a 192 - 9(013) Valor do Desconto a ser concedido; 2 decimais
                      Copy('0000000000000',1,013)                                                              + // 29.1 - 193 a 205 - 9(013) Valor do IOF a ser recolhido; 2 decimais
                      Copy('0000000000000',1,013)                                                              + // 30.1 - 206 a 218 - 9(013) Valor do abatimento a ser concedido; 2 decimais
                      Copy(sCPFOuCNPJ,1,002)                                                                   + // 31.1 - 219 a 220 - 9(002) Identificador do Tipo de Inscrição do Pagador
                      Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet2CGC.AsString),14),1,014)        + // 32.1 - 221 a 234 - 9(014) Número de Inscrição do Pagador
                      Copy(Form7.ibDataSet2NOME.AsString+Replicate(' ',40),1,040)                              + // 33.1 - 235 a 274 - X(040) Nome do Pagador
                      Copy(Form7.ibDataSet2ENDERE.AsString+Replicate(' ',40),1,040)                            + // 34.1 - 275 a 314 - X(040) Endereço do Pagador
                      Copy(Form7.ibDataSet2COMPLE.AsString+Replicate(' ',40),1,012)                            + // 35.1 - 315 a 326 - X(012) Bairro do Pagador
                      Copy(LimpaNumero(Form7.ibDataSet2CEP.AsString)+Replicate('0',40),1,008)                  + // 36.1 - 327 a 334 - 9(008) CEP do Pagador
                      Copy(Form7.ibDataSet2CIDADE.AsString+Replicate(' ',40),1,015)                            + // 37.1 - 335 a 349 - X(015) Cidade do Pagador
                      Copy(Form7.ibDataSet2ESTADO.AsString+Replicate(' ',40),1,002)                            + // 38.1 - 350 a 351 - X(002) Unidade da Federação do Pagador
                      Copy('000000',1,006)                                                                     + // 39.1 - 352 a 357 - 9(006) Definição da data para pagamento de multa
                      Copy('0000000000',1,010)                                                                 + // 40.1 - 358 a 367 - 9(010) Valor nominal da multa; 2 decimais
                      Copy(Replicate(' ',22),1,022)                                                            + // 41.1 - 368 a 389 - X(022) Nome do Sacador/Avalista
                      Copy('00',1,002)                                                                         + // 42.1 - 390 a 391 - 9(002) Terceira Instrução de Cobrança
                      Copy('29',1,002)                                                                         + // 43.1 - 392 a 393 - 9(002) Número de dias para início do protesto/devolução
                      Copy('1',1,001)                                                                          + // 44.1 - 394 a 394 - 9(001) Código da Moeda ‘1’
                      Copy(StrZero(iReg,6,0),1,006)                                                            + // 45.1 - 395 a 400 - 9(006) Número Sequencial do Registro no Arquivo
                      ''
                      );
                  end else
                  begin
                    if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '237' then // BRADESCO
                    begin
                      // BRADESCO
                      WriteLn(F,
                        Copy('1',1,001)                                                                              + // 01.1 - 001 a 001  - 9(001) Identificação do Registro
                        Copy('00000',1,005)                                                                          + // 02.1 - 002 a 006  - 9(005) Agência de Débito (opcional)
                        Copy('0',1,001)                                                                              + // 03.1 - 007 a 007  - X(001) Dígito da Agência de Débito (opcional)
                        Copy('00000',1,005)                                                                          + // 04.1 - 008 a 012  - 9(005) Razão da Conta Corrente (opcional)
                        Copy('0000000',1,007)                                                                        + // 05.1 - 013 a 019  - 9(007) Conta Corrente (opcional)
                        Copy('0',1,001)                                                                              + // 06.1 - 020 a 020  - X(001) Dígito da Conta Corrente (opcional)
                        '0'+
                        Right('000'+LimpaNumero(Form26.MaskEdit43.Text),3)+
                        '0'+Copy(Right('00000'+LimpaNumero(Form26.MaskEdit44.Text),5),1,4)+
                        Copy(Right('00000000'+LimpaNumero(Form7.ibDataSet11CONTA.AsString),8),1,7) +
                        Copy(Right('00000000'+LimpaNumero(Form7.ibDataSet11CONTA.AsString),8),8,1)                   + // 07.1 - 021 a 037  - X(017) Identificação da Empresa Beneficiária no Banco
                        Copy(Replicate(' ',25),1,025)                                                                + // 08.1 - 038 a 062  - X(025) Nº Controle do Participante
                        Copy('000',1,003)                                                                            + // 09.1 - 063 a 065  - 9(003) Código do Banco a ser debitado na Câmara de Compensação
                        Copy('0',1,001)                                                                              + // 10.1 - 066 a 066  - 9(001) Campo de Multa
                        Copy('0000',1,004)                                                                           + // 11.1 - 067 a 070  - 9(004) Percentual de multa
                        Copy(Copy(StrTran(Form7.ibDataset7NOSSONUM.AsString,'-',''),4,012),1,12)                     + // 12.1 - 071 a 081  - 9(011) Identificação do Título no Banco
                        Copy('0000000000',1,010)                                                                     + // 13.1 - 083 a 092  - 9(010) Desconto Bonificação por dia
                        Copy('2',1,001)                                                                              + // 14.1 - 093 a 093  - X(001) Condição para Emissão da Papeleta de Cobrança
                        Copy('N',1,001)                                                                              + // 15.1 - 094 a 094  - X(001) Ident. se emite Boleto para Débito Automático
                        Copy('          ',1,010)                                                                     + // 16.1 - 095 a 104  - X(010) Identificação da Operação do Banco
                        Copy(' ',1,001)                                                                              + // 17.1 - 105 a 105  - 9(001) Indicador Rateio Crédito (opcional)
                        Copy('2',1,001)                                                                              + // 18.1 - 106 a 106  - X(001) Endereçamento para Aviso do Débito Automático em Conta Corrente (opcional)
                        Copy('  ',1,002)                                                                             + // 19.1 - 107 a 108  - X(002) Branco
                        //
                        Copy(sComandoMovimento,1,002)                                                                + // 20.1 - 109 a 110  - 9(002) Identificação da ocorrência
                        Copy(AllTrim(Form7.ibDataset7DOCUMENTO.AsString)+Replicate(' ',10),1,10)                     + // 21.1 - 111 a 120  - X(010) Nº do Documento
                        Copy(Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,2)                              +
                        Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),4,2)                                   +
                        Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),9,2),1,006)                            + // 22.1 - 121 a 126  - 9(006) Data do Vencimento do Título
                        Copy(StrZero((Form7.ibDataSet7VALOR_DUPL.AsFloat * 100),13,0),1,013)                         + // 23.1 - 127 a 139  - 9(013) Valor do Título
                        Copy('000',1,003)                                                                            + // 24.1 - 140 a 142  - 9(003) Banco Encarregado da Cobrança
                        Copy('00000',1,005)                                                                          + // 25.1 - 143 a 147  - 9(005) Agência Depositária
                        Copy('01',1,002)                                                                             + // 26.1 - 148 a 149  - 9(002) Espécie de Título
                        Copy('N',1,001)                                                                              + // 27.1 - 150 a 150  - X(001) Identificação
                        Copy(Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),1,2)                                 +
                        Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),4,2)                                      +
                        Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),9,2),1,006)                               + // 28.1 - 151 a 156  - 9(006) Data da emissão do Título
                        Copy('00',1,002)                                                                             + // 29.1 - 157 a 158  - 9(002) 1ª instrução
                        Copy('00',1,002)                                                                             + // 30.1 - 159 a 160  - 9(002) 2ª instrução
                        Copy('0000000000000',1,013)                                                                  + // 31.1 - 161 a 173  - 9(013) Valor a ser cobrado por Dia de Atraso
                        Copy('000000',1,006)                                                                         + // 32.1 - 174 a 179  - 9(006) Data Limite P/Concessão de Desconto
                        Copy('0000000000000',1,013)                                                                  + // 33.1 - 180 a 192  - 9(013) Valor do Desconto
                        Copy('0000000000000',1,013)                                                                  + // 34.1 - 193 a 205  - 9(013) Valor do IOF
                        Copy('0000000000000',1,013)                                                                  + // 35.1 - 206 a 218  - 9(013) Valor do Abatimento a ser concedido ou cancelado
                        Copy(sCPFOuCNPJ,1,002)                                                                       + // 36.1 - 219 a 220  - 9(002) Identificação do Tipo de Inscrição do Pagador
                        Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet2CGC.AsString),14),1,014)            + // 37.1 - 221 a 234  - X(014) Nº Inscrição do Pagador
                        Copy(UpperCase(ConverteAcentosPHP(Form7.ibDataSet2NOME.AsString))+Replicate(' ',40),1,040)   + // 38.1 - 235 a 274  - X(040) Nome do Pagador
                        Copy(UpperCase(ConverteAcentosPHP(Form7.ibDataSet2ENDERE.AsString))+Replicate(' ',40),1,040) + // 39.1 - 275 a 314  - X(040) Endereço Completo
                        Copy('            ',1,012)                                                                   + // 40.1 - 315 a 326  - X(012) 1ª Mensagem
                        Copy(LimpaNumero(Form7.ibDataSet2CEP.AsString)+Replicate('0',8),1,005)                       + // 41.1 - 327 a 331  - 9(005) CEP
                        Copy(LimpaNumero(Form7.ibDataSet2CEP.AsString)+Replicate('0',8),6,003)                       + // 42.1 - 332 a 334  - 9(003) Sufixo do CEP
                        Copy(Replicate(' ',60),1,060)                                                                + // 43.1 - 335 a 394  - X(060) Sacador/Avalista ou 2ª Mensagem
                        Copy(StrZero(iReg,6,0),1,006)                                                                + // 44.1 - 395 a 400  - 9(006) Nº Seqüencial do Registro
                        ''
                        );
                    end else
                    begin
                      // SANTANDER
                      if (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '033') or (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '353') then
                      begin
                        if LimpaNumero(Form7.ibDataSet11CONTA.AsString) <> '' then
                        begin
                          if LimpaNumero(Form7.ibDataSet11CONTA.AsString) <> '' then
                          begin
                            try
                              Form7.ibDataSet11.Edit;
                              if Length(LimpaNumero(Form7.ibDataSet11CONTA.AsString)) <= 8 then
                              begin
                                Form7.ibDataSet11CONTA.AsString := Right('00000000'+LimpaNumero(Form7.ibDataSet11CONTA.AsString),8);
                              end else
                              begin
                                Form7.ibDataSet11CONTA.AsString := Right('0000000000'+LimpaNumero(Form7.ibDataSet11CONTA.AsString),10);
                              end;

                              Form7.ibDataSet11.Post;
                            except
                            end;
                          end;
                        end;

                        if Length(LimpaNumero(Form7.IBDataSet13CGC.AsString)) = 14 then sCPFOuCNPJ_EMITENTE := '02' else sCPFOuCNPJ_EMITENTE := '01';
                        if Length(LimpaNumero(Form7.ibDataSet11CONTA.AsString)) = 10 then sIdoComplemento     := 'I' else sIdoComplemento := '0';
                        
                        WriteLn(F,
                          Copy('1',1,001)                                                                          + // 001.1 - 001 a 001 - 9(001) Código do registro = 1
                          Copy(sCPFOuCNPJ_EMITENTE,1,002)                                                          + // 002.1 - 002 a 003 - 9(002) Tipo de inscrição do cedente: 01 = CPF 02 = CGC
                          Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet13CGC.AsString),14),1,014)       + // 003.1 - 004 a 017 - 9(014) CGC ou CPF do cedente
                          Copy(LimpaNumero(Form26.MaskEdit44.Text)+'0000',1,004)                                   + // 004.1 - 018 a 021 - 9(004) Código da agência cedente (nota 2)
                          Copy(LimpaNumero(Form26.MaskEdit46.Text)+'000000000',1,8)                                + // 005.1 - 022 a 029 - 9(008) Conta movimento cedente (nota 2)
                          Copy(LimpaNumero(Form7.ibDataSet11CONTA.AsString)+'00000000',1,008)                      + // 006.1 - 030 a 037 - 9(008) Conta cobrança cedente (nota 2)
                          Copy(Replicate(' ',25),1,25)                                                             + // 007.1 - 038 a 062 - X(025) Número de controle do participante, para controle por parte do cedente
                          Copy(StrZero(StrToFloat('0'+LimpaNumero(Form7.ibDataSet7NN.AsString)),7,0),1,07)         +
                          Modulo_11(LimpaNumero(Form7.ibDataSet7NN.AsString))                                      + // 008.1 - 063 a 070 - 9(008) Nosso número (nota 3)
                          Copy('000000',1,6)                                                                       + // 009.1 - 071 a 076 - 9(006) Data do segundo desconto
                          Copy(' ',1,1)                                                                            + // 010.1 - 077 a 077 - X(001) Branco
                          Copy('0',1,1)                                                                            + // 011.1 - 078 a 078 - 9(001) Informação de multa = 4, senão houver informar zero
                          Copy('0000',1,4)                                                                         + // 012.1 - 079 a 082 - 9(004) Percentual multa por atraso %
                          Copy('00',1,2)                                                                           + // 013.1 - 083 a 084 - 9(002) Unidade de valor moeda corrente = 00
                          Copy('0000000000000',1,13)                                                               + // 014.1 - 085 a 097 - 9(013) Valor do título em outra unidade (consultar banco)
                          Copy('    ',1,4)                                                                         + // 015.1 - 098 a 101 - X(004) Brancos
                          Copy('000000',1,6)                                                                       + // 016.1 - 102 a 107 - 9(006) Data para cobrança de multa. (Nota 4)
                          Copy('5',1,1)                                                                            + // 017.1 - 108 a 108 - 9(001) Código da carteira (5 = RÁPIDA COM REGISTRO (BLOQUETE EMITIDO PELO CLIENTE))
                          Copy(sComandoMovimento,1,002)                                                            + // 018.1 - 109 a 110 - 9(002) Código da ocorrência: (01 = ENTRADA DE TÍTULO 02 = BAIXA DE TÍTULO 06 = PRORROGAÇÃO DE VENCIMENTO)
                          Copy(Form7.ibDataset7DOCUMENTO.AsString+'          ',1,010)                              + // 019.1 - 111 a 120 - X(010) Seu número
                          Copy(Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,2)                          +
                          Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),4,2)                               +
                          Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),9,2),1,006)                        + // 020.1 - 121 a 126 - 9(006) Data de vencimento do título
                          Copy(StrZero((Form7.ibDataSet7VALOR_DUPL.AsFloat * 100),13,0),1,013)                     + // 021.1 - 127 a 139 - 9(013) Valor do título - moeda corrente
                          Copy(Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+'000',1,3)                                + // 022.1 - 140 a 142 - 9(003) Número do Banco cobrador = 353 / 033
                          Copy('00000',1,5)                                                                        + // 023.1 - 143 a 147 - 9(005) Código da agência cobradora do Banco Santander informar somente se carteira for igual a 5, caso contrário, informar zeros.
                          Copy('01',1,2)                                                                           + // 024.1 - 148 a 149 - 9(002) Espécie de documento: 01 = DUPLICATA
                          Copy('N',1,001)                                                                          + // 025.1 - 150 a 150 - X(001) Tipo de aceite = N
                          Copy(Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),1,2)                             +
                          Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),4,2)                                  +
                          Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),9,2),1,006)                           + // 026.1 - 151 a 156 - 9(006) Data da emissão do título
                          Copy('00',1,2)                                                                           + // 027.1 - 157 a 158 - 9(002) Primeira instrução cobrança
                          Copy('00',1,2)                                                                           + // 028.1 - 159 a 160 - 9(002) Segunda instrução cobrança código 00 = NÃO HÁ INSTRUÇÕES
                          Copy(Replicate('0',13),1,13)                                                             + // 029.1 - 161 a 173 - 9(013) Valor de mora a ser cobrado por dia de atraso
                          Copy('000000',1,6)                                                                       + // 030.1 - 174 a 179 - 9(006) Data limite para concessão de desconto
                          Copy(Replicate('0',13),1,13)                                                             + // 031.1 - 180 a 192 - 9(013) Valor de desconto a ser concedido
                          Copy(Replicate('0',13),1,13)                                                             + // 032.1 - 193 a 205 - 9(013) Valor do IOF a ser recolhido pelo Banco para nota de seguro
                          Copy(Replicate('0',13),1,13)                                                             + // 033.1 - 206 a 218 - 9(013) Valor do abatimento a ser concedido ou valor do segundo desconto
                          Copy(sCPFOuCNPJ,1,002)                                                                   + // 034.1 - 219 a 220 - 9(002) Tipo de inscrição do sacado: 01 = CPF 02 = CGC
                          Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet2CGC.AsString),14),1,014)        + // 035.1 - 221 a 234 - 9(014) CGC ou CPF do sacado
                          Copy(Form7.ibDataSet2NOME.AsString+Replicate(' ',40),1,040)                              + // 036.1 - 235 a 274 - X(040) Nome do sacado
                          Copy(Form7.ibDataSet2ENDERE.AsString+Replicate(' ',40),1,040)                            + // 037.1 - 275 a 314 - X(040) Endereço do sacado
                          Copy(Form7.ibDataSet2COMPLE.AsString+Replicate(' ',40),1,012)                            + // 038.1 - 315 a 326 - X(012) Bairro do sacado (opcional)
                          Copy(LimpaNumero(Form7.ibDataSet2CEP.AsString)+Replicate('0',40),1,008)                  + // 039.1 - 327 a 331 - 9(005) CEP do sacado
                                                                                                                     // 040.1 - 332 a 334 - 9(003) Complemento do CEP
                          Copy(Form7.ibDataSet2CIDADE.AsString+Replicate(' ',40),1,015)                            + // 041.1 - 335 a 349 - X(015) Município do sacado
                          Copy(Form7.ibDataSet2ESTADO.AsString+Replicate(' ',40),1,002)                            + // 042.1 - 350 a 351 - X(002) UF Estado do sacado
                          Copy(Replicate(' ',30),1,030)                                                            + // 043.1 - 352 a 381 - X(030) Nome do sacador ou coobrigado
                          Copy(' ',1,1)                                                                            + // 044.1 - 382 a 382 - X(001) Brancos
                          Copy(sIdoComplemento,1,1)                                                                + // 045.1 - 383 a 383 - 9(001) Identificador do Complemento (nota 2)
                          Copy(LimpaNumero(Form7.ibDataSet11CONTA.AsString)+'0000000000',9,2)                      + // 046.1 - 384 a 385 - 9(002) Complemento (nota 2)
                          Copy(Replicate(' ',6),1,006)                                                             + // 047.1 - 386 a 391 - X(006) Brancos
                          Copy('00',1,002)                                                                         + // 048.1 - 392 a 393 - 9(002) Número de dias para protesto.
                          Copy(' ',1,001)                                                                          + // 049.1 - 394 a 394 - X(001) Branco
                          Copy(StrZero(iReg,6,0),1,006)                                                            + // 050.1 - 395 a 400 - 9(006) Número sequencial do registro no arquivo
                          ''
                          );
                      end else
                      begin
                        // ITAÚ REMESSA ITAU
                        if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '341' then // Itaú ITAU
                        begin
                          sCodigoDaCarteira := 'I';

                          if Form26.MaskEdit43.Text = '108' then sCodigoDaCarteira := 'I';
                          if Form26.MaskEdit43.Text = '180' then sCodigoDaCarteira := 'I';
                          if Form26.MaskEdit43.Text = '121' then sCodigoDaCarteira := 'I';
                          if Form26.MaskEdit43.Text = '150' then sCodigoDaCarteira := 'U';
                          if Form26.MaskEdit43.Text = '109' then sCodigoDaCarteira := 'I';
                          if Form26.MaskEdit43.Text = '191' then sCodigoDaCarteira := 'I';
                          if Form26.MaskEdit43.Text = '104' then sCodigoDaCarteira := 'I';
                          if Form26.MaskEdit43.Text = '188' then sCodigoDaCarteira := 'I';
                          if Form26.MaskEdit43.Text = '147' then sCodigoDaCarteira := 'E';
                          if Form26.MaskEdit43.Text = '112' then sCodigoDaCarteira := 'I';
                          if Form26.MaskEdit43.Text = '115' then sCodigoDaCarteira := 'I';

                          if Length(LimpaNumero(Form7.IBDataSet13CGC.AsString)) = 14 then sCPFOuCNPJ_EMITENTE := '02' else sCPFOuCNPJ_EMITENTE := '01';

                          WriteLn(F,
                            Copy('1',1,001)                                                                          + // 001 a 001 - 9(01) IDENTIFICAÇÃO DO REGISTRO TRANSAÇÃO
                            Copy(sCPFOuCNPJ_EMITENTE,1,002)                                                          + // 002 a 003 - 9(02) TIPO DE INSCRIÇÃO DA EMPRESA
                            Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet13CGC.AsString),14),1,014)       + // 004 a 017 - 9(14) Nº DE INSCRIÇÃO DA EMPRESA (CPF/CNPJ)
                            Copy(LimpaNumero(Form26.MaskEdit44.Text)+'0000',1,004)                                   + // 018 a 021 - 9(04) AGÊNCIA MANTENEDORA DA CONTA
                            Copy('00',1,2)                                                                           + // 022 a 023 - 9(02) COMPLEMENTO DE REGISTRO
                            Copy(LimpaNumero(Form26.MaskEdit46.Text)+'00000',1,5)                                    + // 024 a 028 - 9(05) NÚMERO DA CONTA CORRENTE DA EMPRESA
                            Copy(Right('0'+LimpaNumero(Form26.MaskEdit46.Text),1),1,1)                               + // 029 a 029 - 9(01) DÍGITO DE AUTO CONFERÊNCIA AG/CONTA EMPRESA
                            Copy(Replicate(' ',4),1,004)                                                             + // 030 a 033 - X(04) COMPLEMENTO DE REGISTRO
                            Copy('0000',1,004)                                                                       + // 034 a 037 - 9(04) CÓD.INSTRUÇÃO/ALEGAÇÃO A SER CANCELADA
                            Copy(Replicate(' ',25),1,025)                                                            + // 038 a 062 - X(25) IDENTIFICAÇÃO DO TÍTULO NA EMPRESA
                            Copy(Right('00000000'+LimpaNumero(Form7.ibDataSet7NN.AsString),8),1,8)                   + // 063 a 070 - 9(08) IDENTIFICAÇÃO DO TÍTULO NO BANCO
                            Copy('0000000000000',1,13)                                                               + // 071 a 083 - 9(13) QUANTIDADE DE MOEDA VARIÁVEL
                            Copy(AllTrim(LimpaNumero(Form26.MaskEdit43.Text))+'000',1,3)                             + // 084 a 086 - 9(03) NÚMERO DA CARTEIRA NO BANCO
                            Copy(Replicate(' ',21),1,021)                                                            + // 087 a 107 - X(21) IDENTIFICAÇÃO DA OPERAÇÃO NO BANCO
                            Copy(sCodigoDaCarteira,1,001)                                                            + // 108 a 108 - X(01) CÓDIGO DA CARTEIRA
                            Copy(sComandoMovimento,1,002)                                                            + // 109 a 110 - 9(02) IDENTIFICAÇÃO DA OCORRÊNCIA
                            Copy(AllTrim(Form7.ibDataset7DOCUMENTO.AsString)+Replicate(' ',10),1,10)                 + // 111 a 120 - X(10) Nº DO DOCUMENTO DE COBRANÇA (DUPL.,NP ETC.)
                            Copy(Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,2)                          +
                            Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),4,2)                               +
                            Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),9,2),1,006)                        + // 121 a 126 - 9(06) DATA DE VENCIMENTO DO TÍTULO
                            Copy(StrZero((Form7.ibDataSet7VALOR_DUPL.AsFloat * 100),13,0),1,013)                     + // 127 a 139 - 9(13) VALOR NOMINAL DO TÍTULO
                            Copy(sIdentificacaoBanco,1,003)                                                          + // 140 a 142 - 9(03) Nº DO BANCO NA CÂMARA DE COMPENSAÇÃO
                            Copy('00000',1,5)                                                                        + // 143 a 147 - 9(05) AGÊNCIA ONDE O TÍTULO SERÁ COBRADO
                            Copy('01',1,002)                                                                         + // 148 a 149 - X(02) ESPÉCIE DO TÍTULO
                            Copy('N',1,001)                                                                          + // 150 a 150 - X(01) IDENTIFICAÇÃO DE TÍTULO ACEITO OU NÃO ACEITO
                            Copy(Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),1,2)                             +
                            Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),4,2)                                  +
                            Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),9,2),1,006)                           + // 151 a 156 - 9(06) DATA DA EMISSÃO DO TÍTULO
                            Copy('10',1,002)                                                                         + // 157 a 158 - X(02) 1ª INSTRUÇÃO DE COBRANÇA
                            Copy('10',1,002)                                                                         + // 159 a 160 - X(02) 2ª INSTRUÇÃO DE COBRANÇA
                            Copy('0000000000000',1,13)                                                               + // 161 a 173 - 9(13) VALOR DE MORA POR DIA DE ATRASO
                            Copy('000000',1,6)                                                                       + // 174 a 179 - 9(06) DATA LIMITE PARA CONCESSÃO DE DESCONTO
                            Copy('0000000000000',1,13)                                                               + // 180 a 192 - 9(13) VALOR DO DESCONTO A SER CONCEDIDO
                            Copy('0000000000000',1,13)                                                               + // 193 a 205 - 9(13) VALOR DO I.O.F. RECOLHIDO P/ NOTAS SEGURO
                            Copy('0000000000000',1,13)                                                               + // 206 a 218 - 9(13) VALOR DO ABATIMENTO A SER CONCEDIDO
                            Copy(sCPFOuCNPJ,1,002)                                                                   + // 219 a 220 - 9(02) IDENTIFICAÇÃO DO TIPO DE INSCRIÇÃO/SACADO
                            Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet2CGC.AsString),14),1,014)        + // 221 a 234 - 9(14) Nº DE INSCRIÇÃO DO SACADO (CPF/CNPJ)
                            Copy(Form7.ibDataSet2NOME.AsString+Replicate(' ',30),1,030)                              + // 235 a 264 - X(30) NOME DO SACADO
                            Copy(Replicate(' ',10),1,010)                                                            + // 265 a 274 - X(10) COMPLEMENTO DE REGISTRO
                            Copy(Form7.ibDataSet2ENDERE.AsString+Replicate(' ',40),1,040)                            + // 275 a 314 - X(40) RUA, NÚMERO E COMPLEMENTO DO SACADO
                            Copy(Form7.ibDataSet2COMPLE.AsString+Replicate(' ',12),1,012)                            + // 315 a 326 - X(12) BAIRRO DO SACADO
                            Copy(LimpaNumero(Form7.ibDataSet2CEP.AsString)+Replicate('0',8),1,008)                   + // 327 a 334 - 9(08) CEP DO SACADO
                            Copy(Form7.ibDataSet2CIDADE.AsString+Replicate(' ',15),1,015)                            + // 335 a 349 - X(15) CIDADE DO SACADO
                            Copy(Form7.ibDataSet2ESTADO.AsString+Replicate(' ',02),1,002)                            + // 350 a 351 - X(02) UF DO SACADO
                            Copy(Replicate(' ',30),1,030)                                                            + // 352 a 381 - X(30) NOME DO SACADOR OU AVALISTA
                            Copy(Replicate(' ',04),1,004)                                                            + // 382 a 385 - X(04) COMPLEMENTO DO REGISTRO
                            Copy('000000',1,6)                                                                       + // 386 a 391 - 9(06) DATA DE MORA
                            Copy('00',1,002)                                                                         + // 392 a 393 - 9(02) QUANTIDADE DE DIAS
                            Copy(' ',1,001)                                                                          + // 394 a 394 - X(01) COMPLEMENTO DO REGISTRO
                            Copy(StrZero(iReg,6,0),1,006)                                                            + // 395 a 400 - 9(06) Nº SEQÜENCIAL DO REGISTRO NO ARQUIVO
                            ''
                            );
                        end else
                        begin
                          if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '041' then // Banrisul
                          begin
                            // BANRISUL REMESSA
                            WriteLn(F,
                              Copy('1',1,001)                                                                          + // 001 a 001 - x(01) TIPO DE REGISTRO: 1 (constante)
                              Copy(Replicate(' ',16),1,016)                                                            + // 002 a 017 - x(16) BRANCOS
                              Copy(
                              Copy(LimpaNumero(Form26.MaskEdit44.Text)+'0000',1,004)+
                              LimpaNumero(Form26.MaskEdit46.Text)+Replicate('0',13)
                              ,1,13)                                                                                   + // 03 027 a 039 -  13 (9) CÓDIGO DE CEDENTE
                              Copy(Replicate(' ',07),1,007)                                                            + // 031 a 037 - x(07) BRANCOS
                              Copy(Form7.ibDataset7DOCUMENTO.AsString+Replicate(' ',25),1,025)                         + // 038 a 062 - x(25) IDENTIFICAÇÃO DO TÍTULO PARA O BENEFICIÁRIO
                              Copy(LimpaNumero(Form7.ibDataset7NOSSONUM.AsString)+'00000000000000000',1,010)           + // 063 a 072 - x(10) IDENTIFICAÇÃO DO TÍTULO PARA O BANCO (NOSSO NÚMERO)
                              Copy(Replicate(' ',32),1,032)                                                            + // 073 a 104 - x(32) MENSAGEM NO BLOQUETO
                              Copy(Replicate(' ',03),1,003)                                                            + // 105 a 107 - x(03) BRANCOS
                              Copy('1',1,001)                                                                          + // 108 a 108 - x(01) TIPO DE CARTEIRA
                              Copy(sComandoMovimento,1,002)                                                            + // 109 a 110 - x(02) CÓDIGO DE OCORRÊNCIA
                              Copy(LimpaNumero(Form7.ibDataset7NOSSONUM.AsString)+Replicate(' ',10),1,10)              + // 111 a 120 - x(10) SEU NÚMERO  *+* Nosso número banrisul
                              Copy(Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,2)                          +
                              Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),4,2)                               +
                              Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),9,2),1,006)                        + // 121 a 126 - x(06) DATA DE VENCIMENTO DO TÍTULO
                              Copy(StrZero((Form7.ibDataSet7VALOR_DUPL.AsFloat * 100),13,0),1,013)                     + // 127 a 139 - x(13) VALOR DO TÍTULO
                              Copy('041',1,003)                                                                        + // 140 a 142 - x(03) BANCO COBRADOR: 041 (constante)
                              Copy(Replicate(' ',05),1,005)                                                            + // 143 a 147 - x(05) BRANCOS
                              Copy('08',1,002)                                                                         + // 148 a 149 - x(02) TIPO DE DOCUMENTO
                              Copy('N',1,001)                                                                          + // 150 a 150 - x(01) CÓDIGO DE ACEITE
                              Copy(Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),1,2)                             +
                              Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),4,2)                                  +
                              Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),9,2),1,006)                           + // 151 a 156 - x(06) DATA DA EMISSÃO DO TÍTULO
                              Copy('23',1,002)                                                                         + // 157 a 158 - x(02) CÓDIGO DA 1ª INSTRUÇÃO - Não protestar
                              Copy('  ',1,002)                                                                         + // 159 a 160 - x(02) CÓDIGO DA 2ª INSTRUÇÃO
                              Copy(' ',1,001)                                                                          + // 161 a 161 - x(01) CÓDIGO DE MORA
                              Copy('             ',1,012)                                                              + // 162 a 173 - x(12) VALOR AO DIA OU TAXA MENSAL DE JUROS
                              Copy('      ',1,006)                                                                     + // 174 a 179 - x(06) DATA PARA CONCESSÃO DO DESCONTO
                              Copy('              ',1,013)                                                             + // 180 a 192 - x(13) VALOR DO DESCONTO A SER CONCEDIDO
                              Copy('              ',1,013)                                                             + // 193 a 205 - x(13) VALOR IOF
                              Copy('              ',1,013)                                                             + // 206 a 218 - x(13) VALOR DO ABATIMENTO
                              Copy(sCPFOuCNPJ,1,002)                                                                   + // 219 a 220 - x(02) TIPO DE INSCRIÇÃO DO PAGADOR
                              Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet2CGC.AsString),14),1,014)        + // 221 a 234 - x(14) NÚMERO DE INSCRIÇÃO DO PAGADOR NO MF
                              Copy(ConverteAcentosPHP(Form7.ibDataSet2NOME.AsString)+Replicate(' ',35),1,035)          + // 235 a 269 - x(35) NOME DO PAGADOR
                              Copy(Replicate(' ',05),1,005)                                                            + // 270 a 274 - x(05) BRANCOS
                              Copy(ConverteAcentosPHP(Form7.ibDataSet2ENDERE.AsString)+Replicate(' ',40),1,040)        + // 275 a 314 - x(40) ENDEREÇO DO PAGADOR
                              Copy(Replicate(' ',07),1,007)                                                            + // 315 a 321 - x(07) BRANCOS
                              Copy(Replicate(' ',03),1,003)                                                            + // 322 a 324 - x(03) TAXA PARA MULTA APÓS O VENCIMENTO
                              Copy(Replicate(' ',02),1,002)                                                            + // 325 a 326 - x(02) NÚMERO DE DIAS PARA MULTA APÓS O VENCIMENTO
                              Copy(LimpaNumero(Form7.ibDataSet2CEP.AsString)+Replicate('0',40),1,008)                  + // 327 a 334 - x(08) CEP
                              Copy(ConverteAcentosPHP(Form7.ibDataSet2CIDADE.AsString)+Replicate(' ',15),1,015)        + // 335 a 349 - x(15) CIDADE DO PAGADOR (PRAÇA DE COBRANÇA)
                              Copy(Form7.ibDataSet2ESTADO.AsString+Replicate(' ',02),1,002)                            + // 350 a 351 - x(02) UF – UNIDADE DA FEDERAÇÃO
                              Copy(Replicate(' ',04),1,004)                                                            + // 352 a 355 - x(04) TAXA AO DIA PARA PAGAMENTO ANTECIPADO
                              Copy(Replicate(' ',02),1,002)                                                            + // 356 a 357 - x(02) BRANCOS
                              Copy('              ',1,012)                                                             + // 358 a 369 - x(12) VALOR PARA CÁLCULO DO DESCONTO
                              Copy(Replicate(' ',02),1,002)                                                            + // 370 a 371 - x(02) NÚMERO DE DIAS PARA PROTESTO OU DE DEVOLUÇÃO AUTOMÁTICA
                              Copy(Replicate(' ',23),1,023)                                                            + // 372 a 394 - x(23) BRANCOS
                              Copy(StrZero(iReg,6,0),1,006)                                                            + // 395 a 400 - x(06) NÚMERO SEQUENCIAL DO REGISTRO
                              ''
                              );
                          end else
                          begin
                            // Banco do Brasil REMESSA
                            WriteLn(F,
                              Copy('7',1,001)                                                                          + // 01.7 001 a 001 9(001) Identificação do Registro Detalhe: 7 (sete)
                              Copy('02',1,002)                                                                         + // 02.7 002 a 003 9(002) Tipo de Inscrição do Cedente 22
                              Copy(LimpaNumero(Form7.IBDataSet13CGC.AsString)+Replicate(' ',14),1,014)                 + // 03.7 004 a 017 9(014) Número do CPF/CNPJ do Cedente
                              Copy(Copy(Form26.MaskEdit44.Text+'    ',1,4),1,004)                                      + // 04.7 018 a 021 9(004) Prefixo da Agência 02
                              Copy(Copy(AllTrim(Form26.MaskEdit44.Text)+'000000',6,1),1,001)                           + // 05.7 022 a 022 X(001) Dígito Verificador - D.V. - do Prefixo da Agência 02
                              Copy(Right('000000000'+AllTrim(StrTran(Form26.MaskEdit46.Text,'-','')),9),1,8)           + // 06.7 023 a 030 9(008) Número da Conta Corrente do Cedente 02
                              Copy(Right('000000000'+AllTrim(StrTran(Form26.MaskEdit46.Text,'-','')),9),9,1)           + // 07.7 031 a 031 X(001) Dígito Verificador - D.V. - do Número da Conta Corrente do Cedente 02
                              Copy(Right('000000'+LimpaNumero(Form26.MaskEdit50.Text),7),1,7)                          + // 08.7 032 a 038 9(007) Número do Convênio de Cobrança do Cedente 02
                              Copy(Replicate(' ',25),1,025)                                                            + // 09.7 039 a 063 X(025) Código de Controle da Empresa 23
                              Copy(LimpaNumero(Form7.ibDataset7NOSSONUM.AsString)+'00000000000000000',1,017)           + // 10.7 064 a 080 9(017) Nosso-Número 06
                              Copy('00',1,002)                                                                         + // 11.7 081 a 082 9(002) Número da Prestação: “00” (Zeros)
                              Copy('00',1,002)                                                                         + // 12.7 083 a 084 9(002) Grupo de Valor: “00” (Zeros)
                              Copy('   ',1,003)                                                                        + // 13.7 085 a 087 X(003) Complemento do Registro: “Brancos”
                              Copy(' ',1,001)                                                                          + // 14.7 088 a 088 X(001) Indicativo de Mensagem ou Sacador/Avalista 13
                              Copy('   ',1,003)                                                                        + // 15.7 089 a 091 X(003) Prefixo do Título: “Brancos”
                              Copy(AllTrim(LimpaNumero(Form26.MaskEdit43.Text))+'000000',3,3)                          + // 16.7 092 a 094 9(003) Variação da Carteira 02
                              Copy('0',1,001)                                                                          + // 17.7 095 a 095 9(001) Conta Caução: “0” (Zero)
                              Copy('000000',1,006)                                                                     + // 18.7 096 a 101 9(006) Número do Borderô: “000000” (Zeros)
                              Copy('     ',1,005)                                                                      + // 19.7 102 a 106 X(005) Tipo de Cobrança 24
                              Copy(AllTrim(LimpaNumero(Form26.MaskEdit43.Text))+'00',1,002)                            + // 20.7 107 a 108 9(002) Carteira de Cobrança 25
                              Copy(sComandoMovimento,1,002)                                                            + // 21.7 109 a 110 9(002) Comando 20
                              Copy(AllTrim(Form7.ibDataset7DOCUMENTO.AsString)+Replicate(' ',10),1,10)                 + // 22.7 111 a 120 X(010) Seu Número/Número do Título Atribuído pelo Cedente 05
                              Copy(Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,2)                          +
                              Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),4,2)                               +
                              Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),9,2),1,006)                        + // 23.7 121 a 126 9(006) Data de Vencimento 08
                              Copy(StrZero((Form7.ibDataSet7VALOR_DUPL.AsFloat * 100),13,0),1,013)                     + // 24.7 127 a 139 9(011) v99 Valor do Título 19
                              Copy(LimpaNumero(Form26.MaskEdit42.Text)+'000',1,003)                                    + // 25.7 140 a 142 9(003) Número do Banco: “001”
                              Copy('0000',1,004)                                                                       + // 26.7 143 a 146 9(004) Prefixo da Agência Cobradora: “0000” 26
                              Copy('     ',5,001)                                                                      + // 27.7 147 a 147 X(001) Dígito Verificador do Prefixo da Agência Cobradora: “Brancos”
                              Copy('01',1,002)                                                                         + // 28.7 148 a 149 9(002) Espécie de Titulo 07
                              Copy('N',1,001)                                                                          + // 29.7 150 a 150 X(001) Aceite do Título: 27
                              Copy(Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),1,2)                             +
                              Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),4,2)                                  +
                              Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),9,2),1,006)                           + // 30.7 151 a 156 9(006) Data de Emissão: Informe no formato “DDMMAA” 28 31.7
                              Copy('00',1,002)                                                                         + // 31.7 157 a 158 9(002) Instrução Codificada 09
                              Copy('01',1,002)                                                                         + // 32.7 159 a 160 9(002) Instrução Codificada 09
                              Copy('00000000000000',1,013)                                                             + // 33.7 161 a 173 9(011) v99 Juros de Mora por Dia de Atraso 10
                              Copy('000000',1,006)                                                                     + // 34.7 174 a 179 9(006) Data Limite para Concessão de Desconto/Data de Operação do BBVendor/Juros de Mora. 11
                              Copy('00000000000000',1,013)                                                             + // 35.7 180 a 192 9(011)v99 Valor do Desconto 29
                              Copy('00000000000000',1,013)                                                             + // 36.7 193 a 205 9(011)v99 Valor do IOF/Qtde Unidade Variável. 30
                              Copy('00000000000000',1,013)                                                             + // 37.7 206 a 218 9(011)v99 Valor do Abatimento 31
                              Copy(sCPFOuCNPJ,1,002)                                                                   + // 38.7 219 a 220 9(002) Tipo de Inscrição do Sacado 32
                              Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet2CGC.AsString),14),1,014)        + // 39.7 221 a 234 9(014) Número do CNPJ ou CPF do Sacado 33
                              Copy(Form7.ibDataSet2NOME.AsString+Replicate(' ',37),1,037)                              + // 40.7 235 a 271 X(037) Nome do Sacado
                              Copy('   ',1,003)                                                                        + // 41.7 272 a 274 X(003) Complemento do Registro: “Brancos”
                              Copy(Form7.ibDataSet2ENDERE.AsString+Replicate(' ',40),1,040)                            + // 42.7 275 a 314 X(040) Endereço do Sacado
                              Copy(Form7.ibDataSet2COMPLE.AsString+Replicate(' ',40),1,012)                            + // 43.7 315 a 326 X(012) Bairro do Sacado
                              Copy(LimpaNumero(Form7.ibDataSet2CEP.AsString)+Replicate('0',08),1,008)                  + // 44.7 327 a 334 9(008) CEP do Endereço do Sacado
                              Copy(Form7.ibDataSet2CIDADE.AsString+Replicate(' ',15),1,015)                            + // 45.7 335 a 349 X(015) Cidade do Sacado
                              Copy(Form7.ibDataSet2ESTADO.AsString+Replicate(' ',02),1,002)                            + // 46.7 350 a 351 X(002) UF da Cidade do Sacado
                              Copy(Replicate(' ',40),1,040)                                                            + // 47.7 352 a 391 X(040) Observações/Mensagem ou Sacador/Avalista 13
                              Copy('00',1,002)                                                                         + // 48.7 392 a 393 X(002) Número de Dias Para Protesto 34
                              Copy(' ',1,001)                                                                          + // 49.7 394 a 394 X(001) Complemento do Registro: “Brancos”
                              Copy(StrZero(iReg,6,0),1,006)                                                            + // 50.7 395 a 400 9(006) Seqüencial de Registro 35
                              ''
                              );
                          end;
                        end;
                      end;
                    end;
                  end;
                end;
              except
                on E: Exception do
                begin
                  Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
                end;
              end;
            except
              on E: Exception do
              begin
                Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
              end;
            end;

            vTotal := vTotal + Form7.ibDataSet7VALOR_DUPL.AsFloat;
          except
          end;
        end;
      end;
      Form7.ibDataSet7.Next;
    end;

    // TAILER
    if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '041' then // Banrisul
    begin
      // BANRISUL TAILER
      WriteLn(F,
        Copy('9',1,001)                                                                                                            + // 001 a 001 - 9(001)      Código do registro = 9
        Copy(Replicate(' ',26),1,26)                                                                                               + // 002 a 027 - X(26)       Brancos
        Copy(StrZero(vTotal*100,13,0),1,013)                                                                                       + // 028 a 040 - 9(013)      Valor total dos títulos (informação obrigatória)
        Copy(Replicate(' ',354),1,354)                                                                                             + // 041 a 394 - X(354)      Brancos
        Copy(StrZero(iReg+1,6,0),1,006)                                                                                            + // 395 a 400 - 9(006)      Número sequencial do registro no arquivo
        ''
        );
    end else
    begin
      if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '756' then
      begin
        // SICOOB TAILER
        WriteLn(F,
          Copy('9',1,001)                                                                                                            + // 1 Identificação Registro Trailler: "9"
          Copy(Replicate(' ',193),1,193)                                                                                             + // 2 Complemento do Registro: Brancos
          Copy(AllTrim(Edit4.Text)+' '+AllTrim(Edit5.Text)+' '+AllTrim(Edit6.Text)+' '+AllTrim(Edit7.Text)+Replicate(' ',200),001,40)+ // 3 "Mensagem responsabilidade Beneficiário:
          Copy(AllTrim(Edit4.Text)+' '+AllTrim(Edit5.Text)+' '+AllTrim(Edit6.Text)+' '+AllTrim(Edit7.Text)+Replicate(' ',200),041,40)+ // 4 "Mensagem responsabilidade Beneficiário:
          Copy(AllTrim(Edit4.Text)+' '+AllTrim(Edit5.Text)+' '+AllTrim(Edit6.Text)+' '+AllTrim(Edit7.Text)+Replicate(' ',200),081,40)+ // 5 "Mensagem responsabilidade Beneficiário:
          Copy(AllTrim(Edit4.Text)+' '+AllTrim(Edit5.Text)+' '+AllTrim(Edit6.Text)+' '+AllTrim(Edit7.Text)+Replicate(' ',200),121,40)+ // 6 "Mensagem responsabilidade Beneficiário:
          Copy(AllTrim(Edit4.Text)+' '+AllTrim(Edit5.Text)+' '+AllTrim(Edit6.Text)+' '+AllTrim(Edit7.Text)+Replicate(' ',200),161,40)+ // 7 "Mensagem responsabilidade Beneficiário:
          Copy(StrZero(iReg+1,6,0),1,006)                                                                                            + // 8 Seqüencial do Registro: Incrementado em 1 a cada registro
          ''
          );
      end else
      begin
        if (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '033') or (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '353') then
        begin
          // SANTANDER TAILER
          WriteLn(F,
            Copy('9',1,001)                                                                                                            + // 001 a 001 - 9(001)      Código do registro = 9
            Copy(StrZero(iReg+1,6,0),1,006)                                                                                            + // 002 a 007 - 9(006)      Quantidade de documentos no arquivo informação obrigatória)
            Copy(StrZero(vTotal*100,13,0),1,013)                                                                                       + // 008 a 020 - 9(011)v99   Valor total dos títulos (informação obrigatória)
            Copy(Replicate('0',374),1,374)                                                                                             + // 021 a 394 - 9(374)      Zeros
            Copy(StrZero(iReg+1,6,0),1,006)                                                                                            + // 395 a 400 - 9(006)      Número sequencial do registro no arquivo
            ''
            );
        end else
        begin
          WriteLn(F,
            Copy('9',1,001)                                                                                                            + // 01.9 001 a 001 9(001) Identificação do Registro Trailer: “9”
            Copy(Replicate(' ',393),1,393)                                                                                             + // 02.9 002 a 394 X(393) Complemento do Registro: “Brancos”
            Copy(StrZero(iReg+1,6,0),1,006)                                                                                            + // 03.9 395 a 400 9(006) Número Seqüencial do Registro no Arquivo
            ''
            );
        end;
      end;
    end;

    CloseFile(F); // Fecha o arquivo

    if iReg = 1 then
    begin
      DeleteFile(Form1.sAtual+'\remessa\'+Form1.sArquivoRemessa);
      Form1.sArquivoRemessa := '';
      
      ShowMessage('Não existe movimento, o arquivo não foi gerado.');
    end;
  except
    on E: Exception do
    begin
      Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
    end;
  end;

  Form7.ibDataSet7.EnableControls;
end;

procedure TForm25.btnCNAB240Click(Sender: TObject);
var
  vTotal : Real;
  F: TextFile;
  sDigitoAgencia,
  sCodigodoJurosdeMora,
  sDatadoJurosdeMora,
  sDVDaAgencia,
  sCodigoParaBaixa,
  sNumeroDeDiasParaBaixa,
  sEspecieDoTitulo,
  sTipoDocumento,
  sNumerodoDocumento,
  sFormaDeCadastrar,
  sCodigoDaCarteira,
  sDigitocontacorrente, sNumerocontaCorrente,
  sLayoutdoLote, sDensidade, sLayoutArquivo,
  sCodigoDoConvenio, sNomeDoBanco, sComandoMovimento, sParcela, sCPFOuCNPJ: String;
  I, iReg, iRemessa, iLote : Integer;
begin
  // CNAB 240
  try
    try
      ForceDirectories(pchar(Form1.sAtual + '\remessa'));
    except
    end;

    if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '748' then
    begin
      // SICREDI
      Form1.sArquivoRemessa := AllTrim(Form26.MaskEdit46.Text)+Copy('123456789OND',Month(Date),1)+StrZero(Day(date),2,0)+'.CRM';

      I := 0;

      while FileExists(Form1.sAtual+'\remessa\'+Form1.sArquivoRemessa) do
      begin
        I := I + 1;
        Form1.sArquivoRemessa := AllTrim(Form26.MaskEdit46.Text)+Copy('123456789OND',Month(Date),1)+StrZero(Day(date),2,0)+'.'+StrZero(I,3,0);
      end;
    end else
    begin
      Form1.sArquivoRemessa := Copy(StrTran(DateToStr(Date),'/','_')+DiaDaSemana(Date)+replicate('_',10),1,14)+StrTran(TimeToStr(Time),':','_')+'.txt';
    end;

    AssignFile(F,Form1.sAtual+'\remessa\'+Form1.sArquivoRemessa);
    Rewrite(F);   // Abre para gravação

    // Criar um generator para cada banco
    try
      try
        Form7.ibDataset99.Close;
        Form7.ibDataset99.SelectSql.Clear;
        Form7.ibDataset99.SelectSql.Add('select gen_id(G_'+Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+',1) from rdb$database');
        Form7.ibDataset99.Open;

        iRemessa := StrToInt(Form7.ibDataset99.FieldByname('GEN_ID').AsString);
      except
        try
          Form7.ibDataset99.Close;
          Form7.ibDataset99.SelectSql.Clear;
          Form7.ibDataset99.SelectSql.Add('create generator G_'+Copy(AllTrim(Form26.MaskEdit42.Text),1,3));
          Form7.ibDataset99.Open;

          Form7.ibDataset99.Close;
          Form7.ibDataset99.SelectSql.Clear;
          Form7.ibDataset99.SelectSql.Add('set generator G_'+Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+' to 1');
          Form7.ibDataset99.Open;
        except
        end;

        iRemessa := 1;
      end;
    except
      iRemessa := 1
    end;

    // Zerezima
    iReg    := 2;
    vTotal  := 0;
    iLote   := 1;

    if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '001' then
    begin
      // BANCO DO BRASIL
      if Pos('-',Form26.MaskEdit44.Text) = 0 then ShowMessage('Configure o código da agência 0000-0');
      if Pos('-',Form26.MaskEdit46.Text) = 0 then ShowMessage('Configure o Número da Código do Cedente 00000-0');
      if Pos('/',Form26.MaskEdit43.Text) = 0 then ShowMessage('Configure a carteira/variação 00/000');

      sCodigoDoConvenio      := Copy(StrZero(StrToInt('0'+LimpaNumero(Form26.MaskEdit50.Text)),9,0),1,9)+'0014'+Copy(AllTrim(Form26.MaskEdit43.Text)+'00/000',1,2)+Copy(AllTrim(Form26.MaskEdit43.Text)+'00/000',4,3)+'  ';
      sNomeDoBanco           := 'BANCO DO BRASIL S.A.';
      sCodigoDoConvenio      := Copy(StrZero(StrToInt('0'+LimpaNumero(Form26.MaskEdit50.Text)),9,0),1,9)+'0014'+Copy(AllTrim(Form26.MaskEdit43.Text)+'00/000',1,2)+Copy(AllTrim(Form26.MaskEdit43.Text)+'00/000',4,3)+'  ';
      sLayoutArquivo         := '000';
      sDensidade             := '06250';
      sLayoutdoLote          := '000';
      sNumeroContaCorrente   := Right('000000000000'+Copy(Form26.MaskEdit46.Text,1,Pos('-',Form26.MaskEdit46.Text)-1),12);
      sDigitocontacorrente   := Copy(Right(Replicate(' ',13)+Form26.MaskEdit46.Text,1),1,1);
      sCodigoDaCarteira      := '7';
      sFormaDeCadastrar      := '1';
      sTipoDocumento         := '1';
      sEspecieDoTitulo       := '02';
      sNumeroDeDiasParaBaixa := '   ';
      sCodigoParaBaixa       := '0';
      sDVDaAgencia           := Copy(Copy(Form26.MaskEdit44.Text+'0000-0',6,1),1,1);
      sDigitoAgencia         := '0';
    end else
    begin
      if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '756' then
      begin
        // SICOOB
        sNomeDoBanco           := 'SICOOB';
        sCodigoDoConvenio      := Copy(Replicate(' ',20),1,20);
        sLayoutArquivo         := '081';
        sDensidade             := '00000';
        sLayoutdoLote          := '040';
        sNumeroContaCorrente   := Right('000000000000'+Copy(Form7.ibDataSet11CONTA.AsString,1,Pos('-',Form7.ibDataSet11CONTA.AsString)-1),12);
        sDigitocontacorrente   := Copy(Right(Replicate(' ',13)+Form7.ibDataSet11CONTA.AsString,1),1,1);
        sCodigoDaCarteira      := '1';
        sFormaDeCadastrar      := '0';
        sTipoDocumento         := ' ';
        sEspecieDoTitulo       := '02';
        sNumeroDeDiasParaBaixa := '   ';
        sCodigoParaBaixa       := '0';
        sDVDaAgencia           := Copy(Copy(Form26.MaskEdit44.Text+'0000-0',6,1),1,1);
        sDigitoAgencia         := '0';
      end else
      begin
        if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '748' then
        begin
          // SICREDI
          sNomeDoBanco           := 'SICREDI';
          sCodigoDoConvenio      := Copy(Replicate(' ',20),1,20);
          sLayoutArquivo         := '081';
          sDensidade             := '01600';
          sLayoutdoLote          := '040';
          sNumeroContaCorrente   := Right('000000000000'+Copy(Form7.ibDataSet11CONTA.AsString,1,Pos('-',Form7.ibDataSet11CONTA.AsString)-1),12);
          sDigitocontacorrente   := Copy(Right(Replicate(' ',13)+Form7.ibDataSet11CONTA.AsString,1),1,1);
          sCodigoDaCarteira      := '1';
          sFormaDeCadastrar      := '1';
          sTipoDocumento         := '1';
          sEspecieDoTitulo       := '03';
          sNumeroDeDiasParaBaixa := '060';
          sCodigoParaBaixa       := '1';
          sDVDaAgencia           := ' ';
          sDigitoAgencia         := '0';
        end else
        begin
          if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '085' then
          begin
            // AILOS
            sNomeDoBanco           := 'AILOS';
            sCodigoDoConvenio      := Copy(AllTrim(Form26.MaskEdit50.Text)+REplicate(' ',20),1,20);
            sLayoutArquivo         := '087';
            sDensidade             := '00000';
            sLayoutdoLote          := '045';
            sNumeroContaCorrente   := Copy(StrZero(StrToInt('0'+LimpaNumero(Form26.MaskEdit46.Text)),13,0),1,12);
            sDigitocontacorrente   := Copy(StrZero(StrToInt('0'+LimpaNumero(Form26.MaskEdit46.Text)),13,0),13,1);
            sCodigoDaCarteira      := '1';
            sFormaDeCadastrar      := '1';
            sTipoDocumento         := '1';
            sEspecieDoTitulo       := '02';
            sNumeroDeDiasParaBaixa := '   ';
            sCodigoParaBaixa       := '2';
            sDVDaAgencia           := Copy(Copy(Form26.MaskEdit44.Text+'0000-0',6,1),1,1);
            sDigitoAgencia         := ' ';
          end else
          begin
            sNomeDoBanco           := 'BANCO PADRAO CNAB';
            sCodigoDoConvenio      := Copy(Replicate(' ',20),1,20);
            sLayoutArquivo         := '000';
            sDensidade             := '00000';
            sLayoutdoLote          := '000';
            sNumeroContaCorrente   := Copy(StrZero(StrToInt('0'+LimpaNumero(Form26.MaskEdit46.Text)),13,0),1,12);
            sDigitocontacorrente   := Copy(StrZero(StrToInt('0'+LimpaNumero(Form26.MaskEdit46.Text)),13,0),13,1);
            sCodigoDaCarteira      := '1';
            sFormaDeCadastrar      := '1';
            sTipoDocumento         := '1';
            sEspecieDoTitulo       := '02';
            sNumeroDeDiasParaBaixa := '   ';
            sCodigoParaBaixa       := '0';
            sDVDaAgencia           := Copy(Copy(Form26.MaskEdit44.Text+'0000-0',6,1),1,1);
            sDigitoAgencia         := '0';
          end;
        end;
      end;
    end;
    
    try
      // Registro Header de Arquivo (Tipo = 0)
      // Banco do Brasil  HEADER
      WriteLn(F,Copy(AllTrim(Form26.MaskEdit42.Text),1,3)                                       + // 001 a 003 (003) Código do Banco na Compensação
        '0000'                                                                                    + // 004 a 007 (004) Lote de Serviço
        '0'                                                                                       + // 008 a 008 (001) Tipo de Registro "0" header
        Copy(Replicate(' ',9),1,9)                                                                + // 009 a 017 (009) Uso Exclusivo FEBRABAN / CNAB
        Copy('2',1,1)                                                                             + // 018 a 018 (001) Tipo de Inscrição da Empresa
        Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet13CGC.AsString),14),1,014)        + // 019 a 032 (014) Número de Inscrição da Empresa
        copy(sCodigoDoconvenio,1,20)                                                              + // 033 a 052 (020) Código do Convênio no Banco
        Copy('0'+Copy(Form26.MaskEdit44.Text+'0000-0',1,4),1,5)                                   + // 053 a 057 (005) Agência Mantenedora da Conta
        Copy(sDVdaAgencia,1,1)                                                                    + // 058 a 058 (001) Dígito Verificador da Agência
        Copy(sNumeroContaCorrente,1,12)                                                           + // 059 a 070 (012) Número da Conta Corrente
        Copy(sDigitocontacorrente,1,1)                                                            + // 071 a 071 (001) Dígito Verificador da Conta
        Copy(sDigitoAgencia,1,1)                                                                  + // 072 a 072 (001) Dígito Verificador da Ag/Conta
        Copy(UpperCase(Form7.IbDataSet13NOME.AsString)+Replicate(' ',30),1,030)                   + // 073 a 102 (030) Nome da Empresa
        Copy(sNomeDoBanco+replicate(' ',30),1,30)                                                 + // 103 a 132 (030) Nome do Banco
        Copy(Replicate(' ',10),1,10)                                                              + // 133 a 142 (010) Uso Exclusivo FEBRABAN / CNAB
        copy('1',1,1)                                                                             + // 143 a 143 (001) Código Remessa '1'
        Copy(Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),7,4),1,008) + // 144 a 151 (008) Data de Geração do Arquivo
        Copy(StrTran(TimeToStr(Time),':','')+'000000',1,006)                                      + // 152 a 157 (006) Hora de Geração do Arquivo
        Copy(StrZero(iRemessa,6,0),1,006)                                                         + // 158 a 163 (006) Número Seqüencial do Arquivo
        Copy(sLayoutArquivo,1,3)                                                                  + // 164 a 166 (003) No da Versão do Layout do Arquivo
        Copy(sDensidade,1,5)                                                                      + // 167 a 171 (005) Densidade de Gravação do Arquivo
        Copy(Replicate(' ',20),1,20)                                                              + // 172 a 191 (020) Para Uso Reservado do Banco
        Copy(Replicate(' ',20),1,20)                                                              + // 192 a 211 (020) Para Uso Reservado da Empresa
        Copy(Replicate(' ',29),1,29)                                                              // 212 a 240 (029) Uso Exclusivo FEBRABAN / CNAB
        );

      // Registro Header de Lote (Tipo = 1)
      WriteLn(F,Copy(AllTrim(Form26.MaskEdit42.Text),1,3)                                       + // 001 a 003 (003) Código do Banco na Compensação
        '0001'                                                                                    + // 004 a 007 (004) Lote de Serviço
        '1'                                                                                       + // 008 a 008 (001) Tipo de Registro
        'R'                                                                                       + // 009 a 009 (001) Tipo de Operação
        '01'                                                                                      + // 010 a 011 (002) Tipo de Serviço
        Copy(Replicate(' ',002),1,002)                                                            + // 012 a 013 (002) Uso Exclusivo da FEBRABAN/CNAB
        Copy(sLayoutdoLote,1,3)                                                                   + // 014 a 016 (003) Nº da Versão do Layout do Lote
        ' '                                                                                       + // 017 a 017 (001) Uso Exclusivo da FEBRABAN/CNAB
        Copy('2',1,1)                                                                             + // 018 a 018 (001) Tipo de Inscrição da Empresa
        Copy(Right(Replicate('0',15)+LimpaNumero(Form7.IBDataSet13CGC.AsString),15),1,015)        + // 019 a 033 (015) Número de Inscrição da Empresa
        copy(sCodigoDoconvenio,1,20)                                                              + // 034 a 053 (020) Código do Convênio no Banco
        Copy(('0'+Copy(Form26.MaskEdit44.Text+'0000-0',1,4)),1,5)                                 + // 054 a 058 (005) Agência Mantenedora da Conta
        Copy(sDVdaAgencia,1,1)                                                                    + // 059 a 059 (001) Dígito Verificador da Agência
        Copy(sNumeroContaCorrente,1,12)                                                           + // 060 a 071 (012) Número da Conta Corrente
        Copy(sDigitocontacorrente,1,1)                                                            + // 072 a 072 (001) Dígito Verificador da Conta
        Copy(' ',1,1)                                                                             + // 073 a 073 (001) Dígito Verificador da Ag/Conta
        Copy(UpperCase(Form7.IbDataSet13NOME.AsString)+Replicate(' ',30),1,030)                   + // 074 a 103 (030) Nome da Empresa
        Copy(Replicate(' ',40),1,40)                                                              + // 104 a 143 (040) Mensagem 1
        Copy(Replicate(' ',40),1,40)                                                              + // 144 a 183 (040) Mensagem 2
        Copy(StrZero(iRemessa,8,0),1,008)                                                         + // 184 a 191 (008) Número Remessa/Retorno
        Copy(Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),7,4),1,008) + // 192 a 199 (008) Data de Gravação Remessa/Retorno
        Copy('00000000',1,8)                                                                      + // 200 a 207 (008) Data do Crédito
        Copy(Replicate(' ',33),1,33)                                                              // 208 a 240 (033) Uso Exclusivo FEBRABAN / CNAB
        );
    except
      on E: Exception do
      begin
        Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
      end;
    end;

    Form7.ibDataSet7.DisableControls;
    Form7.ibDataSet7.First;

    while not Form7.ibDataSet7.Eof do
    begin
      if Form7.ibDataSet7ATIVO.AsFloat <> 1 then
      begin
        if (UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'REMESSA ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')') or
           (UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')BAIXA') or
           (UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')VENCIMENTO') or
           (UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')EXCLUIR') then
        begin
          try
            Form7.ibDataSet2.Close;
            Form7.ibDataSet2.Selectsql.Clear;
            Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet7NOME.AsString)+' ');  //
            Form7.ibDataSet2.Open;

            sCPFOuCNPJ := '01';
            if Length(LimpaNumero(Form7.IBDataSet2CGC.AsString)) = 14 then sCPFOuCNPJ := '02' else sCPFOuCNPJ := '01';

            sParcela := '01';

            if Ord(Form7.ibDataSet7DOCUMENTO.AsString[Length(Trim(Form7.ibDataSet7DOCUMENTO.AsString))]) >= 64 then
            begin
              sParcela := StrZero((Ord(Form7.ibDataSet7DOCUMENTO.AsString[Length(Trim(Form7.ibDataSet7DOCUMENTO.AsString))])-64),2,0); //converte a letra em número
            end else
            begin
              sParcela := '01';
            end;

            if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '756' then
            begin
              sNumerodoDocumento := Copy(StrZero(StrToFloat('0'+LimpaNumero(Form7.ibDataset7NOSSONUM.AsString)),10,0)+sParcela+'014     ',1,20);
            end else
            begin
              sNumerodoDocumento := Copy(LimpaNumero(Form7.ibDataset7NOSSONUM.AsString)+Replicate(' ',20),1,20);
            end;
          except
            on E: Exception do
            begin
              Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
            end;
          end;

          try
            // Código de Movimento usados pelo Small Commerce
            // '01' = Entrada de Títulos
            // '02' = Pedido de Baixa
            // '06' = Alteração de Vencimento
            sComandoMovimento := '01';

            if UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text)+'000',1,3)+')BAIXA'       then sComandoMovimento := '02';
            if UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text)+'000',1,3)+')VENCIMENTO'  then sComandoMovimento := '06';
            if UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text)+'000',1,3)+')EXCLUIR'     then sComandoMovimento := '99';

            if UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')BAIXA' then
            begin
              Form7.ibDataSet7.Edit;
              Form7.ibDataSet7PORTADOR.AsString := 'EM CARTEIRA';
              Form7.ibDataSet7.Post;
            end else
            begin
              if Form7.ibDataSet7PORTADOR.AsString <> 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')' then
              begin
                Form7.ibDataSet7.Edit;
                Form7.ibDataSet7PORTADOR.AsString := 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')';
                Form7.ibDataSet7.Post;
              end;
            end;


            try
              // Registros de Detalhe (Tipo = 3)
              // Registro Detalhe - Segmento P (Obrigatório - Remessa)
              iReg := iReg + 1;

              if (Form1.fTaxa = 0) and (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '748') then
              begin
                sCodigodoJurosdeMora := '3';          // Código do Juros de Mora
                sDatadoJurosdeMora   := '00000000';   // Data do Juros de Mora
              end else
              begin
                sCodigodoJurosdeMora := '2'; // Código do Juros de Mora
                sDatadoJurosdeMora   := Copy(Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime+1),1,2)  +
                                        Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime+1),4,2)       +
                                        Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime+1),7,4),1,008); // Data do Juros de Mora
              end;
              
              WriteLn(F,
                Copy(AllTrim(Form26.MaskEdit42.Text),1,3)                                                 + // 001 a 003 (003) Código do Banco na Compensação
                Copy('0001',1,4)                                                                          + // 004 a 007 (004) Lote de Serviço
                copy('3',1,1)                                                                             + // 008 a 008 (001) Tipo de Registro
                Copy(StrZero(iReg-2,5,0),1,005)                                                           + // 009 a 013 (005) Nº Sequencial do Registro no Lote
                Copy('P',1,1)                                                                             + // 014 a 014 (001) Cód. Segmento do Registro Detalhe
                Copy(' ',1,1)                                                                             + // 015 a 015 (001) Uso Exclusivo FEBRABAN/CNAB
                Copy(sComandoMovimento,1,2)                                                               + // 016 a 017 (002) Código de Movimento Remessa
                Copy('0'+Copy(Form26.MaskEdit44.Text+'0000-0',1,4),1,5)                                   + // 018 a 022 (005) Agência Mantenedora da Conta
                Copy(sDVdaAgencia,1,1)                                                                    + // 023 a 023 (001) Dígito Verificador da Agência
                Copy(sNumeroContaCorrente,1,12)                                                           + // 024 a 035 (012) Número da Conta Corrente
                Copy(sDigitocontacorrente,1,1)                                                            + // 036 a 036 (001) Dígito Verificador da Conta
                Copy(' ',1,1)                                                                             + // 037 a 037 (001) Dígito Verificador da Ag/Conta
                Copy(sNumerodoDocumento,1,20)                                                             + // 038 a 057 (020) Número do Documento de Cobrança
                Copy(sCodigoDaCarteira,1,1)                                                               + // 058 a 058 (001) Código da Carteira
                Copy(sFormaDeCadastrar,1,1)                                                               + // 059 a 059 (001) Forma de Cadastr. do Título no Banco
                Copy(sTipoDocumento,1,1)                                                                  + // 060 a 060 (001) Tipo de Documento
                Copy('2',1,1)                                                                             + // 061 a 061 (001) Identificação da Emissão do Boleto de Pagamento
                Copy('2',1,1)                                                                             + // 062 a 062 (001) Identificação da Distribuição
                Copy(AllTrim(Form7.ibDataset7DOCUMENTO.AsString)+Replicate(' ',15),1,15)                  + // 067 a 077 (015) Número do Documento de Cobrança
                Copy(Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,2)                           +
                Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),4,2)                                +
                Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),7,4),1,008)                         + // 078 a 085 (008) Data de Vencimento do Título
                Copy(StrZero((Form7.ibDataSet7VALOR_DUPL.AsFloat * 100),15,0),1,015)                      + // 086 a 100 (013)+(2) Valor Nominal do Título
                Copy('00000',1,5)                                                                         + // 101 a 105 (005) Agência Encarregada da Cobrança
                Copy(' ',1,001)                                                                           + // 106 a 106 (001) Dígito Verificador da Agência
                Copy(sEspecieDoTitulo,1,2)                                                                + // 107 a 108 (002) Espécie do Título
                Copy('N',1,1)                                                                             + // 109 a 109 (001) Identific. de Título Aceito/Não Aceito
                Copy(Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),1,2)                              +
                Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),4,2)                                   +
                Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),7,4),1,008)                            + // 110 a 117 (008) Data da Emissão do Título
                Copy(sCodigodoJurosdeMora,1,1)                                                            + // 118 a 118 (001) Código do Juros de Mora
                sDatadoJurosdeMora                                                                        + // 119 a 126 (008) Data do Juros de Mora
                Copy(StrZero((Form1.fTaxa * 30 * 100),15,0),1,015)                                        + // 127 a 141 (013)+(2) Juros de Mora por Dia/Taxa
                Copy('0',1,1)                                                                             + // 142 a 142 (001) Código do Desconto
                Copy('00000000',1,8)                                                                      + // 143 a 150 (008) Data do Desconto
                Copy(StrZero(0,15,0),1,015)                                                               + // 151 a 165 (013)+(2) Valor / Percentual a ser Concedido
                Copy('000000000000000',1,15)                                                              + // 166 a 180 (013)+(2) Valor do IOF a ser Recolhido
                Copy('000000000000000',1,15)                                                              + // 181 a 195 (013)+(2) Valor do Abatimento
                Copy(AllTrim(Form7.ibDataset7DOCUMENTO.AsString)+Replicate(' ',25),1,25)                  + // 196 a 220 (025) Identificação do Título na Empresa
                Copy('3',1,1)                                                                             + // 221 a 221 (001) Código para Protesto
                Copy('00',1,2)                                                                            + // 222 a 223 (002) Número de Dias para Protesto
                Copy(sCodigoParaBaixa,1,1)                                                                + // 224 a 224 (001) Código para Baixa/Devolução
                Copy(sNumeroDeDiasParaBaixa,1,3)                                                          + // 225 a 227 (003) Número de Dias para Baixa/Devolução
                Copy('09',1,2)                                                                            + // 228 a 229 (002) Código da Moeda
                Copy(Right('0000000000',10),1,10)                                                         + // 230 a 239 (10) Nº do Contrato da Operação de Créd.
                Copy(' ',1,1)                                                                               // 240 a 240 (001) Uso Exclusivo FEBRABAN / CNAB
                );

              // Registro Detalhe - Segmento Q (Obrigatório - Remessa)

              iReg := iReg + 1;

              WriteLn(F,
                Copy(AllTrim(Form26.MaskEdit42.Text),1,3)                                                 + // 001 a 003 (003) Código do Banco na Compensação
                Copy('0001',1,4)                                                                          + // 004 a 007 (004) Lote de Serviço
                copy('3',1,1)                                                                             + // 008 a 008 (001) Tipo de Registro
                Copy(StrZero(iReg-2,5,0),1,005)                                                           + // 009 a 013 (005) Nº Sequencial do Registro no Lote
                Copy('Q',1,1)                                                                             + // 014 a 014 (001) Cód. Segmento do Registro Detalhe
                Copy(' ',1,1)                                                                             + // 015 a 015 (001) Uso Exclusivo FEBRABAN/CNAB
                Copy(sComandoMovimento,1,2)                                                               + // 016 a 017 (002) Código de Movimento Remessa

                // Dados do Pagador
                Copy(sCPFOuCNPJ,2,1)                                                                      + // 018 a 018 (001) Tipo de Inscrição da Empresa
                Copy(Right(Replicate('0',15)+LimpaNumero(Form7.IBDataSet2CGC.AsString),15),1,015)         + // 019 a 033 (015) Número de Inscrição da Empresa
                Copy(UpperCase(ConverteAcentos(Form7.IbDataSet2NOME.AsString))+Replicate(' ',40),1,040)                    + // 034 a 073 (040) Nome da Empresa
                Copy(UpperCase(ConverteAcentos(Form7.IbDataSet2ENDERE.AsString))+Replicate(' ',40),1,040)                  + // 074 a 113 (040) Endereço
                Copy(UpperCase(ConverteAcentos(Form7.IbDataSet2COMPLE.AsString))+Replicate(' ',15),1,015)                  + // 114 a 128 (015) Bairro
                Copy(UpperCase(Form7.IbDataSet2CEP.AsString)+Replicate(' ',5),1,005)                                       + // 129 a 133 (005) CEP
                Copy(UpperCase(Form7.IbDataSet2CEP.AsString)+Replicate(' ',3),7,003)                                       + // 134 a 136 (003) Sufixo do CEP
                Copy(UpperCase(ConverteAcentos(Form7.IbDataSet2CIDADE.AsString))+Replicate(' ',15),1,015)                  + // 137 a 151 (015)Cidade
                Copy(UpperCase(ConverteAcentos(Form7.IbDataSet2ESTADO.AsString))+Replicate(' ',2),1,002)                   + // 152 a 153 (002) Unidade da Federação

                // Avalista
                Copy('0',1,1)                                                                             + // 154 a 154 (001) Tipo de Inscrição da Empresa Avalista
                Copy(Replicate('0',15),1,015)                                                             + // 155 a 169 (015) Número de Inscrição da Empresa avalista
                Copy(Replicate(' ',40),1,040)                                                             + // 170 a 209 (040) Nome da Empresa avalista

                Copy(Replicate('0',3),1,3)                                                                 + // 210 a 212 (003) Cód. Bco. Corresp. na Compensação
                Copy(Replicate(' ',20),1,20)                                                               + // 213 a 232 (020) Nosso Nº no Banco Correspondente 213 a 232 (020)
                Copy(Replicate(' ',8),1,8)                                                                   // 233 a 240 (008) Uso Exclusivo FEBRABAN / CNAB
                );
            except
              on E: Exception do
              begin
                Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
              end;
            end;
          except
            on E: Exception do
            begin
              Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
            end;
          end;

          try
            vTotal := vTotal + Form7.ibDataSet7VALOR_DUPL.AsFloat;
          except
            on E: Exception do
            begin
              Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
            end;
          end;
        end;
      end;

      Form7.ibDataSet7.Next;
    end;

    try
      // Registro Trailer de Lote (Tipo = 5)
      WriteLn(F,
        Copy(AllTrim(Form26.MaskEdit42.Text),1,3)     + // 001 a 003 (003) Código do Banco na Compensação
        '0001'                                        + // 004 a 007 (004) Lote de Serviço
        '5'                                           + // 008 a 008 (001) Tipo de Registro
        Copy(Replicate(' ',9),1,9)                    + // 009 a 017 (009) Uso Exclusivo FEBRABAN/CNAB
        Copy(StrZero(iReg,6,0),1,006)               + // 018 a 023 (006) Quantidade de Registros do Lote
        Copy(StrZero(0,92,0),1,092)                   + // 024 a 115 (092) Zeros
        Copy(Replicate(' ',125),1,125)                  // 116 a 240 (125) Brancos
        );

      // Registro Trailer de Arquivo (Tipo = 9)
      WriteLn(F,
        Copy(AllTrim(Form26.MaskEdit42.Text),1,3) +   // 001 a 003 (003) Código do Banco na Compensação
        Copy('9999',1,004)                        +   // 004 a 007 (004) Lote de Serviço
        Copy('9',1,004)                           +   // 008 a 008 (001) Tipo de Registro
        Copy(Replicate(' ',9),1,9)                +   // 009 a 017 (009) Uso Exclusivo FEBRABAN/CNAB
        Copy(StrZero(iLote,6,0),1,006)            +   // 018 a 023 (006) Quantidade de Lotes do Arquivo
        Copy(StrZero(iReg+2,6,0),1,006)           +   // 024 a 029 (006) Quantidade de Registros do Arquivo
        Copy(StrZero(0,6,0),1,006)                +   // 030 a 035 (006) Qtde de Contas p/ Conc. (Lotes)
        Copy(Replicate(' ',205),1,205)                // 036 a 240 (205) Uso Exclusivo FEBRABAN/CNAB
        );

      CloseFile(F); // Fecha o arquivo
    except
      on E: Exception do
      begin
        Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
      end;
    end;

    if iReg = 2 then
    begin
      DeleteFile(Form1.sAtual+'\remessa\'+Form1.sArquivoRemessa);
      Form1.sArquivoRemessa := '';

      ShowMessage('Não existe movimento, o arquivo não foi gerado.');
    end;

  except
    on E: Exception do
    begin
      Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
    end;
  end;

  Form7.ibDataSet7.EnableControls;
end;

procedure TForm25.GravaPortadorNossoNumCodeBar;
begin
  // Precisa estar posicionado no registro certo
  Form7.ibDataSet7.Edit;
  Form7.ibDataSet7PORTADOR.AsString  := 'REMESSA ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')';
  Form7.ibDataSet7NOSSONUM.AsString  := sNossoNum;
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
                                        
  //Mauricio Parizotto 2023-06-16
  if sInstituicaoFinanceira <> '' then
    Form7.ibDataSet7INSTITUICAOFINANCEIRA.AsString   := sInstituicaoFinanceira;

  Form7.ibDataSet7FORMADEPAGAMENTO.AsString := 'Boleto Bancário'; // Sandro Silva 2023-07-13 Form7.ibDataSet7FORMADEPAGAMENTO.AsString := '15-Boleto Bancário';
    
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
    //ShowMessage('Não é possível imprimir este bloqueto.'+chr(10)+'Esta conta já foi enviada para o '+Form7.ibDataSet7PORTADOR.AsString Mauricio Parizotto 2023-10-02
    ShowMessage('Não é possível imprimir este boleto.'+chr(10)+'Esta conta já foi enviada para o '+Form7.ibDataSet7PORTADOR.AsString
    +chr(10)+chr(10)+'Para enviar para outro banco clique ao contrário sobre a conta e no menu clique em "Baixar esta conta no banco".'
    +chr(10)+'Em seguida gere o arquivo de remessa e envie para o banco.');
  end;
end;

procedure TForm25.ValidaEmailPagador;
var
  sEmail : String;
begin
  //
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

end.







