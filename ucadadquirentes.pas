{Cadastrar adquirentes
Autor: Sandro Luis da Silva
}
unit ucadadquirentes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, frame_teclado_1, StdCtrls, IniFiles, ComCtrls, Buttons,
  SmallFunc_xe, Grids, DB, DBGrids, DBClient, MD5
  , uajustaresolucao;

const COLUNAGERENCIADORTEF   = 4;
const COLUNAADQUIRENTEATIVO  = 5;
const COLUNAADQUIRENTEPADRAO = 6;

type
  TFCadAdquirentes = class(TForm)
    Button1: TBitBtn;
    Panel2: TPanel;
    Frame_teclado1: TFrame_teclado;
    Label1: TLabel;
    CDSADQUIRENTES: TClientDataSet;
    DSADQUIRENTES: TDataSource;
    CDSADQUIRENTESADQUIRENTE: TStringField;
    CDSADQUIRENTESCHAVEREQUISICAO: TStringField;
    CDSADQUIRENTESIDESTABELECIMENTO: TStringField;
    CDSADQUIRENTESSERIALPOS: TStringField;
    CDSADQUIRENTESATIVO: TStringField;
    CDSADQUIRENTESPADRAO: TStringField;
    CDSADQUIRENTESEXCLUIR: TStringField;
    GRIDADQUIRENTES: TDBGrid;
    Label5: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Button2: TBitBtn;
    Label8: TLabel;
    CDSADQUIRENTESGERENCIADORTEF: TStringField;
    lbOrientacao: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CDSADQUIRENTESAfterInsert(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GRIDADQUIRENTESExit(Sender: TObject);
    procedure CDSADQUIRENTESBeforePost(DataSet: TDataSet);
    procedure CDSADQUIRENTESPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure Button2Click(Sender: TObject);
    procedure CDSADQUIRENTESPADRAOSetText(Sender: TField;
      const Text: String);
    procedure CDSADQUIRENTESATIVOSetText(Sender: TField;
      const Text: String);
    procedure CDSADQUIRENTESADQUIRENTESetText(Sender: TField;
      const Text: String);
    procedure GRIDADQUIRENTESKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GRIDADQUIRENTESKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GRIDADQUIRENTESColEnter(Sender: TObject);
    procedure GRIDADQUIRENTESDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure GRIDADQUIRENTESCellClick(Column: TColumn);
    procedure GRIDADQUIRENTESEnter(Sender: TObject);
    procedure CDSADQUIRENTESSERIALPOSSetText(Sender: TField;
      const Text: String);
  private
    { Private declarations }
    slSessions : TStringList;
    iniPOS: TIniFile;
    function SalvarAdquirente: Boolean;
    procedure DeletarRecord(Sender: TObject);
    procedure CarregarAdquirentes;
    procedure ExibeOrientacao(Sender: TObject);
    function GeraChaveRequisicaoIntegradorFiscal(
      sAdquirente: String; sNumeroPOS: String): String;

  public
    { Public declarations }
  end;

var
  FCadAdquirentes: TFCadAdquirentes;

implementation

uses fiscal, _Small_59, StrUtils, _Small_IntegradorFiscal, ufuncoesfrente;

{$R *.dfm}

procedure TFCadAdquirentes.Button1Click(Sender: TObject);
begin
  if SalvarAdquirente then
    Close;
end;

procedure TFCadAdquirentes.Image6Click(Sender: TObject);
begin
  Button1Click(Sender);
end;

procedure TFCadAdquirentes.FormActivate(Sender: TObject);
begin
  //
  //
  Frame_teclado1.Led_FISCAL.Picture := Form1.Frame_teclado1.Led_FISCAL.Picture;
  Frame_teclado1.Led_FISCAL.Hint    := Form1.Frame_teclado1.Led_FISCAL.Hint;
  //
  Frame_teclado1.Led_ECF.Picture    := Form1.Frame_teclado1.Led_ECF.Picture;
  Frame_teclado1.Led_ECF.Hint       := Form1.Frame_teclado1.Led_ECF.Hint;
  //
  Frame_teclado1.Led_REDE.Picture   := Form1.Frame_teclado1.Led_REDE.Picture;
  Frame_teclado1.Led_REDE.Hint      := Form1.Frame_teclado1.Led_REDE.Hint;
end;

procedure TFCadAdquirentes.FormCreate(Sender: TObject);
var
  iColuna: Integer;
  iLargura: Integer;
begin
  iniPOS     := TIniFile.Create(FRENTE_INI);
  slSessions := TStringList.Create;

  CDSADQUIRENTES.CreateDataSet;
  CDSADQUIRENTES.IndexDefs.Add('idxAdquirente', 'ADQUIRENTE', [ixUnique]);
  CDSADQUIRENTES.IndexName := 'idxAdquirente';

  Self.Top    := Form1.Panel1.Top;
  Self.Left   := Form1.Panel1.Left;
  Self.Height := Form1.Panel1.Height;
  Self.Width  := Form1.Panel1.Width;

  AjustaResolucao(FCadAdquirentes);
  AjustaResolucao(Frame_teclado1);
  Form1.Image7Click(Sender); // Sandro Silva 2016-08-18

  Button1.Left := (Self.Width - (Button1.Width + AjustaLargura(12) + Button2.Width)) div 2;
  Button2.Left := Button1.BoundsRect.Right + AjustaLargura(12);

  for iColuna := 0 to GRIDADQUIRENTES.Columns.Count -1 do
  begin
    GRIDADQUIRENTES.Columns[iColuna].Width := AjustaLargura(GRIDADQUIRENTES.Columns[iColuna].Width);
  end;

  iLargura := 0;
  for iColuna := 0 to GRIDADQUIRENTES.Columns.Count -1 do
  begin
    if iColuna = 0 then
    begin
      Label2.Left  := GRIDADQUIRENTES.Left + iLargura + AjustaLargura(3); // Sandro Silva 2021-09-21 GRIDADQUIRENTES.Left + iLargura + 3;
      Label2.Width := GRIDADQUIRENTES.Columns[iColuna].Width;
      iLargura := iLargura + GRIDADQUIRENTES.Columns[iColuna].Width;
    end;

    if iColuna = 1 then
    begin
      Label3.Left  := GRIDADQUIRENTES.Left + iLargura + AjustaLargura(4); // Sandro Silva 2021-09-21 GRIDADQUIRENTES.Left + iLargura + 4;
      Label3.Width := GRIDADQUIRENTES.Columns[iColuna].Width;
      iLargura := iLargura + GRIDADQUIRENTES.Columns[iColuna].Width;
    end;

    if iColuna = 2 then
    begin
      Label4.Left  := GRIDADQUIRENTES.Left + iLargura + AjustaLargura(5); // Sandro Silva 2021-09-21 GRIDADQUIRENTES.Left + iLargura + 5;
      Label4.Width := GRIDADQUIRENTES.Columns[iColuna].Width;
      iLargura := iLargura + GRIDADQUIRENTES.Columns[iColuna].Width;
    end;

    if iColuna = 3 then
    begin
      Label5.Left  := GRIDADQUIRENTES.Left + iLargura + AjustaLargura(6); // Sandro Silva 2021-09-21 GRIDADQUIRENTES.Left + iLargura + 6;
      Label5.Width := GRIDADQUIRENTES.Columns[iColuna].Width;
      iLargura := iLargura + GRIDADQUIRENTES.Columns[iColuna].Width;
    end;

    if iColuna = 4 then
    begin
      Label8.Left  := GRIDADQUIRENTES.Left + iLargura + AjustaLargura(6); // Sandro Silva 2021-09-21 GRIDADQUIRENTES.Left + iLargura + 6;
      Label8.Width := GRIDADQUIRENTES.Columns[iColuna].Width;
      iLargura := iLargura + GRIDADQUIRENTES.Columns[iColuna].Width;
    end;

    if iColuna = 5 then
    begin
      Label6.Left  := GRIDADQUIRENTES.Left + iLargura + AjustaLargura(6); // Sandro Silva 2021-09-21 GRIDADQUIRENTES.Left + iLargura + 6;
      Label6.Width := GRIDADQUIRENTES.Columns[iColuna].Width;
      iLargura := iLargura + GRIDADQUIRENTES.Columns[iColuna].Width;
    end;

    if iColuna = 6 then
    begin
      Label7.Left  := GRIDADQUIRENTES.Left + iLargura + AjustaLargura(6); // Sandro Silva 2021-09-21 GRIDADQUIRENTES.Left + iLargura + 6;
      Label7.Width := GRIDADQUIRENTES.Columns[iColuna].Width;
      iLargura := iLargura + GRIDADQUIRENTES.Columns[iColuna].Width;
    end;

  end;

end;

procedure TFCadAdquirentes.FormShow(Sender: TObject);
begin
  CarregarAdquirentes;

  GRIDADQUIRENTES.Font.Size := Button1.Font.Size;
  Frame_teclado1.Left := AjustaLargura(-12); // Sandro Silva 2021-09-21 AjustaLargura(-5);

  Label1.Left    := GRIDADQUIRENTES.Left + AjustaLargura(3); // Sandro Silva 2021-09-21 Label1.Left    := GRIDADQUIRENTES.Left + Form1.AjustaLargura(3);
  Label1.Caption := 'Cadastro de Adquirente';
end;

procedure TFCadAdquirentes.CDSADQUIRENTESAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('ATIVO').AsString   := 'Sim';
  DataSet.FieldByName('PADRAO').AsString  := 'Não';
  DataSet.FieldByName('EXCLUIR').ReadOnly := False;
  DataSet.FieldByName('EXCLUIR').AsString := 'X';
  DataSet.FieldByName('EXCLUIR').ReadOnly := True; // Não permite alterar depois de preenchido
end;

procedure TFCadAdquirentes.CarregarAdquirentes;
var
  iSecao: Integer;
  sNomeSecao: String;
begin
  CDSADQUIRENTES.EmptyDataSet;

  slSessions.Clear;
  iniPOS.ReadSections(slSessions); //Conta o número de itens

  GRIDADQUIRENTES.Columns[COLUNAADQUIRENTEATIVO].PickList.Clear;
  GRIDADQUIRENTES.Columns[COLUNAADQUIRENTEATIVO].PickList.Add('Não');
  GRIDADQUIRENTES.Columns[COLUNAADQUIRENTEATIVO].PickList.Add('Sim');

  GRIDADQUIRENTES.Columns[COLUNAADQUIRENTEPADRAO].PickList.Clear;
  GRIDADQUIRENTES.Columns[COLUNAADQUIRENTEPADRAO].PickList.Add('Não');
  GRIDADQUIRENTES.Columns[COLUNAADQUIRENTEPADRAO].PickList.Add('Sim');

  GRIDADQUIRENTES.Columns[COLUNAGERENCIADORTEF].PickList.Clear;
  GRIDADQUIRENTES.Columns[COLUNAGERENCIADORTEF].PickList.Add(' ');
  for iSecao := 0 to slSessions.Count - 1 do
  begin
    if iniPOS.ReadString(slSessions.Strings[iSecao], 'bAtivo', 'Não') = 'Sim' then
    begin
      GRIDADQUIRENTES.Columns[COLUNAGERENCIADORTEF].PickList.Add(slSessions.Strings[iSecao]);
    end;
  end;
  TStringList(GRIDADQUIRENTES.Columns[COLUNAGERENCIADORTEF].PickList).Sorted := True;

  for iSecao := 0 to slSessions.Count - 1 do
  begin
    if AnsiContainsText(slSessions.Strings[iSecao], 'ADQUIRENTE') then
    begin
      sNomeSecao := slSessions.Strings[iSecao];
      CDSADQUIRENTES.Append;
      CDSADQUIRENTES.FieldByName('ADQUIRENTE').AsString        := iniPOS.ReadString(sNomeSecao, 'Nome', '');
      CDSADQUIRENTES.FieldByName('CHAVEREQUISICAO').AsString   := iniPOS.ReadString(sNomeSecao, 'Chave Requisicao', '');
      CDSADQUIRENTES.FieldByName('IDESTABELECIMENTO').AsString := iniPOS.ReadString(sNomeSecao, 'Id Estabelecimento', '');
      CDSADQUIRENTES.FieldByName('SERIALPOS').AsString         := iniPOS.ReadString(sNomeSecao, 'Serial POS', '');
      CDSADQUIRENTES.FieldByName('ATIVO').AsString             := iniPOS.ReadString(sNomeSecao, 'POS Ativo', 'Sim');
      CDSADQUIRENTES.FieldByName('PADRAO').AsString            := iniPOS.ReadString(sNomeSecao, 'Padrao', 'Não');
      CDSADQUIRENTES.FieldByName('GERENCIADORTEF').AsString    := iniPOS.ReadString(sNomeSecao, 'Gerenciador TEF', '');
      CDSADQUIRENTES.Post;
    end;
  end;
  CDSADQUIRENTES.First;
end;

procedure TFCadAdquirentes.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  iniPOS1: TIniFile;
begin
  lbOrientacao.Visible := False;
  try
    iniPOS1     := TIniFile.Create(FRENTE_INI); // Sandro Silva 2017-06-01

    if QtdAdquirentes = 0 then
      iniPOS1.WriteString(SECAO_MFE, CHAVE_VENDA_NO_CARTAO, 'Não')
    else
      iniPOS1.WriteString(SECAO_MFE, CHAVE_VENDA_NO_CARTAO, 'Sim');
    Self.SendToBack;
    iniPOS1.Free;
  except
  end;
end;

function TFCadAdquirentes.SalvarAdquirente: Boolean;
var
  iSecao: Integer;
  sNomeSecao: String;
  iQtdPadrao: Integer;
  //sChaveRequisicao: String;
begin
  Result := False;
  slSessions.Clear;
  iniPOS.ReadSections(slSessions); //conta o número de itens

  for iSecao := 0 to slSessions.Count - 1 do
  begin
    if AnsiContainsText(slSessions.Strings[iSecao], 'ADQUIRENTE') then
    begin
      iniPOS.EraseSection(slSessions.Strings[iSecao]);
    end;
  end;

  iQtdPadrao := 0;
  CDSADQUIRENTES.First;
  while CDSADQUIRENTES.Eof = False do
  begin
    if AnsiUpperCase(CDSADQUIRENTES.FieldByName('PADRAO').AsString) = 'SIM' then
      Inc(iQtdPadrao);
    CDSADQUIRENTES.Next;
  end;

  if iQtdPadrao <= 1 then
  begin

    CDSADQUIRENTES.First;
    while CDSADQUIRENTES.Eof = False do
    begin
      if Trim(CDSADQUIRENTES.FieldByName('ADQUIRENTE').AsString) <> '' then
      begin
        sNomeSecao := 'ADQUIRENTE ' + IntToStr(CDSADQUIRENTES.RecNo);

        iniPOS.WriteString(sNomeSecao, 'Nome',               Trim(CDSADQUIRENTES.FieldByName('ADQUIRENTE').AsString));
        iniPOS.WriteString(SnomeSecao, 'Chave Requisicao',   Trim(CDSADQUIRENTES.FieldByName('CHAVEREQUISICAO').AsString));
        iniPOS.WriteString(SnomeSecao, 'Id Estabelecimento', Trim(CDSADQUIRENTES.FieldByName('IDESTABELECIMENTO').AsString));
        iniPOS.WriteString(SnomeSecao, 'Serial POS',         Trim(CDSADQUIRENTES.FieldByName('SERIALPOS').AsString));
        iniPOS.WriteString(SnomeSecao, 'POS Ativo',          IfThen(AnsiUpperCase(Trim(CDSADQUIRENTES.FieldByName('ATIVO').AsString)) = 'SIM', 'Sim', 'Não'));
        iniPOS.WriteString(SnomeSecao, 'Padrao',             IfThen(AnsiUpperCase(Trim(CDSADQUIRENTES.FieldByName('PADRAO').AsString)) = 'SIM', 'Sim', 'Não'));
        iniPOS.WriteString(SnomeSecao, 'Gerenciador TEF',    Trim(CDSADQUIRENTES.FieldByName('GERENCIADORTEF').AsString));
      end;
      CDSADQUIRENTES.Next;
    end;

    Result := True;
    
  end
  else
    ShowMessage('Defina apenas um padrão');
end;

procedure TFCadAdquirentes.GRIDADQUIRENTESExit(Sender: TObject);
begin
  if (Sender as TDBGrid).DataSource.DataSet.State in [dsEdit, dsInsert] then
    (Sender as TDBGrid).DataSource.DataSet.Post;
end;

procedure TFCadAdquirentes.CDSADQUIRENTESBeforePost(DataSet: TDataSet);
begin
  DataSet.FieldByName('ADQUIRENTE').AsString := AnsiUpperCase(DataSet.FieldByName('ADQUIRENTE').AsString);
end;

procedure TFCadAdquirentes.CDSADQUIRENTESPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
var
  sAlerta: String;
begin
  sAlerta := E.Message;
  if AnsiContainsText(E.Message, 'Key Violation') then
    sAlerta := 'Nome da Adquirente já existe';
  if AnsiContainsText(E.Message, 'must have a value') then
    sAlerta := 'Preencha todas as colunas';
  Application.MessageBox(PAnsiChar(sAlerta), 'Atenção', MB_ICONWARNING + MB_OK);
  Action := daAbort;
end;

procedure TFCadAdquirentes.Button2Click(Sender: TObject);
begin
  Close;
  //ModalResult := mrCancel;
end;

procedure TFCadAdquirentes.CDSADQUIRENTESPADRAOSetText(Sender: TField;
  const Text: String);
begin
  if AnsiUpperCase(Text) = 'SIM' then
    Sender.AsString := 'Sim'
  else
    Sender.AsString := 'Não';
end;

procedure TFCadAdquirentes.CDSADQUIRENTESATIVOSetText(Sender: TField;
  const Text: String);
begin
  if AnsiUpperCase(Text) = 'SIM' then
    Sender.AsString := 'Sim'
  else
    Sender.AsString := 'Não';
end;

procedure TFCadAdquirentes.CDSADQUIRENTESADQUIRENTESetText(Sender: TField;
  const Text: String);
begin
  Sender.Value := AnsiUpperCase(Text);
  if (Trim(Sender.Value) <> '') then
  begin // Gera guid da chave de requisição (cnpjemitente+)
    CDSADQUIRENTES.FieldByName('CHAVEREQUISICAO').AsString := GeraChaveRequisicaoIntegradorFiscal(Sender.Value, CDSADQUIRENTES.FieldByName('SERIALPOS').AsString);
  end;
end;

procedure TFCadAdquirentes.GRIDADQUIRENTESKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  I: Integer;
begin
  if Key = VK_RETURN then
  begin
    I := (Sender as TDbGrid).SelectedIndex;
    if ((Sender as TDbGrid).SelectedIndex + 1) < (Sender as TDbGrid).Columns.Count - 1 then
    begin
      (Sender as TDbGrid).SelectedIndex := (Sender as TDbGrid).SelectedIndex + 1;
      if I = (Sender as TDbGrid).SelectedIndex  then
      begin
        (Sender as TDbGrid).SelectedIndex := 0;
        (Sender as TDbGrid).DataSource.DataSet.Next;
        if (Sender as TDbGrid).DataSource.DataSet.EOF then
          (Sender as TDbGrid).DataSource.DataSet.Append;
      end;
    end
    else
    begin
      (Sender as TDbGrid).SelectedIndex := 0;
      (Sender as TDbGrid).DataSource.DataSet.Next;
      if (Sender as TDbGrid).DataSource.DataSet.EOF then
        (Sender as TDbGrid).DataSource.DataSet.Append;
    end;
  end;
end;

procedure TFCadAdquirentes.GRIDADQUIRENTESKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if ((Shift = [ssctrl]) and (Key = VK_Delete)) or ((Sender as TDbGrid).SelectedIndex = (Sender as TDbGrid).Columns.Count -1) then
  begin
    Key := 0;
    DeletarRecord(Sender);
  end;
end;

procedure TFCadAdquirentes.GRIDADQUIRENTESColEnter(Sender: TObject);
begin
  if (Sender as TDbGrid).SelectedIndex = (Sender as TDbGrid).Columns.Count -1 then
    DeletarRecord(Sender);

  if ((Sender as TDbGrid).SelectedIndex = COLUNAGERENCIADORTEF)
    or ((Sender as TDbGrid).SelectedIndex = COLUNAADQUIRENTEATIVO)
    or ((Sender as TDbGrid).SelectedIndex = COLUNAADQUIRENTEPADRAO)then
  begin
    keybd_event(VK_F2,0,0,0);
    keybd_event(VK_F2,0,KEYEVENTF_KEYUP,0);
    keybd_event(VK_MENU,0,0,0);
    keybd_event(VK_DOWN,0,0,0);
    keybd_event(VK_DOWN,0,KEYEVENTF_KEYUP,0);
    keybd_event(VK_MENU,0,KEYEVENTF_KEYUP,0);
  end;
  ExibeOrientacao(Sender);
end;

procedure TFCadAdquirentes.DeletarRecord(Sender: TObject);
begin
  if (Sender as TDbGrid).DataSource.DataSet.IsEmpty then
    Exit;
    
  if Application.MessageBox('Confirma a exclusão?', 'Atenção', MB_ICONWARNING + MB_YESNO + MB_DEFBUTTON2) = idYes then
    (Sender as TDbGrid).DataSource.DataSet.Delete;
  (Sender as TDbGrid).SelectedIndex := 0;
end;

procedure TFCadAdquirentes.GRIDADQUIRENTESDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  R: TRect;
begin
  with (Sender as TDbGrid) do
  begin
    if AnsiLowerCase(Column.FieldName) = 'EXCLUIR' then
    begin
      Canvas.FillRect(Rect);
      R := Rect;
      //InflateRect(R, -4, -4); //aqui manipula o tamanho do checkBox
      InflateRect(R, AjustaLargura(-4), AjustaAltura(-4)); //aqui manipula o tamanho do checkBox
      DrawFrameControl(Canvas.Handle, R, DFC_BUTTON, DFCS_CAPTIONCLOSE);
    end;
  end;
end;

procedure TFCadAdquirentes.GRIDADQUIRENTESCellClick(Column: TColumn);
begin
  if Column.FieldName = 'EXCLUIR' then
    DeletarRecord(GRIDADQUIRENTES);
end;

procedure TFCadAdquirentes.GRIDADQUIRENTESEnter(Sender: TObject);
begin
  ExibeOrientacao(Sender);
end;

procedure TFCadAdquirentes.ExibeOrientacao(Sender: TObject);
begin
  lbOrientacao.Caption := '';
  lbOrientacao.Font.Color := clRed;
  lbOrientacao.Visible := False;
  if (Sender as TDbGrid).Columns.Items[(Sender as TDbGrid).SelectedIndex].FieldName = 'ADQUIRENTE' then
    lbOrientacao.Caption := '* Informe o nome da Rede Adquirente contratada';
  if (Sender as TDbGrid).Columns.Items[(Sender as TDbGrid).SelectedIndex].FieldName = 'CHAVEREQUISICAO' then
    lbOrientacao.Caption := '* Chave gerada a partir do CNPJ do Estabelecimento + Nome Adquirente + Número Serial do POS' +
                            #13 + '"' + LimpaNumero(Form1.IBDataSet13.FieldByName('CGC').AsString) + '" + "' + CDSADQUIRENTES.FieldByName('ADQUIRENTE').AsString + '" + "' + CDSADQUIRENTES.FieldByName('SERIALPOS').AsString + '"' ; //'Informe o CNPJ da Rede Adquirente para gerar a chave';
  if (Sender as TDbGrid).Columns.Items[(Sender as TDbGrid).SelectedIndex].FieldName = 'IDESTABELECIMENTO' then
    lbOrientacao.Caption := '* Informe o ID do estabelecimento junto a Rede Adquirente contratada (Consulte a Rede Adquirente e solicite o "MerchantID")';
  if (Sender as TDbGrid).Columns.Items[(Sender as TDbGrid).SelectedIndex].FieldName = 'SERIALPOS' then
    lbOrientacao.Caption := '* Número Serial do equipamento que realizará a transação com cartão. Se estiver usando TEF informe o texto TEF';

  lbOrientacao.Visible := (Trim(lbOrientacao.Caption) <> '');
end;

function TFCadAdquirentes.GeraChaveRequisicaoIntegradorFiscal(
  sAdquirente: String; sNumeroPOS: String): String;
var
  sChaveRequisicao: String;
begin
  // Gera guid da chave de requisição (cnpjemitente+nome adquirente+número serial pos)
  sChaveRequisicao := MD5Print(MD5String(LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString) + Trim(sAdquirente) + Trim(sNumeroPOS)));
  sChaveRequisicao := AnsiUpperCase(sChaveRequisicao);
  sChaveRequisicao := Copy(sChaveRequisicao, 1, 8) + '-' + Copy(sChaveRequisicao, 9, 4) + '-' + Copy(sChaveRequisicao, 13, 4) + '-' + Copy(sChaveRequisicao, 17, 4) + '-' + Copy(sChaveRequisicao, 21, 12);
  Result := sChaveRequisicao;
end;


procedure TFCadAdquirentes.CDSADQUIRENTESSERIALPOSSetText(Sender: TField;
  const Text: String);
begin
  Sender.Value := AnsiUpperCase(Text);

  if (Trim(Sender.Value) <> '') then
  begin
    CDSADQUIRENTES.FieldByName('CHAVEREQUISICAO').AsString := GeraChaveRequisicaoIntegradorFiscal(CDSADQUIRENTES.FieldByName('ADQUIRENTE').AsString, Sender.Value);
  end;

end;

end.
