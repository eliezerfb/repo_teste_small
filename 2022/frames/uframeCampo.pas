unit uframeCampo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, IBDatabase, DB,
  IBCustomDataSet, IBQuery;

const ALIAS_CAMPO_PESQUISADO = 'NOME';

type
  TTipoPesquisa = (tpLocate, tpSelect);

type
  TfFrameCampo = class(TFrame)
    txtCampo: TEdit;
    gdRegistros: TDBGrid;
    DataSource: TDataSource;
    Query: TIBQuery;
    procedure txtCampoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure gdRegistrosDblClick(Sender: TObject);
    procedure gdRegistrosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtCampoChange(Sender: TObject);
    procedure txtCampoClick(Sender: TObject);
    procedure FrameExit(Sender: TObject);
    procedure txtCampoEnter(Sender: TObject);
  private
    FGravarSomenteTextoEncontrato: Boolean;
    FOnShow: TNotifyEvent;
    FTipoPesquisa: TTipoPesquisa;
    FFiltro: String;
    FTabela: String;
    FCampoVazioAbrirGridPesquisa: Boolean;
    FAutoSizeColunaNoGridDePesquisa: Boolean;
    procedure Pesquisar;
    function SelectPesquisa: String;
  public
    sCampoDescricao: String;
    //sTabela: String;
    CampoCodigo: TField;
    CampoCodigoPesquisa : string; // Mauricio Parizotto 2023-11-20 para caso em que tabela de origem o campo esteja com nome diferente
    CampoAuxExiber : string;
    property GravarSomenteTextoEncontrato: Boolean read FGravarSomenteTextoEncontrato write FGravarSomenteTextoEncontrato default True;
    property TipoDePesquisa: TTipoPesquisa read FTipoPesquisa write FTipoPesquisa;
    property sFiltro: String read FFiltro write FFiltro;
    property sTabela: String read FTabela write FTabela;
    property CampoVazioAbrirGridPesquisa: Boolean read FCampoVazioAbrirGridPesquisa write FCampoVazioAbrirGridPesquisa;
    property AutoSizeColunaNoGridDePesquisa: Boolean read FAutoSizeColunaNoGridDePesquisa write FAutoSizeColunaNoGridDePesquisa;
    constructor Create(AOwner: TComponent); override;
    procedure CarregaDescricao;

  end;

implementation

uses uFuncoesRetaguarda
    , uDialogs;

{$R *.dfm}

constructor TfFrameCampo.Create(AOwner: TComponent);
begin
  inherited;
  FGravarSomenteTextoEncontrato := True;
  //Mauricio Parizotto 2023-10-31
  FTipoPesquisa := tpLocate;
//  FTipoPesquisa := tpSelect;
  FCampoVazioAbrirGridPesquisa    := False;
  FAutoSizeColunaNoGridDePesquisa := False;
end;

procedure TfFrameCampo.Pesquisar;
begin
  Self.BringToFront;
  gdRegistros.Visible := True;
  Self.Height := txtCampo.Height + gdRegistros.Height + 5;
  case FTipoPesquisa of
    tpSelect:
    begin
      Query.Close;
      Query.SQL.Text := SelectPesquisa;   
      Query.Open;
    end;
  else
    Query.Locate(ALIAS_CAMPO_PESQUISADO, Trim(txtCampo.Text), [loCaseInsensitive, loPartialKey]);
  end;

end;

procedure TfFrameCampo.txtCampoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    gdRegistros.Visible := False;
    Self.Height := txtCampo.Height;

    PostMessage(GetParentForm(Self).Handle, wm_NextDlgCtl, Ord((ssShift in Shift)), 0);
    Key := 0;
  end;

  if (Key = VK_UP) or (Key = VK_DOWN) then
  begin
    PostMessage(GetParentForm(Self).Handle, wm_NextDlgCtl, Ord((ssShift in Shift)), 0);
    Key := 0;
  end;

  if Key = VK_ESCAPE then
  begin
    gdRegistros.Visible := False;
    Self.Height := txtCampo.Height;
  end;
end;

procedure TfFrameCampo.gdRegistrosDblClick(Sender: TObject);
begin
  txtCampo.Text     := Query.Fields[1].AsString;
  CampoCodigo.Value := Query.Fields[0].Value; // Sandro Silva 2023-09-26   CampoCodigo.AsInteger   := Query.Fields[0].AsInteger;

  gdRegistros.Visible := False;
  txtcampo.SetFocus;
  Self.Height := txtCampo.Height;

  Self.SendToBack;
end;

procedure TfFrameCampo.gdRegistrosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    gdRegistrosDblClick(gdRegistros);

  if Key = VK_ESCAPE then
  begin
    gdRegistros.Visible := False;
    Self.Height := txtCampo.Height;
    txtCampo.SetFocus;
  end;
end;

procedure TfFrameCampo.CarregaDescricao;
var
  CampoChange: TNotifyEvent;
  sNomeCampoChave: String;
