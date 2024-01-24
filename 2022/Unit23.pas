unit Unit23;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, smallfunc_xe, DB, Printers, IniFiles, Mask,
  DBCtrls, SMALL_DBEdit;

type
  TForm23 = class(TForm)
    Button3: TButton;
    Button1: TButton;
    Button4: TButton;
    Label16: TLabel;
    CheckBox1: TCheckBox;
    Button5: TButton;
    SMALL_DBEdit1: TSMALL_DBEdit;
    Label20: TLabel;
    Button2: TButton;
    Button6: TButton;
    SMALL_DBEdit2: TSMALL_DBEdit;
    Panel2: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Image2: TImage;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button6Click(Sender: TObject);
    procedure SMALL_DBEdit2Change(Sender: TObject);
    procedure SMALL_DBEdit2Exit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form23: TForm23;

implementation

uses Unit7, Unit31, Mais, Unit26, uDialogs;

{$R *.DFM}


procedure TForm23.Button2Click(Sender: TObject);
var
  Largura,Altura,
  LinhaValor,ColunaValor,
  LinhaExtenso1,ColunaExtenso1,
  LinhaExtenso2,ColunaExtenso2,
  LinhaNominal,ColunaNominal,
  LinhaCidade,ColunaCidade,
  LinhaDia,ColunaDia,
  LinhaMes,ColunaMes,
  LinhaAno,ColunaAno:integer;
