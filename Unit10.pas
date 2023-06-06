unit Unit10;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SmallFunc, IniFiles, Menus, Buttons, StrUtils,
  umfe, _Small_59;

type
  TTipoForm = (tfAdquirente, tfFabricanteSAT, tfPOS, tfTEF);

  TForm10 = class(TForm)
    pnBotoes: TPanel;
    btnMais: TBitBtn;
    btnMenos: TBitBtn;
    Button3: TBitBtn;
    Panel2: TPanel;
    ListBox1: TListBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBox1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnMaisClick(Sender: TObject);
    procedure btnMenosClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FTipoForm: TTipoForm;
    FbFuncoesADM: Boolean;
    { Private declarations }
    procedure AjustaFormCartoes;
    procedure SelecionarAdministradora;
    procedure SelecionarAdquirente;
    procedure AcionaTEF;
  public
    { Public declarations }
    sNomedoTef : String;
    sNomeAdquirente: String;
    bMenuFiscal: Boolean;
    function ListarAdquirentes(SelecionarUnicaCadastrada: Boolean): Boolean;
    function ListarTEFAtivos(SelecionarUnicoCadastrado: Boolean): Boolean;
    property TipoForm: TTipoForm read FTipoForm write FTipoForm;
    property FuncoesAdmTEF: Boolean read FbFuncoesADM write FbFuncoesADM;
  end;

var
  Form10: TForm10;

implementation

uses fiscal, _Small_IntegradorFiscal, ufuncoesfrente, uajustaresolucao;

{$R *.DFM}

procedure TForm10.AcionaTEF;
var
  Mais1Ini : TiniFile;
begin
  //
  // Form10 devera devolver sDiretorio, sResp, sReq, sExec
  //

  Mais1ini := TIniFile.Create('FRENTE.INI');
  Mais1Ini.WriteString('Frente de caixa','TEF USADO',Form10.sNomeDoTEF);
  //
  Form1.sDiretorio := AllTrim(Mais1Ini.ReadString(Form10.sNomeDoTEF,'Pasta','XXXXXXXX'));
  Form1.sReq       := AllTrim(Mais1Ini.ReadString(Form10.sNomeDoTEF,'Req','REQ'));
  Form1.sResp      := AllTrim(Mais1Ini.ReadString(Form10.sNomeDoTEF,'Resp','RESP'));
  Form1.sExec      := AllTrim(Mais1Ini.ReadString(Form10.sNomeDoTEF,'Exec','XXX.XXX'));
  Mais1Ini.Free;
end;

