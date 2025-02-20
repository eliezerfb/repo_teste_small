unit uFrmAssistenteProcura;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, smallfunc_xe,  DBGrids, DB, jpeg;

type
  TFrmAssistenteProcura = class(TForm)
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
  FrmAssistenteProcura: TFrmAssistenteProcura;

implementation

uses Unit7, Mais, uDialogs;

{$R *.DFM}

procedure TFrmAssistenteProcura.FormActivate(Sender: TObject);
begin
  FrmAssistenteProcura.Image1.Picture := Form7.imgProcurar.Picture;
  
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
end;


procedure TFrmAssistenteProcura.Button1Click(Sender: TObject);
var
  iReg      : Integer;
  bSair     : Boolean;
  sRegistro : String;
  CampoPK   : string;
begin
  try
    FrmAssistenteProcura.Button2.Tag := 0;
    Button3.Enabled    := False;
    Button1.Enabled    := False;

    MemoPesquisa.Text    := 'Pesquisando...';

    //Mauricio Parizotto 2023-12-04
    try
      CampoPK := GetCampoPKDataSet(Form7.ArquivoAberto);
    except
      CampoPK := 'REGISTRO';
    end;

    Form7.sProcura := AllTrim(Edit1.Text);

    if Form7.DbGrid1.SelectedField.DataType = ftFloat then
    begin
      iReg := Form7.ArquivoAberto.RecNo;
      Form7.ArquivoAberto.Next;

      if AllTrim(Form7.sProcura) = '' then Form7.sProcura := '0';

      with Form7 do
      begin
        if Copy(AllTrim(Format('%12.4n', [(StrToFloat(sProcura) - ArquivoAberto.FieldByName(dBgrid1.SelectedField.FieldName).AsFloat)])),1,4) <> '0,00' then
        begin
          bSair     := False;
          ArquivoAberto.DisableControls;
          
          // Inicia a procura
          Screen.Cursor  := crAppStart;  // Cursor de Aguardo

          // Ainda não encontrou
          while bSair = False do
          begin
            // Se clicar no botão cancelar para o processamento
            Application.ProcessMessages;
            //
            if FrmAssistenteProcura.Button2.Tag = 1 then Abort;
            if ArquivoAberto.Eof then ArquivoAberto.First else ArquivoAberto.Next;
            if Copy(AllTrim(Format('%12.4n', [(StrToFloat(sProcura) - ArquivoAberto.FieldByName(dBgrid1.SelectedField.FieldName).AsFloat)])),1,4) = '0,00' then bSair := True;
            if iReg = ArquivoAberto.RecNo then bSair := True;
          end;

          Screen.Cursor  := crDefault;  // Cursor normal
          ArquivoAberto.EnableControls;
        end;

        // encontrou
        if Copy(AllTrim(Format('%12.4n', [(StrToFloat(sProcura) - ArquivoAberto.FieldByName(dBgrid1.SelectedField.FieldName).AsFloat)])),1,4) = '0,00' then
        begin
          MemoPesquisa.Text      := dBgrid1.SelectedField.AsString;
          FrmAssistenteProcura.Button4.Enabled := True;
          if FrmAssistenteProcura.Button4.Canfocus then FrmAssistenteProcura.Button4.SetFocus;
        end else
        begin
          if FrmAssistenteProcura.Button2.CanFocus then FrmAssistenteProcura.Button2.SetFocus;
          FrmAssistenteProcura.Button1.Enabled := False;
          MemoPesquisa.Text := 'não cadastrado!';
          MemoPesquisa.Visible := True;
        end;
      end;
    end else
    begin
      // Não é um campo numérico
      if Pos('CGC',Form7.dBgrid1.SelectedField.FieldName) <> 0 then
      begin
        // CNPJ ou CPF
        if LimpaNumero(Edit1.Text) <> '' then
        begin
          if CpfCgc(LimpaNumero(Edit1.Text)) then
          begin
            Edit1.Text := ConverteCpfCgc(AllTrim(LimpaNumero(Edit1.Text)));
            Form7.sProcura:=Edit1.Text;
            //
            Form7.TabelaAberta.Locate(Form7.dBgrid1.SelectedField.FieldName,form7.sProcura,[loCaseInsensitive, loPartialKey]);
            //sRegistro  := Form7.ArquivoAberto.FieldByName('REGISTRO').AsString; // Mauricio Parizotto 2023-12-04
            sRegistro  := Form7.ArquivoAberto.FieldByName(CampoPK).AsString;
          end else
          begin
            //ShowMessage('CPF ou CNPJ inválido!'); Mauricio Parizotto 2023-10-25
            MensagemSistema('CPF ou CNPJ inválido!');
            MemoPesquisa.Text := '';
            Edit1.SelectAll;
            if Edit1.CanFocus then Edit1.SetFocus;
          end;
        end;
      end else
      begin
        //sRegistro  := Form7.ArquivoAberto.FieldByName('REGISTRO').AsString; // Mauricio Parizotto 2023-12-04
        sRegistro  := Form7.ArquivoAberto.FieldByName(CampoPK).AsString;

        if (not FrmAssistenteProcura.Button4.Enabled) then
        begin
          try
            Form7.TabelaAberta.Locate(Form7.dBgrid1.SelectedField.FieldName,form7.sProcura,[loCaseInsensitive, loPartialKey]);
          except
          end;
        end;

        if (pos(AnsiUpperCase(Form7.sProcura),AnsiUpperCase(Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString)) = 0)
        or (FrmAssistenteProcura.Button4.Enabled) then
        begin
          try
            //Form7.TabelaAberta.Locate('REGISTRO',sRegistro,[loCaseInsensitive, loPartialKey]); // Mauricio Parizotto 2023-12-04
            Form7.TabelaAberta.Locate(CampoPK,sRegistro,[loCaseInsensitive, loPartialKey]); // Foi criado para eliminar metodo MyBookmark
          except
          end;

          iReg    := Form7.ArquivoAberto.RecNo;

          // faz um controle do botão voltar
          if FrmAssistenteProcura.Button3.Tag=0 then
          begin
             Form7.ArquivoAberto.Next;
             if Form7.ArquivoAberto.Eof then Form7.ArquivoAberto.First;
          end else FrmAssistenteProcura.Button3.Tag:=0;

          // Ainda não encontrou
          if (pos(AnsiUpperCase(Form7.sProcura),AnsiUpperCase(Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString)) = 0) then
          begin
            bSair     := False;
            Form7.ArquivoAberto.DisableControls;
            // Procura De acordo com o campo selecionado
            if Form7.sProcura <> '' then
            begin
              // Inicia a procura
              Screen.Cursor  := crAppStart;  // Cursor de Aguardo
              //
              // Ainda não encontrou continua a procura
              //
              while (pos(AnsiUpperCase(Form7.sProcura),AnsiUpperCase(Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString)) = 0 ) and ( bSair = False ) do
              begin
                // Se clicar no botão cancelar para o processamento
                Application.ProcessMessages;
                //
                if FrmAssistenteProcura.Button2.Tag = 1 then Abort;
                if Form7.ArquivoAberto.Eof then Form7.ArquivoAberto.First else Form7.ArquivoAberto.Next;
                if iReg = Form7.ArquivoAberto.RecNo then bSair := True;
              end;

              Screen.Cursor  := crDefault;  // Cursor normal
            end;

            Form7.ArquivoAberto.EnableControls;
          end;
        end;
      end;

      // Encontrou
      if pos(AnsiUpperCase(Form7.sProcura),AnsiUpperCase(Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString)) <> 0 then
      begin
        MemoPesquisa.Lines.Clear;
        MemoPesquisa.Lines.Add(Form7.dBgrid1.SelectedField.AsString);
        MemoPesquisa.Visible:=True;
        FrmAssistenteProcura.Button4.Enabled := True;
        if FrmAssistenteProcura.Button4.CanFocus then FrmAssistenteProcura.Button4.SetFocus;
      end else
      begin
        // Não encontrou
        if FrmAssistenteProcura.Button2.CanFocus then FrmAssistenteProcura.Button2.SetFocus;
        MemoPesquisa.Text := 'não cadastrado!';
        MemoPesquisa.Visible := True;
      end;
    end;  // Ve se é numerico

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

    if Form7.ArquivoAberto.MoveBy(+1) = 1 then
      Form7.ArquivoAberto.MoveBy(-1)
    else
      if Form7.ArquivoAberto.MoveBy(-1) = -1 then
        Form7.ArquivoAberto.MoveBy(+1);
  except
  end;
