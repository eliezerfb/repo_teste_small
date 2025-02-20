unit uFrmSaneamentoIMendes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmPadrao, Vcl.StdCtrls, Vcl.Buttons,
  uDialogs, uSmallConsts;

type
  TFrmSaneamentoIMendes = class(TFrmPadrao)
    btnOK: TBitBtn;
    chkTodos: TCheckBox;
    chkPendentes: TCheckBox;
    chkAlterados: TCheckBox;
    chkNaoConsultados: TCheckBox;
    chkConsultados: TCheckBox;
    Label1: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure chkTodosClick(Sender: TObject);
    procedure chkPendentesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    sFiltro : string;
    bResult : boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

  function GetFiltroSaneamento(var sFiltro : string) : boolean;

var
  FrmSaneamentoIMendes: TFrmSaneamentoIMendes;

implementation

{$R *.dfm}

procedure TFrmSaneamentoIMendes.btnOKClick(Sender: TObject);
begin
  if not(chkAlterados.Checked)
    and not(chkPendentes.Checked)
    and not(chkConsultados.Checked)
    and not(chkNaoConsultados.Checked) then
  begin
    MensagemSistema('Selecione pelo menos uma opção!',msgAtencao);
    Exit;
  end;

  if not(chkTodos.Checked) then
  begin
    sFiltro := ' 1=2';

    if chkAlterados.Checked then
      sFiltro := sFiltro + ' or STATUS_TRIBUTACAO = '+QuotedStr(_cStatusImendesAlterado);

    if chkPendentes.Checked then
      sFiltro := sFiltro + ' or STATUS_TRIBUTACAO = '+QuotedStr(_cStatusImendesPendente);

    if chkConsultados.Checked then
      sFiltro := sFiltro + ' or STATUS_TRIBUTACAO = '+QuotedStr(_cStatusImendesConsultado);

    if chkNaoConsultados.Checked then
      sFiltro := sFiltro + ' or STATUS_TRIBUTACAO = '+QuotedStr(_cStatusImendesNaoConsultado);

    sFiltro := ' and ('+sFiltro+')';
  end;

  bResult := True;

  Close;
end;


procedure TFrmSaneamentoIMendes.chkPendentesClick(Sender: TObject);
begin
  try
    chkTodos.OnClick := nil;

    chkTodos.Checked := (chkAlterados.Checked)
      and (chkConsultados.Checked)
      and (chkNaoConsultados.Checked)
      and (chkPendentes.Checked);
  finally
    chkTodos.OnClick := chkTodosClick;
  end;

end;

procedure TFrmSaneamentoIMendes.chkTodosClick(Sender: TObject);
begin
  try
    chkAlterados.OnClick      := nil;
    chkConsultados.OnClick    := nil;
    chkNaoConsultados.OnClick := nil;
    chkPendentes.OnClick      := nil;

    chkAlterados.Checked      := chkTodos.Checked;
    chkConsultados.Checked    := chkTodos.Checked;
    chkNaoConsultados.Checked := chkTodos.Checked;
    chkPendentes.Checked      := chkTodos.Checked;
  finally
    chkAlterados.OnClick      := chkPendentesClick;
    chkConsultados.OnClick    := chkPendentesClick;
    chkNaoConsultados.OnClick := chkPendentesClick;
    chkPendentes.OnClick      := chkPendentesClick;
  end;
end;

procedure TFrmSaneamentoIMendes.FormCreate(Sender: TObject);
begin
  inherited;
  bResult := false;
end;

function GetFiltroSaneamento(var sFiltro : string) : boolean;
begin
  Result := False;

  try
    FrmSaneamentoIMendes := TFrmSaneamentoIMendes.Create(nil);
    FrmSaneamentoIMendes.ShowModal;
    sFiltro := FrmSaneamentoIMendes.sFiltro;
    Result := FrmSaneamentoIMendes.bResult;
  finally
    FreeAndNil(FrmSaneamentoIMendes);
  end;
end;

end.
