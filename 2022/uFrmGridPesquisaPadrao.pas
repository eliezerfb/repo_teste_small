unit uFrmGridPesquisaPadrao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, DB, IBCustomDataSet, IBQuery, Grids, DBGrids,
  ComCtrls, StdCtrls, Buttons;

type
  TFrmGridPesquisaPadrao = class(TFrmPadrao)
    lblTitulo2: TLabel;
    lblTitulo1: TLabel;
    edPesquisa: TEdit;
    dtpFiltro: TDateTimePicker;
    dbGridPrincipal: TDBGrid;
    IBQPESQUISA: TIBQuery;
    DSPesquisa: TDataSource;
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    procedure dtpFiltroClick(Sender: TObject);
    procedure edPesquisaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbGridPrincipalDblClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dtpFiltroKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dtpFiltroCloseUp(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FIdSelecionado: String;
  protected
    procedure SelecionaPesquisa; virtual; abstract;
  end;

var
  FrmGridPesquisaPadrao: TFrmGridPesquisaPadrao;

implementation

uses Unit7;

{$R *.dfm}

procedure TFrmGridPesquisaPadrao.dtpFiltroClick(Sender: TObject);
begin
  Keybd_Event(VK_MENU,0,0,0);
  Keybd_Event(VK_DOWN,0,0,0);
  Keybd_Event(VK_DOWN,0,KEYEVENTF_KEYUP,0);
  Keybd_Event(VK_MENU,0,KEYEVENTF_KEYUP,0);
end;

procedure TFrmGridPesquisaPadrao.edPesquisaKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    SelecionaPesquisa;
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

procedure TFrmGridPesquisaPadrao.dbGridPrincipalDblClick(Sender: TObject);
begin
  inherited;
  btnOK.Click;
end;

procedure TFrmGridPesquisaPadrao.btnCancelarClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
  FIdSelecionado := '';
  Close;
end;

procedure TFrmGridPesquisaPadrao.btnOKClick(Sender: TObject);
begin
  inherited;
  if FIdSelecionado = '' then
    ModalResult := mrCancel
  else
    ModalResult := mrOk;
end;

procedure TFrmGridPesquisaPadrao.FormCreate(Sender: TObject);
begin
  inherited;
  dtpFiltro.Date := Date;
end;

procedure TFrmGridPesquisaPadrao.FormShow(Sender: TObject);
begin
  inherited;
  
  if edPesquisa.CanFocus then
  begin
    edPesquisa.SetFocus;
  end;

  SelecionaPesquisa;
end;

procedure TFrmGridPesquisaPadrao.dtpFiltroKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;

procedure TFrmGridPesquisaPadrao.dtpFiltroCloseUp(Sender: TObject);
begin
  inherited;
  
  SelecionaPesquisa;
end;

end.
