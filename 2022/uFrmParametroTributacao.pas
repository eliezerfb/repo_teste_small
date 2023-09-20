unit uFrmParametroTributacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmFichaPadrao, ComCtrls, StdCtrls, Buttons, ExtCtrls, Mask,
  DBCtrls, SMALL_DBEdit, DB;

type
  TFrmParametroTributacao = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    gbPisCofinsEntrada: TGroupBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label34: TLabel;
    SMALL_DBEdit37: TSMALL_DBEdit;
    Label51: TLabel;
    cboOrigem: TComboBox;
    Label36: TLabel;
    Label37: TLabel;
    cboCST: TComboBox;
    cboCSOSN: TComboBox;
    Label31: TLabel;
    SMALL_DBEdit31: TSMALL_DBEdit;
    Label2: TLabel;
    SMALL_DBEdit1: TSMALL_DBEdit;
    Label3: TLabel;
    procedure SMALL_DBEdit37KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmParametroTributacao: TFrmParametroTributacao;

implementation

uses
  Unit7
  , HtmlHelp
  ;

{$R *.dfm}

procedure TFrmParametroTributacao.SMALL_DBEdit37KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar(Form7.sAjuda)));
end;

end.