begin
  if (Trim(FTabela) = '') then // and (Trim(FSQL) = '') then
  begin
    MensagemSistema('Informe o nome da tabela ou a instrução SQL para selecionar os dados', msgErro); // Precisa ser informado a tabela ou o SQL, senão causa erro
    Exit;
  end;

  //Mauricio Parizotto 2023-11-20
  //sNomeCampoChave := CampoCodigo.FieldName;
  sNomeCampoChave := CampoCodigoPesquisa;
  if sNomeCampoChave = '' then
    sNomeCampoChave := CampoCodigo.FieldName;

  //Mauricio Parizotto 2023-11-15
  txtCampo.Text := CampoCodigo.AsString;

  Query.Close;
  case FTipoPesquisa of
    tpSelect:
    begin
      Query.SQL.Text := SelectPesquisa;
    end
  else
    Query.SQL.Text := ' Select ' + sNomeCampoChave + ',' + sCampoDescricao + ' as ' + ALIAS_CAMPO_PESQUISADO +
                      ' From ' + FTabela +
                      ' Where 1=1 ' +
                      FFiltro +
                      ' Order by upper(' + sCampoDescricao + ')';
  end;
  Query.Open;

  if Query.Locate(sNomeCampoChave, Trim(CampoCodigo.AsString), [loCaseInsensitive, loPartialKey]) then
  begin
    CampoChange := txtCampo.onChange;
    txtCampo.onChange := nil;
    txtCampo.Text := Query.FieldByName(ALIAS_CAMPO_PESQUISADO).AsString;
    txtCampo.onChange := CampoChange;
  end else
  begin
    {Mauricio Parizotto 2023-1-20 Inicio}
    //txtCampo.Text := '';
    if FGravarSomenteTextoEncontrato then
      txtCampo.Text := '';
    {Mauricio Parizotto 2023-1-20 Fim}
  end;

end;

procedure TfFrameCampo.txtCampoChange(Sender: TObject);
begin
  // Sandro Silva 2023-09-29 if (txtCampo.Text <> '') and (txtCampo.Focused) then
  if (txtCampo.Focused) then
  begin
    Pesquisar;
  end;
end;

procedure TfFrameCampo.txtCampoClick(Sender: TObject);
begin
  Pesquisar;
end;

procedure TfFrameCampo.FrameExit(Sender: TObject);
begin
  {Sandro Silva 2023-09-27 inicio
  if Query.Locate('NOME', Trim(txtCampo.Text), [loCaseInsensitive, loPartialKey]) then
  begin
    txtCampo.Text           := Query.Fields[1].AsString;

    if CampoCodigo.AsInteger <> Query.Fields[0].AsInteger then
      CampoCodigo.AsInteger := Query.Fields[0].AsInteger;
  end else
  begin
    txtCampo.Clear;
    CampoCodigo.Value := null;
  end;
  }
  if Query.Locate(ALIAS_CAMPO_PESQUISADO, Trim(txtCampo.Text), [loCaseInsensitive, loPartialKey]) then
  begin
    if FGravarSomenteTextoEncontrato then
    begin
      txtCampo.Text := Query.Fields[1].AsString;

      if not (CampoCodigo.DataSet.State in [dsEdit]) then
        CampoCodigo.DataSet.Edit;

      if CampoCodigo.DataType in [ftSmallint, ftInteger, ftWord, ftLargeint] then
      begin
        if CampoCodigo.AsInteger <> Query.Fields[0].AsInteger then
          CampoCodigo.AsInteger := Query.Fields[0].AsInteger;
      end
      else
      begin
        if CampoCodigo.Value <> Query.Fields[0].Value then
          CampoCodigo.Value := Query.Fields[0].Value;
      end;
    end
    else
    begin
      if not (CampoCodigo.DataSet.State in [dsEdit]) then
        CampoCodigo.DataSet.Edit;
      CampoCodigo.Value := txtCampo.Text;
    end;
    {Sandro Silva 2023-09-28 fim}
  end else
  begin
    if FGravarSomenteTextoEncontrato then // Por exemplo, na OS, o campo IDENTIFI1 recebe texto livre ou que exista em outra OS.IDENTIFI1
    begin
      txtCampo.Clear;
      CampoCodigo.Value := null;
    end
    else
    begin
      CampoCodigo.Value := Trim(txtCampo.Text);
    end;
  end;
  {Sandro Silva 2023-09-27 fim}

  gdRegistros.Visible := False;
  Self.Height := txtCampo.Height;
  Self.SendToBack;
end;

procedure TfFrameCampo.txtCampoEnter(Sender: TObject);
begin
  if txtCampo.Text = '' then
  begin
    if FCampoVazioAbrirGridPesquisa then
      Pesquisar;
  end;

  if not (CampoCodigo.DataSet.State in ([dsEdit, dsInsert])) then
    CampoCodigo.DataSet.Edit;

  {Sandro Silva 2023-10-23 inicio}
  if FAutoSizeColunaNoGridDePesquisa then
  begin
    gdRegistros.Columns[0].Width := gdRegistros.Width - 20;
  end;
  {Sandro Silva 2023-10-23 fim}
end; 

function TfFrameCampo.SelectPesquisa: String;
var
  sNomeCampoChave: String;
begin
  //Mauricio Parizotto 2023-11-20
  sNomeCampoChave := CampoCodigoPesquisa;
  if sNomeCampoChave = '' then
    sNomeCampoChave := CampoCodigo.FieldName;

  Result :=
    //' Select distinct  ' + CampoCodigo.FieldName + ',' + sCampoDescricao + ' as ' + ALIAS_CAMPO_PESQUISADO + Mauricio Parizotto 2023-11-20
    ' Select distinct  ' + sNomeCampoChave + ',' + sCampoDescricao + ' as ' + ALIAS_CAMPO_PESQUISADO +
    CampoAuxExiber+// Mauricio Parizotto 2023-11-21
    ' From ' + FTabela +
    ' Where (upper(' + sCampoDescricao + ') like upper(' + QuotedStr('%' + txtCampo.Text + '%') + ')) ' +
    ' Order by upper(' + sCampoDescricao + ')';
end;

end.