begin
  //
  // Cópia de cheque
  //
  LinhaValor     := StrToInt(AllTrim(Form31.MasKEdit1.Text));
  ColunaValor    := StrToInt(AllTrim(Form31.MasKedit21.Text));
  LinhaExtenso1  := StrToInt(AllTrim(Form31.MasKedit2.Text));
  ColunaExtenso1 := StrToInt(AllTrim(Form31.MasKedit22.Text));
  LinhaExtenso2  := StrToInt(AllTrim(Form31.MasKedit3.Text));
  ColunaExtenso2 := StrToInt(AllTrim(Form31.MasKedit23.Text));
  LinhaNominal   := StrToInt(AllTrim(Form31.MasKedit4.Text));
  ColunaNominal  := StrToInt(AllTrim(Form31.MasKedit24.Text));
  LinhaCidade    := StrToInt(AllTrim(Form31.MasKedit5.Text));
  ColunaCidade   := StrToInt(AllTrim(Form31.MasKedit25.Text));
  LinhaDia       := StrToInt(AllTrim(Form31.MasKedit6.Text));
  ColunaDia      := StrToInt(AllTrim(Form31.MasKedit26.Text));
  LinhaMes       := StrToInt(AllTrim(Form31.MasKedit7.Text));
  ColunaMes      := StrToInt(AllTrim(Form31.MasKedit27.Text));
  LinhaAno       := StrToInt(AllTrim(Form31.MasKedit8.Text));
  ColunaAno      := StrToInt(AllTrim(Form31.MasKedit28.Text));
  {começa a rotina de impressão}
  Screen.cursor :=crHourGlass;
  //
  Printer.Orientation:=poPortrait;
  Printer.BeginDoc;
  Printer.Canvas.Pen.Width :=2;
  Printer.Canvas.Font.Name := 'Courier New';
  Printer.Canvas.Font.Size := 10;
  Largura :=Printer.Canvas.TextWidth('a');
  Altura  :=Printer.Canvas.Font.Height;
  {título que vai para o gerenciador de impressão}
  Printer.Title:='Impressão da cópia de Cheque';
  {----------------primeira Linha----------------}
  {Valor do cheque}
  Printer.Canvas.TextOut(Largura*ColunaValor,-(LinhaValor*Altura),Form23.Label1.Caption);
   {----------------segunda Linha----------------}
  {Extenso 1}
  Printer.Canvas.TextOut(Largura*ColunaExtenso1,-(LinhaExtenso1*Altura),
     Copy(Form23.Label2.Caption+Form23.Label3.Caption,1,79-ColunaExtenso1));
  {----------------terceira Linha----------------}
  {Extenso 2}
  Printer.Canvas.TextOut(Largura*ColunaExtenso2,-(LinhaExtenso2*Altura),
     Copy(Form23.Label2.Caption+Form23.Label3.Caption+Replicate('x',79),
     80-ColunaExtenso1,79-ColunaExtenso2));
  {----------------quarta Linha----------------}
  {Nominal}
  Printer.Canvas.TextOut(Largura*ColunaNominal,-(LinhaNominal*Altura),
  Copy(Form23.Label4.Caption+Replicate(' ',79),1,69-ColunaNominal));
  {----------------Quinta Linha----------------}
  {Cidade}
  Printer.Canvas.TextOut(Largura*ColunaCidade,-(LinhaCidade*Altura),Form23.Label5.Caption);
  {dia}
  Printer.Canvas.TextOut(Largura*ColunaDia,-(LinhaDia*Altura),Form23.Label6.Caption);
  {mes}
  Printer.Canvas.TextOut(Largura*ColunaMes,-(LinhaMes*Altura),Form23.Label7.Caption);
  {ano}
  Printer.Canvas.TextOut(Largura*ColunaAno,-(LinhaAno *Altura),Right(Form23.Label8.Caption,StrToInt(Form31.MaskEdit9.Text)));
  {----------------Cruzado----------------}
  if CheckBox1.Checked = True then
  begin
    Printer.Canvas.MoveTo(Largura*ColunaValor,-(LinhaValor*Altura));
    Printer.Canvas.LineTo(Largura*ColunaCidade,-((LinhaCidade+1)*Altura));
    Printer.Canvas.MoveTo(Largura*(ColunaValor-7),-(LinhaValor*Altura));
    Printer.Canvas.LineTo(Largura*(ColunaCidade-7),-((LinhaCidade+1)*Altura));
  end;
  // Linha
  Printer.Canvas.MoveTo(Largura*1,-(Altura*16));
  Printer.Canvas.LineTo(Printer.PageWidth,-(Altura*16));
  //
  Printer.Canvas.Font.Name := 'Microsoft Sans Serif';
  Printer.Canvas.Font.Size := 10;
  Printer.Canvas.Font.sTyle := [fsBold];
  // Número do cheque
  Printer.Canvas.TextOut(Largura,-(Altura*17),' Cópia do Cheque número: '+Form7.ibDataSet5DOCUMENTO.AsString);
  // Linha
  Printer.Canvas.MoveTo(Largura,-(Altura*19));
  Printer.Canvas.LineTo(Printer.PageWidth,-(Altura*19));
  // Linha Inicial
  Printer.Canvas.MoveTo(Largura,-(Altura*16));
  Printer.Canvas.LineTo(Largura,-(Altura*19));
  // Linha Final
  Printer.Canvas.MoveTo(Printer.PageWidth,-(Altura*16));
  Printer.Canvas.LineTo(Printer.PageWidth,-(Altura*19));
  // Banco
  Form7.ibDataSet11.Active := True;
  Form7.ibDataSet11.First;
  while (not Form7.ibDataSet11.EOF) and (AllTrim(Form7.ibDataSet11NOME.AsString) <> AllTrim(Form7.Caption)) do Form7.ibDataSet11.Next;
  if AllTrim(Form7.ibDataSet11NOME.AsString) = AllTrim(Form7.Caption) then
  begin
    Printer.Canvas.TextOut(Largura,-(Altura*21),'Banco: '+AllTrim(Form7.ibDataSet11NOME.AsString));
    Printer.Canvas.TextOut(Printer.PageWidth div 2,-(Altura*21),'Agência: '+AllTrim(Form7.ibDataSet11AGENCIA.AsString));
    Printer.Canvas.TextOut(Printer.PageWidth-(Printer.PageWidth div 3),-(Altura*21),'Conta: '+AllTrim(Form7.ibDataSet11CONTA.AsString));
  end;
  // Banco
  Printer.Canvas.TextOut(Largura,-(Altura*23),'Utilizado para: '+Form7.ibDataSet5HISTORICO.AsString);
  // Linha
  Printer.Canvas.MoveTo(Largura,-(Altura*26));
  Printer.Canvas.LineTo(Largura*100,-(Altura*26));
  // Vistos
  Printer.Canvas.TextOut(Printer.PageWidth div 5,-(Altura*27),'    VISTOS');
  Printer.Canvas.TextOut(Printer.PageWidth div 2,-(Altura*27),' Assinado por:');
  // vistos
  Printer.Canvas.Font.Name  := 'Microsoft Sans Serif';
  Printer.Canvas.Font.Size  := 8;
  Printer.Canvas.Font.sTyle := [];
  // Vistos
  Printer.Canvas.TextOut(Largura,-(Altura*29),' Assinante:');
  Printer.Canvas.TextOut(Printer.PageWidth div 6,-(Altura*29),' Conferente:');
  Printer.Canvas.TextOut(Printer.PageWidth div 3,-(Altura*29),' Contador:');
  // Linha
  Printer.Canvas.MoveTo(Largura,-(Altura*29));
  Printer.Canvas.LineTo(Printer.PageWidth,-(Altura*29));
  // Linha
  Printer.Canvas.MoveTo(Printer.PageWidth div 2,-(Altura*32));
  Printer.Canvas.LineTo(Printer.PageWidth,-(Altura*32));
  // Linha
  Printer.Canvas.MoveTo(Largura,-(Altura*35));
  Printer.Canvas.LineTo(Printer.PageWidth,-(Altura*35));
  //  Linhas verticais
  Printer.Canvas.MoveTo(Largura,-(Altura*26));
  Printer.Canvas.LineTo(Largura,-(Altura*35));
  // Que divide as assinaturas
  Printer.Canvas.MoveTo(Printer.PageWidth div 6,-(Altura*29));
  Printer.Canvas.LineTo(Printer.PageWidth div 6,-(Altura*35));
  // Que divide as assinaturas
  Printer.Canvas.MoveTo(Printer.PageWidth div 3,-(Altura*29));
  Printer.Canvas.LineTo(Printer.PageWidth div 3,-(Altura*35));
  // Que divide as assinaturas
  Printer.Canvas.MoveTo(Printer.PageWidth div 2,-(Altura*26));
  Printer.Canvas.LineTo(Printer.PageWidth div 2,-(Altura*35));
  // Final
  Printer.Canvas.MoveTo(Printer.PageWidth,-(Altura*26));
  Printer.Canvas.LineTo(Printer.PageWidth,-(Altura*35));
  //