procedure TForm10.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  case FTipoForm of
    tfTEF:
      begin

        AcionaTEF;

        {
        if ModalResult = mrOk then
          AcionaTEF;
        {Sandro Silva 2023-06-05 fim}
      end;
    tfPOS:
      begin
        //
      end;
    tfAdquirente:
      begin
        //
      end;
    tfFabricanteSAT:
      begin
        //
      end;
  end;
end;

procedure TForm10.FormActivate(Sender: TObject);
var
  Mais1Ini: TIniFile;
  sSecoes :  TStrings;
  I, J : Integer;
begin
  // LogFrente('Teste 01: Entrando form10.activate');
  bMenuFiscal := False;// Sandro Silva 2017-11-07 Polimig
  Form10.Visible := False; // Para usuário não ver o form sendo redimensionado
  ListBox1.Clear;
  Form10.Height := 1;
  sSecoes  := TStringList.Create;
  Mais1ini := TIniFile.Create('FRENTE.INI');
  Mais1Ini.ReadSections(sSecoes);

  case FTipoForm of
    tfTEF:
      begin
        ListarTEFAtivos(False); // Sandro Silva 2022-06-24
      end;
    tfPOS:
      begin

        J := 0;

        for I := 0 to (sSecoes.Count - 1) do
        begin
          if Mais1Ini.ReadString(sSecoes[I],'CARTAO ACEITO','NAO') = 'SIM' then
          begin
            ListBox1.Items.Add(sSecoes[I]);
            if Form10.sNomeDoTEF = sSecoes[I] then
              ListBox1.ItemIndex := J;
            J := J + 1;
          end;
        end;

      end;
    tfAdquirente:
      begin
        ListarAdquirentes(False);
      end;
    tfFabricanteSAT:
      begin
        ListBox1.Items.Add('0101 - DIMEP D-SAT');
        ListBox1.Items.Add('0102 - DIMEP D-SAT2.0');
        ListBox1.Items.Add('0201 - SWEDA SS1000');
        ListBox1.Items.Add('0202 - SWEDA SS-2000');
        ListBox1.Items.Add('0301 - TANCA TS-1000');
        ListBox1.Items.Add('0401 - GERTEC GerSat');
        ListBox1.Items.Add('0402 - GERTEC GerSAT-W ');
        ListBox1.Items.Add('0501 - URANO SAT UR');
        ListBox1.Items.Add('0502 - URANO U-S@T');
        ListBox1.Items.Add('0601 - BEMATECH RB-1000 ');
        ListBox1.Items.Add('0602 - BEMATECH RB-2000');
        ListBox1.Items.Add('0701 - ELGIN Linker');
        ListBox1.Items.Add('0702 - ELGIN LinkerII');
        ListBox1.Items.Add('0801 - KRYPTUS EASYS@T');
        ListBox1.Items.Add('0901 - NITERE NSAT4200');
        ListBox1.Items.Add('1001 - DARUMA DS-100i');
        ListBox1.Items.Add('1101 - EPSON SAT-A10');
        ListBox1.Items.Add('1201 - CONTROL ID S@T iD');
      end;
  end;

  if ListBox1.Count > 0 then
  begin
    ListBox1.Ctl3D     := True;
    ListBox1.ItemIndex := 0;
    ListBox1.Ctl3D     := False;
    try
      if ListBox1.CanFocus then
        ListBox1.SetFocus;
    except

    end;
  end;

  //
  AjustaFormCartoes;

  sSecoes.Free; // Sandro Silva 2017-05-19
  Mais1Ini.Free;
  //
  // LogFrente('Teste 01: Saindo do form10.activate');

  if FTipoForm = tfPOS then
  begin
    if Form1.UsaIntegradorFiscal then
      Form1.sNomeRede := ''; // Precisa selecionar a Rede do cartão
  end;

end;

procedure TForm10.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    case FTipoForm of
      tfTEF, tfPOS:
        begin
          SelecionarAdministradora;
          if FTipoForm = tfPOS then
            ModalResult := mrOk; // Sandro Silva 2023-06-05
          if FTipoForm = tfTEF then
            Close;
        end;
      tfAdquirente:
        begin
          SelecionarAdquirente;
          Close;
        end;
    end;
    // Sandro Silva 2023-06-05 Close;
  end;
end;

procedure TForm10.ListBox1DblClick(Sender: TObject);
begin
  case FTipoForm of
    tfTEF, tfPOS:
      begin
        SelecionarAdministradora;

        if FTipoForm = tfPOS then
          ModalResult := mrOk; // Sandro Silva 2023-06-05
        if FTipoForm = tfTEF then
          Close;

      end;
    tfAdquirente:
      begin
        SelecionarAdquirente;
        Close;
      end;
  end;
  // Sandro Silva 2023-06-05 Close;
end;

procedure TForm10.FormShow(Sender: TObject);
var
  Mais1Ini: TIniFile;
  sSecoes :  TStrings;
  I, J : Integer;
begin
  {Sandro Silva 2021-09-21 inicio}
  btnMais.Top  := AjustaAltura(8);
  btnMenos.Top  := btnMais.Top;
  Button3.Top  := btnMais.Top;
  btnMais.Left := AjustaLargura(15);
  Button3.Left := Form10.Width - Button3.Width - btnMais.Left;
  btnMenos.Left := btnMais.Left + btnMais.Width + AjustaLargura(15) + (Form10.Width - btnMais.Width - btnMenos.Width - Button3.Width - AjustaLargura(30)) div 3;
  {Sandro Silva 2021-09-21 fim}

  {Sandro Silva 2023-06-06 inicio}
  ModalResult := mrNone; // Sandro Silva 2023-06-05

  KeyPreview := False;
  if FTipoForm = tfPOS then
    KeyPreview := True;
  {Sandro Silva 2023-06-06 fim}
  //
  sSecoes := TStringList.Create;
  Mais1ini := TIniFile.Create('FRENTE.INI');
  case FTipoForm of
    tfPOS:
      begin

        Mais1Ini.ReadSections(sSecoes);

        J := 0;

        for I := 0 to (sSecoes.Count - 1) do
        begin
          if Mais1Ini.ReadString(sSecoes[I],'CARTAO ACEITO','NAO') = 'SIM' then
          begin
            J := J + 1;
          end;
        end;

        if J=0 then
        begin

          if Mais1Ini.ReadString('VISA CREDITO','CARTAO ACEITO','XXX') = 'XXX' then
          begin
            Mais1Ini.WriteString('VISA CREDITO','CARTAO ACEITO','SIM');
          end;

          if Mais1Ini.ReadString('VISA DEBITO','CARTAO ACEITO','XXX') = 'XXX' then
          begin
            Mais1Ini.WriteString('VISA DEBITO','CARTAO ACEITO','SIM');
          end;
        end;
      end;
    tfTEF:
      begin

      end;
    tfAdquirente:
      begin
        sSecoes.Clear;
        Mais1Ini.ReadSections(sSecoes); //conta o número de itens

        ListBox1.Clear;

        for I := 0 to sSecoes.Count - 1 do
        begin
          if AnsiContainsText(sSecoes.Strings[I], 'ADQUIRENTE') then
          begin
            ListBox1.Items.Add(Mais1Ini.ReadString(sSecoes.Strings[I], 'Nome', ''));

            if Mais1Ini.ReadString(sSecoes.Strings[I], 'Nome', '') = Form1.sUltimaAdquirenteUsada then
              ListBox1.ItemIndex := ListBox1.Count - 1; // Seleciona no LIstBox

          end;
        end;
        ListBox1.SetFocus; // Sandro Silva 2017-05-19
      end;
  end;
  sSecoes.Free;
  Mais1ini.Free;

  Application.ProcessMessages; // Sandro Silva 2023-06-05
  Application.BringToFront; // Sandro Silva 2023-06-05
end;

procedure TForm10.Button3Click(Sender: TObject);
begin

  if AnsiUpperCase(Button3.Caption) = 'OK' then // Sandro Silva 2017-11-07 Polimig
  begin
    try
      case FTipoForm of
        tfTEF, tfPOS:
          begin
            if ListBox1.ItemIndex >= 0 then // não ocorrer exception quando não seleciona um cartão e fecha a tela
              Form10.sNomeDoTEF := ListBox1.Items[ListBox1.ItemIndex];
          end;
        tfAdquirente:
          begin

          end;
      end;
    except end;
  end
  else
    bMenuFiscal := True;// Sandro Silva 2017-11-07 Polimig
  Close;
  //
end;

procedure TForm10.btnMaisClick(Sender: TObject);
var
  Mais1Ini: TIniFile;
  sNovo : String;
begin

  sNovo := 'XXX';
  while sNovo <> '' do
  begin

    sNovo := Form1.Small_InputBox('Incluir cartão','Nome e tipo, exemplo: VISA CREDITO, tecle <OK> em branco para sair:','');
    sNovo := AnsiUpperCase(ConverteAcentos(sNovo));// Acerta o texto se digitado com acento e em minúsculo;

    if (pos('CREDITO',sNovo)<>0) or (pos('DEBITO',sNovo)<>0) then
    begin
      if ListBox1.Items.IndexOf(UpperCase(sNOVO)) > -1 then
      begin
        SmallMsg(sNovo + ' já existe');
        Abort;
      end;
      Mais1ini := TIniFile.Create('FRENTE.INI');
      Mais1Ini.WriteString(UpperCase(sNOVO),'CARTAO ACEITO','SIM');
      Mais1ini.Free;
      Form10.Visible := False;
      ListBox1.Items.Add(sNOVO);
      ListBox1.Update;

      AjustaFormCartoes;

      SmallMsg('Cartão '+sNovo+' aceito.');

    end else
    begin
      if Alltrim(sNovo)<>'' then SmallMsg('Use o nome do cartão + a palavra DEBITO ou CREDITO.');
    end;
  end;
end;

procedure TForm10.btnMenosClick(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin

  if ListBox1.ItemIndex < 0 then
  begin
    SmallMsg('Selecione um cartão');
    Abort;
  end;
  if Application.MessageBox(pChar('Quer realmente excluir da lista'+Chr(10)
                  +'de cartões aceitos o cartão '+Chr(10)
                  +ListBox1.Items[ListBox1.ItemIndex]+'?'+chr(10)
                  +Chr(10)),'Atenção', mb_YesNo + mb_DefButton2 + MB_ICONWARNING) =  IDYES then
  begin
    Mais1ini := TIniFile.Create('FRENTE.INI');
    Mais1ini.EraseSection(ListBox1.Items[ListBox1.ItemIndex]);
    Mais1ini.Free;
    ListBox1.DeleteSelected;
    Form10.Visible := False;
    Form10.Height := Form10.Height - AjustaAltura(30); // Sandro Silva 2021-09-21 Form10.Height - Form1.AjustaAltura(30); // Sandro Silva 2021-08-27 Form10.Height := Form10.Height - 30;
  end;
  AjustaFormCartoes;

end;

procedure TForm10.FormCreate(Sender: TObject);
begin
  // Ajusta tamanho form e posição dos botões
//  Form10.KeyPreview := True; // Sandro Silva 2023-06-05
  AjustaResolucao(Form10);
  Form10.OnPaint := Form10.OnResize;
  Form10.Width   := AjustaLargura(330);

end;

procedure TForm10.FormResize(Sender: TObject);
var
  iAreaBotoes: Integer;
begin
  iAreaBotoes := AjustaAltura(90); // Sandro Silva 2021-09-21Form1.AjustaAltura(90); // Sandro Silva 2021-08-27 iAreaBotoes := 90;
  Form10.Top := (Form1.Height - iAreaBotoes - Form10.Height) div 2; // centralizar janela dos cartões
end;

procedure TForm10.AjustaFormCartoes;
{Sandro Silva 2014-06-30 inicio
Ajusta as dimensões do form dos cartões}
begin
  // Ajusta o form conforme a quantidade de cartões configurados
  Form10.Height := (ListBox1.Items.Count * 30) + AjustaAltura(1); // Sandro Silva 2021-09-21 Form10.Height := (ListBox1.Items.Count * 30) + Form1.AjustaAltura(1);

  //Ajusta altura quando botões estão visíveis
  if pnBotoes.Visible then
    Form10.Height := Form10.Height + AjustaAltura(40); // Sandro Silva 2021-09-21  Form10.Height := Form10.Height + Form1.AjustaAltura(40); // Sandro Silva 2021-08-27 40;

  if (Form10.Height) > AjustaAltura(400) then // Sandro Silva 2021-09-21 if (Form10.Height) > Form1.AjustaAltura(400) then
    Form10.Height := AjustaAltura(400); // Sandro Silva 2021-09-21 Form10.Height := Form1.AjustaAltura(400);

  Form10.Visible := True; // Para usuário não ver o form sendo redimensionado
end;

procedure TForm10.SelecionarAdministradora;
var
  bAutorizacao: Boolean; // Sandro Silva 2018-10-22
begin
  bAutorizacao := False;
  try

    if ListBox1.ItemIndex >= 0 then // não ocorrer exception quando não seleciona um cartão e fecha a tela
    begin
      Form10.sNomeDoTEF := ListBox1.Items[ListBox1.ItemIndex];
      if (Form10.pnBotoes.Visible = False) and (Form1.sTef <> 'Sim') then
      begin
        {Sandro Silva 2022-06-15 inicio}
        Form1.sTransaca := '';
        Form1.sAutoriza := ''; // Sandro Silva 2018-07-03
        Form1.sNomeRede := Trim(StringReplace(StringReplace(AnsiUpperCase(ConverteAcentos(ListBox1.Items[ListBox1.ItemIndex])), 'CREDITO', '', [rfReplaceAll]), 'DEBITO', '', [rfReplaceAll]));
        Form1.sTipoParc := '0';
        Form1.sParcelas := '1';
        {Sandro Silva 2022-06-15 fim}

        if (Form1.sIdentificaPOS = 'Sim') or (Form1.UsaIntegradorFiscal()) then // Sandro Silva 2018-08-06 if (Form1.sIdentificaPOS = 'Sim') then
        begin
          Form1.sTransaca := '';
          if (Form1.sModeloECF = '65') or (Form1.sModeloECF = '59') or (Form1.sModeloECF = '99')// NFC-e/SAT/MEI
            or (Form1.UsaIntegradorFiscal()) // No Ceará usa integrador fiscal, é obrigatório para NFC-e e MFE
            then // Número de autorização apenas quando NFC-e
          begin

            while (Trim(Form1.sTransaca) = '') do
            begin
              if Form1.UsaIntegradorFiscal() then
                Form1.sTransaca := Form1.Small_InputBox('AUTORIZAÇÃO','Insira agora o cartão no terminal POS e realize a transação' + #13 + 'Informe o número da AUTORIZAÇÃO para operação com POS ' + Form1.IntegradorCE.SerialPOS + ':', Form1.sTransaca)
              else
                Form1.sTransaca := Form1.Small_InputBox('AUTORIZAÇÃO','Informe o número da AUTORIZAÇÃO para operação com POS:', Form1.sTransaca);

              if (Trim(Form1.sTransaca) <> '') or (AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString) <> 'CE') then
              begin
                bAutorizacao := True;
                Break;
              end
              else
              begin
                if (AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString) = 'CE') then
                begin
                  if Form1.TransacoesCartao.Transacoes.Count = 0 then
                    SmallMsg('O Número da Autoriação é necessária para forma de pagamento cartão' + #13 + #13 + 'Solicite outro cartão ' + #13 + #13 + 'ou informe 0,00 no valor de pagamento para finalizar em outra forma')
                  else
                    SmallMsg('O Número da Autoriação é necessária para forma de pagamento cartão' + #13 + #13 + 'Solicite outro cartão ' + #13 + #13 + 'ou informe 0,00 no valor de pagamento para finalizar o valor restante em dinheiro');
                  Break;
                end;
              end;

            end;

          end; //
          Form1.sAutoriza := Form1.sTransaca; // Sandro Silva 2018-07-03

          if bAutorizacao then
          begin
            //Remove acentuação, espaços e texto "DEBITO" e "CREDITO"
            Form1.sNomeRede := Trim(StringReplace(StringReplace(AnsiUpperCase(ConverteAcentos(ListBox1.Items[ListBox1.ItemIndex])), 'CREDITO', '', [rfReplaceAll]), 'DEBITO', '', [rfReplaceAll]));
            Form1.sTipoParc := '0';
            Form1.sParcelas := '1';

            while True do
            begin
              if Form1.UsaIntegradorFiscal() then
                Form1.sParcelas := Trim(Form1.Small_InputBox(PARCELAS_EM_CARTAO, 'Informe o número de PARCELAS para operação com POS ' + Form1.IntegradorCE.SerialPOS + ':', Form1.sParcelas))
              else
                Form1.sParcelas := Trim(Form1.Small_InputBox(PARCELAS_EM_CARTAO, 'Informe o número de PARCELAS para operação com POS:', Form1.sParcelas));

              if StrToIntDef(Form1.sParcelas, 0) > 62 then
              begin
                if Application.MessageBox(PAnsiChar('Número de PARCELAS acima do padrão' + #13 +  #13 +
                                                    'Confirma ' + FormatFloat(',0', StrToIntDef(Form1.sParcelas, 0)) + ' parcelas?' + #13 + #13),
                                          'Alerta',
                                          MB_YESNO + MB_ICONWARNING + MB_DEFBUTTON2) = IDNO then // MB_DEFBUTTON2 para evitar que o usuário avance com Enter sem querer quando não deveria. Caso que informou o número da autorização para o número de parcelas e gerou mais de 100 mil registros no RECEBER
                  Form1.sParcelas := '';
              end;

              try
                // Previnir casos onde é digitado outro número ao invés do número das parcelas, causando exception. Situação ocorreu e gerou mais de 100 mil registros no RECEBER
                Form1.sParcelas := IntToStr(StrToIntDef(Form1.sParcelas, 0));
              except
                on E: Exception do
                begin
                  Application.MessageBox(PAnsiChar('Número de parcelas informado é inválido: ' + Form1.sparcelas), 'Atenção', MB_OK + MB_ICONWARNING);
                  Form1.sParcelas := '';
                end;
              end;

              if (Form1.sParcelas = LimpaNumero(Form1.sParcelas)) and (StrToIntDef(Form1.sParcelas, 0) > 0) then
                Break;
            end;
          end;
        end;
      end;
    end;
  except
  end;
end;

procedure TForm10.SelecionarAdquirente;
var
  IniADQUIRENTE: TIniFile;
  sSecoes :  TStrings;
  I: Integer;
begin
  sSecoes := TStringList.Create;
  IniADQUIRENTE := TIniFile.Create('FRENTE.INI');

  sSecoes.Clear;
  IniADQUIRENTE.ReadSections(sSecoes); //conta o número de itens

  Form1.IntegradorCE.ChaveRequisicao       := '';
  Form1.IntegradorCE.CodigoEstabelecimento := '';

  if UsaKitDesenvolvimentoSAT = False then
  begin
    Form1.IntegradorCE.SerialPOS             := '';
  end;

  for I := 0 to sSecoes.Count - 1 do
  begin
    if AnsiContainsText(sSecoes.Strings[I], 'ADQUIRENTE') then
    begin
      if ListBox1.Items[ListBox1.ItemIndex] = IniADQUIRENTE.ReadString(sSecoes.Strings[I], 'Nome', 'xxx') then
      begin
        if IniADQUIRENTE.ReadString(sSecoes.Strings[I], 'Ativo', 'Sim') = 'Sim' then
        begin
          if (Form1.UsaIntegradorFiscal()) then
          begin
            Form1.IntegradorCE.ChaveRequisicao       := IniADQUIRENTE.ReadString(sSecoes.Strings[I], 'Chave Requisicao', '');
            Form1.IntegradorCE.CodigoEstabelecimento := IniADQUIRENTE.ReadString(sSecoes.Strings[I], 'ID Estabelecimento', '');
            if UsaKitDesenvolvimentoSAT = False then // Usar o ID do Serial POS configurado quando não estiver usando Kit desenvolvimento
              Form1.IntegradorCE.SerialPOS             := IniADQUIRENTE.ReadString(sSecoes.Strings[I], 'Serial POS', '');
          end;

          Form1.sUltimaAdquirenteUsada := ListBox1.Items[ListBox1.ItemIndex];
          sNomeAdquirente := ListBox1.Items[ListBox1.ItemIndex]; // Sandro Silva 2017-09-01
          Break;
        end;
      end;
    end;
  end;
  sSecoes.Free;
  IniADQUIRENTE.Free;
end;

function TForm10.ListarAdquirentes(SelecionarUnicaCadastrada: Boolean): Boolean;
var
  IniADQUIRENTE: TIniFile;
  sSecoes :  TStrings;
  I: Integer;
begin
  Result := False;
  sSecoes  := TStringList.Create;
  IniADQUIRENTE := TIniFile.Create('FRENTE.INI');
  try
    try
      sSecoes.Clear;
      IniADQUIRENTE.ReadSections(sSecoes); //conta o número de itens

      ListBox1.Clear;

      for I := 0 to sSecoes.Count - 1 do
      begin
        if AnsiContainsText(sSecoes.Strings[I], 'ADQUIRENTE') then
        begin
          ListBox1.Items.Add(IniADQUIRENTE.ReadString(sSecoes.Strings[I], 'Nome', ''));
        end;
      end;

      if SelecionarUnicaCadastrada then
      begin
        if ListBox1.Items.Count = 1 then
        begin
          ListBox1.ItemIndex := 0;
          SelecionarAdquirente;
          Result := True;
        end;
      end;
    except

    end;
    if SelecionarUnicaCadastrada = False then
      Result := True;
  finally
    sSecoes.Free;
    IniADQUIRENTE.Free;
  end;
end;

function TForm10.ListarTEFAtivos(
  SelecionarUnicoCadastrado: Boolean): Boolean;
var
  Mais1Ini: TIniFile;
  sSecoes :  TStrings;
  j: Integer;
  I: Integer;
begin

  //Quando tiver apenas 1 tef ativo já vai executar o cliente tef diminuindo um clic ou Enter na tela de TEFs configurados

  Result := False;
  sSecoes  := TStringList.Create;
  Mais1ini := TIniFile.Create('FRENTE.INI');
  try
    try
      sSecoes.Clear;
      Mais1Ini.ReadSections(sSecoes);

      Form10.sNomeDoTEF := AllTrim(Mais1Ini.ReadString('Frente de caixa','TEF USADO','TEF_DISC'));

      J := 0;

      ListBox1.Clear;
      for I := 0 to (sSecoes.Count - 1) do
      begin
        if Mais1Ini.ReadString(sSecoes[I],'bAtivo','Não') = 'Sim' then
        begin
          ListBox1.Items.Add(sSecoes[I]);
          if Form10.sNomeDoTEF = sSecoes[I] then
            ListBox1.ItemIndex := J;
          J := J + 1;
        end;
      end;

      if SelecionarUnicoCadastrado then
      begin
        if ListBox1.Items.Count = 1 then
        begin
          ListBox1.ItemIndex := 0;
          SelecionarAdministradora;
          AcionaTEF;
          Result := True;
        end;
      end;

    except

    end;
    if SelecionarUnicoCadastrado = False then
      Result := True;

  finally
    sSecoes.Free; // Sandro Silva 2017-05-19
    Mais1Ini.Free;
  end;

end;

procedure TForm10.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;
//    Close;
  end;
end;

end.

