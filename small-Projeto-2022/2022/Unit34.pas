unit Unit34;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mask, smallfunc_xe, DBCtrls, SMALL_DBEdit;

type
  TForm34 = class(TForm)
    Panel2: TPanel;
    Image1: TImage;
    Label1: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Label2: TLabel;
    Label3: TLabel;
    SMALL_DBEdit1: TSMALL_DBEdit;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button4: TButton;
    Button2: TButton;
    procedure SMALL_DBEdit1Change(Sender: TObject);
    procedure SMALL_DBEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form34: TForm34;

implementation

uses Unit7, Mais;

{$R *.DFM}





procedure TForm34.Button2Click(Sender: TObject);
begin
  Form34.Close;
end;




procedure TForm34.Button4Click(Sender: TObject);
begin
  Button4.Visible := False;
  try
    //
    if StrToFloat(LimpaNumeroDeixandoAVirgula(SMALL_DBEdit1.Text)) <> 0 then
    begin
      //
      Form7.ibDataSet4.First;
      RadioButton1.visible := False;
      RadioButton2.visible := False;
      RadioButton3.visible := False;
      SMALL_DBEdit1.Visible   := False;
      //
      Button5.Visible := True;
      Button6.Visible := True;
      Button7.Visible := True;
      //
      Label3.Top  := 60;
      Label2.Top  := 80;
      Label1.Top  := 100;
      //
      if RadioButton1.Checked = True then
      begin
        while not (Form7.ibDataSet4.EOF) and (Form7.ibDataSet4PRECO.Asfloat = 0) do Form7.ibDataSet4.Next;
        Label3.Caption := Form7.ibDataSet4DESCRICAO.AsString;
        Label2.Caption := 'Preço velho: ' + Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet4PRECO.AsFloat]);
        Label1.Caption := 'Preço novo:  ' + Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet4PRECO.AsFloat *  (1+(StrToFloat(LimpaNumeroDeixandoAVirgula(SMALL_DBEdit1.Text)) / 100))]);
      end;
      if RadioButton2.Checked = True then
      begin
        while not (Form7.ibDataSet4.EOF) and (Form7.ibDataSet4CUSTOCOMPR.Asfloat = 0) do Form7.ibDataSet4.Next;
        Label3.Caption := Form7.ibDataSet4DESCRICAO.AsString;
        Label2.Caption := 'Preço velho: ' + Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet4PRECO.AsFloat]);
        Label1.Caption := 'Preço novo:  ' + Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet4CUSTOCOMPR.AsFloat *  (1+(StrToFloat(LimpaNumeroDeixandoAVirgula(SMALL_DBEdit1.Text)) / 100))]);
      end;
      if RadioButton3.Checked = True then
      begin
        Form7.ibDataSet4.DisableControls;
        while not (Form7.ibDataSet4.EOF) and (Form7.ibDataSet4INDEXADOR.Asfloat = 0) do Form7.ibDataSet4.Next;
        Form7.ibDataSet4.EnableControls;
        if Form7.ibDataSet4INDEXADOR.Asfloat > 0 then
        begin
          Label3.Caption := Form7.ibDataSet4DESCRICAO.AsString;
          Label2.Caption := 'Preço velho: ' + Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet4PRECO.AsFloat]);
          Label1.Caption := 'Preço novo:  ' + Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet4INDEXADOR.AsFloat * StrToFloat(LimpaNumeroDeixandoAVirgula(SMALL_DBEdit1.Text))]);
        end else
        begin
          ShowMessage('Não existem produtos indexados por US$.');
          close;
        end;
      end;
      Label3.Visible := True;
    end;
    //
    if Button5.CanFocus then Button5.SetFocus;
    //
  except end;
  //
end;









