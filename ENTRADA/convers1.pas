unit convers1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Db, DBTables, SmallFunc;

type
  TForm1 = class(TForm)
    Table1: TTable;
    BatchMove1: TBatchMove;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    Table2: TTable;
    Button2: TButton;
    Label12: TLabel;
    Label13: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Image1: TImage;
    Label15: TLabel;
    Image3: TImage;
    Label16: TLabel;
    Image4: TImage;
    Botao_Forte: TImage;
    Botao_Fraco: TImage;
    procedure Button2Click(Sender: TObject);
    procedure Button2Enter(Sender: TObject);
    procedure Button2Exit(Sender: TObject);
    procedure Button4Enter(Sender: TObject);
    procedure Button4Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation


{$R *.DFM}

function Converso(sArquivo:String): Boolean;
var
  sAtual : String;
  I , J : Integer;
begin
  //
  with Form1 do
  begin
    //
    if FileExists(sArquivo) and FileExists(AllTrim('_'+Copy(sArquivo+'              ',2,15))) then
    begin
      Label7.Caption := 'Atualizando: '+sArquivo+Replicate(' ',10);
      Label7.Repaint;
      GetDir(0,sAtual);
      Table1.Active       := False;
      Table1.DataBaseName := sAtual;
      Table1.TableName    := sArquivo;
      Pack(Table1);
      Table1.Active       := True;
      //
      Table2.Active       := False;
      Table2.DataBaseName := sAtual;
      Table2.TableName    := AllTrim('_'+Copy(sArquivo+'              ',2,15));
      Pack(Table2);
      Table2.Active       := True;
      //
      BatchMove1.Mappings.Clear;
      //
      // Arquivo original
      //
      for I := 0 to Table1.FieldDefs.Count -1 do
      begin
        for J := 0 to Table2.FieldDefs.Count -1 do
        begin
          if Table1.FieldDefs[I].Name = Table2.FieldDefs[J].Name then
          begin
            Form1.BatchMove1.Mappings.Add(Table1.FieldDefs[I].Name+'='+Table2.FieldDefs[J].Name);
          end;
        end;
      end;
      //
      Table1.Active := False;
      Table2.Active := False;
      //
      Form1.BatchMove1.Execute;
      DeleteFile(StrTran(sARquivo,'DBF','MDX'));                       // Apaga o arquivo: Ex: _STOQUE.DBF
      //
      // ShowMessage(sArquivo);
      //
      DeleteFile(StrTran(sArquivo,'DBF','BAK'));
      CopyFile(pChar(AllTrim('_'+Copy(sArquivo+'              ',2,15))),pChar(StrTran(sArquivo,'DBF','BAK')),True);
      DeleteFile(AllTrim('_'+Copy(sArquivo+'              ',2,15)));   // Apaga o arquivo: Ex: ESTOQUE.MDX
      //
      // Atualiza os números das NF nos itens de venda
      //
      if Table1.TableName = 'ITENS001.DBF' then
      begin
        Table1.Active       := True;
        Table1.First;
        while not Table1.EOF do
        begin
          if AllTrim(Copy(Table1.FieldByName('NUMERONF').AsString,7,1)) = '' then
          begin
            Table1.Edit;
            Table1.FieldByName('NUMERONF').AsString := Copy(Table1.FieldByName('NUMERONF').AsString,1,6) + '1';
            Table1.Post;
          end;
          Table1.Next;
        end;
        Table1.Active := False;
      end;
      //
      if Table1.TableName = 'VENDAS.DBF' then
      begin
        Table1.Active       := True;
        Table1.First;
        while not Table1.EOF do
        begin
          if AllTrim(Copy(Table1.FieldByName('NUMERONF').AsString,7,1)) = '' then
          begin
            if AllTrim(Table1.FieldByName('NUMERONF').AsString) <> '' then
            begin
              Table1.Edit;
              Table1.FieldByName('NUMERONF').AsString := Copy(Table1.FieldByName('NUMERONF').AsString,1,6) + '1';
              Table1.Post;
            end;
          end;
          Table1.Next;
        end;
        Table1.Active := False;
      end;
    end;
  end;
  Result := True;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  I : Integer;
