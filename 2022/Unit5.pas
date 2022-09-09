//
// Paleta de cores da Small
//

// $007D7AEA // Vermelho   60%
// $0088F6FF // Amarelo  60 %
// $008FC26C // Verde  60 %
// $00F4C84D // Azul 60 %
// $00C1BFBD
// $00E1E6F0
// $00888FFF
// $0088F6FF
// $008FC26C
// $00F4C84D
// $007D7AEA
// $00FFFFFF
// $00F4C84D ; // Roxo pra combinar


//
//
//
unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, OleCtrls, SHDocVw, SmallFunc, Grids,
  inifiles, shellapi, DBCtrls, DBGrids, Mask, SMALL_DBEdit;

type
  TForm5 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Image2: TImage;
    Panel3: TPanel;
    Image3: TImage;
    Panel4: TPanel;
    Image4: TImage;
    Panel5: TPanel;
    Image5: TImage;
    Panel6: TPanel;
    Image6: TImage;
    Panel7: TPanel;
    Image7: TImage;
    Panel8: TPanel;
    Image8: TImage;
    Panel9: TPanel;
    Image9: TImage;
    Panel10: TPanel;
    Image10: TImage;
    Panel11: TPanel;
    Image11: TImage;
    Panel12: TPanel;
    Image12: TImage;
    Panel13: TPanel;
    Image13: TImage;
    Panel14: TPanel;
    Image14: TImage;
    Panel15: TPanel;
    Image15: TImage;
    Panel16: TPanel;
    Image16: TImage;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Panel17: TPanel;
    Image17: TImage;
    Panel18: TPanel;
    Image18: TImage;
    Panel19: TPanel;
    Image19: TImage;
    Panel20: TPanel;
    Image20: TImage;
    Panel21: TPanel;
    Image21: TImage;
    Panel22: TPanel;
    Image22: TImage;
    Panel23: TPanel;
    Image23: TImage;
    Panel24: TPanel;
    Image24: TImage;
    procedure FormShow(Sender: TObject);
    procedure Image16MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ScrollBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image16MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image16EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure Image16DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Image1Expande(Sender: TObject);
    procedure Image2Expande(Sender: TObject);
    procedure Image7Expande(Sender: TObject);
    procedure Image3Expande(Sender: TObject);
    procedure Image4Expande(Sender: TObject);
    procedure Image8Expande(Sender: TObject);
    procedure Image5Expande(Sender: TObject);
    procedure Image6Expande(Sender: TObject);
    procedure Image9Expande(Sender: TObject);
    procedure Image10Expande(Sender: TObject);
    procedure Image11Expande(Sender: TObject);
    procedure Image12Expande(Sender: TObject);
    procedure Image13Expande(Sender: TObject);
    procedure Image14Expande(Sender: TObject);
    procedure Image15Expande(Sender: TObject);
    procedure Image16Expande(Sender: TObject);
    procedure Image17Expande(Sender: TObject);
    procedure Image18Expande(Sender: TObject);
    procedure Image19Expande(Sender: TObject);
    procedure Image20Expande(Sender: TObject);
    procedure Image21Expande(Sender: TObject);
    procedure Image22Expande(Sender: TObject);
    procedure Image23Expande(Sender: TObject);
    procedure Image24Expande(Sender: TObject);


    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ScrollBox1DblClick(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    { Private declarations }
  public
    { Public declarations }
    iXPublic, iYPublic, iTabOrder : Integer;
    fMutado : Real;

  end;


var
  Form5: TForm5;

implementation

uses Mais, Unit7, Mais3, Unit12, Unit24;

{$R *.dfm}

function ExpandeOGrafico(Objeto: tObject): boolean;
begin
  //
  if tPanel(Objeto).Name = 'Image1'  then Form5.Image1Expande(Objeto);
  if tPanel(Objeto).Name = 'Image2'  then Form5.Image2Expande(Objeto);
  if tPanel(Objeto).Name = 'Image3'  then Form5.Image3Expande(Objeto);
  if tPanel(Objeto).Name = 'Image4'  then Form5.Image4Expande(Objeto);
  if tPanel(Objeto).Name = 'Image5'  then Form5.Image5Expande(Objeto);
  if tPanel(Objeto).Name = 'Image6'  then Form5.Image6Expande(Objeto);
  if tPanel(Objeto).Name = 'Image7'  then Form5.Image7Expande(Objeto);
  if tPanel(Objeto).Name = 'Image8'  then Form5.Image8Expande(Objeto);
  if tPanel(Objeto).Name = 'Image9'  then Form5.Image9Expande(Objeto);
  if tPanel(Objeto).Name = 'Image10' then Form5.Image10Expande(Objeto);
  if tPanel(Objeto).Name = 'Image11' then Form5.Image11Expande(Objeto);
  if tPanel(Objeto).Name = 'Image12' then Form5.Image12Expande(Objeto);
  if tPanel(Objeto).Name = 'Image13' then Form5.Image13Expande(Objeto);
  if tPanel(Objeto).Name = 'Image14' then Form5.Image14Expande(Objeto);
  if tPanel(Objeto).Name = 'Image15' then Form5.Image15Expande(Objeto);
  if tPanel(Objeto).Name = 'Image16' then Form5.Image16Expande(Objeto);
  if tPanel(Objeto).Name = 'Image17' then Form5.Image17Expande(Objeto);
  if tPanel(Objeto).Name = 'Image18' then Form5.Image18Expande(Objeto);
  if tPanel(Objeto).Name = 'Image19' then Form5.Image19Expande(Objeto);
  if tPanel(Objeto).Name = 'Image20' then Form5.Image20Expande(Objeto);
  if tPanel(Objeto).Name = 'Image21' then Form5.Image21Expande(Objeto);
  if tPanel(Objeto).Name = 'Image22' then Form5.Image22Expande(Objeto);
  if tPanel(Objeto).Name = 'Image23' then Form5.Image23Expande(Objeto);
  if tPanel(Objeto).Name = 'Image24' then Form5.Image24Expande(Objeto);
  //
  Result := True;
  //
end;


function CarregaGrafico(sImagem: tImage; sN: String; pB: boolean): boolean;
var
  I : Integer;
begin
  //
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  //
  if pB then
  begin
    for I := 1 to 120 do
    begin
      if not FileExists(pchar(Form1.sAtual+'\'+sN+'.png')) then
      begin
        Sleep(25);
      end;
    end;
  end;
  //
  try
    //
    if FileExists(pchar(Form1.sAtual+'\'+sN+'.png')) then
    begin
      //
      while FileExists(pChar(Form1.sAtual+'\'+sN+'_ok.png')) do
      begin
        DeleteFile(pChar(Form1.sAtual+'\'+sN+'_ok.png'));
        Sleep(5);
      end;
      //
      while not FileExists(pchar(Form1.sAtual+'\'+sN+'_ok.png')) do
      begin
        RenameFile(pchar(Form1.sAtual+'\'+sN+'.png'),pchar(Form1.sAtual+'\'+sN+'_ok.png'));
        Sleep(5);
      end;
      //
      Sleep(5);
      //
    end;
    //
    if FileExists(pchar(Form1.sAtual+'\'+sN+'_ok.png')) then
    begin
      try sImagem.Picture.LoadFromFile(pchar(Form1.sAtual+'\'+sN+'_ok.png')) except end;
    end;
    //
  except end;
  //
  Form5.BringToFront;
  Screen.Cursor := crdefault; // Cursor de Aguardo
  Result := True;
  //
end;



function GeraGrafico(sNome: String): boolean;
begin
  //
  while FileExists(pChar(Form1.sAtual+'\'+sNome+'.png')) do
  begin
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    Sleep(5);
  end;
  //
  ShellExecute( 0, 'Open', 'graficos.exe', pChar(sNome+'.gra SMALLSOFT'), '', SW_SHOWMINNOACTIVE);
  Result := True;
  //
end;


function PosicionaIndicador(Sender: tPanel): boolean;
var
  vTop:  array [0..500] of integer;  // Cria uma matriz com 12 elementos
  vLeft: array [0..500] of integer;  // Cria uma matriz com 12 elementos
  I, iTop, iLeft : Integer;
begin
  //
  try
    //
    Form5.Left   := Form7.Left;
    Form5.Height := Form7.Height;
    Form5.Width  := Form7.Width;
    Form5.Top    := Form7.Top;
    //
    iTop := 10;
    iLEft := 10;
    //
    for I := 0 to 24 do
    begin
      //
      vTop[I]  := iTop;
      vLeft[I] := iLeft;
      //
      iLeft  := iLeft + 310;
      //
      if ((iLeft + 310) > (4*310+10)) or ((iLeft + 310) > Form5.Width) then
      begin
        iLeft := 10;
        iTop  := iTop + 160;
      end;
      //
    end;
    //
    with Sender do
    begin
      Top  := vTop[TabOrder];
      Left := vLeft[TabOrder];
    end;
    //
  except end;
  //
  try
    Form5.ScrollBox1.Repaint;
  except end;
  //
  Result := True;
  //
end;

function PosicionatodosOsIndicadores(Sender: tPanel): boolean;
begin
  //
  try
    //
    Form5.ScrollBox1.VertScrollBar.Position := 0;
    //
    PosicionaIndicador(Form5.Panel1);
    PosicionaIndicador(Form5.Panel2);
    PosicionaIndicador(Form5.Panel3);
    PosicionaIndicador(Form5.Panel4);
    PosicionaIndicador(Form5.Panel5);
    PosicionaIndicador(Form5.Panel6);
    PosicionaIndicador(Form5.Panel7);
    PosicionaIndicador(Form5.Panel8);
    PosicionaIndicador(Form5.Panel9);
    PosicionaIndicador(Form5.Panel10);
    PosicionaIndicador(Form5.Panel11);
    PosicionaIndicador(Form5.Panel12);
    PosicionaIndicador(Form5.Panel13);
    PosicionaIndicador(Form5.Panel14);
    PosicionaIndicador(Form5.Panel15);
    PosicionaIndicador(Form5.Panel16);
    PosicionaIndicador(Form5.Panel17);
    PosicionaIndicador(Form5.Panel18);
    PosicionaIndicador(Form5.Panel19);
    PosicionaIndicador(Form5.Panel20);
    PosicionaIndicador(Form5.Panel21);
    PosicionaIndicador(Form5.Panel22);
    PosicionaIndicador(Form5.Panel23);
    PosicionaIndicador(Form5.Panel24);
    //
  except end;
  //
  Result := True;
  //
end;

function GraficoCalendario(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  J, I, iLarg, iAlt : Integer;
  dContador : tDateTime;
  bChave : Boolean;
begin
  try
    /////////////////////////
    // C A L E N D A R I O //
    /////////////////////////
    bChave     := True;
    iLarg      := (iFont * 2) + Abs(Ifont div 2);
    iAlt       := (iFont * 2);
    dContador  := StrToDate('01/'+StrZero(Month(Date),2,0)+'/'+StrZero(Year(Date),4,0));
    //
    Form5.Image1.Canvas.Brush.Color := ClWhite;
    Form5.Image1.Canvas.Pen.Color   := ClWhite;
    Form5.Image1.Canvas.Rectangle(0,0,iX,iY);
    //
    Form5.Image1.Canvas.Font.Name  := 'Microsoft Sans Serif';
    Form5.Image1.Canvas.Font.Style := [fsBold];
    Form5.Image1.Canvas.Font.Size  := iFont;
    Form5.Image1.Canvas.Font.Color := clBlack;
    //
    Form5.Image1.Canvas.TextOut(iFont,iFont, pChar( IntToStr(Day(Date)) + ' de ' + LowerCase(Alltrim(MesExtenso(Month(Date)))) + ' de ' + IntToStr(Year(Date)) ) );
    //
    Form5.Image1.Canvas.Font.Style := [];
    Form5.Image1.Canvas.Font.Color := clSilver;
    //
    J := 0;
    for I := 1 to DiasPorMes(Year(Date),Month(Date)) do
    begin
      if (DayOfWeek(dContador) = 7) or (DayOfWeek(dContador) = 1) then Form5.Image1.Canvas.Font.Color := clRed else Form5.Image1.Canvas.Font.Color := clBlack;
      if bChave then Form5.Image1.Canvas.TextOut(((iLarg*2)* DayOfWeek(dContador))-iLarg, (iAlt * 2),Copy(DiaDaSemana(dContador),1,3));  // Cabeçalho
      if (Date = dContador) then
      begin
        Form5.Image1.Canvas.Brush.Color := $00EAB231;
        Form5.Image1.Canvas.Font.Color := ClWhite;
        Form5.Image1.Canvas.Font.Style := [fsBold];
      end else
      begin
        Form5.Image1.Canvas.Brush.Color := ClWhite;
        Form5.Image1.Canvas.Font.Color := clSilver;
        Form5.Image1.Canvas.Font.Style := [];
      end;
      Form5.Image1.Canvas.TextOut(((iLarg*2) * DayOfWeek(dContador))-iLarg, ((iAlt*3)+J), Right('   '+IntToStr(Day(dContador))+' ',4)  );     // Dias
      Form5.Image1.Canvas.Brush.Color := ClWhite;
      if DayOfWeek(dContador) = 7 then J := J + iAlt;
      dContador := dContador + 1;
      if DayOfWeek(dContador) = DayOfWeek(StrToDate('01/'+StrZero(Month(Date),2,0)+'/'+StrZero(Year(Date),4,0))) then bChave := False;
    end;
    /////////////////////////
    // C A L E N D A R I O //
    /////////////////////////
    //
  except end;
  //
  Result := True;
  //
end;



function GraficoRegistrosNoCadastro(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  Mais1Ini: TIniFile;
  I : Integer;
begin
  //
  // GRAFICO
  //
  try
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    //                        //
    // cria o vendedores.gra //
    //                      //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    //
    // Titulo
    //
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','Legenda','1');
    Mais1Ini.WriteString('DADOS','TipoS1','4');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    //
    Mais1Ini.WriteString('DADOS','Titulo','Registros no cadastro');
    Mais1Ini.WriteString('DADOS','SubTitulo','');
    Mais1Ini.WriteString('DADOS','NomeBmp','tempo.png');
    Mais1Ini.WriteString('DADOS','CorS1','$00EAB231');
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont));
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    // ITENS001 e ALTERACA
    //
    Form1.ibQueryGrafico.Close;
    Form1.ibQueryGrafico.SQL.Clear;
    Form1.ibQueryGrafico.SQL.Add('select count(REGISTRO)as QTD, Coalesce(CLIFOR,''Cliente'')as RELACAO from CLIFOR group by RELACAO');
    Form1.ibQueryGrafico.Open;
    //
    I := 0;
    //
    while not Form1.ibQueryGrafico.Eof do
    begin
      I := I + 1;
      Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),
                                   'S1<'+StrTran(Format('%15.2n',[ Form1.ibQueryGrafico.FieldByName('QTD').AsFloat ]),'.','')+'>'+
                                   'S2<'+StrTran(Format('%15.2n',[ Form1.ibQueryGrafico.FieldByName('QTD').AsFloat ]),'.','')+'>'+
                                   'VX<'+StrZero(I,2,0)+'>LX<'+AllTrim(StrTran(Format('%10.0n',[ Form1.ibQueryGrafico.FieldByName('QTD').AsFloat ]),'.',''))+' '+
                                   StrTran(
                                   StrTran(
                                   StrTran(
                                   StrTran(
                                   StrTran(
                                   StrTran(
                                   StrTran(
                                   StrTran(

                                   Uppercase(Form1.ibQueryGrafico.FieldByName('RELACAO').AsString)
                                    ,Uppercase('Cliente/Fornecedor')     ,'Clientes/Fornecedores' )
                                    ,Uppercase('Funcionário'       )     ,'Funcionários'          )
                                    ,Uppercase('Revenda'           )     ,'Revendas'              )
                                    ,Uppercase('Representante'     )     ,'Representantes'        )
                                    ,Uppercase('Distribuidor'      )     ,'Distribuidores'        )
                                    ,Uppercase('Vendedor'          )     ,'Vendedores'            )
                                    ,Uppercase('Cliente'           )     ,'Clientes'              )
                                    ,Uppercase('Fornecedor'        )     ,'Fornecedores'          )
                                   +
                                   '>');
      Form1.ibQueryGrafico.Next;
    end;
    //
    Mais1Ini.Free;
    //
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;

function GraficoVendasMes(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  Mais1Ini: TIniFile;
  dInicio, dFinal : TdateTime;
  I : Integer;
  vTotalDoMes:  array [1..12] of Real;  // Cria uma matriz com 12 elementos
begin
  //
  try
    //
//    dInicio := StrtoDate('01/01/2021');
//    dFinal  := StrtoDate('31/12/2021');
    dInicio := StrtoDate('01/01/'+IntToStr(Year(Date)));
    dFinal  := StrtoDate('31/12/'+IntToStr(Year(Date)));
    //
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    //                              //
    // cria o gráfico de vndas.png //
    //                            //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    //
    // Titulo
    //
    if Right(sNome,1) = 'G' then
    begin
      Mais1Ini.WriteString('DADOS','FontSizeMarks',IntToStr((5 * Screen.Width div 300)));
    end else
    begin
      Mais1Ini.WriteString('DADOS','FontSizeMarks',IntToStr(5));
    end;
    //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','TituloY','');
    Mais1Ini.WriteString('DADOS','TipoS1','0');
    Mais1Ini.WriteString('DADOS','Titulo','Vendas por mês '+IntToStr(Year(DATE)));
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','TituloX','');
    Mais1Ini.WriteString('DADOS','CorS1','$0088F6FF'); // Amarelo 60%
    Mais1Ini.WriteString('DADOS','TituloSerie1','');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont));
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    for I := 1 to 12 do
    begin
      vTotalDoMes[I] := 0;
    end;
    //
    // Vendas NFe
    //
    Form1.ibQueryGrafico.Close;
    Form1.ibQueryGrafico.SQL.Clear;
    Form1.ibQueryGrafico.SQL.Add('select sum(VENDAS.MERCADORIA+VENDAS.SERVICOS-VENDAS.DESCONTO)as VTOT, extract(month from VENDAS.EMISSAO)'+
                           ' as VMES from VENDAS, ICM where VENDAS.EMITIDA=''S'' and EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+
                           ' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and ICM.NOME=VENDAS.OPERACAO and ICM.INTEGRACAO<>'''' group by VMES order by VMES');
    Form1.ibQueryGrafico.Open;
    Form1.ibQueryGrafico.First;
    //
    while not Form1.ibQueryGrafico.Eof do
    begin
      vTotalDoMes[StrToInt(Form1.ibQueryGrafico.FieldByName('VMES').AsString)] := Form1.ibQueryGrafico.FieldByName('vTOT').AsFloat;
      Form1.ibQueryGrafico.Next;
    end;
    //
    // Vendas NCe
    //
    Form1.ibQueryGrafico.Close;
    Form1.ibQueryGrafico.SQL.Clear;
    Form1.ibQueryGrafico.SQL.Add('select sum(ALTERACA.TOTAL)as VTOT, extract(month from ALTERACA.DATA) as VMES from ALTERACA where ALTERACA.DATA<='+QuotedStr(DateToStrInvertida(dFinal))+' and ALTERACA.DATA>='+QuotedStr(DateToStrInvertida(dInicio))+' and (TIPO='+QuotedStr('BALCAO')+' or TIPO='+QuotedStr('VENDA')+') '+
                                 ' group by VMES order by VMES');
    Form1.ibQueryGrafico.Open;
    Form1.ibQueryGrafico.First;
    //
    while not Form1.ibQueryGrafico.Eof do
    begin
      vTotalDoMes[StrToInt(Form1.ibQueryGrafico.FieldByName('VMES').AsString)] := vTotalDoMes[StrToInt(Form1.ibQueryGrafico.FieldByName('VMES').AsString)] + Form1.ibQueryGrafico.FieldByName('vTOT').AsFloat;
      Form1.ibQueryGrafico.Next;
    end;
    //
    for I := 1 to 12 do
    begin
      Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),
                                     'S1<'+StrTran(Format('%15.2n',[vTotalDoMes[I]]),'.','')+'>'+
                                     'S2< 0,00>'+
                                     'VX<'+StrZero(I,2,0)+'>LX<'+ Copy(MesExtenso(I),1,3)+'>');
    end;
    //
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;


function GraficoVendasAno(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  Mais1Ini: TIniFile;
  iAno, I : Integer;
  vTotalDoAno:  array [1..3000] of Real;  // Cria uma matriz com 12 elementos
begin
  //
  try
    //
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    //                              //
    // cria o gráfico de vndas.png //
    //                            //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    //
    // Titulo
    //
    if Right(sNome,1) = 'G' then
    begin
      Mais1Ini.WriteString('DADOS','FontSizeMarks',IntToStr((5 * Screen.Width div 300)));
    end else
    begin
      Mais1Ini.WriteString('DADOS','FontSizeMarks',IntToStr(5));
    end;
    //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','TituloY','');
    Mais1Ini.WriteString('DADOS','TipoS1','0');
    Mais1Ini.WriteString('DADOS','Titulo','Vendas por ano ');
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','TituloX','');
    Mais1Ini.WriteString('DADOS','CorS1','$0088F6FF'); // Amarelo 60%
    Mais1Ini.WriteString('DADOS','TituloSerie1','');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont));
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    for iAno := 1995 to 2030 do
    begin
      vTotalDoAno[iAno] := 0;
    end;
    //
    // Vendas NFe
    //
    Form1.ibQueryGrafico.Close;
    Form1.ibQueryGrafico.SQL.Clear;
    Form1.ibQueryGrafico.SQL.Add('select sum(VENDAS.MERCADORIA+VENDAS.SERVICOS-VENDAS.DESCONTO)as VTOT, extract(year from VENDAS.EMISSAO) as VANO from VENDAS, ICM where VENDAS.EMITIDA=''S'' and ICM.NOME=VENDAS.OPERACAO and ICM.INTEGRACAO<>'''' group by VANO order by VANO');
    Form1.ibQueryGrafico.Open;
    Form1.ibQueryGrafico.First;
    //
    while not Form1.ibQueryGrafico.Eof do
    begin
      if LimpaNumero(Form1.ibQueryGrafico.FieldByName('VANO').AsString) <> '' then
      begin
        vTotalDoAno[StrToInt(Form1.ibQueryGrafico.FieldByName('VANO').AsString)] := Form1.ibQueryGrafico.FieldByName('vTOT').AsFloat;
      end;
      Form1.ibQueryGrafico.Next;
    end;
    //
    // Vendas NCe
    //
    Form1.ibQueryGrafico.Close;
    Form1.ibQueryGrafico.SQL.Clear;
    Form1.ibQueryGrafico.SQL.Add('select sum(ALTERACA.TOTAL)as VTOT, extract(Year from ALTERACA.DATA) as VANO from ALTERACA where (TIPO='+QuotedStr('BALCAO')+' or TIPO='+QuotedStr('VENDA')+') '+
                                 ' group by VANO order by VANO');
    Form1.ibQueryGrafico.Open;
    Form1.ibQueryGrafico.First;
    //
    while not Form1.ibQueryGrafico.Eof do
    begin
      vTotalDoAno[StrToInt(Form1.ibQueryGrafico.FieldByName('VANO').AsString)] := vTotalDoAno[StrToInt(Form1.ibQueryGrafico.FieldByName('VANO').AsString)] + Form1.ibQueryGrafico.FieldByName('vTOT').AsFloat;
      Form1.ibQueryGrafico.Next;
    end;
    //
    I := 0;
    //
    for iAno := 1995 to 2030 do
    begin
      if vTotalDoAno[iAno] <> 0 then
      begin
        I := I + 1;
        Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),
                                       'S1<'+StrTran(Format('%15.2n',[vTotalDoAno[iAno]]),'.','')+'>'+
                                       'S2< 0,00>'+
                                       'VX<'+StrZero(I,2,0)+'>LX<'+ StrZero(iAno,4,0) +'>');
      end;
    end;
    //
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;


function GraficoVendas(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  Mais1Ini: TIniFile;
  dInicio, dFinal : TdateTime;
begin
  //
  try
    //
    dInicio := Date-90;
    dFinal  := Date;
    //
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    //                              //
    // cria o gráfico de vndas.png //
    //                            //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    //
    // Titulo
    //
    Mais1Ini.WriteString('DADOS','3D','1');
    //
    if Right(sNome,1) = 'G' then
    begin
      Mais1Ini.WriteString('DADOS','FontSizeMarks',IntToStr((5 * Screen.Width div 300)));
    end else
    begin
      Mais1Ini.WriteString('DADOS','FontSizeMarks',IntToStr(5));
    end;
    //
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','Legenda','1');
    Mais1Ini.WriteString('DADOS','TipoS1','4');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    Mais1Ini.WriteString('DADOS','Titulo','Vendas últimos 90 dias');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','CorS1','$007D7AEA'); // Vermelho 60%
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont));
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select sum(MERCADORIA+SERVICOS-DESCONTO)as TOT from VENDAS, ICM where  EMITIDA=''S'' and EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and ICM.NOME=VENDAS.OPERACAO and ICM.INTEGRACAO<>'''' ');
    Form1.ibQuery1.Open;
    //
    Mais1Ini.WriteString('DADOS','XY'+'02',
                                 'S1<'+StrTran(Format('%15.2n',[ Form1.ibQuery1.FieldByName('TOT').AsFloat]),'.','')+'>'+
                                 'S2<'+StrTran(Format('%15.2n',[ Form1.ibQuery1.FieldByName('TOT').AsFloat]),'.','')+'>'+
                                 'VX<02>LX<Atual: '+AllTrim(Format('%15.0n',[(Form1.ibQuery1.FieldByName('TOT').AsFloat)/1000]))  +' mil>');
    //
    dInicio := StrToDate(StrZero(Day(dInicio),2,0)+'/'+StrZero(Month(dInicio),2,0)+'/'+StrZero(Year(dInicio)-1,4,0));
    dFinal  := StrToDate(StrZero(Day(dfinal),2,0)+'/'+StrZero(Month(dFinal),2,0)+'/'+StrZero(Year(dFinal)-1,4,0));
    //
    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('select sum(MERCADORIA+SERVICOS-DESCONTO)as TOT from VENDAS, ICM where  EMITIDA=''S'' and EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and ICM.NOME=VENDAS.OPERACAO and ICM.INTEGRACAO<>'''' ');
    Form1.ibQuery2.Open;
    //
    Mais1Ini.WriteString('DADOS','XY'+'01',
                                 'S1<'+StrTran(Format('%15.2n',[ Form1.ibQuery2.FieldByName('TOT').AsFloat]),'.','')+'>'+
                                 'S2<'+StrTran(Format('%15.2n',[ Form1.ibQuery2.FieldByName('TOT').AsFloat]),'.','')+'>'+
                                 'VX<01>LX<Anterior: '+AllTrim(Format('%15.0n',[(Form1.ibQuery2.FieldByName('TOT').AsFloat)/1000]))  +' mil>');


    //
    if Form1.ibQuery1.FieldByName('TOT').AsFloat > Form1.ibQuery2.FieldByName('TOT').AsFloat then
    begin
      Mais1Ini.WriteString('DADOS','SubTitulo','Aumento de '+
      AllTrim(StrTran(StrTran(Format('%15.2n',[(((Form1.ibQuery2.FieldByName('TOT').AsFloat / Form1.ibQuery1.FieldByName('TOT').AsFloat)-1)*100)]),'.',''),'-',''))+'% no período');
    end else
    begin
      Mais1Ini.WriteString('DADOS','SubTitulo','Queda de '+
      AllTrim(StrTran(StrTran(Format('%15.2n',[(((Form1.ibQuery1.FieldByName('TOT').AsFloat / Form1.ibQuery2.FieldByName('TOT').AsFloat)-1)*100*-1)]),'.',''),'-',''))+'% no período');
    end;
    //
    Mais1Ini.Free;
    //
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;


function GraficoVendasParciais(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  Mais1Ini: TIniFile;
  dInicio, dFinal : TdateTime;
begin
  //
  try
    //
    dInicio := StrToDate('01/01/'+StrZero(Year(Date),4,0));
    dFinal  := Date;
    //
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    //                              //
    // cria o gráfico de vndas.png //
    //                            //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    //
    // Titulo
    //
    Mais1Ini.WriteString('DADOS','3D','1');
    //
    if Right(sNome,1) = 'G' then
    begin
      Mais1Ini.WriteString('DADOS','FontSizeMarks',IntToStr((5 * Screen.Width div 300)));
    end else
    begin
      Mais1Ini.WriteString('DADOS','FontSizeMarks',IntToStr(5));
    end;
    //
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','Legenda','1');
    Mais1Ini.WriteString('DADOS','TipoS1','4');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    Mais1Ini.WriteString('DADOS','Titulo','Vendas do ano até '+Copy(DateToStr(Date),1,5));
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','CorS1','$00EAB231');
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont));
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select sum(MERCADORIA+SERVICOS-DESCONTO)as TOT from VENDAS, ICM where  EMITIDA=''S'' and EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and ICM.NOME=VENDAS.OPERACAO and ICM.INTEGRACAO<>'''' ');
    Form1.ibQuery1.Open;
    //
    Mais1Ini.WriteString('DADOS','XY'+'02',
                                 'S1<'+StrTran(Format('%15.2n',[ Form1.ibQuery1.FieldByName('TOT').AsFloat]),'.','')+'>'+
                                 'S2<'+StrTran(Format('%15.2n',[ Form1.ibQuery1.FieldByName('TOT').AsFloat]),'.','')+'>'+
                                 'VX<02>LX<Atual: '+AllTrim(Format('%15.0n',[(Form1.ibQuery1.FieldByName('TOT').AsFloat)/1000]))  +' mil>');
    //
    dInicio := StrToDate(StrZero(Day(dInicio),2,0)+'/'+StrZero(Month(dInicio),2,0)+'/'+StrZero(Year(dInicio)-1,4,0));
    dFinal  := StrToDate(StrZero(Day(dfinal),2,0)+'/'+StrZero(Month(dFinal),2,0)+'/'+StrZero(Year(dFinal)-1,4,0));
    //
    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('select sum(MERCADORIA+SERVICOS-DESCONTO)as TOT from VENDAS, ICM where  EMITIDA=''S'' and EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and ICM.NOME=VENDAS.OPERACAO and ICM.INTEGRACAO<>'''' ');
    Form1.ibQuery2.Open;
    //
    Mais1Ini.WriteString('DADOS','XY'+'01',
                                 'S1<'+StrTran(Format('%15.2n',[ Form1.ibQuery2.FieldByName('TOT').AsFloat]),'.','')+'>'+
                                 'S2<'+StrTran(Format('%15.2n',[ Form1.ibQuery2.FieldByName('TOT').AsFloat]),'.','')+'>'+
                                 'VX<01>LX<Anterior: '+AllTrim(Format('%15.0n',[(Form1.ibQuery2.FieldByName('TOT').AsFloat)/1000]))  +' mil>');


    //
    if Form1.ibQuery1.FieldByName('TOT').AsFloat > Form1.ibQuery2.FieldByName('TOT').AsFloat then
    begin
      Mais1Ini.WriteString('DADOS','SubTitulo','Aumento de '+
      AllTrim(StrTran(StrTran(Format('%15.2n',[(((Form1.ibQuery2.FieldByName('TOT').AsFloat / Form1.ibQuery1.FieldByName('TOT').AsFloat)-1)*100)]),'.',''),'-',''))+'% no período');
    end else
    begin
      Mais1Ini.WriteString('DADOS','SubTitulo','Queda de '+
      AllTrim(StrTran(StrTran(Format('%15.2n',[(((Form1.ibQuery1.FieldByName('TOT').AsFloat / Form1.ibQuery2.FieldByName('TOT').AsFloat)-1)*100*-1)]),'.',''),'-',''))+'% no período');
    end;
    //
    Mais1Ini.Free;
    //
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;



function GraficoRelacaoDespesasMesAnterior(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  Mais1Ini: TIniFile;
  I : Integer;
  dInicio, dFinal : TdateTime;
begin
  try
    //
    dInicio := StrToDate('01/'+StrZero( Month( Date - DiasDesteMes ),2,0)+'/'+StrZero(Year(Date-DiasDesteMes),4,0));
    dFinal  := StrToDate(StrZero(DiasPorMes(Year(Date-DiasDesteMes),Month(Date-DiasDesteMes)),2,0)+Copy(DateTimeToStr(Date-DiasDesteMes),3,8));
    //
    // GRAFICO
    //
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    //                        //
    // cria o vendedores.gra //
    //                      //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    //
    // Titulo
    //
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','Legenda','1');
    Mais1Ini.WriteString('DADOS','TipoS1','4');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    //
    Mais1Ini.WriteString('DADOS','Titulo','Principais despesas mês anterior');
    Mais1Ini.WriteString('DADOS','SubTitulo','');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont));
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    // CAIXA
    //
    Form1.ibQueryGrafico.Close;
    Form1.ibQueryGrafico.SQL.Clear;
    Form1.ibQueryGrafico.SQL.Add('select CAIXA.NOME as NOME, sum((CAIXA.ENTRADA-CAIXA.SAIDA))as vS from CAIXA, CONTAS where CAIXA.NOME=CONTAS.NOME and substring(CONTAS.CONTA||''0'' from 1 for 1)=3 and CAIXA.DATA<='+QuotedStr(DateToStrInvertida(dFinal))+' and CAIXA.DATA>='+QuotedStr(DateToStrInvertida(dInicio))+' group by CAIXA.NOME order by VS');
    Form1.ibQueryGrafico.Open;
    //
    I := 0;
    //
    while not Form1.ibQueryGrafico.Eof do
    begin
      //
      I := I + 1;
      //
      Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),
                                   'S1<'+StrTran(Format('%15.2n',[ Form1.ibQueryGrafico.FieldByName('VS').AsFloat * -1]),'.','')+'>'+
                                   'S2<'+StrTran(Format('%15.2n',[ Form1.ibQueryGrafico.FieldByName('VS').AsFloat * -1]),'.','')+'>'+
                                   'VX<'+StrZero(I,2,0)+'>LX<'+ AllTrim(Copy(Form1.ibQueryGrafico.FieldByname('NOME').AsString+'            ',1,12))+' '+ AllTrim(Format('%12.0n',[ (Form1.ibQueryGrafico.FieldByName('VS').AsFloat * -1) / 1000]))  +' mil >');
      //
      Form1.ibQueryGrafico.Next;
      //
    end;
    //
    Mais1Ini.Free;
    //
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;

function GraficoRelacaoDespesas360(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  Mais1Ini: TIniFile;
  I : Integer;
  dInicio, dFinal : TdateTime;
begin
  try
    //
    dInicio :=  Date - 360;
    dFinal  :=  Date;
    //
    dInicio := StrToDate(DateToStr(dInicio));
    dFinal  := StrToDate(DateToStr(dFinal ));
    //
    // GRAFICO
    //
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    //                        //
    // cria o vendedores.gra //
    //                      //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    //
    // Titulo
    //
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','Legenda','1');
    Mais1Ini.WriteString('DADOS','TipoS1','4');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    //
    Mais1Ini.WriteString('DADOS','Titulo','Principais despesas 360 dias');
    Mais1Ini.WriteString('DADOS','SubTitulo','');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont));
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    // CAIXA
    //
    Form1.ibQueryGrafico.Close;
    Form1.ibQueryGrafico.SQL.Clear;
    Form1.ibQueryGrafico.SQL.Add( 'select CAIXA.NOME as NOME, sum((CAIXA.ENTRADA-CAIXA.SAIDA))as vS from CAIXA, CONTAS where CAIXA.NOME=CONTAS.NOME and substring(CONTAS.CONTA||''0'' from 1 for 1)=3 and CAIXA.DATA<='+QuotedStr(DateToStrInvertida(dFinal))+' and CAIXA.DATA>='+QuotedStr(DateToStrInvertida(dInicio))+' group by CAIXA.NOME order by VS');
    Form1.ibQueryGrafico.Open;
    //
    I := 0;
    //
    while not Form1.ibQueryGrafico.Eof do
    begin
      I := I + 1;
      Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),
                                   'S1<'+StrTran(Format('%15.2n',[ Form1.ibQueryGrafico.FieldByName('VS').AsFloat * -1]),'.','')+'>'+
                                   'S2<'+StrTran(Format('%15.2n',[ Form1.ibQueryGrafico.FieldByName('VS').AsFloat * -1]),'.','')+'>'+
                                   'VX<'+StrZero(I,2,0)+'>LX<'+ AllTrim(Copy(Form1.ibQueryGrafico.FieldByname('NOME').AsString+'            ',1,12))+' '+ AllTrim(Format('%12.0n',[ (Form1.ibQueryGrafico.FieldByName('VS').AsFloat * -1) / 1000]))  +' mil >');

      Form1.ibQueryGrafico.Next;
    end;
    //
    Mais1Ini.Free;
    //
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;

function GraficoRelacaoReceitas360(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  Mais1Ini: TIniFile;
  I : Integer;
  dInicio, dFinal : TdateTime;
begin
  try
    //
    dInicio :=  Date - 360;
    dFinal  :=  Date;
    //
    dInicio := StrToDate(DateToStr(dInicio));
    dFinal  := StrToDate(DateToStr(dFinal ));
    //
    // GRAFICO
    //
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    //                        //
    // cria o vendedores.gra //
    //                      //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    //
    // Titulo
    //
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','Legenda','1');
    Mais1Ini.WriteString('DADOS','TipoS1','4');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    //
    Mais1Ini.WriteString('DADOS','Titulo','Principais receitas 360 dias');
    Mais1Ini.WriteString('DADOS','SubTitulo','');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','CorS1','$00EAB231');
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont));
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    // CAIXA
    //
    Form1.ibQueryGrafico.Close;
    Form1.ibQueryGrafico.SQL.Clear;
    Form1.ibQueryGrafico.SQL.Add( 'select CAIXA.NOME as NOME, sum((CAIXA.ENTRADA-CAIXA.SAIDA))as vS from CAIXA, CONTAS where CAIXA.NOME=CONTAS.NOME and substring(CONTAS.CONTA||''0'' from 1 for 1)=1 and CAIXA.DATA<='+QuotedStr(DateToStrInvertida(dFinal))+' and CAIXA.DATA>='+QuotedStr(DateToStrInvertida(dInicio))+' group by CAIXA.NOME order by VS desc');
    Form1.ibQueryGrafico.Open;
    //
    I := 0;
    //
    while not Form1.ibQueryGrafico.Eof do
    begin
      I := I + 1;
      Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),
                                   'S1<'+StrTran(Format('%15.2n',[ Form1.ibQueryGrafico.FieldByName('VS').AsFloat ]),'.','')+'>'+
                                   'S2<'+StrTran(Format('%15.2n',[ Form1.ibQueryGrafico.FieldByName('VS').AsFloat ]),'.','')+'>'+
                                   'VX<'+StrZero(I,2,0)+'>LX<'+ Copy(Form1.ibQueryGrafico.FieldByname('NOME').AsString+'        ',1,10) + ' '+ AllTrim(Format('%15.0n',[Form1.ibQueryGrafico.FieldByName('VS').AsFloat / 1000]))  +' mil >');

      Form1.ibQueryGrafico.Next;
    end;
    //
    Mais1Ini.Free;
    //
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;




function GraficoCurvaABCEstoque(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  Mais1Ini: TIniFile;
  iA, IB, IC : Integer;
  fTotal4, fTotal5 : Real;
  dInicio, dFinal : TdateTime;
begin
  //
  try
    //
    dInicio :=  Date -90;
    dFinal  :=  Date;
    //
    dInicio := StrToDate(DateToStr(dInicio));
    dFinal  := StrToDate(DateToStr(dFinal ));
    //
    // GRAFICO
    //
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    //                        //
    // cria o vendedores.gra //
    //                      //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    //
    // Titulo
    //
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','Legenda','1');
    Mais1Ini.WriteString('DADOS','TipoS1','4');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    //
    Mais1Ini.WriteString('DADOS','Titulo','Curva ABC do estoque');
    Mais1Ini.WriteString('DADOS','SubTitulo','90 dias');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','CorS1','$00EAB231');
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont));
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    // ITENS001 e ALTERACA
    //
    Form1.ibQueryGrafico.Close;
    Form1.ibQueryGrafico.SQL.Clear;
    Form1.ibQueryGrafico.SQL.Add( 'select CODIGO, SUM(vTOTAL) as TOTAL'+
                                  ' from'+
                                  ' (select ITENS001.CODIGO, sum(ITENS001.TOTAL)as vTOTAL '+
                                  ' from ITENS001, VENDAS'+
                                  ' where VENDAS.EMITIDA=''S'' and VENDAS.EMISSAO between '+QuotedStr(DateToStrInvertida(dInicio))+' and '+QuotedStr(DateToStrInvertida(dFinal))+' and VENDAS.NUMERONF=ITENS001.NUMERONF'+
                                  ' group by CODIGO'+
                                  ' union'+
                                  ' select ALTERACA.CODIGO, sum(ALTERACA.TOTAL)as vTOTAL'+
                                  ' from ALTERACA where (TIPO = ''BALCAO'') and ALTERACA.DATA between '+QuotedStr(DateToStrInvertida(dInicio))+' and '+QuotedStr(DateToStrInvertida(dInicio))+' '+
                                  ' group by CODIGO)'+
                                  ' group by CODIGO order by TOTAL desc');

    Form1.ibQueryGrafico.Open;
    //
    fTotal4 := 0;
    fTotal5 := 0;
    //
    Form1.ibQueryGrafico.First;
    while not Form1.ibQueryGrafico.EOF do
    begin
      if AllTrim(Form1.IBQueryGrafico.FieldByName('CODIGO').AsString) <> '' then
      begin
        fTotal5 := fTotal5 + (Form1.IBQueryGrafico.FieldByName('TOTAL').AsFloat);
      end;
      Form1.ibQueryGrafico.Next;
    end;
    //
    iA := 0;
    iB := 0;
    iC := 0;
    //
    Form1.ibQueryGrafico.First;
    //
    while not Form1.ibQueryGrafico.EOF do
    begin
      //
      if AllTrim(Form1.IBQueryGrafico.FieldByName('CODIGO').AsString) <> '' then
      begin
        //
        //
        fTotal4 := fTotal4 + (Form1.IBQueryGrafico.FieldByName('TOTAL').AsFloat/fTotal5*100);
        //
        if fTotal4 < 70 then
        begin
          iA := iA +1;
        end else
        begin
          if fTotal4 < 90 then
          begin
            iB := iB +1;
          end else
          begin
            iC := iC + 1;
          end;
        end;
      end;
      //
      Form1.ibQueryGrafico.Next;
      //
    end;
    //
    // ShowMessage(IntToStr(iA)+chr(10)+IntToStr(iB)+chr(10)+IntToStr(iC));
    //
    Mais1Ini.WriteString('DADOS','XY01','S1<'+IntToStr(iA)+'>S2<0,00>VX<01>LX<'+IntToStr(iA)+' Produtos A>');
    Mais1Ini.WriteString('DADOS','XY02','S1<'+IntToStr(iB)+'>S2<0,00>VX<02>LX<'+IntToStr(iB)+' Produtos B>');
    Mais1Ini.WriteString('DADOS','XY03','S1<'+IntToStr(iC)+'>S2<0,00>VX<03>LX<'+IntToStr(iC)+' Produtos C>');
    //
    Mais1Ini.Free;
    //
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;


