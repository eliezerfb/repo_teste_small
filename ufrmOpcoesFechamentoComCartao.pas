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
  , uSmallConsts
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
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGOPCOESDblClick(Sender: TObject);
  private
    { Private declarations }
    procedure CarregaOpcoes;
    procedure AddOpcao(sTipo: String; sOpcao: String);
    procedure SelecionaOpcao;
  public
    { Public declarations }
    class function CriaForm(var TipoTransacao: TTipoTransacaoTefPos): Integer;
  end;

var
  FrmOpcoesFechamentoComCartao: TFrmOpcoesFechamentoComCartao;

implementation

{$R *.dfm}

uses Unit10
  , uTransacionaPosOuTef;

procedure TFrmOpcoesFechamentoComCartao.AddOpcao(sTipo, sOpcao: String);
begin
  try
    CDSOPCOES.Append;
    CDSOPCOES.FieldByName('TIPO').AsString  := sTipo;
    CDSOPCOES.FieldByName('OPCAO').AsString := sOpcao;
    CDSOPCOES.Post;
  except

  end;
end;

procedure TFrmOpcoesFechamentoComCartao.CarregaOpcoes;
var
  sSecoes: TStringList;
  Ini: TIniFile;
  //J: Integer;
  I: Integer;
begin
  sSecoes := TStringList.Create;
  Ini := TIniFile.Create(FRENTE_INI);

  Ini.ReadSections(sSecoes);

  //J := 0;

  for I := 0 to (sSecoes.Count - 1) do
  begin
    if AnsiUpperCase(Ini.ReadString(sSecoes[I], 'bAtivo', _cNao)) = AnsiUpperCase(_cSim) then
    begin
      AddOpcao(TIPO_TEF, sSecoes[I]);
      //J := J + 1;
    end;
  end;

  for I := 0 to (sSecoes.Count - 1) do
  begin
    if AnsiUpperCase(Ini.ReadString(sSecoes[I], 'CARTAO ACEITO', _cNao)) = AnsiUpperCase(_cSim) then
    begin
      AddOpcao(TIPO_POS, sSecoes[I]);
      //J := J + 1;
    end;
  end;

  FreeAndNil(sSecoes);
  Ini.Free;
end;

class function TFrmOpcoesFechamentoComCartao.CriaForm(var TipoTransacao: TTipoTransacaoTefPos): Integer;
begin
   TipoTransacao.Tipo := tpNone;
   Application.CreateForm(TFrmOpcoesFechamentoComCartao, FrmOpcoesFechamentoComCartao);
   FrmOpcoesFechamentoComCartao.ShowModal;
   Result := FrmOpcoesFechamentoComCartao.ModalResult;
   if Result = mrOk then
   begin
     TipoTransacao.Tipo := tpTEF;
     if FrmOpcoesFechamentoComCartao.CDSOPCOES.FieldByName('TIPO').AsString = TIPO_POS then
       TipoTransacao.Tipo := tpPOS;

     if TipoTransacao.Tipo = tpTEF then
     begin
       Form10.sNomeDoTEF := FrmOpcoesFechamentoComCartao.CDSOPCOES.FieldByName('OPCAO').AsString;
       AcionaTEF(Form10.sNomeDoTEF); // Form10.Acionatef;
     end;

//     if TipoTransacao.Tipo = tpPOS then
//       AplicaOpcaoPosEscolhida(FrmOpcoesFechamentoComCartao.CDSOPCOES.FieldByName('OPCAO').AsString);

     TipoTransacao.Descricao := FrmOpcoesFechamentoComCartao.CDSOPCOES.FieldByName('OPCAO').AsString;
   end;
   FreeAndNil(FrmOpcoesFechamentoComCartao);
end;

procedure TFrmOpcoesFechamentoComCartao.DBGOPCOESDblClick(Sender: TObject);
begin
  SelecionaOpcao;
end;

procedure TFrmOpcoesFechamentoComCartao.FormCreate(Sender: TObject);
begin
  ModalResult := mrNone;
  AjustaResolucao(FrmOpcoesFechamentoComCartao);
  CDSOPCOES.CreateDataSet;
  CDSOPCOES.Open;
  CarregaOpcoes;
  CDSOPCOES.First;

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

procedure TFrmOpcoesFechamentoComCartao.SelecionaOpcao;
begin
  ModalResult := mrOk;
end;

end.
