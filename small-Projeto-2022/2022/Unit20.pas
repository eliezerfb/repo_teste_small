unit Unit20;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, SmallFunc,  DBGrids, DB, jpeg;

type
  TForm20 = class(TForm)
    Panel2: TPanel;
    Image1: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    MemoPesquisa: TMemo;
    Button3: TButton;
    Button1: TButton;
    Button4: TButton;
    Button2: TButton;
    Panel1: TPanel;
    Edit2: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Edit3: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button3Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit1Enter(Sender: TObject);
    procedure MemoPesquisaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form20: TForm20;

implementation

uses Unit7, Mais;

{$R *.DFM}

procedure TForm20.FormActivate(Sender: TObject);
begin
  //
  Form20.Image1.Picture := Form7.Image203.Picture;
  //
  Button3.Tag          :=0; //Botão voltar
  Button1.Tag          := 0;
  Button3.Enabled      := False;
  //
  if Panel1.Visible then
  begin
    Button4.Enabled      := True;
  end else
  begin
    Button4.Enabled      := False;
  end;
  //
  MemoPesquisa.Lines.Clear;
  Label5.Visible := True;
  Button1.Enabled := True;
  //
  with Form7 do
  begin
    Edit1.Text := ArquivoAberto.FieldByname(dBgrid1.SelectedField.FieldName).asString;
    if Form7.DbGrid1.SelectedField.DataType = ftFloat then
      if AllTrim(Edit1.Text) = '' then Edit1.Text := '0,00';
  end;
  //
  if Panel1.Visible then
  begin
    if Edit2.CanFocus then Edit2.SetFocus;
    Label8.Caption := 'Localizar em '+Form7.ArquivoAberto.FieldByname(Form7.dBgrid1.SelectedField.FieldName).DisplayLabel+' com:';
  end else
  begin
    if Edit1.CanFocus then Edit1.SetFocus;
    Label5.Caption := Form7.ArquivoAberto.FieldByname(Form7.dBgrid1.SelectedField.FieldName).DisplayLabel+' com:';
    Edit1.SelectAll;
  end;
  //
end;


procedure TForm20.Button1Click(Sender: TObject);
var
  iReg      : Integer;
  bSair     : Boolean;
//  MyBookmark: TBookmark;
  sRegistro : String;
