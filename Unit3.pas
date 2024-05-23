unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mask, DBCtrls, SMALL_DBEdit, SmallFunc_xe,
  frame_teclado_1, Buttons, DB, IBCustomDataSet, IBQuery
  , uajustaresolucao
  ;

type
  TForm3 = class(TForm)
    Panel2: TPanel;
    Frame_teclado1: TFrame_teclado;
    SMALL_DBEdit1: TSMALL_DBEdit;
    Label5: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Button1: TBitBtn;
    Button2: TBitBtn;
    Label6: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SMALL_DBEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses fiscal, Unit2, Unit22
      , _small_59
      , _small_1
      ,_small_2
      , _small_3
      , _small_12
      , _small_65
      , _small_14
      , _small_15
      , _small_17
      , _small_99
      , StrUtils
      , ufuncoesfrente, uDialogs;

{$R *.DFM}

procedure TForm3.Button1Click(Sender: TObject);
var
  iGnf, iCOO : Integer;
  bSangria, bSuprimento : boolean;
  IBQTEMP: TIBQuery;

  ValorOperacao : double;
begin
  if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99') then
  begin
    if (Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat <= 0) then
    begin
      ShowMessage('Valor inválido: ' + QuotedStr(FormatFloat(',0.00', Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat)));
      SMALL_DBEdit1.SetFocus;
      Exit;
    end;

    {Sandro Silva 2021-02-26 inicio} 
    IBQTEMP := CriaIBQuery(Form1.ibDataSet27.Transaction);
    try
      IBQTEMP.Close;
      IBQTEMP.SQL.Text := ' select sum(coalesce(VALOR, 0)) as VALOR ' +
                          ' from PAGAMENT ' +
                          ' where DATA = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', Date)) +
                          '   and CAIXA = ' + QuotedStr(Form1.sCaixa) +
                          '   and  CLIFOR containing :CLIFOR ';

      if AnsiContainsText(Form3.Caption, TITULO_FORM_SANGRIA) then
        IBQTEMP.ParamByName('CLIFOR').AsString := 'sangria'
      else
        IBQTEMP.ParamByName('CLIFOR').AsString := 'suprimento';

      IBQTEMP.Open;

      if IBQTEMP.FieldByName('VALOR').AsFloat > 0 then
      begin
        if Application.MessageBox(PChar('Hoje já houve ' + Form3.Caption + #10 + #10 + #10 +
                                            'Confirma ' + Form3.Caption + ' de "R$' + FormatFloat(',0.00', Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat) + '?'),
                                 'Atenção', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = idNo then
        begin
          Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat := 0.00;
          SMALL_DBEdit1.SetFocus;
          Exit;
        end;
      end;
    except
    end;
    FreeAndNil(IBQTEMP);
    {Sandro Silva 2021-02-26 fim}
  end;

  if (Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat > 9999) then
  begin // Ficha 4176
    if Application.MessageBox(PChar('Confirma o valor "' + FormatFloat(',0.00', Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat) + '" para ' + Form3.Caption + '?'), 'Atenção', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = idNo then
    begin
      Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat := 0.00;
      SMALL_DBEdit1.SetFocus;
      Exit;
    end;
  end;

  if Form3.Caption = TITULO_FORM_SANGRIA then // Sandro Silva 2021-02-26 if Form3.Caption = 'Retirada de caixa' then
  begin
    bSangria := False;

    if Form1.sModeloECF = '01' then bSangria := _ecf01_Sangria(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
    if Form1.sModeloECF = '02' then bSangria := _ecf02_Sangria(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
    if Form1.sModeloECF = '03' then bSangria := _ecf03_Sangria(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
    if Form1.sModeloECF = '12' then bSangria := _ecf12_Sangria(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
    if Form1.sModeloECF = '14' then bSangria := _ecf14_Sangria(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
    if Form1.sModeloECF = '15' then bSangria := _ecf15_Sangria(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
    if Form1.sModeloECF = '17' then bSangria := _ecf17_Sangria(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
    {Mauricio Parizotto 2024-05-17 Inicio
    if Form1.sModeloECF = '59' then bSangria := _ecf59_Sangria(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
    if form1.sModeloECF = '65' then bSangria := _ecf65_Sangria(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
    if Form1.sModeloECF = '99' then bSangria := _ecf99_Sangria(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
    }

    if Form1.sModeloECF = '59' then bSangria := True;
    if form1.sModeloECF = '65' then bSangria := True;
    if Form1.sModeloECF = '99' then bSangria := True;

    {Sandro Silva 2021-07-22 inicio
    if Form1.sModeloECF = '04' then bSangria := _ecf04_Sangria(Form1.ibDataSet25.FieldByName('ACUMULADO1.AsFloat);
    if Form1.sModeloECF = '05' then bSangria := _ecf05_Sangria(Form1.ibDataSet25.FieldByName('ACUMULADO1.AsFloat);
    if Form1.sModeloECF = '06' then bSangria := _ecf06_Sangria(Form1.ibDataSet25.FieldByName('ACUMULADO1.AsFloat);
    if Form1.sModeloECF = '07' then bSangria := _ecf07_Sangria(Form1.ibDataSet25.FieldByName('ACUMULADO1.AsFloat);
    if Form1.sModeloECF = '08' then bSangria := _ecf08_Sangria(Form1.ibDataSet25.FieldByName('ACUMULADO1.AsFloat);
    if Form1.sModeloECF = '09' then bSangria := _ecf09_Sangria(Form1.ibDataSet25.FieldByName('ACUMULADO1.AsFloat);
    if Form1.sModeloECF = '10' then bSangria := _ecf10_Sangria(Form1.ibDataSet25.FieldByName('ACUMULADO1.AsFloat);
    if Form1.sModeloECF = '11' then bSangria := _ecf11_Sangria(Form1.ibDataSet25.FieldByName('ACUMULADO1.AsFloat);
    }

    {$Region'//// Grava Sangria ////'}
    if bSAngria then
    begin
      // Livro caixa
      try
        Form1.ibDataSet1.Append;
        Form1.ibDataSet1.Edit;
        Form1.ibDataSet1DATA.AsDateTime    := Date;
        Form1.ibDataSet1HISTORICO.AsString := 'Sangria '+ Form1.sTipoDocumento + ' ' + Form1.sCaixa + ' as '+TimetoStr(Time); // Sandro Silva 2019-04-15  Form1.ibDataSet1HISTORICO.AsString := 'Sangria '+ Form1.sTipoDocumento + Form1.sCaixa + ' as '+TimetoStr(Time);
        Form1.ibDataSet1NOME.AsString      := Form1.sPlanoDeContas;
        Form1.ibDataSet1ENTRADA.AsFloat    := Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat;
        Form1.ibDataSet1SAIDA.AsFloat      := 0;
        Form1.ibDataSet1.Post;
      except
        //Mauricio Parizotto 2024-05-07
        on e:exception do
        begin
          MensagemSistema('Erro ao gravar sangria!',msgErro);
          LogFrente('Erro ao gravar sangria no livro caixa. '+e.Message);
        end;
      end;

      try
        Form1.ibDataSet28.Append;

        if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99') then
          iCOO := 0 // Sandro Silva 2016-04-25 Ronei definiu que deve ser zero
        else
          iCOO := StrToInt('0'+Form1.PDV_NumeroDoCupom(True));
        if (Form1.sModeloECF = '03') or (Form1.sModeloECF = '17') then
          iCOO := iCOO - 1;

        // iCCF := iCOO;
        iGNF := iCOO;

        if Form1.sModeloECF = '02' then iGNF := StrToInt('0'+LimpaNumero(_ecf02_GNF(True))); // Ok
        if Form1.sModeloECF = '03' then iGNF := StrToInt('0'+LimpaNumero(_ecf03_GNF(True))); //
        if Form1.sModeloECF = '14' then iGNF := StrToInt('0'+LimpaNumero(_ecf14_GNF(True))); //
        if Form1.sModeloECF = '15' then iGNF := StrToInt('0'+LimpaNumero(_ecf15_GNF(True))); //
        if Form1.sModeloECF = '17' then iGNF := StrToInt('0'+LimpaNumero(_ecf17_GNF(True))); //

        Form1.ibDataSet28.FieldByName('DATA').AsDateTime   := Date;
        Form1.ibDataSet28.FieldByName('PEDIDO').AsString   := FormataNumeroDoCupom(iCOO); // // Sandro Silva 2021-12-01 Form1.ibDataSet28.FieldByName('PEDIDO').AsString   := StrZero(iCOO,6,0); //
        Form1.ibDataSet28.FieldByName('COO').AsString      := FormataNumeroDoCupom(iCOO); // // Sandro Silva 2021-12-01 Form1.ibDataSet28.FieldByName('COO').AsString      := StrZero(iCOO,6,0); //
//        Form1.ibDataSet28.FieldByName('CCF').AsString      := StrZero(iCCF,6,0); //
        Form1.ibDataSet28.FieldByName('GNF').AsString      := FormataNumeroDoCupom(iGnf); // Sandro Silva 2021-12-01 Form1.ibDataSet28.FieldByName('GNF').AsString      := StrZero(iGnf,6,0);
        Form1.ibDataSet28.FieldByName('CAIXA').AsString    := Form1.sCaixa;
        Form1.ibDataSet28.FieldByName('CLIFOR').AsString   := 'Sangria';
        Form1.ibDataSet28.FieldByName('VENDEDOR').AsString := '';
        Form1.ibDataSet28.FieldByName('FORMA').AsString    := '02 Dinheiro';
        Form1.ibDataSet28.FieldByName('VALOR').Asfloat     := Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat;
        Form1.ibDataSet28.FieldByName('HORA').AsString     := FormatDateTime('HH:nn:ss', Time); // Sandro Silva 2018-11-30

        Form1.ibDataSet28.Post;
      except
        //Mauricio Parizotto 2024-05-07
        on e:exception do
        begin
          MensagemSistema('Erro ao gravar sangria!',msgErro);
          LogFrente('Erro ao gravar sangria no pagamento. '+e.Message);
        end;
      end;

      Form1.Demais('CN');
    end;
    {$Endregion}

    if (Form1.sModeloECF = '59')
      or (Form1.sModeloECF = '65')
      or (Form1.sModeloECF = '99')  then
    begin
      ValorOperacao := Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat;
      Commitatudo(True);
    end;

    if Form1.sModeloECF = '59' then _ecf59_Sangria(ValorOperacao);
    if form1.sModeloECF = '65' then _ecf65_Sangria(ValorOperacao);
    if Form1.sModeloECF = '99' then _ecf99_Sangria(ValorOperacao);
    {Mauricio Parizotto 2024-05-17 Fim}
  end else
  begin
    if Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat > 0 then
    begin
      bSuprimento := False;

      if Form1.sModeloECF = '01' then bSuprimento := _ecf01_Suprimento(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
      if Form1.sModeloECF = '02' then bSuprimento := _ecf02_Suprimento(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
      if Form1.sModeloECF = '03' then bSuprimento := _ecf03_Suprimento(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
      if Form1.sModeloECF = '12' then bSuprimento := _ecf12_Suprimento(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
      if Form1.sModeloECF = '14' then bSuprimento := _ecf14_Suprimento(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
      if Form1.sModeloECF = '15' then bSuprimento := _ecf15_Suprimento(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
      if Form1.sModeloECF = '17' then bSuprimento := _ecf17_Suprimento(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
      {Mauricio Parizotto 2024-05-17 Inicio
      if Form1.sModeloECF = '59' then bSuprimento := _ecf59_Suprimento(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
      if form1.sModeloECF = '65' then bSuprimento := _ecf65_Suprimento(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
      if Form1.sModeloECF = '99' then bSuprimento := _ecf99_Suprimento(Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat);
      }
      if Form1.sModeloECF = '59' then bSuprimento := True;
      if form1.sModeloECF = '65' then bSuprimento := True;
      if Form1.sModeloECF = '99' then bSuprimento := True;

      {Sandro Silva 2021-07-22 inicio
      if Form1.sModeloECF = '04' then bSuprimento := _ecf04_Suprimento(Form1.ibDataSet25.FieldByName('ACUMULADO1.AsFloat);
      if Form1.sModeloECF = '05' then bSuprimento := _ecf05_Suprimento(Form1.ibDataSet25.FieldByName('ACUMULADO1.AsFloat);
      if Form1.sModeloECF = '06' then bSuprimento := _ecf06_Suprimento(Form1.ibDataSet25.FieldByName('ACUMULADO1.AsFloat);
      if Form1.sModeloECF = '07' then bSuprimento := _ecf07_Suprimento(Form1.ibDataSet25.FieldByName('ACUMULADO1.AsFloat);
      if Form1.sModeloECF = '08' then bSuprimento := _ecf08_Suprimento(Form1.ibDataSet25.FieldByName('ACUMULADO1.AsFloat);
      if Form1.sModeloECF = '09' then bSuprimento := _ecf09_Suprimento(Form1.ibDataSet25.FieldByName('ACUMULADO1.AsFloat);
      if Form1.sModeloECF = '10' then bSuprimento := _ecf10_Suprimento(Form1.ibDataSet25.FieldByName('ACUMULADO1.AsFloat);
      if Form1.sModeloECF = '11' then bSuprimento := _ecf11_Suprimento(Form1.ibDataSet25.FieldByName('ACUMULADO1.AsFloat);
      }

      {$Region'//// Grava Suprimento ////'}
      if bSuprimento then
      begin
        // Livro caixa
        try
          Form1.ibDataSet1.Append;
          Form1.ibDataSet1.Edit;
          Form1.ibDataSet1DATA.AsDateTime    := Date;
          Form1.ibDataSet1HISTORICO.AsString := 'Suprimento '+Form1.sTipoDocumento + ' ' + Form1.sCaixa+ ' as '+TimetoStr(Time); // Sandro Silva 2019-04-15 Form1.ibDataSet1HISTORICO.AsString := 'Suprimento '+Form1.sTipoDocumento + Form1.sCaixa+ ' as '+TimetoStr(Time);
          Form1.ibDataSet1NOME.AsString      := Form1.sPlanoDeContas;
          Form1.ibDataSet1ENTRADA.AsFloat    := 0;
          Form1.ibDataSet1SAIDA.AsFloat      := Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat;
          Form1.ibDataSet1.Post;
        except
          //Mauricio Parizotto 2024-05-07
          on e:exception do
          begin
            MensagemSistema('Erro ao gravar suprimento!',msgErro);
            LogFrente('Erro ao gravar suprimento no livro caixa. '+e.Message);
          end;
        end;

        try
          Form1.ibDataSet28.Append;

          if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99') then
            iCOO := 0 // Sandro Silva 2016-04-25 Ronei definiu que deve ser zero
          else
            iCOO := StrToInt('0'+Form1.PDV_NumeroDoCupom(True));
          if (Form1.sModeloECF = '03') or (Form1.sModeloECF = '17') then
            iCOO := iCOO - 1;

          iGNF := iCOO;

          if Form1.sModeloECF = '02' then iGNF := StrToInt('0'+LimpaNumero(_ecf02_GNF(True))); // Ok
          if Form1.sModeloECF = '03' then iGNF := StrToInt('0'+LimpaNumero(_ecf03_GNF(True))); //
          if Form1.sModeloECF = '14' then iGNF := StrToInt('0'+LimpaNumero(_ecf14_GNF(True))); //
          if Form1.sModeloECF = '15' then iGNF := StrToInt('0'+LimpaNumero(_ecf15_GNF(True))); //
          if Form1.sModeloECF = '17' then iGNF := StrToInt('0'+LimpaNumero(_ecf17_GNF(True))); //          
          //
          Form1.ibDataSet28.FieldByName('DATA').AsDateTime   := Date;
          Form1.ibDataSet28.FieldByName('PEDIDO').AsString   := FormataNumeroDoCupom(iCOO); // // Sandro Silva 2021-12-01 Form1.ibDataSet28.FieldByName('PEDIDO').AsString   := StrZero(iCOO,6,0); //
          Form1.ibDataSet28.FieldByName('COO').AsString      := FormataNumeroDoCupom(iCOO); // // Sandro Silva 2021-12-01 Form1.ibDataSet28.FieldByName('COO').AsString      := StrZero(iCOO,6,0); //
//          Form1.ibDataSet28.FieldByName('CCF').AsString      := StrZero(iCCF,6,0); //
          Form1.ibDataSet28.FieldByName('GNF').AsString      := FormataNumeroDoCupom(iGnf); // Sandro Silva 2021-12-01 Form1.ibDataSet28.FieldByName('GNF').AsString      := StrZero(iGnf,6,0);
          Form1.ibDataSet28.FieldByName('CAIXA').AsString    := Form1.sCaixa;
          Form1.ibDataSet28.FieldByName('CLIFOR').AsString   := 'Suprimento';
          Form1.ibDataSet28.FieldByName('VENDEDOR').AsString := '';
          Form1.ibDataSet28.FieldByName('FORMA').AsString    := '02 Dinheiro';
          Form1.ibDataSet28.FieldByName('VALOR').Asfloat     := Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat;
          Form1.ibDataSet28.FieldByName('HORA').AsString     := FormatDateTime('HH:nn:ss', Time); // Sandro Silva 2018-11-30

          Form1.ibDataSet28.Post;
        except
          //Mauricio Parizotto 2024-05-07
          on e:exception do
          begin
            MensagemSistema('Erro ao gravar suprimento!',msgErro);
            LogFrente('Erro ao gravar suprimento no pagamento. '+e.Message);
          end;
        end;

        Form1.Demais('CN');
      end;
      {$Endregion}

      if (Form1.sModeloECF = '59')
        or (Form1.sModeloECF = '65')
        or (Form1.sModeloECF = '99')  then
      begin
        ValorOperacao := Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat;
        Commitatudo(True);
      end;

      if Form1.sModeloECF = '59' then _ecf59_Suprimento(ValorOperacao);
      if form1.sModeloECF = '65' then _ecf65_Suprimento(ValorOperacao);
      if Form1.sModeloECF = '99' then _ecf99_Suprimento(ValorOperacao);
      {Mauricio Parizotto 2024-05-17 Fim}
    end;
  end;


  Close;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm3.FormActivate(Sender: TObject);
var
  I : Integer;
  sTexto: String;
begin
  Label1.Visible := False;
  Label2.Visible := False;
  Label4.Visible := False;
  if (Form3.Caption = TITULO_FORM_SANGRIA) then // Sandro Silva 2021-02-26 if (Form3.Caption = 'Retirada de caixa') then
    sTexto := 'Informe o valor da '
  else
    sTexto := 'Informe o valor do ';
  Label6.Caption := sTexto + ' ' + Form3.Caption + ' e clique  <Avançar>  para continuar';

  Form3.Frame_teclado1.Led_REDE.Picture   := Form1.Frame_teclado1.Image_led_verde.Picture;
  Form3.Frame_teclado1.Led_FISCAL.Picture := Form1.Frame_teclado1.Image_led_verde.Picture;
  Form3.Frame_teclado1.Led_ECF.Picture    := Form1.Frame_teclado1.Image_led_verde.Picture;

  if (Form1.sSangria <> '999.999,99') and (Form3.Caption = TITULO_FORM_SANGRIA) then // Sandro Silva 2021-02-26 if (Form1.sSangria <> '999.999,99') and (Form3.Caption = 'Retirada de caixa') then
  begin
    Label3.Caption := 'Valor de sangria criptografado:'+Chr(10)+'R$ ###.###,##';
    SMALL_DBEdit1.Visible := False;
    Button1.SetFocus;
  end else
  begin
    SMALL_DBEdit1.SetFocus;
  end;

  if Form1.iGAveta <> 0 then
  begin
    // ------------- //
    // Abre a gaveta //
    // ------------- //
    Form1.PDV_AbreGaveta(False);

    if Form1.sGaveta <> '128' then
    begin
      for I := 1 to 10 do
      begin
        if Form1.sGaveta <> '255' then
        begin

          Form1.sGaveta := Form1.PDV_StatusGaveta(True);

          if I = 5 then ShowMessage('Verifique se a gaveta não está chaveada.');
        end;
      end;
    end;

    if Form1.sGaveta = '255' then
      Form1.Label_7.Caption := 'Gaveta aberta'
    else
      Form1.Label_7.Caption := '';

  end;

  if (Form1.sModeloECF_Reserva <> '59') and (Form1.sModeloECF_Reserva <> '65') and (Form1.sModeloECF_Reserva <> '99') then
  begin
    if Form3.Focused = False then
      Form3.BringToFront;// Ficha 4588 Form ficando por trás da aplicação Sandro Silva 2019-04-12
  end;
end;

procedure TForm3.SMALL_DBEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(13) then Button1.SetFocus;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I : Integer;
begin
  // Só libera depois que a gaveta for fechada
  Button1.Enabled := False;
  Button2.Enabled := False;

  Screen.Cursor := crHourGlass; // Cursor de Aguardo

  I := 1;

  if Form1.iGAveta <> 0 then
  begin
    Form1.Display('Feche a gaveta'+Replicate('.',I),'Gaveta aberta');
    while Form1.sGaveta = '255' do
    begin
      I := I + 1;
      if I > 10 then I := 1;

      Form1.lbDisplayPDV.Caption := 'Feche a gaveta'+Replicate('.',I);
      Form1.lbDisplayPDV.Repaint;

      Form1.sGaveta := Form1.PDV_StatusGaveta(True);
    end;
  end;

  Form1.Label_7.Caption := '';
  Button1.Enabled := True;
  Button2.Enabled := True;
  Screen.Cursor := crDefault; // Cursor normal
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  AjustaResolucao(Form3);// Sandro Silva 2016-08-19
  AjustaResolucao(Form3.Frame_teclado1);// Sandro Silva 2016-08-19
  Form3.Width  := AjustaLargura(Form3.Width);// Sandro Silva 2016-08-19
  Form3.Height := AjustaAltura(Form3.Height);// Sandro Silva 2016-08-19
  if Form3.Top < 0 then
    Form3.Top := 0;

  Label5.Width := SMALL_DBEdit1.Width; // Sandro Silva 2016-08-29
end;

end.


