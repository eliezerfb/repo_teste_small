unit uFrmInformacoesRastreamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, StrUtils, DBCtrls, ExtCtrls, Buttons
  ;

const COR_CAMPO_OBRIGATORIO = $0080FFFF;  

type
  TFrmInformacoesRastreamento = class(TForm)
    Button1: TBitBtn;
    Label1: TLabel;
    edNumeroLote: TEdit;
    Label2: TLabel;
    edQuantidade: TMaskEdit;
    Label3: TLabel;
    edDtFabricacao: TMaskEdit;
    Label4: TLabel;
    edDtValidade: TMaskEdit;
    Label5: TLabel;
    edCodigoAgregacao: TEdit;
    Button2: TBitBtn;
    lbLegenda: TLabel;
    lbQuantidadeNaNota: TLabel;
    lbAcumulado: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FocusNextControl(Sender: TObject; var Key: Char);
    procedure edQuantidadeExit(Sender: TObject);
    procedure edQuantidadeKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure edNumeroLoteChange(Sender: TObject);
    procedure edQuantidadeChange(Sender: TObject);
    procedure edDtFabricacaoChange(Sender: TObject);
    procedure edDtValidadeChange(Sender: TObject);
  private
    { Private declarations }
    procedure ValidaCampoPreenchido(Campo: TCustomEdit);
  public
    { Public declarations }
    procedure LimpaCampos;
  end;

var
  FrmInformacoesRastreamento: TFrmInformacoesRastreamento;

implementation

{$R *.dfm}

procedure ValidaAceitaApenasUmaVirgula(edit: TEdit; var Key: Char); overload;
var
  vTextSelecionado: string;
begin
  vTextSelecionado := Copy(edit.Text, edit.SelStart + 1, edit.SelLength);
                          //ContainsStr xe6
  If (key = ',') and not (AnsiContainsText(vTextSelecionado, ',')) then //Se tiver com virgula selecionada vai substituir, logo, pode usar virgula
    If AnsiContainsStr(edit.Text,',') then
      key := #0;
end;

procedure ValidaAceitaApenasUmaVirgula(edit: TDBEdit; var Key: Char); overload;
var
  vTextSelecionado: string;
begin
  vTextSelecionado := Copy(edit.Text, edit.SelStart + 1, edit.SelLength);
                          //ContainsStr xe6
  If (key = ',') and not (AnsiContainsText(vTextSelecionado, ',')) then //Se tiver com virgula selecionada vai substituir, logo, pode usar virgula
    If AnsiContainsStr(edit.Text,',') then
      key := #0;
end;

procedure ValidaAceitaApenasUmaVirgula(edit: TMaskEdit; var Key: Char); overload;
var
  vTextSelecionado: string;
begin
  vTextSelecionado := Copy(edit.Text, edit.SelStart + 1, edit.SelLength);
                          //ContainsStr xe6
  If (key = ',') and not (AnsiContainsText(vTextSelecionado, ',')) then //Se tiver com virgula selecionada vai substituir, logo, pode usar virgula
    If AnsiContainsStr(edit.Text,',') then
      key := #0;
end;

procedure ValidaAceitaApenasUmaVirgula(edit: TLabeledEdit; var Key: Char); overload;
var
  vTextSelecionado: string;
begin
  vTextSelecionado := Copy(edit.Text, edit.SelStart + 1, edit.SelLength);
                          //ContainsStr xe6
  If (key = ',') and not (AnsiContainsText(vTextSelecionado, ',')) then //Se tiver com virgula selecionada vai substituir, logo, pode usar virgula
    If AnsiContainsStr(edit.Text,',') then
      key := #0;
end;