//  Printer.Canvas.Font.Name  := 'Courier New';
//  Printer.Canvas.Font.Size  := 10;
//  Printer.Canvas.Font.sTyle := [];
  //
  //
  Printer.EndDoc;
  screen.cursor := crDefault;
end;

Procedure vaivolta(iPar: Integer);
var
  bSair : Boolean;
  iReg  : Integer;
begin
  { Percore o arquivo procurando um chque }
  bSair := False;
  //
  with Form7 do
  begin
    ibDataSet5.MoveBy(iPar);
    iReg := ibDataSet5.Recno; { Marca o número do registro }
    while bSair = False do
    begin
      if ibDataSet5SAIDA_.AsFloat = 0 then ibDataSet5.MoveBy(iPar) else bSair := True;
      if iPar = 1 then if ibDataSet5.EOF then iPar := -1;
      if iPar = -1 then if ibDataSet5.BOF then iPar := 1;
      if iReg = ibDataSet5.Recno then  bSair := True;
    end;
    //
    if ibDataSet5SAIDA_.AsFloat > 0.0001 then
    begin
      { Preenche na tela com os dados do emitente  }  // ibDataSet11: Arquivo do EMITENTE
      Form23.Label14.Caption := ibDataSet13NOME.AsString; // Nome do Emitente
      Form23.Label15.Caption := ibDataSet13CGC.AsString;  // CGC do Emitente
      { Preenche na tela com os dados do emitente  }  // ibDataSet11: Arquivo do EMITENTE
      Form23.Label5.Caption := Trim(ibDataSet13MUNICIPIO.AsString);  // Cidade da DATA
      Form23.Label6.Caption := Copy(DateTimeToStr(Date),1,2);    // Dia da data
      Form23.Label7.Caption := Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2))));  // Mês da data
      Form23.Label8.Caption := Copy(DateTimeToStr(Date),7,4);  // Ano da data
      { Preenche na tela conforme os dados da conta}    // ibDataSet11: Arquivo de contas bancárias
      Form23.Label9.Caption := ibDataSet11AGENCIA.AsString; // Agência
      Form23.Label10.Caption := ibDataSet11CONTA.AsString;  // Número da conta
      { Preenche na tela con os dados do cheque}
      Form23.Label11.Caption := ibDataSet5DOCUMENTO.AsString; // Número do cheque
      { Canhoto }
      Form23.Label13.Caption := ibDataSet5DOCUMENTO.AsString; // Número do cheque no canhoto
      Form23.Label17.Caption := ibDataSet5EMISSAO.AsString;   // Data no canhoto
      Form23.Label18.Caption := Format('%8.2n',[ibDataSet5SAIDA_.AsFloat]); // Valor do cheque
      //
