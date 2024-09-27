unit uFrmSaneamentoIMendes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmPadrao, Vcl.StdCtrls, Vcl.Buttons;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSaneamentoIMendes: TFrmSaneamentoIMendes;

implementation

{$R *.dfm}

procedure TFrmSaneamentoIMendes.btnOKClick(Sender: TObject);
begin
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

end.