procedure TForm34.Button7Click(Sender: TObject);
begin
  Button2.Enabled := False;
  Button5.Enabled := False;
  Button6.Enabled := False;
  Button7.Enabled := False;
  //
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  Form7.ibDataSet4.DisableControls;
  while not Form7.ibDataSet4.Eof do
  begin
    if RadioButton1.Checked = True then
    begin
      try
        Form7.ibDataSet4.Edit;
        Form7.ibDataSet4PRECO.AsFloat := Arredonda(Form7.ibDataSet4PRECO.AsFloat *  (1+(StrToFloat(LimpaNumeroDeixandoAVirgula(SMALL_DBEdit1.Text)) / 100)),StrToInt(Form1.ConfPreco));
        Form7.ibDataSet4.Post;
      except end;
    end;
    if RadioButton2.Checked = True then
    begin
      try
        Form7.ibDataSet4.Edit;
        Form7.ibDataSet4PRECO.AsFloat := Arredonda(Form7.ibDataSet4CUSTOCOMPR.AsFloat *  (1+(StrToFloat(LimpaNumeroDeixandoAVirgula(SMALL_DBEdit1.Text)) / 100)),StrToInt(Form1.ConfPreco));
        Form7.ibDataSet4.Post;
      except end;
    end;
    if RadioButton3.Checked = True then
    begin
      try
        Form7.ibDataSet4.Edit;
        Form7.ibDataSet4PRECO.AsFloat := Arredonda(Form7.ibDataSet4INDEXADOR.AsFloat * StrToFloat(LimpaNumeroDeixandoAVirgula(SMALL_DBEdit1.Text)),StrToInt(Form1.ConfPreco));
        Form7.ibDataSet4.Post;
      except end;
    end;
    Form7.ibDataSet4.Next;
  end;
  //
  Form7.ibDataSet4.EnableControls;
  Screen.Cursor := crDefault;
  Form34.Close;
  //
end;

procedure TForm34.Button6Click(Sender: TObject);
begin
  if RadioButton1.Checked = True then
  begin
    try
      Form7.ibDataSet4.Next;
      while not (Form7.ibDataSet4.EOF) and (Form7.ibDataSet4PRECO.Asfloat = 0) do Form7.ibDataSet4.Next;
      Label3.Caption := Form7.ibDataSet4DESCRICAO.AsString;
      Label2.Caption := 'Preço velho: ' + Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet4PRECO.AsFloat]);
      Label1.Caption := 'Preço novo:  ' + Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet4PRECO.AsFloat *  (1+(StrToFloat(LimpaNumeroDeixandoAVirgula(SMALL_DBEdit1.Text)) / 100))]);
      if Form7.ibDataSet4.EOF then Close;
    except end;
  end;
  if RadioButton2.Checked = True then
  begin
    try
      Form7.ibDataSet4.Next;
      while not (Form7.ibDataSet4.EOF) and (Form7.ibDataSet4CUSTOCOMPR.Asfloat = 0) do Form7.ibDataSet4.Next;
      Label3.Caption := Form7.ibDataSet4DESCRICAO.AsString;
      Label2.Caption := 'Preço velho: ' + Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet4PRECO.AsFloat]);
      Label1.Caption := 'Preço novo:  ' + Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet4CUSTOCOMPR.AsFloat *  (1+(StrToFloat(LimpaNumeroDeixandoAVirgula(SMALL_DBEdit1.Text)) / 100))]);
      if Form7.ibDataSet4.EOF then Close;
    except end;
  end;
  if RadioButton3.Checked = True then
  begin
    try
      Form7.ibDataSet4.Next;
      while not (Form7.ibDataSet4.EOF) and (Form7.ibDataSet4INDEXADOR.Asfloat = 0) do Form7.ibDataSet4.Next;
      Label3.Caption := Form7.ibDataSet4DESCRICAO.AsString;
      Label2.Caption := 'Preço velho: ' + Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet4PRECO.AsFloat]);
      Label1.Caption := 'Preço novo:  ' + Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet4INDEXADOR.AsFloat * StrToFloat(LimpaNumeroDeixandoAVirgula(SMALL_DBEdit1.Text))]);
      if Form7.ibDataSet4.EOF then Close;
    except end;
  end;
end;

