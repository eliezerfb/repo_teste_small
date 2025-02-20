unit Unit25;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, synPDF,
  ExtCtrls, StdCtrls, Mask, DBCtrls, SMALL_DBEdit, smallfunc_xe, IniFiles, Printers, ShellApi, jpeg, DB,
  Buttons;

type
  TForm25 = class(TForm)
    Edit3: TEdit;
    edtInstrucaoL1: TEdit;
    edtInstrucaoL2: TEdit;
    edtInstrucaoL3: TEdit;
    edtInstrucaoL4: TEdit;
    PrinterSetupDialog1: TPrinterSetupDialog;
    Edit1: TEdit;
    Edit2: TEdit;
    imgBoletoVisual: TImage;
    Image7: TImage;
    Panel1: TPanel;
    btnConfigurarBoleto: TBitBtn;
    btnAnterior: TBitBtn;
    btnProximo: TBitBtn;
    btnImprimir: TBitBtn;
    btnImprimirTodos: TBitBtn;
    btnEnviaEmail: TBitBtn;
    btnEnviaEmailTodos: TBitBtn;
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
    procedure btnEnviaEmailClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chkDataAtualizadaJurosMoraClick(Sender: TObject);
    procedure btnEnviaEmailTodosClick(Sender: TObject);
  private
    { Private declarations }
    bOk : Boolean; // Sandro Silva 2023-06-20
    sInstituicaoFinanceira : string;
    sTipoMulta : string;
    vMulta : Double;
    procedure ImprimirBoleto;
    procedure ValidaEmailPagador;
    function GeraImagemDoBoletoComOCodigoDeBarras(Imprimir: Boolean): Boolean;
    procedure IniciaImpresao(var Impressao: TCanvas);
    procedure GeraVisualizacaoBoleto;
    procedure SetFormaBoleto;
    function ValidaMesmoBanco: Boolean;
  public
    { Public declarations }
    sNossoNum : String;
    sNumero   : String;
    sFormatoBoleto : string;
    procedure GeraCarneTodos;
    procedure CarregaConfiguracao;
    procedure CarregaDadosParcela;
    procedure GravaPortadorNossoNumCodeBar;
    procedure EventoShow;
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
  uFuncoesRetaguarda, uDialogs, uEmail, uDesenhaBoleto, uSmallConsts;

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

function PointX(MM : Double) : Longint;
begin
  Result := Round(Printer.PageWidth / GetDeviceCaps(Printer.Handle,HORZSIZE));
end;

function Tform25.GeraImagemDoBoletoComOCodigoDeBarras(Imprimir: Boolean): Boolean;
var
  I: Integer;
  Impressao: TCanvas;
begin
  CarregaConfiguracao; //Mauricio Parizotto 2024-02-07

  try
    CarregaDadosParcela;
    GeraVisualizacaoBoleto;

    //IniciaImpresao(Impressao); Mauricio Parizotto 2024-02-27

    if Imprimir then
    begin
      IniciaImpresao(Impressao); //Mauricio Parizotto 2024-02-27

      if Form25.sFormatoBoleto = 'Padrão' then
        DesenhaBoletoLayoutPadrao(Impressao, grPrint, Copy(Form26.MaskEdit42.Text,1,3), Form26.MaskEdit44.Text, Form26.MaskEdit46.Text, Form26.MaskEdit50.Text, Form26.MaskEdit43.Text, Form26.MaskEdit47.Text, Form26.MaskEdit45.Text)
      else
        DesenhaBoletoLayoutCarne(Impressao, grPrint, Copy(Form26.MaskEdit42.Text,1,3), Form26.MaskEdit44.Text, Form26.MaskEdit46.Text, Form26.MaskEdit50.Text, Form26.MaskEdit43.Text, Form26.MaskEdit47.Text, Form26.MaskEdit45.Text,1);

      Printer.EndDoc;
    end;

    Result     := True;
  except
    on E: Exception do
    begin
      Result     := False;
    end;
  end;
end;


procedure TForm25.btnAnteriorClick(Sender: TObject);
begin
  Form7.ibDataSet7.MoveBy(-1);

  ValidaEmailPagador;
  GeraImagemDoBoletoComOCodigoDeBarras(False);