function GraficoCurvaABCClientes(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  Mais1Ini: TIniFile;
  iA, iB, iC : Integer;
  fTotal3, fTotal4 : Real;
  dInicio, dFinal : TdateTime;
begin
  //
  try
   //
    dInicio :=  Date -90;
    dFinal  :=  Date;
    //
    dInicio := StrToDate(DateToStr(dInicio));
    dFinal  := StrToDate(DateToStr(dFinal ));
    //
    // GRAFICO
    //
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    //                        //
    // cria o vendedores.gra //
    //                      //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    //
    // Titulo
    //
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','Legenda','1');
    Mais1Ini.WriteString('DADOS','TipoS1','4');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    //
    Mais1Ini.WriteString('DADOS','Titulo','Curva ABC de clientes');
    Mais1Ini.WriteString('DADOS','SubTitulo','90 dias');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','CorS1','$00EAB231');
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont));
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    fTotal3 := 0;
    fTotal4 := 0;
    //
    // Vendas com NF
    //
    Form1.ibQueryGrafico.Close;
    Form1.ibQueryGrafico.SQL.Clear;
    Form1.ibQueryGrafico.SQL.Add('select VENDAS.CLIENTE, sum(VENDAS.TOTAL)as VTOTAL from VENDAS where EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and EMITIDA=''S'' group by VENDAS.CLIENTE order by VTOTAL desc');
    Form1.ibQueryGrafico.Open;
    //
    Form1.ibQueryGrafico.First;
    while (not Form1.ibQueryGrafico.EOF) do
    begin
      //
      fTotal3 := fTotal3 + Form1.ibQueryGrafico.FieldByname('VTOTAL').asFloat;
      Form1.ibQueryGrafico.Next;
      //
    end;
    //
    iA := 0;
    iB := 0;
    iC := 0;
    //
    Form1.ibQueryGrafico.First;
    while not Form1.ibQueryGrafico.EOF do
    begin
      //
      if Form1.ibQueryGrafico.FieldByName('VTOTAL').AsFloat <> 0 then
      begin
        //
        fTotal4 := fTotal4 + (( Form1.ibQueryGrafico.FieldByName('VTOTAL').AsFloat )/fTotal3*100);
        //
        if fTotal4 < 70 then iA := iA +1 else if fTotal4 < 90 then  iB := iB +1 else iC := iC + 1;
        //
      end;
      //
      Form1.ibQueryGrafico.Next;
      //
    end;
    //
    Form1.ibQueryGrafico.Close;
    //
    Mais1Ini.WriteString('DADOS','XY01','S1<'+IntToStr(iA)+'>S2<0,00>VX<01>LX<'+IntToStr(iA)+' Clientes A>');
    Mais1Ini.WriteString('DADOS','XY02','S1<'+IntToStr(iB)+'>S2<0,00>VX<02>LX<'+IntToStr(iB)+' Clientes B>');
    Mais1Ini.WriteString('DADOS','XY03','S1<'+IntToStr(iC)+'>S2<0,00>VX<03>LX<'+IntToStr(iC)+' Clientes C>');
    //
    Mais1Ini.Free;
    //
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;

