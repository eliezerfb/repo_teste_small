unit Unit37;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, IniFiles, smallfunc_xe, shellapi, Grids,
  DBGrids, Printers, Data.DB;

type
  TForm37 = class(TForm)
    Panel2: TPanel;
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Panel3: TPanel;
    Edit1: TEdit;
    DBGrid3: TDBGrid;
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid3CellClick(Column: TColumn);
    procedure DBGrid3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form37: TForm37;

implementation

uses Unit7, Mais, Unit34, Unit12, Unit14, Mais3;

{$R *.DFM}

procedure TForm37.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm37.FormActivate(Sender: TObject);
var
  Mais1Ini : TIniFile;
begin
  //
  Image1.Picture := Form7.imgImprimir.Picture;
  //
  // Desabilita os controles
  //
  Form7.ibDataSet9.DisableControls;
  Form7.ibDataSet15.DisableControls;
  Form7.ibDataSet16.DisableControls;
  Form7.ibDataSet4.DisableControls;
  Form7.ibDataSet27.DisableControls;
  Form7.ibDataSet7.DisableControls;
  Form7.ibDataSet2.disableControls;
  Form7.ibDataSet15.DisableControls;
  Form7.ibDataSet16.DisableControls;
  Form7.IBDataSet99.DisableControls;
  //
  if not Form7.ibDataSet4.Active then Form7.ibDataSet4.Open;
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
  DateTimePicker1.Date := StrtoDate(Mais1Ini.ReadString('Outros','Período Inicial',DateToStr(Date)));
  DateTimePicker2.Date := StrtoDate(Mais1Ini.ReadString('Outros','Período Final',DateToStr(Date-360)));
  Mais1Ini.Free;
  //
  Edit1.Text := '';
  //
  if (Copy(Form37.Caption,1,21) = 'Relatório de convênio') or (Form37.Caption = 'Receber convênio') then
  begin
    Label2.Caption := 'Emitidas no período de';
    if Copy(Form37.Caption,1,27) = 'Relatório de convênio TODOS'
      then Form37.Label1.Caption := 'Convênio: TODOS'
        else Form37.Label1.Caption := 'Convênio: ' + Copy(Form7.ibDataSet29NOME.AsString,1,20);
    CheckBox2.Visible := False;
    if Panel3.Visible then Edit1.SetFocus;
  end else
  begin
    Label2.Caption := 'Período de';
    Label1.Caption := 'Vendedor: ' + Copy(Form7.ibDataSet9NOME.AsString,1,35);
    CheckBox2.Visible := True;
  end;
end;

procedure TForm37.Button1Click(Sender: TObject);
var
  F: TextFile;
  dInicio, dFinal : TdateTime;
  fTotal, fTotal1, fTotal2, ftotal3, fPercentu, fComissao : Real;
  sVendedor : String;
  sPedido, sConvenio : String;
