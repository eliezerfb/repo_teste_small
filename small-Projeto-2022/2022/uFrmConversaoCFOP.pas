unit uFrmConversaoCFOP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit;

type
  TFrmConversaoCFOP = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    Label129: TLabel;
    edtCFOPOrigem: TSMALL_DBEdit;
    Label1: TLabel;
    edtCFOPConversao: TSMALL_DBEdit;
    chkConsiderar: TDBCheckBox;
    lblCST: TLabel;
    lblCSOSN: TLabel;
    cboCST: TComboBox;
    cboCSOSN: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure DSCadastroDataChange(Sender: TObject; Field: TField);
    procedure edtCFOPOrigemKeyPress(Sender: TObject; var Key: Char);
    procedure edtCFOPConversaoKeyPress(Sender: TObject; var Key: Char);
    procedure btnOKClick(Sender: TObject);
    procedure cboCSTChange(Sender: TObject);
    procedure cboCSOSNChange(Sender: TObject);
    procedure chkConsiderarClick(Sender: TObject);
    procedure lblNovoClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
    procedure CarregaInfos;
    procedure CheckCONSIDERACSTCSOSN;
  public
    { Public declarations }
  end;

var
  FrmConversaoCFOP: TFrmConversaoCFOP;

implementation

{$R *.dfm}

uses unit7, smallfunc_xe, uDialogs;

procedure TFrmConversaoCFOP.btnOKClick(Sender: TObject);
begin
  //Valida Campos - se um tiver preenchido valida o outro
  if (Trim(Form7.ibdConversaoCFOPCFOP_CONVERSAO.AsString) <> '') or (Trim(Form7.ibdConversaoCFOPCFOP_ORIGEM.AsString) <> '') then
  begin
    if Length(Form7.ibdConversaoCFOPCFOP_ORIGEM.AsString) <> 4 then
    begin
      edtCFOPOrigem.SetFocus;
      Exit;
    end;

    if Length(Form7.ibdConversaoCFOPCFOP_CONVERSAO.AsString) <> 4 then
    begin
      edtCFOPConversao.SetFocus;
      Exit;
    end;
  end;

  if chkConsiderar.Checked then
  begin
    if (Trim(Form7.ibdConversaoCFOPCST.AsString) = '') and (Trim(Form7.ibdConversaoCFOPCSOSN.AsString) = '') then
    begin
      MensagemSistema('Pelo menos um dos campos a considerar deve ser preenchido!',msgAtencao);
      cboCST.SetFocus;
      Exit;
    end;
  end;

  inherited;
end;

procedure TFrmConversaoCFOP.cboCSOSNChange(Sender: TObject);
begin
  DSCadastro.DataSet.FieldByName('CSOSN').AsString := Trim(Copy(cboCSOSN.Items[cboCSOSN.ItemIndex]+'   ',1,3));
end;

procedure TFrmConversaoCFOP.cboCSTChange(Sender: TObject);
begin
  DSCadastro.DataSet.FieldByName('CST').AsString := Trim(Copy(cboCST.Items[cboCST.ItemIndex]+'  ',1,2));
end;

procedure TFrmConversaoCFOP.DSCadastroDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;

  if DSCadastro.DataSet.State in ([dsEdit, dsInsert]) then
    Exit;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;

  CarregaInfos;
end;

procedure TFrmConversaoCFOP.edtCFOPConversaoKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  ValidaValor(Sender,Key,'I');
end;

procedure TFrmConversaoCFOP.edtCFOPOrigemKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  ValidaValor(Sender,Key,'I');
end;

procedure TFrmConversaoCFOP.FormShow(Sender: TObject);
begin
  inherited;

  if edtCFOPOrigem.CanFocus then
    edtCFOPOrigem.SetFocus;
end;

function TFrmConversaoCFOP.GetPaginaAjuda: string;
begin
  Result := 'INDEX.HTM';
end;

procedure TFrmConversaoCFOP.lblNovoClick(Sender: TObject);
begin
  inherited;

  CarregaInfos;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmConversaoCFOP.SetaStatusUso;
begin
  inherited;

  edtCFOPOrigem.Enabled          := not(bEstaSendoUsado);
  chkConsiderar.Enabled          := not(bEstaSendoUsado);
  cboCST.Enabled                 := not(bEstaSendoUsado) and (chkConsiderar.Checked);
  cboCSOSN.Enabled               := not(bEstaSendoUsado) and (chkConsiderar.Checked);
  edtCFOPConversao.Enabled       := not(bEstaSendoUsado);
end;

procedure TFrmConversaoCFOP.CarregaInfos;
var
  I : integer;
begin
  cboCST.ItemIndex := -1;
  cboCSOSN.ItemIndex := -1;

  if not (DSCadastro.DataSet.State in ([dsEdit, dsInsert])) then
    DSCadastro.DataSet.Edit;

  //CST
  if AllTrim(Form7.ibdConversaoCFOPCST.AsString)<>'' then
  begin
    for I := 0 to cboCST.Items.Count -1 do
    begin
      if Copy(cboCST.Items[I],1,Length(Trim(Form7.ibdConversaoCFOPCST.AsString))) = UpperCase(AllTrim(Form7.ibdConversaoCFOPCST.AsString)) then
      begin
        cboCST.ItemIndex := I;
      end;
    end;
  end;

  //CSOSN
  if AllTrim(Form7.ibdConversaoCFOPCSOSN.AsString)<>'' then
  begin
    for I := 0 to cboCSOSN.Items.Count -1 do
    begin
      if Copy(cboCSOSN.Items[I],1,Length(Trim(Form7.ibdConversaoCFOPCSOSN.AsString))) = UpperCase(AllTrim(Form7.ibdConversaoCFOPCSOSN.AsString)) then
      begin
        cboCSOSN.ItemIndex := I;
      end;
    end;
  end;

  CheckCONSIDERACSTCSOSN;
end;


procedure TFrmConversaoCFOP.CheckCONSIDERACSTCSOSN;
begin
  cboCST.Enabled   := chkConsiderar.Checked;
  cboCSOSN.Enabled := chkConsiderar.Checked;

  lblCST.Enabled   := chkConsiderar.Checked;
  lblCSOSN.Enabled := chkConsiderar.Checked;
end;

procedure TFrmConversaoCFOP.chkConsiderarClick(Sender: TObject);
begin
  CheckCONSIDERACSTCSOSN;
end;

end.
