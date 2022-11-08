unit Unit11;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SmallFunc, IniFiles, ExtCtrls, frame_teclado_1,
  Buttons
  , uajustaresolucao
  ;

type
  TForm11 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TBitBtn;
    Label6: TLabel;
    Panel2: TPanel;
    Frame_teclado1: TFrame_teclado;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit5: TEdit;
    Edit4: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label1MouseLeave(Sender: TObject);
    procedure Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CarregaInformacoesConta(iConta: Integer);
  end;

var
  Form11: TForm11;

implementation

uses fiscal, Unit2, DB, ufuncoesfrente;

{$R *.dfm}

procedure TForm11.Button1Click(Sender: TObject);
var
  iCaracteres: Integer;
begin
  iCaracteres := Form11.Edit1.MaxLength; // Sandro Silva 2018-09-13
  //
  Close;
  //
  Form1.IBQuery1.Close;
  Form1.IBQuery1.SQL.Clear;
  Form1.IBQuery1.SQL.Add('delete from CONTAOS where CONTA='+QuotedStr(FormataNumeroDoCupom(Form1.icupom))+' '); // Sandro Silva 2021-11-29 Form1.IBQuery1.SQL.Add('delete from CONTAOS where CONTA='+QuotedStr(StrZero(Form1.icupom,6,0))+' ');
  Form1.IBQuery1.Open;
  //
  Commitatudo(True); // Form11.Button1Click()
  //
  Form1.IBQuery1.Close;
  Form1.IBQuery1.SQL.Clear;
  Form1.IBQuery1.SQL.Add('insert into CONTAOS (CONTA,IDENTIFICADOR1,IDENTIFICADOR2,IDENTIFICADOR3,IDENTIFICADOR4,IDENTIFICADOR5) values ('+
  QuotedStr(FormataNumeroDoCupom(Form1.icupom))+', '+ // Sandro Silva 2021-11-29 QuotedStr(StrZero(Form1.icupom,6,0))+', '+
  QuotedStr(Copy(Form11.Edit1.Text, 1, iCaracteres))+', '+ // Sandro Silva 2018-09-13 QuotedStr(Form11.Edit1.Text)+', '+
  QuotedStr(Copy(Form11.Edit2.Text, 1, iCaracteres))+', '+ // Sandro Silva 2018-09-13 QuotedStr(Form11.Edit2.Text)+', '+
  QuotedStr(Copy(Form11.Edit3.Text, 1, iCaracteres))+', '+ // Sandro Silva 2018-09-13 QuotedStr(Form11.Edit3.Text)+', '+
  QuotedStr(Copy(Form11.Edit4.Text, 1, iCaracteres))+', '+ // Sandro Silva 2018-09-13 QuotedStr(Form11.Edit4.Text)+', '+
  QuotedStr(Copy(Form11.Edit5.Text, 1, iCaracteres))+')'); // Sandro Silva 2018-09-13 QuotedStr(Form11.Edit5.Text)+')');

// ShowMessage(Form1.IBQuery1.SQL.Text);

  Form1.IBQuery1.Open;
  //
  Commitatudo(True); // Form11.Button1Click()
  //
end;

procedure TForm11.FormShow(Sender: TObject);
begin
  CarregaInformacoesConta(Form1.icupom);
end;

procedure TForm11.Label1Click(Sender: TObject);
var
  sNome : String;
  SmallIni : tIniFile;
begin
  //
  with Sender as TLabel do
  begin
    //
    sNome   := StrTran(AllTrim(Form1.Small_InputBox('Personalização do sistema','Nome do campo:',Caption)),':','');
    Caption := sNome+':';
    Repaint;
    //
    SmallIni := TIniFile.Create(Form1.sAtual+'\LABELS.INI');
    SmallIni.WriteString('FRENTE',NAME,sNome);
    SmallIni.Free;
    //
  end;
  //
end;