function GraficoCurvaABCFornecedores(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  Mais1Ini: TIniFile;
  iA, iB, iC : Integer;
  fTotal3, fTotal4 : Real;
  dInicio, dFinal : TdateTime;
begin
  //
  try
    dInicio :=  Date -90;
    dFinal  :=  Date;
    //
    dInicio := StrToDate(DateToStr(dInicio));
    dFinal  := StrToDate(DateToStr(dFinal ));
    //
    // GRAFICO
    //
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    //                        //
    // cria o vendedores.gra //
    //                      //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    //
    // Titulo
    //
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','Legenda','1');
    Mais1Ini.WriteString('DADOS','TipoS1','4');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    //
    Mais1Ini.WriteString('DADOS','Titulo','Curva ABC de fornecedores');
    Mais1Ini.WriteString('DADOS','SubTitulo','90 dias');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','CorS1','$00EAB231');
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont));
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    fTotal3 := 0;
    fTotal4 := 0;
    //
    // Vendas com NF
    //
    Form1.ibQueryGrafico.Close;
    Form1.ibQueryGrafico.SQL.Clear;
    Form1.ibQueryGrafico.SQL.Add('select COMPRAS.FORNECEDOR, sum(COMPRAS.TOTAL)as VTOTAL from COMPRAS where EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' group by COMPRAS.FORNECEDOR order by VTOTAL desc');
    Form1.ibQueryGrafico.Open;
    //
    Form1.ibQueryGrafico.First;
    while (not Form1.ibQueryGrafico.EOF) do
    begin
      //
      fTotal3 := fTotal3 + Form1.ibQueryGrafico.FieldByname('VTOTAL').asFloat;
      Form1.ibQueryGrafico.Next;
      //
    end;
    //
    iA := 0;
    iB := 0;
    iC := 0;
    //
    Form1.ibQueryGrafico.First;
    while not Form1.ibQueryGrafico.EOF do
    begin
      //
      if Form1.ibQueryGrafico.FieldByName('VTOTAL').AsFloat <> 0 then
      begin
        //
        fTotal4 := fTotal4 + (( Form1.ibQueryGrafico.FieldByName('VTOTAL').AsFloat )/fTotal3*100);
        //
        if fTotal4 < 70 then iA := iA +1 else if fTotal4 < 90 then  iB := iB +1 else iC := iC + 1;
        //
      end;
      //
      Form1.ibQueryGrafico.Next;
      //
    end;
    //
    Form1.ibQueryGrafico.Close;
    //
    Mais1Ini.WriteString('DADOS','XY01','S1<'+IntToStr(iA)+'>S2<0,00>VX<01>LX<'+IntToStr(iA)+' Fornecedores A>');
    Mais1Ini.WriteString('DADOS','XY02','S1<'+IntToStr(iB)+'>S2<0,00>VX<02>LX<'+IntToStr(iB)+' Fornecedores B>');
    Mais1Ini.WriteString('DADOS','XY03','S1<'+IntToStr(iC)+'>S2<0,00>VX<03>LX<'+IntToStr(iC)+' Fornecedores C>');
    //
    Mais1Ini.Free;
    //
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;


function GraficoFaturamentoUltimosAnos(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  Mais1Ini: TIniFile;
  I : Integer;
begin
  //
  // Faturamento
  //
  try
    //
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    //                               //
    // cria o gráfico de receber.png //
    //                               //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','TituloY','');
    Mais1Ini.WriteString('DADOS','TipoS1','0');
    Mais1Ini.WriteString('DADOS','Titulo','Receita anual');
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','TituloX','');
    Mais1Ini.WriteString('DADOS','CorS1','$00F4C84D'); // Azul 60 %
    Mais1Ini.WriteString('DADOS','TituloSerie1','');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont));
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select sum(CAIXA.ENTRADA-CAIXA.SAIDA) as FATURAMENTO, extract(year from CAIXA.DATA) as ANO from CAIXA, CONTAS'
    +' where substring(CONTAS.CONTA||''0'' from 1 for 1)=1 and CAIXA.NOME=CONTAS.NOME group by extract(year from CAIXA.DATA) order by extract(year from CAIXA.DATA)');
    Form1.ibQuery1.Open;
    //
    I := 0;
    //
    while not Form1.ibQuery1.Eof do
    begin
      I := I + 1;
      Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),
                                   'S1<'+StrTran(Format('%15.2n',[ Form1.ibQuery1.FieldByName('FATURAMENTO').AsFloat ]),'.','')+'>'+
                                   'S2<'+StrTran(Format('%15.2n',[ Form1.ibQuery1.FieldByName('FATURAMENTO').AsFloat ]),'.','')+'>'+
                                   'VX<'+StrZero(I,2,0)+'>LX<'+Form1.ibQuery1.FieldByName('ANO').AsString+'>');
      Form1.ibQuery1.Next;
    end;
    //
    Mais1Ini.Free;
    //
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;

