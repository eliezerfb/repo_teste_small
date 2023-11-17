unit uframeCampoCaixasRelatorio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, CheckLst, IBQuery, IBDataBase;

type
  TframeCampoCaixasRel = class(TFrame)
    chklbCaixas: TCheckListBox;
    chkCaixaFechamentoDeCaixa: TCheckBox;
    procedure chklbCaixasClickCheck(Sender: TObject);
    procedure chklbCaixasKeyPress(Sender: TObject; var Key: Char);
    procedure chkCaixaFechamentoDeCaixaClick(Sender: TObject);
  private
    FcCaixa: String;
    function ListaCaixasSelecionados(Lista: TCheckListBox): String;
    procedure SetCaixa(const Value: String);
    function getCaixasSelecionados: String;
  public
    procedure CarregarCaixas(AoTransaction: TIBTransaction);
    property Caixa: String read FcCaixa write SetCaixa;
    property CaixasSelecionados: String read getCaixasSelecionados;
  end;

implementation

{$R *.dfm}

uses
  ufuncoesfrente;

procedure TframeCampoCaixasRel.chklbCaixasClickCheck(Sender: TObject);
var
  cListaCaixas: String;
begin
  cListaCaixas := StringReplace(ListaCaixasSelecionados(chklbCaixas), #39, EmptyStr, [rfReplaceAll]);
  if cListaCaixas = EmptyStr then
    cListaCaixas := 'Todos';
  chkCaixaFechamentoDeCaixa.Caption := 'Caixas (' + cListaCaixas + '):'
end;

procedure TframeCampoCaixasRel.chklbCaixasKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    SelectNext(Sender as TWinControl, True, True);
end;

function TframeCampoCaixasRel.ListaCaixasSelecionados(Lista: TCheckListBox): String;
var
  i: Integer;
begin
  Result := EmptyStr;

  for i := 0 to Pred(Lista.Items.Count) do
  begin
    if Lista.Checked[i] then
    begin
      if Result <> EmptyStr then
        Result := Result + ', ';

      Result := Result + QuotedStr(LIsta.Items.Strings[i]);
    end;
  end;
end;

procedure TframeCampoCaixasRel.chkCaixaFechamentoDeCaixaClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Pred(chklbCaixas.Items.Count) do
    chklbCaixas.Checked[i] := chkCaixaFechamentoDeCaixa.Checked;

  chkCaixaFechamentoDeCaixa.Caption := 'Caixas (Todos):'
end;

procedure TframeCampoCaixasRel.CarregarCaixas(AoTransaction: TIBTransaction);
var
  QryCaixas: TIBQuery;
begin
  QryCaixas := CriaIBQuery(AoTransaction);
  try
    chklbCaixas.Clear;
    QryCaixas.Close;
    QryCaixas.SQL.Clear;
    QryCaixas.SQL.Add('select distinct CAIXA');
    QryCaixas.SQL.Add('from NFCE');
    QryCaixas.SQL.Add('where coalesce(CAIXA, '''') <> ''''');
    QryCaixas.SQL.Add('order by DATA DESC, CAIXA');
    QryCaixas.Open;

    while QryCaixas.Eof = False do
    begin
      chklbCaixas.Items.Add(QryCaixas.FieldByName('CAIXA').AsString);
      if FcCaixa <> EmptyStr then
      begin
        if chklbCaixas.Items.Strings[chklbCaixas.Items.Count -1] = FcCaixa then
          chklbCaixas.Checked[chklbCaixas.Items.Count -1] := True;
      end;

      QryCaixas.Next;
    end;
    chklbCaixasClickCheck(Self);
  finally
    FreeAndNil(QryCaixas);
  end;
end;

procedure TframeCampoCaixasRel.SetCaixa(const Value: String);
var
  i: Integer;
begin
  FcCaixa := Value;

  if chklbCaixas.Items.Count <= 0 then
    Exit;

  for i := 0 to Pred(chklbCaixas.Items.Count) do
    chklbCaixas.Checked[i] := (chklbCaixas.Items.Strings[i] = FcCaixa);

  chklbCaixasClickCheck(Self);    
end;

function TframeCampoCaixasRel.getCaixasSelecionados: String;
begin
  Result := StringReplace(ListaCaixasSelecionados(chklbCaixas), #39, EmptyStr, [rfReplaceAll]);
end;

end.