begin
  //
  try
    //
    Form20.Button2.Tag := 0;
    Button3.Enabled    := False;
    Button1.Enabled    := False;
    //
    MemoPesquisa.Text    := 'Pesquisando...';
    //
    Form7.sProcura := AllTrim(Edit1.Text);
    //
    if Form7.DbGrid1.SelectedField.DataType = ftFloat then
    begin
      //
      iReg := Form7.ArquivoAberto.RecNo;
      Form7.ArquivoAberto.Next;
      //
      if AllTrim(Form7.sProcura) = '' then Form7.sProcura := '0';
      //
      with Form7 do
      begin
        //
        if Copy(AllTrim(Format('%12.4n', [(StrToFloat(sProcura) - ArquivoAberto.FieldByName(dBgrid1.SelectedField.FieldName).AsFloat)])),1,4) <> '0,00' then
        begin
          bSair     := False;
          ArquivoAberto.DisableControls;
          //
          // Inicia a procura
          //
          Screen.Cursor  := crAppStart;  // Cursor de Aguardo
          //
          // Ainda não encontrou
          //
          while bSair = False do
          begin
            //
            // Se clicar no botão cancelar para o processamento
            //
            Application.ProcessMessages;
            //
            if Form20.Button2.Tag = 1 then Abort;
            if ArquivoAberto.Eof then ArquivoAberto.First else ArquivoAberto.Next;
            if Copy(AllTrim(Format('%12.4n', [(StrToFloat(sProcura) - ArquivoAberto.FieldByName(dBgrid1.SelectedField.FieldName).AsFloat)])),1,4) = '0,00' then bSair := True;
            if iReg = ArquivoAberto.RecNo then bSair := True;
            //
          end;
          //
          Screen.Cursor  := crDefault;  // Cursor normal
          ArquivoAberto.EnableControls;
          //
        end;
        //
        // encontrou
        //
        if Copy(AllTrim(Format('%12.4n', [(StrToFloat(sProcura) - ArquivoAberto.FieldByName(dBgrid1.SelectedField.FieldName).AsFloat)])),1,4) = '0,00' then
        begin
          MemoPesquisa.Text      := dBgrid1.SelectedField.AsString;
          Form20.Button4.Enabled := True;
          if Form20.Button4.Canfocus then Form20.Button4.SetFocus;
        end else
        begin
          if Form20.Button2.CanFocus then Form20.Button2.SetFocus;
          form20.Button1.Enabled := False;
          MemoPesquisa.Text := 'não cadastrado!';
          MemoPesquisa.Visible := True;
        end;
      end;
    end else
    begin
      //
      // Não é um campo numérico
      //
      if Pos('CGC',Form7.dBgrid1.SelectedField.FieldName) <> 0 then
      begin
        //
        // CNPJ ou CPF
        //
        if LimpaNumero(Edit1.Text) <> '' then
        begin
          if CpfCgc(LimpaNumero(Edit1.Text)) then
          begin
            //
            Edit1.Text := ConverteCpfCgc(AllTrim(LimpaNumero(Edit1.Text)));
            Form7.sProcura:=Edit1.Text;
            //
            Form7.TabelaAberta.Locate(Form7.dBgrid1.SelectedField.FieldName,form7.sProcura,[loCaseInsensitive, loPartialKey]);
            sRegistro  := Form7.ArquivoAberto.FieldByName('REGISTRO').AsString; // Foi criado para eliminar metodo MyBookmark
            //
          end else
          begin
            ShowMessage('CPF ou CNPJ inválido!');
            MemoPesquisa.Text := '';
            Edit1.SelectAll;
            if Edit1.CanFocus then Edit1.SetFocus;
          end;
        end;
      end else
      begin
        //
        // MyBookmark := Form7.ArquivoAberto.GetBookmark; // Dava Acsses Violation
        //
        sRegistro  := Form7.ArquivoAberto.FieldByName('REGISTRO').AsString; // Foi criado para eliminar metodo MyBookmark
        //
        if (not Form20.Button4.Enabled) then
        begin
          try
            Form7.TabelaAberta.Locate(Form7.dBgrid1.SelectedField.FieldName,form7.sProcura,[loCaseInsensitive, loPartialKey]);
          except end;
        end;
        //
        if (pos(AnsiUpperCase(Form7.sProcura),AnsiUpperCase(Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString)) = 0)
        or (Form20.Button4.Enabled) then
        begin
          //
          // Form7.ArquivoAberto.GotoBookmark(MyBookmark); // Dava Acsses Violation
          //
          try
            Form7.TabelaAberta.Locate('REGISTRO',sRegistro,[loCaseInsensitive, loPartialKey]); // Foi criado para eliminar metodo MyBookmark
          except end;
          //
          iReg    := Form7.ArquivoAberto.RecNo;
          //
          // faz um controle do botão voltar
          //
          if Form20.Button3.Tag=0 then
          begin
             Form7.ArquivoAberto.Next;
             if Form7.ArquivoAberto.Eof then Form7.ArquivoAberto.First;
          end else Form20.Button3.Tag:=0;
          //
          // Ainda não encontrou
          //
          if (pos(AnsiUpperCase(Form7.sProcura),AnsiUpperCase(Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString)) = 0) then
          begin
            bSair     := False;
            Form7.ArquivoAberto.DisableControls;
            //
            // Procura De acordo com o campo selecionado
            //
            if Form7.sProcura <> '' then
            begin
              //
              // Inicia a procura
              //
              Screen.Cursor  := crAppStart;  // Cursor de Aguardo
              //
              // Ainda não encontrou continua a procura
              //
              while (pos(AnsiUpperCase(Form7.sProcura),AnsiUpperCase(Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString)) = 0 ) and ( bSair = False ) do
              begin
                //
                // Se clicar no botão cancelar para o processamento
                //
                Application.ProcessMessages;
                //
                if Form20.Button2.Tag = 1 then Abort;
                if Form7.ArquivoAberto.Eof then Form7.ArquivoAberto.First else Form7.ArquivoAberto.Next;
                if iReg = Form7.ArquivoAberto.RecNo then bSair := True;
                //
              end;
              //
              Screen.Cursor  := crDefault;  // Cursor normal
              //
            end;
            //
            Form7.ArquivoAberto.EnableControls;
            //
          end;
        end;
      end;
      //
      // Encontrou
      //
      if pos(AnsiUpperCase(Form7.sProcura),AnsiUpperCase(Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString)) <> 0 then
      begin
        MemoPesquisa.Lines.Clear;
        MemoPesquisa.Lines.Add(Form7.dBgrid1.SelectedField.AsString);
        MemoPesquisa.Visible:=True;
        Form20.Button4.Enabled := True;
        if form20.Button4.CanFocus then Form20.Button4.SetFocus;
        //
      end else
      begin
        //
        // Não encontrou
        //
        if form20.Button2.CanFocus then Form20.Button2.SetFocus;
        Form20.Button1.Enabled := False;
        MemoPesquisa.Text := 'não cadastrado!';
        MemoPesquisa.Visible := True;
      end;
    end;  // Ve se é numerico
    //
    if pos('não cadastrado',MemoPesquisa.Text)>0 then
    begin
      if Edit1.CanFocus then
      begin
        Edit1.SelectAll;
        if Edit1.CanFocus then Edit1.SetFocus;
      end;
    end;
    Button3.Enabled := True; //cancelar
    Button1.Enabled := True; //avançar
    //
    if Form7.ArquivoAberto.MoveBy(+1) = 1 then Form7.ArquivoAberto.MoveBy(-1) else if Form7.ArquivoAberto.MoveBy(-1) = -1 then Form7.ArquivoAberto.MoveBy(+1);
    //
  except end;
  //