//    if Copy(AnsiUpperCase(AllTrim(ibDataSet5HISTORICO.AsString)),1,1) = 'À' then Form23.Edit1.Text := AllTrim(Copy(ibDataSet5HISTORICO.AsString,2,34))
//    else Form23.Edit1.Text := '';
      { formata o valor do chque }
      Form23.Label1.Caption := Format('%8.2n',[ibDataSet5SAIDA_.AsFloat]); // Valor do cheque
      Form23.Label2.Caption := Copy(Alltrim(Extenso(ibDataSet5Saida_.AsFloat))
                               +' '+replicate('x',200),1,56);  // 1 linha do extenso
      Form23.Label3.Caption := Copy(Alltrim(Extenso(ibDataSet5Saida_.AsFloat))
                               +' '+replicate('x',200),57,68);  // 2 linha do extenso
      //
      Form23.Button4.Enabled := True;
      Form23.Button2.Enabled := True;
      //
    end else
    begin
      // Preenche em branco
      Form23.Label14.Caption := '';
      Form23.Label15.Caption := '';
      Form23.Label5.Caption  := '';
      Form23.Label6.Caption  := '';
      Form23.Label7.Caption  := '';
      Form23.Label8.Caption  := '';
      Form23.Label9.Caption  := '';
      Form23.Label10.Caption := '';
      Form23.Label11.Caption := '';
      Form23.Label13.Caption := '';
      Form23.Label17.Caption := '';
      Form23.Label18.Caption := '';
      Form23.Label19.Caption := '';
      Form23.SMALL_DBEdit2.Text  := '';
      { formata o valor do chque }
      Form23.Label1.Caption  := '';
      Form23.Label2.Caption  := '';
      Form23.Label3.Caption  := '';
      //
      Form23.Button4.Enabled := False;
      Form23.Button2.Enabled := False;
      //
    end;
  end;
  //
end;

procedure TForm23.Button3Click(Sender: TObject);
begin
  vaivolta(-1);
end;

procedure TForm23.Button1Click(Sender: TObject);
begin
  vaivolta(1);
end;

procedure TForm23.FormShow(Sender: TObject);
begin
  Image2.Picture := Image1.Picture;
  //
  if Form7.ibDataSet5SAIDA_.AsFloat = 0 then vaivolta(1) else vaivolta(0);
  //
end;

procedure TForm23.CheckBox1Click(Sender: TObject);
begin
  Image1.Picture := Image2.Picture;
  Form23.Repaint;
  Image1.Canvas.Pen.Width  := 1;              // Largura da linha
  Image1.Canvas.Pen.Color  := clBlue;         // Cor da Fonte
  //
  if CheckBox1.Checked = True then
  begin
    // Linha 1
    Image1.Canvas.MoveTo(500+20,16);
    Image1.Canvas.Lineto(300+20,168);
    // Linha 2
    Image1.Canvas.MoveTo(450-10,16);
    Image1.Canvas.Lineto(250-10,168);
  end;

end;