function GraficoDespesasUltimosAnos(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  Mais1Ini: TIniFile;
  I : Integer;
begin
  //
  // Faturamento
  //
  try
    //
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    //                               //
    // cria o gráfico de receber.png //
    //                               //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','TituloY','');
    Mais1Ini.WriteString('DADOS','TipoS1','0');
    Mais1Ini.WriteString('DADOS','Titulo','Despesa anual');
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','TituloX','');
    Mais1Ini.WriteString('DADOS','CorS1','$007D7AEA'); // Vermelho 60%
    Mais1Ini.WriteString('DADOS','TituloSerie1','');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont)); //'$00EAB231' // '$00EAB231'
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('select sum(CAIXA.ENTRADA-CAIXA.SAIDA) as despesas, extract(year from CAIXA.DATA) as ANO from CAIXA, CONTAS'
    +' where substring(CONTAS.CONTA||''0'' from 1 for 1)=3 and CAIXA.NOME=CONTAS.NOME group by extract(year from CAIXA.DATA) order by extract(year from CAIXA.DATA)');
    Form1.ibQuery2.Open;
    //
    I := 0;
    //
    while not Form1.ibQuery2.Eof do
    begin
      I := I + 1;
      Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),
                                   'S1<'+StrTran(Format('%15.2n',[ Form1.ibQuery2.FieldByName('despesas').AsFloat * -1]),'.','')+'>'+
                                   'S2<'+StrTran(Format('%15.2n',[ Form1.ibQuery2.FieldByName('despesas').AsFloat * -1]),'.','')+'>'+
                                   'VX<'+StrZero(I,2,0)+'>LX<'+Form1.ibQuery2.FieldByName('ANO').AsString+'>');
      Form1.ibQuery2.Next;
    end;
    //
    Mais1Ini.Free;
    //
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;

function GraficoLucroUltimosAnos(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  Mais1Ini: TIniFile;
  I : Integer;
begin
  //
  // Faturamento
  //
  try
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    //                               //
    // cria o gráfico de receber.png //
    //                               //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','TituloY','');
    Mais1Ini.WriteString('DADOS','TipoS1','0');
    Mais1Ini.WriteString('DADOS','Titulo','Lucro anual');
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','TituloX','');
    Mais1Ini.WriteString('DADOS','CorS1','$008FC26C'); // Verde 60%

    Mais1Ini.WriteString('DADOS','TituloSerie1','');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont)); //'$00EAB231' // '$00EAB231'
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select sum(CAIXA.ENTRADA-CAIXA.SAIDA) as FATURAMENTO, extract(year from CAIXA.DATA) as ANO from CAIXA, CONTAS'
    +' where substring(CONTAS.CONTA||''0'' from 1 for 1)=1 and CAIXA.NOME=CONTAS.NOME group by extract(year from CAIXA.DATA) order by extract(year from CAIXA.DATA)');
    Form1.ibQuery1.Open;
    //
    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('select sum(CAIXA.ENTRADA-CAIXA.SAIDA) as despesas, extract(year from CAIXA.DATA) as ANO from CAIXA, CONTAS'
    +' where substring(CONTAS.CONTA||''0'' from 1 for 1)=3 and CAIXA.NOME=CONTAS.NOME group by extract(year from CAIXA.DATA) order by extract(year from CAIXA.DATA)');
    Form1.ibQuery2.Open;
    //
    Form1.ibQuery1.First;
    Form1.ibQuery2.First;
    //
    I := 0;
    //
    while not Form1.ibQuery1.Eof do
    begin
      //
      I := I + 1;
      //
      if Form1.ibQuery2.FieldByName('ANO').AsString = Form1.ibQuery1.FieldByName('ANO').AsString then
      begin
        Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),
                                     'S1<'+StrTran(Format('%15.2n',[ Form1.ibQuery1.FieldByName('faturamento').AsFloat + Form1.ibQuery2.FieldByName('despesas').AsFloat]),'.','')+'>'+
                                     'S2<'+StrTran(Format('%15.2n',[ Form1.ibQuery1.FieldByName('faturamento').AsFloat + Form1.ibQuery2.FieldByName('despesas').AsFloat]),'.','')+'>'+
                                     'VX<'+StrZero(I,2,0)+'>LX<'+Form1.ibQuery1.FieldByName('ANO').AsString+'>');
      end;
      //
      Form1.ibQuery1.Next;
      Form1.ibQuery2.Next;
    end;
    //
    Mais1Ini.Free;
    //
    GeraGrafico(sNome);
    //
  except
    on E: Exception do  ShowMessage('Erro 4 ao gerar indicadores: '+chr(10)+chr(10)+E.Message);
  end;
  //
  Result := True;
  //
end;

function GraficoLucroMes(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  Mais1Ini: TIniFile;
  I : Integer;
begin
  //
  // Faturamento
  //
  try
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    //                               //
    // cria o gráfico de receber.png //
    //                               //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','TituloY','');
    Mais1Ini.WriteString('DADOS','TipoS1','0');
    Mais1Ini.WriteString('DADOS','Titulo','Lucro '+IntToStr(Year(DATE)));
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','TituloX','');
    Mais1Ini.WriteString('DADOS','CorS1','$008FC26C'); // Verde 60%
    Mais1Ini.WriteString('DADOS','TituloSerie1','');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont)); //'$00EAB231' // '$00EAB231'
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select sum(CAIXA.ENTRADA-CAIXA.SAIDA) as FATURAMENTO, extract(month from CAIXA.DATA) as MES from CAIXA, CONTAS'
    +' where substring(CONTAS.CONTA||''0'' from 1 for 1)=1 and CAIXA.NOME=CONTAS.NOME and extract(year from CAIXA.DATA)='+QuotedStr(IntToStr(Year(DATE)))+' group by extract(month from CAIXA.DATA) order by extract(month from CAIXA.DATA)');
    Form1.ibQuery1.Open;
    //
    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('select sum(CAIXA.ENTRADA-CAIXA.SAIDA) as despesas, extract(month from CAIXA.DATA) as MES from CAIXA, CONTAS'
    +' where substring(CONTAS.CONTA||''0'' from 1 for 1)=3 and CAIXA.NOME=CONTAS.NOME and extract(year from CAIXA.DATA)='+QuotedStr(IntToStr(Year(DATE)))+' group by extract(month from CAIXA.DATA) order by extract(month from CAIXA.DATA)');
    Form1.ibQuery2.Open;
    //
    for I := 1 to 12 do
    begin
      Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),
                                   'S1<          0,00>'+
                                   'S2<          0,00>'+
                                   'VX<'+StrZero(I,2,0)+'>LX<'+ Copy(MesExtenso(I),1,3)+'>');
    end;
    //
    I := 0;
    //
    Form1.ibQuery1.First;
    Form1.ibQuery2.First;
    //
    while not Form1.ibQuery1.Eof do
    begin
      //
      I := I + 1;
      //
      if Form1.ibQuery2.FieldByName('MES').AsString = Form1.ibQuery1.FieldByName('MES').AsString then
      begin
        Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),
                                     'S1<'+StrTran(Format('%15.2n',[ Form1.ibQuery1.FieldByName('faturamento').AsFloat + Form1.ibQuery2.FieldByName('despesas').AsFloat]),'.','')+'>'+
                                     'S2<'+StrTran(Format('%15.2n',[ Form1.ibQuery1.FieldByName('faturamento').AsFloat + Form1.ibQuery2.FieldByName('despesas').AsFloat]),'.','')+'>'+
                                     'VX<'+StrZero(I,2,0)+'>LX<'+ Copy(MesExtenso(StrToInt(Form1.ibQuery1.FieldByName('MES').AsString)),1,3) +'>');
      end;
      //
      Form1.ibQuery1.Next;
      Form1.ibQuery2.Next;
    end;
    //
    Mais1Ini.Free;
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;

function GraficoFaturamentoMes(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  Mais1Ini: TIniFile;
  I : Integer;
begin
  //
  // Faturamento
  //
  try
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    //                               //
    // cria o gráfico de receber.png //
    //                               //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','TituloY','');
    Mais1Ini.WriteString('DADOS','TipoS1','0');
    Mais1Ini.WriteString('DADOS','Titulo','Receita '+IntToStr(Year(DATE)));
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','TituloX','');
    Mais1Ini.WriteString('DADOS','CorS1','$00F4C84D'); // Azul 60 %
    Mais1Ini.WriteString('DADOS','TituloSerie1','');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont));
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select sum(CAIXA.ENTRADA-CAIXA.SAIDA) as FATURAMENTO, extract(month from CAIXA.DATA) as MES from CAIXA, CONTAS'
    +' where substring(CONTAS.CONTA||''0'' from 1 for 1)=1 and CAIXA.NOME=CONTAS.NOME and extract(year from CAIXA.DATA)='+QuotedStr(IntToStr(Year(DATE)))+' group by extract(month from CAIXA.DATA) order by extract(month from CAIXA.DATA)');
    Form1.ibQuery1.Open;
    //
    for I := 1 to 12 do
    begin
      Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),
                                   'S1<0.00>'+
                                   'S2<0.00>'+
                                   'VX<'+StrZero(I,2,0)+'>LX<'+ Copy(MesExtenso(I),1,3) +'>');
    end;
    //
    I := 0;
    //
    while not Form1.ibQuery1.Eof do
    begin
      I := I + 1;
      Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),
                                   'S1<'+StrTran(Format('%15.2n',[ Form1.ibQuery1.FieldByName('FATURAMENTO').AsFloat ]),'.','')+'>'+
                                   'S2<'+StrTran(Format('%15.2n',[ Form1.ibQuery1.FieldByName('FATURAMENTO').AsFloat ]),'.','')+'>'+
                                   'VX<'+StrZero(I,2,0)+'>LX<'+ Copy(MesExtenso(StrToInt(Form1.ibQuery1.FieldByName('MES').AsString)),1,3) +'>');
      Form1.ibQuery1.Next;
    end;
    //
    Mais1Ini.Free;
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;

function GraficoDespesasMes(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  Mais1Ini: TIniFile;
  I : Integer;
begin
  //
  // Faturamento
  //
  try
    //
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    //                               //
    // cria o gráfico de receber.png //
    //                               //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','TituloY','');
    Mais1Ini.WriteString('DADOS','TipoS1','0');
    Mais1Ini.WriteString('DADOS','Titulo','Despesa '+IntToStr(Year(DATE)));
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','TituloX','');
    Mais1Ini.WriteString('DADOS','CorS1','$007D7AEA'); // Vermelho
    Mais1Ini.WriteString('DADOS','TituloSerie1','');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont));
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('select sum(CAIXA.ENTRADA-CAIXA.SAIDA) as despesas, extract(month from CAIXA.DATA) as MES from CAIXA, CONTAS'
    +' where substring(CONTAS.CONTA||''0'' from 1 for 1)=3 and CAIXA.NOME=CONTAS.NOME and extract(year from CAIXA.DATA)='+QuotedStr(IntToStr(Year(DATE)))+' group by extract(month from CAIXA.DATA) order by extract(month from CAIXA.DATA)');
    Form1.ibQuery2.Open;
    //
    for I := 1 to 12 do
    begin
      Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),
                                   'S1<0.00>'+
                                   'S2<0.00>'+
                                   'VX<'+StrZero(I,2,0)+'>LX<'+ Copy(MesExtenso(I),1,3) +'>');
    end;
    //
    I := 0;
    //
    while not Form1.ibQuery2.Eof do
    begin
      I := I + 1;
      Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),
                                   'S1<'+StrTran(Format('%15.2n',[ Form1.ibQuery2.FieldByName('despesas').AsFloat * -1]),'.','')+'>'+
                                   'S2<'+StrTran(Format('%15.2n',[ Form1.ibQuery2.FieldByName('despesas').AsFloat * -1]),'.','')+'>'+
                                   'VX<'+StrZero(I,2,0)+'>LX<'+ Copy(MesExtenso(StrToInt(Form1.ibQuery2.FieldByName('MES').AsString)),1,3) +'>');
      Form1.ibQuery2.Next;
    end;
    //
    Mais1Ini.Free;
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;

function GraficoVendasPorVendedorMesAnterior(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  //
  I : Integer;
  Mais1Ini : tInifile;
  fTotal, fTotal1, fTotal2 : Real;
  dInicio, dFinal : TdateTime;
  //
begin
  //
  try
    //
    dInicio := StrToDate('01/'+StrZero( Month( Date - DiasDesteMes ),2,0)+'/'+StrZero(Year(Date-DiasDesteMes),4,0));
    dFinal  := StrToDate(StrZero(DiasPorMes(Year(Date-DiasDesteMes),Month(Date-DiasDesteMes)),2,0)+Copy(DateTimeToStr(Date-DiasDesteMes),3,8));
    //
    fTotal  := 0;
    //
    // GRAFICO
    //
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    //                        //
    // cria o vendedores.gra //
    //                      //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    //
    // Titulo
    //
    Mais1Ini.WriteString('DADOS','3D','1');
    //
    if Right(sNome,1) = 'G' then
    begin
      Mais1Ini.WriteString('DADOS','FontSizeMarks',IntToStr((5 * Screen.Width div 300)));
    end else
    begin
      Mais1Ini.WriteString('DADOS','FontSizeMarks',IntToStr(5));
    end;
    //
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','Legenda','1');
    Mais1Ini.WriteString('DADOS','TipoS1','4');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    Mais1Ini.WriteString('DADOS','Titulo','Vendas por vendedor mês anterior');
    Mais1Ini.WriteString('DADOS','SubTitulo','');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
//    Mais1Ini.WriteString('DADOS','CorS1','$00EAB231'); //'$00EAB231' // '$00EAB231'
    Mais1Ini.WriteString('DADOS','CorS1','$00EAB231'); //'$00EAB231' // '$00EAB231' $0000D7FF
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont)); //'$00EAB231' // '$00EAB231'
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    Form1.IBDataSetGrafico1.Close;
    Form1.IBDataSetGrafico1.SelectSQL.Clear;
    Form1.IBDataSetGrafico1.SelectSQL.Add('select VENDEDOR, sum(MERCADORIA+SERVICOS-DESCONTO) from VENDAS, ICM where  EMITIDA=''S'' and EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and ICM.NOME=VENDAS.OPERACAO and ICM.INTEGRACAO<>'''' group by VENDEDOR');
    Form1.IBDataSetGrafico1.Open;
    Form1.IBDataSetGrafico1.First;
    //
    Form1.IBDataSetGrafico2.Close;
    Form1.IBDataSetGrafico2.SelectSQL.Clear;
    Form1.IBDataSetGrafico2.SelectSQL.Add('select VENDEDOR, sum(TOTAL) from ALTERACA where DATA<='+QuotedStr(DateToStrInvertida(dFinal))+' and DATA>='+QuotedStr(DateToStrInvertida(dInicio))+' and (TIPO='+QuotedStr('BALCAO')+' or TIPO='+QuotedStr('VENDA')+') group by VENDEDOR');
    Form1.IBDataSetGrafico2.Open;
    Form1.IBDataSetGrafico2.First;
    //
    I := 0;
    //
    Form1.ibDataSetGrafico3.Close;
    Form1.ibDataSetGrafico3.SelectSQL.Clear;
    Form1.ibDataSetGrafico3.SelectSQL.Add('select * FROM VENDEDOR where FUNCAO like '+QuotedStr('%VENDEDOR%')+' order by upper(NOME)');
    Form1.ibDataSetGrafico3.Open;
    Form1.ibDataSetGrafico3.First;
    Form1.ibDataSetGrafico3.DataSource := Nil;
    //
    Form1.ibDataSetGrafico3.First;
    while not Form1.ibDataSetGrafico3.EOF do
    begin
      //
      Form1.IBDataSetGrafico1.Locate('VENDEDOR',Form1.ibDataSetGrafico3.FieldByname('NOME').AsString,[]);
      Form1.IBDataSetGrafico2.Locate('VENDEDOR',Form1.ibDataSetGrafico3.FieldByname('NOME').AsString,[]);
      //
      fTotal1 := 0;
      fTotal2 := 0;
      //
      if AllTrim(Form1.ibDataSetGrafico3.FieldByName('NOME').AsString) = AllTrim(Form1.IBDataSetGrafico1.FieldByName('VENDEDOR').AsString) then fTotal1 := fTotal1 + Form1.IBDataSetGrafico1.FieldByname('SUM').AsFloat;
      if AllTrim(Form1.ibDataSetGrafico3.FieldByName('NOME').AsString) = AllTrim(Form1.IBDataSetGrafico2.FieldByName('VENDEDOR').AsString) then fTotal2 := fTotal2 + Form1.IBDataSetGrafico2.FieldByname('SUM').AsFloat;
      //
      I := I + 1;
      Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),'S1<'+
      StrTran(Format('%15.2n',[fTotal1+fTotal2]),'.','')
        +'>S2<'+'0,00'
        +'>VX<'+StrZero(I,2,0)+'>LX<'+ Copy(Form1.ibDataSetGrafico3.FieldByname('NOME').AsString+'        ',1,10) + ' '+ AllTrim(Format('%15.0n',[(fTotal1+fTotal2)/1000]))  +' mil >');
      //
      fTotal  := fTotal + fTotal1+fTotal2;
      Form1.ibDataSetGrafico3.Next;
      //
    end;
    //
    Mais1Ini.Free;
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;


function GraficoVendasPorVendedor(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  //
  I : Integer;
  Mais1Ini : tInifile;
  fTotal, fTotal1, fTotal2 : Real;
  dInicio, dFinal : TdateTime;
  //
begin
  //
  try
    dInicio := StrToDate('01/'+StrZero(Month(Date),2,0)+'/'+StrZero(Year(Date),4,0));
    dFinal  := StrToDate(StrZero(DiasDesteMes,2,0)+'/'+StrZero(Month(Date),2,0)+'/'+StrZero(Year(Date),4,0));
    //
    fTotal  := 0;
    //
    // GRAFICO
    //
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    //                        //
    // cria o vendedores.gra //
    //                      //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    //
    // Titulo
    //
    Mais1Ini.WriteString('DADOS','3D','1');
    //
    if Right(sNome,1) = 'G' then
    begin
      Mais1Ini.WriteString('DADOS','FontSizeMarks',IntToStr((5 * Screen.Width div 300)));
    end else
    begin
      Mais1Ini.WriteString('DADOS','FontSizeMarks',IntToStr(5));
    end;
    //
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','Legenda','1');
    //
    Mais1Ini.WriteString('DADOS','TipoS1','4');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    //
    Mais1Ini.WriteString('DADOS','Titulo','Vendas por vendedor neste mês');
    Mais1Ini.WriteString('DADOS','SubTitulo','');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
//    Mais1Ini.WriteString('DADOS','CorS1','$00EAB231'); //'$00EAB231' // '$00EAB231'
    Mais1Ini.WriteString('DADOS','CorS1','$00EAB231'); //'$00EAB231' // '$00EAB231' $0000D7FF
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont)); //'$00EAB231' // '$00EAB231'
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    Form1.IBDataSetGrafico1.Close;
    Form1.IBDataSetGrafico1.SelectSQL.Clear;
    Form1.IBDataSetGrafico1.SelectSQL.Add('select VENDEDOR, sum(MERCADORIA+SERVICOS-DESCONTO) from VENDAS, ICM where EMITIDA=''S'' and EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and ICM.NOME=VENDAS.OPERACAO and ICM.INTEGRACAO<>'''' group by VENDEDOR');
    Form1.IBDataSetGrafico1.Open;
    Form1.IBDataSetGrafico1.First;
    //
    Form1.IBDataSetGrafico2.Close;
    Form1.IBDataSetGrafico2.SelectSQL.Clear;
    Form1.IBDataSetGrafico2.SelectSQL.Add('select VENDEDOR, sum(TOTAL) from ALTERACA where DATA<='+QuotedStr(DateToStrInvertida(dFinal))+' and DATA>='+QuotedStr(DateToStrInvertida(dInicio))+' and (TIPO='+QuotedStr('BALCAO')+' or TIPO='+QuotedStr('VENDA')+') group by VENDEDOR');
    Form1.IBDataSetGrafico2.Open;
    Form1.IBDataSetGrafico2.First;
    //
    I := 0;
    //
    Form1.ibDataSetGrafico3.Close;
    Form1.ibDataSetGrafico3.SelectSQL.Clear;
    Form1.ibDataSetGrafico3.SelectSQL.Add('select * FROM VENDEDOR where FUNCAO like '+QuotedStr('%VENDEDOR%')+' order by upper(NOME)');
    Form1.ibDataSetGrafico3.Open;
    Form1.ibDataSetGrafico3.First;
    Form1.ibDataSetGrafico3.DataSource := Nil;
    //
    Form1.ibDataSetGrafico3.First;
    while not Form1.ibDataSetGrafico3.EOF do
    begin
      //
      Form1.IBDataSetGrafico1.Locate('VENDEDOR',Form1.ibDataSetGrafico3.FieldByname('NOME').AsString,[]);
      Form1.IBDataSetGrafico2.Locate('VENDEDOR',Form1.ibDataSetGrafico3.FieldByname('NOME').AsString,[]);
      //
      fTotal1 := 0;
      fTotal2 := 0;
      //
      if AllTrim(Form1.ibDataSetGrafico3.FieldByName('NOME').AsString) = AllTrim(Form1.IBDataSetGrafico1.FieldByName('VENDEDOR').AsString) then fTotal1 := fTotal1 + Form1.IBDataSetGrafico1.FieldByname('SUM').AsFloat;
      if AllTrim(Form1.ibDataSetGrafico3.FieldByName('NOME').AsString) = AllTrim(Form1.IBDataSetGrafico2.FieldByName('VENDEDOR').AsString) then fTotal2 := fTotal2 + Form1.IBDataSetGrafico2.FieldByname('SUM').AsFloat;
      //
      I := I + 1;
      Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),'S1<'+
      StrTran(Format('%15.2n',[fTotal1+fTotal2]),'.','')
        +'>S2<'+'0,00'
        +'>VX<'+StrZero(I,2,0)+'>LX<'+ Copy(Form1.ibDataSetGrafico3.FieldByname('NOME').AsString+'        ',1,10) + ' '+ AllTrim(Format('%15.0n',[(fTotal1+fTotal2)/1000]))  +' mil >');
      //
      fTotal  := fTotal + fTotal1+fTotal2;
      Form1.ibDataSetGrafico3.Next;
      //
    end;
    //
    Mais1Ini.Free;
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;