end;

procedure TForm25.btnProximoClick(Sender: TObject);
begin
  Form7.ibDataSet7.MoveBy(1);

  ValidaEmailPagador;
  GeraImagemDoBoletoComOCodigoDeBarras(False);
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
begin
  EventoShow;

  if btnImprimirTodos.CanFocus then
    btnImprimirTodos.SetFocus;
end;

procedure TForm25.FormActivate(Sender: TObject);
begin
  ValidaEmailPagador;

  CarregaConfiguracao;
  CarregaDadosParcela;
  GeraVisualizacaoBoleto;
end;

procedure TForm25.btnImprimirClick(Sender: TObject);
begin
  if not Form25.PrintDialog1.Execute then
    Exit;

  ImprimirBoleto;
end;

procedure TForm25.btnImprimirTodosClick(Sender: TObject);
begin

  {$Region'//// Seta Forma de Pagamento ////'}
  try
    Form7.ibDataSet7.DisableControls;
    Form7.ibDataSet7.First;

    while not Form7.ibDataSet7.Eof do
    begin
      SetFormaBoleto;
      Form7.ibDataSet7.Next;
    end;
  finally
    Form7.ibDataSet7.First;
    Form7.ibDataSet7.EnableControls;
  end;
  {$Endregion}

  {$region'//// Padrão ///'}
  if sFormatoBoleto = 'Padrão' then
  begin
    try
      bOk := True; // No caso de um Except

      Form7.ibDataSet7.First;

      if (LimpaNumero(Form26.MaskEdit42.Text) = '') then
      begin
        bOk := False;
        MensagemSistema('Configure o código do banco.');
      end;

      try
        if not Form25.PrintDialog1.Execute then
          Exit;

        while (not Form7.ibDataSet7.EOF) and (bOk) do
        begin
          if (FormaDePagamentoGeraBoleto(Form7.ibDataSet7FORMADEPAGAMENTO.AsString)) and (ValidaMesmoBanco) then // Mauricio Parizotto 2024-02-28
          begin
            //ImprimirBoleto;
            //Valida email e carrega o cliente correto
            ValidaEmailPagador; //Mauricio Parizotto 2024-03-26
            GeraImagemDoBoletoComOCodigoDeBarras(True);
            GravaPortadorNossoNumCodeBar;
          end;

          Form7.ibDataSet7.Next;
        end;
      except
        MensagemSistema('Erro na impressão do boleto.',msgErro);
      end;
    except
    end;
  end;
  {$Endregion}

  if sFormatoBoleto = 'Carnê' then
  begin
    GeraCarneTodos;
  end;
end;


procedure TForm25.btnEnviaEmailClick(Sender: TObject);
var
  sEmail : String;
  PDF :TPdfDocumentGDI;
  PAGE : TPdfPage;