// Valida o valor informado
procedure ValidaValor(Sender: TObject; var Key: Char; tipo: string);
begin
  {If (key = #13) then
  begin
     SelectNext((Sender as TwinControl),true,true);
     key := #0;
  end;}

  if Tipo = 'L' then
  begin
     //If not CharInSet(key, ['A'..'Z',#8, ' ']) then
     if not (Key in ['A'..'Z',#8, ' ']) then
       Key := #0;
  end;

  //Inteiro
  if Tipo = 'I' then
  begin
     //if not CharInSet(key,['0'..'9',#8]) then
     if not (key in ['0'..'9',#8]) then
        Key := #0;

     //if CharInSet(Key ,['E','e']) then
     if (Key in ['E','e']) then
      Key := #0;
  end;

  //Float
  if Tipo = 'F' then
  begin
     //if not CharInSet(key,['0'..'9',#8,',']) then
     if not (Key in ['0'..'9',#8,',']) then
        Key := #0;

     //if CharInSet(Key ,['E','e']) then
     if (Key in ['E','e']) then
      Key := #0;

     if Sender is TDBEdit then
      ValidaAceitaApenasUmaVirgula(TDBEdit(Sender),Key);

    if Sender is TEdit then
      ValidaAceitaApenasUmaVirgula(TEdit(Sender),Key);

    if Sender is TLabeledEdit then
      ValidaAceitaApenasUmaVirgula(TLabeledEdit(Sender),Key);

    if Sender is TMaskEdit then
      ValidaAceitaApenasUmaVirgula(TMaskEdit(Sender),Key);

  end;

  if Tipo = 'A' then
  begin
     //if not CharInSet(Key ,['A'..'Z','0'..'9',#8, ' ', ',', '.', '^', '~', '´', '`', '/', '?', '°', ';', ':', '<', '>',
     //                 '[', ']', '\', '|', '{', '}', '+', '=', '-', '_', '(', ')', '*', '&', '"', '%', '$', '#', '@', '!']) then
     if not (Key in ['A'..'Z','0'..'9',#8, ' ', ',', '.', '^', '~', '´', '`', '/', '?', '°', ';', ':', '<', '>',
                      '[', ']', '\', '|', '{', '}', '+', '=', '-', '_', '(', ')', '*', '&', '"', '%', '$', '#', '@', '!']) then
       Key := #0;
  end;
  
end;

procedure TFrmInformacoesRastreamento.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmInformacoesRastreamento.Button1Click(Sender: TObject);
begin

  if Trim(edNumeroLote.Text) = '' then
  begin
    ShowMessage('Informe o Número do lote');
    edQuantidade.SetFocus;
    Exit;
  end;

  if StrToFloatDef(edQuantidade.Text, 0) <= 0 then
  begin
    ShowMessage('Informe a Quantidade no lote');
    edQuantidade.SetFocus;
    Exit;
  end;

  if StrToDateDef(edDtFabricacao.Text, StrToDate('30/12/1899')) = StrToDate('30/12/1899') then
  begin
    ShowMessage('Informe a Data de Fabricação válida');
    edDtFabricacao.SetFocus;
    Exit;
  end;

  if StrToDateDef(edDtValidade.Text, StrToDate('30/12/1899')) = StrToDate('30/12/1899') then
  begin
    ShowMessage('Informe a Data de Validade válida');
    edDtValidade.SetFocus;
    Exit;
  end;   

  ModalResult := mrOk;
end;

procedure TFrmInformacoesRastreamento.FocusNextControl(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    SelectNext(Sender as TWinControl, True, True);
    Key := #0;
  end;
end;

procedure TFrmInformacoesRastreamento.edQuantidadeExit(Sender: TObject);
begin
  if Trim(edQuantidade.Text) <> '' then
  begin
    if StrToFloatDef(edQuantidade.Text, 0) <= 0 then
    begin
      ShowMessage('Informe a Quantidade no lote');
      edQuantidade.SetFocus;
      Exit;
    end;
    edQuantidade.Text := FloatToStr(StrToFloatDef(edQuantidade.Text, 0));
  end;

  if edQuantidade.Text = '' then
    edQuantidade.Color := COR_CAMPO_OBRIGATORIO
  else
    edQuantidade.Color := clWindow;

end;

procedure TFrmInformacoesRastreamento.edQuantidadeKeyPress(Sender: TObject;
  var Key: Char);
begin
  FocusNextControl(Sender, Key);
  ValidaValor(Sender, Key, 'F');
end;

procedure TFrmInformacoesRastreamento.FormCreate(Sender: TObject);
begin
  LimpaCampos;
end;

procedure TFrmInformacoesRastreamento.LimpaCampos;
begin
  edNumeroLote.Clear;
  edQuantidade.Clear;
  edDtFabricacao.Clear;
  edDtValidade.Clear;
  edCodigoAgregacao.Clear;
  edNumeroLote.Color   := COR_CAMPO_OBRIGATORIO;
  edQuantidade.Color   := COR_CAMPO_OBRIGATORIO;
  edDtFabricacao.Color := COR_CAMPO_OBRIGATORIO;
  edDtValidade.Color   := COR_CAMPO_OBRIGATORIO;
  lbLegenda.Color      := COR_CAMPO_OBRIGATORIO;
end;

procedure TFrmInformacoesRastreamento.ValidaCampoPreenchido(
  Campo: TCustomEdit);
begin
  if Campo.Text = '' then
    TEdit(Campo).Color := COR_CAMPO_OBRIGATORIO
  else
    TEdit(Campo).Color := clWindow;
end;

procedure TFrmInformacoesRastreamento.edNumeroLoteChange(Sender: TObject);
begin
  ValidaCampoPreenchido(TCustomEdit(Sender));
end;

procedure TFrmInformacoesRastreamento.edQuantidadeChange(Sender: TObject);
begin
  ValidaCampoPreenchido(TCustomEdit(Sender));
end;

procedure TFrmInformacoesRastreamento.edDtFabricacaoChange(
  Sender: TObject);
begin
  ValidaCampoPreenchido(TCustomEdit(Sender));
end;

procedure TFrmInformacoesRastreamento.edDtValidadeChange(Sender: TObject);
begin
  ValidaCampoPreenchido(TCustomEdit(Sender));
end;

end.