procedure TForm34.Button5Click(Sender: TObject);
begin
  if RadioButton1.Checked = True then
  begin
    try
      Form7.ibDataSet4.Edit;
      Form7.ibDataSet4PRECO.AsFloat := Arredonda(Form7.ibDataSet4PRECO.AsFloat *  (1+(StrToFloat(LimpaNumeroDeixandoAVirgula(SMALL_DBEdit1.Text)) / 100)),StrToInt(Form1.ConfPreco));
      Form7.ibDataSet4.Post;
      Form7.ibDataSet4.Next;
      while not (Form7.ibDataSet4.EOF) and (Form7.ibDataSet4PRECO.Asfloat = 0) do Form7.ibDataSet4.Next;
      Label3.Caption := Form7.ibDataSet4DESCRICAO.AsString;
      Label2.Caption := 'Preço velho: ' + Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet4PRECO.AsFloat]);
      Label1.Caption := 'Preço novo:  ' + Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet4PRECO.AsFloat *  (1+(StrToFloat(LimpaNumeroDeixandoAVirgula(SMALL_DBEdit1.Text)) / 100))]);
      if Form7.ibDataSet4.EOF then Close;
    except end;
  end;
  if RadioButton2.Checked = True then
  begin
    try
      Form7.ibDataSet4.Edit;
      Form7.ibDataSet4PRECO.AsFloat := Arredonda(Form7.ibDataSet4CUSTOCOMPR.AsFloat *  (1+(StrToFloat(LimpaNumeroDeixandoAVirgula(SMALL_DBEdit1.Text)) / 100)),StrToInt(Form1.ConfPreco));
      Form7.ibDataSet4.Post;
      Form7.ibDataSet4.Next;
      while not (Form7.ibDataSet4.EOF) and (Form7.ibDataSet4CUSTOCOMPR.Asfloat = 0) do Form7.ibDataSet4.Next;
      Label3.Caption := Form7.ibDataSet4DESCRICAO.AsString;
      Label2.Caption := 'Preço velho: ' + Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet4PRECO.AsFloat]);
      Label1.Caption := 'Preço novo:  ' + Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet4CUSTOCOMPR.AsFloat *  (1+(StrToFloat(LimpaNumeroDeixandoAVirgula(SMALL_DBEdit1.Text)) / 100))]);
      if Form7.ibDataSet4.EOF then Close;
    except end;
  end;
  if RadioButton3.Checked = True then
  begin
    try
      Form7.ibDataSet4.Edit;
      Form7.ibDataSet4PRECO.AsFloat := Arredonda(Form7.ibDataSet4INDEXADOR.AsFloat *  StrToFloat(LimpaNumeroDeixandoAVirgula(SMALL_DBEdit1.Text)),StrToInt(Form1.ConfPreco));
      Form7.ibDataSet4.Post;
      Form7.ibDataSet4.Next;
      while not (Form7.ibDataSet4.EOF) and (Form7.ibDataSet4INDEXADOR.Asfloat = 0) do Form7.ibDataSet4.Next;
      Label3.Caption := Form7.ibDataSet4DESCRICAO.AsString;
      Label2.Caption := 'Preço velho: ' + Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet4PRECO.AsFloat]);
      Label1.Caption := 'Preço novo:  ' + Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet4INDEXADOR.AsFloat * StrToFloat(LimpaNumeroDeixandoAVirgula(SMALL_DBEdit1.Text))]);
      if Form7.ibDataSet4.EOF then Close;
    except end;
  end;

end;

procedure TForm34.SMALL_DBEdit1Change(Sender: TObject);
begin
  Button4.Enabled := True;
end;

procedure TForm34.SMALL_DBEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(13) then
    if Button4.CanFocus then Button4.SetFocus;

end;

procedure TForm34.FormActivate(Sender: TObject);
begin
  //
  // volta tudo ao original
  //
  Form34.Image1.Picture := Form1.imgEstoque.Picture;
  //
  Button5.Visible := False;
  Button6.Visible := False;
  Button7.Visible := False;
  Button5.Enabled := True;
  Button6.Enabled := True;
  Button7.Enabled := True;
  Button2.Enabled := True;
  Button4.Enabled := True;
  Button4.Visible := True;
  //
  SMALL_DBEdit1.Visible := True;
  RadioButton1.visible := True;
  RadioButton2.visible := True;
  RadioButton3.visible := True;
  RadioButton1.Checked := True;
  Label3.Visible := False;
  Label1.Caption := 'Aumentar sobre:';
  Label2.Caption := '% de aumento:';
  Label1.Top := 12;
  Label2.Top := 140;
  Form7.ibDataSet25.Append;
  Form7.ibDataSet25ACUMULADO1.AsFloat := 0;
  //
  SMALL_DBEdit1.SetFocus;
end;

procedure TForm34.RadioButton3Click(Sender: TObject);
begin
  if RadioButton3.Checked then Label2.Caption := 'Valor do US$:' else Label2.Caption := '% de aumento:';
end;

procedure TForm34.RadioButton2Click(Sender: TObject);
begin
  if RadioButton3.Checked then Label2.Caption := 'Valor do US$:' else Label2.Caption := '% de aumento:';
end;

procedure TForm34.RadioButton1Click(Sender: TObject);
begin
  if RadioButton3.Checked then Label2.Caption := 'Valor do US$:' else Label2.Caption := '% de aumento:';
end;

end.