begin
  sEmail := Form7.ibDataSet2EMAIL.AsString; // XML POR EMAIL

  if validaEmail(sEmail) then
  begin
    if ValidaMesmoBanco then // Mauricio Parizotto 2024-02-28
    begin
      CarregaConfiguracao;
      CarregaDadosParcela;
      SetFormaBoleto;

      // Apaga o PDF anterior
      while FileExists(Form1.sAtual+'\boleto_'+AllTrim(Form7.ibDataSet7DOCUMENTO.AsString)+'.pdf') do
      begin
        DeleteFile(Form1.sAtual+'\boleto_'+AllTrim(Form7.ibDataSet7DOCUMENTO.AsString)+'.pdf');
        sleep(1000);
      end;

      try
        PDF:=TPdfDocumentGDI.Create();
        PDF.Info.Author       := 'Small';
        PDF.Info.Creator      := 'Small';
        PDF.Info.Title        := 'Boletos';
        PDF.Info.Subject      := 'Boletos de cobrança';
        PDF.Info.CreationDate := now;
        PDF.DefaultPaperSize := psA4; //Tamanho A4
        PDF.ForceJPEGCompression := 0;
        PDF.AddTrueTypeFont('Interleaved 2of5 Text');
        PDF.EmbeddedTTF := True;
        PDF.EmbeddedWholeTTF := true;

        PAGE := pdf.AddPage;
        PAGE.PageLandscape := False;

        if Form25.sFormatoBoleto = 'Padrão' then
          DesenhaBoletoLayoutPadrao(PDF.VCLCanvas, grPDF, Copy(Form26.MaskEdit42.Text,1,3), Form26.MaskEdit44.Text, Form26.MaskEdit46.Text, Form26.MaskEdit50.Text, Form26.MaskEdit43.Text, Form26.MaskEdit47.Text, Form26.MaskEdit45.Text)
        else
          DesenhaBoletoLayoutCarne(PDF.VCLCanvas, grPDF, Copy(Form26.MaskEdit42.Text,1,3), Form26.MaskEdit44.Text, Form26.MaskEdit46.Text, Form26.MaskEdit50.Text, Form26.MaskEdit43.Text, Form26.MaskEdit47.Text, Form26.MaskEdit45.Text,1);

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

        // 2024-02-26 Unit7.EnviarEMail('',sEmail,'','Boleto','Boleto',pChar(Form1.sAtual+'\boleto_'+AllTrim(Form7.ibDataSet7DOCUMENTO.AsString)+'.pdf'), False);
        EnviarEMail('', sEmail, '', PChar('Boleto'), PChar('Boleto'), PChar(Form1.sAtual + '\boleto_' + AllTrim(Form7.ibDataSet7DOCUMENTO.AsString) + '.pdf'), False);
      end;
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

    Mais1Ini.WriteString(Form1.sEscolhido,'Instruções1',AllTrim(edtInstrucaoL1.Text));  // linha 1 das instruções ---> 10   4
    Mais1Ini.WriteString(Form1.sEscolhido,'Instruções2',AllTrim(edtInstrucaoL2.Text));  // linha 2 das instruções ---> 10   4
    Mais1Ini.WriteString(Form1.sEscolhido,'Instruções3',AllTrim(edtInstrucaoL3.Text));  // linha 3 das instruções ---> 10   4
    Mais1Ini.WriteString(Form1.sEscolhido,'Instruções4',AllTrim(edtInstrucaoL4.Text));  // linha 4 das instruções ---> 10   4
    
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
  GeraImagemDoBoletoComOCodigoDeBarras(False);
end;