function GraficoInadimplencia90dias(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  I : Integer;
  Mais1Ini : tInifile;
begin
  //
  // Gráfico Inadimplencia 90 dias
  //
  try
    //
    Form1.ibQueryGrafico.Close;
    Form1.ibQueryGrafico.SQL.Clear;
    Form1.ibQueryGrafico.SQL.Add('select cast(sum(VALOR_DUPL)as numeric(18,2))as VALOR, cast(sum(VALOR_RECE)as numeric(18,2))as RECE  from RECEBER where (VENCIMENTO>=(CURRENT_DATE-90)) and VENCIMENTO<CURRENT_DATE and coalesce(ATIVO,9)<>1');
    Form1.ibQueryGrafico.Open;
    //                                          //
    // Gráfico de fluxo de caixa inadimplencia //
    //                                        //
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','TipoS1','4');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    Mais1Ini.WriteString('DADOS','Titulo','Inadimplência 90 dias: '+AllTrim(Format('%12.2n',[(100-(Form1.ibQueryGrafico.FieldByname('RECE').AsFloat/Form1.ibQueryGrafico.FieldByname('VALOR').AsFloat)*100)]))+'%');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont));
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    // Acumula os valores
    //
    I := 1;

        Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),'S1<'+
        StrTran(Format('%15.2n',[(100-(Form1.ibQueryGrafico.FieldByname('RECE').AsFloat/Form1.ibQueryGrafico.FieldByname('VALOR').AsFloat)*100)]),'.','')
          +'>S2<'+'0,00'
                          +'>VX<'+StrZero(I,2,0)+'>LX<Inadimplência>');

    I := 2;

        Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),'S1<'+
        StrTran(Format('%15.2n',[100-(100-(Form1.ibQueryGrafico.FieldByname('RECE').AsFloat/Form1.ibQueryGrafico.FieldByname('VALOR').AsFloat)*100)]),'.','')
          +'>S2<'+'0,00'
                          +'>VX<'+StrZero(I,2,0)+'>LX<Adimplência>');


    Form1.ibQueryGrafico.Close;
    //
    Mais1Ini.Free;
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;


function GraficoInadimplencia360dias(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  I : Integer;
  Mais1Ini : tInifile;
begin
  //
  // Gráfico Inadimplencia 90 dias
  //
  try
    //
    Form1.ibQueryGrafico.Close;
    Form1.ibQueryGrafico.SQL.Clear;
    Form1.ibQueryGrafico.SQL.Add('select cast(sum(VALOR_DUPL)as numeric(18,2))as VALOR, cast(sum(VALOR_RECE)as numeric(18,2))as RECE  from RECEBER where (VENCIMENTO>=(CURRENT_DATE-360)) and VENCIMENTO<CURRENT_DATE and coalesce(ATIVO,9)<>1');
    Form1.ibQueryGrafico.Open;
    //                                          //
    // Gráfico de fluxo de caixa inadimplencia //
    //                                        //
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','TipoS1','4');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    Mais1Ini.WriteString('DADOS','Titulo','Inadimplência 360 dias: '+AllTrim(Format('%12.2n',[(100-(Form1.ibQueryGrafico.FieldByname('RECE').AsFloat/Form1.ibQueryGrafico.FieldByname('VALOR').AsFloat)*100)]))+'%');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont)); //'$00EAB231' // '$00EAB231'
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    // Acumula os valores
    //
    I := 1;

        Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),'S1<'+
        StrTran(Format('%15.2n',[(100-(Form1.ibQueryGrafico.FieldByname('RECE').AsFloat/Form1.ibQueryGrafico.FieldByname('VALOR').AsFloat)*100)]),'.','')
          +'>S2<'+'0,00'
                          +'>VX<'+StrZero(I,2,0)+'>LX<Inadimplência>');

    I := 2;

        Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),'S1<'+
        StrTran(Format('%15.2n',[100-(100-(Form1.ibQueryGrafico.FieldByname('RECE').AsFloat/Form1.ibQueryGrafico.FieldByname('VALOR').AsFloat)*100)]),'.','')
          +'>S2<'+'0,00'
                          +'>VX<'+StrZero(I,2,0)+'>LX<Adimplência>');


    Mais1Ini.Free;
    Form1.ibQueryGrafico.Close;
    //
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;

function GraficoInadimplenciaTotalDias(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  I : Integer;
  Mais1Ini : tInifile;
begin
  //
  // Gráfico Inadimplencia 90 dias
  //
  try
    //
    Form1.ibQueryGrafico.Close;
    Form1.ibQueryGrafico.SQL.Clear;
    Form1.ibQueryGrafico.SQL.Add('select cast(sum(VALOR_DUPL)as numeric(18,2))as VALOR, cast(sum(VALOR_RECE)as numeric(18,2))as RECE  from RECEBER where VENCIMENTO<CURRENT_DATE and coalesce(ATIVO,9)<>1');
    Form1.ibQueryGrafico.Open;
    //                                          //
    // Gráfico de fluxo de caixa inadimplencia //
    //                                        //
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.gra'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.gra');
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','TipoS1','4');
    Mais1Ini.WriteString('DADOS','AlturaBmp',intToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',intToStr(iX));
    Mais1Ini.WriteString('DADOS','Titulo','Inadimplência total: '+AllTrim(Format('%12.2n',[(100-(Form1.ibQueryGrafico.FieldByname('RECE').AsFloat/Form1.ibQueryGrafico.FieldByname('VALOR').AsFloat)*100)]))+'%');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont)); //'$00EAB231' // '$00EAB231'
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    // Acumula os valores
    //
    I := 1;

        Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),'S1<'+
        StrTran(Format('%15.2n',[(100-(Form1.ibQueryGrafico.FieldByname('RECE').AsFloat/Form1.ibQueryGrafico.FieldByname('VALOR').AsFloat)*100)]),'.','')
          +'>S2<'+'0,00'
                          +'>VX<'+StrZero(I,2,0)+'>LX<Inadimplência>');

    I := 2;

        Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),'S1<'+
        StrTran(Format('%15.2n',[100-(100-(Form1.ibQueryGrafico.FieldByname('RECE').AsFloat/Form1.ibQueryGrafico.FieldByname('VALOR').AsFloat)*100)]),'.','')
          +'>S2<'+'0,00'
                          +'>VX<'+StrZero(I,2,0)+'>LX<Adimplência>');


    Mais1Ini.Free;
    Form1.ibQueryGrafico.Close;
    //
    GeraGrafico(sNome);
    //
  except end;
  //
  Result := True;
  //
end;


function GraficoFluxoDeCaixa(sNome: String; iY: integer; iX: Integer; iFont: Integer; iFontYX: Integer): boolean;
var
  III : Integer;
  Mais1Ini : tInifile;
  dContador, dInicio, dFinal : TdateTime;
  fNConsiliadosTOTAL, fNConsiliados, fReceber, fPagar, fTotal, fTotal1, fTotal2, fTotal3 : Real;
