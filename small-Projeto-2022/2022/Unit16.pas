unit Unit16;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Grids, DBGrids, DB, Mask, Spin, ComCtrls,
  smallfunc_xe, IniFiles;
type
  TForm16 = class(TForm)
    Panel2: TPanel;
    Image2: TImage;
    Label1: TLabel;
    DateTimePicker1: TDateTimePicker;
    Label3: TLabel;
    DateTimePicker2: TDateTimePicker;
    Label2: TLabel;
    MaskEdit1: TMaskEdit;
    MaskEdit2: TMaskEdit;
    Button3: TButton;
    Button4: TButton;
    Button2: TButton;
    Button1: TButton;
    ListBox1: TListBox;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure MaskEdit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MaskEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Memo1Enter(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label5Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure MaskEdit2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MaskEdit1Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  Form16: TForm16;

implementation

uses Unit7, Mais, Unit14;

{$R *.DFM}

procedure TForm16.FormActivate(Sender: TObject);
begin
  Form16.Image2.Picture := Form7.imgFiltrar.Picture;

  try
    {-----------------------------------------}
    {Filtra de acordo com o campo selecionado }
    {-----------------------------------------}
    Form16.MaskEdit1.Visible        := False;
    Form16.MaskEdit2.Visible        := False;
    Form16.Label3.Visible           := False;
    Form16.DateTimePicker1.Visible  := False;
    Form16.DateTimePicker2.Visible  := False;
    Button1.Enabled := True;

    //with Form7 do
    begin
      with Form7.ArquivoAberto do
      begin
        {Campos do tipo String}
        if Form7.dBgrid1.SelectedField.FieldName = 'CODIGO' then
        begin
          Form16.Label1.Caption := 'Filtrar do C�digo';
          Form16.Label3.Caption := 'at�';
          //
          Form16.Label3.Visible     := True;
          Form16.MaskEdit1.Visible  := True;
          Form16.MaskEdit2.Visible  := True;
          Form16.MaskEdit1.EditMask  := '';
          Form16.MaskEdit2.EditMask  := '';
          Form16.MaskEdit1.Width    := (Form7.dBGrid1.SelectedField.DisplayWidth * 8 )+ 10;
          Form16.MaskEdit2.Width    := (Form7.dBGrid1.SelectedField.DisplayWidth * 8 )+ 10;
          Form16.MaskEdit1.Text := Form7.dBGrid1.SelectedField.Value;
          Form16.MaskEdit2.Text := Form7.dBGrid1.SelectedField.Value;
          Form16.MaskEdit1.SetFocus;
        end else
        begin
          if Form7.dBgrid1.SelectedField.FieldName = 'CEP' then
          begin
            Form16.Label1.Caption := 'Filtrar do CEP';
            Form16.Label3.Caption := 'at�';
            //
            Form16.Label3.Visible     := True;
            Form16.MaskEdit1.Visible  := True;
            Form16.MaskEdit2.Visible  := True;
            Form16.MaskEdit1.EditMask := '';
            Form16.MaskEdit2.EditMask := '';
            Form16.MaskEdit1.Width    := (Form7.dBGrid1.SelectedField.DisplayWidth * 8 )+ 10;
            Form16.MaskEdit2.Width    := (Form7.dBGrid1.SelectedField.DisplayWidth * 8 )+ 10;
            Form16.MaskEdit1.Text := Form7.dBGrid1.SelectedField.Value;
            Form16.MaskEdit2.Text := Form7.dBGrid1.SelectedField.Value;
            Form16.MaskEdit1.SetFocus;
          end else
          begin
            if Form7.dBgrid1.SelectedField.FieldName = 'Or�amento' then
            begin
              Form16.Label1.Caption := 'Filtrar do Or�amento';
              Form16.Label3.Caption := 'at�';
              //
              Form16.Label3.Visible     := True;
              Form16.MaskEdit1.Visible  := True;
              Form16.MaskEdit2.Visible  := True;
              Form16.MaskEdit1.EditMask := '';
              Form16.MaskEdit2.EditMask := '';
              Form16.MaskEdit1.Width    := (Form7.dBGrid1.SelectedField.DisplayWidth * 10 )+ 10;
              Form16.MaskEdit2.Width    := (Form7.dBGrid1.SelectedField.DisplayWidth * 10 )+ 10;
              Form16.MaskEdit1.Text := Form7.dBGrid1.SelectedField.Value;
              Form16.MaskEdit2.Text := Form7.dBGrid1.SelectedField.Value;
              Form16.MaskEdit1.SetFocus;
            end else
            begin
              if (Form7.dBgrid1.Selectedfield.DataType = ftString) or (Form7.dBgrid1.Selectedfield.DataType = ftMemo) or (Form7.dBgrid1.Selectedfield.DataType = ftWideString) then
              begin
                MaskEdit1.Visible := True;
                Form16.Label1.Caption := 'Filtrar '+LowerCase(Form7.dBgrid1.SelectedField.DisplayLabel) + ' com';
                Form16.MaskEdit1.EditMask := '';
                Form16.MaskEdit1.Width    := (Form7.dBGrid1.SelectedField.DisplayWidth * 8 )+ 10;
                Form16.MaskEdit1.Text     := FieldByname(Form7.dBgrid1.SelectedField.FieldName).AsString;
                MaskEdit1.SetFocus;

                {Mauricio Parizotto 2024-03-20
                if (MaskEdit1.Width + MaskEdit1.Left) > (Form16.Width -20) then
                  MaskEdit1.Width := (Form16.Width - MaskEdit1.Left - 20);
                }
                if MaskEdit1.Width > 318 then
                  MaskEdit1.Width := 318;
              end;
            end;
            {Campos do tipo Date}
            if Form7.dBgrid1.Selectedfield.DataType = ftDate then
            begin
              Form16.Label1.Caption  := 'Filtrar '+LowerCase(Form7.dBgrid1.SelectedField.DisplayLabel) + ' de';
              Form16.Label3.Caption  := 'at�';
              //
              Form16.Label3.Visible  := True;
              Form16.DateTimePicker1.Visible  := True;
              Form16.DateTimePicker2.Visible  := True;
              Form16.DateTimePicker1.SetFocus;
              //
              if Form7.dBgrid1.Selectedfield.AsString = '' then
              begin
                Form16.DateTimePicker1.Date:= StrToDateTime('31/12/1899');
                Form16.DateTimePicker2.Date:=  StrToDateTime('31/12/1899');
              end else
              begin
                Form16.DateTimePicker1.Date:= Form7.dBgrid1.Selectedfield.AsDateTime;
                Form16.DateTimePicker2.Date:= Form7.dBgrid1.Selectedfield.AsDateTime;
              end;
              //
              if AllTrim(Form7.dBgrid1.SelectedField.DisplayLAbel) = 'Nascido em' then
              begin
                Form16.Label1.Caption  := 'Filtrar aniversariantes de';
                Form16.DateTimePicker1.Date:= Date;
                Form16.DateTimePicker2.Date:= Date + 30;
              end;
            end;
            if TipoCampoFloat(Form7.dBgrid1.Selectedfield) then // Sandro Silva 2024-04-29 if Form7.dBgrid1.Selectedfield.DataType = ftFloat then
            begin
              try
                Form16.Label1.Caption := StrTran(StrTran('Filtrar '+LowerCase(Form7.dBgrid1.SelectedField.DisplayLabel) + ' de','r$','R$'),'us$','US$');
                Form16.Label3.Caption := 'at�';
                //
                Form16.Label3.Visible     := True;
                Form16.MaskEdit1.Visible  := True;
                Form16.MaskEdit2.Visible  := True;
                Form16.MaskEdit1.EditMask  := '';
                Form16.MaskEdit2.EditMask  := '';
                Form16.MaskEdit1.Width    := (Form7.dBGrid1.SelectedField.DisplayWidth * 8 )+ 10;
                Form16.MaskEdit2.Width    := (Form7.dBGrid1.SelectedField.DisplayWidth * 8 )+ 10;
                if Form7.dBGrid1.SelectedField.AsFloat = 0 then
                begin
                  Form16.MaskEdit1.Text := '0,00';
                  Form16.MaskEdit2.Text := '0,00';
                end else
                begin
                  Form16.MaskEdit1.Text := Form7.dBGrid1.SelectedField.Value;
                  Form16.MaskEdit2.Text := Form7.dBGrid1.SelectedField.Value;
                end;
                Form16.MaskEdit1.SetFocus;
              except
              end;
            end;
          end;
        end;
      end;
    end;
  except end;

  Button4.Enabled := True;
  Button2.Enabled := True;
end;

procedure TForm16.Button1Click(Sender: TObject);
begin
  Close;
end;


procedure TForm16.Button2Click(Sender: TObject);
var
  sLogica : String;
  cTabela: string;
begin
  cTabela := EmptyStr;
  if (Form7.sModulo = 'ORCAMENTO') then
    cTabela := 'ORCAMENTS.';
    
  Button1.Enabled := False;
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  try
    with Form7 do
    begin
      //*********************
      // Esconde ou mostra **
      //*********************
      with Sender as TButton do if CapTion = 'Listar' then sLogica := '' else sLogica := ' not ';
      //********************************************
      // Temos v�rios tipos de condi��o: Quando ? **
      //********************************************
      with ArquivoAberto do
      begin
        //
        // S� � necess�rio alterar a vari�vel Form7.sWhere
        //
        if dBgrid1.SelectedField.FieldName = 'CODIGO' then
        begin
          ListBox1.Items.Add(sLogica+' (CODIGO >= '+QuotedStr(MaskEdit1.Text)+' and CODIGO <= '+QuotedStr(MaskEdit2.Text)+') ');
        end else
        begin
          if (dBgrid1.SelectedField.FieldName = 'Desconto') and (Form7.sModulo='ORCAMENTO') then
          begin
            ListBox1.Items.Add(sLogica +
                '((CAST('+cTabela+'DESCONTO AS NUMERIC(18,2)) >= ' + QuotedStr(StrTran(LimpanumeroDeixandoAVirgula(MaskEdit1.Text),',','.')) + ') AND (CAST('+cTabela+'DESCONTO AS NUMERIC(18,2)) <= ' + QuotedStr(StrTran(LimpanumeroDeixandoAVirgula(MaskEdit2.Text),',','.')) + '))'
                );
            Exit;
          end;

          if (dBgrid1.SelectedField.FieldName = 'Total bruto') and (Form7.sModulo='ORCAMENTO') then
          begin
            ListBox1.Items.Add(sLogica+
                '((CAST('+cTabela+'TOTALBRUTO AS NUMERIC(18,2)) >= '+ QuotedStr(StrTran(LimpanumeroDeixandoAVirgula(MaskEdit1.Text),',','.')) + ') AND (CAST('+cTabela+'TOTALBRUTO AS NUMERIC(18,2)) <= ' + QuotedStr(StrTran(LimpanumeroDeixandoAVirgula(MaskEdit2.Text),',','.')) + '))'
                );
            Exit;
          end;

          if (dBgrid1.SelectedField.FieldName = 'Total l�quido') and (Form7.sModulo='ORCAMENTO') then
          begin
            ListBox1.Items.Add(sLogica+
                '((CAST(('+cTabela+'TOTALBRUTO - '+cTabela+'DESCONTO) AS NUMERIC(18,2)) >= '+ QuotedStr(StrTran(LimpanumeroDeixandoAVirgula(MaskEdit1.Text),',','.')) + ') AND (CAST(('+cTabela+'TOTALBRUTO - '+cTabela+'DESCONTO) AS NUMERIC(18,2)) <= ' + QuotedStr(StrTran(LimpanumeroDeixandoAVirgula(MaskEdit2.Text),',','.')) + '))'
                );
            Exit;
          end;
          //
          if dBgrid1.SelectedField.FieldName = 'CEP' then
          begin
            ListBox1.Items.Add(sLogica+' (CEP >= '+QuotedStr(MaskEdit1.Text)+' and CEP <= '+QuotedStr(MaskEdit2.Text)+') ');
          end else
          begin
            if dBgrid1.SelectedField.FieldName = 'Or�amento' then
            begin
              ListBox1.Items.Add(sLogica+' (Or�amento >= '+QuotedStr(MaskEdit1.Text)+' and Or�amento <= '+QuotedStr(MaskEdit2.Text)+') ');
            end else
            begin
              if dBgrid1.SelectedField.FieldName = 'DATANAS' then
              begin                                             // 2007/09/01
                ListBox1.Items.Add(sLogica+' substring(DATANAS from 6 for 5)>='+QuotedStr(StrTran(Copy(DateToStrInvertida(Form16.DateTimePicker1.Date),6,5),'/','-'))+' and substring(DATANAS from 6 for 5)<='+QuotedStr(StrTran(Copy(DateToStrInvertida(Form16.DateTimePicker2.Date),6,5),'/','-')));
              end else
              begin
                //if dBgrid1.Selectedfield.DataType = ftString then Mauricio Parizotto 2023-07-26 Migra��o Delphi 11
                if (dBgrid1.Selectedfield.DataType = ftString) or (dBgrid1.Selectedfield.DataType = ftWideString) then
                begin
                  ListBox1.Items.Add(sLogica+' upper( Coalesce('+cTabela+dBgrid1.Selectedfield.FieldName+','+QuotedStr('~')+') ) like '+QuotedStr('%'+UpperCase(ConverteAcentos3(MaskEdit1.Text))+'%'));
                end;
                if dBgrid1.Selectedfield.DataType = ftMemo then // N�o pode usar o upper
                begin
                  ListBox1.Items.Add(sLogica+' '+cTabela+dBgrid1.Selectedfield.FieldName+' like '+QuotedStr('%'+MaskEdit1.Text+'%'));
                end;
                //
                if dBgrid1.Selectedfield.DataType = ftDate then
                begin
                  ListBox1.Items.Add(sLogica+' '+cTabela+dBgrid1.Selectedfield.FieldName+' >= '+QuotedStr(DateToStrInvertida(Form16.DateTimePicker1.Date))+' and '+cTabela+dBgrid1.Selectedfield.FieldName+' <= '+QuotedStr(DateToStrInvertida(Form16.DateTimePicker2.Date))+' ')
                end;
                //
                if TipoCampoFloat(dBgrid1.Selectedfield) then // Sandro Silva 2024-04-29 if dBgrid1.Selectedfield.DataType = ftFloat then
                begin
                  ListBox1.Items.Add(sLogica+' ('+cTabela+dBgrid1.Selectedfield.FieldName+' >= '+QuotedStr(
                  StrTran(LimpanumeroDeixandoAVirgula(MaskEdit1.Text),',','.')
                  )+' and '+cTabela+dBgrid1.Selectedfield.FieldName+' <= '+QuotedStr(
                  StrTran(LimpanumeroDeixandoAVirgula(MaskEdit2.Text),',','.')
                  )+') ');
                end;
              end;
            end;
          end;
        end;
      end;
      //
    end;
  finally
    Screen.Cursor := crDefault; // Cursor de Aguardo
    close;
  end;
end;

procedure TForm16.Button3Click(Sender: TObject);
begin
  ListBox1.Items.Clear;
  Close;
end;

procedure TForm16.MaskEdit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if MaskEdit2.CanFocus then MaskEdit2.SetFocus else Button2.SetFocus;
  end;
end;

procedure TForm16.MaskEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  if TipoCampoFloat(Form7.dBgrid1.Selectedfield) then // Sandro Silva 2024-04-29 if Form7.dBgrid1.Selectedfield.DataType = ftFloat then
    if Key = chr(46) then
      key := chr(44);
end;


procedure TForm16.FormShow(Sender: TObject);
var
  I, J : Integer;
begin
  //
  if MaskEdit1.CanFocus then
  begin
    MaskEdit1.SetFocus;
    MaskEdit1.SelectAll;
    MaskEdit1.TabOrder := 0;
    MaskEdit2.TabOrder := 1;
  end;
  //
  ListBox1.Items.Clear;
  //
  if Pos('select',Form7.sWhere) = 0 then Form7.sWhere := StrTran(StrTran(Form7.sWhere,'where',''),' and ','#')+'#' else Form7.sWhere := AllTrim(Copy(Form7.sWhere+Replicate(' ',5000),6,4900))+'#';
  //
  J := 1;
  for I := 1 to Length(AllTrim(Form7.sWhere))+1 do
  begin
   if Copy(Form7.sWhere,I,1) = '#' then
   begin
     ListBox1.Items.Add(Copy(Form7.sWhere,J,I-J));
     J := I+1;
   end;
  end;
  //
  Form7.sWhere :=  '';
  //
end;

procedure TForm16.Label7Click(Sender: TObject);
begin
  Form16.Button2Click(Button4);
end;

procedure TForm16.Memo1Enter(Sender: TObject);
begin
  if Button2.CanFocus then Button2.SetFocus;
end;

procedure TForm16.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = Vk_Delete then
  begin
    ListBox1.DeleteSelected;
    Close;
  end;
end;

procedure TForm16.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I : Integer;
begin
  //
  // Passa o que ta no Listbox para a vari�vel sWhere (SQL usado do Select)
  //
  Form7.sWhere := '';
  for I := 0 to ListBox1.Items.Count -1 do
  begin
    if AllTrim(Form7.sWhere) = '' then Form7.sWhere := AllTrim(ListBox1.Items[I])+' ' else Form7.sWhere := Form7.sWhere + ' and ' + AllTrim(ListBox1.Items[I])+' ';
  end;
  //
  Form7.sWhere := 'where '+Form7.sWhere;
  //
  if Form7.sWhere = '' then
  begin
    Form7.bFirst := True;
  end else
  begin
    Form7.bFirst := False;
  end;
  //
end;

procedure TForm16.Label5Click(Sender: TObject);
begin
  Form16.Button2Click(Button2);
end;

procedure TForm16.Image3Click(Sender: TObject);
begin
  Form16.Button2Click(Button2);
end;

procedure TForm16.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  ListBox1.Canvas.FillRect(Rect);
  ListBox1.Canvas.TextOut(Rect.Left+2,Rect.Top+2, AllTrim(TraduzSql(ListBox1.Items[Index],True)) );
end;

procedure TForm16.MaskEdit2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Button2.SetFocus;
end;

procedure TForm16.MaskEdit1Exit(Sender: TObject);
begin
  if Pos('CGC',Form7.dBgrid1.SelectedField.FieldName) <> 0 then
  begin
    if LimpaNumero(MaskEdit1.Text) <> '' then
    begin
      if CpfCgc(LimpaNumero(MaskEdit1.Text)) then
      begin
        MaskEdit1.Text := ConverteCpfCgc(AllTrim(LimpaNumero(MaskEdit1.Text)));
      end;
    end;
  end;
end;

end.