procedure TForm25.btnEnviaEmailTodosClick(Sender: TObject);
var
  sArquivo: String;
  sEmail : String;
  PDF :TPdfDocumentGDI;
  PAGE : TPdfPage;
  posicao : integer;
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
    try
      PDF:=TPdfDocumentGDI.Create();
      PDF.Info.Author       := 'Small';
      PDF.Info.Creator      := 'Small';
      PDF.Info.Title        := 'Boletos';
      PDF.Info.Subject      := 'Boletos de cobrança';
      PDF.Info.CreationDate := now;
      PDF.DefaultPaperSize := psA4; //Tamanho A4
      PDF.ForceJPEGCompression := 0;
      PDF.AddTrueTypeFont('Interleaved 2of5 Text');
      PDF.EmbeddedTTF := True;
      PDF.EmbeddedWholeTTF := true;

      Form7.ibDataSet7.First;

      posicao := 0;

      while not Form7.ibDataSet7.Eof do
      begin
        if Form7.ibDataSet7NOME.AsString = Form7.ibDataSet2NOME.AsString then
        begin
          if Form7.ibDataSet7VALOR_RECE.AsFloat = 0 then
          begin
            CarregaConfiguracao;
            CarregaDadosParcela;

            inc(posicao);

            if posicao = 1 then
            begin
              PAGE := pdf.AddPage;
              PAGE.PageLandscape := False;
            end;

            if Form25.sFormatoBoleto = 'Padrão' then
            begin
              posicao := 0;
              DesenhaBoletoLayoutPadrao(PDF.VCLCanvas, grPDF, Copy(Form26.MaskEdit42.Text,1,3), Form26.MaskEdit44.Text, Form26.MaskEdit46.Text, Form26.MaskEdit50.Text, Form26.MaskEdit43.Text, Form26.MaskEdit47.Text, Form26.MaskEdit45.Text);
            end else
            begin
              DesenhaBoletoLayoutCarne(PDF.VCLCanvas, grPDF, Copy(Form26.MaskEdit42.Text,1,3), Form26.MaskEdit44.Text, Form26.MaskEdit46.Text, Form26.MaskEdit50.Text, Form26.MaskEdit43.Text, Form26.MaskEdit47.Text, Form26.MaskEdit45.Text,posicao);

              if posicao = 3 then
                posicao := 0;
            end;
          end;
        end;

        if UpperCase(Copy(AllTrim(Form7.ibDataSet7PORTADOR.AsString),1,7)) <> 'BANCO (' then
        begin
          GravaPortadorNossoNumCodeBar;
        end;

        Screen.Cursor            := crHourGlass;

        Form7.ibDataSet7.Next;
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
      //2024-02-26 Unit7.EnviarEMail('',sEmail,'','Boleto','Boleto',pChar(Form1.sAtual+'\'+sArquivo), False);
      EnviarEMail('', sEmail, '', PChar('Boleto'), PChar('Boleto'), PChar(Form1.sAtual+'\'+sArquivo), False);
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

  //Form7.ibDataSet7FORMADEPAGAMENTO.AsString := _cFormaPgtoBoleto; // Sandro Silva 2023-07-13 Form7.ibDataSet7FORMADEPAGAMENTO.AsString := '15-Boleto Bancário'; Mauricio Parizotto 2024-02-27

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
  if ValidaMesmoBanco then // Mauricio Parizotto 2024-02-28
  begin
    SetFormaBoleto;

    if GeraImagemDoBoletoComOCodigoDeBarras(True) then
    begin
      if UpperCase(Copy(AllTrim(Form7.ibDataSet7PORTADOR.AsString),1,7)) <> 'BANCO (' then
      begin
        GravaPortadorNossoNumCodeBar;
      end;
    end;
  end;
end;

procedure TForm25.ValidaEmailPagador;
var
  sEmail : String;
begin
  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet7NOME.AsString));
  Form7.ibDataSet2.Open;

  sEmail := Form7.ibDataSet2EMAIL.AsString; // XML POR EMAIL

  if validaEmail(sEmail) then
  begin
    btnEnviaEmail.Visible := True; // Sandro Silva 2022-12-23 Button7.Visible := True;
  end else
  begin
    btnEnviaEmail.Visible := False; // Sandro Silva 2022-12-23 Button7.Visible := False;
  end;
end;

function TForm25.GeraCodBarra(codBanco:string):string;
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

procedure TForm25.GeraCarneTodos;
var
  posicao : integer;
  Impressao: TCanvas;
begin
  try
    Form7.ibDataSet7.First;

    if (LimpaNumero(Form26.MaskEdit42.Text) = '') then
    begin
      MensagemSistema('Configure o código do banco.');
      Exit;
    end;

    try
      if not Form25.PrintDialog1.Execute then
        Exit;

      CarregaConfiguracao;

      posicao := 0;

      while (not Form7.ibDataSet7.EOF) do
      begin
        if (FormaDePagamentoGeraBoleto(Form7.ibDataSet7FORMADEPAGAMENTO.AsString)) and (ValidaMesmoBanco) then // Mauricio Parizotto 2024-02-28
        begin
          inc(posicao);

          if posicao = 1 then
            IniciaImpresao(Impressao);

          CarregaDadosParcela;

          //Mauricio Parizotto 2024-03-26
          //Valida email e carrega o cliente correto
          ValidaEmailPagador;

          DesenhaBoletoLayoutCarne(Impressao, grPrint, Copy(Form26.MaskEdit42.Text,1,3), Form26.MaskEdit44.Text, Form26.MaskEdit46.Text, Form26.MaskEdit50.Text, Form26.MaskEdit43.Text, Form26.MaskEdit47.Text, Form26.MaskEdit45.Text,posicao);

          GravaPortadorNossoNumCodeBar;

          //Imprime pagina
          if posicao = 3 then
          begin
            Printer.EndDoc;
            posicao := 0;
          end;
        end;

        Form7.ibDataSet7.Next;
      end;

      //Imprime restante
      if posicao <> 0 then
      begin
        Printer.EndDoc;
      end;

    except
      MensagemSistema('Erro na impressão do boleto.',msgErro);
    end;
  except
  end;
