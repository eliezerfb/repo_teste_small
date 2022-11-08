unit uclientetef;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, frame_teclado_1, StdCtrls, IniFiles, ComCtrls, Buttons,
  SmallFunc, Grids, ufuncoesfrente
  , uajustaresolucao
  ;

type
  TFClienteTef = class(TForm)
    Button1: TBitBtn;
    Panel2: TPanel;
    Frame_teclado1: TFrame_teclado;
    sgClienteTef: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure CarregaGerenciadoresTef;
  public
    { Public declarations }
  end;

var
  FClienteTef: TFClienteTef;

implementation

uses fiscal, _Small_59;

{$R *.dfm}

procedure TFClienteTef.Button1Click(Sender: TObject);
begin
  //
  Close;
  //
end;

procedure TFClienteTef.Image6Click(Sender: TObject);
begin
  FClienteTef.Button1Click(Sender);
end;

procedure TFClienteTef.FormActivate(Sender: TObject);
begin
  //
  //
  FClienteTef.Frame_teclado1.Led_FISCAL.Picture := Form1.Frame_teclado1.Led_FISCAL.Picture;
  FClienteTef.Frame_teclado1.Led_FISCAL.Hint    := Form1.Frame_teclado1.Led_FISCAL.Hint;
  //
  FClienteTef.Frame_teclado1.Led_ECF.Picture := Form1.Frame_teclado1.Led_ECF.Picture;
  FClienteTef.Frame_teclado1.Led_ECF.Hint    := Form1.Frame_teclado1.Led_ECF.Hint;
  //
  FClienteTef.Frame_teclado1.Led_REDE.Picture := Form1.Frame_teclado1.Led_REDE.Picture;
  FClienteTef.Frame_teclado1.Led_REDE.Hint    := Form1.Frame_teclado1.Led_REDE.Hint;
  //
end;

procedure TFClienteTef.FormCreate(Sender: TObject);
begin

  FClienteTef.Top    := Form1.Panel1.Top;
  FClienteTef.Left   := Form1.Panel1.Left;
  FClienteTef.Height := Form1.Panel1.Height;
  FClienteTef.Width  := Form1.Panel1.Width;

  // Sandro Silva 2016-08-15  FClienteTef.Frame_teclado1.Image4.Picture := Form1.Frame_teclado1.Image4.Picture;
  AjustaResolucao(FClienteTef);
  AjustaResolucao(FClienteTef.Frame_teclado1);
  Form1.Image7Click(Sender); // Sandro Silva 2016-08-18

  CarregaGerenciadoresTef;  
end;

procedure TFClienteTef.CarregaGerenciadoresTef;
var
  iCol: Integer;
  procedure AddTef(Nome: String);
  begin
    sgClienteTef.RowCount := sgClienteTef.RowCount + 1;
    sgClienteTef.Cells[0, sgClienteTef.RowCount -1] := Nome;
    sgClienteTef.Cells[1, sgClienteTef.RowCount -1] := LerParametroIni(FRENTE_INI, Nome, 'Pasta', '');
    sgClienteTef.Cells[2, sgClienteTef.RowCount -1] := LerParametroIni(FRENTE_INI, Nome, 'Req', 'Req');
    sgClienteTef.Cells[3, sgClienteTef.RowCount -1] := LerParametroIni(FRENTE_INI, Nome, 'Resp', 'Resp');
    sgClienteTef.Cells[4, sgClienteTef.RowCount -1] := LerParametroIni(FRENTE_INI, Nome, 'Exec', '');
    sgClienteTef.Cells[5, sgClienteTef.RowCount -1] := LerParametroIni(FRENTE_INI, Nome, 'bAtivo', 'Sim');
  end;
begin
  sgClienteTef.RowCount := 1;

  sgClienteTef.Cells[0, sgClienteTef.RowCount -1] := 'Adquirente';
  sgClienteTef.Cells[1, sgClienteTef.RowCount -1] := 'Pasta';
  sgClienteTef.Cells[2, sgClienteTef.RowCount -1] := 'Pasta Req';
  sgClienteTef.Cells[3, sgClienteTef.RowCount -1] := 'Pasta Resp';
  sgClienteTef.Cells[4, sgClienteTef.RowCount -1] := 'Pasta Cliente';
  sgClienteTef.Cells[5, sgClienteTef.RowCount -1] := 'Ativo';

  AddTef('Sitef');
  AddTef('TEF Dial');
  AddTef('TEF Disc');
  AddTef('Disk TEF');
  AddTef('TEF CSHP');
  AddTef('Direcao');

  sgClienteTef.FixedRows := 1;
  sgClienteTef.FixedCols := 1;

  sgClienteTef.Font.Size := Button1.Font.Size;

  for iCol := 1 to sgClienteTef.ColCount - 1 do
  begin
    sgClienteTef.ColWidths[iCol] := AjustaLargura(sgClienteTef.ColWidths[iCol]);
  end;

end;

end.
