{
Unit para lançar informações referente a transação com cartão que serão
usada no intergrador fiscal do Ceará
Autor: Sandro Luis da Silva}

unit udadospos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, frame_teclado_1, StdCtrls, IniFiles, ComCtrls, Buttons,
  SmallFunc, _Small_59
  , uajustaresolucao;

type
  TFDadosPOS = class(TForm)
    Label2: TLabel;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TBitBtn;
    Panel2: TPanel;
    Frame_teclado1: TFrame_teclado;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    Edit4: TEdit;
    Label6: TLabel;
    Edit5: TEdit;
    BitBtn1: TBitBtn;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FDadosPOS: TFDadosPOS;

implementation

uses Unit2, fiscal, Unit15, _Small_IntegradorFiscal, umfe;

{$R *.dfm}

procedure TFDadosPOS.Button1Click(Sender: TObject);
begin
{Sandro Silva 2023-06-14 inicio
  if Form1.UsaIntegradorFiscal() then
  begin
    Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.idFila            := Form1.IntegradorCE.UltimoidPagamento;
    Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.CodigoAutorizacao := Edit1.Text;
    Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.Nsu               := Edit2.Text;
    Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.NumerodeAprovacao := Edit3.Text;
    Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.Bandeira          := Edit4.Text;
    Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.Adquirente        := Edit5.Text;
    Form1.sTransaca := Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.CodigoAutorizacao; // Sandro Silva 2018-10-22
  end;
  }
  ModalResult := mrOk;
end;

procedure TFDadosPOS.FormActivate(Sender: TObject);
begin
  //
  //
  FDadosPOS.Frame_teclado1.Led_FISCAL.Picture := Form1.Frame_teclado1.Led_FISCAL.Picture;
  FDadosPOS.Frame_teclado1.Led_FISCAL.Hint    := Form1.Frame_teclado1.Led_FISCAL.Hint;
  //
  FDadosPOS.Frame_teclado1.Led_ECF.Picture    := Form1.Frame_teclado1.Led_ECF.Picture;
  FDadosPOS.Frame_teclado1.Led_ECF.Hint       := Form1.Frame_teclado1.Led_ECF.Hint;
  //
  FDadosPOS.Frame_teclado1.Led_REDE.Picture   := Form1.Frame_teclado1.Led_REDE.Picture;
  FDadosPOS.Frame_teclado1.Led_REDE.Hint      := Form1.Frame_teclado1.Led_REDE.Hint;
  //
  if Edit1.CanFocus then
  begin
    Edit1.SetFocus;
  end;  
  //
end;

procedure TFDadosPOS.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;
  if Key = VK_UP then
  begin
    Perform(Wm_NextDlgCtl,-1,0);
  end;
  if Key = VK_DOWN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;

procedure TFDadosPOS.FormCreate(Sender: TObject);
begin
  FDadosPOS.Top    := Form1.Panel1.Top;
  FDadosPOS.Left   := Form1.Panel1.Left;
  FDadosPOS.Height := Form1.Panel1.Height;
  FDadosPOS.Width  := Form1.Panel1.Width;

  AjustaResolucao(FDadosPOS);
  AjustaResolucao(FDadosPOS.Frame_teclado1);
  Form1.Image7Click(Sender); // Sandro Silva 2016-08-18
end;

procedure TFDadosPOS.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TFDadosPOS.FormShow(Sender: TObject);
begin
  {Sandro Silva 2023-06-14 inicio
  if (Form1.UsaIntegradorFiscal()) then
  begin

    Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.idFila := Form1.IntegradorCE.UltimoidPagamento;
    if LimpaNumero(Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.CodigoAutorizacao) <> Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.CodigoAutorizacao then
      Edit1.Clear
    else
      Edit1.Text := Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.CodigoAutorizacao;
    if Trim(Edit1.Text) = '' then
      Edit1.Text := Form1.sAutoriza;
    Edit2.Text := Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.Nsu;
    if LimpaNumero(Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.NumerodeAprovacao) <> Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.NumerodeAprovacao then
      Edit3.Clear
    else
      Edit3.Text := Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.NumerodeAprovacao;
    Edit4.Text := Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.Bandeira;
    if Trim(Edit4.Text) = '' then
      Edit4.Text := Form1.sNomerede;
    Edit5.Text := Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.Adquirente;
    if Trim(Edit5.Text) = '' then
      Edit5.Text := Form1.sUltimaAdquirenteUsada;

  end;
  }
end;

end.