begin
  //
  try
    //
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.png'));
    DeleteFile(pChar(Form1.sAtual+'\'+sNome+'.GRA'));
    //
    dInicio :=  Date;
    dFinal  :=  Date + 60;
    //
    dInicio := StrToDate(DateToStr(dInicio));
    dFinal  := StrToDate(DateToStr(dFinal ));
    //
    fTotal  := 0;                          // Zeresima
    fTotal1 := 0;                          // Zeresima
    fTotal2 := 0;                          // Zeresima
    fTotal3 := 0;                          // Zeresima
    //
    // Saldo do Caixa
    //
    Form1.ibQueryGrafico.Close;
    Form1.ibQueryGrafico.SQL.Clear;
    Form1.ibQueryGrafico.SQL.Add('select sum(ENTRADA)as ENTRADA, sum(SAIDA)as SAIDA from CAIXA');
    Form1.ibQueryGrafico.Open;
    fTotal := fTotal + Form1.IBQueryGrafico.FieldByname('ENTRADA').AsFloat - Form1.IBQueryGrafico.FieldByname('SAIDA').AsFloat;          // Soma ao total
    //
    Form1.ibQueryGrafico.Close;
    Form1.ibQueryGrafico.SQL.Clear;
    Form1.ibQueryGrafico.SQL.Add('select sum(SALDO3)as SALDO from BANCOS');
    Form1.ibQueryGrafico.Open;
    fTotal := fTotal + Form1.IBQueryGrafico.FieldByname('SALDO').AsFloat;          // Soma ao total
    //
    try
      Form7.ibDataSet25.DisableControls;
      Form7.ibDataSet25.Close;
      Form7.ibDataSet25.SelectSql.Clear;
      Form7.ibDataSet25.SelectSQL.Add('delete from FLUXO');
      Form7.ibDataSet25.Open;
    except
      Abort;
    end;
    //
    Form7.ibDataSet25.Close;
    Form7.ibDataSet25.SelectSql.Clear;
    Form7.ibDataSet25.SelectSQL.Add('select * from FLUXO order by DATA');
    Form7.ibDataSet25.Open;
    //
    // cria o gráfico de fluxo de caixa fluxo.png //
    //                                            //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+sNome+'.GRA');
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','Titulo','Fluxo de caixa 60 dias');
    Mais1Ini.WriteString('DADOS','NomeBmp',sNome+'.png');
    Mais1Ini.WriteString('DADOS','TituloY','');
    Mais1Ini.WriteString('DADOS','TipoS1','0');
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','TituloX','');
    Mais1Ini.WriteString('DADOS','AlturaBmp',IntToStr(iY));
    Mais1Ini.WriteString('DADOS','LarguraBmp',IntToStr(iX));
    Mais1Ini.WriteString('DADOS','CorS1','$008FC26C'); // Verde 60%
    Mais1Ini.WriteString('DADOS','FontSize',IntToStr(iFont));
    Mais1Ini.WriteString('DADOS','FontSizeLabel',IntToStr(iFontYX));
    //
    fNConsiliadosTOTAL := 0;
    III := 0;
    // Acumula os valores
    dContador := DInicio;
    while dContador <= dFinal do
    begin
      //
      Application.ProcessMessages;
      //
      // Receber
      //
      Form1.ibQueryGrafico.Close;
      Form1.ibQueryGrafico.SQL.Clear;
      Form1.ibQueryGrafico.SQL.Add('select sum(VALOR_DUPL)as REC from RECEBER where Coalesce(VALOR_RECE,0)=0 and coalesce(HISTORICO,''XXX'')<>''NFE NAO AUTORIZADA'' and VENCIMENTO='+QuotedStr(DateToStrInvertida(dContador))+' and coalesce(ATIVO,9)<>1');
      Form1.ibQueryGrafico.Open;
      //
      fReceber := Form1.IBQueryGrafico.FieldByname('REC').AsFloat;          // Soma ao total
      //
      // Pagar
      //
      Form1.ibQueryGrafico.Close;
      Form1.ibQueryGrafico.SQL.Clear;
      Form1.ibQueryGrafico.SQL.Add('select sum(VALOR_DUPL)as PAG from PAGAR where VALOR_PAGO=0 and VENCIMENTO='+QuotedStr(DateToStrInvertida(dContador)));
      Form1.ibQueryGrafico.Open;
      //
      fPagar := Form1.IBQueryGrafico.FieldByname('PAG').AsFloat;          // Soma ao total
      //
      // Não Consiliados
      //
      Form1.ibQueryGrafico.Close;
      Form1.ibQueryGrafico.SQL.Clear;
      Form1.ibQueryGrafico.SQL.Add('select sum(ENTRADA_)as ENTRADA, sum(SAIDA_)as SAIDA from MOVIMENT where (coalesce(COMPENS,'+QuotedStr('1899/12/30')+')='+QuotedStr('1899/12/30')+') and PREDATA='+QuotedStr(DateToStrInvertida(dContador)));
      Form1.ibQueryGrafico.Open;
      //
      fNConsiliados := (Form1.IBQueryGrafico.FieldByname('ENTRADA').AsFloat - Form1.IBQueryGrafico.FieldByname('SAIDA').AsFloat); // Soma o valor da dupl
      //
      // Soma ou desconta os não consiliados
      //
      if fNConsiliados > 0 then fReceber := fReceber + fNConsiliados else fPagar := fPagar + (fNConsiliados * -1);
      fNConsiliadosTOTAL := fNConsiliadosTOTAL + fNConsiliados;
      //
      fTotal := fTotal + fReceber - fPagar;           // Saldo
      //
      Form7.ibDataSet25.Append;                                  // Registro novo no fluxo.dbf
      Form7.ibDataSet25DATA.AsDateTime    := dContador;          // Grava a data no arquivo fluxo.dbf
      Form7.ibDataSet25RECEBER.AsFloat    := fReceber;           // Grava o valor a RECEBER no arquivo fluxo.dbf
      Form7.ibDataSet25PAGAR.AsFloat      := fPagar;             // Grava o valor a PAGAR no arquivo fluxo.dbf
      Form7.ibDataSet25ACUMULADO3.AsFloat := fTotal;             // Grava o valor do Saldo
      Form7.ibDataSet25DIFERENCA_.AsFloat := fReceber - fPagar;  // Grava o valor da diferença
      Form7.ibDataSet25.Post;
      //
      if Form7.ibDataSet25ACUMULADO3.AsFloat <> 0 then
      begin
        III := III + 1;
        Mais1Ini.WriteString('DADOS',
        'XY'+StrZero(III,2,0),'S1<'+StrTran(Format('%15.2n',[Form7.ibDataSet25ACUMULADO3.AsFloat]),'.','')                          +'>S2<'+'0,00'
                          +'>VX<'+StrZero(III,2,0)+'>LX<'+Copy(DateTimeToStr(Form7.ibDataSet25DATA.AsDateTime),1,5)+'>');
      end;
      //
      dContador := SomaDias(dContador, 1);                // Incrementa o contador
      fTotal1   := fTotal1 + Form7.ibDataSet25RECEBER.AsFloat;
      fTotal2   := fTotal2 + Form7.ibDataSet25PAGAR.AsFloat;
      fTotal3   := fTotal3 + Form7.ibDataSet25DIFERENCA_.AsFloat;
      //
    end;
    //
    Mais1Ini.Free;
    GeraGrafico(sNome);

    //
  except end;
  //
  Result := True;
  //
end;

procedure TForm5.FormShow(Sender: TObject);
begin
  //
  if Form5.Caption <> '' then
  begin
    try
      if not Form1.IBTransaction2.Active then Form1.IBTransaction2.Active := True;
      Form1.IBTransaction2.Commit;
    except end;
  end;
  //
  try
    //
    if Form5.Caption = 'VENDAS POR VENDEDOR' then
    begin
      GraficoVendasPorVendedor('VendasPorVendedorG',400,800,(8 * 800 div 300),(5 * 800 div 300));
      GraficoVendasPorVendedorMesAnterior('VendasPorVendedorMesAnteriorG',400,800,(8 * 800 div 300),(5 * 800 div 300));
    end;
    //
    if Form5.Caption = 'FLUXO DE CAIXA' then
    begin
      GraficoFluxoDeCaixa('FluxoDeCaixaG',400,800,(8 * 800 div 300),(5 * 800 div 300));
    end;
    //
    if Form5.Caption = 'INADIMPLÊNCIA' then
    begin
      GraficoInadimplencia90dias('Inadimplencia90DiasG',400,800,(8 * 800 div 300),(5 * 800 div 300));
      GraficoInadimplencia360Dias('Inadimplencia360DiasG',400,800,(8 * 800 div 300),(5 * 800 div 300));
      GraficoInadimplenciaTotalDias('InadimplenciaTotalDiasG',400,800,(8 * 800 div 300),(5 * 800 div 300));
    end;
    //
    if Form5.Caption = 'LUCRO' then
    begin
      GraficoFaturamentoMes('FaturamentoMesG',400,800,(8 * 800 div 300),(5 * 800 div 300));
      GraficoDespesasMes('DespesasMesG',400,800,(8 * 800 div 300),(5 * 800 div 300));
      GraficoLucroMes('LucroMesG',400,800,(8 * 800 div 300),(5 * 800 div 300));
      GraficoFaturamentoUltimosAnos('FaturamentoUltimosAnosG',400,800,(8 * 800 div 300),(5 * 800 div 300));
      GraficoDespesasUltimosAnos('DespesasUltimosAnosG',400,800,(8 * 800 div 300),(5 * 800 div 300));
      GraficoLucroUltimosAnos('LucroUltimosAnosG',400,800,(8 * 800 div 300),(5 * 800 div 300));
    end;
    //
    if Form5.Caption = 'INDICADORES' then
    begin
      try
        //
        GraficoVendasParciais('VendasParciaisG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoVendasMes('VendasMesG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoVendasAno('VendasAnoG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoVendas('VendasG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoRelacaoDespesasMesAnterior('RelacaoDespesasMesAnteriorG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoVendasPorVendedor('VendasPorVendedorG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoVendasPorVendedorMesAnterior('VendasPorVendedorMesAnteriorG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoRelacaoReceitas360('RelacaoReceitas360G',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoRelacaoDespesas360('RelacaoDespesas360G',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoCurvaABCFornecedores('CurvaABCFornecedoresG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoRegistrosNoCadastro('RegistrosNoCadastroG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoCurvaABCEstoque('CurvaABCEstoqueG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoCurvaABCClientes('CurvaABCClientesG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoLucroUltimosAnos('LucroUltimosAnosG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoDespesasUltimosAnos('DespesasUltimosAnosG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoFaturamentoUltimosAnos('FaturamentoUltimosAnosG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoInadimplenciaTotalDias('InadimplenciaTotalDiasG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoInadimplencia360Dias('Inadimplencia360DiasG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoVendasPorVendedor('VendasPorVendedorP',150,300,8,5);
        GraficoLucroMes('LucroMesG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoDespesasMes('DespesasMesG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoFaturamentoMes('FaturamentoMesG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoFluxoDeCaixa('FluxoDeCaixaG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        GraficoInadimplencia90dias('Inadimplencia90DiasG',400,800,(8 * 800 div 300),(5 * 800 div 300));
        //
      except end;
    end;
    //
    if Form5.Caption = '' then
    begin
      //
      try
        if Form5.Panel24.Visible then CarregaGrafico(Form5.Image24,'VendasParciaisP',False);
        if Form5.Panel23.Visible then CarregaGrafico(Form5.Image23,'VendasAnoP',False);
        if Form5.Panel22.Visible then CarregaGrafico(Form5.Image22,'VendasMesP',False);
        if Form5.Panel21.Visible then CarregaGrafico(Form5.Image21,'VendasP',False);
        if Form5.Panel20.Visible then CarregaGrafico(Form5.Image20,'RelacaoDespesasMesAnteriorP',False);
        if Form5.Panel19.Visible then CarregaGrafico(Form5.Image19,'VendasPorVendedorMesAnteriorP',False);
        if Form5.Panel18.Visible then CarregaGrafico(Form5.Image18,'RelacaoReceitas360P',False);
        if Form5.Panel17.Visible then CarregaGrafico(Form5.Image17,'RelacaoDespesas360P',False);
        if Form5.Panel16.Visible then CarregaGrafico(Form5.Image16,'CurvaABCFornecedoresP',False);
        if Form5.Panel15.Visible then CarregaGrafico(Form5.Image15,'RegistrosNoCadastroP',False);
        if Form5.Panel14.Visible then CarregaGrafico(Form5.Image14,'CurvaABCEstoqueP',False);
        if Form5.Panel13.Visible then CarregaGrafico(Form5.Image13,'CurvaABCClientesP',False);
        if Form5.Panel12.Visible then CarregaGrafico(Form5.Image12,'LucroUltimosAnosP',False);
        if Form5.Panel11.Visible then CarregaGrafico(Form5.Image11,'DespesasUltimosAnosP',False);
        if Form5.Panel10.Visible then CarregaGrafico(Form5.Image10,'FaturamentoUltimosAnosP',False);
        if Form5.Panel9.Visible  then CarregaGrafico(Form5.Image9,'InadimplenciaTotalDiasP',False);
        if Form5.Panel8.Visible  then CarregaGrafico(Form5.Image8,'Inadimplencia360DiasP',False);
        if Form5.Panel7.Visible  then CarregaGrafico(Form5.Image7,'VendasPorVendedorP',False);
        if Form5.Panel6.Visible  then CarregaGrafico(Form5.Image6,'LucroMesP',False);
        if Form5.Panel5.Visible  then CarregaGrafico(Form5.Image5,'DespesasMesP',False);
        if Form5.Panel4.Visible  then CarregaGrafico(Form5.Image4,'FaturamentoMesP',False);
        if Form5.Panel3.Visible  then CarregaGrafico(Form5.Image3,'FluxoDeCaixaP',False);
        if Form5.Panel2.Visible  then CarregaGrafico(Form5.Image2,'Inadimplencia90DiasP',False);
        if Form5.Panel1.Visible  then GraficoCalendario('CalendarioP',150,300,8,6);
      except end;
      //
    end;
  except end;
  //
  PosicionatodosOsIndicadores(Form5.Panel13);
  //
end;

procedure TForm5.Image16MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Form1.Enabled then Screen.Cursor := crHandPoint;
end;

procedure TForm5.ScrollBox1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if Form1.Enabled then Screen.Cursor := crDefault;
end;


procedure TForm5.Image16MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  try
    iXPublic := X;
    iYPublic := Y;
    iTabOrder := tPanel(tImage(Sender).Parent).TabOrder;
    TImage(Sender).BeginDrag(False); // inicia a operacao
  except end;
end;

procedure TForm5.Image16EndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  //
  try
    if tPanel(tImage(Sender).Parent).TabOrder <> iTabOrder then
    begin
      tPanel(tImage(Sender).Parent).TabOrder := iTabOrder;
      PosicionatodosOsIndicadores(tPanel(tImage(Sender).Parent));
      iXPublic := 0;
      iYPublic := 0;
    end else
    begin
      ExpandeOGrafico(Sender);
    end;
  except end;
  //
end;

procedure TForm5.Image16DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  try
    if Sender <> Source then
    begin
      iTabOrder := tPanel(tImage(Sender).Parent).TabOrder; // tPanel(Sender).TabOrder;
      tPanel(tImage(Source).Parent).Top  := tPanel(tImage(Sender).Parent).Top + Y - iYPublic;
      tPanel(tImage(Source).Parent).Left := tPanel(tImage(Sender).Parent).Left + X - IXPublic;
      tPanel(tImage(Source).Parent).BringToFront;
    end;
  except end;
end;

procedure TForm5.Image1Expande(Sender: TObject);
begin
  //
  try
    //
    if Form5.Panel1.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image1.Width  := Form5.Width;
      Form5.Image1.Height := Form5.Height;
      Form5.Panel1.Width  := Form5.Width;
      Form5.Panel1.Height := Form5.Height;
      //
      Form5.Panel1.Top    := 0;
      Form5.Panel1.Left   := 0;
      Form5.Panel1.BringToFront;
      Form5.Panel1.Repaint;
      //
      GraficoCalendario('CalendarioG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      //
    end else
    begin
      //
      GraficoCalendario('CalendarioP',150,300,8,6);
      //
      Form5.Image1.Width  := 300;
      Form5.Image1.Height := 150;
      Form5.Panel1.Width  := 301;
      Form5.Panel1.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel1);
      //
    end;
  except end;
  //
end;


procedure TForm5.Image2Expande(Sender: TObject);
begin
  //
  try
    if Form5.Panel2.Width =301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image2.Width  := Form5.Width;
      Form5.Image2.Height := Form5.Height;
      Form5.Panel2.Width  := Form5.Width;
      Form5.Panel2.Height := Form5.Height;
      Form5.Panel2.Top    := 0;
      Form5.Panel2.Left   := 0;
      Form5.Panel2.BringToFront;
      Form5.Panel2.Repaint;
      //
      GraficoInadimplencia90dias('Inadimplencia90DiasG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.Image2,'Inadimplencia90DiasG',True);
      //
    end else
    begin
      //
      GraficoInadimplencia90dias('Inadimplencia90DiasP',150,300,8,6);
      CarregaGrafico(Form5.Image2,'Inadimplencia90DiasP',True);
      //
      Form5.Image2.Width  := 300;
      Form5.Image2.Height := 150;
      Form5.Panel2.Width  := 301;
      Form5.Panel2.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel2);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image7Expande(Sender: TObject);
begin
  //
  try
    if Form5.Panel7.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image7.Width  := Form5.Width;
      Form5.Image7.Height := Form5.Height;
      Form5.Panel7.Width  := Form5.Width;
      Form5.Panel7.Height := Form5.Height;
      Form5.Panel7.Top    := 0;
      Form5.Panel7.Left   := 0;
      Form5.Panel7.BringToFront;
      Form5.Panel7.Repaint;
      //
      GraficoVendasPorVendedor('VendasPorVendedorG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(5 * Screen.Width div 300));
      CarregaGrafico(Form5.Image7,'VendasPorVendedorG',True);
      //
    end else
    begin
      //
      GraficoVendasPorVendedor('VendasPorVendedorP',150,300,8,5);
      CarregaGrafico(Form5.Image7,'VendasPorVendedorP',True);
      //
      Form5.Image7.Width  := 300;
      Form5.Image7.Height := 150;
      Form5.Panel7.Width  := 301;
      Form5.Panel7.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel7);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image3Expande(Sender: TObject);
begin
  //
  try
    if Form5.panel3.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image3.Width  := Form5.Width;
      Form5.Image3.Height := Form5.Height;
      Form5.panel3.Width  := Form5.Width;
      Form5.panel3.Height := Form5.Height;
      Form5.panel3.Top    := 0;
      Form5.panel3.Left   := 0;
      Form5.panel3.BringToFront;
      Form5.Panel3.Repaint;
      //
      GraficoFluxoDeCaixa('FluxoDecaixaG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.Image3,'FluxoDeCaixaG',True);
      //
    end else
    begin
      //
      Graficofluxodecaixa('FluxoDeCaixaP',150,300,8,6);
      CarregaGrafico(Form5.Image3,'FluxoDeCaixaP',True);
      //
      Form5.Image3.Width  := 300;
      Form5.Image3.Height := 150;
      Form5.panel3.Width  := 301;
      Form5.panel3.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel3);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image4Expande(Sender: TObject);
begin
  //
  try
    if Panel4.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image4.Width  := Form5.Width;
      Form5.Image4.Height := Form5.Height;
      Form5.Panel4.Width  := Form5.Width;
      Form5.Panel4.Height := Form5.Height;
      Form5.Panel4.Top    := 0;
      Form5.Panel4.Left   := 0;
      Form5.Panel4.BringToFront;
      Form5.Panel4.Repaint;
      //
      GraficoFaturamentoMes('FaturamentoMesG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.Image4,'FaturamentoMesG',True);
      //
    end else
    begin
      //
      GraficoFaturamentoMes('faturamentomesP',150,300,8,6);
      CarregaGrafico(Form5.Image4,'FaturamentoMesP',True);
      //
      Form5.Image4.Width  := 300;
      Form5.Image4.Height := 150;
      Form5.Panel4.Width  := 301;
      Form5.Panel4.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel4);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image8Expande(Sender: TObject);
begin
  //
  try
    if Form5.panel8.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.image8.Width  := Form5.Width;
      Form5.image8.Height := Form5.Height;
      Form5.panel8.Width  := Form5.Width;
      Form5.panel8.Height := Form5.Height;
      Form5.panel8.Top    := 0;
      Form5.panel8.Left   := 0;
      Form5.panel8.BringToFront;
      Form5.Panel8.Repaint;
      //
      Graficoinadimplencia360dias('Inadimplencia360DiasG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.image8,'Inadimplencia360DiasG',True);
      //
    end else
    begin
      //
      Graficoinadimplencia360dias('Inadimplencia360DiasP',150,300,8,6);
      CarregaGrafico(Form5.image8,'Inadimplencia360DiasP',True);
      //
      Form5.image8.Width  := 300;
      Form5.image8.Height := 150;
      Form5.panel8.Width  := 301;
      Form5.panel8.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel8);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image5Expande(Sender: TObject);
begin
  //
  try
    if Panel5.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image5.Width  := Form5.Width;
      Form5.Image5.Height := Form5.Height;
      Form5.Panel5.Width  := Form5.Width;
      Form5.Panel5.Height := Form5.Height;
      Form5.Panel5.Top    := 0;
      Form5.Panel5.Left   := 0;
      Form5.Panel5.BringToFront;
      Form5.Panel5.Repaint;
      //
      GraficoDespesasMes('DespesasMesG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.Image5,'DespesasMesG',True);
      //
    end else
    begin
      //
      GraficoDespesasMes('DespesasMesP',150,300,8,6);
      CarregaGrafico(Form5.Image5,'DespesasMesP',True);
      //
      Form5.Image5.Width  := 300;
      Form5.Image5.Height := 150;
      Form5.Panel5.Width  := 301;
      Form5.Panel5.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel5);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image6Expande(Sender: TObject);
begin
  //
  try
    if Panel6.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image6.Width  := Form5.Width;
      Form5.Image6.Height := Form5.Height;
      Form5.Panel6.Width  := Form5.Width;
      Form5.Panel6.Height := Form5.Height;
      Form5.Panel6.Top    := 0;
      Form5.Panel6.Left   := 0;
      Form5.Panel6.BringToFront;
      Form5.Panel6.Repaint;
      //
      GraficolucroMes('LucroMesG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.Image6,'LucroMesG',True);
      //
    end else
    begin
      //
      try
        GraficolucroMes('lucromesP',150,300,8,6);
        CarregaGrafico(Form5.Image6,'LucroMesP',True);
      except end;
      //
      Form5.Image6.Width  := 300;
      Form5.Image6.Height := 150;
      Form5.panel6.Width  := 301;
      Form5.panel6.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel6);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image9Expande(Sender: TObject);
begin
  //
  try
    if Form5.panel9.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.image9.Width  := Form5.Width;
      Form5.image9.Height := Form5.Height;
      Form5.panel9.Width  := Form5.Width;
      Form5.panel9.Height := Form5.Height;
      Form5.panel9.Top    := 0;
      Form5.panel9.Left   := 0;
      Form5.panel9.BringToFront;
      Form5.Panel9.Repaint;
      //
      GraficoinadimplenciaTotalDias('inadimplenciaTotalDiasG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.image9,'InadimplenciaTotalDiasG',True);
      //
    end else
    begin
      //
      GraficoinadimplenciaTotalDias('InadimplenciaTotalDiasP',150,300,8,6);
      CarregaGrafico(Form5.image9,'InadimplenciaTotalDiasP',True);
      //
      Form5.image9.Width  := 300;
      Form5.image9.Height := 150;
      Form5.panel9.Width  := 301;
      Form5.panel9.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.panel9);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image10Expande(Sender: TObject);
begin
  //
  try
    if Panel10.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image10.Width  := Form5.Width;
      Form5.Image10.Height := Form5.Height;
      Form5.Panel10.Width  := Form5.Width;
      Form5.Panel10.Height := Form5.Height;
      Form5.Panel10.Top    := 0;
      Form5.Panel10.Left   := 0;
      Form5.Panel10.BringToFront;
      Form5.Panel10.Repaint;
      //
      GraficoFaturamentoUltimosAnos('FaturamentoUltimosAnosG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.Image10,'FaturamentoUltimosAnosG',True);
      //
    end else
    begin
      //
      GraficoFaturamentoUltimosAnos('FaturamentoUltimosAnosP',150,300,8,6);
      CarregaGrafico(Form5.Image10,'FaturamentoUltimosAnosP',True);
      //
      Form5.Image10.Width  := 300;
      Form5.Image10.Height := 150;
      Form5.Panel10.Width  := 301;
      Form5.Panel10.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel5);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image11Expande(Sender: TObject);
begin
  //
  try
    if Panel11.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image11.Width  := Form5.Width;
      Form5.Image11.Height := Form5.Height;
      Form5.Panel11.Width  := Form5.Width;
      Form5.Panel11.Height := Form5.Height;
      Form5.Panel11.Top    := 0;
      Form5.Panel11.Left   := 0;
      Form5.Panel11.BringToFront;
      Form5.Panel11.Repaint;
      //
      GraficoDespesasUltimosAnos('DespesasUltimosAnosG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.Image11,'DespesasUltimosAnosG',True);
      //
    end else
    begin
      //
      GraficoDespesasUltimosAnos('DespesasUltimosAnosP',150,300,8,6);
      CarregaGrafico(Form5.Image11,'DespesasUltimosAnosP',True);
      //
      Form5.Image11.Width  := 300;
      Form5.Image11.Height := 150;
      Form5.Panel11.Width  := 301;
      Form5.Panel11.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel11);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image12Expande(Sender: TObject);
begin
  //
  try
    if Panel12.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image12.Width  := Form5.Width;
      Form5.Image12.Height := Form5.Height;
      Form5.Panel12.Width  := Form5.Width;
      Form5.Panel12.Height := Form5.Height;
      Form5.Panel12.Top    := 0;
      Form5.Panel12.Left   := 0;
      Form5.Panel12.BringToFront;
      Form5.Panel12.Repaint;
      //
      GraficoLucroUltimosAnos('LucroUltimosAnosG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.Image12,'LucroUltimosAnosG',True);
      //
    end else
    begin
      //
      GraficoLucroUltimosAnos('LucroUltimosAnosP',150,300,8,6);
      CarregaGrafico(Form5.Image12,'LucroUltimosAnosP',True);
      //
      Form5.Image12.Width  := 300;
      Form5.Image12.Height := 150;
      Form5.Panel12.Width  := 301;
      Form5.Panel12.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel12);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image13Expande(Sender: TObject);
begin
  //
  try
    if Form5.Panel13.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image13.Width  := Form5.Width;
      Form5.Image13.Height := Form5.Height;
      Form5.Panel13.Width  := Form5.Width;
      Form5.Panel13.Height := Form5.Height;
      Form5.Panel13.Top    := 0;
      Form5.Panel13.Left   := 0;
      Form5.Panel13.BringToFront;
      Form5.Panel13.Repaint;
      //
      GraficoCurvaABCClientes('CurvaABCClientesG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.Image13,'CurvaABCClientesG',True);
      //
    end else
    begin
      //
      GraficoCurvaABCClientes('CurvaABCClientesP',150,300,8,6);
      CarregaGrafico(Form5.Image13,'CurvaABCClientesP',True);
      //
      Form5.Image13.Width  := 300;
      Form5.Image13.Height := 150;
      Form5.Panel13.Width  := 301;
      Form5.Panel13.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel13);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image14Expande(Sender: TObject);
begin
  //
  try
    if Form5.Panel14.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image14.Width  := Form5.Width;
      Form5.Image14.Height := Form5.Height;
      Form5.Panel14.Width  := Form5.Width;
      Form5.Panel14.Height := Form5.Height;
      Form5.Panel14.Top    := 0;
      Form5.Panel14.Left   := 0;
      Form5.Panel14.BringToFront;
      Form5.Panel14.Repaint;
      //
      GraficoCurvaABCEstoque('CurvaABCEstoqueG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.Image14,'CurvaABCEstoqueG',True);
      //
    end else
    begin
      //
      GraficoCurvaABCEstoque('CurvaABCEstoqueP',150,300,8,6);
      CarregaGrafico(Form5.Image14,'CurvaABCEstoqueP',True);
      //
      Form5.Image14.Width  := 300;
      Form5.Image14.Height := 150;
      Form5.Panel14.Width  := 301;
      Form5.Panel14.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel14);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image15Expande(Sender: TObject);
begin
  //
  try
    if Form5.Panel15.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image15.Width  := Form5.Width;
      Form5.Image15.Height := Form5.Height;
      Form5.Panel15.Width  := Form5.Width;
      Form5.Panel15.Height := Form5.Height;
      Form5.Panel15.Top    := 0;
      Form5.Panel15.Left   := 0;
      Form5.Panel15.BringToFront;
      Form5.Panel15.Repaint;
      //
      GraficoRegistrosNoCadastro('RegistrosNoCadastroG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.Image15,'RegistrosNoCadastroG',True);
      //
    end else
    begin
      //
      GraficoRegistrosNoCadastro('RegistrosNoCadastroP',150,300,8,6);
      CarregaGrafico(Form5.Image15,'RegistrosNoCadastroP',True);
      //
      Form5.Image15.Width  := 300;
      Form5.Image15.Height := 150;
      Form5.Panel15.Width  := 301;
      Form5.Panel15.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel15);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image16Expande(Sender: TObject);
begin
  //
  try
    if Form5.Panel16.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image16.Width  := Form5.Width;
      Form5.Image16.Height := Form5.Height;
      Form5.Panel16.Width  := Form5.Width;
      Form5.Panel16.Height := Form5.Height;
      Form5.Panel16.Top    := 0;
      Form5.Panel16.Left   := 0;
      Form5.Panel16.BringToFront;
      Form5.Panel16.Repaint;
      //
      GraficoCurvaABCFornecedores('CurvaABCFornecedoresG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.Image16,'CurvaABCFornecedoresG',True);
      //
    end else
    begin
      //
      GraficoCurvaABCFornecedores('CurvaABCFornecedoresP',150,300,8,6);
      CarregaGrafico(Form5.Image16,'CurvaABCFornecedoresP',True);
      //
      Form5.Image16.Width  := 300;
      Form5.Image16.Height := 150;
      Form5.Panel16.Width  := 301;
      Form5.Panel16.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel16);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image17Expande(Sender: TObject);
begin
  //
  try
    if Form5.Panel17.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image17.Width  := Form5.Width;
      Form5.Image17.Height := Form5.Height;
      Form5.Panel17.Width  := Form5.Width;
      Form5.Panel17.Height := Form5.Height;
      Form5.Panel17.Top    := 0;
      Form5.Panel17.Left   := 0;
      Form5.Panel17.BringToFront;
      Form5.Panel17.Repaint;
      //
      GraficoRelacaoDespesas360('RelacaoDespesas360G',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.Image17,'RelacaoDespesas360G',True);
      //
    end else
    begin
      //
      GraficoRelacaoDespesas360('RelacaoDespesas360P',150,300,8,6);
      CarregaGrafico(Form5.Image17,'RelacaoDespesas360P',True);
      //
      Form5.Image17.Width  := 300;
      Form5.Image17.Height := 150;
      Form5.Panel17.Width  := 301;
      Form5.Panel17.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel17);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image18Expande(Sender: TObject);
begin
  //
  try
    if Form5.Panel18.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image18.Width  := Form5.Width;
      Form5.Image18.Height := Form5.Height;
      Form5.Panel18.Width  := Form5.Width;
      Form5.Panel18.Height := Form5.Height;
      Form5.Panel18.Top    := 0;
      Form5.Panel18.Left   := 0;
      Form5.Panel18.BringToFront;
      Form5.Panel18.Repaint;
      //
      GraficoRelacaoReceitas360('RelacaoReceitas360G',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.Image18,'RelacaoReceitas360G',True);
      //
    end else
    begin
      //
      GraficoRelacaoReceitas360('RelacaoReceitas360P',150,300,8,6);
      CarregaGrafico(Form5.Image18,'RelacaoReceitas360P',True);
      //
      Form5.Image18.Width  := 300;
      Form5.Image18.Height := 150;
      Form5.Panel18.Width  := 301;
      Form5.Panel18.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel18);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image19Expande(Sender: TObject);
begin
  //
  try
    if Form5.Panel19.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image19.Width  := Form5.Width;
      Form5.Image19.Height := Form5.Height;
      Form5.Panel19.Width  := Form5.Width;
      Form5.Panel19.Height := Form5.Height;
      Form5.Panel19.Top    := 0;
      Form5.Panel19.Left   := 0;
      Form5.Panel19.BringToFront;
      Form5.Panel19.Repaint;
      //
      GraficoVendasPorVendedorMesAnterior('VendasPorVendedorMesAnteriorG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(5 * Screen.Width div 300));
      CarregaGrafico(Form5.Image19,'VendasPorVendedorMesAnteriorG',True);
      //
    end else
    begin
      //
      GraficoVendasPorVendedorMesAnterior('VendasPorVendedorMesAnteriorP',150,300,8,5);
      CarregaGrafico(Form5.Image19,'VendasPorVendedorMesAnteriorP',True);
      //
      Form5.Image19.Width  := 300;
      Form5.Image19.Height := 150;
      Form5.Panel19.Width  := 301;
      Form5.Panel19.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel19);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image20Expande(Sender: TObject);
begin
  //
  try
    if Form5.Panel20.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image20.Width  := Form5.Width;
      Form5.Image20.Height := Form5.Height;
      Form5.Panel20.Width  := Form5.Width;
      Form5.Panel20.Height := Form5.Height;
      Form5.Panel20.Top    := 0;
      Form5.Panel20.Left   := 0;
      Form5.Panel20.BringToFront;
      Form5.Panel20.Repaint;
      //
      GraficoRelacaoDespesasMesAnterior('RelacaoDespesasMesAnteriorG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.Image20,'RelacaoDespesasMesAnteriorG',True);
      //
    end else
    begin
      //
      GraficoRelacaoDespesasMesAnterior('RelacaoDespesasMesAnteriorP',150,300,8,6);
      CarregaGrafico(Form5.Image20,'RelacaoDespesasMesAnteriorP',True);
      //
      Form5.Image20.Width  := 300;
      Form5.Image20.Height := 150;
      Form5.Panel20.Width  := 301;
      Form5.Panel20.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel20);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image21Expande(Sender: TObject);
begin
  //
  try
    if Form5.Panel21.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image21.Width  := Form5.Width;
      Form5.Image21.Height := Form5.Height;
      Form5.Panel21.Width  := Form5.Width;
      Form5.Panel21.Height := Form5.Height;
      Form5.Panel21.Top    := 0;
      Form5.Panel21.Left   := 0;
      Form5.Panel21.BringToFront;
      Form5.Panel21.Repaint;
      //
      GraficoVendas('VendasG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.Image21,'VendasG',True);
      //
    end else
    begin
      //
      GraficoVendas('VendasP',150,300,8,6);
      CarregaGrafico(Form5.Image21,'VendasP',True);
      //
      Form5.Image21.Width  := 300;
      Form5.Image21.Height := 150;
      Form5.Panel21.Width  := 301;
      Form5.Panel21.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel21);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image22Expande(Sender: TObject);
begin
  //
  try
    if Form5.Panel22.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image22.Width  := Form5.Width;
      Form5.Image22.Height := Form5.Height;
      Form5.Panel22.Width  := Form5.Width;
      Form5.Panel22.Height := Form5.Height;
      Form5.Panel22.Top    := 0;
      Form5.Panel22.Left   := 0;
      Form5.Panel22.BringToFront;
      Form5.Panel22.Repaint;
      //
      GraficoVendasMes('VendasMesG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.Image22,'VendasMesG',True);
      //
    end else
    begin
      //
      GraficoVendasMes('VendasMesP',150,300,8,6);
      CarregaGrafico(Form5.Image22,'VendasMesP',True);
      //
      Form5.Image22.Width  := 300;
      Form5.Image22.Height := 150;
      Form5.Panel22.Width  := 301;
      Form5.Panel22.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel22);
      //
    end;
  except end;
  //
end;

procedure TForm5.Image24Expande(Sender: TObject);
begin
  //
  try
    if Form5.Panel24.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image24.Width  := Form5.Width;
      Form5.Image24.Height := Form5.Height;
      Form5.Panel24.Width  := Form5.Width;
      Form5.Panel24.Height := Form5.Height;
      Form5.Panel24.Top    := 0;
      Form5.Panel24.Left   := 0;
      Form5.Panel24.BringToFront;
      Form5.Panel24.Repaint;
      //
      GraficoVendasParciais('VendasParciaisG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.Image24,'VendasParciaisG',True);
      //
    end else
    begin
      //
      GraficoVendasParciais('VendasParciaisP',150,300,8,6);
      CarregaGrafico(Form5.Image24,'VendasParciaisP',True);
      //
      Form5.Image24.Width  := 300;
      Form5.Image24.Height := 150;
      Form5.Panel24.Width  := 301;
      Form5.Panel24.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel24);
      //
    end;
  except end;
  //
end;


procedure TForm5.Image23Expande(Sender: TObject);
begin
  //
  try
    if Form5.Panel23.Width = 301 then
    begin
      //
      Form5.Top    := 0;
      Form5.Left   := 0;
      Form5.Width := Screen.Width;
      Form5.Height := Screen.Height;
      Form5.ScrollBox1.VertScrollBar.Visible := False;
      //
      Form5.Image23.Width  := Form5.Width;
      Form5.Image23.Height := Form5.Height;
      Form5.Panel23.Width  := Form5.Width;
      Form5.Panel23.Height := Form5.Height;
      Form5.Panel23.Top    := 0;
      Form5.Panel23.Left   := 0;
      Form5.Panel23.BringToFront;
      Form5.Panel23.Repaint;
      //
      GraficoVendasAno('VendasAnoG',Form5.Height,Form5.Width,(8 * Screen.Width div 300),(6 * Screen.Width div 300));
      CarregaGrafico(Form5.Image23,'VendasAnoG',True);
      //
    end else
    begin
      //
      GraficoVendasAno('VendasAnoP',150,300,8,6);
      CarregaGrafico(Form5.Image23,'VendasAnoP',True);
      //
      Form5.Image23.Width  := 300;
      Form5.Image23.Height := 150;
      Form5.Panel23.Width  := 301;
      Form5.Panel23.Height := 151;
      Form5.ScrollBox1.VertScrollBar.Visible := True;
      Form5.ScrollBox1.VertScrollBar.Position := 0;
      //
      PosicionatodosOsIndicadores(Form5.Panel23);
      //
    end;
  except end;
  //
end;



procedure TForm5.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Mais1Ini: TIniFile;
begin
  //
  Form7.sModulo := '';
  //
  try
    //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I01ORDEM',IntToStr(Form5.Panel1.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I02ORDEM',IntToStr(Form5.Panel2.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I03ORDEM',IntToStr(Form5.Panel3.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I04ORDEM',IntToStr(Form5.Panel4.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I05ORDEM',IntToStr(Form5.Panel5.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I06ORDEM',IntToStr(Form5.Panel6.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I07ORDEM',IntToStr(Form5.Panel7.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I08ORDEM',IntToStr(Form5.Panel8.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I09ORDEM',IntToStr(Form5.Panel9.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I10ORDEM',IntToStr(Form5.Panel10.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I11ORDEM',IntToStr(Form5.Panel11.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I12ORDEM',IntToStr(Form5.Panel12.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I13ORDEM',IntToStr(Form5.Panel13.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I14ORDEM',IntToStr(Form5.Panel14.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I15ORDEM',IntToStr(Form5.Panel15.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I16ORDEM',IntToStr(Form5.Panel16.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I17ORDEM',IntToStr(Form5.Panel17.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I18ORDEM',IntToStr(Form5.Panel18.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I19ORDEM',IntToStr(Form5.Panel19.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I20ORDEM',IntToStr(Form5.Panel20.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I21ORDEM',IntToStr(Form5.Panel21.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I22ORDEM',IntToStr(Form5.Panel22.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I23ORDEM',IntToStr(Form5.Panel23.TabOrder));
    Mais1Ini.WriteString(Senhas.UsuarioPub,'I24ORDEM',IntToStr(Form5.Panel24.TabOrder));
    Mais1Ini.Free;
    //
  except end;
  //
  Form1.AvisoIndicadores(True);
  //
end;

procedure TForm5.ScrollBox1DblClick(Sender: TObject);
var
  Hora, Min, Seg, cent : Word;
  tInicio : tTime;
  bGeraGraficoFluxo, bGeraGraficoVendas, bGeraGraficoInadimplencia, bGeraGraficoCaixa, bGeraGraficoSempre : boolean;
begin
  //
  tInicio := Time;
  //
  bGeraGraficoVendas        := False;
  bGeraGraficoInadimplencia := False;
  bGeraGraficoCaixa         := False;
  bGeraGraficoFluxo         := False;
  bGeraGraficoSempre        := False;
  //
  try
    //
    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('select gen_id(G_GRAFICO_RECEBER,0) from rdb$database');
    Form1.ibQuery2.Open;
    //
    if Form1.ibQuery2.FieldByname('GEN_ID').AsString <> '1' then
    begin
      //
      Form1.ibQuery2.Close;
      Form1.ibQuery2.SQL.Clear;
      Form1.ibQuery2.SQL.Add('set generator G_GRAFICO_RECEBER to 1');
      Form1.ibQuery2.ExecSQL;
      //
      bGeraGraficoInadimplencia := True;
      bGeraGraficoFluxo         := True;
      //
    end else bGeraGraficoInadimplencia := False;
    //
  except end;
  //
  try
    //
    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('select gen_id(G_GRAFICO_VENDAS,0) from rdb$database');
    Form1.ibQuery2.Open;
    //
    if Form1.ibQuery2.FieldByname('GEN_ID').AsString <> '1' then
    begin
      //
      Form1.ibQuery2.Close;
      Form1.ibQuery2.SQL.Clear;
      Form1.ibQuery2.SQL.Add('set generator G_GRAFICO_VENDAS to 1');
      Form1.ibQuery2.ExecSQL;
      //
      bGeraGraficoVendas := True;
      //
    end else bGeraGraficoVendas := False;
    //
  except end;
  //
  try
    //
    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('select gen_id(G_GRAFICO_CAIXA,0) from rdb$database');
    Form1.ibQuery2.Open;
    //
    if Form1.ibQuery2.FieldByname('GEN_ID').AsString <> '1' then
    begin
      //
      Form1.ibQuery2.Close;
      Form1.ibQuery2.SQL.Clear;
      Form1.ibQuery2.SQL.Add('set generator G_GRAFICO_CAIXA to 1');
      Form1.ibQuery2.ExecSQL;
      //
      bGeraGraficoCAIXA := True;
      bGeraGraficoFluxo := True;
      //
    end else bGeraGraficoCAIXA := False;
    //
  except end;
  //
  try
    //
    if Form5.Panel24.Visible then if bGeraGraficoVendas        or  (not FileExists(pchar(Form1.sAtual+'\VendasPArciaisP_Ok.png')))               then GraficoVendasParciais('VendasParciaisP',150,300,8,6);
    //
    if Form5.Panel23.Visible then if bGeraGraficoVendas        or  (not FileExists(pchar(Form1.sAtual+'\VendasAnoP_Ok.png')))                    then GraficoVendasAno('VendasAnoP',150,300,8,6);
    if Form5.Panel22.Visible then if bGeraGraficoVendas        or  (not FileExists(pchar(Form1.sAtual+'\VendasMesP_Ok.png')))                    then GraficoVendasMes('VendasMesP',150,300,8,6);
    //
    if Form5.Panel21.Visible then if bGeraGraficoVendas        or  (not FileExists(pchar(Form1.sAtual+'\VendasP_Ok.png')))                       then GraficoVendas('VendasP',150,300,8,6);
    if Form5.Panel20.Visible then if bGeraGraficoCaixa         or  (not FileExists(pchar(Form1.sAtual+'\RelacaoDespesasMesAnteriorP_Ok.png')))   then GraficoRelacaoDespesasMesAnterior('RelacaoDespesasMesAnteriorP',150,300,8,6);
    if Form5.Panel19.Visible then if bGeraGraficoVendas        or  (not FileExists(pchar(Form1.sAtual+'\VendasPorVendedorMesAnteriorP_Ok.png'))) then GraficoVendasPorVendedorMesAnterior('VendasPorVendedorMesAnteriorP',150,300,8,5);
    if Form5.Panel18.Visible then if bGeraGraficoCaixa         or  (not FileExists(pchar(Form1.sAtual+'\RelacaoReceitas360P_Ok.png')))           then GraficoRelacaoReceitas360('RelacaoReceitas360P',150,300,8,6);
    if Form5.Panel17.Visible then if bGeraGraficoCaixa         or  (not FileExists(pchar(Form1.sAtual+'\RelacaoDespesas360P_Ok.png')))           then GraficoRelacaoDespesas360('RelacaoDespesas360P',150,300,8,6);
    //
    if Form5.Panel16.Visible then if  bGeraGraficoSempre       or  (not FileExists(pchar(Form1.sAtual+'\CurvaABCFornecedoresP_Ok.png')))         then GraficoCurvaABCFornecedores('CurvaABCFornecedoresP',150,300,8,6);
    if Form5.Panel15.Visible then if  bGeraGraficoSempre       or  (not FileExists(pchar(Form1.sAtual+'\RegistrosNoCadastroP_Ok.png')))          then GraficoRegistrosNoCadastro('RegistrosNoCadastroP',150,300,8,6);
    if Form5.Panel14.Visible then if  bGeraGraficoSempre       or  (not FileExists(pchar(Form1.sAtual+'\CurvaABCEstoqueP_Ok.png')))              then GraficoCurvaABCEstoque('CurvaABCEstoqueP',150,300,8,6);
    if Form5.Panel13.Visible then if  bGeraGraficoSempre       or  (not FileExists(pchar(Form1.sAtual+'\CurvaABCClientesP_Ok.png')))             then GraficoCurvaABCClientes('CurvaABCClientesP',150,300,8,6);
    //
    if Form5.Panel12.Visible then if bGeraGraficoCaixa          or  (not FileExists(pchar(Form1.sAtual+'\LucroUltimosAnosP_Ok.png')))             then GraficoLucroUltimosAnos('LucroUltimosAnosP',150,300,8,6);
    if Form5.Panel11.Visible then if bGeraGraficoCaixa          or  (not FileExists(pchar(Form1.sAtual+'\DespesasUltimosAnosP_Ok.png')))          then GraficoDespesasUltimosAnos('DespesasUltimosAnosP',150,300,8,6);
    if Form5.Panel10.Visible then if bGeraGraficoCaixa          or  (not FileExists(pchar(Form1.sAtual+'\FaturamentoUltimosAnosP_Ok.png')))       then GraficoFaturamentoUltimosAnos('FaturamentoUltimosAnosP',150,300,8,6);
    //
    if Form5.Panel9.Visible  then if bGeraGraficoInadimplencia  or  (not FileExists(pchar(Form1.sAtual+'\InadimplenciaTotalDiasP_Ok.png')))       then GraficoInadimplenciaTotalDias('InadimplenciaTotalDiasP',150,300,8,6);
    if Form5.Panel8.Visible  then if bGeraGraficoInadimplencia  or  (not FileExists(pchar(Form1.sAtual+'\Inadimplencia360DiasP_Ok.png')))         then GraficoInadimplencia360Dias('Inadimplencia360DiasP',150,300,8,6);
    if Form5.Panel7.Visible  then if bGeraGraficoVendas         or  (not FileExists(pchar(Form1.sAtual+'\VendasPorVendedorP_Ok.png')))            then GraficoVendasPorVendedor('VendasPorVendedorP',150,300,8,5);
    if Form5.Panel6.Visible  then if bGeraGraficoCaixa          or  (not FileExists(pchar(Form1.sAtual+'\LucroMesP_Ok.png')))                     then GraficoLucroMes('LucroMesP',150,300,8,6);
    if Form5.Panel5.Visible  then if bGeraGraficoCaixa          or  (not FileExists(pchar(Form1.sAtual+'\DespesasMesP_Ok.png')))                  then GraficoDespesasMes('DespesasMesP',150,300,8,6);
    if Form5.Panel4.Visible  then if bGeraGraficoCaixa          or  (not FileExists(pchar(Form1.sAtual+'\FaturamentoMesP_Ok.png')))               then GraficoFaturamentoMes('FaturamentoMesP',150,300,8,6);
    if Form5.Panel3.Visible  then if bGeraGraficoFluxo          or  (not FileExists(pchar(Form1.sAtual+'\FluxoDeCaixaP_Ok.png')))                 then GraficoFluxoDeCaixa('FluxoDeCaixaP',150,300,8,6);
    if Form5.Panel2.Visible  then if bGeraGraficoInadimplencia  or  (not FileExists(pchar(Form1.sAtual+'\Inadimplencia90DiasP_Ok.png')))          then GraficoInadimplencia90dias('Inadimplencia90DiasP',150,300,8,6);
    //
    if Form5.Panel1.Visible  then GraficoCalendario('CalendarioP',150,300,8,6);
    //
  except end;
  //
  try
    if Form5.Panel24.Visible then CarregaGrafico(Form5.Image24,'VendasParciaisP',bGeraGraficoVendas);
    if Form5.Panel23.Visible then CarregaGrafico(Form5.Image23,'VendasAnoP',bGeraGraficoVendas);
    if Form5.Panel22.Visible then CarregaGrafico(Form5.Image22,'VendasMesP',bGeraGraficoVendas);
    if Form5.Panel21.Visible then CarregaGrafico(Form5.Image21,'VendasP',bGeraGraficoVendas);
    if Form5.Panel20.Visible then CarregaGrafico(Form5.Image20,'RelacaoDespesasMesAnteriorP',bGeraGraficoCaixa);
    if Form5.Panel19.Visible then CarregaGrafico(Form5.Image19,'VendasPorVendedorMesAnteriorP',bGeraGraficoVendas);
    if Form5.Panel18.Visible then CarregaGrafico(Form5.Image18,'RelacaoReceitas360P',bGeraGraficoCaixa);
    if Form5.Panel17.Visible then CarregaGrafico(Form5.Image17,'RelacaoDespesas360P',bGeraGraficoCaixa);
    if Form5.Panel16.Visible then CarregaGrafico(Form5.Image16,'CurvaABCFornecedoresP',bGeraGraficoSempre);
    if Form5.Panel15.Visible then CarregaGrafico(Form5.Image15,'RegistrosNoCadastroP',bGeraGraficoSempre);
    if Form5.Panel14.Visible then CarregaGrafico(Form5.Image14,'CurvaABCEstoqueP',bGeraGraficoSempre);
    if Form5.Panel13.Visible then CarregaGrafico(Form5.Image13,'CurvaABCClientesP',bGeraGraficoSempre);
    if Form5.Panel12.Visible then CarregaGrafico(Form5.Image12,'LucroUltimosAnosP',bGeraGraficoCaixa);
    if Form5.Panel11.Visible then CarregaGrafico(Form5.Image11,'DespesasUltimosAnosP',bGeraGraficoCaixa);
    if Form5.Panel10.Visible then CarregaGrafico(Form5.Image10,'FaturamentoUltimosAnosP',bGeraGraficoCaixa);
    if Form5.Panel9.Visible  then CarregaGrafico(Form5.Image9,'InadimplenciaTotalDiasP',bGeraGraficoInadimplencia);
    if Form5.Panel8.Visible  then CarregaGrafico(Form5.Image8,'Inadimplencia360DiasP',bGeraGraficoInadimplencia);
    if Form5.Panel7.Visible  then CarregaGrafico(Form5.Image7,'VendasPorVendedorP',bGeraGraficoVendas);
    if Form5.Panel6.Visible  then CarregaGrafico(Form5.Image6,'LucroMesP',bGeraGraficoCaixa);
    if Form5.Panel5.Visible  then CarregaGrafico(Form5.Image5,'DespesasMesP',bGeraGraficoCaixa);
    if Form5.Panel4.Visible  then CarregaGrafico(Form5.Image4,'FaturamentoMesP',bGeraGraficoCaixa);
    if Form5.Panel3.Visible  then CarregaGrafico(Form5.Image3,'FluxoDeCaixaP',bGeraGraficoCaixa);
    if Form5.Panel2.Visible  then CarregaGrafico(Form5.Image2,'Inadimplencia90DiasP',bGeraGraficoInadimplencia);
    if Form5.Panel1.Visible  then GraficoCalendario('CalendarioP',150,300,8,6);
//    DecodeTime((Time - tInicio), Hora, Min, Seg, cent); sMensagem := sMensagem + '99: '+TimeToStr(Time - tInicio)+' ´ '+StrZero(cent,3,0)+chr(10); tInicio := Time;
    //
  except end;
  //
  DecodeTime((Time - tInicio), Hora, Min, Seg, cent);
//  Form5.ScrollBox1.Hint := 'Tempo: '+TimeToStr(Time - tInicio)+' ´ '+StrZero(cent,3,0)+chr(10)+ chr(10);
  Form5.BringToFront;
  //
end;

procedure TForm5.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if Form1.Enabled then Screen.Cursor := crHandPoint;
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
  Form5.fMutado := 0;
end;

procedure TForm5.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    //
    //
    Form5.Image1.Width   := 301;
    Form5.Image2.Width   := 301;
    Form5.Image3.Width   := 301;
    Form5.Image4.Width   := 301;
    Form5.Image5.Width   := 301;
    Form5.Image6.Width   := 301;
    Form5.Image7.Width   := 301;
    Form5.Image8.Width   := 301;
    Form5.Image9.Width   := 301;
    Form5.Image10.Width  := 301;
    Form5.Image11.Width  := 301;
    Form5.Image12.Width  := 301;
    Form5.Image13.Width  := 301;
    Form5.Image14.Width  := 301;
    Form5.Image15.Width  := 301;
    Form5.Image16.Width  := 301;
    Form5.Image17.Width  := 301;
    Form5.Image18.Width  := 301;
    Form5.Image19.Width  := 301;
    Form5.Image20.Width  := 301;
    Form5.Image21.Width  := 301;
    Form5.Image22.Width  := 301;
    Form5.Image23.Width  := 301;
    Form5.Image24.Width  := 301;
    //
    Form5.Image1.Height    := 151;
    Form5.Image2.Height    := 151;
    Form5.Image3.Height    := 151;
    Form5.Image4.Height    := 151;
    Form5.Image5.Height    := 151;
    Form5.Image6.Height    := 151;
    Form5.Image7.Height    := 151;
    Form5.Image8.Height    := 151;
    Form5.Image9.Height    := 151;
    Form5.Image10.Height   := 151;
    Form5.Image11.Height   := 151;
    Form5.Image12.Height   := 151;
    Form5.Image13.Height   := 151;
    Form5.Image14.Height   := 151;
    Form5.Image15.Height   := 151;
    Form5.Image16.Height   := 151;
    Form5.Image17.Height   := 151;
    Form5.Image18.Height   := 151;
    Form5.Image19.Height   := 151;
    Form5.Image20.Height   := 151;
    Form5.Image21.Height   := 151;
    Form5.Image22.Height   := 151;
    Form5.Image23.Height   := 151;
    Form5.Image24.Height   := 151;
    //
    Form5.Panel1.Width   := 301;
    Form5.Panel2.Width   := 301;
    Form5.Panel3.Width   := 301;
    Form5.Panel4.Width   := 301;
    Form5.Panel5.Width   := 301;
    Form5.Panel6.Width   := 301;
    Form5.Panel7.Width   := 301;
    Form5.Panel8.Width   := 301;
    Form5.Panel9.Width   := 301;
    Form5.Panel10.Width  := 301;
    Form5.Panel11.Width  := 301;
    Form5.Panel12.Width  := 301;
    Form5.Panel13.Width  := 301;
    Form5.Panel14.Width  := 301;
    Form5.Panel15.Width  := 301;
    Form5.Panel16.Width  := 301;
    Form5.Panel17.Width  := 301;
    Form5.Panel18.Width  := 301;
    Form5.Panel19.Width  := 301;
    Form5.Panel20.Width  := 301;
    Form5.Panel21.Width  := 301;
    Form5.Panel22.Width  := 301;
    Form5.Panel23.Width  := 301;
    Form5.Panel24.Width  := 301;
    //
    Form5.Panel1.Height    := 151;
    Form5.Panel2.Height    := 151;
    Form5.Panel3.Height    := 151;
    Form5.Panel4.Height    := 151;
    Form5.Panel5.Height    := 151;
    Form5.Panel6.Height    := 151;
    Form5.Panel7.Height    := 151;
    Form5.Panel8.Height    := 151;
    Form5.Panel9.Height    := 151;
    Form5.Panel10.Height   := 151;
    Form5.Panel11.Height   := 151;
    Form5.Panel12.Height   := 151;
    Form5.Panel13.Height   := 151;
    Form5.Panel14.Height   := 151;
    Form5.Panel15.Height   := 151;
    Form5.Panel16.Height   := 151;
    Form5.Panel17.Height   := 151;
    Form5.Panel18.Height   := 151;
    Form5.Panel19.Height   := 151;
    Form5.Panel20.Height   := 151;
    Form5.Panel21.Height   := 151;
    Form5.Panel22.Height   := 151;
    Form5.Panel23.Height   := 151;
    Form5.Panel24.Height   := 151;
    //
    ScrollBox1DblClick(Sender);
    //
    Close;
    //
  end;
end;

end.






















//                                                                     //
//                                                                     //
//   _____  __  __  _____  __     __     _____  _____  _____  ______   //
//  /  ___>|  \/  |/  _  \|  |   |  |   /  ___>/     \|  ___||_    _|  //
//  \___  \|      ||  _  ||  |__ |  |__ \___  \|  |  ||  __|   |  |    //
//  <_____/|_|\/|_|\_/ \_/|_____||_____|<_____/\_____/|__|     |__|    //
//                                                                     //
//  All rights reserved                                                //
//                                                                     //






