procedure TForm23.FormActivate(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
  //
  Form31.MaskEdit9.Text  := Mais1Ini.ReadString(Form7.Caption,'Dígitos no ano','2');   //      valor -  2
  Form31.MaskEdit10.Text  := Mais1Ini.ReadString(Form7.Caption,'Página','30');          //      valor - 30
  //
  Form31.MaskEdit1.Text  := Mais1Ini.ReadString(Form7.Caption,'L1','1');   //      valor -  1
  Form31.MaskEdit2.Text  := Mais1Ini.ReadString(Form7.Caption,'L2','4');   //  extenso 1 -  4
  Form31.MaskEdit3.Text  := Mais1Ini.ReadString(Form7.Caption,'L3','6');   //  extenso 2 -  6
  Form31.MaskEdit4.Text  := Mais1Ini.ReadString(Form7.Caption,'L4','8');   //  nominal 1 -  8
  Form31.MaskEdit5.Text  := Mais1Ini.ReadString(Form7.Caption,'L5','10');  //    cidade  - 10
  Form31.MaskEdit6.Text  := Mais1Ini.ReadString(Form7.Caption,'L6','10');  //        dia - 10
  Form31.MaskEdit7.Text  := Mais1Ini.ReadString(Form7.Caption,'L7','10');  //        mês - 10
  Form31.MaskEdit8.Text  := Mais1Ini.ReadString(Form7.Caption,'L8','10');  //        ano - 10
  //
  Form31.MaskEdit21.Text  := Mais1Ini.ReadString(Form7.Caption,'C1','60'); //      valor - 60
  Form31.MaskEdit22.Text  := Mais1Ini.ReadString(Form7.Caption,'C2','12'); //  extenso 1 - 12
  Form31.MaskEdit23.Text  := Mais1Ini.ReadString(Form7.Caption,'C3','05'); //  extenso 2 - 05
  Form31.MaskEdit24.Text  := Mais1Ini.ReadString(Form7.Caption,'C4','05'); //  nominal 1 - 05
  Form31.MaskEdit25.Text  := Mais1Ini.ReadString(Form7.Caption,'C5','31'); //    cidade  - 31
  Form31.MaskEdit26.Text  := Mais1Ini.ReadString(Form7.Caption,'C6','52'); //        dia - 52
  Form31.MaskEdit27.Text  := Mais1Ini.ReadString(Form7.Caption,'C7','58'); //        mês - 58
  Form31.MaskEdit28.Text  := Mais1Ini.ReadString(Form7.Caption,'C8','75'); //        ano - 75
  //
  Mais1Ini.Free;
  //
  CheckBox1.Checked := False;
  //
end;

procedure TForm23.Button4Click(Sender: TObject);
{impressÆo de cheque}
var
  Largura,Altura,
  LinhaValor,ColunaValor,
  LinhaExtenso1,ColunaExtenso1,
  LinhaExtenso2,ColunaExtenso2,
  LinhaNominal,ColunaNominal,
  LinhaCidade,ColunaCidade,
  LinhaDia,ColunaDia,
  LinhaMes,ColunaMes,
  LinhaAno,ColunaAno:integer;
  //
  ArqIni, AplicaIni, Mais1Ini : tIniFile;
  F : TextFile;
  i, j : integer;
  sTexto, sInf, sExt : string;
  //
begin
  //
  try Form7.ibDataSet5.Post; except end;
  //
  Mais1ini := TIniFile.Create('retaguarda.ini');
  //
  if Mais1Ini.ReadString('Cheque','Tipo','0') = '0' then
  begin
    try
      LinhaValor     := StrToInt(AllTrim(Form31.MasKEdit1.Text));
      ColunaValor    := StrToInt(AllTrim(Form31.MasKedit21.Text));
      LinhaExtenso1  := StrToInt(AllTrim(Form31.MasKedit2.Text));
      ColunaExtenso1 := StrToInt(AllTrim(Form31.MasKedit22.Text));
      LinhaExtenso2  := StrToInt(AllTrim(Form31.MasKedit3.Text));
      ColunaExtenso2 := StrToInt(AllTrim(Form31.MasKedit23.Text));
      LinhaNominal   := StrToInt(AllTrim(Form31.MasKedit4.Text));
      ColunaNominal  := StrToInt(AllTrim(Form31.MasKedit24.Text));
      LinhaCidade    := StrToInt(AllTrim(Form31.MasKedit5.Text));
      ColunaCidade   := StrToInt(AllTrim(Form31.MasKedit25.Text));
      LinhaDia       := StrToInt(AllTrim(Form31.MasKedit6.Text));
      ColunaDia      := StrToInt(AllTrim(Form31.MasKedit26.Text));
      LinhaMes       := StrToInt(AllTrim(Form31.MasKedit7.Text));
      ColunaMes      := StrToInt(AllTrim(Form31.MasKedit27.Text));
      LinhaAno       := StrToInt(AllTrim(Form31.MasKedit8.Text));
      ColunaAno      := StrToInt(AllTrim(Form31.MasKedit28.Text));
      {começa a rotina de impressão}
      Screen.cursor :=crHourGlass;
      //
      Printer.Orientation:=poPortrait;
      Printer.BeginDoc;
      Printer.Canvas.Pen.Width :=2;
      Printer.Canvas.Font.Name := 'Courier New';
      Printer.Canvas.Font.Size := 10;
      Largura :=Printer.Canvas.TextWidth('a');
      Altura  :=Printer.Canvas.Font.Height;
       {t¡tulo que vai para o gerenciador de impressÆo}
      Printer.Title:='Impressão de Cheque';
      {----------------primeira Linha----------------}
      {Valor do cheque}
      if (ColunaValor + LinhaValor) <> 0 then Printer.Canvas.TextOut(Largura*ColunaValor,-(LinhaValor*Altura),Form23.Label1.Caption);
       {----------------segunda Linha----------------}
      {Extenso 1}
      if (ColunaExtenso1 + LinhaExtenso1) <> 0 then Printer.Canvas.TextOut(Largura*ColunaExtenso1,-(LinhaExtenso1*Altura),
         Copy(Form23.Label2.Caption+Form23.Label3.Caption,1,79-ColunaExtenso1));
      {----------------terceira Linha----------------}
      {Extenso 2}
      if (ColunaExtenso2 + LinhaExtenso2) <> 0 then Printer.Canvas.TextOut(Largura*ColunaExtenso2,-(LinhaExtenso2*Altura),
         Copy(Form23.Label2.Caption+Form23.Label3.Caption+Replicate('x',79),
         80-ColunaExtenso1,79-ColunaExtenso2));
      {----------------quarta Linha----------------}
      {Nominal}
      if (ColunaNominal + LinhaNominal) <> 0 then Printer.Canvas.TextOut(Largura*ColunaNominal,-(LinhaNominal*Altura),
      Copy(Form23.Label4.Caption+Replicate(' ',79),1,69-ColunaNominal));
      {----------------Quinta Linha----------------}
      {Cidade}
      if (ColunaCidade + LinhaCidade) <> 0 then Printer.Canvas.TextOut(Largura*ColunaCidade,-(LinhaCidade*Altura),Form23.Label5.Caption);
      {dia}
      if (ColunaDia + LinhaDia) <> 0 then Printer.Canvas.TextOut(Largura*ColunaDia,-(LinhaDia*Altura),Form23.Label6.Caption);
      {mes}
      if (ColunaMes + LinhaMes) <> 0 then Printer.Canvas.TextOut(Largura*ColunaMes,-(LinhaMes*Altura),Form23.Label7.Caption);
      {ano}
      if (ColunaAno + LinhaAno) <> 0 then Printer.Canvas.TextOut(Largura*ColunaAno,-(LinhaAno *Altura),Right(Form23.Label8.Caption,StrToInt(Form31.MaskEdit9.Text)));
      {----------------Cruzado----------------}
      if CheckBox1.Checked = True then
      begin
        Printer.Canvas.MoveTo(Largura*ColunaValor,-(LinhaValor*Altura));
        Printer.Canvas.LineTo(Largura*ColunaCidade,-((LinhaCidade+1)*Altura));
        Printer.Canvas.MoveTo(Largura*(ColunaValor-7),-(LinhaValor*Altura));
        Printer.Canvas.LineTo(Largura*(ColunaCidade-7),-((LinhaCidade+1)*Altura));
      end;
      Printer.EndDoc;
      screen.cursor := crDefault;
    except end;
  end else
  begin
    //
    ArqIni := TIniFile.Create( Form1.sAtual + '\smallcom.inf');
    Arqini.UpdateFile;
    AplicaIni := TIniFile.Create('retaguarda.ini');
    Aplicaini.UpdateFile;
    //
    AssignFile(F, AplicaIni.ReadString('CHEQUE', 'PORTA', 'LPT1'));
    Rewrite(F);
    Form7.ibDataSet5.DisableControls;
    if Form7.ibDataSet5.FieldByName('SAIDA_').AsFloat > 0 then
    begin
      for i:=1 to ArqIni.ReadInteger(Form7.Caption, 'Página', 30) do
      begin
        sTexto := '';
        for j := 1 to 8 do
        begin
          sExt := Extenso(Form7.ibDataSet5.FieldByName('SAIDA_').AsFloat) + ' ' + Replicate('x', 80);
          if j = 1 then sInf := Replicate(' ', ArqIni.ReadInteger(Form7.Caption, 'C1', 0)) + StrTran(Format('%9.2n', [Form7.ibDataSet5.FieldByName('SAIDA_').AsFloat]), ' ', '');
          if j = 2 then sInf := Replicate(' ', ArqIni.ReadInteger(Form7.Caption, 'C2', 0)) + Copy(sExt, 1, 80 - ArqIni.ReadInteger(Form7.Caption, 'C2', 0));
          if j = 3 then sInf := Replicate(' ', ArqIni.ReadInteger(Form7.Caption, 'C3', 0)) + Copy(sExt + Replicate('x', 80), Length(Copy(sExt, 1, 80 - ArqIni.ReadInteger(Form7.Caption, 'C2', 0))) + 1, 80 - ArqIni.ReadInteger(Form7.Caption, 'C3', 0));
          if j = 4 then
             if Form7.ibDataSet5.FieldByName('NOMINAL').AsString <> '' then sInf := Replicate(' ', ArqIni.ReadInteger(Form7.Caption, 'C4', 0)) + Copy(Form7.ibDataSet5.FieldByName('NOMINAL').AsString + ' ' + Replicate('x', 80), 1, 80) else sInf := '';
          if j = 5 then sInf := Replicate(' ', ArqIni.ReadInteger(Form7.Caption, 'C5', 0)) + Form7.ibDataSet13.FieldByName('MUNICIPIO').AsString;
          if j = 6 then sInf := Replicate(' ', ArqIni.ReadInteger(Form7.Caption, 'C6', 0)) + IntToStr(Day(Form7.ibDataSet5.FieldByName('EMISSAO').AsDateTime));
          if j = 7 then sInf := Replicate(' ', ArqIni.ReadInteger(Form7.Caption, 'C7', 0)) + MesExtenso(Month(Form7.ibDataSet5.FieldByName('EMISSAO').AsDateTime));
          if j = 8 then sInf := Replicate(' ', ArqIni.ReadInteger(Form7.Caption, 'C8', 0)) + right(IntToStr(Year(Form7.ibDataSet5.FieldByName('EMISSAO').AsDateTime)), ArqIni.ReadInteger(Form7.Caption, 'Dígitos no ano', 4));

          if i = ArqIni.ReadInteger(Form7.Caption, 'L' + IntToStr(j), 0) then
          begin
            if length(sInf) > Length(sTexto) then
              sTexto := sTexto + Copy(sInf, Length(sTexto), Length(sInf))
            else
              sTexto := sInf + copy(sTexto, Length(sinf), Length(sTexto));
          end;
        end;
        sTexto := copy(ConverteAcentos(sTexto) + Replicate(' ', 80), 1, 80);
        // Cruzar o cheque
        if (i < ArqIni.ReadInteger(Form7.Caption, 'Página', 30)) and (i < 40) then
        begin
          if CheckBox1.Checked then sTexto := Copy(sTexto, 1, 40 - i) + '/' + Copy(sTexto, 40 - i + 2, 80);
          if CheckBox1.Checked then sTexto := Copy(sTexto, 1, 44 - i) + '/' + Copy(sTexto, 44 - i + 2, 80);
        end;
        Writeln(F, sTexto);
      end;
    end;
    CloseFile(F);
    Form7.ibDataSet5.EnableControls;
    //
  end;
  Mais1ini.Free;
end;
procedure TForm23.Button5Click(Sender: TObject);
begin
  Form31.ShowModal;
end;

procedure TForm23.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Mais1Ini: TIniFile;
begin
  //
  try
    Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
    //
    Mais1Ini.WriteString(Form7.Caption,'Dígitos no ano','0'+LimpaNumero(Form31.MaskEdit9.Text)); //      valor -  2
    Mais1Ini.WriteString(Form7.Caption,'Página','0'+LimpaNumero(Form31.MaskEdit10.Text)); //      valor -  30
    //
    Mais1Ini.WriteString(Form7.Caption,'L1','0'+LimpaNumero(Form31.MaskEdit1.Text)); //      valor -  1
    Mais1Ini.WriteString(Form7.Caption,'L2','0'+LimpaNumero(Form31.MaskEdit2.Text)); //  extenso 1 -  4
    Mais1Ini.WriteString(Form7.Caption,'L3','0'+LimpaNumero(Form31.MaskEdit3.Text)); //  extenso 2 -  6
    Mais1Ini.WriteString(Form7.Caption,'L4','0'+LimpaNumero(Form31.MaskEdit4.Text)); //  nominal 1 -  8
    Mais1Ini.WriteString(Form7.Caption,'L5','0'+LimpaNumero(Form31.MaskEdit5.Text)); //    cidade  - 10
    Mais1Ini.WriteString(Form7.Caption,'L6','0'+LimpaNumero(Form31.MaskEdit6.Text)); //        dia - 10
    Mais1Ini.WriteString(Form7.Caption,'L7','0'+LimpaNumero(Form31.MaskEdit7.Text)); //        mês - 10
    Mais1Ini.WriteString(Form7.Caption,'L8','0'+LimpaNumero(Form31.MaskEdit8.Text)); //        ano - 10
    //
    Mais1Ini.WriteString(Form7.Caption,'C1','0'+LimpaNumero(Form31.MaskEdit21.Text));//      valor - 60
    Mais1Ini.WriteString(Form7.Caption,'C2','0'+LimpaNumero(Form31.MaskEdit22.Text));//  extenso 1 - 12
    Mais1Ini.WriteString(Form7.Caption,'C3','0'+LimpaNumero(Form31.MaskEdit23.Text));//  extenso 2 - 05
    Mais1Ini.WriteString(Form7.Caption,'C4','0'+LimpaNumero(Form31.MaskEdit24.Text));//  nominal 1 - 05
    Mais1Ini.WriteString(Form7.Caption,'C5','0'+LimpaNumero(Form31.MaskEdit25.Text));//    cidade  - 31
    Mais1Ini.WriteString(Form7.Caption,'C6','0'+LimpaNumero(Form31.MaskEdit26.Text));//        dia - 52
    Mais1Ini.WriteString(Form7.Caption,'C7','0'+LimpaNumero(Form31.MaskEdit27.Text));//        mês - 58
    Mais1Ini.WriteString(Form7.Caption,'C8','0'+LimpaNumero(Form31.MaskEdit28.Text));//        ano - 75
    
    Mais1Ini.Free;
  except
    //ShowMessage('Erro de gravação no arquivo smallcom.inf') Mauricio Parizotto 2023-10-25
    MensagemSistema('Erro de gravação no arquivo smallcom.inf',msgErro);
  end;
end;

procedure TForm23.Button6Click(Sender: TObject);
begin
  Close;
end;


procedure TForm23.SMALL_DBEdit2Change(Sender: TObject);
begin
  if SMALL_DBEdit2.Text <> '' then Label4.Caption :=
  copy(alltrim(SMALL_DBEdit2.Text)+' '+replicate('x',200),1,67) else Label4.Caption := '';
end;

procedure TForm23.SMALL_DBEdit2Exit(Sender: TObject);
begin
//if Copy(UpperCase(AllTrim(Form7.ibDataSet5HISTORICO.AsString)),1,1) = 'À' then
//begin
//  Form7.ibDataSet5.Edit;
//  Form7.ibDataSet5HISTORICO.AsString := 'À '+Edit1.Text;
//  Form7.ibDataSet5.Post;
//end;
end;

procedure TForm23.FormCreate(Sender: TObject);
begin
  //
end;

end.