begin
  //
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  //
  Converso('EMITENTE.DBF');
  Converso('OS.DBF');
  Converso('BANCOS.DBF');
  Converso('ALTERACA.DBF');
  Converso('CAIXA.DBF');
  Converso('CLIFOR.DBF');
  Converso('ESTOQUE.DBF');
  Converso('RECEBER.DBF');
  Converso('PAGAR.DBF');
  Converso('VENDEDOR.DBF');
  Converso('CONTAS.DBF');
  Converso('ICM.DBF');
  Converso('GRUPO.DBF');
  Converso('BANCOS.DBF');
  Converso('EMITENTE.DBF');
  Converso('VENDAS.DBF');
  Converso('ITENS001.DBF');
  Converso('COMPRAS.DBF');
  Converso('ITENS002.DBF');
  Converso('TRANSPOR.DBF');
  Converso('GRADE.DBF');
  Converso('NOTA.DBF');
  Converso('ORCAMENT.DBF');
  Converso('REDUCOES.DBF');
  Converso('SERIE.DBF');
  //
  Label7.Caption := 'Aguarde';
  Label7.Repaint;
  //
  for I := 1 to 80 do if FileExists('_OVI'+StrZero(I,4,0)+'.DBF') then CopyFile('MOVI0001.DBF',pChar('MOVI'+StrZero(I,4,0)+'.DBF'),True);
  for I := 1 to 80 do Converso(Pchar('MOVI'+StrZero(I,4,0)+'.DBF'));
  //
  DeleteFile('FLUXO.DBF');
  DeleteFile('RESUMO.DBF');
  DeleteFile('DUPLICAT.DBF');
  DeleteFile('SAIDA.DBF');
  DeleteFile('ENTRADA.DBF');
  DeleteFile('FLUXO.MDX');
  DeleteFile('RESUMO.MDX');
  //
  Label7.Caption := 'Aguarde';
  Label7.Repaint;
  //
  if FileExists('_orneced.dbf') then
  begin
    //
    Label7.Caption := 'Atualizando: CLIENTES.DBF';
    //
    Table2.TableName    := 'CLIFOR.DBF';
    Table2.Active       := False;
    //
    Pack(Table2);
    //
    Table2.AddIndex('CLI_00','NOME',[]);
    Table2.IndexFieldNames := 'NOME';
    Table2.IndexName := 'CLI_00';
    Table2.Active := True;
    //
    Table1.TableName    := '_orneced.dbf';
    Table1.Active       := False;
    Pack(Table1);
    Table1.Active       := True;
    Table1.First;
    while not Table1.Eof do
    begin
      Table2.FindKey([Table1.FieldByName('NOME').AsString]);
      if Table2.FieldByName('NOME').AsString = Table1.FieldByName('NOME').AsString then Table1.Delete else Table1.Next;
    end;
    //
    Table2.IndexName := '';
    Table2.Active := False;
    Table1.Active := False;
    //
    DeleteFile('CLIFOR.MDX');
    //
    Pack(Table1);
    Pack(Table2);
    //
    RenameFile('_orneced.dbf'    , '_LIFOR.DBF');
    //
    Converso('CLIFOR.DBF');
    //
  end;
  //
  Close;
  //
end;

procedure TForm1.Button2Enter(Sender: TObject);
begin
  Label15.Font.Style := [fsBold];
  Image3.Picture    := Form1.Botao_Fraco.Picture;
end;

procedure TForm1.Button2Exit(Sender: TObject);
begin
  Label15.Font.Style := [];
  Image3.Picture     := Form1.Botao_Forte.Picture;
end;

procedure TForm1.Button4Enter(Sender: TObject);
begin
  Label16.Font.Style := [];
  Image4.Picture    := Form1.Botao_Fraco.Picture;
end;

procedure TForm1.Button4Exit(Sender: TObject);
begin
  Label16.Font.Style := [fsBold];
  Image4.Picture    := Form1.Botao_Forte.Picture;
end;

end.


