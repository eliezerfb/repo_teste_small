unit ufrmOpcoesFechamentoComCartao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids,
  Vcl.DBGrids
  , System.StrUtils
  , System.IniFiles
  , uajustaresolucao
  , ufuncoesfrente
  , uclassetransacaocartao
  , uSmallConsts, Vcl.ExtCtrls
  ;

const TIPO_TEF = 'TEF';
const TIPO_POS = 'POS';

type
  TFrmOpcoesFechamentoComCartao = class(TForm)
    DSOPCOES: TDataSource;
    DBGOPCOES: TDBGrid;
    CDSOPCOES: TClientDataSet;
    CDSOPCOESTIPO: TStringField;
    CDSOPCOESOPCAO: TStringField;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGOPCOESDblClick(Sender: TObject);
    procedure CDSOPCOESAfterScroll(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    class var iQtdPosTefDisponivel: Integer;
    class procedure CarregaOpcoes;
    class procedure AddOpcao(sTipo: String; sOpcao: String);
    procedure SelecionaOpcao;
  public
    { Public declarations }
    class function CriaForm(var TipoTransacao: TTipoTransacaoTefPos): Integer;
    class function QtdOpcoesTefPOSDisponiveis: Integer;
  end;

var
  FrmOpcoesFechamentoComCartao: TFrmOpcoesFechamentoComCartao;

implementation

{$R *.dfm}

uses Unit10
  , fiscal
  , uTransacionaPosOuTef
  , smallfunc_xe;

class procedure TFrmOpcoesFechamentoComCartao.AddOpcao(sTipo, sOpcao: String);
begin
  try
    if (FrmOpcoesFechamentoComCartao <> nil) then
    begin
      FrmOpcoesFechamentoComCartao.CDSOPCOES.Append;
      FrmOpcoesFechamentoComCartao.CDSOPCOES.FieldByName('TIPO').AsString  := sTipo;
      FrmOpcoesFechamentoComCartao.CDSOPCOES.FieldByName('OPCAO').AsString := sOpcao;
      FrmOpcoesFechamentoComCartao.CDSOPCOES.Post;
    end;
  except

  end;
end;

class procedure TFrmOpcoesFechamentoComCartao.CarregaOpcoes;
var
  sSecoes: TStringList;
  Ini: TIniFile;
  I: Integer;
begin
  iQtdPosTefDisponivel := 0;

  sSecoes := TStringList.Create;
  Ini := TIniFile.Create(FRENTE_INI);

  Ini.ReadSections(sSecoes);

  for I := 0 to (sSecoes.Count - 1) do
  begin
    if AnsiUpperCase(Ini.ReadString(sSecoes[I], 'bAtivo', _cNao)) = AnsiUpperCase(_cSim) then
    begin
      inc(iQtdPosTefDisponivel);
      AddOpcao(TIPO_TEF, sSecoes[I]);
    end;
  end;

  if Ini.ReadString(SECAO_FRENTE_CAIXA, CHAVE_HABILITAR_USO_POS, _cNao) = _cSim then
  begin
    for I := 0 to (sSecoes.Count - 1) do
    begin
      if AnsiUpperCase(Ini.ReadString(sSecoes[I], 'CARTAO ACEITO', _cNao)) = AnsiUpperCase(_cSim) then
      begin
        inc(iQtdPosTefDisponivel);
        AddOpcao(TIPO_POS, sSecoes[I]);
      end;
    end;
  end;

  FreeAndNil(sSecoes);
  Ini.Free;
end;

procedure TFrmOpcoesFechamentoComCartao.CDSOPCOESAfterScroll(DataSet: TDataSet);
begin
  ShowScrollBar(DBGOPCOES.Handle, SB_HORZ, False);
end;

class function TFrmOpcoesFechamentoComCartao.CriaForm(var TipoTransacao: TTipoTransacaoTefPos): Integer;
begin
   TipoTransacao.Tipo := tpNone;
   Application.CreateForm(TFrmOpcoesFechamentoComCartao, FrmOpcoesFechamentoComCartao);

   if FrmOpcoesFechamentoComCartao.CDSOPCOES.RecordCount = 1  then
   begin
     Result := mrOk;
   end
   else
   begin
     FrmOpcoesFechamentoComCartao.ShowModal;
     Result := FrmOpcoesFechamentoComCartao.ModalResult;
   end;

   if Result = mrOk then
   begin
     Form10.sNomeDoTEF := FrmOpcoesFechamentoComCartao.CDSOPCOES.FieldByName('OPCAO').AsString;

     TipoTransacao.Tipo := tpTEF;
     if FrmOpcoesFechamentoComCartao.CDSOPCOES.FieldByName('TIPO').AsString = TIPO_POS then
       TipoTransacao.Tipo := tpPOS;

     if TipoTransacao.Tipo = tpTEF then
     begin
       AcionaTEF(Form10.sNomeDoTEF);
     end;

     if TipoTransacao.Tipo = tpPOS then
     begin
       Form1.sNomeRedeTransacionada := Trim(StringReplace(StringReplace(AnsiUpperCase(ConverteAcentos(FrmOpcoesFechamentoComCartao.CDSOPCOES.FieldByName('OPCAO').AsString)), 'CREDITO', '', [rfReplaceAll]), 'DEBITO', '', [rfReplaceAll]));
     end;

     TipoTransacao.Descricao := FrmOpcoesFechamentoComCartao.CDSOPCOES.FieldByName('OPCAO').AsString;
   end
   else
   begin

   //se passar aqui result false, como fica o restante

     TipoTransacao.Tipo := tpNone;
   end;

   FreeAndNil(FrmOpcoesFechamentoComCartao);
end;

procedure TFrmOpcoesFechamentoComCartao.DBGOPCOESDblClick(Sender: TObject);
begin
  SelecionaOpcao;
end;

procedure TFrmOpcoesFechamentoComCartao.FormCreate(Sender: TObject);
begin
  DBGOPCOES.Options := DBGOPCOES.Options - [dgTitles, dgColLines, dgRowLines, dgColumnResize];
  ModalResult := mrNone;
  CDSOPCOES.CreateDataSet;
  CDSOPCOES.Open;
  CarregaOpcoes;
  CDSOPCOES.First;
  AjustaResolucao(FrmOpcoesFechamentoComCartao);
  Self.Height := AjustaAltura(Self.Height);
  Self.Width  := AjustaLargura(Self.Width);
  DBGOPCOES.Columns[0].Width := AjustaLargura(25);
  DBGOPCOES.Columns[1].Width := AjustaLargura(DBGOPCOES.Columns[1].Width);
  ShowScrollBar(DBGOPCOES.Handle, SB_HORZ, False);
end;

procedure TFrmOpcoesFechamentoComCartao.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;
  end;
  if Key = VK_RETURN then
    SelecionaOpcao;
end;

procedure TFrmOpcoesFechamentoComCartao.FormShow(Sender: TObject);
begin
  ShowScrollBar(DBGOPCOES.Handle, SB_HORZ, False);
  BringToFront;
end;

class function TFrmOpcoesFechamentoComCartao.QtdOpcoesTefPOSDisponiveis: Integer;
begin
  CarregaOpcoes;
  Result := iQtdPosTefDisponivel;
end;

procedure TFrmOpcoesFechamentoComCartao.SelecionaOpcao;
begin
  ModalResult := mrOk;
end;

end.