end;

procedure TFrmAssistenteProcura.Button2Click(Sender: TObject);
begin
  Screen.Cursor  := crDefault;  // Cursor normal
  Form7.ArquivoAberto.EnableControls;
  Button2.Tag := 1;
  FrmAssistenteProcura.close;
end;

procedure TFrmAssistenteProcura.Button4Click(Sender: TObject);
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
          FrmAssistenteProcura.Button2.Tag := 0;
          Screen.Cursor  := crAppStart;  // Cursor de Aguardo
          Form7.ArquivoAberto.DisableControls;
          Form7.ArquivoAberto.First;
          while not Form7.ArquivoAberto.eof do
          begin
            if FrmAssistenteProcura.Button2.Tag = 1 then Form7.ArquivoAberto.Last;
            if (pos(Edit2.Text,Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString) <> 0) or ((AllTrim(Edit2.Text) = '') and (Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString='')) then
            begin
              Form7.ArquivoAberto.Edit;

              if (AllTrim(Edit2.Text) = '') and (Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString='') then
              begin
                Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString := Edit3.Text;
              end else
              begin
                Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString := StrTran(Form7.ArquivoAberto.FieldByName(Form7.dBgrid1.SelectedField.FieldName).AsString,Edit2.Text,Edit3.Text);
              end;
              
              Form7.ArquivoAberto.Post;
            end;
            Form7.ArquivoAberto.Next;
          end;
          Form7.ArquivoAberto.EnableControls;
          Screen.Cursor  := crDefault;  // Cursor normal
        end;
      end else
      begin
        MensagemSistema('Não é possível substituir "'+Edit2.TExt+'" por "'+Edit3.TExt +'". Referencia circular.',msgAtencao);
      end;
    end;
  except
    on E: Exception do
      MensagemSistema('Erro 3 na procura: '+E.Message,msgErro);
  end;
  
  FrmAssistenteProcura.close;
end;


procedure TFrmAssistenteProcura.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Form7.DbGrid1.SelectedField.DataType = ftFloat then
     if Key = chr(46) then key := chr(44);
end;

procedure TFrmAssistenteProcura.Button3Click(Sender: TObject);
begin
  Button3.Tag:=1;//
  Form7.ArquivoAberto.First;
  FrmAssistenteProcura.Button1Click(Sender);
end;


procedure TFrmAssistenteProcura.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
    FrmAssistenteProcura.Button1.Click;
  end;
end;

procedure TFrmAssistenteProcura.Edit1Enter(Sender: TObject);
begin
  Edit1.SelectAll;
end;

procedure TFrmAssistenteProcura.MemoPesquisaKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    FrmAssistenteProcura.Button4.Click;
  end;
end;

procedure TFrmAssistenteProcura.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Edit3.SetFocus;
  end;
end;

procedure TFrmAssistenteProcura.Edit3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Button4Click(Sender);
  end;
end;

procedure TFrmAssistenteProcura.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Panel1.Visible := False;
end;

end.

