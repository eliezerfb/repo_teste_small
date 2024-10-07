unit Unit21;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, Mask, smallfunc_xe,  WinTypes, WinProcs, Grids, DBGrids, DB, DBCtrls;


type
  TForm21 = class(TForm)
    Panel3: TPanel;
    Image1: TImage;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Button3: TButton;
    Button1: TButton;
    Button4: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
  public
  end;

var
  Form21: TForm21;

implementation

uses Unit7, uFrmAssistenteProcura, Mais, uSmallResourceString;

{$R *.DFM}

procedure TForm21.Button1Click(Sender: TObject);
begin
  Form7.ArquivoAberto.MoveBy(1);
  Form21.Activate;
end;

procedure TForm21.Button3Click(Sender: TObject);
begin
  Form7.ArquivoAberto.MoveBy(-1);
  Form21.Activate;
end;


procedure TForm21.Button2Click(Sender: TObject);
begin
  Form21.Close;
end;

procedure TForm21.FormActivate(Sender: TObject);
var
  I : Integer;
begin
  Form21.Image1.Picture := Form7.imgExcluir.Picture;

  Label11.Visible := False;
  Label12.Visible := False;
  Label13.Visible := False;
  Label14.Visible := False;
  Label15.Visible := False;
  Label16.Visible := False;
  Label17.Visible := False;

  Label11.Visible := False;
  Label12.Visible := False;
  Label13.Visible := False;
  Label14.Visible := False;
  Label15.Visible := False;
  Label16.Visible := False;
  Label17.Visible := False;

  Edit1.Visible := False;
  Edit2.Visible := False;
  Edit3.Visible := False;
  Edit4.Visible := False;
  Edit5.Visible := False;
  Edit6.Visible := False;
  Edit7.Visible := False;

  Label11.Caption := '';
  Label12.Caption := '';
  Label13.Caption := '';
  Label14.Caption := '';
  Label15.Caption := '';
  Label16.Caption := '';
  Label17.Caption := '';
  
  Button4.SetFocus;
  for I := 1 to Form7.iCampos do
  begin
    if I <= 7 then
    begin
      TLAbel(Form21.Components[I-1+LAbel11.ComponentIndex]).Caption := Form7.ArquivoAberto.fields[I-1].DisplayLabel;

      TLAbel(Form21.Components[I-1+LAbel11.ComponentIndex]).Visible := True;
      TEdit(Form21.Components[I-1+Edit1.ComponentIndex]).Visible    := True;

      //if Form7.ArquivoAberto.Fields[I-1].DataType = fTString then  Mauricio Parizotto 2023-07-26 Migração Alexandria
      if (Form7.ArquivoAberto.Fields[I-1].DataType = fTString) or (Form7.ArquivoAberto.Fields[I-1].DataType = ftWideString) then
        TEdit(Form21.Components[I-1+Edit1.ComponentIndex]).Text := Copy(Form7.ArquivoAberto.fields[I-1].AsString + replicate(' ',50),1,50);

      if Form7.ArquivoAberto.Fields[I-1].DataType = fTDate then
        TEdit(Form21.Components[I-1+Edit1.ComponentIndex]).Text  := Copy(Form7.ArquivoAberto.fields[I-1].AsString + replicate(' ',30),1,30);

      if TipoCampoFloat(Form7.ArquivoAberto.Fields[I-1]) then // Sandro Silva 2024-04-29 if Form7.ArquivoAberto.Fields[I-1].DataType = fTFloat then
        TEdit(Form21.Components[I-1+Edit1.ComponentIndex]).Text  := Copy(Format('%12.2n',[Form7.ArquivoAberto.fields[I-1].AsFloat])  + replicate(' ',30),1,30);

      //TEdit(Form21.Components[I-1+Edit1.ComponentIndex]).Width := (Form7.ArquivoAberto.Fields[I-1].Displaywidth * 8)+10; Mauricio Parizotto 2024-03-20
      TEdit(Form21.Components[I-1+Edit1.ComponentIndex]).Width := (Form7.ArquivoAberto.Fields[I-1].Displaywidth * 8)+40;

  //Mauricio Parizotto 2024-03-20
  //      if TEdit(Form21.Components[I-1+Edit1.ComponentIndex]).Width > 250 then
  //        TEdit(Form21.Components[I-1+Edit1.ComponentIndex]).Width := 250;
      if TEdit(Form21.Components[I-1+Edit1.ComponentIndex]).Width > 404 then
        TEdit(Form21.Components[I-1+Edit1.ComponentIndex]).Width := 404;
    end;
  end;
end;

procedure TForm21.Button4Click(Sender: TObject);
var
  bButton: Integer;
begin
  {----------------------------------------------}
  {Mensagem esperta, que retorna o valor do botão}
  {----------------------------------------------}
  if ((Form7.sModulo <> 'VENDA') and (Form7.sModulo = 'ORCAMENTO')) then
    bButton := Application.MessageBox(PChar(_cMensagemExcluir), PChar(_cTituloMsg), MB_ICONQUESTION + MB_OKCANCEL + MB_DEFBUTTON1)
  else
    bButton := IDOK;

  if bButton = IDOK then
  begin
    try
      Form7.ArquivoAberto.Delete;
      Form21.Activate;
      Button2.SetFocus;
    except end;
  end;  
end;

end.

