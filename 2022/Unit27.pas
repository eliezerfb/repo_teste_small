unit Unit27;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, iniFiles, SmallFunc, shellapi, Mask,
  DBCtrls, SMALL_DBEdit;

type
  TForm27 = class(TForm)
    Panel2: TPanel;
    Image1: TImage;
    Label2: TLabel;
    DateTimePicker1: TDateTimePicker;
    Label3: TLabel;
    DateTimePicker2: TDateTimePicker;
    Button3: TButton;
    Button4: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DateTimePicker2Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form27: TForm27;

implementation

uses Unit7, Mais, Unit40, Unit34, Unit14, Mais3;

{$R *.DFM}


procedure TForm27.Button2Click(Sender: TObject);
begin
  Form27.Close;
end;

procedure TForm27.Button4Click(Sender: TObject);
var
  tInicio : tTime;
  Mais1Ini : TiniFile;
  F, F1: TextFile;
  fNConsiliados,  fReceber, fPagar, fTotal, fTotal1, fTotal2, fTotal3: Double;
  dContador, dInicio, dFinal : TdateTime;
  MesInicial, I : Integer;
begin
  //
  tInicio := Time;
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  Form27.Repaint;
  //
  try
    //
    AssignFile(F,pChar(Senhas.UsuarioPub+'.HTM'));  // Direciona o arquivo F para EXPORTA.TXT
    Rewrite(F);                           // Abre para gravação
    Writeln(F,'<html><head><title>'+AnsiUpperCase(AllTrim(Form7.ibDataSet13NOME.AsString)+' - '+Form7.Caption)+'</title></head>');
    WriteLn(F,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>');
    WriteLn(F,'<img src="logotip.jpg" alt="'+AllTrim(Form7.ibDataSet13NOME.AsString)+'">');
    WriteLn(F,'<br><font face="Verdana" size=3 color=#000000><b>'+AllTrim(Form7.ibDataSet13NOME.AsString)+'</b></font>');
    WriteLn(F,'<br></center>');              // Linha em branco
    WriteLn(F,'<br>');           // Linha em branco
    WriteLn(F,'<center>');
    //
    DeleteFile(pChar(Form1.sAtual+'\fluxo.png'));
    DeleteFile(pChar(Form1.sAtual+'\FLUXO.GRA'));

    {$IFDEF VER150}
    ShortDateFormat := 'dd/mm/yyyy';
    {$ELSE}
    FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
    {$ENDIF}

    dInicio :=  DateTimePicker1.Date;
    dFinal  :=  DateTimePicker2.Date;
    //
    dInicio := StrToDate(DateToStr(dInicio));
    dFinal  := StrToDate(DateToStr(dFinal ));
    //
    fTotal  := 0;                          // Zeresima
    fTotal1 := 0;                          // Zeresima
    fTotal2 := 0;                          // Zeresima
    fTotal3 := 0;                          // Zeresima
    //
    Form7.ibDataSet2.DisableControls;
    Form7.ibDataSet7.DisableControls;
    Form7.ibDataSet8.DisableControls;
    //
    //
//    if (dFinal - dInicio) > 30 then
    begin
      WriteLn(F,'<a href="fluxo.png"><img src="fluxo.png" border="0" width=760 height=380></a><br><br><br>');
    end;
    //
    WriteLn(F,'<table border=0>');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td>');
    WriteLn(F,'   <table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    // Acumula os valores
    Form7.ibDataSet11.Active := True;                          //
    Form7.ibDataSet11.First;                                   // Contas Bancárias
    while not Form7.ibDataSet11.EOF do                         //
    begin                                            //
      if Form7.ibDataSet11SALDO3.AsFloat <> 0 then             // Só as não zeradas
      begin                                          //
        WriteLn(F,'    <tr bgcolor=#FFFFFF>');
        WriteLn(F,'        <td nowrap align=left><font face="Verdana" size=1>'+Form7.ibDataSet11NOME.AsString+'<br></font></td>');
        WriteLn(F,'        <td nowrap align=right><font face="Verdana" size=1>'+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+ Format('%15.2n',[Form7.ibDataSet11SALDO3.AsFloat])+'<br></font></td>');
        fTotal := fTotal + Form7.ibDataSet11SALDO3.AsFloat;    // Soma ao total
      end;                                           //
      Form7.ibDataSet11.Next;                                  // Próxima conta
    end;
    //                                          // Saldo do Caixa
    Form7.ibDataSet1.Last;                                     // vai para o último registro
    //
    WriteLn(F,'     <tr bgcolor=#FFFFFF>');
    WriteLn(F,'        <td nowrap align=left width=560><font face="Verdana" size=1>Caixa do dia '+DateToStr(Form7.ibDataSet1DATA.AsDateTime)+'<br></font></td>');
    WriteLn(F,'        <td nowrap align=right><font face="Verdana" size=1>'+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+ Format('%15.2n',[Form7.ibDataSet1SALDO.AsFloat])+'<br></font></td>');
    fTotal := fTotal + Form7.ibDataSet1SALDO.AsFloat;          // Soma ao total
    WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+'>');
    WriteLn(F,'        <td nowrap align=left><font face="Verdana" size=1>Total<br></font></td>');
    WriteLn(F,'        <td nowrap align=right><font face="Verdana" size=1>'+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+ Format('%15.2n',[fTotal])+'<br></font></td>');
    WriteLn(F,'   </table>');
    WriteLn(F,'  </td>');
    WriteLn(F,' </tr>');
    WriteLn(F,'</table><br>');
    //
//      WriteLn(F,'<br>');              // Linha em branco
//      WriteLn(F,'<br>');              // Linha em branco
////////////////////// Poe o calendario ao lado
    WriteLn(F,'<table border=0 cellspacing=10>');
    WriteLn(F,' <tr valign=top>');
    WriteLn(F,'  <td>');

/////////////////////////
// C A L E N D A R I O //
/////////////////////////
    WriteLn(F,'<font face="Verdana" size=1><b>'+MesExtenso(Month(dInicio))+' de '+IntToStr(Year(dInicio))+'</b>');              // Mês e ano
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+' align=left>');
    WriteLn(F,'  <th nowrap><font face="Verdana" size=1 color=FF0000>Dom</font></th>');
    WriteLn(F,'  <th nowrap><font face="Verdana" size=1>Seg</font></th>');
    WriteLn(F,'  <th nowrap><font face="Verdana" size=1>Ter</font></th>');
    WriteLn(F,'  <th nowrap><font face="Verdana" size=1>Qua</font></th>');
    WriteLn(F,'  <th nowrap><font face="Verdana" size=1>Qui</font></th>');
    WriteLn(F,'  <th nowrap><font face="Verdana" size=1>Sex</font></th>');
    WriteLn(F,'  <th nowrap><font face="Verdana" size=1 color=FF0000>Sab</font></th>');
    WriteLn(F,' </tr>');
    //
    WriteLn(F,' <tr bgcolor=#FFFFFF>');
    //
    dContador  := DInicio - Day(dInicio) +1;
    MesInicial := Month(dInicio);
    //
    for I := 1 to DayOfWeek(dContador)-1 do WriteLn(F,'   <td nowrap align=left><font face="Verdana" size=1> </td>');
    while dContador <= dFinal + DiasPorMes(Year(dFinal),Month(dFinal)) - Day(dFinal) do
    begin
      if Month(dContador) = MesInicial then
      begin
        if DayOfWeek(dContador) = 1 then WriteLn(F,' <tr bgcolor=#FFFFFF>');
        if (dContador < dInicio) or (dContador > dFinal) then WriteLn(F,'   <td nowrap align=left><font face="Verdana" size=1 color=c0c0c0>'+IntToStr(Day(dContador))+'</td>') else WriteLn(F,'   <td nowrap align=left><font face="Verdana" size=1>'+IntToStr(Day(dContador))+'</td>');
        if DayOfWeek(dContador) = 7 then WriteLn(F,' </tr>');
        dContador := SomaDias(dContador, 1);                // Incrementa o contador
      end else
      begin
        MesInicial := Month(dContador);
        for I := DayOfWeek(dContador) to 7 do WriteLn(F,'   <td nowrap align=left><font face="Verdana" size=1> </td>');
        WriteLn(F,' </tr>');
        WriteLn(F,'</table>');
        WriteLn(F,'<br>');
        WriteLn(F,'<br><font face="Verdana" size=1><b>'+MesExtenso(Month(dContador))+' de '+IntToStr(Year(dInicio))+'</b>');              // Mês e ano
        WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
        WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+' align=left>');
        WriteLn(F,'  <th nowrap><font face="Verdana" size=1 color=FF0000>Dom</font></th>');
        WriteLn(F,'  <th nowrap><font face="Verdana" size=1>Seg</font></th>');
        WriteLn(F,'  <th nowrap><font face="Verdana" size=1>Ter</font></th>');
        WriteLn(F,'  <th nowrap><font face="Verdana" size=1>Qua</font></th>');
        WriteLn(F,'  <th nowrap><font face="Verdana" size=1>Qui</font></th>');
        WriteLn(F,'  <th nowrap><font face="Verdana" size=1>Sex</font></th>');
        WriteLn(F,'  <th nowrap><font face="Verdana" size=1 color=FF0000>Sab</font></th>');
        WriteLn(F,' </tr>');
        //
        WriteLn(F,' <tr bgcolor=#FFFFFF>');
        for I := 1 to DayOfWeek(dContador)-1 do WriteLn(F,'   <td nowrap align=left><font face="Verdana" size=1> </td>');
      end;
    end;
    //
    WriteLn(F,' </tr>');
    WriteLn(F,'</table>');
    WriteLn(F,'<br>');
    //