begin
  if Form37.Panel3.Visible then
  begin
    Form37.Panel3.Visible := False;
    Form37.Button1.SetFocus;
    Form37.Label1.Caption := 'Convênio: ' + Copy(Form7.ibDataSet29NOME.AsString,1,20);
  end else
  begin
    {$IFDEF VER150}
    ShortDateFormat := 'dd/mm/yyyy';
    {$ELSE}
    FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
    {$ENDIF}

    dInicio :=  DateTimePicker1.Date;
    dFinal  :=  DateTimePicker2.Date;

    Screen.Cursor  := crHourGlass;    // Cursor de Aguardo

    dInicio := StrToDate(DateToStr(dInicio));
    dFinal  := StrToDate(DateToStr(dFinal ));

    DeleteFile(pChar(Senhas.UsuarioPub+'.HTM'));
    DeleteFile(Form1.sAtual+'\COMISSAO.GRA');
    DeleteFile(Form1.sAtual+'\COMISSAO.gif');
    //
    AssignFile(F,pChar(Senhas.UsuarioPub+'.HTM'));  // Direciona o arquivo F para EXPORTA.TXT
    Rewrite(F);                                     // Abre para gravação
    //
    if (Copy(Form37.Caption,1,21) = 'Relatório de convênio') or (Form37.Caption = 'Receber convênio') then
    begin
      //
      // Ok SQL testado
      //
      Writeln(F,'<html><head><title>'+AllTrim(Form7.ibDataSet13NOME.AsString) + ' - CONVÊNIO '+AnsiUpperCase(AllTrim(Form7.ibDataSet2CONVENIO.AsString))+'</title></head>');
      WriteLn(F,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="30">');
      //
      MybookMark := Form7.ibDataSet29.GetBookmark;
      //
      while not Form7.ibDataSet29.Eof do
      begin
        //
        sConvenio := Form7.ibDataSet29NOME.AsString;
        //
        WriteLn(F,'<center><img src="logotip.jpg" alt="'+AllTrim(Form7.ibDataSet13NOME.AsString)+'">');
        WriteLn(F,'<br><font size=3 color=#000000><b>'+AllTrim(Form7.ibDataSet13NOME.AsString)+'</b></font></center>');
        WriteLn(F,'<br><font face="Microsoft Sans Serif" size=4 color=#000000><b>Convênio: '+AllTrim(sConvenio)+'</b></font>');
        //
        fTotal3 := 0;
        //
        Form7.ibDataSet2.First;
        //
        while not Form7.ibDataSet2.eof do
        begin
          //
          if (sConvenio = Form7.ibDataSet2CONVENIO.Asstring) and (Form7.ibDataSet2ULTIMACO.AsDateTime >= dInicio) then
          begin
            //
            WriteLn(F,'<hr><font face="Microsoft Sans Serif" size=3 color=#000000><b>Cliente: '+AllTrim(Form7.ibDataSet2NOME.AsString)+'</b></font><hr>');
            //
            fTotal := 0;
            //
            // HISTÓRICO DAS VENDAS
            //
            if Form37.CheckBox1.Checked = True then
            begin
              //
              Writeln(F,'<font face="Microsoft Sans Serif" size=1><b>HISTÓRICO DAS VENDAS</b>');
              WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
              WriteLn(F,' <tr>');
              WriteLn(F,'  <td  width=050 bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Data</td>');
              WriteLn(F,'  <td  width=050 bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Documento</td>');
              WriteLn(F,'  <td  width=300 bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição</td>');
              WriteLn(F,'  <td  width=100 bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
              WriteLn(F,'  <td  width=100 bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Valor</td>');
              WriteLn(F,' </tr>');
              //
              Form7.IBDataSet15.Close;
              Form7.IBDataSet15.SelectSQL.Clear;
              Form7.IBDataSet15.SelectSQL.Add('select * from VENDAS where CLIENTE='+QuotedStr(Form7.ibDataSet2NOME.AsString)+' and EMITIDA=''S'' and EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' order by EMISSAO');
              Form7.IBDataSet15.Open;
              Form7.IBDataSet15.First;
              //
              while not (Form7.ibDataSet15.EOF) do
              begin
                //
                // Produtos
                //
                Form7.ibDataSet16.Close;
                Form7.ibDataSet16.SelectSQL.Clear;
                Form7.ibDataSet16.SelectSQL.Add('select * from ITENS001 where NUMERONF='+QuotedStr(Form7.ibDataSet15NUMERONF.AsString)+' and coalesce(QUANTIDADE,0) = coalesce(SINCRONIA,0) ');
                Form7.ibDataSet16.Open;
                Form7.ibDataSet16.First;
                //
                while not (Form7.ibDataSet16.EOF) do
                begin
                  if alltrim(Form7.ibDataSet16DESCRICAO.AsString) <> '' then
                  begin
                    WriteLn(F,' <tr>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet15EMISSAO.AsDateTime)      +'</td>'+  // Data
                            '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9)+'/'+Copy(Form7.ibDataSet15NUMERONF.AsString,10,3)+'</td>'+  // Doc
                            '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet16DESCRICAO.AsString+Replicate(' ',35),1,35) +'</td>'+  // Descricao
                            '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%8.'+Form1.ConfCasas+'n',[Form7.ibDataSet16QUANTIDADE.AsFloat])            +'</td>'+  // Quantidade
                            '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet16UNITARIO.AsFloat * Form7.ibDataSet16QUANTIDADE.AsFloat])+'</td>'); // Valor
                    WriteLn(F,' </tr>');
                    fTotal := fTotal + Form7.ibDataSet16UNITARIO.AsFloat * Form7.ibDataSet16QUANTIDADE.AsFloat;
                  end;
                  Form7.ibDataSet16.Next;
                end;
                //
                // Serviços
                //
                Form7.ibDataSet35.Close;
                Form7.ibDataSet35.SelectSQL.Clear;
                Form7.ibDataSet35.SelectSQL.Add('select * from ITENS003 where NUMERONF='+QuotedStr(Form7.ibDataSet15NUMERONF.AsString)+'  order by REGISTRO');
                Form7.ibDataSet35.Open;
                Form7.ibDataSet35.First;
                //
                while not (Form7.ibDataSet35.EOF) do
                begin
                  if alltrim(Form7.ibDataSet35DESCRICAO.AsString) <> '' then
                  begin
                    WriteLn(F,' <tr>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet15EMISSAO.AsDateTime)      +'</td>'+  // Data
                            '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Copy(Form7.ibDataSet15NUMERONF.AsString,1,9)+Replicate(' ',8),1,8)    +'</td>'+  // Doc
                            '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet35DESCRICAO.AsString+Replicate(' ',35),1,35) +'</td>'+  // Descricao
                            '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%8.'+Form1.ConfCasas+'n',[Form7.ibDataSet35QUANTIDADE.AsFloat])            +'</td>'+  // Quantidade
                            '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet35TOTAL.AsFloat])+'</td>'); // Valor
                    WriteLn(F,' </tr>');
                    fTotal := fTotal + Form7.ibDataSet35TOTAL.AsFloat;
                  end;
                  Form7.ibDataSet35.Next;
                end;
                //
                Form7.ibDataSet15.Next;
                //
              end;
              //
              Form7.ibDataSet27.Close;
              Form7.ibDataSet27.SelectSQL.Clear;
              Form7.ibDataSet27.SelectSQL.Add('select * from ALTERACA where CLIFOR='+QuotedStr(Form7.ibDataSet2NOME.AsString)+' and DATA<='+QuotedStr(DateToStrInvertida(dFinal))+' and DATA>='+QuotedStr(DateToStrInvertida(dInicio))+' and (TIPO='+QuotedStr('BALCAO')+' or TIPO='+QuotedStr('VENDA')+')');
              Form7.ibDataSet27.Open;
              Form7.ibDataSet27.First;
              //
              while not (Form7.ibDataSet27.EOF) do
              begin
                //
                WriteLn(F,' <tr>');
                Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet27DATA.AsDateTime)+'</td>');  // Data
                Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet27PEDIDO.AsString+'</td>'); // Doc
                Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet27DESCRICAO.AsString+Replicate(' ',40),1,40)+'</td>'); // Descricao
                Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1 >'+Format('%8.'+Form1.ConfCasas+'n',[Form7.ibDataSet27QUANTIDADE.AsFloat])+'</td>'); // Quantidade
                Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1 >'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet27UNITARIO.AsFloat* Form7.ibDataSet27QUANTIDADE.AsFloat])+'</td>'); // Valor
                WriteLn(F,' </tr>');
                fTotal := fTotal + Form7.ibDataSet27UNITARIO.AsFloat * Form7.ibDataSet27QUANTIDADE.AsFloat;
                Form7.ibDataSet27.Next;
                //
              end;
              //
              // totalizador
              //
              WriteLn(F,' <tr>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
              WriteLn(F,' </tr>');
              WriteLn(F,'</table>');
            end;
            //
            // CONTAS A RECEBER
            //
            fTotal  := 0;
            fTotal1 := 0;
            //
            Writeln(F,'<br><font face="Microsoft Sans Serif" size=1><b>CONTAS A RECEBER</b>');
            WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td  width=050 bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Documento</td>');
            WriteLn(F,'  <td  width=300 bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Histórico</td>');
            WriteLn(F,'  <td  width=050 bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Vencimento</td>');
            WriteLn(F,'  <td  width=100 bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Valor</td>');
            WriteLn(F,'  <td  width=100 bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Valor Atual</td>');
            WriteLn(F,' </tr>');
            //
            Form7.ibDataSet7.Close;
            Form7.ibDataSet7.SelectSQL.Clear;
            Form7.ibDataSet7.SelectSQL.Add('select * from RECEBER where NOME='+QuotedStr(Form7.ibDataSet2NOME.AsString)+' and EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and VALOR_RECE=0  and coalesce(HISTORICO,''XXX'')<>''NFE NAO AUTORIZADA'' ');
            Form7.ibDataSet7.Open;
            Form7.ibDataSet7.First;
            //
            while not Form7.ibDataSet7.Eof do
            begin
              //
              WriteLn(F,' <tr>');
              Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet7DOCUMENTO.AsString+'</td>');
              Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet7HISTORICO.AsString+'</td>');
              Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime)+'</td>');
              Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%10.2n',[Form7.ibDataSet7VALOR_DUPL.AsFloat])+'</td>');
              Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%10.2n',[Form7.ibDataSet7VALOR_JURO.AsFloat])+'</td>');
              WriteLn(F,' </tr>');
              fTotal  := fTotal  + Form7.ibDataSet7VALOR_DUPL.AsFloat;
              fTotal1 := fTotal1 + Form7.ibDataSet7VALOR_JURO.AsFloat;
              //
              Form7.ibDataSet7.Next;
              //
            end;
            //
            // Totalizador
            //
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.2n',[fTotal])+'</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.2n',[fTotal1])+'</td>');
            WriteLn(F,' </tr>');
            WriteLn(F,'</table>');
            //
            fTotal3 := fTotal3 + fTotal1;
            //
          end;
          //
          Form7.ibDataSet2.Next;
          //
        end;
        //
        WriteLn(F,'<br>');              // Linha em branco
        Writeln(F,'<hr><font face="Microsoft Sans Serif" size=4>Total: R$ ' + Format('%12.2n',[fTotal3]) +'<hr>');
        Writeln(F,'<br><font face="Microsoft Sans Serif" size=1><center>Referente as vendas emitidas de ' + DateTimeToStr(dInicio) + ' até ' + DateTimeToStr(dFinal));
        //
        // WWW
        //
        if (Alltrim(Form7.ibDataSet13HP.AsString) = '') then
        begin
          WriteLn(F,'<font face="verdana" size=1><center>Relatório gerado pelo sistema Smallsoft, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
        end else
        begin
          WriteLn(F,'<font face="verdana" size=1><center><a href="http://'+Form7.ibDataSet13HP.AsString+'">'+Form7.ibDataSet13HP.AsString+'</a><font>');
        end;
        //
        if not Form1.bPDF then
          WriteLn(F,'<a href="http://www.smallsoft.com.br/meio_ambiente.htm"><center><font face="Webdings" size=5 color=#215E21>P<font face="Microsoft Sans Serif" size=1 color=#215E21> Antes de imprimir, pense no meio ambiente.</center></a>');
        //
        if Form37.Caption = 'Relatório de convênio TODOS' then
          Form7.ibDataSet29.Next
        else
          Form7.ibDataSet29.Last;
        //
      end;
      //
      WriteLn(F,'</html>');
      Form7.ibDataSet29.GotoBookmark(MyBookMark);
      //
      // OK SQL testado
      //
    end else
    begin
      //
      // Comissão de vendedores     'Relatório de comissões'
      //
      sVendedor  := Form7.ibDataSet9NOME.AsString;
      //
      fTotal     := 0;
      fTotal3    := 0;
      //
      Writeln(F,'<html><head><title>'+AllTrim(Form7.ibDataSet13NOME.AsString) + ' - VENDEDOR '+AnsiUpperCase(AllTrim(sVendedor))+'</title></head>');
      WriteLn(F,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>');
      WriteLn(F,'<img src="logotip.jpg" alt="'+AllTrim(Form7.ibDataSet13NOME.AsString)+'">');
      WriteLn(F,'<br><font size=3 color=#000000><b>'+AllTrim(Form7.ibDataSet13NOME.AsString)+'</b></font>');
      WriteLn(F,'<br><font size=3 color=#000000><b>'+'RELATÓRIO DE COMISSÃO - '+AnsiUpperCase(AllTrim(sVendedor))+'</b></font><br><br>');
      //
      WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=2>');
      WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+' align=left>');
      WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Venda</font></th>');
      WriteLn(F,'  <th '+{nowrap}'>');
      WriteLn(F,'   <table border=0 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
      WriteLn(F,'    <tr  bgcolor=#'+Form1.sHtmlCor+' align=left>');
      //
      if CheckBox2.Checked then // Do que foi recebido
      begin
        //
        if CheckBox1.Checked then // Item por item
        begin
          WriteLn(F,'     <th '+{nowrap}' width=250><font face="Microsoft Sans Serif" size=1>Descrição</font></th>');
          WriteLn(F,'     <th '+{nowrap}' width=60><font face="Microsoft Sans Serif" size=1>Quantidade</font></th>');
          WriteLn(F,'     <th '+{nowrap}' width=30><font face="Microsoft Sans Serif" size=1>%</font></th>');
        end;
        WriteLn(F,'     <th '+{nowrap}' width=60><font face="Microsoft Sans Serif" size=1>Total</font></th>');
        WriteLn(F,'     <th '+{nowrap}' width=60><font face="Microsoft Sans Serif" size=1>Comissão</font></th>');
        WriteLn(F,'    </tr>');
        WriteLn(F,'   </th>');
        WriteLn(F,'  </table>');
        WriteLn(F,' </tr>');
        //
        Form7.IBDataSet15.Close;
        Form7.IBDataSet15.SelectSQL.Clear;
        Form7.IBDataSet15.SelectSQL.Add('select * from VENDAS, ICM where VENDEDOR='+QuotedStr(sVendedor)+'  and EMITIDA=''S'' and EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and ICM.NOME=VENDAS.OPERACAO and (Upper(ICM.INTEGRACAO) like ''%RECEBER%'' or upper(ICM.INTEGRACAO) like ''%CAIXA%'') and coalesce(DUPLICATAS,0)=0 order by EMISSAO');
        Form7.IBDataSet15.Open;
        Form7.IBDataSet15.First;
        //
        while not (Form7.ibDataSet15.EOF) do
        begin
          //
          WriteLn(F,' <tr>');
          if CheckBox1.Checked then // Item por item
          begin
            WriteLn(F,'  <td width=250 align=left valign=Top><font face="Microsoft Sans Serif" size=1>Número: '+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9)
            +'<br>Emissão: '+Form7.ibDataSet15EMISSAO.AsString
            +'<br>Cliente: '+Form7.ibDataSet15CLIENTE.AsString);
          end else
          begin
            WriteLn(F,'  <td width=250 align=left valign=Top><font face="Microsoft Sans Serif" size=1>Número: '+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9)
            +'  '+Form7.ibDataSet15EMISSAO.AsString
            +'  '+Form7.ibDataSet15CLIENTE.AsString);
          end;
          //
          WriteLn(F,'  <td align=left valign=Top>');
          WriteLn(F,'   <table border=0 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
          //
          fTotal1 := 0;
          fTotal2 := 0;
          //
          // Produtos
          //
          Form7.ibDataSet16.Close;
          Form7.ibDataSet16.SelectSQL.Clear;
          Form7.ibDataSet16.SelectSQL.Add('select * from ITENS001 where NUMERONF='+QuotedStr(Form7.ibDataSet15NUMERONF.AsString)+' ');
          Form7.ibDataSet16.Open;
          Form7.ibDataSet16.First;
          //
          while not (Form7.ibDataSet16.EOF) do
          begin
            if alltrim(Form7.ibDataSet16DESCRICAO.AsString) <> '' then
            begin
              // ------------------------------------------ //
              // Se a comissão for diferenciada por produto //
              // ------------------------------------------ //
              Form7.ibDataSet4.Close;
              Form7.ibDataSet4.Selectsql.Clear;
              Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet16CODIGO.AsString)+' ');
              Form7.ibDataSet4.Open;
              //
              if (Form7.ibDataSet16DESCRICAO.AsString = Form7.ibDataSet4DESCRICAO.AsString) and (Form7.ibDataSet4COMISSAO.AsFloat <> 0 ) then
              begin
                fPercentu := Form7.ibDataSet4COMISSAO.AsFloat
              end else
              begin
                // ---------------------------------------------------------- //
                // Percentual de comissao cadastrada no arquivo de vendedores //
                // se o número de duplicatas for <> 0 é venda a prazo         //
                // ---------------------------------------------------------- //
                if (Form7.ibDataSet15DUPLICATAS.AsFloat = 0)  then fPercentu := Form7.ibDataSet9COMISSA1.AsFloat else fPercentu := Form7.ibDataSet9COMISSA2.AsFloat;
              end;
              // ------------------------------------------ //
              fComissao := Form7.ibDataSet16QUANTIDADE.AsFloat * Form7.ibDataSet16UNITARIO.AsFloat * fPercentu / 100;
              //
              if CheckBox1.Checked then // Item por item
              begin
                WriteLn(F,'    <tr bgcolor=#FFFFFF>');
                WriteLn(F,'     <td width=250 align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet16DESCRICAO.AsString+'<br></font></td>');
                WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibDataSet16QUANTIDADE.AsFloat])+'<br></font></td>');
                WriteLn(F,'     <td width=30 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%5.2n',[fPercentu])+'<br></font></td>');
                WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet16QUANTIDADE.AsFloat * Form7.ibDataSet16UNITARIO.AsFloat ])+'<br></font></td>');
                WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%9.2n',[fComissao])+'<br></font></td>');
                WriteLn(F,'    </tr>');
              end else
              begin

              end;
              //
              fTotal1 := fTotal1 + fComissao;
              fTotal2 := fTotal2 + (Form7.ibDataSet16QUANTIDADE.AsFloat * Form7.ibDataSet16UNITARIO.AsFloat);
            end;
            //
            Form7.ibDataSet16.Next;
            //
          end;
          //
          // serviços
          //
          Form7.ibDataSet35.Close;
          Form7.ibDataSet35.SelectSQL.Clear;
          Form7.ibDataSet35.SelectSQL.Add('select * from ITENS003 where NUMERONF='+QuotedStr(Form7.ibDataSet15NUMERONF.AsString)+'  order by REGISTRO');
          Form7.ibDataSet35.Open;
          Form7.ibDataSet35.First;
          //
          while not (Form7.ibDataSet35.EOF) do
          begin
            if alltrim(Form7.ibDataSet35DESCRICAO.AsString) <> '' then
            begin
              // ------------------------------------------ //
              // Se a comissão for diferenciada por produto //
              // ------------------------------------------ //
              Form7.ibDataSet4.Close;
              Form7.ibDataSet4.Selectsql.Clear;
              Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(Form7.ibDataSet35DESCRICAO.AsString)+' ');
              Form7.ibDataSet4.Open;
              //
              if (Alltrim(Form7.ibDataSet35DESCRICAO.AsString) = AllTrim(Form7.ibDataSet4DESCRICAO.AsString)) and (Form7.ibDataSet4COMISSAO.AsFloat <> 0 ) then
              begin
                fPercentu := Form7.ibDataSet4COMISSAO.AsFloat
              end else
              begin
                // ---------------------------------------------------------- //
                // Percentual de comissao cadastrada no arquivo de vendedores //
                // se o número de duplicatas for <> 0 é venda a prazo         //
                // ---------------------------------------------------------- //
                if (Form7.ibDataSet15DUPLICATAS.AsFloat = 0)  then fPercentu := Form7.ibDataSet9COMISSA1.AsFloat else fPercentu := Form7.ibDataSet9COMISSA2.AsFloat;
              end;
              //
              // ------------------------------------------
              //
              fComissao := Form7.ibDataSet35TOTAL.AsFloat * fPercentu / 100;
              //
              if CheckBox1.Checked then // Item por item
              begin
                WriteLn(F,'    <tr bgcolor=#FFFFFF>');
                WriteLn(F,'     <td width=250 align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet35DESCRICAO.AsString+'<br></font></td>');
                WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibDataSet35QUANTIDADE.AsFloat])+'<br></font></td>');
                WriteLn(F,'     <td width=30 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%5.2n',[fPercentu])+'<br></font></td>');
                WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet35TOTAL.AsFloat ])+'<br></font></td>');
                WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%9.2n',[fComissao])+'<br></font></td>');
                WriteLn(F,'    </tr>');
              end else
              begin

              end;
              //
              fTotal1 := fTotal1 + fComissao;
              fTotal2 := fTotal2 + (Form7.ibDataSet35TOTAL.AsFloat);
              //
            end;
            //
            Form7.ibDataSet35.Next;
            //
          end;
          //
          WriteLn(F,'    <tr>');

          if Form7.ibDataSet15DESCONTO.AsFloat <> 0 then
          begin
            //
            if (Form7.ibDataSet15DUPLICATAS.AsFloat = 0)  then fPercentu := Form7.ibDataSet9COMISSA1.AsFloat else fPercentu := Form7.ibDataSet9COMISSA2.AsFloat;
            //
            fComissao := Form7.ibDataSet15DESCONTO.AsFloat * fPercentu / 100;

            // Totalizador
{            fTotal    := fTotal  - (Form7.ibDataSet15DESCONTO.AsFloat);
            fTotal3   := fTotal3 - fComissao;   }


            fTotal1   := fTotal1 - fComissao;
            fTotal2   := fTotal2 - (Form7.ibDataSet15DESCONTO.AsFloat);
            //
            if CheckBox1.Checked then // Item por item
            begin
              WriteLn(F,'     <td  width=250 align=right><font face="Microsoft Sans Serif" size=1><b>Desconto</font></td>');
              WriteLn(F,'     <td  width=60 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
              WriteLn(F,'     <td  width=30 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
              WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[Form7.ibDataSet15DESCONTO.AsFloat*-1])+'<br></font></td>');
              WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fComissao*-1])+'<br></font></td>');
            end;
            //
          end;
          WriteLn(F,'    <tr>');

          if CheckBox1.Checked then // Item por item
          begin
            WriteLn(F,'     <td  width=250 align=right><font face="Microsoft Sans Serif" size=1><b>Total</font></td>');
            WriteLn(F,'     <td  width=60 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
            WriteLn(F,'     <td  width=30 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          end;
          //
          WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal2])+'<br></font></td>');
          WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal1])+'<br></font></td>');
          WriteLn(F,'    </tr>');
          //
          WriteLn(F,'    <tr>');
          //
          fTotal  := fTotal  + ftotal2;
          fTotal3 := fTotal3 + ftotal1;
          //
          WriteLn(F,'   </table>');
          WriteLn(F,'  </td>');
          WriteLn(F,' </tr>');
          //
          Form7.ibDataSet15.Next;
          //
        end;
        //
        Form7.IBDataSet15.Close;
        Form7.IBDataSet15.SelectSQL.Clear;
        Form7.IBDataSet15.SelectSQL.Add('select * from VENDAS, ICM where VENDEDOR='+QuotedStr(sVendedor)+' and EMITIDA=''S'' and ICM.NOME=VENDAS.OPERACAO and (Upper(ICM.INTEGRACAO) like ''%RECEBER%'' or upper(ICM.INTEGRACAO) like ''%CAIXA%'') and DUPLICATAS<>0 order by EMISSAO');
        Form7.IBDataSet15.Open;
        //
        Form7.IBDataSet99.Close;
        Form7.IBDataSet99.SelectSQL.Clear;
        Form7.IBDataSet99.SelectSQL.Add('select * from RECEBER where RECEBIMENT<='+QuotedStr(DateToStrInvertida(dFinal))+' and RECEBIMENT>='+QuotedStr(DateToStrInvertida(dInicio))+'  and coalesce(HISTORICO,''XXX'')<>''NFE NAO AUTORIZADA'' order by RECEBIMENT');
        Form7.IBDataSet99.Open;
        Form7.IBDataSet99.First;
        //
        while not (Form7.ibDataSet99.EOF) do
        begin
          //
          if Form7.ibDataSet15.Locate('NUMERONF',Form7.IBDataSet99.FieldByname('NUMERONF').AsString,[]) then
          begin
            //
            WriteLn(F,' <tr>');
            if CheckBox1.Checked then // Item por item
            begin
              WriteLn(F,'  <td width=250 align=left valign=Top><font face="Microsoft Sans Serif" size=1>Número: '+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9)
              +'<br>Emissão: '+Form7.ibDataSet15EMISSAO.AsString
              +'<br>Cliente: '+Form7.ibDataSet15CLIENTE.AsString
              +'<br>Duplicata: '+Form7.IBDataSet99.FieldByname('DOCUMENTO').AsString
              +'<br>Recebimento: '+Form7.IBDataSet99.FieldByname('RECEBIMENT').AsString
              +'<br>Valor: '+Format('%10.'+Form1.ConfCasas+'n',[Form7.IBDataSet99.FieldByname('VALOR_RECE').AsFloat])+'</td>');
            end else
            begin
              WriteLn(F,'  <td width=400 align=left valign=Top><font face="Microsoft Sans Serif" size=1>Duplicata: '+Form7.IBDataSet99.FieldByname('DOCUMENTO').AsString
              +' '+Form7.IBDataSet99.FieldByname('RECEBIMENT').AsString
              +' '+Form7.IBDataSet99.FieldByname('NOME').AsString);
            end;
            //
            WriteLn(F,'  <td align=left valign=Top>');
            WriteLn(F,'   <table border=0 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            //
            fTotal1 := 0;
            fTotal2 := 0;
            //
            // PRODUTOS
            //
            Form7.ibDataSet16.Close;
            Form7.ibDataSet16.SelectSQL.Clear;
            Form7.ibDataSet16.SelectSQL.Add('select * from ITENS001 where NUMERONF='+QuotedStr(Form7.ibDataSet15NUMERONF.AsString)+'  and coalesce(QUANTIDADE,0) = coalesce(SINCRONIA,0)');
            Form7.ibDataSet16.Open;
            Form7.ibDataSet16.First;
            //
            while not (Form7.ibDataSet16.EOF) do
            begin
              if alltrim(Form7.ibDataSet16DESCRICAO.AsString) <> '' then
              begin
                // ---------------------------------------------------------- //
                // Percentual de comissao cadastrada no arquivo de vendedores //
                // se o número de duplicatas for <> 0 é venda a prazo         //
                // ---------------------------------------------------------- //
                if (Form7.ibDataSet15DUPLICATAS.AsFloat = 0)  then fPercentu := Form7.ibDataSet9COMISSA1.AsFloat else fPercentu := Form7.ibDataSet9COMISSA2.AsFloat;
                // ------------------------------------------ //
                // Se a comissão for diferenciada por produto //
                // ------------------------------------------ //
                Form7.ibDataSet4.Close;
                Form7.ibDataSet4.Selectsql.Clear;
                Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet16CODIGO.AsString)+' ');
                Form7.ibDataSet4.Open;
                //
                if (Form7.ibDataSet16DESCRICAO.AsString = Form7.ibDataSet4DESCRICAO.AsString) and (Form7.ibDataSet4COMISSAO.AsFloat <> 0 ) then fPercentu := Form7.ibDataSet4COMISSAO.AsFloat;
                // ------------------------------------------ //
                fComissao := Form7.ibDataSet16QUANTIDADE.AsFloat * Form7.ibDataSet16UNITARIO.AsFloat * fPercentu / 100;
                //
                if CheckBox1.Checked then // Item por item
                begin
                  WriteLn(F,'    <tr bgcolor=#FFFFFF>');
                  WriteLn(F,'     <td width=250 align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet16DESCRICAO.AsString+'<br></font></td>');
                  WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibDataSet16QUANTIDADE.AsFloat])+'<br></font></td>');
                  WriteLn(F,'     <td width=30 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%5.2n',[fPercentu])+'<br></font></td>');
                  WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet16QUANTIDADE.AsFloat * Form7.ibDataSet16UNITARIO.AsFloat ])+'<br></font></td>');
                  WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%9.2n',[fComissao])+'<br></font></td>');
                  WriteLn(F,'    </tr>');
                end;
                //
                fTotal1 := fTotal1 + fComissao;
                fTotal2 := fTotal2 + (Form7.ibDataSet16QUANTIDADE.AsFloat * Form7.ibDataSet16UNITARIO.AsFloat);
              end;
              //
              Form7.ibDataSet16.Next;
              //
            end;
            //
            // Serviços
            //
            Form7.ibDataSet35.Close;
            Form7.ibDataSet35.SelectSQL.Clear;
            Form7.ibDataSet35.SelectSQL.Add('select * from ITENS003 where NUMERONF='+QuotedStr(Form7.ibDataSet15NUMERONF.AsString)+'  order by REGISTRO');
            Form7.ibDataSet35.Open;
            Form7.ibDataSet35.First;
            //
            while not (Form7.ibDataSet35.EOF) do
            begin
              //
              if alltrim(Form7.ibDataSet35DESCRICAO.AsString) <> '' then
              begin
                // ------------------------------------------ //
                // Se a comissão for diferenciada por produto //
                // ------------------------------------------ //
                Form7.ibDataSet4.Close;
                Form7.ibDataSet4.Selectsql.Clear;
                Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(Form7.ibDataSet35DESCRICAO.AsString)+' ');
                Form7.ibDataSet4.Open;
                //
                if (Alltrim(Form7.ibDataSet35DESCRICAO.AsString) = AllTrim(Form7.ibDataSet4DESCRICAO.AsString)) and (Form7.ibDataSet4COMISSAO.AsFloat <> 0 ) then
                begin
                  fPercentu := Form7.ibDataSet4COMISSAO.AsFloat
                end else
                begin
                  // ---------------------------------------------------------- //
                  // Percentual de comissao cadastrada no arquivo de vendedores //
                  // se o número de duplicatas for <> 0 é venda a prazo         //
                  // ---------------------------------------------------------- //
                  if (Form7.ibDataSet15DUPLICATAS.AsFloat = 0)  then fPercentu := Form7.ibDataSet9COMISSA1.AsFloat else fPercentu := Form7.ibDataSet9COMISSA2.AsFloat;
                end;
                //
                fComissao := Form7.ibDataSet35TOTAL.AsFloat * fPercentu / 100;
                //
                if CheckBox1.Checked then // Item por item
                begin
                  WriteLn(F,'    <tr bgcolor=#FFFFFF>');
                  WriteLn(F,'     <td width=250 align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet35DESCRICAO.AsString+'<br></font></td>');
                  WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibDataSet35QUANTIDADE.AsFloat])+'<br></font></td>');
                  WriteLn(F,'     <td width=30 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%5.2n',[fPercentu])+'<br></font></td>');
                  WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet35TOTAL.AsFloat ])+'<br></font></td>');
                  WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%9.2n',[fComissao])+'<br></font></td>');
                  WriteLn(F,'    </tr>');
                end;
                //
                fTotal1 := fTotal1 + fComissao;
                fTotal2 := fTotal2 + Form7.ibDataSet35TOTAL.AsFloat;
                //
              end;
              //
              Form7.ibDataSet35.Next;
              //
            end;
            //
            WriteLn(F,'    <tr>');
            //
            if CheckBox1.Checked then // Item por item
            begin
              WriteLn(F,'     <td  width=250 align=right><font face="Microsoft Sans Serif" size=1><b>Total</font></td>');
              WriteLn(F,'     <td  width=60 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
              WriteLn(F,'     <td  width=30 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
              WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal2])+'<br></font></td>');
              WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal1])+'<br></font></td>');
              WriteLn(F,'    </tr>');
            end;
            //
            WriteLn(F,'    <tr>');
            //
            if CheckBox1.Checked then // Item por item
            begin
              WriteLn(F,'     <td  width=250 align=right><font face="Microsoft Sans Serif" size=1><b>Total recebido da parcela</font></td>');
              WriteLn(F,'     <td  width=60 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
              WriteLn(F,'     <td  width=30 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
            end;
            //
            WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[Form7.IBDataSet99.FieldByname('VALOR_RECE').AsFloat])+'<br></font></td>');
            WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[(fTotal1 / fTotal2 * Form7.IBDataSet99.FieldByname('VALOR_RECE').AsFloat)])+'<br></font></td>');
            //
            WriteLn(F,'    </tr>');
            //
            fTotal  := fTotal  + Form7.IBDataSet99.FieldByname('VALOR_RECE').AsFloat;
            //
            fTotal3 := fTotal3 + (fTotal1 / fTotal2 * Form7.IBDataSet99.FieldByname('VALOR_RECE').AsFloat);
            //
            WriteLn(F,'   </table>');
            WriteLn(F,'  </td>');
            WriteLn(F,' </tr>');
            //
          end;
          //
          //
          Form7.ibDataSet27.Close;
          Form7.ibDataSet27.SelectSQL.Clear;
          {Sandro Silva 2023-02-23 inicio   ficha 6637
          Form7.ibDataSet27.SelectSQL.Add('select * from ALTERACA ' +
          'where PEDIDO='+QuotedStr('0'+copy(Form7.IBDataSet99.FieldByname('NUMERONF').AsString,1,5))+
          ' and SubString(CAIXA from 2 for 2)='+QuotedStr(copy(Form7.IBDataSet99.FieldByname('NUMERONF').AsString,6,2))+
          ' and VENDEDOR='+QuotedStr(sVendedor)+
          ' ');
          }
          Form7.ibDataSet27.SelectSQL.Text :=
            'select * from ALTERACA ' +
            'where PEDIDO = ' + QuotedStr(Copy(Form7.IBDataSet99.FieldByname('NUMERONF').AsString, 1, 6)) +
            ' and subString(CAIXA from 2 for 2) = ' + QuotedStr(Right(Form7.IBDataSet99.FieldByname('NUMERONF').AsString, 2)) +
            ' and VENDEDOR = ' + QuotedStr(sVendedor) +
            ' and char_length(' + QuotedStr(Form7.IBDataSet99.FieldByname('NUMERONF').AsString) + ') < 12 ' + // Número da nota no PDV tem menos que 12 dígitos. Se aumentar o tamanho de ALTERACA.PEDIDO deverá rever essa lógica
            ' ';
          {Sandro Silva 2023-02-23 fim}

          Form7.ibDataSet27.Open;
          Form7.ibDataSet27.First;
          //
{
if Form7.ibDataSet99.FieldByname('RECEBIMENT').AsString = '29/09/2008' then
begin
  ShowMEssage(Form7.ibDataSet99.FieldByname('RECEBIMENT').AsString+chr(10)+
  Form7.ibDataSet99.FieldByname('DOCUMENTO').AsString);
  ShowMessage(Form7.ibDataSet27.SelectSQL.Text);

---------------------------
Small Commerce
---------------------------
select * from ALTERACA where PEDIDO='000923' and CAIXA='099' and VENDEDOR='CARLOS'

---------------------------
OK
---------------------------



end;
}


          //
          if not Form7.ibDataSet27.Eof then
          begin
            //
            WriteLn(F,' <tr>');
            if CheckBox1.Checked then // Item por item
            begin
              WriteLn(F,'  <td width=250 align=left valign=Top><font face="Microsoft Sans Serif" size=1>Número: '+Copy(Form7.ibDataSet27PEDIDO.AsString,1,6)
              +'<br>Emissão: '+Form7.ibDataSet27DATA.AsString
              +'<br>Cliente: '+Form7.IBDataSet99.FieldByname('NOME').AsString
              +'<br>Duplicata: '+Form7.IBDataSet99.FieldByname('DOCUMENTO').AsString
              +'<br>Recebimento: '+Form7.IBDataSet99.FieldByname('RECEBIMENT').AsString
              +'<br>Valor: '+Format('%10.'+Form1.ConfCasas+'n',[Form7.IBDataSet99.FieldByname('VALOR_RECE').AsFloat])+'</td>');
            end else
            begin
              WriteLn(F,'  <td width=400 align=left valign=Top><font face="Microsoft Sans Serif" size=1>Duplicata: '+Form7.IBDataSet99.FieldByname('DOCUMENTO').AsString
              +' '+Form7.IBDataSet99.FieldByname('RECEBIMENT').AsString
              +' '+Form7.IBDataSet99.FieldByname('NOME').AsString);
            end;
            //
            WriteLn(F,'  <td align=left valign=Top>');
            WriteLn(F,'   <table border=0 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            //
            fTotal1 := 0;
            fTotal2 := 0;
            //
            // PRODUTOS
            //
            while not (Form7.ibDataSet27.EOF) do
            begin
              // ---------------------------------------------------------- //
              // Percentual de comissao cadastrada no arquivo de vendedores //
              // se o número de duplicatas for <> 0 é venda a prazo         //
              // ---------------------------------------------------------- //
              fPercentu := Form7.ibDataSet9COMISSA2.AsFloat;
              // ------------------------------------------ //
              // Se a comissão for diferenciada por produto //
              // ------------------------------------------ //
              Form7.ibDataSet4.Close;
              Form7.ibDataSet4.Selectsql.Clear;
              Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(Form7.ibDataSet27DESCRICAO.AsString)+' ');
              Form7.ibDataSet4.Open;
              //
              if (Form7.ibDataSet27DESCRICAO.AsString = Form7.ibDataSet4DESCRICAO.AsString) and (Form7.ibDataSet4COMISSAO.AsFloat <> 0 ) then fPercentu := Form7.ibDataSet4COMISSAO.AsFloat;
              // ------------------------------------------ //
              fComissao := Form7.ibDataSet27QUANTIDADE.AsFloat * Form7.ibDataSet27UNITARIO.AsFloat * fPercentu / 100;
              //
              if CheckBox1.Checked then // Item por item
              begin
                WriteLn(F,'    <tr bgcolor=#FFFFFF>');
                WriteLn(F,'     <td width=250 align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet27DESCRICAO.AsString+'<br></font></td>');
                WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibDataSet27QUANTIDADE.AsFloat])+'<br></font></td>');
                WriteLn(F,'     <td width=30 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%5.2n',[fPercentu])+'<br></font></td>');
                WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet27QUANTIDADE.AsFloat * Form7.ibDataSet27UNITARIO.AsFloat ])+'<br></font></td>');
                WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%9.2n',[fComissao])+'<br></font></td>');
                WriteLn(F,'    </tr>');
              end;
              //
              fTotal1 := fTotal1 + fComissao;
              fTotal2 := fTotal2 + (Form7.ibDataSet27QUANTIDADE.AsFloat * Form7.ibDataSet27UNITARIO.AsFloat);
              //
              Form7.ibDataSet27.Next;
              //
            end;
            //
            WriteLn(F,'    <tr>');
            //
            if CheckBox1.Checked then // Item por item
            begin
              WriteLn(F,'     <td  width=250 align=right><font face="Microsoft Sans Serif" size=1><b>Total</font></td>');
              WriteLn(F,'     <td  width=60 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
              WriteLn(F,'     <td  width=30 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
              WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal2])+'<br></font></td>');
              WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal1])+'<br></font></td>');
              WriteLn(F,'    </tr>');
            end;
            //
            WriteLn(F,'    <tr>');
            //
            if CheckBox1.Checked then // Item por item
            begin
              WriteLn(F,'     <td  width=250 align=right><font face="Microsoft Sans Serif" size=1><b>Total recebido da parcela</font></td>');
              WriteLn(F,'     <td  width=60 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
              WriteLn(F,'     <td  width=30 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
            end;
            //
            WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[Form7.IBDataSet99.FieldByname('VALOR_RECE').AsFloat])+'<br></font></td>');
            WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[(fTotal1 / fTotal2 * Form7.IBDataSet99.FieldByname('VALOR_RECE').AsFloat)])+'<br></font></td>');
            WriteLn(F,'    </tr>');
            //
            fTotal  := fTotal  + Form7.IBDataSet99.FieldByname('VALOR_RECE').AsFloat;
            fTotal3 := fTotal3 + (fTotal1 / fTotal2 * Form7.IBDataSet99.FieldByname('VALOR_RECE').AsFloat);
            //
            WriteLn(F,'   </table>');
            WriteLn(F,'  </td>');
            WriteLn(F,' </tr>');
            //
          end;
          //
          Form7.ibDataSet99.Next;
          //
        end;
        //
        // --------------- //
        // Venda no balcão //
        // --------------- //
        fTotal1 := 0;
        fTotal2 := 0;
        //
        sPedido := 'XXXXXX';
        //
        Form7.ibDataSet27.Close;
        Form7.ibDataSet27.SelectSQL.Clear;

        {Dailon Parisotto (f-19029) 2024-05-22 Inicio

        Form7.ibDataSet27.SelectSQL.Add('select * from ALTERACA where DATA<='+QuotedStr(DateToStrInvertida(dFinal))+' and DATA>='+QuotedStr(DateToStrInvertida(dInicio))+' and (TIPO='+QuotedStr('BALCAO')+' or TIPO='+QuotedStr('VENDA')+') and VENDEDOR='+QuotedStr(sVendedor)+' order by PEDIDO'); // A vista voltar e acertar

        }
        Form7.ibDataSet27.SelectSQL.Add('SELECT ALTERACA.*');
        Form7.ibDataSet27.SelectSQL.Add('FROM ALTERACA');
        Form7.ibDataSet27.SelectSQL.Add('INNER JOIN PAGAMENT');
        Form7.ibDataSet27.SelectSQL.Add('    ON (PAGAMENT.CAIXA=ALTERACA.CAIXA)');
        Form7.ibDataSet27.SelectSQL.Add('    AND (PAGAMENT.PEDIDO=ALTERACA.PEDIDO)');
        Form7.ibDataSet27.SelectSQL.Add('    AND (SUBSTRING(PAGAMENT.FORMA FROM 1 FOR 2) = ''02'')');
        Form7.ibDataSet27.SelectSQL.Add('WHERE');
        Form7.ibDataSet27.SelectSQL.Add('    (ALTERACA.DATA<='+QuotedStr(DateToStrInvertida(dFinal))+') AND (ALTERACA.DATA>='+QuotedStr(DateToStrInvertida(dInicio))+')');
        Form7.ibDataSet27.SelectSQL.Add('    AND ((ALTERACA.TIPO='+QuotedStr('BALCAO')+') OR (ALTERACA.TIPO='+QuotedStr('VENDA')+'))');
        Form7.ibDataSet27.SelectSQL.Add('    AND (ALTERACA.VENDEDOR='+QuotedStr(sVendedor)+')');
        Form7.ibDataSet27.SelectSQL.Add('ORDER BY ALTERACA.PEDIDO'); // A vista voltar e acertar
        {Dailon Parisotto (f-19029) 2024-05-22 Fim}

        Form7.ibDataSet27.Open;
        Form7.ibDataSet27.First;
        //
        while (not Form7.ibDataSet27.EOF) do
        begin
          //
          // Se a comissão for diferenciada por produto se não pega da tabéla de vendedores
          //
          Form7.IBDataSet99.Close;
          Form7.IBDataSet99.SelectSQL.Clear;
          Form7.IBDataSet99.SelectSQL.Add('select NUMERONF from RECEBER where NUMERONF like '+QuotedStr(StrZero(StrToFloat(Form7.ibDataSet27PEDIDO.AsString),6,0)+Copy(Form7.ibDataSet27CAIXA.AsString,1,3))+' and coalesce(VALOR_RECE,0)=0 ');
          Form7.IBDataSet99.Open;
          //
          if StrZero(StrToFloat(Form7.ibDataSet27PEDIDO.AsString),6,0)+Copy(Form7.ibDataSet27CAIXA.AsString,1,3) <> Form7.ibDataSet99.FieldByName('NUMERONF').AsString then
          begin
            //
            if Form7.ibDataSet27PEDIDO.AsString <> sPedido then
            begin
              //
              WriteLn(F,'    <tr>'); // ok
              //
              //
              if sPedido <> 'XXXXXX' then
              begin
                //
                if CheckBox1.Checked then // Item por item
                begin
                  WriteLn(F,'     <td  width=250 align=right><font face="Microsoft Sans Serif" size=1><b>Total</font></td>');
                  WriteLn(F,'     <td  width=60 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
                  WriteLn(F,'     <td  width=30 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
                end;
                //
                WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal2])+'<br></font></td>');
                WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal1])+'<br></font></td>');
                WriteLn(F,'    </tr>');
                WriteLn(F,'   </table>');
                WriteLn(F,'  </td>');
                WriteLn(F,' </tr>');
              end;
              //
              if CheckBox1.Checked then // Item por item
              begin
                WriteLn(F,'  <td width=200 align=left valign=Top><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet27PEDIDO.AsString,1,6)+'<br>'+Form7.ibDataSet27DATA.AsString+'<br>'+Form7.ibDataSet27CLIFOR.AsString+'<br></td>');
              end else
              begin
                WriteLn(F,'  <td width=430 align=left valign=Top><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet27PEDIDO.AsString,1,6)+'  '+Form7.ibDataSet27DATA.AsString+'  '+Form7.ibDataSet27CLIFOR.AsString+'</td>');
              end;
              WriteLn(F,'  <td align=left valign=Top>');
              WriteLn(F,'   <table border=0 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
              //
              sPedido := Form7.ibDataSet27PEDIDO.AsString;
              fTotal1 := 0;
              fTotal2 := 0;
              //
            end;
            // ------------------------------------------ //
            // Se a comissão for diferenciada por produto //
            // ------------------------------------------ //
            Form7.ibDataSet4.Close;
            Form7.ibDataSet4.Selectsql.Clear;
            Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(Form7.ibDataSet27DESCRICAO.AsString)+' ');
            Form7.ibDataSet4.Open;
            //
            if (Form7.ibDataSet27DESCRICAO.AsString = Form7.ibDataSet4DESCRICAO.AsString) and (Form7.ibDataSet4COMISSAO.AsFloat <> 0 ) then
              fPercentu := Form7.ibDataSet4COMISSAO.AsFloat
            else
              fPercentu := Form7.ibDataSet9COMISSA1.AsFloat;
            fComissao := Form7.ibDataSet27QUANTIDADE.AsFloat * Form7.ibDataSet27UNITARIO.AsFloat * fPercentu / 100;
            //
            if CheckBox1.Checked then // Item por item
            begin
              WriteLn(F,'    <tr bgcolor=#FFFFFF>');
              WriteLn(F,'     <td width=250 align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet27DESCRICAO.AsString+'<br></font></td>');
              WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibDataSet27QUANTIDADE.AsFloat])+'<br></font></td>');
              WriteLn(F,'     <td width=30 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%5.2n',[fPercentu])+'<br></font></td>');
              WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet27QUANTIDADE.AsFloat * Form7.ibDataSet27UNITARIO.AsFloat ])+'<br></font></td>');
              WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%9.2n',[fComissao])+'<br></font></td>');
              WriteLn(F,'    </tr>');
            end;
            //
            fTotal  := fTotal  + (Form7.ibDataSet27QUANTIDADE.AsFloat * Form7.ibDataSet27UNITARIO.AsFloat);
            fTotal3 := fTotal3 + fComissao;
            fTotal1 := fTotal1 + fComissao;
            fTotal2 := fTotal2 + (Form7.ibDataSet27QUANTIDADE.AsFloat * Form7.ibDataSet27UNITARIO.AsFloat);
            //
          end;
          //
          Form7.ibDataSet27.Next;
          //
        end;
        //
        if fTotal2 <> 0 then
        begin
          //
          WriteLn(F,'    <tr>'); // ok
          if CheckBox1.Checked then // Item por item
          begin
            WriteLn(F,'     <td  width=250 align=right><font face="Microsoft Sans Serif" size=1><b>Total</font></td>');
            WriteLn(F,'     <td  width=60 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
            WriteLn(F,'     <td  width=30 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          end;
          //
          WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal2])+'<br></font></td>');
          WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal1])+'<br></font></td>');
          WriteLn(F,'    </tr>');
          WriteLn(F,'   </table>');
          WriteLn(F,'  </td>');
          WriteLn(F,' </tr>');
        end;
        //
        WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+' align=left>');
        WriteLn(F,'  <th '+{nowrap}' align=right><font face="Microsoft Sans Serif" size=1><b>Total recebido no período</font></th>');
        WriteLn(F,'  <th '+{nowrap}'>');
        WriteLn(F,'   <table border=0 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
        WriteLn(F,'    <tr  bgcolor=#'+Form1.sHtmlCor+' align=left>');
        //
        if CheckBox1.Checked then // Item por item
        begin
          WriteLn(F,'     <td width=250 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td width=60  align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td width=30  align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
        end;
        //
        WriteLn(F,'     <td width=60  align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal])+'<br></font></td>');
        WriteLn(F,'     <td width=60  align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal3])+'<br></font></td>');
        WriteLn(F,'    </tr>');
        WriteLn(F,'   </th>');
        WriteLn(F,'  </table>');
        WriteLn(F,' </tr>');
        WriteLn(F,' </tr>');
        WriteLn(F,'</table>');
        //
      end else
      begin
        //
        if CheckBox1.Checked then // Item por item
        begin
          WriteLn(F,'     <th '+{nowrap}' width=250><font face="Microsoft Sans Serif" size=1>Descrição</font></th>');
          WriteLn(F,'     <th '+{nowrap}' width=60><font face="Microsoft Sans Serif" size=1>Quantidade</font></th>');
          WriteLn(F,'     <th '+{nowrap}' width=30><font face="Microsoft Sans Serif" size=1>%</font></th>');
        end;
        //
        WriteLn(F,'     <th '+{nowrap}' width=60><font face="Microsoft Sans Serif" size=1>Total</font></th>');
        WriteLn(F,'     <th '+{nowrap}' width=60><font face="Microsoft Sans Serif" size=1>Comissão</font></th>');
        WriteLn(F,'    </tr>');
        WriteLn(F,'   </th>');
        WriteLn(F,'  </table>');
        WriteLn(F,' </tr>');
        //
        Form7.IBDataSet15.Close;
        Form7.IBDataSet15.SelectSQL.Clear;
        Form7.IBDataSet15.SelectSQL.Add('select * from VENDAS, ICM where EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and VENDEDOR='+QuotedStr(sVendedor)+' and EMITIDA=''S'' and ICM.NOME=VENDAS.OPERACAO and (Upper(ICM.INTEGRACAO) like ''%RECEBER%'' or upper(ICM.INTEGRACAO) like ''%CAIXA%'') order by EMISSAO');
        Form7.IBDataSet15.Open;
        Form7.IBDataSet15.First;
        //
        while not (Form7.ibDataSet15.EOF) do
        begin
          //
          WriteLn(F,' <tr>');
          //
          if CheckBox1.Checked then // Item por item
          begin
            WriteLn(F,'  <td width=200 align=left valign=Top><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9)+'<br>'+Form7.ibDataSet15EMISSAO.AsString+'<br>'+Form7.ibDataSet15CLIENTE.AsString+'<br></td>');
          end else
          begin
            WriteLn(F,'  <td width=430 align=left valign=Top><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9)+'  '+Form7.ibDataSet15EMISSAO.AsString+'  '+Form7.ibDataSet15CLIENTE.AsString+'</td>');
          end;
          WriteLn(F,'  <td align=left valign=Top>');
          WriteLn(F,'   <table border=0 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
          //
          fTotal1 := 0;
          fTotal2 := 0;
          //
          // Produtos
          //
          Form7.ibDataSet16.Close;
          Form7.ibDataSet16.SelectSQL.Clear;
          Form7.ibDataSet16.SelectSQL.Add('select * from ITENS001 where NUMERONF='+QuotedStr(Form7.ibDataSet15NUMERONF.AsString)+'  and coalesce(QUANTIDADE,0) = coalesce(SINCRONIA,0)');
          Form7.ibDataSet16.Open;
          Form7.ibDataSet16.First;
          //
          while not (Form7.ibDataSet16.EOF) do
          begin
            if alltrim(Form7.ibDataSet16DESCRICAO.AsString) <> '' then
            begin
              // ---------------------------------------------------------- //
              // Percentual de comissao cadastrada no arquivo de vendedores //
              // se o número de duplicatas for <> 0 é venda a prazo         //
              // ---------------------------------------------------------- //
              if (Form7.ibDataSet15DUPLICATAS.AsFloat = 0)  then fPercentu := Form7.ibDataSet9COMISSA1.AsFloat else fPercentu := Form7.ibDataSet9COMISSA2.AsFloat;
              // ------------------------------------------ //
              // Se a comissão for diferenciada por produto //
              // ------------------------------------------ //
              Form7.ibDataSet4.Close;
              Form7.ibDataSet4.Selectsql.Clear;
              Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(Form7.ibDataSet16DESCRICAO.AsString)+' ');
              Form7.ibDataSet4.Open;
              //
              if (Form7.ibDataSet16DESCRICAO.AsString = Form7.ibDataSet4DESCRICAO.AsString) and (Form7.ibDataSet4COMISSAO.AsFloat <> 0 ) then fPercentu := Form7.ibDataSet4COMISSAO.AsFloat;
              // ------------------------------------------ //
              fComissao := Form7.ibDataSet16QUANTIDADE.AsFloat * Form7.ibDataSet16UNITARIO.AsFloat * fPercentu / 100;
              //
              if CheckBox1.Checked then // Item por item
              begin
                WriteLn(F,'    <tr bgcolor=#FFFFFF>');
                WriteLn(F,'     <td width=250 align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet16DESCRICAO.AsString+'<br></font></td>');
                WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibDataSet16QUANTIDADE.AsFloat])+'<br></font></td>');
                WriteLn(F,'     <td width=30 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%5.2n',[fPercentu])+'<br></font></td>');
                WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet16QUANTIDADE.AsFloat * Form7.ibDataSet16UNITARIO.AsFloat ])+'<br></font></td>');
                WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%9.2n',[fComissao])+'<br></font></td>');
                WriteLn(F,'    </tr>');
              end;
              //
              fTotal  := fTotal  + (Form7.ibDataSet16QUANTIDADE.AsFloat * Form7.ibDataSet16UNITARIO.AsFloat);
              fTotal3 := fTotal3 + fComissao;
              fTotal1 := fTotal1 + fComissao;
              fTotal2 := fTotal2 + (Form7.ibDataSet16QUANTIDADE.AsFloat * Form7.ibDataSet16UNITARIO.AsFloat);
              //
            end;
            //
            Form7.ibDataSet16.Next;
            //
          end;
          //
          // Serviços
          //
          Form7.ibDataSet35.Close;
          Form7.ibDataSet35.SelectSQL.Clear;
          Form7.ibDataSet35.SelectSQL.Add('select * from ITENS003 where NUMERONF='+QuotedStr(Form7.ibDataSet15NUMERONF.AsString)+'  order by REGISTRO');
          Form7.ibDataSet35.Open;
          Form7.ibDataSet35.First;
          //
          while not (Form7.ibDataSet35.EOF) do
          begin
            if alltrim(Form7.ibDataSet35DESCRICAO.AsString) <> '' then
            begin
              // ------------------------------------------ //
              // Se a comissão for diferenciada por produto //
              // ------------------------------------------ //
              Form7.ibDataSet4.Close;
              Form7.ibDataSet4.Selectsql.Clear;
              Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(Form7.ibDataSet35DESCRICAO.AsString)+' ');
              Form7.ibDataSet4.Open;
              //
              if (Alltrim(Form7.ibDataSet35DESCRICAO.AsString) = AllTrim(Form7.ibDataSet4DESCRICAO.AsString)) and (Form7.ibDataSet4COMISSAO.AsFloat <> 0 ) then
              begin
                fPercentu := Form7.ibDataSet4COMISSAO.AsFloat
              end else
              begin
                // ---------------------------------------------------------- //
                // Percentual de comissao cadastrada no arquivo de vendedores //
                // se o número de duplicatas for <> 0 é venda a prazo         //
                // ---------------------------------------------------------- //
                if (Form7.ibDataSet15DUPLICATAS.AsFloat = 0)  then fPercentu := Form7.ibDataSet9COMISSA1.AsFloat else fPercentu := Form7.ibDataSet9COMISSA2.AsFloat;
              end;
              //
              fComissao := Form7.ibDataSet35TOTAL.AsFloat * fPercentu / 100;
              //
              if CheckBox1.Checked then // Item por item
              begin
                WriteLn(F,'    <tr bgcolor=#FFFFFF>');
                WriteLn(F,'     <td width=250 align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet35DESCRICAO.AsString+'<br></font></td>');
                WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibDataSet35QUANTIDADE.AsFloat])+'<br></font></td>');
                WriteLn(F,'     <td width=30 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%5.2n',[fPercentu])+'<br></font></td>');
                WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet35TOTAL.AsFloat ])+'<br></font></td>');
                WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%9.2n',[fComissao])+'<br></font></td>');
                WriteLn(F,'    </tr>');
              end;
              //
              fTotal  := fTotal  + (Form7.ibDataSet35TOTAL.AsFloat);
              fTotal3 := fTotal3 + fComissao;
              fTotal1 := fTotal1 + fComissao;
              fTotal2 := fTotal2 + (Form7.ibDataSet35TOTAL.AsFloat);
              //
            end;
            //
            Form7.ibDataSet35.Next;
            //
          end;
          //
          if Form7.ibDataSet15DESCONTO.AsFloat <> 0 then
          begin
            //
            if (Form7.ibDataSet15DUPLICATAS.AsFloat = 0)  then fPercentu := Form7.ibDataSet9COMISSA1.AsFloat else fPercentu := Form7.ibDataSet9COMISSA2.AsFloat;
            //
            fComissao := Form7.ibDataSet15DESCONTO.AsFloat * fPercentu / 100;
            fTotal    := fTotal  - (Form7.ibDataSet15DESCONTO.AsFloat);
            fTotal3   := fTotal3 - fComissao;
            fTotal1   := fTotal1 - fComissao;
            fTotal2   := fTotal2 - (Form7.ibDataSet15DESCONTO.AsFloat);
            //
            if CheckBox1.Checked then // Item por item
            begin
              WriteLn(F,'     <td  width=250 align=right><font face="Microsoft Sans Serif" size=1><b>Desconto</font></td>');
              WriteLn(F,'     <td  width=60 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
              WriteLn(F,'     <td  width=30 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
              WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[Form7.ibDataSet15DESCONTO.AsFloat*-1])+'<br></font></td>');
              WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fComissao*-1])+'<br></font></td>');
            end;
            //
          end;
          //
          WriteLn(F,'    <tr>');
          //
          if CheckBox1.Checked then // Item por item
          begin
            WriteLn(F,'     <td  width=250 align=right><font face="Microsoft Sans Serif" size=1><b>Total</font></td>');
            WriteLn(F,'     <td  width=60 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
            WriteLn(F,'     <td  width=30 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          end;
          //
          WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal2])+'<br></font></td>');
          WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal1])+'<br></font></td>');
          WriteLn(F,'    </tr>');
          WriteLn(F,'   </table>');
          WriteLn(F,'  </td>');
          WriteLn(F,' </tr>');
          //
          Form7.ibDataSet15.Next;
          //
        end;
        //
        WriteLn(F,' <tr>');
        // --------------- //
        // Venda no balcão //
        // --------------- //
        sPedido := 'XXXXXX';
        //
        Form7.ibDataSet27.Close;
        Form7.ibDataSet27.SelectSQL.Clear;
        Form7.ibDataSet27.SelectSQL.Add('select');
        Form7.ibDataSet27.SelectSQL.Add('    ALTERACA.*');
        Form7.ibDataSet27.SelectSQL.Add('from ALTERACA');
        Form7.ibDataSet27.SelectSQL.Add('where');
        Form7.ibDataSet27.SelectSQL.Add('(DATA<='+QuotedStr(DateToStrInvertida(dFinal))+' and DATA>='+QuotedStr(DateToStrInvertida(dInicio)) + ')');
        Form7.ibDataSet27.SelectSQL.Add('and ((TIPO='+QuotedStr('BALCAO')+') or (TIPO='+QuotedStr('VENDA')+'))');
        Form7.ibDataSet27.SelectSQL.Add('and (VENDEDOR='+QuotedStr(sVendedor)+')');
        Form7.ibDataSet27.SelectSQL.Add('order by PEDIDO');
        Form7.ibDataSet27.Open;
        Form7.ibDataSet27.First;
        //
        fTotal1 := 0;
        fTotal2 := 0;
        //
        while (not Form7.ibDataSet27.EOF) do
        begin
          Form7.IBDataSet99.Close;
          Form7.IBDataSet99.SelectSQL.Clear;
          Form7.IBDataSet99.SelectSQL.Add('SELECT COUNT(RECEBER.REGISTRO) AS DUPLICATAS FROM RECEBER WHERE (NUMERONF=' + QuotedStr(Form7.ibDataSet27PEDIDO.AsString + Form7.ibDataSet27CAIXA.AsString) + ')');
          Form7.IBDataSet99.Open;
          Form7.IBDataSet99.First;

          if Form7.ibDataSet27PEDIDO.AsString <> sPedido then
          begin
            //
            if sPedido <> 'XXXXXX' then
            begin
              //
              WriteLn(F,'    <tr>');
              //
              if CheckBox1.Checked then // Item por item
              begin
                WriteLn(F,'     <td  width=250 align=right><font face="Microsoft Sans Serif" size=1><b>Total</font></td>');
                WriteLn(F,'     <td  width=60 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
                WriteLn(F,'     <td  width=30 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
              end;
              //
              WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal2])+'<br></font></td>');
              WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal1])+'<br></font></td>');
              WriteLn(F,'    </tr>');
              WriteLn(F,'   </table>');
              WriteLn(F,'  </td>');
              WriteLn(F,' </tr>');
            end;
            //
            if CheckBox1.Checked then // Item por item
            begin
              WriteLn(F,'  <td width=200 align=left valign=Top><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet27PEDIDO.AsString,1,6)+'<br>'+Form7.ibDataSet27DATA.AsString+'<br>'+Form7.ibDataSet27CLIFOR.AsString+'<br></td>');
            end else
            begin
              WriteLn(F,'  <td width=430 align=left valign=Top><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet27PEDIDO.AsString,1,6)+'  '+Form7.ibDataSet27DATA.AsString+'  '+Form7.ibDataSet27CLIFOR.AsString+'</td>');
            end;
            WriteLn(F,'  <td align=left valign=Top>');
            WriteLn(F,'   <table border=0 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            //
            sPedido := Form7.ibDataSet27PEDIDO.AsString;
            fTotal1 := 0;
            fTotal2 := 0;
            //
          end;
          // ------------------------------------------ //
          // Se a comissão for diferenciada por produto //
          // ------------------------------------------ //
          Form7.ibDataSet4.Close;
          Form7.ibDataSet4.Selectsql.Clear;
          Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(Form7.ibDataSet27DESCRICAO.AsString)+' ');
          Form7.ibDataSet4.Open;
          //
          if (Form7.ibDataSet27DESCRICAO.AsString = Form7.ibDataSet4DESCRICAO.AsString) and (Form7.ibDataSet4COMISSAO.AsFloat <> 0 ) then
            fPercentu := Form7.ibDataSet4COMISSAO.AsFloat
          else
          begin
            if (Form7.IBDataSet99.FieldByName('DUPLICATAS').AsInteger = 0) then
              fPercentu := Form7.ibDataSet9COMISSA1.AsFloat
            else
              fPercentu := Form7.ibDataSet9COMISSA2.AsFloat;
          end;
          fComissao := Form7.ibDataSet27QUANTIDADE.AsFloat * Form7.ibDataSet27UNITARIO.AsFloat * fPercentu / 100;
          //
          if CheckBox1.Checked then // Item por item
          begin
            WriteLn(F,'    <tr bgcolor=#FFFFFF>');
            WriteLn(F,'     <td width=250 align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet27DESCRICAO.AsString+'<br></font></td>');
            WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibDataSet27QUANTIDADE.AsFloat])+'<br></font></td>');
            WriteLn(F,'     <td width=30 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%5.2n',[fPercentu])+'<br></font></td>');
            WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet27QUANTIDADE.AsFloat * Form7.ibDataSet27UNITARIO.AsFloat ])+'<br></font></td>');
            WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1>'+Format('%9.2n',[fComissao])+'<br></font></td>');
            WriteLn(F,'    </tr>');
          end;
          //
          fTotal  := fTotal  + (Form7.ibDataSet27QUANTIDADE.AsFloat * Form7.ibDataSet27UNITARIO.AsFloat);
          fTotal3 := fTotal3 + fComissao;
          fTotal1 := fTotal1 + fComissao;
          fTotal2 := fTotal2 + (Form7.ibDataSet27QUANTIDADE.AsFloat * Form7.ibDataSet27UNITARIO.AsFloat);
          //
          Form7.ibDataSet27.Next;
          //
        end;
        //
        if ftotal2 <> 0 then
        begin
          WriteLn(F,'    <tr>');
          if CheckBox1.Checked then // Item por item
          begin
            WriteLn(F,'     <td  width=250 align=right><font face="Microsoft Sans Serif" size=1><b>Total</font></td>');
            WriteLn(F,'     <td  width=60 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
            WriteLn(F,'     <td  width=30 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          end;
          //
          WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal2])+'<br></font></td>');
          WriteLn(F,'     <td width=60 align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal1])+'<br></font></td>');
          WriteLn(F,'    </tr>');
          WriteLn(F,'   </table>');
          WriteLn(F,'  </td>');
          WriteLn(F,' </tr>');
        end;
        //
        WriteLn(F,'    <tr>');
        //
        WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+' align=left>');
        WriteLn(F,'  <th '+{nowrap}' align=right><font face="Microsoft Sans Serif" size=1><b>Total</font></th>');
        WriteLn(F,'  <th '+{nowrap}'>');
        WriteLn(F,'   <table border=0 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
        WriteLn(F,'    <tr  bgcolor=#'+Form1.sHtmlCor+' align=left>');
        //
        if CheckBox1.Checked then // Item por item
        begin
          WriteLn(F,'     <td width=250 align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td width=60  align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td width=30  align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
        end;
        //
        WriteLn(F,'     <td width=60  align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal])+'<br></font></td>');
        WriteLn(F,'     <td width=60  align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal3])+'<br></font></td>');
        WriteLn(F,'    </tr>');
        WriteLn(F,'   </th>');
        WriteLn(F,'  </table>');
        WriteLn(F,' </tr>');
        WriteLn(F,' </tr>');
        WriteLn(F,'</table>');
        //
      end;
    end;
    //
    WriteLn(F,'<br>');              // Linha em branco
    Writeln(F,'<center><font face="Microsoft Sans Serif" size=1><br>Período analisado, de ' + DateTimeToStr(dInicio) + ' até ' + DateTimeToStr(dFinal)+'<br></center>');
    //
    // WWW
    //
    if (Alltrim(Form7.ibDataSet13HP.AsString) = '') then
    begin
      WriteLn(F,'<font face="verdana" size=1><center>Relatório gerado pelo sistema Smallsoft, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
    end else
    begin
      WriteLn(F,'<font face="verdana" size=1><center><a href="http://'+Form7.ibDataSet13HP.AsString+'">'+Form7.ibDataSet13HP.AsString+'</a><font>');
    end;
    //
    if not Form1.bPDF then WriteLn(F,'<a href="http://www.smallsoft.com.br/meio_ambiente.htm"><center><font face="Webdings" size=5 color=#215E21>P<font face="Microsoft Sans Serif" size=1 color=#215E21> Antes de imprimir, pense no meio ambiente.</center></a>');
    WriteLn(F,'</html>');
    //
    Screen.Cursor  := crDefault;
    CloseFile(F);
    Form37.Close;
    //
  end;
  //
end;


procedure TForm37.Edit1Change(Sender: TObject);
begin
//  Form7.ibDataSet29.IndexFieldNames := 'NOME';
//  Form7.ibDataSet29.SetKey;
//  Form7.ibDataSet29NOME.AsString := AllTrim(Edit1.Text);
//  Form7.ibDataSet29.GotoNearest;
  Form37.DBGrid3.Update;
end;

procedure TForm37.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Form37.Panel3.Visible := False;
    Form37.Button1.SetFocus;
    Form37.Label1.Caption := 'Convênio: ' + Copy(Form7.ibDataSet29NOME.AsString,1,20);
  end;
  if dBgrid3.Visible = True then
  begin
    if (Key = VK_UP) or (Key = VK_DOWN) then  if dBgrid3.CanFocus then dBgrid3.SetFocus  else Button1.SetFocus;
  end


end;

procedure TForm37.DBGrid3CellClick(Column: TColumn);
begin
  Form37.Label1.Caption := 'Convênio: ' + Copy(Form7.ibDataSet29NOME.AsString,1,20);
  Edit1.Text := Form7.ibDataSet29NOME.AsString;
  Edit1.SetFocus;
  Form37.Panel3.Visible := False;
  Form37.Button1.SetFocus;
end;

procedure TForm37.DBGrid3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Form37.Panel3.Visible := False;
    Form37.Button1.SetFocus;
    Form37.Label1.Caption := 'Convênio: ' + Copy(Form7.ibDataSet29NOME.AsString,1,20);
  end;
end;

procedure TForm37.FormShow(Sender: TObject);
begin
  if FileExists(Senhas.UsuarioPub+'.HTM') then DeleteFile(pChar(Senhas.UsuarioPub+'.HTM'));
end;

procedure TForm37.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Mais1Ini : TIniFile;
  dInicio, dFinal : TdateTime;
  fTotal : Real;
  I : Integer;
  sConvenio : String;

begin
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
  Mais1Ini.WriteString('Outros','Período Inicial',DateToStr(DateTimePicker1.Date));
  Mais1Ini.WriteString('Outros','Período Final',DateToStr(DateTimePicker2.Date));
  Mais1Ini.Free;
  //
  if FileExists(Senhas.UsuarioPub+'.HTM') then AbreArquivoNoFormatoCerto(Senhas.UsuarioPub);
  //
  if (Form37.Caption = 'Receber convênio') then
  begin
    //////////////////////////////////////////////
    // Calcula o total                          //
    //////////////////////////////////////////////
    dInicio :=  Form37.DateTimePicker1.Date;
    dFinal  :=  Form37.DateTimePicker2.Date;
    //
    sConvenio := Form7.ibDataSet29NOME.AsString;
    fTotal := 0;
    //
    Form7.ibDataSet2.Close;
    Form7.ibDataSet2.SelectSql.Clear;
    Form7.ibDataSet2.SelectSql.Add('select * from CLIFOR');
    Form7.ibDataSet2.Open;
    //
    Form7.ibDataSet2.First;
    while not Form7.ibDataSet2.eof do
    begin
      //
      if (sConvenio = Form7.ibDataSet2CONVENIO.Asstring) and (Form7.ibDataSet2ULTIMACO.AsDateTime >= dInicio) then
      begin
        //
        // CONTAS A RECEBER
        //
        Form7.sModulo := 'AUTOMATICO';
        Form7.ibDataSet7.First;
        Form7.ibDataSet7.Locate('NOME',Form7.ibDataSet2NOME.AsString,[]);
        while (Form7.ibDataSet7NOME.AsString = Form7.ibDataSet2NOME.AsString) and not (Form7.ibDataSet7.Eof) do
        begin
          if ((Form7.ibDataSet7EMISSAO.AsDateTime <= dFinal) and (Form7.ibDataSet7EMISSAO.AsDateTime >= dInicio)) then
          begin
            if Form7.ibDataSet7VALOR_RECE.AsFloat = 0 then
            begin
              fTotal  := fTotal  + Form7.ibDataSet7VALOR_DUPL.AsFloat;
            end;
          end;
          Form7.ibDataSet7.Next;
        end;
        Form7.sModulo := 'RECEBER';
        //
      end;
      //
      Form7.ibDataSet2.Next;
      //
    end;
    //
    //
    //
    I := Application.MessageBox(Pchar('Tem certeza que quer efetuar quitação das contas'
                            + chr(10)+'a receber do convênio '+AllTrim(Form7.ibDataSet29NOME.AsString)
                            +' no valor de R$ '+AllTrim(Format('%12.2n',[fTotal]))+chr(10)
                            +' Conforme apresentado no relatório?'
                            + Chr(10))
                            ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING);
    if I = IDYES then
    begin
      //
      I := Application.MessageBox(Pchar('Imprimir recibo?'
                            + Chr(10))
                            ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONQUESTION);
      if I = IDYES then
      begin
        Form7.fTotalDoRecibo       := fTotal;
        Form7.sReciboProvenienteDe := 'Referente ao pagamento das duplicatas do período entre '+DateToStr(dInicio) + ' até '
                                      +DateToStr(dFinal)+' do convênio '+AllTrim(Form7.ibDataSet29NOME.AsString)+'.';
        Form7.sReciboRecebemosDe   := Form7.ibDataSet29RAZAO.AsString;
        Form7.RECIBOClick(Sender);
      end;
      //
      Form7.ibDataSet2.First;
      while not Form7.ibDataSet2.eof do
      begin
        if (sConvenio = Form7.ibDataSet2CONVENIO.Asstring) and (Form7.ibDataSet2ULTIMACO.AsDateTime >= dInicio) then
        begin
          //
          // CONTAS A RECEBER
          //
          Form7.ibDataSet7.First;
          Form7.ibDataSet7.Locate('NOME',Form7.ibDataSet2NOME.AsString,[]);
          while (Form7.ibDataSet7NOME.AsString = Form7.ibDataSet2NOME.AsString) and not (Form7.ibDataSet7.Eof) do
          begin
            if ((Form7.ibDataSet7EMISSAO.AsDateTime <= dFinal) and (Form7.ibDataSet7EMISSAO.AsDateTime >= dInicio)) then
            begin
              if Form7.ibDataSet7VALOR_RECE.AsFloat = 0 then
              begin
                Form7.ibDataSet1.Edit;
                Form7.ibDataSet7.Edit;
                Form7.sModulo := 'AUTOMATICO';
                Form7.ibDataSet7VALOR_RECE.AsFloat := Form7.ibDataSet7VALOR_DUPL.AsFloat;
              end;
            end;
            Form7.ibDataSet7.Next;
          end;
        end;
        Form7.ibDataSet2.Next;
      end;
    end;
  end;
  //
  // Desabilita os controles
  //
  Form7.ibDataSet9.EnableControls;
  Form7.ibDataSet15.EnableControls;
  Form7.ibDataSet16.EnableControls;
  Form7.ibDataSet4.EnableControls;
  Form7.ibDataSet27.EnableControls;
  Form7.ibDataSet7.EnableControls;
  Form7.ibDataSet2.EnableControls;
  Form7.ibDataSet15.EnableControls;
  Form7.ibDataSet16.EnableControls;
  Form7.IBDataSet99.EnableControls;
  //
end;

end.