end;


procedure TForm25.CarregaConfiguracao;
begin
  Form26.Caption := 'Configuração do '+AnsiLowercase(Form25.Caption);

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
end;


procedure TForm25.CarregaDadosParcela;
var
  codBarrasSemDV, DV : string;
begin
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

  Form25.sNossoNum := '';
end;

procedure TForm25.IniciaImpresao(var Impressao: TCanvas);
var
  Device : array[0..255] of char;
  Driver : array[0..255] of char;
  Port   : array[0..255] of char;
  hDMode : THandle;
  PDMode : PDEVMODE;
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

      Printer.Title              := 'Boleto de cobrança bancária';  // Este título é visto no spoool da impressora
      Printer.BeginDoc;                                // Inicia o documento de impressão
    end;
  end;

  Impressao        := Printer.Canvas;
end;


procedure TForm25.GeraVisualizacaoBoleto;
begin
  imgBoletoVisual.Height := 1039;
  imgBoletoVisual.Canvas.Pen.Color  := clWhite;
  imgBoletoVisual.Canvas.Rectangle(5,0,imgBoletoVisual.Width,1200);

  DesenhaBoletoLayoutPadrao(imgBoletoVisual.Canvas, grImagem ,Copy(Form26.MaskEdit42.Text,1,3), Form26.MaskEdit44.Text, Form26.MaskEdit46.Text, Form26.MaskEdit50.Text, Form26.MaskEdit43.Text, Form26.MaskEdit47.Text, Form26.MaskEdit45.Text);

  imgBoletoVisual.Refresh;
  imgBoletoVisual.Top := -525;
end;

procedure Tform25.SetFormaBoleto;
begin
  Form7.ibDataSet7.Edit;
  Form7.ibDataSet7FORMADEPAGAMENTO.AsString := _cFormaPgtoBoleto;
  Form7.ibDataSet7.Post;
end;


procedure Tform25.EventoShow;
var
  Mais1Ini: TIniFile;
  I: Integer;
begin
  //Mauricio Parizotto 2024-02-05
  sFormatoBoleto := ExecutaComandoEscalar(Form7.ibDataSet7.Transaction,
                                          ' Select Coalesce(FORMATOBOLETO,''Padrão'') '+
                                          ' From BANCOS '+
                                          ' Where NOME ='+QuotedStr(Form1.sBancoBoleto));

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

      edtInstrucaoL1.Text := Mais1Ini.ReadString(Form1.sEscolhido,'Instruções1','');  // linha 1 das instruções ---> 10   4
      edtInstrucaoL2.Text := Mais1Ini.ReadString(Form1.sEscolhido,'Instruções2','');  // linha 2 das instruções ---> 10   4
      edtInstrucaoL3.Text := Mais1Ini.ReadString(Form1.sEscolhido,'Instruções3','');  // linha 3 das instruções ---> 10   4
      edtInstrucaoL4.Text := Mais1Ini.ReadString(Form1.sEscolhido,'Instruções4','');  // linha 4 das instruções ---> 10   4

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
end;


function TForm25.ValidaMesmoBanco:Boolean; // Mauricio Parizotto 2024-02-28
begin
  Result := False;

  if (UpperCase(Copy(AllTrim(Form7.ibDataSet7PORTADOR.AsString),1,7)) <> 'BANCO (') or (Pos('('+Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+')',Form7.ibDataSet7PORTADOR.AsString)<>0) then
  begin
    Result := True;
  end else
  begin
    Result := False;

    MensagemSistema('Não é possível imprimir este boleto.'+chr(10)+'Esta conta já foi enviada para o '+Form7.ibDataSet7PORTADOR.AsString
                      +chr(10)+chr(10)+'Para enviar para outro banco clique ao contrário sobre a conta e no menu clique em "Baixar esta conta no banco".'
                      +chr(10)+'Em seguida gere o arquivo de remessa e envie para o banco.'
                      ,msgAtencao);
  end;
end;

end.