/////////////////////////
// C A L E N D A R I O //
/////////////////////////

    WriteLn(F,'  </td><td>');

////////////////
// F L U X O  //
////////////////

    // Cabeçalho
    //      WriteLn(F,'<table border=0>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=2>');
    WriteLn(F,'    <tr  bgcolor=#'+Form1.sHtmlCor+' align=left>');
    WriteLn(F,'        <th nowrap><font face="Verdana" size=1>Data</font></th>');
    WriteLn(F,'        <th nowrap><font face="Verdana" size=1>Dia</font></th>');
    WriteLn(F,'        <th nowrap><font face="Verdana" size=1>Receber</font></th>');
    WriteLn(F,'        <th nowrap><font face="Verdana" size=1>Pagar</font></th>');
    WriteLn(F,'        <th nowrap><font face="Verdana" size=1>Diferença</font></th>');
    WriteLn(F,'        <th nowrap><font face="Verdana" size=1>Saldo</font></th>');
    WriteLn(F,'    </tr>');
    
    try
      Form7.ibDataSet25.Close;
      Form7.ibDataSet25.SelectSql.Clear;
      Form7.ibDataSet25.SelectSQL.Add('delete from FLUXO');
      Form7.ibDataSet25.Open;
    except
    end;

    Form7.ibDataSet25.Close;
    Form7.ibDataSet25.SelectSql.Clear;
    Form7.ibDataSet25.SelectSQL.Add('select * from FLUXO order by DATA');
    Form7.ibDataSet25.Open;

    // cria o gráfico de fluxo de caixa fluxo.png
    Mais1ini := TIniFile.Create(Form1.sAtual+'\FLUXO.GRA');
    Mais1Ini.WriteString('DADOS','3D','1');
    Mais1Ini.WriteString('DADOS','NomeBmp','fluxo.png');
    Mais1Ini.WriteString('DADOS','TituloY','');
    Mais1Ini.WriteString('DADOS','TipoS1','5');
    Mais1Ini.WriteString('DADOS','Titulo','Fluxo de Caixa');
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','Legenda','0');
    Mais1Ini.WriteString('DADOS','MarcasS1','0');
    Mais1Ini.WriteString('DADOS','TituloX','');
    //
    Mais1Ini.WriteString('DADOS','AlturaBmp','380');
    Mais1Ini.WriteString('DADOS','LarguraBmp','760');
    //
    Mais1Ini.WriteString('DADOS','CorS1','$008FC26C'); // Verde
    //
    Mais1Ini.WriteString('DADOS','FontSize','20'); 
    Mais1Ini.WriteString('DADOS','FontSizeLabel','8');
    //
    I := 0;
    // Acumula os valores
    dContador := DInicio;
    while dContador <= dFinal do
    begin
      AssignFile(F1,StrTraN(DateToStr(dCONTADOR),'/','')+'.HTM');            // Direciona o arquivo F para FLUXO.TXT
      Rewrite(F1);                           // Abre para gravação
      Writeln(F1,'<html><head><title>'+AnsiUpperCase(AllTrim(Form7.ibDataSet13NOME.AsString)+' - '+Form7.Caption)+'</title></head>');
      WriteLn(F1,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>');
      WriteLn(F1,'<img src="logotip.jpg" alt="'+AllTrim(Form7.ibDataSet13NOME.AsString)+'">');
      WriteLn(F1,'<br><font face="Verdana" size=3 color=#c0c0c0><b>'+AllTrim(Form7.ibDataSet13NOME.AsString)+'</b></font>');
      WriteLn(F1,'<br>');           // Linha em branco
      WriteLn(F1,'<br><font face="Verdana" size=2 color=#000000><b>Contas a Receber do Dia '+DateToStr(dCONTADOR)+'</b></font>');
      WriteLn(F1,'<br></center>');              // Linha em branco
      WriteLn(F1,'<center>');
      WriteLn(F1,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
      WriteLn(F1,'  <tr  bgcolor=#'+Form1.sHtmlCor+' align=left>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1>Documento</font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1>Valor</font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1>Cliente</font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1>Histórico</font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1>Telefone</font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1>Portador</font></th>');
      WriteLn(F1,'  </tr>');
      fReceber := 0;                                     // Zerezima
      //
      Form7.ibDataSet7.Close;
      Form7.ibDataSet7.SelectSQL.Clear;
      Form7.ibDataSet7.SelectSQL.Add('select * from RECEBER where Coalesce(VALOR_RECE,0)=0 and coalesce(HISTORICO,''XXX'')<>''NFE NAO AUTORIZADA'' and VENCIMENTO='+QuotedStr(DateToStrInvertida(dContador))+' and coalesce(ATIVO,9)<>1 order by VENCIMENTO');
      Form7.ibDataSet7.Open;
      //
      while not Form7.ibDataSet7.EOF do
      begin
        //
        Form7.ibDataSet100.Close;
        Form7.ibDataSet100.SelectSql.Clear;
        Form7.ibDataSet100.SelectSQL.Add('select FONE from CLIFOR where NOME='+QuotedStr(Alltrim(Form7.ibDataSet7NOME.AsString))+'');
        Form7.ibDataSet100.Open;
        //
        fReceber := fReceber + Form7.ibDataSet7VALOR_DUPL.AsFloat; // soma o valor da dupl
        WriteLn(F1,' <tr bgcolor=#FFFFFF>');
        WriteLn(F1,'   <td nowrap align=left><font face="Verdana" size=1>'+Form7.ibDataSet7DOCUMENTO.AsString+'</td>');
        WriteLn(F1,'   <td nowrap align=right><font face="Verdana" size=1>'+Format('%15.2n',[Form7.ibDataSet7VALOR_DUPL.AsFloat])+'</td>');
        WriteLn(F1,'   <td nowrap align=left><font face="Verdana" size=1>'+Form7.ibDataSet7NOME.AsString+'</td>');
        WriteLn(F1,'   <td nowrap align=left><font face="Verdana" size=1>'+Form7.ibDataSet7HISTORICO.AsString+'</td>');
        WriteLn(F1,'   <td nowrap align=left><font face="Verdana" size=1>'+Form7.ibDataSet100.FieldByname('FONE').AsString+'</td>');
        WriteLn(F1,'   <td nowrap align=left><font face="Verdana" size=1>'+Form7.ibDataSet7PORTADOR.AsString+'</td>');
        WriteLn(F1,' </tr>');
        //
        Form7.ibDataSet7.Next;                                                    // Proximo
        //
      end;
      //
      WriteLn(F1,'  <tr  bgcolor=#'+Form1.sHtmlCor+' align=left>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1></font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1>'+Format('%15.2n',[fReceber])+'</font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1></font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1></font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1></font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1></font></th>');
      WriteLn(F1,'  </tr>');
      //
      WriteLn(F1,'</table>');
      //
      WriteLn(F1,'<br>');           // Linha em branco
      WriteLn(F1,'<br><font face="Verdana" size=2 color=#000000><b>Contas a Pagar do Dia '+DateTimeToStr(dCONTADOR)+'</b></font>');
      WriteLn(F1,'<br></center>');              // Linha em branco
      WriteLn(F1,'<center>');
      WriteLn(F1,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
      WriteLn(F1,'  <tr  bgcolor=#'+Form1.sHtmlCor+' align=left>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1>Documento</font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1>Valor</font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1>Fornecedor</font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1>Histórico</font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1>Telefone</font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1>Portador</font></th>');
      WriteLn(F1,'  </tr>');
      //
      fPagar := 0;                                       //  Zerezima
      Form7.ibDataSet8.Close;
      Form7.ibDataSet8.SelectSQL.Clear;
      Form7.ibDataSet8.SelectSQL.Add('select * from PAGAR where VALOR_PAGO=0 and VENCIMENTO='+QuotedStr(DateToStrInvertida(dContador))+' and coalesce(ATIVO,9)<>1 order by VENCIMENTO');
      Form7.ibDataSet8.Open;
      //
      while not Form7.ibDataSet8.EOF do   // Percore o arquivo do dia
      begin
        //
        fPagar := fPagar + Form7.ibDataSet8VALOR_DUPL.AsFloat; // Soma o valor da dupl
        //
        Form7.ibDataSet100.Close;
        Form7.ibDataSet100.SelectSql.Clear;
        Form7.ibDataSet100.SelectSQL.Add('select FONE from CLIFOR where NOME='+QuotedStr(Alltrim(Form7.ibDataSet8NOME.AsString))+'');
        Form7.ibDataSet100.Open;
        //
        WriteLn(F1,'  <tr bgcolor=#FFFFFF>');
        WriteLn(F1,'   <td nowrap align=left><font face="Verdana" size=1>'+Form7.ibDataSet8DOCUMENTO.AsString+'</td>');
        WriteLn(F1,'   <td nowrap align=right><font face="Verdana" size=1>'+Format('%15.2n',[Form7.ibDataSet8VALOR_DUPL.AsFloat])+'</td>');
        WriteLn(F1,'   <td nowrap align=left><font face="Verdana" size=1>'+Form7.ibDataSet8NOME.AsString+'</td>');
        WriteLn(F1,'   <td nowrap align=left><font face="Verdana" size=1>'+Form7.ibDataSet8HISTORICO.AsString+'</td>');
        WriteLn(F1,'   <td nowrap align=left><font face="Verdana" size=1>'+Form7.ibDataSet100.FieldByname('FONE').AsString+'</td>');
        WriteLn(F1,'   <td nowrap align=left><font face="Verdana" size=1>'+Form7.ibDataSet8PORTADOR.AsString+'</td>');
        WriteLn(F1,'  </tr>');
        //
        Form7.ibDataSet8.Next;
        //
      end;
      //
      WriteLn(F1,'  <tr  bgcolor=#'+Form1.sHtmlCor+' align=left>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1></font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1>'+Format('%15.2n',[fPagar])+'</font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1></font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1></font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1></font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1></font></th>');
      WriteLn(F1,'  </tr>');
      WriteLn(F1,' </table>');
      //
      WriteLn(F1,'<br>');           // Linha em branco
      WriteLn(F1,'<br><font face="Verdana" size=2 color=#000000><center><b>Lançamentos bancários previstos para '+DateTimeToStr(dCONTADOR)+'</b></font>');
      WriteLn(F1,'<br></center>');              // Linha em branco
      WriteLn(F1,'<center>');
      WriteLn(F1,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
      WriteLn(F1,'  <tr  bgcolor=#'+Form1.sHtmlCor+' align=left>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1>Documento</font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1>Valor</font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1>Banco</font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1>Histórico</font></th>');
      WriteLn(F1,'  </tr>');
      //
      fNConsiliados := 0;                                       //  Zerezima
      Form7.ibDataSet5.Close;
      Form7.ibDataSet5.SelectSQL.Clear;
      Form7.ibDataSet5.SelectSQL.Add('select * from MOVIMENT where (COMPENS='+QuotedStr('1899/12/30')+' or coalesce(COMPENS,'+QuotedStr('1899/12/30')+')='+QuotedStr('1899/12/30')+') and PREDATA='+QuotedStr(DateToStrInvertida(dContador))+' order by PREDATA');
      Form7.ibDataSet5.Open;
      //
      while not Form7.ibDataSet5.EOF do   // Percore o arquivo do dia
      begin
        //
        fNConsiliados := fNConsiliados + (Form7.ibDataSet5ENTRADA_.AsFloat - Form7.ibDataSet5SAIDA_.AsFloat) ; // Soma o valor da dupl
        //
        WriteLn(F1,'  <tr bgcolor=#FFFFFF>');
        WriteLn(F1,'   <td nowrap align=left><font face="Verdana" size=1>'+Form7.ibDataSet5DOCUMENTO.AsString+'</td>');
        WriteLn(F1,'   <td nowrap align=right><font face="Verdana" size=1>'+Format('%15.2n',[Form7.ibDataSet5ENTRADA_.AsFloat - Form7.ibDataSet5SAIDA_.AsFloat])+'</td>');
        WriteLn(F1,'   <td nowrap align=left><font face="Verdana" size=1>'+Form7.ibDataSet5NOME.AsString+'</td>');
        WriteLn(F1,'   <td nowrap align=left><font face="Verdana" size=1>'+Form7.ibDataSet5HISTORICO.AsString+'</td>');
        WriteLn(F1,'  </tr>');
        //
        Form7.ibDataSet5.Next;
        //
      end;
      //
      WriteLn(F1,'  <tr  bgcolor=#'+Form1.sHtmlCor+' align=left>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1></font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1>'+Format('%15.2n',[fNConsiliados])+'</font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1></font></th>');
      WriteLn(F1,'   <th nowrap><font face="Verdana" size=1></font></th>');
      WriteLn(F1,'  </tr>');
      //
      if fNConsiliados > 0 then fReceber := fReceber + fNConsiliados else fPagar := fPagar + (fNConsiliados * -1);
      //
      fTotal := fTotal + fReceber - fPagar;           // Saldo
      //
      Form7.ibDataSet25.Append;                                 // Registro novo no fluxo.dbf
      Form7.ibDataSet25DATA.AsDateTime    := dContador;          // Grava a data no arquivo fluxo.dbf
      Form7.ibDataSet25RECEBER.AsFloat    := fReceber;           // Grava o valor a RECEBER no arquivo fluxo.dbf
      Form7.ibDataSet25PAGAR.AsFloat      := fPagar;             // Grava o valor a PAGAR no arquivo fluxo.dbf
      Form7.ibDataSet25DIFERENCA_.AsFloat := fReceber - fPagar;  // Grava o valor da diferença
      Form7.ibDataSet25ACUMULADO3.AsFloat := fTotal;             // Grava o valor do Saldo
      Form7.ibDataSet25.Post;
      //
      WriteLn(F1,'</table>');
      WriteLn(F1,'<br><font face="Verdana" size=1>Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
        + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
        + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time)+'</font>');
      //
      WriteLn(F1,'<br>');              // Linha em branco
      WriteLn(F1,'</html>');
      CloseFile(F1);                                    // Fecha o arquivo
      //
      WriteLn(F,'    <tr bgcolor=#FFFFFF>');
      WriteLn(F,'        <td nowrap align=left><font face="Verdana" size=1><a href="'+StrTraN(DateToStr(dCONTADOR),'/','')+'.HTM">'+DateTimeToStr(Form7.ibDataSet25DATA.AsDateTime)+'</a><br></font></td>');

      if (DayOfWeek(Form7.ibDataSet25DATA.AsDateTime) = 1) or (DayOfWeek(Form7.ibDataSet25DATA.AsDateTime) = 7) then
        WriteLn(F,'        <td nowrap align=left><font face="Verdana" size=1 color=#FF0000>'+Copy(DiaDaSemana(Form7.ibDataSet25DATA.AsDateTime),1,3)+'<br></font></td>') else WriteLn(F,'        <td nowrap align=left><font face="Verdana" size=1>'+Copy(DiaDaSemana(Form7.ibDataSet25DATA.AsDateTime),1,3)+'<br></font></td>');
      WriteLn(F,'        <td nowrap align=right><font face="Verdana" size=1>'+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+ Format('%15.2n',[Form7.ibDataSet25RECEBER.AsFloat])+'<br></font></td>');
      WriteLn(F,'        <td nowrap align=right><font face="Verdana" size=1>'+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+ Format('%15.2n',[Form7.ibDataSet25PAGAR.AsFloat])+'<br></font></td>');
      WriteLn(F,'        <td nowrap align=right><font face="Verdana" size=1>'+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+ Format('%15.2n',[Form7.ibDataSet25DIFERENCA_.AsFloat])+'<br></font></td>');
      WriteLn(F,'        <td nowrap align=right><font face="Verdana" size=1>'+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+ Format('%15.2n',[Form7.ibDataSet25ACUMULADO3.AsFloat])+'<br></font></td>');
      //
      if Form7.ibDataSet25ACUMULADO3.AsFloat <> 0 then
      begin
        I := I + 1;
        Mais1Ini.WriteString('DADOS',
        'XY'+StrZero(I,2,0),'S1<'+StrTran(Format('%15.2n',[Form7.ibDataSet25ACUMULADO3.AsFloat]),'.','')                          +'>S2<'+'0,00'
                          +'>VX<'+StrZero(I,2,0)+'>LX<'+Copy(DateTimeToStr(Form7.ibDataSet25DATA.AsDateTime),1,5)+'>');
      end;
      //
      dContador := SomaDias(dContador, 1);                // Incrementa o contador
      fTotal1   := fTotal1 + Form7.ibDataSet25RECEBER.AsFloat;
      fTotal2   := fTotal2 + Form7.ibDataSet25PAGAR.AsFloat;
      fTotal3   := fTotal3 + Form7.ibDataSet25DIFERENCA_.AsFloat;
    end;
    //
    Mais1Ini.Free;
    //
    WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+'>');
    WriteLn(F,'        <td nowrap align=left><font face="Verdana" size=1><br></font></td>');
    WriteLn(F,'        <td nowrap align=right><font face="Verdana" size=1><br></font></td>');
    WriteLn(F,'        <td nowrap align=right><font face="Verdana" size=1>'+ Format('%15.2n',[fTotal1])+'<br></font></td>');
    WriteLn(F,'        <td nowrap align=right><font face="Verdana" size=1>'+ Format('%15.2n',[fTotal2])+'<br></font></td>');
    WriteLn(F,'        <td nowrap align=right><font face="Verdana" size=1>'+ Format('%15.2n',[fTotal3])+'<br></font></td>');
    WriteLn(F,'        <td nowrap align=left><font face="Verdana" size=1></font></td>');
    // -----------
    WriteLn(F,'  </tr>');
    WriteLn(F,'</table>');
    //
////////////////
// F L U X O  //
////////////////
    WriteLn(F,'  </td>');
    WriteLn(F,' </tr>');
    WriteLn(F,'</table>');
    WriteLn(F,'<br>');
    //
    Writeln(F,'<font face="Verdana" size=1><br>Período de ' + DateTimeToStr(dInicio) + ' até ' + DateTimeToStr(dFinal));
    //
    //
    CriaJpg('logotip.jpg');
    //
//    if (dFinal - dInicio) > 30 then
    begin
      ShellExecute( 0, 'Open', 'graficos.exe', 'FLUXO.GRA SMALLSOFT', '', SW_SHOWMINNOACTIVE);
      while not FileExists(Form1.sAtual+'\fluxo.png') do sleep(100);
    end;
    //
    Form7.ibDataSet2.EnableControls;
    Form7.ibDataSet7.EnableControls;
    Form7.ibDataSet8.EnableControls;
    //
    WriteLn(F,'<br><font face="Verdana" size=1>Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
      + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
      + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time)+'</font>');
    //
    WriteLn(F,'<br>');              // Linha em branco
    //
    // WWW
    //
    if (Alltrim(Form7.ibDataSet13HP.AsString) = '') then
    begin
      WriteLn(F,'<font face="Verdana" size=1><center>Relatório gerado pelo sistema Smallsoft, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
    end else
    begin
      WriteLn(F,'<font face="Verdana" size=1><center><a href="http://'+Form7.ibDataSet13HP.AsString+'">'+Form7.ibDataSet13HP.AsString+'</a><font>');
    end;
    //
    WriteLn(F,'<font face="Verdana" size=1><center>Tempo para gerar este relatório: '+TimeToStr(Time - tInicio)+'</center>');
    //
    if not Form1.bPDF then WriteLn(F,'<a href="http://www.smallsoft.com.br/meio_ambiente.htm"><center><font face="Webdings" size=5 color=#215E21>P<font face="Verdana" size=1 color=#215E21> Antes de imprimir, pense no meio ambiente.</center></a>');
    WriteLn(F,'</html>');
    CloseFile(F);                                    // Fecha o arquivo
    //
    Screen.Cursor := crHourGlass; // Cursor de Aguardo
    Screen.Cursor := crDefault; // Cursor de Aguardo
    //
  except end;
  //
  Screen.Cursor := crDefault; // Cursor de Aguardo
  Form27.Close;
  //
  if Form7.Visible then
  begin
    AgendaCommit(True);
    Form7.Close;
    Form7.Show;
  end else
  begin
    AgendaCommit(True);
    Fechatudo(True);
    Commitatudo(True); // SQL - Commando
    AbreArquivos(False); 
  end;
  //
  AbreArquivoNoFormatoCerto(Senhas.UsuarioPub);
  //
end;

procedure TForm27.FormActivate(Sender: TObject);
begin
  Image1.Picture := Form7.Image205.Picture;

  {$IFDEF VER150}
  ShortDateFormat := 'dd/mm/yyyy';
  {$ELSE}
  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  {$ENDIF}

  DateTimePicker1.Date    := Date;
  DateTimePicker2.Date    := Date + 60; // SomaDias(Date, 30);
end;

procedure TForm27.DateTimePicker2Exit(Sender: TObject);
begin
  Button4.Setfocus;
end;

end.