procedure TForm11.Label1MouseLeave(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    Font.Style := [fsBold];
    Font.Color := clBlack;
    Repaint;
  end;
end;

procedure TForm11.Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as TLabel do
  begin
    Font.Style := [fsBold,fsUnderline];
    Font.Color := clBlue;
    Repaint;
  end;
end;

procedure TForm11.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;
  if Key = VK_UP then
  begin
    Perform(Wm_NextDlgCtl,-1,0);
  end;
  if Key = VK_DOWN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;

procedure TForm11.FormActivate(Sender: TObject);
var
  iCaracteres: Integer; // Sandro Silva 2018-09-13
begin
  //
  Form11.Frame_teclado1.Led_FISCAL.Picture := Form1.Frame_teclado1.Led_FISCAL.Picture;
  Form11.Frame_teclado1.Led_FISCAL.Hint    := Form1.Frame_teclado1.Led_FISCAL.Hint;
  //
  Form11.Frame_teclado1.Led_ECF.Picture := Form1.Frame_teclado1.Led_ECF.Picture;
  Form11.Frame_teclado1.Led_ECF.Hint    := Form1.Frame_teclado1.Led_ECF.Hint;
  //
  Form11.Frame_teclado1.Led_REDE.Picture := Form1.Frame_teclado1.Led_REDE.Picture;
  Form11.Frame_teclado1.Led_REDE.Hint    := Form1.Frame_teclado1.Led_REDE.Hint;
  //
  Form11.Edit1.SetFocus;
  //
  Form11.Top    := Form1.Panel1.Top;
  Form11.Left   := Form1.Panel1.Left;
  Form11.Height := Form1.Panel1.Height;
  Form11.Width  := Form1.Panel1.Width;
  //
  // Define o máximo de caracteres permitidos na digitação
  Form1.IBQuery1.Close;
  Form1.IBQuery1.SQL.Text :=
    'select first 1 IDENTIFICADOR1, IDENTIFICADOR2, IDENTIFICADOR3, IDENTIFICADOR4, IDENTIFICADOR5 ' +
    'from CONTAOS ';
  Form1.IBQuery1.Open;

  iCaracteres := Form1.IBQuery1.FieldByName('IDENTIFICADOR1').Size;
  if (Form1.sModeloECF_Reserva <> '59') and (Form1.sModeloECF_Reserva <> '65') and (Form1.sModeloECF_Reserva <> '99') then // Para PAF deve permitir apenas 15 caracteres nos identificadores
    iCaracteres := 15;

  Form11.Edit1.MaxLength := iCaracteres;
  Form11.Edit2.MaxLength := Form11.Edit1.MaxLength;
  Form11.Edit3.MaxLength := Form11.Edit1.MaxLength;
  Form11.Edit4.MaxLength := Form11.Edit1.MaxLength;
  Form11.Edit5.MaxLength := Form11.Edit1.MaxLength;

end;

procedure TForm11.Image6Click(Sender: TObject);
begin
  Form11.Button1.SetFocus;
  Form11.Button1Click(Sender);
end;

procedure TForm11.FormCreate(Sender: TObject);
begin
  AjustaResolucao(Form11); // Sandro Silva 2016-07-28
  AjustaResolucao(Form11.Frame_teclado1);
  Form1.Image7Click(Sender); // Sandro Silva 2016-08-18
end;

procedure TForm11.CarregaInformacoesConta(iConta: Integer);
var
  SmallIni : tIniFile;
  iCaracteres: Integer;
begin
  //
  SmallIni := TIniFile.Create(Form1.sAtual+'\LABELS.INI');
  //
  Form11.Label1.Caption := SmallIni.ReadString('FRENTE','Label1','Identificador 1');
  Form11.Label2.Caption := SmallIni.ReadString('FRENTE','Label2','Identificador 2');
  Form11.Label3.Caption := SmallIni.ReadString('FRENTE','Label3','Identificador 3');
  Form11.Label4.Caption := SmallIni.ReadString('FRENTE','Label4','Identificador 4');
  Form11.Label5.Caption := SmallIni.ReadString('FRENTE','Label5','Identificador 5');
  SmallIni.Free; // Sandro Silva 2018-11-21 Memória 
  //
  if Form1.sConcomitante = 'OS'+LimpaNumero(Form1.ibDataSet13.FieldByname('CGC').AsString) then
  begin
    Form1.IBQuery1.Close;
    Form1.IBQuery1.SQL.Clear;
    Form1.IBQuery1.SQL.Add('select first 1 * from ALTERACA where (TIPO=''MESA'' or TIPO=''DEKOL'') and PEDIDO='+QuotedStr(FormataNumeroDoCupom(iConta))+' order by ITEM'); // Sandro Silva 2021-11-29 Form1.IBQuery1.SQL.Add('select first 1 * from ALTERACA where (TIPO=''MESA'' or TIPO=''DEKOL'') and PEDIDO='+QuotedStr(StrZero(iConta,6,0))+' order by ITEM');
    Form1.IBQuery1.Open;

    Form11.Label6.Caption := StrZero(Form1.iCupom,3,0) + ' - ' + 'Ordem de Serviço: ' + Form1.IBQuery1.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString;// Sandro Silva 2017-12-27 Polimig  Form11.Label6.Caption := 'Ordem de Serviço: '+StrZero(Form1.iCupom,3,0) + Form1.IBQuery1.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString;
    Form11.Label6.Width := Edit1.Width;// Sandro Silva 2017-12-27 Polimig

  end;
  
  if Form1.sConcomitante = 'MESA'+LimpaNumero(Form1.ibDataSet13.FieldByname('CGC').AsString) then
  begin
    Form11.Label6.Caption := 'Mesa: '+StrZero(Form1.iCupom,3,0);
  end;
  //
  Form11.Label6.Width := Edit1.Width; // Sandro Silva 2017-12-27 Polimig  AjustaLargura(260); // Sandro Silva 2017-12-15  260;
  Form11.Label6.Repaint;
  //
  Form1.IBQuery1.Close;
  Form1.IBQuery1.SQL.Clear;
  Form1.IBQuery1.SQL.Add('select * from CONTAOS where CONTA='+QuotedStr(FormataNumeroDoCupom(iConta))+' '); // Sandro Silva 2021-12-01 Form1.IBQuery1.SQL.Add('select * from CONTAOS where CONTA='+QuotedStr(StrZero(iConta,6,0))+' ');
  Form1.IBQuery1.Open;
  //
  iCaracteres := Form1.IBQuery1.FieldByname('IDENTIFICADOR1').Size;
  if (Form1.sModeloECF_Reserva <> '59') and (Form1.sModeloECF_Reserva <> '65') and (Form1.sModeloECF_Reserva <> '99') then
    iCaracteres := 15;
  Edit1.Text := Copy(Form1.IBQuery1.FieldByname('IDENTIFICADOR1').AsString, 1, iCaracteres);
  Edit2.Text := Copy(Form1.IBQuery1.FieldByname('IDENTIFICADOR2').AsString, 1, iCaracteres);
  Edit3.Text := Copy(Form1.IBQuery1.FieldByname('IDENTIFICADOR3').AsString, 1, iCaracteres);
  Edit4.Text := Copy(Form1.IBQuery1.FieldByname('IDENTIFICADOR4').AsString, 1, iCaracteres);
  Edit5.Text := Copy(Form1.IBQuery1.FieldByname('IDENTIFICADOR5').AsString, 1, iCaracteres);
  //
end;

end.
