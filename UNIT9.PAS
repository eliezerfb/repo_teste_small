unit Unit9;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SmallFunc, ComCtrls, Buttons;

type
  TForm9 = class(TForm)
    Panel1: TPanel;
    Button2: TBitBtn;
    Button1: TBitBtn;
    TreeView1: TTreeView;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form9: TForm9;

implementation

uses fiscal;

{$R *.dfm}

procedure TForm9.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm9.Button2Click(Sender: TObject);
var
  F : TextFile;
begin
  //
  Form1.sAjuda := 'ecf_cotepe.htm#Tab. Prod.';
  //
//  ShowMessage('Este PAF-ECF não executa funções de baixa de estoque com base em índices técnicos de produção, não podendo ser utilizado por estabelecimento que necessite deste recurso.');
  //
  Form1.SaveDialog1.FileName := Form1.sPastaDoExecutavel+'\INDTECPRO.TXT';
  //
//  if Form1.SaveDialog1.Execute then
  begin
    //
    DeleteFile(Form1.SaveDialog1.FileName);
    AssignFile(F, Form1.SaveDialog1.FileName);
    Rewrite(F);                           // Abre para gravação
    //
    Writeln(F, '');
    //
    Form1.ibDataSet4.Close;
    Form1.ibDataSet4.SelectSQL.Clear;
    Form1.ibDataSet4.SelectSQL.Add('select * from ESTOQUE where coalesce(ATIVO,0)=0 order by CODIGO');
    Form1.ibDAtaSet4.Open;
    //
    Form1.ibDataSet4.First;
    while not Form1.ibDataSet4.EOF do
    begin
      //
      Form1.ibDataSet100.Close;
      Form1.ibDataSet100.SelectSql.Clear;
      Form1.ibDataSet100.SelectSQL.Add('select * from COMPOSTO where CODIGO='+QuotedStr(Form1.ibDataSet4.FieldByname('CODIGO').AsString)+' ');
      Form1.ibDataSet100.Open;
      //
      if not Form1.ibDataSet100.Eof then
      begin
        //
        Writeln(F, Form1.ibDataSet4.FieldByname('CODIGO').AsString + ' ' + Form1.ibDataSet4.FieldByname('DESCRICAO').AsString);
        //
        while not Form1.ibDataSet100.Eof do
        begin
          //
          Form1.ibDataSet99.Close;
          Form1.ibDataSet99.SelectSql.Clear;
          Form1.ibDataSet99.SelectSQL.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(Form1.ibDataSet100.FieldByname('DESCRICAO').AsString)+' ');
          Form1.ibDataSet99.Open;
          //
          Writeln(F, ' '+Form1.ibDataSet99.FieldByname('CODIGO').AsString + '  ' + Copy(Form1.ibDataSet99.FieldByname('DESCRICAO').AsString+Replicate(' ',35),1,35) + ' ' + Format('%10.2n',[Form1.ibDataSet100.FieldByname('QUANTIDADE').AsFloat])+' '+Form1.ibDataSet99.FieldByname('MEDIDA').AsString);
          Form1.ibDataSet100.Next;
          //
        end;
        //
      end;
      //
      Form1.ibDataSet4.Next;
      //
    end;
    //
    Writeln(F, '');
    //
    CloseFile(F);                                    // Fecha o arquivo
    //
  end;
  //
  AssinaturaDigital(pChar(Form1.SaveDialog1.FileName));
  //
end;

procedure TForm9.FormActivate(Sender: TObject);
var
  tn    : TTreeNode;
begin
  //
  Form1.sAjuda := 'ecf_cotepe.htm#Tab. Prod.';
  Form9.TreeView1.Items.Clear;
  //
  Form1.ibDataSet4.Close;
  Form1.ibDataSet4.SelectSQL.Clear;
  Form1.ibDataSet4.SelectSQL.Add('select * from ESTOQUE where coalesce(ATIVO,0)=0 order by CODIGO');
  Form1.ibDAtaSet4.Open;
  //
  Form1.ibDataSet4.First;
  while not Form1.ibDataSet4.EOF do
  begin
    //
    Form1.ibDataSet100.Close;
    Form1.ibDataSet100.SelectSql.Clear;
    Form1.ibDataSet100.SelectSQL.Add('select * from COMPOSTO where CODIGO='+QuotedStr(Form1.ibDataSet4.FieldByname('CODIGO').AsString)+' ');
    Form1.ibDataSet100.Open;
    //
    if not Form1.ibDataSet100.Eof then
    begin
      //
      tn := Form9.TreeView1.Items.AddChild(Nil,pChar(Form1.ibDataSet4.FieldByname('CODIGO').AsString + ' ' + Form1.ibDataSet4.FieldByname('DESCRICAO').AsString));
      //
      while not Form1.ibDataSet100.Eof do
      begin
        //
        Form1.ibDataSet99.Close;
        Form1.ibDataSet99.SelectSql.Clear;
        Form1.ibDataSet99.SelectSQL.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(Form1.ibDataSet100.FieldByname('DESCRICAO').AsString)+' ');
        Form1.ibDataSet99.Open;
        //
        Form9.TreeView1.Items.AddChild(tn, pChar(' '+Form1.ibDataSet99.FieldByname('CODIGO').AsString + '  ' + Copy(Form1.ibDataSet99.FieldByname('DESCRICAO').AsString+Replicate(' ',35),1,35) + ' ' + Format('%10.2n',[Form1.ibDataSet100.FieldByname('QUANTIDADE').AsFloat])+' '+Form1.ibDataSet99.FieldByname('MEDIDA').AsString));
        Form1.ibDataSet100.Next;
        //
      end;
      //
    end;
    //
    Form1.ibDataSet4.Next;
    //
  end;
  //
end;

end.