end;

procedure TForm20.Button2Click(Sender: TObject);
begin
  Screen.Cursor  := crDefault;  // Cursor normal
  Form7.ArquivoAberto.EnableControls;
  Button2.Tag := 1;
  Form20.close;
end;

procedure TForm20.Button4Click(Sender: TObject);
var
  I : Integer;
begin
  //
  try
    if Panel1.Visible then
    begin
      //
      if Pos(Edit2.Text,Edit3.Text) = 0 then
      begin
        //
        if (AllTrim(Edit2.Text) = '') then
        begin
          I := Application.MessageBox(Pchar('Tem certeza que quer substituir todas as expressões <NÃO PREENCHIDAS> por '
                                  + Chr(10) +'"'+ Edit3.Text + '" dentro do campo '+Form7.ArquivoAberto.FieldByname(Form7.dBgrid1.SelectedField.FieldName).DisplayLabel+'?'
                            + Chr(10)
                            + Chr(10))
                            ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING);

        end else
        begin
          I := Application.MessageBox(Pchar('Tem certeza que quer substituir todas as expressões "'+ Edit2.Text + '" por '
                                  + Chr(10) +'"'+ Edit3.Text + '" dentro do campo '+Form7.ArquivoAberto.FieldByname(Form7.dBgrid1.SelectedField.FieldName).DisplayLabel+'?'
                            + Chr(10)
                            + Chr(10))
                            ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING);

        end;
        //
        if I = IDYES then
        begin
          //
          Form20.Button2.Tag := 0;
          Screen.Cursor  := crAppStart;  // Cursor de Aguardo
          Form7.ArquivoAberto.DisableControls;
          Form7.ArquivoAberto.First;
          while not Form7.ArquivoAberto.eof do
          begin
            if Form20.Button2.Tag = 1 then Form7.ArquivoAberto.Last;
            if (pos(Edit2.Text,Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString) <> 0) or ((AllTrim(Edit2.Text) = '') and (Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString='')) then
            begin
              //
              Form7.ArquivoAberto.Edit;
              //
              if (AllTrim(Edit2.Text) = '') and (Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString='') then
              begin
                Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString := Edit3.Text;
              end else
              begin
                Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString := StrTran(Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString,Edit2.Text,Edit3.Text);
              end;
              //
              Form7.ArquivoAberto.Post;
              //
            end;
            Form7.ArquivoAberto.Next;
          end;
          Form7.ArquivoAberto.EnableControls;
          Screen.Cursor  := crDefault;  // Cursor normal
        end;
      end else
      begin
        ShowMessage('Não é possível substituir "'+Edit2.TExt+'" por "'+Edit3.TExt +'". Referencia circular.');
      end;
    end;
  except
    //
    on E: Exception do  ShowMessage('Erro 3 na procura: '+E.Message);
    //
  end;
  //
  Form20.close;
  //
end;


procedure TForm20.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Form7.DbGrid1.SelectedField.DataType = ftFloat then
     if Key = chr(46) then key := chr(44);
end;

procedure TForm20.Button3Click(Sender: TObject);
begin
  Button3.Tag:=1;//
  Form7.ArquivoAberto.First;
  Form20.Button1Click(Sender);
end;


procedure TForm20.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
    Form20.Button1.Click;
  end;
end;

procedure TForm20.Edit1Enter(Sender: TObject);
begin
  Edit1.SelectAll;
end;

procedure TForm20.MemoPesquisaKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Form20.Button4.Click;
  end;
end;

procedure TForm20.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Edit3.SetFocus;
  end;
end;

procedure TForm20.Edit3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Button4Click(Sender);
  end;
end;

procedure TForm20.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Panel1.Visible := False;
end;

end.

