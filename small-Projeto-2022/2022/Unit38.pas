// Unit de relat�rios
unit Unit38;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, IniFiles, smallfunc_xe, ShellApi, checklst,
  Mask, DBCtrls, SMALL_DBEdit, Unit7, Buttons, StrUtils, FileCtrl, IBX.IBQuery;

const _RelatorioVendaEstado = 'Relat�rio de vendas por estado (Nota Fiscal)';

type
  TForm38 = class(TForm)
    Panel2: TPanel;
    Image1: TImage;
    btnVoltar: TBitBtn;
    btnAvancar: TBitBtn;
    btnCancelar: TBitBtn;
    Panel5: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    MonthCalendar1: TMonthCalendar;
    pnlSelOperacoes: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Panel3: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    RadioButton1: TRadioButton;
    rbItemPorITem: TRadioButton;
    chkOperacoes: TCheckListBox;
    Edit1: TEdit;
    Label17: TLabel;
    Panel1: TPanel;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Panel6: TPanel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    ComboBox1: TComboBox;
    cbListarCodigos: TCheckBox;
    btnMarcarTodos: TBitBtn;
    btnDesmarcarTodos: TBitBtn;
    pnlOSTipoFiltro: TPanel;
    rbDataCriacao: TRadioButton;
    rbDataAgendada: TRadioButton;
    rbDataFechada: TRadioButton;
    procedure btnAvancarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbItemPorITemClick(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure btnMarcarTodosClick(Sender: TObject);
    procedure btnDesmarcarTodosClick(Sender: TObject);
  private
    function StrToFloatFormat(sFormato: String; Valor: Real): Real;
    procedure DefinirEnabledListarCodigo;
    procedure RelatorioBalanca(var F: TextFile);
    procedure RelatorioProdutosMonofasicos(var F: TextFile; dInicio, dFinal : TdateTime);
    procedure RelatorioPisCofinsNfe(var F: TextFile; dInicio, dFinal: TdateTime);
    procedure RelatorioPisCofinsCupom(var F: TextFile; dInicio, dFinal: TdateTime);
    procedure RelatorioCompleRestICMS_ST(var F: TextFile; dInicio, dFinal: TdateTime);
    procedure RelatorioIPI(var F: TextFile; dInicio, dFinal : TdateTime);
    procedure RelatorioServicos(var F: TextFile; dInicio, dFinal : TdateTime);
    procedure RelatorioServicosTecnico(var F: TextFile; dInicio,  dFinal: TdateTime);
    procedure RelatorioVendasVendedor(var F: TextFile; dInicio, dFinal: TdateTime);
    procedure RelatorioPrevisaoCompra(var F: TextFile; dInicio, dFinal: TdateTime);
    procedure RelatorioResumoCompra(var F: TextFile; dInicio, dFinal: TdateTime);
    procedure RelatorioVendasPara(var F: TextFile; dInicio, dFinal: TdateTime);
    procedure RelatorioResumoVendas(var F: TextFile; dInicio, dFinal: TdateTime);
    procedure RelatorioAuditoria(var F: TextFile; dInicio, dFinal: TdateTime);
    procedure RelatorioCurvaABC_Clientes(var F: TextFile; dInicio, dFinal: TdateTime);
    procedure RelatorioCurvaABC_Estoque(var F: TextFile; dInicio, dFinal: TdateTime);
    procedure RelatorioRankingClientes(var F: TextFile; dInicio, dFinal: TdateTime);
    procedure RelatorioRankingDevedores(var F: TextFile; dInicio, dFinal: TdateTime);
    procedure RelatorioPecasOSAberta(var F: TextFile; dInicio, dFinal: TdateTime);
    procedure RelatorioRomaneioCargas(var F: TextFile; dInicio, dFinal: TdateTime);
    procedure RelatorioRomaneioEntregas(var F: TextFile; dInicio, dFinal: TdateTime);
    procedure RelatorioProdutosMonofasicosCupom(var F: TextFile; dInicio, dFinal: TdateTime);
    procedure RelatorioVendasCupom(var F: TextFile; dInicio,  dFinal: TdateTime);
    procedure RelatorioOrcamentosPendentes(var F: TextFile; dInicio, dFinal: TdateTime);
    procedure RelatorioVenda(var F: TextFile; dInicio, dFinal: TdateTime; var fTotal, fTotal1, fTotal2, fTotal3, fTotal4, fTotal5, fTotal6  : Real);
    procedure RelatorioCompras(var F: TextFile; dInicio, dFinal: TdateTime; var fTotal, fTotal1, fTotal2, fTotal3, fTotal4, fTotal5, fTotal6  : Real);
    procedure RelatorioComprasItem(var F: TextFile; dInicio, dFinal: TdateTime; var fTotal, fTotal1, fTotal2, fTotal3, fTotal4, fTotal5, fTotal6  : Real);
    procedure RelatorioVendaItem(var F: TextFile; dInicio, dFinal: TdateTime; var fTotal, fTotal1, fTotal2, fTotal3, fTotal4, fTotal5, fTotal6  : Real);
    procedure RelatorioComprasVenda(var F: TextFile; dInicio, dFinal: TdateTime);
    function TestarNomeArquivoValido(AcCaminho: String): Boolean;
    procedure RelatorioVendaEstado(var F: TextFile; dInicio, dFinal: TdateTime);
    procedure ListaOperacoesMarcadas(var F: TextFile);
    procedure ListaPeiodoSelecionado(var F: TextFile; dInicio, dFinal : TdateTime);
    procedure GeraNomeRelatorio(var F: TextFile; sNome:string);
    procedure RodapePadrao(var F: TextFile; tInicio : tTime);
    procedure GeraRelatorioVendaEstado(var F: TextFile; dInicio, dFinal: TdateTime);
    function GetFiltroOperacao(sAliasTabela: string): string;
  public
  end;

var
  Form38: TForm38;

const
  _cRelVendaCupom = 'Relat�rio de vendas (Cupom Fiscal)';

implementation

uses 
  Mais
  , Unit34
  , Unit30
  , Unit16
  , Mais3
  , Unit2
  , uFuncoesRetaguarda
  , uRateioVendasBalcao
  , IBCustomDataSet
  , uAtualizaNovoCampoItens001CSOSN
  , uArquivosDAT
  , uDialogs
  , uSmallResourceString
  , uSmallConsts
  , uConectaBancoSmall
  ;

{$R *.DFM}


function FechaForm38(sP1: Boolean): Boolean;
var
  bMostra: Boolean;
begin
  if Form38.Tag = 1 then
  begin
    Form38.Tag := 0;

    if Form38.Caption = 'Cancelar' then bMostra := False else bMostra := True;

    Form38.Close;

    if Form7.sModulo <> 'Auditoria' then
    begin
      if (Form7.sModulo <> 'Hist�rico') and (Form7.sModulo <> 'CONTATOS') then
      begin
        Form7.sModulo := Form7.sModuloAnterior;
        Form7.Close;
        Form7.Show;
      end;
    end;

    if (Form7.sModulo <> 'Hist�rico') then
    begin
      if Form1.bHtml1 then
      begin
        if bMostra then if FileExists(Senhas.UsuarioPub+'.HTM') then AbreArquivoNoFormatoCerto(Senhas.UsuarioPub);
      end else
      begin
        if bMostra then
        begin
          if FileExists(Senhas.UsuarioPub+'.txt') then
          begin
            Sleep(100);
            AssinaturaDigital(pChar(Senhas.UsuarioPub+'.txt'));
            Sleep(100);
            ShellExecute( 0, 'Open',pChar(Senhas.UsuarioPub+'.txt'),'', '', SW_SHOW);
          end;
        end;
      end;
    end;
  end;

  Result := True;
end;

procedure TForm38.btnAvancarClick(Sender: TObject);
var
  F: TextFile;
  dInicio, dFinal : TdateTime;
  sReg4 : String;
  tInicio : tTime;
begin
  tInicio := Time;

  if Form7.sModulo <> 'Auditoria' then
  begin
    sReg4 := Form7.ibDataSet4REGISTRO.AsString;

    Form7.ibDataSet2.DisableControls;
    Form7.ibDataSet4.DisableControls;
    Form7.IBDataSet15.DisableControls;
    Form7.ibDataSet16.DisableControls;
    Form7.ibDataSet23.DisableControls;
    //LogRetaguarda('unit38 ibDataSet23.EnableControls 187'); // Sandro Silva 2023-12-04
    Form7.IBDataSet24.DisableControls;

    //LogRetaguarda('ibDataSet24.DisableControls; 189'); // Sandro Silva 2023-11-27

    Form7.ibDataSet27.DisableControls;
    Form7.ibDataSet35.DisableControls;
    Form7.ibDataSet99.DisableControls;
  end;

  if FileExists(Senhas.UsuarioPub+'.HTM') then
    DeleteFile(Senhas.UsuarioPub+'.HTM');

  if FileExists(Senhas.UsuarioPub+'.txt') then
    DeleteFile(Senhas.UsuarioPub+'.txt');

  //if Form7.sModulo = 'BALANCA' then Mauricio Parizotto 2024-05-16
  if Form7.sModulo = 'Balan�as' then
  begin
    RelatorioBalanca(F);
  end else
  begin
    if (Form7.sModulo <> 'CLIENTES')
      and (Form7.sModulo <> 'FORNECED')
      and (Form7.sModulo <> 'CONTAS')
      and (Form7.sModulo <> 'CONTATOS') then
    begin
      //Filtro Por Opera��o
      if (chkOperacoes.Visible = False)
        and ((Form7.sModulo = 'Relat�rio de vendas')
          or (Form7.sModulo = 'Relat�rio de compras')
          or (Form7.sModulo = 'Resumo das vendas')
          or (Form7.sModulo = 'Curva ABC de clientes') // Mauricio Parizotto 2023-05-24
          or (Form7.sModulo = _RelatorioVendaEstado) //Mauricio Parizotto 2024-05-31
          ) then
      begin
        // Cria um item para cada opera��o de venda
        //btnVoltar.Enabled        := True; Mauricio Parizotto
        btnVoltar.Visible        := True;
        chkOperacoes.Visible     := True;
        pnlSelOperacoes.Visible  := True;
        pnlSelOperacoes.BringToFront;

        btnAvancar.Caption := 'Gerar';

        Form7.ibDataSet14.Close;
        Form7.ibDataSet14.SelectSql.Clear;
        Form7.ibDataSet14.SelectSql.Add('select * from ICM order by CFOP');
        Form7.ibDataSet14.Open;
        Form7.ibDataSet14.First;

        chkOperacoes.Items.Clear;

        while (not Form7.ibDataSet14.EOF) and (Form38.Caption <> 'Cancelar') do
        begin
          Application.ProcessMessages;

          //if ((Form7.sModulo = 'Relat�rio de vendas') or (Form7.sModulo = 'Resumo das vendas')) then
          if (Form7.sModulo = 'Relat�rio de vendas')
              or (Form7.sModulo = 'Resumo das vendas')
              or (Form7.sModulo = _RelatorioVendaEstado) //Mauricio Parizotto 2024-05-31
              or (Form7.sModulo = 'Curva ABC de clientes') then
          begin
            if (Copy(Form7.ibDataSet14CFOP.AsString,1,1) = '5') or (Copy(Form7.ibDataSet14CFOP.AsString,1,1) = '6') or (Copy(Form7.ibDataSet14CFOP.AsString,1,1) = '7') then
            begin
              if AllTrim(Form7.ibDataSet14NOME.AsString) <> '' then
              begin
                chkOperacoes.Items.add(Form7.ibDataSet14NOME.AsString);
                if (Copy(AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.Value),1,5) = 'CAIXA') or (Copy(AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.Value),1,7) = 'RECEBER') then
                begin
                  chkOperacoes.Checked[(chkOperacoes.Items.Count -1)] := True;
                end else
                begin
                  chkOperacoes.Checked[(chkOperacoes.Items.Count -1)] := False;
                end;
              end;
            end;
          end;

          if (Form7.sModulo = 'Relat�rio de compras') then
          begin
            if (Copy(Form7.ibDataSet14CFOP.AsString,1,1) = '1') or (Copy(Form7.ibDataSet14CFOP.AsString,1,1) = '2') or (Copy(Form7.ibDataSet14CFOP.AsString,1,1) = '3') then
            begin
              if AllTrim(Form7.ibDataSet14NOME.AsString) <> EmptyStr then
              begin
                chkOperacoes.Items.add(Form7.ibDataSet14NOME.AsString);

                if (Copy(AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.Value),1,5) = 'CAIXA') or (Copy(AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.Value),1,5) = 'PAGAR') then
                begin
                  chkOperacoes.Checked[(chkOperacoes.Items.Count -1)] := True;
                end else
                begin
                  chkOperacoes.Checked[(chkOperacoes.Items.Count -1)] := False;
                end;
              end;
            end;
          end;

          Form7.ibDataSet14.Next;
        end;
      end else
      begin
        Screen.Cursor  := crAppStart;

        FormatSettings.ShortDateFormat := 'dd/mm/yyyy';

        dInicio :=  DateTimePicker1.Date;
        dFinal  :=  DateTimePicker2.Date;

        dInicio := StrToDate(DateToStr(dInicio));
        dFinal  := StrToDate(DateToStr(dFinal ));

        if Form1.bHtml1 then
        begin
          DeleteFile(pChar(Senhas.UsuarioPub+'.HTM'));
          AssignFile(F,pChar(Senhas.UsuarioPub+'.HTM'));
          try
            Rewrite(F);                           // Abre para grava��o
          except
            ShowMessage('N�o foi poss�vel gravar no arquivo .HTM   '+Chr(10)+Chr(10)+'Este programa ser� fechado.');
            Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
            Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
            FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
          end;

          CriaJpg('logotip.jpg');
          Writeln(F,'<html><head><title>'+AllTrim(Form7.ibDataSet13NOME.AsString) + ' - '+Form7.sModulo+'</title></head>');
          WriteLn(F,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>');
          WriteLn(F,'<img src="logotip.jpg" alt="'+AllTrim(Form7.ibDataSet13NOME.AsString)+'">');
          WriteLn(F,'<br><font size=3 color=#000000><b>'+AllTrim(Form7.ibDataSet13NOME.AsString)+'</b></font>');
        end else
        begin
          DeleteFile(pChar(Senhas.UsuarioPub+'.txt'));
          AssignFile(F,pChar(Senhas.UsuarioPub+'.txt'));         // Direciona o arquivo F para RELATO.TXT
          try
            Rewrite(F);                           // Abre para grava��o
          except
            //ShowMessage('N�o foi poss�vel gravar no arquivo .txt   '+Chr(10)+Chr(10)+'Este programa ser� fechado.'); Mauricio Parizotto 2023-10-25
            MensagemSistema('N�o foi poss�vel gravar no arquivo .txt   '+Chr(10)+Chr(10)+'Este programa ser� fechado.',msgAtencao);
            Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
            Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
            FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
          end;

          WriteLn(F,AllTrim(Form7.ibDataSet13NOME.AsString));
          WriteLn(F,'');
        end;

        if Form7.sModulo = 'Relat�rio de produtos monof�sicos (NF-e)' then
        begin
          RelatorioProdutosMonofasicos(F,dInicio,dFinal);
        end;

        if Form7.sModulo = 'Relat�rio de PIS/COFINS (NF-e)' then
        begin
          RelatorioPisCofinsNfe(F,dInicio,dFinal);
        end;

        if Form7.sModulo = 'Relat�rio de PIS/COFINS (Cupom Fiscal)' then
        begin
          RelatorioPisCofinsCupom(F,dInicio,dFinal);
        end;

        if Form7.sModulo = 'Complemento/Restitui��o por ICMS ST' then
        begin
          RelatorioCompleRestICMS_ST(F,dInicio,dFinal);
        end;

        if Form7.sModulo = 'Relat�rio de IPI' then
        begin
          RelatorioIPI(F,dInicio,dFinal);
        end;

        if Form7.sModulo = 'Relat�rio de servi�os' then
        begin
          RelatorioServicos(F,dInicio,dFinal);
        end;

        if Form7.sModulo = 'Relat�rio de servi�os por t�cnico' then
        begin
          RelatorioServicosTecnico(F,dInicio,dFinal);
        end;

        if Form7.sModulo = 'Relat�rio de vendas por vendedor' then
        begin
          RelatorioVendasVendedor(F,dInicio,dFinal);
        end;

        if Form7.sModulo =  'Previs�o de compras' then
        begin
          RelatorioPrevisaoCompra(F,dInicio,dFinal);
        end;

        if Form7.sModulo =  'Resumo das compras' then
        begin
          RelatorioResumoCompra(F,dInicio,dFinal);
        end;

        if Form7.sModulo = 'Vendas para' then
        begin
          RelatorioVendasPara(F,dInicio,dFinal);
        end;

        if Form7.sModulo =  'Resumo das vendas' then
        begin
          RelatorioResumoVendas(F,dInicio,dFinal);
        end;

        if Form7.sModulo =  'Auditoria' then
        begin
          RelatorioAuditoria(F,dInicio,dFinal);
        end;

        if Form7.sModulo = 'Curva ABC de clientes' then
        begin
          RelatorioCurvaABC_Clientes(F,dInicio,dFinal);
        end;

        if Form7.sModulo =  'Curva ABC do estoque' then
        begin
          RelatorioCurvaABC_Estoque(F,dInicio,dFinal);
        end;

        if Form7.sModulo =  'Ranking de clientes' then
        begin
          RelatorioRankingClientes(F,dInicio,dFinal);
        end;

        if Form7.sModulo =  'Ranking de devedores' then
        begin
          RelatorioRankingDevedores(F,dInicio,dFinal);
        end;

        if Form7.sModulo =  'Pe�as em OS abertas' then
        begin
          RelatorioPecasOSAberta(F,dInicio,dFinal);
        end;

        if Form7.sModulo =  'Romaneio de carga' then
        begin
          RelatorioRomaneioCargas(F,dInicio,dFinal);
        end;

        if Form7.sModulo =  'Romaneio de entrega' then
        begin
          RelatorioRomaneioEntregas(F,dInicio,dFinal);
        end;

        if (Form7.sModulo =  'Relat�rio de produtos monof�sicos (Cupom Fiscal)') then
        begin
          RelatorioProdutosMonofasicosCupom(F,dInicio,dFinal);
        end;

        if Form7.sModulo =  'Relat�rio de vendas (Cupom Fiscal)' then
        begin
          RelatorioVendasCupom(F,dInicio,dFinal);
        end;

        if Form7.sModulo =  'Relat�rio de or�amentos pendentes' then
        begin
          RelatorioOrcamentosPendentes(F,dInicio,dFinal);
        end;

        if (Form7.sModulo =  'Relat�rio de compras') or (Form7.sModulo =  'Relat�rio de vendas') then
        begin
          RelatorioComprasVenda(F,dInicio,dFinal);
        end;

        //Mauricio Parizotto 2024-05-31
        if (Form7.sModulo = _RelatorioVendaEstado) then
        begin
          RelatorioVendaEstado(F,dInicio,dFinal);
        end;

        RodapePadrao(F,tInicio);

        CloseFile(F);

        Screen.Cursor  := crDefault; // Cursor de Aguardo

        Form7.ibDataSet2.EnableControls;
        Form7.ibDataSet4.EnableControls;
        Form7.IBDataSet15.EnableControls;
        Form7.ibDataSet16.EnableControls;
        Form7.ibDataSet23.EnableControls;
        //LogRetaguarda('unit38 ibDataSet23.EnableControls 488'); // Sandro Silva 2023-12-04
        Form7.IBDataSet24.EnableControls;
        Form7.ibDataSet27.EnableControls;
        Form7.ibDataSet35.EnableControls;
        Form7.ibDataSet99.EnableControls;

        FechaForm38(True);
      end;
    end;
  end;

  btnAvancar.Enabled := True;

  if (Form7.sModulo = 'CLIENTES') or (Form7.sModulo = 'FORNECED') or (Form7.sModulo = 'CONTAS') or (Form7.sModulo = 'CONTATOS') then
  begin
    Screen.Cursor  := crDefault; // Cursor de Aguardo
    FechaForm38(True);
  end;
  
  if Form7.sModulo <> 'Auditoria' then
  begin
    Form7.ibDataSet4.Locate('REGISTRO',sReg4,[]);

    Form7.ibDataSet2.EnableControls;
    Form7.ibDataSet4.EnableControls;
    Form7.IBDataSet15.EnableControls;
    Form7.ibDataSet16.EnableControls;
    Form7.ibDataSet23.EnableControls;
    //LogRetaguarda('unit38 ibDataSet23.EnableControls 516'); // Sandro Silva 2023-12-04
    Form7.IBDataSet24.EnableControls;

    //LogRetaguarda('Form7.ibDataSet24.EnableControls; 519'); // Sandro Silva 2023-11-27

    Form7.ibDataSet27.EnableControls;
    Form7.ibDataSet35.EnableControls;
    Form7.ibDataSet99.EnableControls;
  end;
end;

procedure TForm38.btnCancelarClick(Sender: TObject);
begin
  Form38.Caption := 'Cancelar';
  {Mauricio Parizotto 2024-03-01 Inicio}
  //FechaForm38(True);
  Form7.sModulo := Form7.sModuloAnterior;
  Form38.Tag    := 0;
  Close;
  {Mauricio Parizotto 2024-03-01 Fim}
end;

procedure TForm38.btnVoltarClick(Sender: TObject);
begin
  //btnVoltar.Enabled       := False; Mauricio Parizotto
  btnVoltar.Visible       := False;
  pnlSelOperacoes.Visible := False;
  chkOperacoes.visible    := False;

  btnAvancar.Caption := 'Avan�ar >'; //Mauricio Parizotto 2024-03-20

  Form38.Caption          := Form7.sModulo;
  if Form7.sModulo =  'Relat�rio de compras' then RadioButton1.Caption := 'Relat�rio de cr�dito de ICMS'
     else RadioButton1.Caption := 'Relat�rio de ICMS';
  if Form7.sModulo = 'CLIENTES' then Form38.CapTion := 'Hist�rico do cliente';

  if Form7.sModulo = 'FORNECED' then Form38.CapTion := 'Hist�rico do fornecedor';

  if Form7.sModulo = 'CONTAS' then
  begin
    btnAvancar.SetFocus;
    Form38.CapTion := 'Plano de contas';
  end;

  if Form7.sModulo = 'CONTATOS' then
  begin
    btnAvancar.SetFocus;
    Form38.CapTion := 'Contatos de hora em hora';
  end;

  if Form7.sModulo = 'Exporta��o de arquivo TXT para balan�a' then
  begin
    if FileExists(Senhas.UsuarioPub+'.HTM') then DeleteFile(Senhas.UsuarioPub+'.HTM');
    if FileExists(Senhas.UsuarioPub+'.txt') then DeleteFile(Senhas.UsuarioPub+'.txt');
    Form38.Tag := 1;
    FechaForm38(True);
  end;
end;

procedure TForm38.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Mais1Ini : TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
  Mais1Ini.WriteString('Outros','Per�odo Inicial',DateToStr(DateTimePicker1.Date));
  Mais1Ini.WriteString('Outros','Per�odo Final',DateToStr(DateTimePicker2.Date));
  Mais1Ini.Free;

  Label25.Visible          := False;
  ComboBox1.Visible        := False;
  Panel6.Visible           := False;
  Panel3.Visible           := False;
  Panel3.Visible           := False;
  Label2.Visible           := False;
  Label3.Visible           := False;
  RadioButton1.Visible     := False;
  rbItemPorITem.Visible    := False;
  cbListarCodigos.Visible  := False;
  cbListarCodigos.Checked  := False;
  DateTimePicker1.Visible  := False;
  DateTimePicker2.Visible  := False;
  Panel1.Visible           := False;
  pnlOSTipoFiltro.Visible  := False; //Mauricio Parizotto 2024-05-14
end;

procedure TForm38.FormCreate(Sender: TObject);
begin
  MonthCalendar1.Date := Date;
end;

procedure TForm38.Edit1Exit(Sender: TObject);
begin
  Edit1.Text := Limpanumero(Edit1.Text);
end;

procedure TForm38.Edit1Change(Sender: TObject);
begin
  Edit1.Text := Limpanumero(Edit1.Text);
end;

procedure TForm38.FormShow(Sender: TObject);
var
  Mais1Ini : TIniFile;
begin
  {Mauricio Parizotto 2024-03-20 Inicio}
  Form38.Tag := 1;

  Image1.Picture := Form7.imgImprimir.Picture;

  if Form7.sModulo = 'Auditoria' then
  begin
    Form38.ComboBox1.Items.Clear;
    try
      Form7.IBDataSet100.Close;
      Form7.IBDataSet100.SelectSQL.Clear;
      Form7.IBDataSet100.SelectSQL.Add('select USUARIO from AUDIT0RIA group by USUARIO');
      Form7.IBDataSet100.Open;
      while not Form7.IBDataSet100.Eof do
      begin
        Form38.ComboBox1.Items.Add(Form7.IBDataSet100.FieldByname('USUARIO').AsString);
        Form7.IBDataSet100.Next;
      end;
    except
    end;
  end;

  Form7.IBDataSet100.Close;

  Form38.ComboBox1.Text := Form2.Usuario.Text;
  if not Form7.ibDataSet4.Active then
    Form7.ibDataSet4.Open;

  Mais1ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
  DateTimePicker1.Date := StrtoDate(Mais1Ini.ReadString('Outros','Per�odo Inicial',DateToStr(Date-360)));
  DateTimePicker2.Date := StrtoDate(Mais1Ini.ReadString('Outros','Per�odo Final',DateToStr(Date)));
  Mais1Ini.Free;
  if Form7.sModulo = 'Ranking de devedores' then
  begin
    Form38.ComboBox1.Items.Clear;
    Form38.ComboBox1.Items.Add('�ltimos tr�s meses');
    Form38.ComboBox1.Items.Add('�ltimos doze meses');
    Form38.ComboBox1.Items.Add('Todos');
    Form38.ComboBox1.ItemIndex := 0;
  end;

  cbListarCodigos.Enabled := False;
  cbListarCodigos.TabStop := False;
  if Form7.sModulo = _cRelVendaCupom then
  begin
    cbListarCodigos.Top := DateTimePicker2.Top + DateTimePicker2.Height + 5;
    cbListarCodigos.Left := DateTimePicker2.Left;
    cbListarCodigos.Enabled := True;
    cbListarCodigos.TabStop := True;
  end else
  begin
    cbListarCodigos.Top  := rbItemPorITem.Top + rbItemPorITem.Height + 5;
    cbListarCodigos.Left := rbItemPorITem.Left + 16;
    DefinirEnabledListarCodigo;
  end;

  btnVoltarClick(btnVoltar);

  btnAvancar.Caption := 'Gerar';

  if (chkOperacoes.Visible = False)
        and ((Form7.sModulo = 'Relat�rio de vendas')
          or (Form7.sModulo = 'Relat�rio de compras')
          or (Form7.sModulo = 'Resumo das vendas')
          or (Form7.sModulo = 'Curva ABC de clientes') // Mauricio Parizotto 2023-05-24
          or (Form7.sModulo = _RelatorioVendaEstado) // Mauricio Parizotto 2024-05-31
          ) then
  begin
    btnAvancar.Caption := 'Avan�ar >';
  end;

  {Mauricio Parizotto 2024-03-20 Fim}
end;

function TForm38.StrToFloatFormat(sFormato: String; Valor: Real): Real;
var
  sValorFormat: String;
begin
  sValorFormat := Format('%10.2n', [(Valor)]);
  sValorFormat := StringReplace(sValorFormat, ' ', '', []);
  sValorFormat := StringReplace(sValorFormat, '.', '', []);
  Result := StrToFloatDef(sValorFormat, 0);
end;

procedure TForm38.DefinirEnabledListarCodigo;
begin
  if Form7.sModulo = _cRelVendaCupom then
    Exit;
  cbListarCodigos.Enabled := rbItemPorITem.Checked;
  cbListarCodigos.TabStop := cbListarCodigos.Enabled;
  if not cbListarCodigos.Enabled then
    cbListarCodigos.Checked := False;
end;

procedure TForm38.rbItemPorITemClick(Sender: TObject);
begin
  DefinirEnabledListarCodigo;
end;

procedure TForm38.RadioButton1Click(Sender: TObject);
begin
  DefinirEnabledListarCodigo;
end;

function TForm38.TestarNomeArquivoValido(AcCaminho: String) : Boolean;
var
  slArq: TStringList;
begin
  Result := False;
  slArq := TStringList.Create;
  try
    try
      slArq.SaveToFile(AcCaminho);

      Sleep(200);

      if not FileExists(AcCaminho) then
      begin
        MensagemSistema(_cArquivoInvalidoBalanca, msgAtencao);
        Exit;
      end
      else
      begin
        DeleteFile(AcCaminho);
        Sleep(200);
      end;
      Result := True;
    except
      MensagemSistema(_cArquivoInvalidoBalanca, msgAtencao);
    end;
  finally
    FreeAndNil(slArq);
  end;
end;

procedure TForm38.RelatorioBalanca(var F: TextFile);
var
  sValidade : string;
  I : integer;
  cNomeArqPadrao: String;
  cCaminho: String;
  cCaminhoExtra: String;
  oDialog: TSaveDialog;
  oArqDat: TArquivosDAT;
begin
  oArqDat := TArquivosDAT.Create(EmptyStr);
  try
    cCaminho := oArqDat.SmallCom.Outros.CaminhoArqBalanca;

    if Radiobutton3.Checked then
      cNomeArqPadrao := 'produtos.txt';  // Urano

    if Radiobutton4.Checked then
      cNomeArqPadrao := 'txitens.txt'; // Toledo

    if Radiobutton5.Checked then
      cNomeArqPadrao := 'cadtxt.txt'; // Filizola


    oDialog := TSaveDialog.Create(nil);
    try
      oDialog.FileName := cCaminho + cNomeArqPadrao;
      oDialog.InitialDir := cCaminho;
      oDialog.Filter := 'Arquivo de Texto (.txt)|*.txt';
      if not oDialog.Execute then
        Exit;

      cCaminho := oDialog.FileName;

      if Copy(cCaminho, Length(cCaminho)-3, 4) <> '.txt' then
        cCaminho := cCaminho + '.txt';

      oArqDat.SmallCom.Outros.CaminhoArqBalanca := ExtractFilePath(cCaminho);

      if not TestarNomeArquivoValido(cCaminho) then
        Exit;
        
      if Radiobutton5.Checked then
      begin
        cCaminhoExtra := oArqDat.SmallCom.Outros.CaminhoArqBalanca2;

        oDialog.FileName := cCaminhoExtra + 'setortxt.txt';
        oDialog.InitialDir := cCaminhoExtra;

        if not oDialog.Execute then
          Exit;

        cCaminhoExtra := oDialog.FileName;

        if Copy(cCaminho, Length(cCaminho)-3, 4) <> '.txt' then
          cCaminho := cCaminho + '.txt';

        oArqDat.SmallCom.Outros.CaminhoArqBalanca2 := ExtractFilePath(cCaminhoExtra);

        if not TestarNomeArquivoValido(cCaminho) then
          Exit;
      end;
    finally
      FreeAndNil(oDialog);
    end;
  finally
    FreeAndNil(oArqDat);
  end;

  AssignFile(F,pchar(cCaminho));

  Rewrite(F);

  Form7.ibDataSet4.First;
  while not Form7.ibDataSet4.EOF do
  begin
    if (Copy(Form7.ibDataSet4REFERENCIA.AsString,1,1) = '2') and ((UpperCase(Form7.ibDataSet4MEDIDA.AsString) = 'KG') or (UpperCase(Form7.ibDataSet4MEDIDA.AsString) = 'KU')) then
    begin
      if AllTrim(RetornaValorDaTagNoCampo('VAL',form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
        sValidade := AllTrim(RetornaValorDaTagNoCampo('VAL',form7.ibDataSet4.FieldByname('TAGS_').AsString))
      else
        sValidade := '000';

      if UpperCase(Form7.ibDataSet4MEDIDA.AsString) = 'KG' then                                                                                   // Quando � KG pro programa da
      begin                                                                                                                                   // FILISOLA vai um 'P', ai o a balan�a
        if Radiobutton3.Checked then
          Writeln(F,'0'+Form7.ibDataSet4CODIGO.AsString+' 1'+Copy(UpperCase(Form7.ibDataSet4DESCRICAO.AsString)+Replicate(' ',20),1,20)+StrZero(Form7.ibDataSet4PRECO.AsFloat,11,4) + sVAlidade + 'D00000');
        if Radiobutton4.Checked then
          Writeln(F,'010100'+Form7.ibDataSet4CODIGO.AsString+StrTran(StrZero(Form7.ibDataSet4PRECO.AsFloat,7,2)+sValidade,',','')+Copy(UpperCase(Form7.ibDataSet4DESCRICAO.AsString)+Replicate(' ',300),1,300));
        if Radiobutton5.Checked then
          Writeln(F,'0'+Form7.ibDataSet4CODIGO.AsString+'P'+                                                           // gera uma etiqueta com o peso
        Copy(UpperCase(Form7.ibDataSet4DESCRICAO.AsString)+Replicate(' ',22),1,22)+'0'+StrTran(StrZero(Form7.ibDataSet4PRECO.AsFloat,7,2)+sValidade,',',''));  //
      end else
      begin                                                                                                                                   // Quando � KU pro programa
        if Radiobutton3.Checked then
          Writeln(F,'0'+Form7.ibDataSet4CODIGO.AsString+' 6'+Copy(UpperCase(Form7.ibDataSet4DESCRICAO.AsString)+Replicate(' ',20),1,20)+StrZero(Form7.ibDataSet4PRECO.AsFloat,11,4) + sVAlidade + 'D00000');
        if Radiobutton4.Checked then
          Writeln(F,'010110'+Form7.ibDataSet4CODIGO.AsString+StrTran(StrZero(Form7.ibDataSet4PRECO.AsFloat,7,2)+sValidade,',','')+Copy(UpperCase(Form7.ibDataSet4DESCRICAO.AsString)+Replicate(' ',300),1,300));
        if Radiobutton5.Checked then
          Writeln(F,'0'+Form7.ibDataSet4CODIGO.AsString+'U'+                                                           // FILISOLA vai um 'U', ai o balan�a
        Copy(UpperCase(Form7.ibDataSet4DESCRICAO.AsString)+Replicate(' ',22),1,22)+'0'+StrTran(StrZero(Form7.ibDataSet4PRECO.AsFloat,7,2)+sValidade,',',''));  // gera uma etiqueta com a unidade
      end;
    end;
    Form7.ibDataSet4.Next;
  end;

  CloseFile(F);

  if Radiobutton5.Checked then
  begin
    AssignFile(F,pchar(cCaminhoExtra));   // Filizola
    Rewrite(F);                     

    I := 0;
    Form7.ibDataSet4.First;
    while not Form7.ibDataSet4.EOF do
    begin
      if (Copy(Form7.ibDataSet4REFERENCIA.AsString,1,1) = '2') and ((UpperCase(Form7.ibDataSet4MEDIDA.AsString) = 'KG') or (UpperCase(Form7.ibDataSet4MEDIDA.AsString) = 'KU')) then
      begin
        I := I + 1;
        Writeln(F,Copy(UpperCase(Form7.ibDataSet4NOME.AsString)+Replicate(' ',12),1,12)+'0'+Form7.ibDataSet4CODIGO.AsString+Strzero(I,5,0)+'000');
      end;
      Form7.ibDataSet4.Next;
    end;

    CloseFile(F);
    ShellExecute( 0, 'Open', PChar(cCaminhoExtra),'', '', SW_SHOW);
  end;

  ShellExecute( 0, 'Open',PChar(cCaminho),'', '', SW_SHOW);

  Form38.Tag := 1;
  FechaForm38(True);

end;

procedure TForm38.RelatorioProdutosMonofasicos(var F: TextFile; dInicio, dFinal : TdateTime);
var
  fRateioDoDesconto, fTotal1, ftotal2, ftotal3 : Real;
  sCFOP: String;
  bAchouItem: Boolean;
  iItem: Integer;
  aCFOP: array of TCFOP;
  aCSTCSOSN: array of TCSTCSOSN;
  sCSTPISCOFINS: String;
  sCSTCSOSN: String;
  dTotalCFOP: Double;
  dTotalCSTCSOSN: Double;
  dTotalCFOPCSTPISCOFINS: Double;
begin
  {Sandro Silva 2022-10-04 inicio}
  try
    if AtualizaItens001CsosnFromXML(Form7.ibDataSet16.Transaction, dInicio, dFinal) then
    begin
      AgendaCommit(True);
    end;
  except
  end;
  {Sandro Silva 2022-10-04 fim}

  fTotal1  := 0;
  fTotal2  := 0;
  fTotal3  := 0;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Data</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>NF</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>C�digo</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Descri��o</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CST</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>% PIS</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>R$ PIS</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>% COFINS</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>R$ COFINS</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CFOP</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>NCM</font></th>');
    {Sandro Silva 2022-10-13 inicio}
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CST ICMS</font></th>')
    else
      WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CSOSN</font></th>');
    {Sandro Silva 2022-10-13 fim}
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    WriteLn(F,'');
    {Sandro Silva 2022-10-13 inicio
    WriteLn(F,'DATA       NF        DESCRICAO                              TOTAL      CST  % PIS    R$ PIS     % COFINS R$ COFINS  CFOP NCM          ');
    WriteLn(F,'---------- --------- -------------------------------------- ---------- ---- -------- ---------- -------- ---------- ---- -------------');

    }
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
    begin
      WriteLn(F,'DATA       NF        C�DIGO DESCRI��O                              TOTAL      CST  % PIS    R$ PIS     % COFINS R$ COFINS  CFOP NCM           CST ICMS');
      WriteLn(F,'---------- --------- ------ -------------------------------------- ---------- ---- -------- ---------- -------- ---------- ---- ------------- --------');
    end
    else
    begin
      WriteLn(F,'DATA       NF        C�DIGO DESCRI��O                              TOTAL      CST  % PIS    R$ PIS     % COFINS R$ COFINS  CFOP NCM           CSOSN   ');
      WriteLn(F,'---------- --------- ------ -------------------------------------- ---------- ---- -------- ---------- -------- ---------- ---- ------------- --------');
    end;
    {Sandro Silva 2022-10-13 fim}
  end;
  
  Form7.ibQuery99.Close;
  Form7.ibQuery99.SQL.Clear;
  Form7.ibQuery99.SQL.Add('select * from ITENS001 ,VENDAS, ESTOQUE where VENDAS.EMITIDA=''S'' and VENDAS.EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and VENDAS.EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and Coalesce(CST_PIS_COFINS,''XX'')<>''XX'' and VENDAS.NUMERONF=ITENS001.NUMERONF and ITENS001.CODIGO=ESTOQUE.CODIGO order by VENDAS.EMISSAO, VENDAS.NUMERONF');
  Form7.ibQuery99.Open;

  while (not Form7.ibQuery99.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    {Sandro Silva 2022-10-03 inicio}
    Form7.ibDataSet4.Close;
    Form7.ibDataSet4.Selectsql.Clear;
    Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibQuery99.FieldByName('CODIGO').AsString)+' ');
    Form7.ibDataSet4.Open;
    {Sandro Silva 2022-10-30 fim}

    Application.ProcessMessages;

    if Form7.ibQuery99.FieldByname('CST_PIS_COFINS').AsString ='04' then
    begin
      // Lista s� produtos monofasicos
      try
        if Form7.ibQuery99.FieldByname('DESCONTO').AsFloat <> 0 then
          fRateioDoDesconto  := Arredonda((Form7.ibQuery99.FieldByname('DESCONTO').AsFloat / Form7.ibQuery99.FieldByname('MERCADORIA').AsFloat * Form7.ibQuery99.FieldByname('TOTAL').AsFloat),2)
        else
          fRateioDoDesconto := 0; // REGRA DE TR�S ratiando o desconto no total
      except
        fRateioDoDesconto := 0;
      end;

      {Sandro Silva 2022-10-03 inicio}
      sCFOP := Trim(Form7.ibQuery99.FieldByName('CFOP').AsString);
      if sCFOP = '' then
        sCFOP := ' ';

      bAchouItem := False;
      for iItem := 0 to Length(aCFOP) - 1 do
      begin
        if (aCFOP[iItem].CFOP = sCFOP) and (aCFOP[iItem].CSTPISCOFINS = sCSTPISCOFINS) then
        begin
          bAchouItem := True;
          Break;
        end;
      end;

      if bAchouItem = False then
      begin
        SetLength(aCFOP, Length(aCFOP) + 1);
        iItem := High(aCFOP);
        aCFOP[High(aCFOP)] := TCFOP.Create; // Sandro Silva 2019-06-13
        aCFOP[High(aCFOP)].CFOP         := sCFOP;
        aCFOP[High(aCFOP)].CSTPISCOFINS := sCSTPISCOFINS;
      end;

      // Sandro Silva 2022-12-01 aCFOP[iItem].Valor     := aCFOP[iItem].Valor + StrToFloat(Format('%10.2n',[Form7.ibQuery99.FieldByName('TOTAL').AsFloat - fRateioDoDesconto]));
      aCFOP[iItem].Valor     := aCFOP[iItem].Valor + StrToFloatFormat('%10.2n', Form7.ibQuery99.FieldByName('TOTAL').AsFloat - fRateioDoDesconto);
      //aCFOP[iItem].Acrescimo := aCFOP[iItem].Acrescimo - fRateioDoDesconto;
      aCFOP[iItem].Desconto  := aCFOP[iItem].Desconto - fRateioDoDesconto;

      if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      begin
        sCSTCSOSN := Trim(Form7.ibQuery99.FieldByName('CST_ICMS').AsString);
      end else
      begin
        //sCSTCSOSN := Trim(Form7.ibDataSet4.FieldByName('CSOSN').AsString); // Usar o campo itens001.csosn depois de cri�-lo Trim(Form7.ibQuery99.FieldByName('CSOSN').AsString);
        sCSTCSOSN := Trim(Form7.ibQuery99.FieldByName('CSOSN').AsString);
      end;

      bAchouItem := False;
      for iItem := 0 to Length(aCSTCSOSN) - 1 do
      begin
        if aCSTCSOSN[iItem].CSTCSOSN = sCSTCSOSN then
        begin
          bAchouItem := True;            // AQUI
          Break;
        end;
      end;

      if bAchouItem = False then
      begin
        SetLength(aCSTCSOSN, Length(aCSTCSOSN) + 1);
        iItem := High(aCSTCSOSN);
        aCSTCSOSN[High(aCSTCSOSN)] := TCSTCSOSN.Create; // Sandro Silva 2019-06-13
        aCSTCSOSN[High(aCSTCSOSN)].CSTCSOSN := sCSTCSOSN;
      end;
      // Sandro Silva 2022-12-01 aCSTCSOSN[iItem].Valor     := aCSTCSOSN[iItem].Valor + StrToFloat(Format('%10.2n',[Form7.ibQuery99.FieldByName('TOTAL').AsFloat - fRateioDoDesconto]));
      aCSTCSOSN[iItem].Valor     := aCSTCSOSN[iItem].Valor + StrToFloatFormat('%10.2n', Form7.ibQuery99.FieldByName('TOTAL').AsFloat - fRateioDoDesconto);
      //aCSTCSOSN[iItem].Acrescimo := aCSTCSOSN[iItem].Acrescimo - fRateioDoDesconto;
      aCSTCSOSN[iItem].Desconto  := aCSTCSOSN[iItem].Desconto - fRateioDoDesconto;

      {Sandro Silva 2022-10-03 fim}

      if Form1.bHtml1 then
      begin
        WriteLn(F,'   <tr>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+DateToStr(Form7.ibQuery99.FieldByname('EMISSAO').AsDateTime)+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibQuery99.FieldByname('NUMERONF').AsString,1,9)+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibQuery99.FieldByname('CODIGO').AsString+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibQuery99.FieldByname('DESCRICAO').AsString+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.2n',[Form7.ibQuery99.FieldByname('TOTAL').AsFloat - fRateioDoDesconto])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibQuery99.FieldByname('CST_PIS_COFINS').AsString+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%8.4n',[Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.2n',[Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat * (Form7.ibQuery99.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) /100])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%8.4n',[Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.2n',[Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat * (Form7.ibQuery99.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) /100])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibQuery99.FieldByname('CFOP').AsString+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibQuery99.FieldByname('CF').AsString+'<br></font></td>');
        {Sandro Silva 2022-10-30 inicio}
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + sCSTCSOSN + '<br></font></td>');
        {Sandro Silva 2022-10-30 fim}
        WriteLn(F,'   </tr>');
      end else
      begin
        Write(F,DateToStr(Form7.ibQuery99.FieldByname('EMISSAO').AsDateTime)+' ');
        Write(F,Copy(Form7.ibQuery99.FieldByname('NUMERONF').AsString+Replicate(' ',9) ,1,9)+' ');
        Write(F,Copy(Form7.ibQuery99.FieldByname('CODIGO').AsString+Replicate(' ', 6), 1, 6) + ' ');
        Write(F,Copy(Form7.ibQuery99.FieldByname('DESCRICAO').AsString+Replicate(' ',38),1,38)+' ');
        Write(F,Format('%10.2n',[(Form7.ibQuery99.FieldByname('TOTAL').AsFloat-fRateioDoDesconto)])+' ');
        Write(F,Copy(Form7.ibQuery99.FieldByname('CST_PIS_COFINS').AsString,1,3)+'   ');
        Write(F,Format('%8.4n',[Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat])+' ');
        Write(F,Format('%10.2n',[Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat * (Form7.ibQuery99.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) /100])+' ');
        Write(F,Format('%8.4n',[Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat])+' ');
        Write(F,Format('%10.2n',[Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat * (Form7.ibQuery99.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) /100])+' ');
        Write(F,Copy(Form7.ibQuery99.FieldByname('CFOP').AsString+Replicate(' ',4) ,1,4)+' ');
        Write(F,Copy(Form7.ibQuery99.FieldByname('CF').AsString+Replicate(' ',13) ,1,13)+' ');
        WriteLn(F,Copy(sCSTCSOSN+Replicate(' ',13) ,1,13)+' ');
      end;

      fTotal1  := fTotal1 + StrToFloatFormat('%10.2n', Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat * (Form7.ibQuery99.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) / 100);
      fTotal2  := fTotal2 + StrToFloatFormat('%10.2n', Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat * (Form7.ibQuery99.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) /100);
      fTotal3  := Ftotal3 + StrToFloatFormat('%10.2n', Form7.ibQuery99.FieldByname('TOTAL').AsFloat - fRateioDoDesconto);
      {Sandro Silva 2022-10-10 fim}
   end;

    Form7.ibQuery99.Next;
  end;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'  <tr bgcolor=#'+Form1.sHtmlCor+'   FF7F00>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    // Sandro Silva 2022-10-11 WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal3])+'<br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal3])+'<br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    // Sandro Silva 2022-10-11 WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal1])+'<br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal1])+'<br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    // Sandro Silva 2022-10-11 WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal2])+'<br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal2])+'<br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'  </tr>');
    WriteLn(F,' </table>');

    {Sandro Silva 2022-10-03 inicio}
    WriteLn(F,'<br>');
    WriteLn(F,'<br>');
    WriteLn(F,'<br><font size=4 color=#000000><b>Acumulado por CFOP</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CFOP</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total</font></th>');
    WriteLn(F,'    </tr>');

    dTotalCFOP := 0.00;
    sCFOP := '--';

    for iItem := 0 to Length(aCFOP) - 1 do
    begin
      dTotalCFOP := dTotalCFOP + aCFOP[iItem].Valor;
      WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCFOP[iItem].CFOP + '</font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [aCFOP[iItem].Valor]) + '</font></td>');
      WriteLn(F,'    </tr>');
    end;
    WriteLn(F,'    <tr bgcolor=#' + Form1.sHtmlCor + ' >');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>' + Format('%11.2n', [dTotalCFOP]) + '<br></font></td>');
    WriteLn(F,'    </tr>');
    WriteLn(F,'   </table>');

    {Sandro Silva 2022-09-30 inicio}
    WriteLn(F,'<br>');
    WriteLn(F,'<br>');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      WriteLn(F,'<br><font size=4 color=#000000><b>Acumulado por CST ICMS</b></font><br></center><br>')
    else
      WriteLn(F,'<br><font size=4 color=#000000><b>Acumulado por CSOSN</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CST ICMS</font></th>')
    else
      WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CSOSN</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total</font></th>');
    WriteLn(F,'    </tr>');

    dTotalCSTCSOSN := 0.00;
    for iItem := 0 to Length(aCSTCSOSN) - 1 do
    begin
      dTotalCSTCSOSN := dTotalCSTCSOSN + aCSTCSOSN[iItem].Valor;
      WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCSTCSOSN[iItem].CSTCSOSN + '</font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n',[aCSTCSOSN[iItem].Valor])+'</font></td>');
      WriteLn(F,'    </tr>');
    end;
    WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n', [dTotalCSTCSOSN])+'<br></font></td>');
    WriteLn(F,'    </tr>');
    WriteLn(F,'   </table>');

    {Sandro Silva 2022-10-03 fim}

    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br>');
    WriteLn(F,'</center>');
  end else
  begin
    WriteLn(F,'                                                                   ----------               ----------          ----------');
    WriteLn(F,'                                                                   ' + Format('%10.2n',[fTotal3])+'               '+Format('%10.2n',[fTotal1])+'          '+Format('%10.2n',[fTotal2]));
    WriteLn(F,'');

    {Sandro Silva 2022-10-14 inicio}
    WriteLn(F, '');
    WriteLn(F, '');
    WriteLn(F, 'Acumulado por CFOP');
    WriteLn(F, '');
    WriteLn(F, 'CFOP  Total          ');
    WriteLn(F, '----- -------------- ');
    dTotalCFOP             := 0.00;
    for iItem := 0 to Length(aCFOP) - 1 do
    begin
      dTotalCFOP             := dTotalCFOP + aCFOP[iItem].Valor;
      dTotalCFOPCSTPISCOFINS := dTotalCFOPCSTPISCOFINS + aCFOP[iItem].Valor;
      Write(F, Copy(aCFOP[iItem].CFOP + Replicate(' ', 5), 1, 5) + ' ');
      WriteLn(F, Format('%14.2n', [aCFOP[iItem].Valor]) + ' ');
    end;

    WriteLn(F, '      -------------- ');
    WriteLn(F, '      ' + Format('%14.2n',[dTotalCFOP]) + ' ');
    WriteLn(F, '');
    WriteLn(F, '');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
    begin
      WriteLn(F, 'Acumulado por CST ICMS');
      WriteLn(F, '');
      WriteLn(F, 'CST ICMS Total          ');
    end else
    begin
      WriteLn(F, 'Acumulado por CSOSN');
      WriteLn(F, '');
      WriteLn(F, 'CSOSN    Total          ');
    end;
    WriteLn(F, '-----    -------------- ');

    dTotalCSTCSOSN := 0.00;
    for iItem := 0 to Length(aCSTCSOSN) - 1 do
    begin
      dTotalCSTCSOSN             := dTotalCSTCSOSN + aCSTCSOSN[iItem].Valor;
      Write(F, Copy(aCSTCSOSN[iItem].CSTCSOSN + Replicate(' ', 8), 1, 8) + ' ');
      WriteLn(F, Format('%14.2n', [aCSTCSOSN[iItem].Valor]) + ' ');
    end;

    WriteLn(F, '         -------------- ');
    WriteLn(F, '         ' + Format('%14.2n', [dTotalCSTCSOSN]) + '');
    WriteLn(F,'');
    {Sandro Silva 2022-10-14 fim}

    Writeln(F,'Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal));
  end;
end;


procedure TForm38.RelatorioPisCofinsNfe(var F: TextFile; dInicio, dFinal : TdateTime);
var
  fRateioDoDesconto, fTotal1, ftotal2, ftotal3 : Real;
  sCFOP: String;
  bAchouItem: Boolean;
  iItem: Integer;
  aCFOP: array of TCFOP;
  aCSTCSOSN: array of TCSTCSOSN;
  sCSTPISCOFINS: String;
  sCSTCSOSN: String;
  dTotalCFOP: Double;
  dTotalCSTCSOSN: Double;
  dTotalCFOPCSTPISCOFINS: Double;
  dTotalPISCOFINSCSTCSOSN: Double;
begin
  {Sandro Silva 2022-10-04 inicio}
  try
    if AtualizaItens001CsosnFromXML(Form7.ibDataSet16.Transaction, dInicio, dFinal) then
    begin
      AgendaCommit(True);
    end;
  except
  end;
  {Sandro Silva 2022-10-04 fim}

  fTotal1  := 0;
  fTotal2  := 0;
  fTotal3  := 0;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Data</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>NF</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>C�digo</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Descri��o</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CST</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>% PIS</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>R$ PIS</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>% COFINS</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>R$ COFINS</font></th>');
    {Sandro Silva 2022-09-30 inicio}
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CFOP</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>NCM</font></th>');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CST ICMS</font></th>')
    else
      WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CSOSN</font></th>');
    {Sandro Silva 2022-09-30 fim}
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    WriteLn(F,'');
    {Sandro Silva 2022-10-17 inicio
    WriteLn(F,'DATA       NF     DESCRICAO                              TOTAL         CST  % PIS    R$ PIS     % COFINS R$ COFINS ');
    WriteLn(F,'---------- ------ -------------------------------------- ------------- ---- -------- ---------- -------- ----------');
    }
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
    begin
      WriteLn(F,'Data       NF        C�digo Descri��o                              Total          CST  % PIS    R$ PIS         % COFINS R$ COFINS      CFOP NCM       CST ICMS ');
      WriteLn(F,'---------- --------- ------ -------------------------------------- -------------- ---- -------- -------------- -------- -------------- ---- --------- ---------');
    end else
    begin
      WriteLn(F,'Data       NF        C�digo Descri��o                              Total          CST  % PIS    R$ PIS         % COFINS R$ COFINS      CFOP NCM       CSOSN ');
      WriteLn(F,'---------- --------- ------ -------------------------------------- -------------- ---- -------- -------------- -------- -------------- ---- --------- ------');
    end;
    {Sandro Silva 2022-10-17 fim}
  end;

  Form7.ibQuery99.Close;
  Form7.ibQuery99.SQL.Clear;
  Form7.ibQuery99.SQL.Add('select * from ITENS001 ,VENDAS where VENDAS.EMITIDA=''S'' and VENDAS.EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and VENDAS.EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and Coalesce(CST_PIS_COFINS,''XX'')<>''XX'' and VENDAS.NUMERONF=ITENS001.NUMERONF order by VENDAS.EMISSAO, VENDAS.NUMERONF');
  Form7.ibQuery99.Open;

  while (not Form7.ibQuery99.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    {Sandro Silva 2022-09-30 inicio}
    Form7.ibDataSet4.Close;
    Form7.ibDataSet4.Selectsql.Clear;
    Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibQuery99.FieldByName('CODIGO').AsString)+' ');
    Form7.ibDataSet4.Open;
    {Sandro Silva 2022-09-30 fim}

    Application.ProcessMessages;

    try
      if Form7.ibQuery99.FieldByname('DESCONTO').AsFloat <> 0 then
        fRateioDoDesconto  := Arredonda((Form7.ibQuery99.FieldByname('DESCONTO').AsFloat / Form7.ibQuery99.FieldByname('MERCADORIA').AsFloat * Form7.ibQuery99.FieldByname('TOTAL').AsFloat),2)
      else
        fRateioDoDesconto := 0; // REGRA DE TR�S ratiando o desconto no total
    except
      fRateioDoDesconto := 0;
    end;

    {Sandro Silva 2022-10-03 inicio}
    sCSTPISCOFINS := Trim(Form7.ibQuery99.FieldByName('CST_PIS_COFINS').AsString);
    if sCSTPISCOFINS = '' then
      sCSTPISCOFINS := ' ';

    sCFOP := Trim(Form7.ibQuery99.FieldByName('CFOP').AsString);
    if sCFOP = '' then
      sCFOP := ' ';

    bAchouItem := False;
    for iItem := 0 to Length(aCFOP) - 1 do
    begin
      if (aCFOP[iItem].CFOP = sCFOP) and (aCFOP[iItem].CSTPISCOFINS = sCSTPISCOFINS) then
      begin
        bAchouItem := True;
        Break;
      end;
    end;

    if bAchouItem = False then
    begin
      SetLength(aCFOP, Length(aCFOP) + 1);
      iItem := High(aCFOP);
      aCFOP[High(aCFOP)] := TCFOP.Create; // Sandro Silva 2019-06-13
      aCFOP[High(aCFOP)].CFOP         := sCFOP;
      aCFOP[High(aCFOP)].CSTPISCOFINS := sCSTPISCOFINS;
    end;
    
    // Sandro Silva 2022-12-15 aCFOP[iItem].Valor     := aCFOP[iItem].Valor + StrToFloat(Format('%10.2n', [(Form7.ibQuery99.FieldByName('TOTAL').AsFloat - fRateioDoDesconto)]));
    aCFOP[iItem].Valor     := aCFOP[iItem].Valor + StrToFloatFormat('%10.2n', (Form7.ibQuery99.FieldByName('TOTAL').AsFloat - fRateioDoDesconto));
    //aCFOP[iItem].Acrescimo := aCFOP[iItem].Acrescimo + Rateio.RateioAcrescimoItem;
    aCFOP[iItem].Desconto  := aCFOP[iItem].Desconto - fRateioDoDesconto;

    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      sCSTCSOSN := Trim(Form7.ibQuery99.FieldByName('CST_ICMS').AsString)
    else
      //sCSTCSOSN := Trim(Form7.IBDataSet4.FieldByName('CSOSN').AsString); // Depois de criar o campo itens001csosn, mudar aqui para buscar o campo Trim(Form7.ibQuery99.FieldByName('CSOSN').AsString);
      sCSTCSOSN := Trim(Form7.ibQuery99.FieldByName('CSOSN').AsString);
    if sCSTCSOSN = '' then
      sCSTCSOSN := ' ';

    bAchouItem := False;
    for iItem := 0 to Length(aCSTCSOSN) - 1 do
    begin
      if (aCSTCSOSN[iItem].CSTCSOSN = sCSTCSOSN) and (aCSTCSOSN[iItem].CSTPISCOFINS = sCSTPISCOFINS) then
      begin
        bAchouItem := True;
        Break;
      end;
    end;

    if bAchouItem = False then
    begin
      SetLength(aCSTCSOSN, Length(aCSTCSOSN) + 1);
      iItem := High(aCSTCSOSN);
      aCSTCSOSN[High(aCSTCSOSN)] := TCSTCSOSN.Create; // Sandro Silva 2019-06-13
      aCSTCSOSN[High(aCSTCSOSN)].CSTCSOSN     := sCSTCSOSN;
      aCSTCSOSN[High(aCSTCSOSN)].CSTPISCOFINS := sCSTPISCOFINS;
    end;
    // Sandro Silva 2022-12-15 aCSTCSOSN[iItem].Valor     := aCSTCSOSN[iItem].Valor + StrToFloat(Format('%10.2n', [(Form7.ibQuery99.FieldByName('TOTAL').AsFloat - fRateioDoDesconto)]));
    aCSTCSOSN[iItem].Valor     := aCSTCSOSN[iItem].Valor + StrToFloatFormat('%10.2n', (Form7.ibQuery99.FieldByName('TOTAL').AsFloat - fRateioDoDesconto));
    //aCSTCSOSN[iItem].Acrescimo := aCSTCSOSN[iItem].Acrescimo + Rateio.RateioAcrescimoItem;
    aCSTCSOSN[iItem].Desconto  := aCSTCSOSN[iItem].Desconto - fRateioDoDesconto;
    {Sandro Silva 2022-10-03 fim}

    if Form1.bHtml1 then
    begin
      WriteLn(F,'   <tr>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+DateToStr(Form7.ibQuery99.FieldByname('EMISSAO').AsDateTime)+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibQuery99.FieldByname('NUMERONF').AsString,1,9)+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibQuery99.FieldByname('CODIGO').AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibQuery99.FieldByname('DESCRICAO').AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.2n',[Form7.ibQuery99.FieldByname('TOTAL').AsFloat - fRateioDoDesconto])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibQuery99.FieldByname('CST_PIS_COFINS').AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%8.4n',[Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat])+'<br></font></td>');
      // Sandro Silva 2022-10-10 WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[ibQuery99.FieldByname('ALIQ_PIS').AsFloat * (ibQuery99.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) /100])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.2n',[Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat * (Form7.ibQuery99.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) /100])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%8.4n',[Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat])+'<br></font></td>');
      // Sandro Silva 2022-10-10 WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[ibQuery99.FieldByname('ALIQ_COFINS').AsFloat * (ibQuery99.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) /100])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.2n',[Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat * (Form7.ibQuery99.FieldByname('TOTAL').AsFloat-fRateioDoDesconto) /100])+'<br></font></td>');
      {Sandro Silva 2022-09-30 inicio}
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.ibQuery99.FieldByname('CFOP').AsString + '<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.IBDataSet4CF.AsString + '<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + sCSTCSOSN + '<br></font></td>');
      {Sandro Silva 2022-09-30 fim}
      WriteLn(F,'   </tr>');
    end else
    begin
      Write(F,DateToStr(Form7.ibQuery99.FieldByname('EMISSAO').AsDateTime)+' ');
      Write(F,Copy(Form7.ibQuery99.FieldByname('NUMERONF').AsString+Replicate(' ',9) ,1,9) + ' ');
      Write(F,Copy(Form7.ibQuery99.FieldByname('CODIGO').AsString+Replicate(' ', 6), 1, 6) + ' ');
      Write(F,Copy(Form7.ibQuery99.FieldByname('DESCRICAO').AsString+Replicate(' ',38),1,38) + ' ');
      Write(F,Format('%14.2n',[(Form7.ibQuery99.FieldByname('TOTAL').AsFloat - fRateioDoDesconto)]) + ' ');
      Write(F,Copy(Form7.ibQuery99.FieldByname('CST_PIS_COFINS').AsString,1,3)+'   ');
      Write(F,Format('%8.4n',[Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat])+' ');
      // Sandro Silva 2022-10-10 Write(F,Format('%10.'+Form1.ConfCasas + 'n',[ibQuery99.FieldByname('ALIQ_PIS').AsFloat * (ibQuery99.FieldByname('TOTAL').AsFloat - fRateioDoDesconto) / 100]) + ' ');
      Write(F,Format('%14.2n',[Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat * (Form7.ibQuery99.FieldByname('TOTAL').AsFloat - fRateioDoDesconto) / 100]) + ' ');
      Write(F,Format('%8.4n',[Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat]) + ' ');
      // Sandro Silva 2022-10-10 WriteLn(F,Format('%10.'+Form1.ConfCasas + 'n',[ibQuery99.FieldByname('ALIQ_COFINS').AsFloat * (ibQuery99.FieldByname('TOTAL').AsFloat - fRateioDoDesconto) / 100]));
      Write(F,Format('%14.2n',[Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat * (Form7.ibQuery99.FieldByname('TOTAL').AsFloat - fRateioDoDesconto) / 100]) + ' ');
      Write(F,Copy(Form7.ibQuery99.FieldByname('CFOP').AsString+Replicate(' ', 4), 1, 4) + ' ');
      {Sandro Silva 2022-10-17 inicio}
      Write(F,Copy(Form7.ibDataSet4CF.AsString+Replicate(' ', 9), 1, 9) + ' ');
      if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
        WriteLn(F, Copy(sCSTCSOSN + Replicate(' ', 9), 1, 9) + ' ')
      else
        WriteLn(F, Copy(sCSTCSOSN + Replicate(' ', 6), 1, 6) + ' ');
      {Sandro Silva 2022-10-17 fim}
    end;

    fTotal1  := fTotal1 + StrToFloatFormat('%10.2n', (Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat * (Form7.ibQuery99.FieldByname('TOTAL').AsFloat - fRateioDoDesconto) / 100));
    fTotal2  := fTotal2 + StrToFloatFormat('%10.2n', (Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat * (Form7.ibQuery99.FieldByname('TOTAL').AsFloat - fRateioDoDesconto) / 100));
    fTotal3  := Ftotal3 + StrToFloatFormat('%10.2n', (Form7.ibQuery99.FieldByname('TOTAL').AsFloat - fRateioDoDesconto));
    {Sandro Silva 2022-12-15 fim}

    {Sandro Silva 2022-10-10 fim}

    Form7.ibQuery99.Next;
  end;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'  <tr bgcolor=#'+Form1.sHtmlCor+'   FF7F00>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    // Sandro Silva 2022-10-10 WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal3])+'<br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal3])+'<br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    // Sandro Silva 2022-10-10 WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal1])+'<br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal1])+'<br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    // Sandro Silva 2022-10-10 WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal2])+'<br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal2])+'<br></font></td>');
    {Sandro Silva 2022-10-30 inicio}
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    {Sandro Silva 2022-10-30 fim}
    WriteLn(F,'  </tr>');
    WriteLn(F,' </table>');
    WriteLn(F,'<br>');
    WriteLn(F,'<br>');
    WriteLn(F,'<br><font size=4 color=#000000><b>Acumulado por CFOP</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor=#' + Form1.sHtmlCor + ' >');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CFOP</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CST PIS/COFINS</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total</font></th>');
    WriteLn(F,'    </tr>');

    dTotalCFOP := 0.00;
    dTotalCFOPCSTPISCOFINS := 0.00;
    sCFOP := '--';

    for iItem := 0 to Length(aCFOP) - 1 do
    begin
      if sCFOP <> aCFOP[iItem].CFOP then
      begin
        if sCFOP <> '--' then
        begin
          WriteLn(F,'  <tr bgcolor=#' + Form1.sHtmlCor + '   FF7F00>');
          WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [dTotalCFOPCSTPISCOFINS]) + '</font></td>');
          WriteLn(F,'    </tr>');
          dTotalCFOPCSTPISCOFINS := 0.00;
        end;
        sCFOP := aCFOP[iItem].CFOP;
      end;
      dTotalCFOP := dTotalCFOP + aCFOP[iItem].Valor;
      dTotalCFOPCSTPISCOFINS := dTotalCFOPCSTPISCOFINS + aCFOP[iItem].Valor;

      WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCFOP[iItem].CFOP + '</font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCFOP[iItem].CSTPISCOFINS + '</font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [aCFOP[iItem].Valor]) + '</font></td>');
      WriteLn(F,'    </tr>');
    end;
    if sCFOP <> '' then
    begin
      WriteLn(F,'  <tr bgcolor=#' + Form1.sHtmlCor + '   FF7F00>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [dTotalCFOPCSTPISCOFINS]) + '</font></td>');
      WriteLn(F,'    </tr>');
    end;

    WriteLn(F,'    <tr bgcolor=#' + Form1.sHtmlCor + ' >');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>' + Format('%11.2n', [dTotalCFOP]) + '<br></font></td>');
    WriteLn(F,'    </tr>');
    WriteLn(F,'   </table>');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      WriteLn(F,'<br><font size=4 color=#000000><b>Acumulado por CST ICMS</b></font><br></center><br>')
    else
      WriteLn(F,'<br><font size=4 color=#000000><b>Acumulado por CSOSN</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CST ICMS</font></th>')
    else
      WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CSOSN</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CST PIS/COFINS</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total</font></th>');
    WriteLn(F,'    </tr>');

    dTotalCSTCSOSN          := 0.00;
    dTotalPISCOFINSCSTCSOSN := 0.00;
    sCSTCSOSN := '--';
    for iItem := 0 to Length(aCSTCSOSN) - 1 do
    begin
      if sCSTCSOSN <> aCSTCSOSN[iItem].CSTCSOSN then
      begin
        if sCSTCSOSN <> '--' then
        begin
          WriteLn(F,'  <tr bgcolor=#' + Form1.sHtmlCor + '   FF7F00>');
          WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [dTotalPISCOFINSCSTCSOSN]) + '</font></td>');
          WriteLn(F,'    </tr>');
          dTotalPISCOFINSCSTCSOSN := 0.00;
        end;
        sCSTCSOSN := aCSTCSOSN[iItem].CSTCSOSN;
      end;

      dTotalCSTCSOSN := dTotalCSTCSOSN + aCSTCSOSN[iItem].Valor;
      dTotalPISCOFINSCSTCSOSN := dTotalPISCOFINSCSTCSOSN + aCSTCSOSN[iItem].Valor;
      WriteLn(F,'    <tr bgcolor=#' + Form1.sHtmlCor + ' >');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCSTCSOSN[iItem].CSTCSOSN + '</font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCSTCSOSN[iItem].CSTPISCOFINS + '</font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n',[aCSTCSOSN[iItem].Valor])+'</font></td>');
      WriteLn(F,'    </tr>');
    end;

    if sCSTCSOSN <> '' then
    begin
      WriteLn(F,'  <tr bgcolor=#' + Form1.sHtmlCor + '   FF7F00>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [dTotalPISCOFINSCSTCSOSN]) + '</font></td>');
      WriteLn(F,'    </tr>');
    end;

    WriteLn(F,'    <tr bgcolor=#' + Form1.sHtmlCor + ' >');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n', [dTotalCSTCSOSN])+'<br></font></td>');
    WriteLn(F,'    </tr>');
    WriteLn(F,'   </table>');
    WriteLn(F,'<br>');
    WriteLn(F,'<br>');
    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br>');
    WriteLn(F,'</center>');
  end else
  begin
    WriteLn(F,'                                                                       ----------                   ----------              ----------');
    // Sandro Silva 2022-10-10 WriteLn(F,'                                                         '+Format('%10.'+Form1.ConfPreco+'n',[fTotal3])+'               '+Format('%10.'+Form1.ConfPreco+'n',[fTotal1])+'          '+Format('%10.'+Form1.ConfPreco+'n',[fTotal2]));
    WriteLn(F,'                                                                       ' + Format('%10.2n', [fTotal3]) + '                   ' + Format('%10.2n', [fTotal1]) + '              ' + Format('%10.2n', [fTotal2]));
    WriteLn(F,'');
    {Sandro Silva 2022-10-14 inicio}
    WriteLn(F, '');
    WriteLn(F, '');
    WriteLn(F, 'Acumulado por CFOP');
    WriteLn(F, '');
    WriteLn(F, 'CFOP  CST PIS/COFINS Total          ');
    WriteLn(F, '----- -------------- -------------- ');
    dTotalCFOP             := 0.00;
    dTotalCFOPCSTPISCOFINS := 0.00;
    sCFOP := '--';
    for iItem := 0 to Length(aCFOP) - 1 do
    begin
      if sCFOP <> aCFOP[iItem].CFOP then
      begin
        if sCFOP <> '--' then
        begin
          Write(F, Replicate(' ', 5) + ' ');
          Write(F, Replicate(' ', 14) + ' ');
          WriteLn(F, Format('%14.2n', [dTotalCFOPCSTPISCOFINS]));
          dTotalCFOPCSTPISCOFINS := 0.00;
        end;
        sCFOP := aCFOP[iItem].CFOP;
      end;

      dTotalCFOP             := dTotalCFOP + aCFOP[iItem].Valor;
      dTotalCFOPCSTPISCOFINS := dTotalCFOPCSTPISCOFINS + aCFOP[iItem].Valor;
      Write(F, Copy(aCFOP[iItem].CFOP + Replicate(' ', 5), 1, 5) + ' ');
      Write(F, Copy(aCFOP[iItem].CSTPISCOFINS + Replicate(' ', 14), 1, 14) + ' ');
      WriteLn(F, Format('%14.2n', [aCFOP[iItem].Valor]) + ' ');
    end;

    if sCFOP <> '' then
    begin
      Write(F, Replicate(' ', 5) + ' ');
      Write(F, Replicate(' ', 14) + ' ');
      WriteLn(F, Format('%14.2n', [dTotalCFOPCSTPISCOFINS]));
      dTotalCFOPCSTPISCOFINS := 0.00;
    end;

    WriteLn(F, '                     -------------- ');
    WriteLn(F, '                     ' + Format('%14.2n',[dTotalCFOP]) + ' ');
    WriteLn(F, '');
    WriteLn(F, '');

    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
    begin
      WriteLn(F, 'Acumulado por CST ICMS');
      WriteLn(F, '');
      WriteLn(F, 'CST ICMS CST PIS/COFINS Total          ');
    end else
    begin
      WriteLn(F, 'Acumulado por CSOSN');
      WriteLn(F, '');
      WriteLn(F, 'CSOSN    CST PIS/COFINS Total          ');
    end;
      WriteLn(F, '-------- -------------- -------------- ');

    dTotalCSTCSOSN := 0.00;
    dTotalPISCOFINSCSTCSOSN := 0.00;
    sCSTCSOSN := '--';

    for iItem := 0 to Length(aCSTCSOSN) - 1 do
    begin
      if sCSTCSOSN <> aCSTCSOSN[iItem].CSTCSOSN then
      begin
        if sCSTCSOSN <> '--' then
        begin
          Write(F, Replicate(' ', 8) + ' ');
          Write(F, Replicate(' ', 14) + ' ');
          WriteLn(F, Format('%14.2n', [dTotalPISCOFINSCSTCSOSN]));
          dTotalPISCOFINSCSTCSOSN := 0.00;
        end;
        sCSTCSOSN := aCSTCSOSN[iItem].CSTCSOSN;
      end;

      dTotalCSTCSOSN             := dTotalCSTCSOSN + aCSTCSOSN[iItem].Valor;
      dTotalPISCOFINSCSTCSOSN := dTotalPISCOFINSCSTCSOSN + aCSTCSOSN[iItem].Valor;
      Write(F, Copy(aCSTCSOSN[iItem].CSTCSOSN + Replicate(' ', 8), 1, 8) + ' ');
      Write(F, Copy(aCSTCSOSN[iItem].CSTPISCOFINS + Replicate(' ', 14), 1, 14) + ' ');
      WriteLn(F, Format('%14.2n', [aCSTCSOSN[iItem].Valor]) + ' ');
    end;

    if sCSTCSOSN <> '' then
    begin
      Write(F, Replicate(' ', 8) + ' ');
      Write(F, Replicate(' ', 14) + ' ');
      WriteLn(F, Format('%14.2n', [dTotalPISCOFINSCSTCSOSN]));
      dTotalPISCOFINSCSTCSOSN := 0.00;
    end;

    WriteLn(F, '                        -------------- ');
    WriteLn(F, '                        ' + Format('%14.2n', [dTotalCSTCSOSN]) + '');
    WriteLn(F,'');
    {Sandro Silva 2022-10-14 fim}

    Writeln(F,'Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal));
  end;
end;

procedure TForm38.RelatorioPisCofinsCupom(var F: TextFile; dInicio, dFinal : TdateTime);
var
  fRateioDoDesconto, fTotal1, ftotal2, ftotal3 : Real;
  sCFOP: String;
  bAchouItem: Boolean;
  iItem: Integer;
  aCFOP: array of TCFOP;
  aCSTCSOSN: array of TCSTCSOSN;
  sCSTPISCOFINS: String;
  sCSTCSOSN: String;
  dTotalCFOP: Double;
  dTotalCSTCSOSN: Double;
  dTotalCFOPCSTPISCOFINS: Double;
  dTotalPISCOFINSCSTCSOSN: Double;

  Rateio: TRateioBalcao;
  sCaixa: String;
  sPedido: String;
begin
  fTotal1  := 0;
  fTotal2  := 0;
  fTotal3  := 0;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Data</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Caixa</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Cupom</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>C�digo</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Descri��o</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CST</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>% PIS</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>R$ PIS</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>% COFINS</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>R$ COFINS</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CFOP</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>NCM</font></th>');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CST ICMS</font></th>')
    else
      WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CSOSN</font></th>');
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    WriteLn(F,'');
    {Sandro Silva 2022-10-17 inicio
      WriteLn(F,'DATA       Caixa  NF        DESCRICAO                              TOTAL      CST  % PIS    R$ PIS     % COFINS R$ COFINS ');
      WriteLn(F,'---------- ------ --------- -------------------------------------- ---------- ---- -------- ---------- -------- ----------');
    }
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
    begin
      WriteLn(F,'Data       Caixa  Cupom     C�digo Descri��o                              Total          CST  % PIS    R$ PIS         % COFINS R$ COFINS      CFOP NCM       CST ICMS ');
      WriteLn(F,'---------- ------ --------- ------ -------------------------------------- -------------- ---- -------- -------------- -------- -------------- ---- --------- ---------');
    end else
    begin
      WriteLn(F,'Data       Caixa  Cupom     C�digo Descri��o                              Total          CST  % PIS    R$ PIS         % COFINS R$ COFINS      CFOP NCM       CSOSN ');
      WriteLn(F,'---------- ------ --------- ------ -------------------------------------- -------------- ---- -------- -------------- -------- -------------- ---- --------- ------');
    end;
    {Sandro Silva 2022-10-17 fim}
  end;

  Form7.ibQuery99.Close;
  Form7.ibQuery99.SQL.Clear;
  Form7.ibQuery99.SQL.Add('select * from ALTERACA where DATA <= ' + QuotedStr(DateToStrInvertida(dFinal)) + ' and DATA >= ' + QuotedStr(DateToStrInvertida(dInicio)) + ' and (TIPO = ' + QuotedStr('BALCAO') + ' or TIPO = ' + QuotedStr('VENDA') + ') order by DATA, PEDIDO');
  Form7.ibQuery99.Open;
  Form7.ibQuery99.DisableControls; // Sandro Silva 2022-09-30

  Rateio := TRateioBalcao.Create;
  Rateio.IBTransaction := Form7.ibQuery99.Transaction;
  sCaixa  := '';
  sPedido := '';
  while (not Form7.ibQuery99.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    if (Form7.ibQuery99.FieldByName('DESCRICAO').AsString <> 'Desconto') and (Form7.ibQuery99.FieldByName('DESCRICAO').AsString <> 'Acr�scimo') then
    begin
      Form7.ibDataSet4.Close;
      Form7.ibDataSet4.Selectsql.Clear;
      Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibQuery99.FieldByName('CODIGO').AsString)+' ');
      Form7.ibDataSet4.Open;

      Application.ProcessMessages;

      Rateio.CalcularRateio(Form7.ibQuery99.FieldByName('CAIXA').AsString, Form7.ibQuery99.FieldByName('PEDIDO').AsString, Form7.ibQuery99.FieldByName('ITEM').AsString);

      sCSTPISCOFINS := Trim(Form7.ibQuery99.FieldByName('CST_PIS_COFINS').AsString);
      if sCSTPISCOFINS = '' then
        sCSTPISCOFINS := ' ';

      sCFOP := Trim(Form7.ibQuery99.FieldByName('CFOP').AsString);
      if sCFOP = '' then
        sCFOP := ' ';

      bAchouItem := False;
      for iItem := 0 to Length(aCFOP) - 1 do
      begin
        if (aCFOP[iItem].CFOP = sCFOP) and (aCFOP[iItem].CSTPISCOFINS = sCSTPISCOFINS) then
        begin
          bAchouItem := True;
          Break;
        end;
      end;

      if bAchouItem = False then
      begin
        SetLength(aCFOP, Length(aCFOP) + 1);
        iItem := High(aCFOP);
        aCFOP[High(aCFOP)] := TCFOP.Create; // Sandro Silva 2019-06-13
        aCFOP[High(aCFOP)].CFOP         := sCFOP;
        aCFOP[High(aCFOP)].CSTPISCOFINS := sCSTPISCOFINS;
      end;

      // Sandro Silva 2022-12-15 aCFOP[iItem].Valor     := aCFOP[iItem].Valor + StrToFloat(Format('%10.2n', [Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem]));
      aCFOP[iItem].Valor     := aCFOP[iItem].Valor + StrToFloatFormat('%10.2n', Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem);
      aCFOP[iItem].Acrescimo := aCFOP[iItem].Acrescimo + Rateio.RateioAcrescimoItem;
      aCFOP[iItem].Desconto  := aCFOP[iItem].Desconto + Rateio.DescontoItem + Rateio.RateioDescontoItem;

      if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
        sCSTCSOSN := Trim(Form7.ibQuery99.FieldByName('CST_ICMS').AsString)
      else
        sCSTCSOSN := Trim(Form7.ibQuery99.FieldByName('CSOSN').AsString);
      if sCSTCSOSN = '' then
        sCSTCSOSN := ' ';

      bAchouItem := False;
      for iItem := 0 to Length(aCSTCSOSN) - 1 do
      begin
        if (aCSTCSOSN[iItem].CSTCSOSN = sCSTCSOSN) and (aCSTCSOSN[iItem].CSTPISCOFINS = sCSTPISCOFINS) then
        begin
          bAchouItem := True;
          Break;
        end;
      end;

      if bAchouItem = False then
      begin
        SetLength(aCSTCSOSN, Length(aCSTCSOSN) + 1);
        iItem := High(aCSTCSOSN);
        aCSTCSOSN[High(aCSTCSOSN)] := TCSTCSOSN.Create; // Sandro Silva 2019-06-13
        aCSTCSOSN[High(aCSTCSOSN)].CSTCSOSN     := sCSTCSOSN;
        aCSTCSOSN[High(aCSTCSOSN)].CSTPISCOFINS := sCSTPISCOFINS;
      end;
      // Sandro Silva 2022-12-15 aCSTCSOSN[iItem].Valor     := aCSTCSOSN[iItem].Valor + StrToFloat(Format('%10.2n', [Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem]));
      aCSTCSOSN[iItem].Valor     := aCSTCSOSN[iItem].Valor + StrToFloatFormat('%10.2n', Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem);
      aCSTCSOSN[iItem].Acrescimo := aCSTCSOSN[iItem].Acrescimo + Rateio.RateioAcrescimoItem;
      aCSTCSOSN[iItem].Desconto  := aCSTCSOSN[iItem].Desconto + Rateio.DescontoItem + Rateio.RateioDescontoItem;

      if Form1.bHtml1 then
      begin
        WriteLn(F,'   <tr>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + DateToStr(Form7.ibQuery99.FieldByname('DATA').AsDateTime) + '<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.ibQuery99.FieldByname('CAIXA').AsString + '<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.ibQuery99.FieldByname('PEDIDO').AsString + '<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.ibQuery99.FieldByname('CODIGO').AsString + '<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.ibQuery99.FieldByname('DESCRICAO').AsString + '<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%10.2n', [Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.ibQuery99.FieldByname('CST_PIS_COFINS').AsString + '<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%8.4n', [Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat]) + '<br></font></td>');
        // Sandro Silva 2022-10-11 WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%7.' + Form1.ConfCasas + 'n', [Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat * (ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem) /100]) + '<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%7.2n', [Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat * (Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem) /100]) + '<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%8.4n', [Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat]) + '<br></font></td>');
        // Sandro Silva 2022-10-11 WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%7.' + Form1.ConfCasas + 'n', [Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat * (ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem) /100]) + '<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%7.2n', [Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat * (Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem) /100]) + '<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.ibQuery99.FieldByname('CFOP').AsString + '<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.IBDataSet4CF.AsString + '<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + sCSTCSOSN + '<br></font></td>');
        WriteLn(F,'   </tr>');
      end else
      begin
        Write(F,DateToStr(Form7.ibQuery99.FieldByname('DATA').AsDateTime)+' ');
        Write(F,Copy(Form7.ibQuery99.FieldByname('CAIXA').AsString+Replicate(' ', 6), 1, 6) + ' ');
        Write(F,Copy(Form7.ibQuery99.FieldByname('PEDIDO').AsString+Replicate(' ', 9), 1, 9) + ' ');
        Write(F,Copy(Form7.ibQuery99.FieldByname('CODIGO').AsString+Replicate(' ', 6), 1, 6) + ' ');
        Write(F,Copy(Form7.ibQuery99.FieldByname('DESCRICAO').AsString+Replicate(' ', 38), 1, 38) + ' ');
        Write(F,Format('%14.2n',[(Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem)]) + ' ');
        Write(F,Copy(Form7.ibQuery99.FieldByname('CST_PIS_COFINS').AsString,1,3)+'   ');
        Write(F,Format('%8.4n',[Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat])+' ');
        // Sandro Silva 2022-10-11 Write(F,Format('%10.' + Form1.ConfCasas + 'n', [ibQuery99.FieldByname('ALIQ_PIS').AsFloat * (Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem) / 100]) + ' ');
        Write(F,Format('%14.2n', [Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat * (Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem) / 100]) + ' ');
        Write(F,Format('%8.4n',[Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat]) + ' ');
        // Sandro Silva 2022-10-11 WriteLn(F,Format('%10.' + Form1.ConfCasas + 'n', [ibQuery99.FieldByname('ALIQ_COFINS').AsFloat * (Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem) / 100]));
        Write(F,Format('%14.2n', [Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat * (Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem) / 100]) + ' ');
        Write(F,Copy(Form7.ibQuery99.FieldByname('CFOP').AsString+Replicate(' ', 4), 1, 4) + ' ');
        {Sandro Silva 2022-10-17 inicio}
        Write(F,Copy(Form7.ibDataSet4CF.AsString+Replicate(' ', 9), 1, 9) + ' ');
        if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
          WriteLn(F, Copy(sCSTCSOSN + Replicate(' ', 9), 1, 9) + ' ')
        else
          WriteLn(F, Copy(sCSTCSOSN + Replicate(' ', 6), 1, 6) + ' ');
        {Sandro Silva 2022-10-17 fim}
      end;

      fTotal1  := fTotal1 + StrToFloatFormat('%10.2n', (Form7.ibQuery99.FieldByname('ALIQ_PIS').AsFloat * (Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem) / 100));
      fTotal2  := fTotal2 + StrToFloatFormat('%10.2n', (Form7.ibQuery99.FieldByname('ALIQ_COFINS').AsFloat * (Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem) / 100));
      fTotal3  := Ftotal3 + StrToFloatFormat('%10.2n', (Form7.ibQuery99.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem));
      {Sandro Silva 2022-12-15 fim}

      {Sandro Silva 2022-10-11 fim}
    end;
    
    Form7.ibQuery99.Next;
  end;
  Form7.ibQuery99.EnableControls; // Sandro Silva 2022-09-30

  if Form1.bHtml1 then
  begin
    WriteLn(F,'  <tr bgcolor=#' + Form1.sHtmlCor + '   FF7F00>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    // Sandro Silva 2022-10-11 WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.' + Form1.ConfPreco + 'n',[fTotal3]) + '<br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal3]) + '<br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    // Sandro Silva 2022-10-11 WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.' + Form1.ConfPreco + 'n',[fTotal1]) + '<br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal1]) + '<br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    // Sandro Silva 2022-10-11 WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.' + Form1.ConfPreco + 'n',[fTotal2]) + '<br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal2]) + '<br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'  </tr>');
    WriteLn(F,' </table>');
    WriteLn(F,'<br>');
    WriteLn(F,'<br>');
    WriteLn(F,'<br><font size=4 color=#000000><b>Acumulado por CFOP</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor=#' + Form1.sHtmlCor + ' >');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CFOP</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CST PIS/COFINS</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total</font></th>');
    WriteLn(F,'    </tr>');

    dTotalCFOP := 0.00;
    dTotalCFOPCSTPISCOFINS := 0.00;
    sCFOP := '--';

    for iItem := 0 to Length(aCFOP) - 1 do
    begin
      if sCFOP <> aCFOP[iItem].CFOP then
      begin
        if sCFOP <> '--' then
        begin
          WriteLn(F,'  <tr bgcolor=#' + Form1.sHtmlCor + '   FF7F00>');
          WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [dTotalCFOPCSTPISCOFINS]) + '</font></td>');
          WriteLn(F,'    </tr>');
          dTotalCFOPCSTPISCOFINS := 0.00;
        end;
        sCFOP := aCFOP[iItem].CFOP;
      end;
      dTotalCFOP := dTotalCFOP + aCFOP[iItem].Valor;
      dTotalCFOPCSTPISCOFINS := dTotalCFOPCSTPISCOFINS + aCFOP[iItem].Valor;

      WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCFOP[iItem].CFOP + '</font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCFOP[iItem].CSTPISCOFINS + '</font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [aCFOP[iItem].Valor]) + '</font></td>');
      WriteLn(F,'    </tr>');
    end;
    if sCFOP <> '' then
    begin
      WriteLn(F,'  <tr bgcolor=#' + Form1.sHtmlCor + '   FF7F00>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [dTotalCFOPCSTPISCOFINS]) + '</font></td>');
      WriteLn(F,'    </tr>');
    end;

    WriteLn(F,'    <tr bgcolor=#' + Form1.sHtmlCor + ' >');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>' + Format('%11.2n', [dTotalCFOP]) + '<br></font></td>');
    WriteLn(F,'    </tr>');
    WriteLn(F,'   </table>');
    WriteLn(F,'<br>');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      WriteLn(F,'<br><font size=4 color=#000000><b>Acumulado por CST ICMS</b></font><br></center><br>')
    else
      WriteLn(F,'<br><font size=4 color=#000000><b>Acumulado por CSOSN</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CST ICMS</font></th>')
    else
      WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CSOSN</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CST PIS/COFINS</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total</font></th>');
    WriteLn(F,'    </tr>');

    dTotalCSTCSOSN          := 0.00;
    dTotalPISCOFINSCSTCSOSN := 0.00;
    sCSTCSOSN := '--';
    for iItem := 0 to Length(aCSTCSOSN) - 1 do
    begin
      if sCSTCSOSN <> aCSTCSOSN[iItem].CSTCSOSN then
      begin
        if sCSTCSOSN <> '--' then
        begin
          WriteLn(F,'  <tr bgcolor=#' + Form1.sHtmlCor + '   FF7F00>');
          WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [dTotalPISCOFINSCSTCSOSN]) + '</font></td>');
          WriteLn(F,'    </tr>');
          dTotalPISCOFINSCSTCSOSN := 0.00;
        end;
        sCSTCSOSN := aCSTCSOSN[iItem].CSTCSOSN;
      end;

      dTotalCSTCSOSN := dTotalCSTCSOSN + aCSTCSOSN[iItem].Valor;
      dTotalPISCOFINSCSTCSOSN := dTotalPISCOFINSCSTCSOSN + aCSTCSOSN[iItem].Valor;
      WriteLn(F,'    <tr bgcolor=#' + Form1.sHtmlCor + ' >');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCSTCSOSN[iItem].CSTCSOSN + '</font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCSTCSOSN[iItem].CSTPISCOFINS + '</font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n',[aCSTCSOSN[iItem].Valor])+'</font></td>');
      WriteLn(F,'    </tr>');
    end;

    if sCSTCSOSN <> '' then
    begin
      WriteLn(F,'  <tr bgcolor=#' + Form1.sHtmlCor + '   FF7F00>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n', [dTotalPISCOFINSCSTCSOSN]) + '</font></td>');
      WriteLn(F,'    </tr>');
      dTotalPISCOFINSCSTCSOSN := 0.00;
    end;
    WriteLn(F,'    <tr bgcolor=#' + Form1.sHtmlCor + ' >');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n', [dTotalCSTCSOSN])+'<br></font></td>');
    WriteLn(F,'    </tr>');
    WriteLn(F,'   </table>');

    WriteLn(F,'<br>');
    WriteLn(F,'<br>');

    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal) + '<br>');
    WriteLn(F,'</center>');
  end else
  begin
    WriteLn(F,'                                                                              ----------                   ----------              ----------');
    // Sandro Silva 2022-10-11 WriteLn(F,'                                                         '+Format('%10.'+Form1.ConfPreco+'n',[fTotal3])+'               '+Format('%10.'+Form1.ConfPreco+'n',[fTotal1])+'          '+Format('%10.'+Form1.ConfPreco+'n',[fTotal2]));
    WriteLn(F,'                                                                              ' + Format('%10.2n', [fTotal3]) + '                   ' + Format('%10.2n', [fTotal1]) + '              ' + Format('%10.2n', [fTotal2]));
    {Sandro Silva 2022-10-14 inicio}
    WriteLn(F, '');
    WriteLn(F, '');
    WriteLn(F, 'Acumulado por CFOP');
    WriteLn(F, '');
    WriteLn(F, 'CFOP  CST PIS/COFINS Total          ');
    WriteLn(F, '----- -------------- -------------- ');
    dTotalCFOP             := 0.00;
    dTotalCFOPCSTPISCOFINS := 0.00;
    sCFOP := '--';
    for iItem := 0 to Length(aCFOP) - 1 do
    begin
      if sCFOP <> aCFOP[iItem].CFOP then
      begin
        if sCFOP <> '--' then
        begin
          Write(F, Replicate(' ', 5) + ' ');
          Write(F, Replicate(' ', 14) + ' ');
          WriteLn(F, Format('%14.2n', [dTotalCFOPCSTPISCOFINS]));
          dTotalCFOPCSTPISCOFINS := 0.00;
        end;
        sCFOP := aCFOP[iItem].CFOP;
      end;

      dTotalCFOP             := dTotalCFOP + aCFOP[iItem].Valor;
      dTotalCFOPCSTPISCOFINS := dTotalCFOPCSTPISCOFINS + aCFOP[iItem].Valor;
      Write(F, Copy(aCFOP[iItem].CFOP + Replicate(' ', 5), 1, 5) + ' ');
      Write(F, Copy(aCFOP[iItem].CSTPISCOFINS + Replicate(' ', 14), 1, 14) + ' ');
      WriteLn(F, Format('%14.2n', [aCFOP[iItem].Valor]) + ' ');
    end;
    if sCFOP <> '' then
    begin
      Write(F, Replicate(' ', 5) + ' ');
      Write(F, Replicate(' ', 14) + ' ');
      WriteLn(F, Format('%14.2n', [dTotalCFOPCSTPISCOFINS]));
      dTotalCFOPCSTPISCOFINS := 0.00;
    end;
    WriteLn(F, '                     -------------- ');
    WriteLn(F, '                     ' + Format('%14.2n',[dTotalCFOP]) + ' ');
    WriteLn(F, '');
    WriteLn(F, '');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
    begin
      WriteLn(F, 'Acumulado por CST ICMS');
      WriteLn(F, '');
      WriteLn(F, 'CST ICMS CST PIS/COFINS Total          ');
    end
    else
    begin
      WriteLn(F, 'Acumulado por CSOSN');
      WriteLn(F, '');
      WriteLn(F, 'CSOSN    CST PIS/COFINS Total          ');
    end;
    WriteLn(F, '-------- -------------- -------------- ');

    dTotalCSTCSOSN := 0.00;
    dTotalPISCOFINSCSTCSOSN := 0.00;
    sCSTCSOSN := '--';
    for iItem := 0 to Length(aCSTCSOSN) - 1 do
    begin
      if sCSTCSOSN <> aCSTCSOSN[iItem].CSTCSOSN then
      begin
        if sCSTCSOSN <> '--' then
        begin
          Write(F, Replicate(' ', 8) + ' ');
          Write(F, Replicate(' ', 14) + ' ');
          WriteLn(F, Format('%14.2n', [dTotalPISCOFINSCSTCSOSN]));
          dTotalPISCOFINSCSTCSOSN := 0.00;
        end;
        sCSTCSOSN := aCSTCSOSN[iItem].CSTCSOSN;
      end;

      dTotalCSTCSOSN             := dTotalCSTCSOSN + aCSTCSOSN[iItem].Valor;
      dTotalPISCOFINSCSTCSOSN := dTotalPISCOFINSCSTCSOSN + aCSTCSOSN[iItem].Valor;
      Write(F, Copy(aCSTCSOSN[iItem].CSTCSOSN + Replicate(' ', 8), 1, 8) + ' ');
      Write(F, Copy(aCSTCSOSN[iItem].CSTPISCOFINS + Replicate(' ', 14), 1, 14) + ' ');
      WriteLn(F, Format('%14.2n', [aCSTCSOSN[iItem].Valor]) + ' ');
    end;
    if sCSTCSOSN <> '' then
    begin
      Write(F, Replicate(' ', 8) + ' ');
      Write(F, Replicate(' ', 14) + ' ');
      WriteLn(F, Format('%14.2n', [dTotalPISCOFINSCSTCSOSN]));
      dTotalPISCOFINSCSTCSOSN := 0.00;
    end;

    WriteLn(F, '                        -------------- ');
    WriteLn(F, '                        ' + Format('%14.2n', [dTotalCSTCSOSN]) + '');
    WriteLn(F,'');
    {Sandro Silva 2022-10-14 fim}

    WriteLn(F,'');
    Writeln(F,'Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal));
  end;
end;

procedure TForm38.RelatorioCompleRestICMS_ST(var F: TextFile; dInicio, dFinal : TdateTime);
var
  fTotal1 : Real;
begin
  fTotal1  := 0;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Modelo</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Numero NF</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Descri��o</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>C�digo</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>NCM</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Qtd.</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>VBCST Entrada</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total Venda</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Diferen�a</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Alq. Interna</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Valor ICMS Final</font></th>');
    WriteLn(F,' </tr>');
  end;

  Form7.ibQuery99.Close;
  Form7.ibQuery99.SQL.Clear;
  Form7.ibQuery99.SQL.Add(
                          'select'+
                          '    V.MODELO,'+
                          '    V.NUMERONF,'+
                          '    I1.DESCRICAO,'+
                          '    E.CODIGO,'+
                          '    E.CF as NCM,'+
                          '    I1.QUANTIDADE as QTD_VENDIDA,'+
                          '    (select first 1 ((coalesce(VBCST, 0) / coalesce(QUANTIDADE, 0)) * I1.QUANTIDADE) from ITENS002 I where CODIGO = E.CODIGO and coalesce(VBCST, 0) <> 0 order by REGISTRO desc) as VBCST_ENTRADA,'+
                          '    I1.TOTAL as TOTAL_VENDA,'+
                          '    coalesce(I1.TOTAL, 0) - (select first 1 ((coalesce(VBCST, 0) / coalesce(QUANTIDADE, 0) * I1.QUANTIDADE)) from ITENS002 I where I.CODIGO = E.CODIGO and coalesce(VBCST, 0) <> 0 order by REGISTRO desc) as DIFERENCA,'+
                          '    I1.ICM as ALQ_INTERNA,'+
                          '    (coalesce(I1.TOTAL, 0) - (select first 1 ((coalesce(VBCST, 0) / coalesce(QUANTIDADE, 0) * I1.QUANTIDADE)) from ITENS002 I where I.CODIGO = E.CODIGO and coalesce(VBCST, 0) <> 0 order by REGISTRO desc)) / 100 * I1.ICM as V_ICMS_FINAL'+
                          '    from ITENS001 I1'+
                          '    join VENDAS V on V.NUMERONF = I1.NUMERONF'+
                          '    join ESTOQUE E on E.CODIGO = I1.CODIGO'+
                          '        where V.NFEXML is not null and V.EMISSAO between '+QuotedStr(DateToStrInvertida(dInicio))+' and '+QuotedStr(DateToStrInvertida(dFinal))+' '+
                          '            and V.EMITIDA = ''S'''+
                          '            and V.INDFINAL = ''1'''+
                          '            and (substring(I1.CST_ICMS from 2 for 2) = ''60'' or (I1.CST_ICMS = ''500''))'+
                          ''+
                          'union'+
                          ' '+
                          ' select MODELO, right(NUMERONF, 12) as NUMERONF, DESCRICAO, CODIGO, NCM, QTD_VENDIDA, VBCST_ENTRADA, TOTAL_VENDA, (TOTAL_VENDA - VBCST_ENTRADA) as DIFERENCA, ALQ_INTERNA, ((TOTAL_VENDA - VBCST_ENTRADA) / 100 * ALQ_INTERNA) as V_ICMS_FINAL from'+
                          ' ('+
                          ' select'+
                          '    N.MODELO,'+
                          '    N.NUMERONF,'+
                          '    A1.DESCRICAO,'+
                          '    E.CODIGO,'+
                          '    E.CF as NCM,'+
                          '    A1.QUANTIDADE as QTD_VENDIDA,'+
                          '    (select first 1 ((coalesce(VBCST, 0) / coalesce(QUANTIDADE, 0)) * A1.QUANTIDADE) from ITENS002 I where CODIGO = E.CODIGO and coalesce(VBCST, 0) <> 0 order by REGISTRO desc) as VBCST_ENTRADA,'+
                          '    A1.TOTAL as TOTAL_VENDA,'+
                          '    case when coalesce(E.ALIQUOTA_NFCE, 0) = 0 then'+
                          '       coalesce((select first 1 ICM.'+Form7.ibDataSet13ESTADO.AsString+'_ from ICM where ICM.ST = E.ST and ICM.ST <> ''''), 0)'+
                          '    else'+
                          '      E.ALIQUOTA_NFCE'+
                          '    end as ALQ_INTERNA'+
                          '        from ALTERACA A1'+
                          '        join NFCE N on N.NUMERONF = A1.PEDIDO and N.CAIXA = A1.CAIXA'+
                          '        join ESTOQUE E on E.CODIGO = A1.CODIGO'+
                          '            where N.NFEXML is not null and N.DATA between '+QuotedStr(DateToStrInvertida(dInicio))+' and '+QuotedStr(DateToStrInvertida(dFinal))+' and upper(N.STATUS) starting ''AUTORIZADO'' '+
                          '                    and (substring(A1.CST_ICMS from 2 for 2) = ''60'' or (A1.CSOSN = ''500'')) '+
                          '                    and A1.DESCRICAO <> ''<CANCELADO>'' '+
                          '                    and A1.DESCRICAO <> ''Desconto'' '+
                          '                    and A1.DESCRICAO <> ''Acr�scimo'' '+
                          '                    and A1.TIPO <> ''CANCEL'' '+
                          '                    order by NUMERONF'+
                          ')'
                          );

  Form7.ibQuery99.Open;

  while (not Form7.ibQuery99.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    Application.ProcessMessages;

    if Form1.bHtml1 then
    begin
      WriteLn(F,'   <tr>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibQuery99.FieldByname('MODELO').AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibQuery99.FieldByname('NUMERONF').AsString,1,9)+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibQuery99.FieldByname('DESCRICAO').AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibQuery99.FieldByname('CODIGO').AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibQuery99.FieldByname('NCM').AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibQuery99.FieldByname('QTD_VENDIDA').AsFloat])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibQuery99.FieldByname('VBCST_ENTRADA').AsFloat])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibQuery99.FieldByname('TOTAL_VENDA').AsFloat])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibQuery99.FieldByname('DIFERENCA').AsFloat])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibQuery99.FieldByname('ALQ_INTERNA').AsFloat])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibQuery99.FieldByname('V_ICMS_FINAL').AsFloat])+'<br></font></td>');
      WriteLn(F,'   </tr>');
    end;

    fTotal1  := fTotal1 + Form7.ibQuery99.FieldByname('V_ICMS_FINAL').AsFloat;

    Form7.ibQuery99.Next;
  end;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'  <tr bgcolor=#'+Form1.sHtmlCor+'   FF7F00>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal1])+'<br></font></td>');
    WriteLn(F,'  </tr>');
    WriteLn(F,' </table>');
    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br>');
    WriteLn(F,'</center>');
  end;
end;

procedure TForm38.RelatorioIPI(var F: TextFile; dInicio, dFinal : TdateTime);
var
  fTotal : Real;
begin
  fTotal  := 0;
  
  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Data</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>NF</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Cliente</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>IPI</font></th>');
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    WriteLn(F,'');
    WriteLn(F,'DATA       NF     CLIENTE                                IPI       ');
    WriteLn(F,'---------- ------ -------------------------------------- ------------');
  end;

  Form7.IBDataSet15.Close;
  Form7.IBDataSet15.SelectSQL.Clear;
  Form7.IBDataSet15.SelectSQL.Add('select * from VENDAS where EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and IPI > 0 and EMITIDA=''S'' order by EMISSAO, NUMERONF');
  Form7.IBDataSet15.Open;
  Form7.IBDataSet15.First;

  while (not Form7.ibDataSet15.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    Application.ProcessMessages;

    if Form1.bHtml1 then
    begin
      WriteLn(F,'   <tr>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+DateToStr(Form7.ibDataSet15EMISSAO.AsDateTime)+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9)+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet15CLIENTE.AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[Form7.ibDataSet15IPI.AsFloat])+'<br></font></td>');
      WriteLn(F,'   </tr>');
    end else
    begin
      Write(F,DateToStr(Form7.ibDataSet15EMISSAO.AsDateTime)+' ');
      Write(F,Copy(Form7.ibDataSet15NUMERONF.AsString+Replicate(' ',9) ,1,9)+' ');
      Write(F,Copy(Form7.ibDataSet15CLIENTE.AsString+Replicate(' ',38),1,38)+' ');
      WriteLn(F,Format('%12.'+Form1.ConfCasas+'n',[Form7.ibDataSet15IPI.AsFloat])+' ');
    end;

    fTotal  := fTotal + Form7.ibDataSet15IPI.AsFloat;
    Form7.ibDataSet15.Next;
  end;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'  <tr bgcolor=#'+Form1.sHtmlCor+'   FF7F00>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal])+'<br></font></td>');
    WriteLn(F,'  </tr>');
    WriteLn(F,' </table>');
    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br>');
    WriteLn(F,'</center>');
  end else
  begin
    WriteLn(F,Replicate(' ',57)+'------------');
    WriteLn(F,Replicate(' ',57)+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'');
    WriteLn(F,'');
    Writeln(F,'Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal));
  end;
end;

procedure TForm38.RelatorioServicos(var F: TextFile; dInicio, dFinal : TdateTime);
var
  fTotal : Real;
begin
  fTotal  := 0;
  
  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Data</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Nota</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>OS</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Descri��o dos servi�os</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Valor</font></th>');
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    WriteLn(F,'');
    WriteLn(F,'DATA       NF      OS    DESCRI��O DOS SERVI�OS                 VALOR       ');
    WriteLn(F,'---------- ------ ------ -------------------------------------- ------------');
  end;

  Form7.IBDataSet15.Close;
  Form7.IBDataSet15.SelectSQL.Clear;
  Form7.IBDataSet15.SelectSQL.Add('select * from VENDAS where EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and SERVICOS > 0 and EMITIDA=''S'' order by EMISSAO, NUMERONF');
  Form7.IBDataSet15.Open;
  Form7.IBDataSet15.First;

  while (not Form7.ibDataSet15.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    Application.ProcessMessages;

    Form7.ibDataSet35.Close;
    Form7.ibDataSet35.SelectSQL.Clear;
    Form7.ibDataSet35.SelectSQL.Add('select * from ITENS003 where NUMERONF='+QuotedStr(Form7.ibDataSet15NUMERONF.AsString)+'  order by REGISTRO');
    Form7.ibDataSet35.Open;
    Form7.ibDataSet35.First;

    while (not Form7.ibDataSet35.EOF) and (Form38.Caption <> 'Cancelar') do
    begin
      Application.ProcessMessages;

      if Form1.bHtml1 then
      begin
        WriteLn(F,'   <tr>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+DateToStr(Form7.ibDataSet15EMISSAO.AsDateTime)+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet35NUMERONF.AsString,1,9)+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet35NUMEROOS.AsString,1,10)+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet35DESCRICAO.AsString+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[Form7.ibDataSet35TOTAL.AsFloat])+'<br></font></td>');
        WriteLn(F,'   </tr>');
      end else
      begin
        Write(F,DateToStr(Form7.ibDataSet15EMISSAO.AsDateTime)+' ');
        Write(F,Copy(Form7.ibDataSet35NUMERONF.AsString+Replicate(' ',9) ,1,9)+' ');
        Write(F,Copy(Form7.ibDataSet35NUMEROOS.AsString+Replicate(' ',6) ,1,6)+' ');
        Write(F,Copy(Form7.ibDataSet35DESCRICAO.AsString+Replicate(' ',40),1,40)+' ');
        WriteLn(F,Format('%12.'+Form1.ConfCasas+'n',[Form7.ibDataSet35TOTAL.AsFloat])+' ');
      end;

      fTotal  := fTotal + Form7.ibDataSet35TOTAL.AsFloat;
      Form7.ibDataSet35.Next;
    end;
    Form7.ibDataSet15.Next;
  end;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'  <tr bgcolor=#'+Form1.sHtmlCor+'   FF7F00>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal])+'<br></font></td>');
    WriteLn(F,'  </tr>');
    WriteLn(F,' </table>');
    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br>');
    WriteLn(F,'</center>');
  end else
  begin
    WriteLn(F,'                                                                ------------');
    WriteLn(F,Replicate(' ',64)+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'');
    WriteLn(F,'');
    Writeln(F,'Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal));
  end;
end;


procedure TForm38.RelatorioServicosTecnico(var F: TextFile; dInicio, dFinal : TdateTime);
var
  fTotal : Real;
  sCampoData : string;
  sDescCampoData : string;
begin
  fTotal  := 0;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>T�cnico</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Valor</font></th>');
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    WriteLn(F,'');
    WriteLn(F,'T�cnico                             Valor');
    WriteLn(F,'----------------------------------- ------------');
  end;

  {Mauricio Parizotto 2024-05-14 Inicio}

  if rbDataAgendada.Checked then
  begin
    sCampoData     := 'OS.DATA_PRO';
    sDescCampoData := 'Data agendada';
  end;

  if rbDataCriacao.Checked then
  begin
    sCampoData     := 'OS.DATA';
    sDescCampoData := 'Data cria��o';
  end;

  if rbDataFechada.Checked then
  begin
    sCampoData     := 'OS.DATA_ENT';
    sDescCampoData := 'Data fechada';
  end;

  Form7.IBDataSet99.Close;
  Form7.IBDataSet99.SelectSQL.Clear;
  Form7.IBDataSet99.SelectSQL.Add(' Select ITENS003.TECNICO,'+
                                  '   sum(ITENS003.TOTAL) '+
                                  ' From ITENS003, OS '+
                                  ' Where ITENS003.NUMEROOS=OS.NUMERO '+
                                  '   and '+sCampoData+' <='+QuotedStr(DateToStrInvertida(dFinal))+
                                  '   and '+sCampoData+' >='+QuotedStr(DateToStrInvertida(dInicio))+
                                  ' Group by TECNICO');
  Form7.IBDataSet99.Open;
  Form7.IBDataSet99.First;

  {Mauricio Parizotto 2024-05-14 Fim}

  while not Form7.ibDataSet99.EOF do
  begin
    if Form1.bHtml1 then
    begin
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByname('TECNICO').AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[Form7.ibDataSet99.FieldByname('SUM').AsFloat])+'<br></font></td>');
      WriteLn(F,'   </tr>');
    end else
    begin
      Write(F,Copy(Form7.ibDataSet99.FieldByname('TECNICO').AsString+Replicate(' ',35),1,35)+' ');
      WriteLn(F,Format('%12.'+Form1.ConfCasas+'n',[Form7.ibDataSet99.FieldByname('SUM').AsFloat])+'');
    end;

    fTotal  := fTotal + Form7.ibDataSet99.FieldByname('SUM').AsFloat;
    Form7.ibDataSet99.Next;
  end;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'  <tr bgcolor=#'+Form1.sHtmlCor+'>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal])+'<br></font></td>');
    WriteLn(F,'  </tr>');
    WriteLn(F,' </table>');
    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>'+sDescCampoData+' de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br>');
    WriteLn(F,'</center>');
  end else
  begin
    WriteLn(F,'                                    ------------');
    WriteLn(F,Replicate(' ',36)+ Format('%12.'+Form1.ConfPreco+'n',[fTotal])+' ');
    WriteLn(F,'');
    Writeln(F,sDescCampoData+' de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'');
  end;
end;


procedure TForm38.RelatorioVendasVendedor(var F: TextFile; dInicio, dFinal : TdateTime);
var
  fTotal, fTotal1, fTotal2, fTotalIndefinido : Real;
  Mais1Ini : TiniFile;
  I : Integer;
begin
  fTotal  := 0;

  // GRAFICO
  DeleteFile(pChar(Form1.sAtual+'\vendedores.png'));
  DeleteFile(pChar(Form1.sAtual+'\vendedores.gra'));

  // cria o vendedores.gra
  Mais1ini := TIniFile.Create(Form1.sAtual+'\vendedores.gra');

  // Titulo
  Mais1Ini.WriteString('DADOS','3D','1');
  Mais1Ini.WriteString('DADOS','MarcasS1','1');
  Mais1Ini.WriteString('DADOS','Legenda','0');
  Mais1Ini.WriteString('DADOS','TipoS1','4');
  Mais1Ini.WriteString('DADOS','AlturaBmp','800');
  Mais1Ini.WriteString('DADOS','LarguraBmp','1600');

  Mais1Ini.WriteString('DADOS','Titulo','Vendas por vendedor');
  Mais1Ini.WriteString('DADOS','NomeBmp','vendedores.png');

  Mais1Ini.WriteString('DADOS','FontSize','30'); //'11577023' // '15381040'
  Mais1Ini.WriteString('DADOS','FontSizeLabel','7');

  if Form1.bHtml1 then
  begin
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Vendedor</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Valor</font></th>');
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    WriteLn(F,'');
    WriteLn(F,'Vendedor                            Valor');
    WriteLn(F,'----------------------------------- ------------');
  end;

  Form7.IBDataSet99.Close;
  Form7.IBDataSet99.SelectSQL.Clear;
  Form7.IBDataSet99.SelectSQL.Add('select VENDEDOR, sum(MERCADORIA+SERVICOS-DESCONTO) from VENDAS, ICM where EMITIDA=''S'' and EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and ICM.NOME=VENDAS.OPERACAO and ( (upper(SubString(ICM.INTEGRACAO from 1 for 5)) =''CAIXA'') or (upper(SubString(ICM.INTEGRACAO from 1 for 7)) =''RECEBER'' )) group by VENDEDOR');
  Form7.IBDataSet99.Open;
  Form7.IBDataSet99.First;

  Form7.IBDataSet100.Close;
  Form7.IBDataSet100.SelectSQL.Clear;
  Form7.IBDataSet100.SelectSQL.Add('select VENDEDOR, sum(TOTAL) from ALTERACA where DATA<='+QuotedStr(DateToStrInvertida(dFinal))+' and DATA>='+QuotedStr(DateToStrInvertida(dInicio))+' and (TIPO='+QuotedStr('BALCAO')+' or TIPO='+QuotedStr('VENDA')+') group by VENDEDOR');
  Form7.IBDataSet100.Open;
  Form7.IBDataSet100.First;

  I := 0;

  Form7.ibDataSet9.Close;
  Form7.ibDataSet9.SelectSQL.Clear;
  Form7.ibDataSet9.SelectSQL.Add('select * FROM VENDEDOR where FUNCAO like '+QuotedStr('%VENDEDOR%')+' order by upper(NOME)');
  Form7.ibDataSet9.Open;
  Form7.ibDataSet9.First;
  Form7.ibDataSet9.DataSource := Nil;

  Form7.ibDataSet9.First;

  while not Form7.ibDataSet9.EOF do
  begin
    Form7.IBDataSet99.Locate('VENDEDOR',Form7.ibDataSet9.FieldByname('NOME').AsString,[]);
    Form7.IBDataSet100.Locate('VENDEDOR',Form7.ibDataSet9.FieldByname('NOME').AsString,[]);

    fTotal1 := 0;
    fTotal2 := 0;

    if AllTrim(Form7.ibDataSet9.FieldByName('NOME').AsString) = AllTrim(Form7.ibDataSet99.FieldByName('VENDEDOR').AsString) then
      fTotal1 := fTotal1 + Form7.ibDataSet99.FieldByname('SUM').AsFloat;

    if AllTrim(Form7.ibDataSet9.FieldByName('NOME').AsString) = AllTrim(Form7.ibDataSet100.FieldByName('VENDEDOR').AsString) then
      fTotal2 := fTotal2 + Form7.ibDataSet100.FieldByname('SUM').AsFloat;

    if Form1.bHtml1 then
    begin
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet9.FieldByname('NOME').AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[fTotal1+fTotal2])+'<br></font></td>');
      WriteLn(F,'   </tr>');

      I := I + 1;
      Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),'S1<'+
      StrTran(Format('%15.2n',[fTotal1+fTotal2]),'.','')
        +'>S2<'+'0,00'
                        +'>VX<'+StrZero(I,2,0)+'>LX<'+Form7.ibDataSet9.FieldByname('NOME').AsString+'>');
    end else
    begin
      Write(F,Copy(Form7.ibDataSet99.FieldByname('VENDEDOR').AsString+Replicate(' ',35),1,35)+' ');
      WriteLn(F,Format('%12.'+Form1.ConfCasas+'n',[fTotal1+fTotal2])+'');
    end;

    fTotal  := fTotal + fTotal1+fTotal2;
    Form7.ibDataSet9.Next;
  end;

  fTotalIndefinido := 0;
  Form7.ibDataSet99.First;

  while not Form7.ibDataSet99.EOF do
  begin
    if not Form7.IBDataSet9.Locate('NOME',Form7.ibDataSet99.FieldByname('VENDEDOR').AsString,[]) then
    begin
      fTotalIndefinido := fTotalIndefinido + Form7.ibDataSet99.FieldByname('SUM').AsFloat;
    end;
    Form7.ibDataSet99.Next;
  end;

  Form7.ibDataSet100.First;

  while not Form7.ibDataSet100.EOF do
  begin
    if not Form7.IBDataSet9.Locate('NOME',Form7.ibDataSet100.FieldByname('VENDEDOR').AsString,[]) then
    begin
      fTotalIndefinido := fTotalIndefinido + Form7.ibDataSet100.FieldByname('SUM').AsFloat;
    end;
    Form7.ibDataSet100.Next;
  end;

  fTotal := fTotal + fTotalIndefinido;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>?<br></font></td>');
    WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[fTotalIndefinido])+'<br></font></td>');
    WriteLn(F,'   </tr>');

    I := I + 1;
    Mais1Ini.WriteString('DADOS','XY'+StrZero(I,2,0),'S1<'+
    StrTran(Format('%15.2n',[ftotalIndefinido]),'.','')
      +'>S2<'+'0,00'
                      +'>VX<'+StrZero(I,2,0)+'>LX<?>');
  end else
  begin
    Write(F,Copy('?'+Replicate(' ',35),1,35)+' ');
    WriteLn(F,Format('%12.'+Form1.ConfCasas+'n',[fTotalIndefinido])+'');
  end;

  WriteLn(F,'     <center><a href="'+Form1.sAtual+'\vendedores.png"><img src="vendedores.png" border="0" width=800 height=400></a>');

  Mais1Ini.Free;
  ShellExecute( 0, 'Open', 'graficos.exe', 'vendedores.gra SMALLSOFT', '', SW_SHOWMINNOACTIVE);
  while not FileExists(Form1.sAtual+'\vendedores.png') do sleep(100);

  if Form1.bHtml1 then
  begin
    WriteLn(F,'  <tr bgcolor=#'+Form1.sHtmlCor+'   FF7F00>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'   <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal])+'<br></font></td>');
    WriteLn(F,'  </tr>');
    WriteLn(F,' </table>');
    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br>');
    WriteLn(F,'</center>');
  end else
  begin
    WriteLn(F,'                                    ------------');
    WriteLn(F,Replicate(' ',36)+ Format('%12.'+Form1.ConfPreco+'n',[fTotal])+' ');
    WriteLn(F,'');
    Writeln(F,'Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'');
  end;
end;

procedure TForm38.RelatorioPrevisaoCompra(var F: TextFile; dInicio, dFinal : TdateTime);
var
  fTotal : Real;
  sDias, sOBS : String;
begin
  Screen.Cursor  := crAppStart;    // Cursor de Aguardo

  btnAvancar.Enabled := False;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');;
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+' align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>C�digo</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Descri��o</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Estoque atual</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>M�dia de venda</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Per�odo</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Estoque para</font></th>');
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    WriteLn(F,'');
    WriteLn(F,'C�d   Descri��o                           Estoque atual  M�dia de venda Per�odo         Estoque para');
    WriteLn(F,'----- ----------------------------------- -------------- -------------- --------------- ---------------');
  end;

  Form7.ibDataSet4.First;

  while (not Form7.ibDataSet4.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    Application.ProcessMessages;
    Screen.Cursor  := crAppStart;    // Cursor de Aguardo

    Form7.ibDataSet4.Edit;
    Form7.ibDataSet4QTD_VEND.AsFloat := 0;
    Form7.ibDataSet4VAL_VEND.AsFloat := 0;
    Form7.ibDataSet4LUC_VEND.AsFloat := 0;

    if Form7.ibDataSet4ATIVO.AsString<>'1' then
    begin
      // Itens de venda
      Form7.ibDataSet16.Close;
      Form7.ibDataSet16.SelectSQL.Clear;
      Form7.ibDataSet16.SelectSQL.Add('select * from ITENS001 where DESCRICAO='+QuotedStr(Form7.ibDataSet4DESCRICAO.AsString)+' and coalesce(QUANTIDADE,0) = coalesce(SINCRONIA,0)');
      Form7.ibDataSet16.Open;
      Form7.ibDataSet16.First;

      while (not Form7.ibDataSet16.Eof) and (Form38.Caption <> 'Cancelar') do
      begin
        Application.ProcessMessages;

        Form7.ibDataSet4QTD_VEND.AsFloat := Form7.ibDataSet4QTD_VEND.AsFloat + Form7.ibDataSet16QUANTIDADE.AsFloat;
        Form7.ibDataSet4VAL_VEND.AsFloat := Form7.ibDataSet4VAL_VEND.AsFloat + (Form7.ibDataSet16QUANTIDADE.AsFloat * Form7.ibDataSet16UNITARIO.AsFloat);
        Form7.ibDataSet4CUS_VEND.AsFloat := Form7.ibDataSet4CUS_VEND.AsFloat + (Form7.ibDataSet16QUANTIDADE.AsFloat * Form7.ibDataSet16CUSTO.AsFloat);
        Form7.ibDataSet4LUC_VEND.AsFloat := Form7.ibDataSet4VAL_VEND.AsFloat - Form7.ibDataSet4CUS_VEND.AsFloat;

        Form7.ibDataSet16.Next;
      end;

      // Itens de venda ECF
      Form7.ibDataSet27.Close;
      Form7.ibDataSet27.SelectSQL.Clear;
      Form7.ibDataSet27.SelectSQL.Add('select * from ALTERACA where DESCRICAO='+QuotedStr(Form7.ibDataSet4DESCRICAO.AsString)+' and (TIPO='+QuotedStr('BALCAO')+' or TIPO='+QuotedStr('VENDA')+')');
      Form7.ibDataSet27.Open;
      Form7.ibDataSet27.First;

      while (not Form7.ibDataSet27.Eof) and (Form38.Caption <> 'Cancelar') do
      begin
        Application.ProcessMessages;
        Form7.ibDataSet4QTD_VEND.AsFloat := Form7.ibDataSet4QTD_VEND.AsFloat + Form7.ibDataSet27QUANTIDADE.AsFloat;
        Form7.ibDataSet4VAL_VEND.AsFloat := Form7.ibDataSet4VAL_VEND.AsFloat + (Form7.ibDataSet23QUANTIDADE.AsFloat * Form7.ibDataSet23UNITARIO.AsFloat);
        Form7.ibDataSet4CUS_VEND.AsFloat := Form7.ibDataSet4CUS_VEND.AsFloat + (Form7.ibDataSet23QUANTIDADE.AsFloat * Form7.ibDataSet23CUSTO.AsFloat);
        Form7.ibDataSet4LUC_VEND.AsFloat := Form7.ibDataSet4VAL_VEND.AsFloat - Form7.ibDataSet4CUS_VEND.AsFloat;
        Form7.ibDataSet27.Next;
      end;
    end;
    
    Form7.ibDataSet4.Next;
  end;

  // Arquivo de produtos
  Form7.ibDataSet4.First;
  while (not Form7.ibDataSet4.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    if Form7.ibDataSet4ATIVO.AsString<>'1' then
    begin
      Application.ProcessMessages;
      try
        fTotal := Form7.ibDataSet4QTD_VEND.AsFloat / ((Date - Form7.ibDataSet4DAT_INICIO.AsDateTime)/30);
      except
        fTotal := 0
      end;

      if fTotal                  = 0 then
        sOBS := 'N�o vende'
      else
      begin
        sOBS := Format('%4.1n',[Form7.ibDataSet4QTD_ATUAL.AsFloat / fTotal * 30])+ ' dias';
        if (Form7.ibDataSet4QTD_ATUAL.AsFloat / fTotal * 30)>= 30 then
           sOBS := Format('%4.1n',[(Form7.ibDataSet4QTD_ATUAL.AsFloat / fTotal)])+ ' meses';
        if (Form7.ibDataSet4QTD_ATUAL.AsFloat / fTotal * 30)>= 360 then
           sOBS := Format('%4.1n',[(Form7.ibDataSet4QTD_ATUAL.AsFloat / fTotal)*30 /360])+ ' anos';
      end;
      
      if Form7.ibDataSet4QTD_ATUAL.AsFloat <= 0 then
        sOBS := 'Em falta';

      sDias := Format('%2.0n',[Date - Form7.ibDataSet4DAT_INICIO.AsDateTime]) + ' dias ';
      if (Date - Form7.ibDataSet4DAT_INICIO.AsDateTime)>= 30 then
         sDias := Format('%2.0n',[(Date - Form7.ibDataSet4DAT_INICIO.AsDateTime)/30]) + ' meses';
      if (Date - Form7.ibDataSet4DAT_INICIO.AsDateTime)>= 360 then
         sDias := Format('%2.0n',[(Date - Form7.ibDataSet4DAT_INICIO.AsDateTime)/360]) + ' anos ';

      if AllTrim(sDias) = '1 dias'  then
        sDias := '1 dia';

      if AllTrim(sDias) = '1 meses' then
        sDias := '1 m�s';

      if AllTrim(sDias) = '1 anos'  then
        sDias := '1 ano';

      if AllTrim(sOBS) = '1 dias'  then
        sOBS := '1 dia';

      if AllTrim(sOBS) = '1 meses' then
        sOBS := '1 m�s';

      if AllTrim(sOBS) = '1 anos'  then
        sOBS := '1 ano';

      if Form1.bHtml1 then
      begin
        WriteLn(F,'   <tr>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet4CODIGO.AsString+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet4DESCRICAO.AsString +'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+ Format('%7.'+Form1.ConfCasas+'n',[Form7.ibDataSet4QTD_ATUAL.AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+ Format('%7.'+Form1.ConfPreco+'n',[fTotal])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=Left><font face="Microsoft Sans Serif" size=1>'+ AllTrim(sDias)+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=Left><font face="Microsoft Sans Serif" size=1>'+ AllTrim(sOBS)+'<br></font></td>');
        WriteLn(F,'   </tr>');
      end else
      begin
        Write(F,Copy(Form7.ibDataSet4CODIGO.AsString,1,5)+' ');
        Write(F,Copy(Form7.ibDataSet4DESCRICAO.AsString+Replicate(' ',35),1,35)+' ');
        Write(F,Format('%14.'+Form1.ConfCasas+'n',[Form7.ibDataSet4QTD_ATUAL.AsFloat])+' ');
        Write(F,Format('%14.'+Form1.ConfPreco+'n',[fTotal])+' ');
        Write(F,Copy(AllTrim(sDias)+Replicate(' ',15),1,15)+' ');
        WriteLn(F,Copy(AllTrim(sOBS)+Replicate(' ',15),1,15)+' ');
      end;
    end;
    
    Form7.ibDataSet4.Next;
  end;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'   </table>');
    WriteLn(F,'</center>');
  end else
  begin
    WriteLn(F,' ');
    WriteLn(F,' ');
  end;
end;

procedure TForm38.RelatorioResumoCompra(var F: TextFile; dInicio, dFinal : TdateTime);
var
  fTotal1,fTotal2 : Real;
  sApagado  : String;
  fApagado  : Real;
  Y : integer;
  F1: TextFile;
begin
  Screen.Cursor  := crAppStart;    // Cursor de Aguardo
  btnAvancar.Enabled := False;
  
  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center>');
    if Form38.Label21.Visible then WriteLn(F,'<center><font size=4 color=#000000><b>Para: '+Form7.ibDataSet2NOME.AsString+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');;
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Ordem</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>C�digo</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Descri��o</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Quantidade</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total de compra</font></th>');
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    if Form38.Label21.Visible then WriteLn(F,'Para: '+Form7.ibDataSet2NOME.AsString+' ');
    WriteLn(F,'');
    WriteLn(F,'Ordem C�d   Descri��o                           Quantidade     Total compra  ');
    WriteLn(F,'----- ----- ----------------------------------- -------------- --------------');
  end;

  // ITENS002 - COMPRAS
  Form7.ibDataSet99.Close;
  Form7.ibDataSet99.SelectSql.Clear;

  if Form38.Label21.Visible then  // Por fornecedor
  begin
    Form7.ibDataSet99.SelectSQL.Add(
    'select ITENS002.DESCRICAO, sum(ITENS002.QUANTIDADE)as vQTD1, sum(ITENS002.TOTAL)as vTOT1 from ITENS002, COMPRAS where (COMPRAS.EMISSAO between '
    +QuotedStr(DateToStrInvertida(dInicio)) + ' and ' + QuotedStr(DateToStrInvertida(dFinal))
    +') and COMPRAS.FORNECEDOR='+QuotedStr(Form7.IBDataSet2NOME.AsString)
    +' and COMPRAS.NUMERONF=ITENS002.NUMERONF and COMPRAS.FORNECEDOR=ITENS002.FORNECEDOR group by DESCRICAO');
  end else
  begin
    Form7.ibDataSet99.SelectSQL.Add(
    'select ITENS002.DESCRICAO, sum(ITENS002.QUANTIDADE)as vQTD1, sum(ITENS002.TOTAL)as vTOT1 from ITENS002, COMPRAS where (COMPRAS.EMISSAO between '
    +QuotedStr(DateToStrInvertida(dInicio)) + ' and ' + QuotedStr(DateToStrInvertida(dFinal))
    +') and COMPRAS.NUMERONF=ITENS002.NUMERONF and COMPRAS.FORNECEDOR=ITENS002.FORNECEDOR group by DESCRICAO');
  end;

  Form7.ibDataSet99.Open;

  sApagado := '';
  fApagado := 0;

  while not Form7.ibDataSet99.Eof do
  begin
    if (AllTrim(Form7.ibDAtaSet99.FieldByname('DESCRICAO').AsString) <> 'Desconto') and (AllTrim(Form7.ibDAtaSet99.FieldByname('DESCRICAO').AsString) <> 'Acr�cimo') then
    begin
      if not Form7.ibDataSet4.Locate('DESCRICAO',AllTrim(Form7.ibDAtaSet99.FieldByname('DESCRICAO').AsString),[]) then
      begin
        sApagado := sApagado + AllTrim(Form7.ibDAtaSet99.FieldByname('DESCRICAO').AsString) + '<br>';
        fApagado := fApagado + Form7.ibDataSet99.FieldByname('VTOT1').AsFloat;
      end else
      begin
        if Form7.ibDataSet4ULT_COMPRA.AsDateTime < dInicio then
        begin
          Form7.ibDataSet4.Edit;
          Form7.ibDataSet4ULT_COMPRA.AsDateTime := dInicio;
          Form7.ibDataSet4.Post;
        end;
      end;
    end;

    Form7.ibDataSet99.Next;
  end;

  Form7.ibDataSet4.First;
  
  while (not Form7.ibDataSet4.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    Application.ProcessMessages;
    Screen.Cursor  := crAppStart;    // Cursor de Aguardo

    if (Form7.ibDataSet4ULT_COMPRA.AsDateTime >= dInicio)
      or (Alltrim(UpperCase(ConverteAcentos(Form7.ibDataSet4DESCRICAO.AsString)))='DESCONTO')
      or (Alltrim(UpperCase(ConverteAcentos(Form7.ibDataSet4DESCRICAO.AsString)))='ACRESCIMO') then
    begin
      Form7.ibDataSet4.Edit;
      Form7.ibDataSet4QTD_VEND.AsFloat := 0;
      Form7.ibDataSet4CUS_VEND.AsFloat := 0;
      Form7.ibDataSet4VAL_VEND.AsFloat := 0;
      Form7.ibDataSet4LUC_VEND.AsFloat := 0;

      if (not Form7.ibDataSet99.IsEmpty) and (Form7.ibDataSet99.Locate('DESCRICAO',Form7.ibDAtaSet4DESCRICAO.AsString,[])) then
      begin
        Form7.ibDataSet4QTD_VEND.AsFloat := Form7.ibDataSet4QTD_VEND.AsFloat + Form7.ibDataSet99.FieldByname('VQTD1').AsFloat;
        Form7.ibDataSet4VAL_VEND.AsFloat := Form7.ibDataSet4VAL_VEND.AsFloat + Form7.ibDataSet99.FieldByname('VTOT1').AsFloat;
      end;
    end;

    Form7.ibDataSet4.Next;
  end;

  // Zeresima
  Y       := 0;
  fTotal1 := 0;
  fTotal2 := 0;

  // Lista o estoque
  Form7.ibDataSet4.Close;
  Form7.ibDataSet4.SelectSQL.Clear;

  if Form7.Caption = 'Controle de estoque' then
  begin
    Form7.ibDataSet4.SelectSQL.Add(Form7.sSelect+' '+Form7.sWhere+' order by VAL_VEND desc');
  end else
  begin
    Form7.ibDataSet4.SelectSQL.Add('select * from ESTOQUE order by VAL_VEND desc');
  end;

  Form7.ibDataSet4.Open;
  Form7.ibDataSet4.First;

  while (not Form7.ibDataSet4.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    if ((Form7.ibDataSet4QTD_VEND.AsFloat <> 0)
      and (Form7.ibDataSet4ULT_COMPRA.AsDateTime >= dInicio))
      or (Alltrim(UpperCase(ConverteAcentos(Form7.ibDataSet4DESCRICAO.AsString)))='DESCONTO')
      or (Alltrim(UpperCase(ConverteAcentos(Form7.ibDataSet4DESCRICAO.AsString)))='ACRESCIMO') then
    begin
      Y := Y + 1;

      if Form1.bHtml1 then
      begin
        WriteLn(F,'   <tr>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=center><font face="Microsoft Sans Serif" size=1>'+IntToStr(Y)+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet4CODIGO.AsString+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet4DESCRICAO.AsString +'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibDataSet4QTD_VEND.AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet4VAL_VEND.AsFloat])+'<br></font></td>');
        WriteLn(F,'   </tr>');
      end else
      begin
        Write(F,StrZero(Y,5,0)+' ');
        Write(F,Copy(Form7.ibDataSet4CODIGO.AsString+Replicate(' ',5),1,5)+' ');
        Write(F,Copy(Form7.ibDataSet4DESCRICAO.AsString+Replicate(' ',35),1,35)+' ');
        Write(F,Format('%14.'+Form1.ConfCasas+'n',[Form7.ibDataSet4QTD_VEND.AsFloat])+' ');
        Writeln(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet4VAL_VEND.AsFloat])+' ');
      end;
      
      fTotal2 := fTotal2 + Form7.ibDataSet4VAL_VEND.AsFloat;
    end;
    
    Form7.ibDataSet4.Next;
  end;
  
  if Form1.bHtml1 then
  begin
    WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal2])+'<br></font></td>');
    WriteLn(F,'    </tr>');

    WriteLn(F,'   <tr>');
    WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=center><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><a href="naolistados.htm">Itens n�o relacionados</a><br></font></td>');
    WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=center><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[fApagado])+'<br></font></td>');
    WriteLn(F,'   </tr>');

    WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[fTotal2 + fApagado])+'<br></font></td>');
    WriteLn(F,'    </tr>');

    WriteLn(F,'   </table>');
    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br>');

    // Filtros ativos
    WriteLn(F,'<br><font size=1>'+TraduzSql('Listando '+Form7.swhere+' e ordenado por valor total de compra',True)+'</font>');

    AssignFile(F1,pchar(Form1.sAtual+'\naolistados.htm'));
    Rewrite(F1);

    Writeln(F1,'<html><head><title>Itens n�o relacionados</title></head>');
    WriteLn(F1,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="10">');
    WriteLn(F1,'<br><font size=1 color=#000000>');
    WriteLn(F1,sApagado);

    WriteLn(F1,'<br><br>Estes itens n�o foram relacionados, por um dos seguintes motivos:');
    WriteLn(F1,'<br>');
    WriteLn(F1,'<br>1 - N�o faz parte do filtro');
    WriteLn(F1,'<br>2 - Foi APAGADO');
    WriteLn(F1,'<br>3 - Foi RENOMEADO');
    CloseFile(F1);                                    // Fecha o arquivo

    WriteLn(F,'</html>');

    WriteLn(F,'</center>');
  end else
  begin
    WriteLn(F,'                                                               --------------');
    Write(F,Replicate(' ',48+15));
    Write(F,Format('%14.'+Form1.ConfPreco+'n',[fTotal2])+' ');
    WriteLn(F,'');
    WriteLn(F,'');
    Writeln(F,'Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'');
  end;
end;

procedure TForm38.RelatorioVendasPara(var F: TextFile; dInicio, dFinal : TdateTime);
var
  fTotal : Real;
begin
  Screen.Cursor  := crAppStart;    // Cursor de Aguardo
  btnAvancar.Enabled := False;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>VENDAS (Notas Fiscais Emitidas)</b></font><br></center>');
    if Form38.Label21.Visible then WriteLn(F,'<center><font size=4 color=#000000><b>Para: '+Form7.ibDataSet2NOME.AsString+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');;

    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>NF</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Data</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>C�digo</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Descri��o do item</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Quantidade</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Unit�rio R$</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total R$</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Vendedor</font></th>');
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,'VENDAS (Notas Fiscais Emitidas)');
    if Form38.Label21.Visible then WriteLn(F,'Para: '+Form7.ibDataSet2NOME.AsString+' ');
    WriteLn(F,'');
    WriteLn(F,'NF     Data       C�d.  Descri��o                           Quantidade     Unit�rio       Total          Vendedor');
    WriteLn(F,'------ ---------- ----- ----------------------------------- -------------- -------------- -------------- --------------------');
  end;

  fTotal := 0;

  Form7.ibDataSet99.Close;
  Form7.ibDataSet99.SelectSql.Clear;

  Form7.ibDataSet99.SelectSQL.Add('select * from ITENS001 ,VENDAS where VENDAS.EMISSAO>= '+QuotedStr(DateToStrInvertida(dInicio))+
                            ' and VENDAS.EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+
                            ' and VENDAS.NUMERONF=ITENS001.NUMERONF'
                            +' and VENDAS.CLIENTE='+QuotedStr(Form7.IBDataSet2NOME.AsString)+
                            ' and VENDAS.EMITIDA=''S''  order by ITENS001.NUMERONF');
  
  Form7.ibDataSet99.Open;
  Form7.ibDataSet99.First;
  while not Form7.ibDAtaset99.Eof do
  begin
    if Form1.bHtml1 then
    begin
      WriteLn(F,'   <tr>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet99.FieldByname('NUMERONF').AsString,1,9)+'/'+Copy(Form7.ibDataSet99.FieldByname('NUMERONF').AsString,10,3)+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByname('EMISSAO').AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByname('CODIGO').AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByname('DESCRICAO').AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibDataSet99.FieldByname('QUANTIDADE').AsFloat])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet99.FieldByname('UNITARIO').AsFloat])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet99.FieldByname('TOTAL').AsFloat])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByname('VENDEDOR').AsString+'<br></font></td>');
      WriteLn(F,'   </tr>');
    end else
    begin
      Write(F,Copy(Form7.ibDataSet99.FieldByname('NUMERONF').AsString+Replicate(' ',50),1,9)+' ');
      Write(F,Copy(Form7.ibDataSet99.FieldByname('EMISSAO').AsString+Replicate(' ',50),1,10)+' ');
      Write(F,Copy(Form7.ibDataSet99.FieldByname('CODIGO').AsString+Replicate(' ',50),1,5)+' ');
      Write(F,Copy(Form7.ibDataSet99.FieldByname('DESCRICAO').AsString+Replicate(' ',50),1,35)+' ');
      Write(F,Format('%14.'+Form1.ConfCasas+'n',[Form7.ibDataSet99.FieldByname('QUANTIDADE').AsFloat])+' ');
      Write(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet99.FieldByname('UNITARIO').AsFloat])+' ');
      Write(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet99.FieldByname('TOTAL').AsFloat])+' ');
      WriteLn(F,Copy(Form7.ibDataSet99.FieldByname('VENDEDOR').AsString+Replicate(' ',50),1,20))
    end;

    fTotal  := fTotal + Form7.ibDataSet99.FieldByname('TOTAL').AsFloat;
    Form7.ibDataSet99.Next;
  end;

  Form7.ibDataSet99.Close;
  Form7.ibDataSet99.SelectSql.Clear;
  Form7.ibDataSet99.SelectSQL.Add('select sum(DESCONTO) as fDESCONTO from VENDAS where VENDAS.EMISSAO>= '+QuotedStr(DateToStrInvertida(dInicio))+' and VENDAS.EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and VENDAS.CLIENTE='+QuotedStr(Form7.IBDataSet2NOME.AsString)+' and VENDAS.EMITIDA=''S'' ');
  Form7.ibDataSet99.Open;

  if Form1.bHtml1 then
  begin
    if Form7.ibDataSet99.FieldByname('FDESCONTO').AsFloat <> 0 then
    begin
      WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br>Desconto</font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet99.FieldByname('FDESCONTO').AsFloat])+'</font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'    </tr>');

      fTotal := fTotal - Form7.ibDataSet99.FieldByname('FDESCONTO').AsFloat;
    end;

    WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal])+'<br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'    </tr>');

    WriteLn(F,'   </table>');
    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br>');
    WriteLn(F,'</center>');
  end else
  begin
    if Form7.ibDataSet99.FieldByname('FDESCONTO').AsFloat <> 0 then
    begin
      WriteLn(F,'Desconto                                                                          '+Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet99.FieldByname('FDESCONTO').AsFloat]));
      fTotal := fTotal - Form7.ibDataSet99.FieldByname('FDESCONTO').AsFloat;
    end;

    WriteLn(F,'                                                                                          --------------');
    WriteLn(F,'                                                                                          '+Format('%14.'+Form1.ConfPreco+'n',[fTotal]));
    WriteLn(F,'');
  end;
end;

procedure TForm38.RelatorioResumoVendas(var F: TextFile; dInicio, dFinal : TdateTime);
var
  sOperacoes : string;
  Y, I : integer;
  sApagado  : String;
  fApagado  : Real;

  fTotal1, fTotal2, fTotal3 : Real;
  fDescontos : Real;

  F1: TextFile;
begin
  Screen.Cursor  := crAppStart;    // Cursor de Aguardo

  Form7.ibDataSet4.Close;
  Form7.ibDataSet4.SelectSQL.Clear;
  Form7.ibDataSet4.SelectSQL.Add('select * from ESTOQUE order by DESCRICAO');

  Form7.ibDataSet4.Open;
  Form7.ibDataSet4.First;

  Form38.btnAvancar.Enabled := False;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center>');
    if Form38.Label21.Visible then WriteLn(F,'<center><font size=4 color=#000000><b>Para: '+Form7.ibDataSet2NOME.AsString+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');;
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Ordem</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>C�digo</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Descri��o</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Quantidade</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Custo de compra</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Vendido por</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Lucro bruto</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>%</font></th>');
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    if Form38.Label21.Visible then WriteLn(F,'Para: '+Form7.ibDataSet2NOME.AsString+' ');
    WriteLn(F,'');
    WriteLn(F,'Ordem C�d   Descri��o                           Quantidade     Custo compra   Vendido por    Lucro bruto    %');
    WriteLn(F,'----- ----- ----------------------------------- -------------- -------------- -------------- -------------- ------------');
  end;

  // ITENS001 - VENDAS
  Form7.ibDataSet99.Close;
  Form7.ibDataSet99.SelectSql.Clear;

  sOperacoes := '';

  //Testar usando sOperacoes := GetFiltroOperacao('VENDAS')
  for I := 0 to (chkOperacoes.Items.Count -1) do
  begin
    if not chkOperacoes.Checked[I] then
    begin
      sOperacoes := sOperacoes + ' and VENDAS.OPERACAO<>'+QuotedStr(chkOperacoes.Items[I])+' ';
    end;
  end;

  if Form38.Label21.Visible then  // Por cliente
  begin
    Form7.ibDataSet99.SelectSQL.Add(
    'select ITENS001.DESCRICAO, sum(ITENS001.QUANTIDADE)as vQTD1, sum(ITENS001.TOTAL)as vTOT1, sum(ITENS001.CUSTO*ITENS001.QUANTIDADE)as vCUS1 from ITENS001, VENDAS where'
    +' VENDAS.EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and VENDAS.EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' '
    +' and VENDAS.CLIENTE='+QuotedStr(Form7.IBDataSet2NOME.AsString)
    +' and VENDAS.NUMERONF=ITENS001.NUMERONF '+sOperacoes+' and VENDAS.EMITIDA=''S'' group by DESCRICAO');
  end else
  begin
    Form7.ibDataSet99.SelectSQL.Add(
    'select ITENS001.DESCRICAO, sum(ITENS001.QUANTIDADE)as vQTD1, sum(ITENS001.TOTAL)as vTOT1, sum(ITENS001.CUSTO*ITENS001.QUANTIDADE)as vCUS1 from ITENS001, VENDAS where'
    +' VENDAS.EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and VENDAS.EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' '
    +' and VENDAS.NUMERONF=ITENS001.NUMERONF '+sOperacoes+' and VENDAS.EMITIDA=''S'' group by DESCRICAO');
  end;

  Form7.ibDataSet99.Open;

  // ALTERACA
  Form7.ibDataSet100.Close;
  Form7.ibDataSet100.SelectSql.Clear;

  if Form38.Label21.Visible then  // Por cliente
  begin
    Form7.ibDataSet100.SelectSQL.Add(
                                      'select ALTERACA.DESCRICAO, sum(ALTERACA.QUANTIDADE)as vQTD2, sum(ALTERACA.TOTAL)as vTOT2 from ALTERACA where ALTERACA.DATA between '
                                      + QuotedStr(DateToStrInvertida(dInicio)) + ' and ' + QuotedStr(DateToStrInvertida(dFinal))
                                      +' and ALTERACA.CLIFOR='+QuotedStr(Form7.IBDataSet2NOME.AsString)
                                      + ' and (TIPO='+QuotedStr('BALCAO')
                                      + ' or TIPO='+QuotedStr('VENDA')+') group by DESCRICAO');
  end else
  begin
    Form7.ibDataSet100.SelectSQL.Add(
                                      'select ALTERACA.DESCRICAO, sum(ALTERACA.QUANTIDADE)as vQTD2, sum(ALTERACA.TOTAL)as vTOT2 from ALTERACA where ALTERACA.DATA between '
                                      +QuotedStr(DateToStrInvertida(dInicio)) + ' and ' + QuotedStr(DateToStrInvertida(dFinal))
                                      + ' and (TIPO='+QuotedStr('BALCAO')
                                      + ' or TIPO='+QuotedStr('VENDA')+') group by DESCRICAO');
  end;

  Form7.ibDataSet100.Open;

  Form7.ibDataSet99.First;

  sApagado := '';
  fApagado := 0;
  
  while not Form7.ibDataSet99.Eof do
  begin
    if (AllTrim(Form7.ibDAtaSet99.FieldByname('DESCRICAO').AsString) <> 'Desconto') and (AllTrim(Form7.ibDAtaSet99.FieldByname('DESCRICAO').AsString) <> 'Acr�cimo') then
    begin
      if not Form7.ibDataSet4.Locate('DESCRICAO',AllTrim(Form7.ibDAtaSet99.FieldByname('DESCRICAO').AsString),[]) then
      begin
        sApagado := sApagado + AllTrim(Form7.ibDAtaSet99.FieldByname('DESCRICAO').AsString) + '<br>';
        fApagado := fApagado + Form7.ibDataSet99.FieldByname('VTOT1').AsFloat;
      end else
      begin
        if Form7.ibDataSet4ULT_VENDA.AsDateTime < dInicio then
        begin
          Form7.ibDataSet4.Edit;
          Form7.ibDataSet4ULT_VENDA.AsDateTime := dInicio;
          Form7.ibDataSet4.Post;
        end;
      end;
    end;

    Form7.ibDataSet99.Next;
  end;

  while not Form7.ibDataSet100.Eof do
  begin
    if (AllTrim(Form7.ibDAtaSet100.FieldByname('DESCRICAO').AsString) <> 'Desconto') and (AllTrim(Form7.ibDAtaSet100.FieldByname('DESCRICAO').AsString) <> 'Acr�scimo') then
    begin
      if not Form7.ibDataSet4.Locate('DESCRICAO',AllTrim(Form7.ibDAtaSet100.FieldByname('DESCRICAO').AsString),[]) then
      begin
        sApagado := sApagado + AllTrim(Form7.ibDAtaSet100.FieldByname('DESCRICAO').AsString) + '<br>';
        fApagado := fApagado + Form7.ibDataSet100.FieldByname('VTOT2').AsFloat;
      end else
      begin
        if Form7.ibDataSet4ULT_VENDA.AsDateTime < dInicio then
        begin
          Form7.ibDataSet4.Edit;
          Form7.ibDataSet4ULT_VENDA.AsDateTime := dInicio;
          Form7.ibDataSet4.Post;
        end;
      end;
    end;
    Form7.ibDataSet100.Next;
  end;

  Form7.ibDataSet4.First;

  while (not Form7.ibDataSet4.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    Application.ProcessMessages;
    Screen.Cursor  := crAppStart;    // Cursor de Aguardo

    if (Form7.ibDataSet4ULT_VENDA.AsDateTime >= dInicio) then
    begin
      Form7.ibDataSet4.Edit;
      Form7.ibDataSet4QTD_VEND.AsFloat := 0;
      Form7.ibDataSet4CUS_VEND.AsFloat := 0;
      Form7.ibDataSet4VAL_VEND.AsFloat := 0;
      Form7.ibDataSet4LUC_VEND.AsFloat := 0;

      if (not Form7.ibDataSet99.IsEmpty) and (Form7.ibDataSet99.Locate('DESCRICAO',AllTrim(Form7.ibDAtaSet4DESCRICAO.AsString),[])) then
      begin
        Form7.ibDataSet4QTD_VEND.AsFloat := Form7.ibDataSet4QTD_VEND.AsFloat + Form7.ibDataSet99.FieldByname('VQTD1').AsFloat;
        Form7.ibDataSet4VAL_VEND.AsFloat := Form7.ibDataSet4VAL_VEND.AsFloat + Form7.ibDataSet99.FieldByname('VTOT1').AsFloat;
        Form7.ibDataSet4CUS_VEND.AsFloat := Form7.ibDataSet4CUS_VEND.AsFloat + Form7.ibDataSet99.FieldByname('VCUS1').AsFloat;
      end;

      if (not Form7.ibDataSet100.IsEmpty) and (Form7.ibDataSet100.Locate('DESCRICAO',AllTrim(Form7.ibDAtaSet4DESCRICAO.AsString),[])) then
      begin
        Form7.ibDataSet4QTD_VEND.AsFloat := Form7.ibDataSet4QTD_VEND.AsFloat + Form7.ibDataSet100.FieldByname('VQTD2').AsFloat;
        Form7.ibDataSet4VAL_VEND.AsFloat := Form7.ibDataSet4VAL_VEND.AsFloat + Form7.ibDataSet100.FieldByname('VTOT2').AsFloat;
        Form7.ibDataSet4CUS_VEND.AsFloat := Form7.ibDataSet4CUS_VEND.AsFloat + Form7.ibDataSet100.FieldByname('VQTD2').AsFloat * Form7.ibDataSet4CUSTOCOMPR.AsFloat;
      end;

      Form7.ibDataSet4LUC_VEND.AsFloat := Form7.ibDataSet4VAL_VEND.AsFloat - Form7.ibDataSet4CUS_VEND.AsFloat;
    end;

    Form7.ibDataSet4.Next;
  end;

  // Zeresima
  Y       := 0;
  fTotal1 := 0;
  fTotal2 := 0;
  fTotal3 := 0;

  // Lista o estoque
  Form7.ibDataSet4.Close;
  Form7.ibDataSet4.SelectSQL.Clear;

  if Form7.Caption = 'Controle de estoque' then
  begin
    Form7.ibDataSet4.SelectSQL.Add(Form7.sSelect+' '+Form7.sWhere+' order by LUC_VEND desc');
  end else
  begin
    Form7.ibDataSet4.SelectSQL.Add('select * from ESTOQUE order by LUC_VEND desc');
  end;

  Form7.ibDataSet4.Open;
  Form7.ibDataSet4.First;

  while (not Form7.ibDataSet4.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    if ((Form7.ibDataSet4QTD_VEND.AsFloat <> 0) and (Form7.ibDataSet4ULT_VENDA.AsDateTime >= dInicio)) then
    begin
      Y := Y + 1;

      if Form1.bHtml1 then
      begin
        WriteLn(F,'   <tr>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=center><font face="Microsoft Sans Serif" size=1>'+IntToStr(Y)+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet4CODIGO.AsString+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet4DESCRICAO.AsString +'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibDataSet4QTD_VEND.AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet4CUS_VEND.AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet4VAL_VEND.AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet4LUC_VEND.AsFloat])+'<br></font></td>');

        if Form7.ibDataSet4CUS_VEND.AsFloat <> 0
          then WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%8.'+Form1.ConfPreco+'n',[(Form7.ibDataSet4VAL_VEND.AsFloat / Form7.ibDataSet4CUS_VEND.AsFloat * 100)-100])+'<br></font></td>')
            else WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><br></font></td>');

        WriteLn(F,'   </tr>');
      end else
      begin
        Write(F,StrZero(Y,5,0)+' ');
        Write(F,Copy(Form7.ibDataSet4CODIGO.AsString+Replicate(' ',5),1,5)+' ');
        Write(F,Copy(Form7.ibDataSet4DESCRICAO.AsString+Replicate(' ',35),1,35)+' ');
        Write(F,Format('%14.'+Form1.ConfCasas+'n',[Form7.ibDataSet4QTD_VEND.AsFloat])+' ');
        Write(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet4CUS_VEND.AsFloat])+' ');
        Write(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet4VAL_VEND.AsFloat])+' ');
        Write(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet4LUC_VEND.AsFloat])+' ');

        if Form7.ibDataSet4CUS_VEND.AsFloat <> 0
          then WriteLn(F,Format('%12.'+Form1.ConfPreco+'n',[(Form7.ibDataSet4VAL_VEND.AsFloat / Form7.ibDataSet4CUS_VEND.AsFloat * 100)-100])+' ')
            else WriteLn(F,'');
      end;

      fTotal1 := fTotal1 + Form7.ibDataSet4CUS_VEND.AsFloat;
      fTotal2 := fTotal2 + Form7.ibDataSet4VAL_VEND.AsFloat;
      fTotal3 := fTotal3 + Form7.ibDataSet4LUC_VEND.AsFloat;
    end;

    Form7.ibDataSet4.Next;
  end;

  fdescontos := 0;
  
  // Desconto nas  Vendas NF
  if Form38.Label21.Visible then  // Por cliente
  begin
    Form7.IBQuery1.SQL.Clear;
    Form7.IBQuery1.SQL.Add('select sum(DESCONTO) from VENDAS where EMITIDA=''S'' and EMISSAO between '+QuotedStr(DateToStrInvertida(dInicio)) + ' and ' + QuotedStr(DateToStrInvertida(dFinal))+' and CLIENTE='+QuotedStr(Form7.IBDataSet2NOME.AsString));
    Form7.IBQuery1.Open;
    fDescontos := fDescontos + (Form7.IBQuery1.FieldByname('SUM').AsFloat*-1);
    Form7.IBQuery1.Close;

    // Desconto nas Vendas ECF
    Form7.IBQuery1.SQL.Clear;
    Form7.IBQuery1.SQL.Add('select sum(TOTAL) from ALTERACA where DATA between '+QuotedStr(DateToStrInvertida(dInicio)) + ' and ' + QuotedStr(DateToStrInvertida(dFinal))+' and DESCRICAO='+QuotedStr('Desconto')+' and CLIFOR='+QuotedStr(Form7.IBDataSet2NOME.AsString)+' and TIPO<>''CANCEL'' ');
    Form7.IBQuery1.Open;
    fDescontos := fDescontos + (Form7.IBQuery1.FieldByname('SUM').AsFloat);
    Form7.IBQuery1.Close;

    // Desconto nas Vendas ECF
    Form7.IBQuery1.SQL.Clear;
    Form7.IBQuery1.SQL.Add('select sum(TOTAL) from ALTERACA where DATA between '+QuotedStr(DateToStrInvertida(dInicio)) + ' and ' + QuotedStr(DateToStrInvertida(dFinal))+' and DESCRICAO='+QuotedStr('Acr�scimo')+' and CLIFOR='+QuotedStr(Form7.IBDataSet2NOME.AsString)+' and TIPO<>''CANCEL'' ');
    Form7.IBQuery1.Open;
    fDescontos := fDescontos + (Form7.IBQuery1.FieldByname('SUM').AsFloat);
    Form7.IBQuery1.Close;
  end else
  begin
    Form7.IBQuery1.SQL.Clear;
    Form7.IBQuery1.SQL.Add('select sum(DESCONTO) from VENDAS where  EMITIDA=''S'' and EMISSAO between '+QuotedStr(DateToStrInvertida(dInicio)) + ' and ' + QuotedStr(DateToStrInvertida(dFinal))+' ');
    Form7.IBQuery1.Open;
    fDescontos := fDescontos + (Form7.IBQuery1.FieldByname('SUM').AsFloat*-1);
    Form7.IBQuery1.Close;

    // Desconto nas Vendas ECF
    Form7.IBQuery1.SQL.Clear;
    Form7.IBQuery1.SQL.Add('select sum(TOTAL) from ALTERACA where DATA between '+QuotedStr(DateToStrInvertida(dInicio)) + ' and ' + QuotedStr(DateToStrInvertida(dFinal))+' and DESCRICAO='+QuotedStr('Desconto')+' and TIPO<>''CANCEL'' ');
    Form7.IBQuery1.Open;
    fDescontos := fDescontos + (Form7.IBQuery1.FieldByname('SUM').AsFloat);
    Form7.IBQuery1.Close;

    // Desconto nas Vendas ECF
    Form7.IBQuery1.SQL.Clear;
    Form7.IBQuery1.SQL.Add('select sum(TOTAL) from ALTERACA where DATA between '+QuotedStr(DateToStrInvertida(dInicio)) + ' and ' + QuotedStr(DateToStrInvertida(dFinal))+' and DESCRICAO='+QuotedStr('Acr�scimo')+' and TIPO<>''CANCEL'' ');
    Form7.IBQuery1.Open;
    fDescontos := fDescontos + (Form7.IBQuery1.FieldByname('SUM').AsFloat);
    Form7.IBQuery1.Close;
  end;

  fTotal2 := fTotal2 + fDescontos;

  if Form1.bHtml1 then
  begin
    if Pos('where',LowerCase(Form7.ibDataSet4.SelectSQL.Text)) = 0 then
    begin
      WriteLn(F,'   <tr>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=center><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>Descontos/Acr�scimos<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[fDescontos])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'   </tr>');

      WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal1])+'<br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal2])+'<br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal3])+'<br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b><br></font></td>');
      WriteLn(F,'    </tr>');

      WriteLn(F,'   <tr>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=center><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><a href="naolistados.htm">Itens n�o relacionados</a><br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[fApagado])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'   </tr>');

      WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[fTotal2 + fApagado])+'<br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b><br></font></td>');
      WriteLn(F,'    </tr>');
    end;

    WriteLn(F,'   </table>');
    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br>');

    // Filtros ativos
    WriteLn(F,'   <table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor=#FFFFFF align=left>');
    WriteLn(F,'     <td><P><font face="Microsoft Sans Serif" size=1><b>Opera��es listadas:</b><br>');
    for I := 0 to (chkOperacoes.Items.Count -1) do
      if chkOperacoes.Checked[I] then
          Writeln(F,'     <br><font face="Microsoft Sans Serif" size=1>'+AllTrim(chkOperacoes.Items[I]));

    Writeln(F,'     <br><font face="Microsoft Sans Serif" size=1>'+'Vendas por ECF, NFC-e ou SAT');
    WriteLn(F,'');
    Writeln(F,'      </td><br>');
    WriteLn(F,'     </td>');
    WriteLn(F,'    </table>');
    WriteLn(F,'<br><font size=1>'+TraduzSql('Listando '+Form7.swhere+' e ordenado por lucro bruto',True)+'</font>');

    WriteLn(F,'</center>');

    AssignFile(F1,pchar(Form1.sAtual+'\naolistados.htm'));
    Rewrite(F1);

    Writeln(F1,'<html><head><title>Itens n�o relacionados</title></head>');
    WriteLn(F1,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="10">');
    WriteLn(F1,'<br><font size=1 color=#000000>');
    WriteLn(F1,sApagado);

    WriteLn(F1,'<br><br>Estes itens n�o foram relacionados, por um dos seguintes motivos:');
    WriteLn(F1,'<br>');
    WriteLn(F1,'<br>1 - N�o faz parte do filtro');
    WriteLn(F1,'<br>2 - Foi APAGADO');
    WriteLn(F1,'<br>3 - Foi RENOMEADO');

    WriteLn(F1,'<br><br><br>OBS: Para fechar este relat�rio com o relat�rio de vendas por per�odo e por iten. Lembre-se de subtrair os descontos');
    CloseFile(F1);                                    // Fecha o arquivo
    WriteLn(F,'</html>');
  end else
  begin
    if Pos('where',LowerCase(Form7.ibDataSet4.SelectSQL.Text)) = 0 then
    begin
      Write(F,'       ');
      Write(F,'       ');
      Write(F,Copy('Descontos/Acr�scimos'+Replicate(' ',35),1,35)+' ');
      Write(F,Replicate(' ',14));
      Write(F,Replicate(' ',14));
      Write(F,Format('%14.'+Form1.ConfPreco+'n',[fDescontos])+' ');
      Write(F,Replicate(' ',14));
      WriteLn(F,'');
    end;

    WriteLn(F,'                                                               -------------- -------------- --------------');
    Write(F,Replicate(' ',48+15));
    Write(F,Format('%14.'+Form1.ConfPreco+'n',[fTotal1])+' ');
    Write(F,Format('%14.'+Form1.ConfPreco+'n',[fTotal2])+' ');
    Write(F,Format('%14.'+Form1.ConfPreco+'n',[fTotal3])+' ');
    WriteLn(F,'');
    WriteLn(F,'');
    Writeln(F,'Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'');

    // Filtros ativos
    WriteLn(F,TraduzSql('Listando '+Form7.swhere+' '+Form7.sOrderBy,True));
    WriteLn(F,'');
    WriteLn(F,'Opera��es listadas:');
    for I := 0 to (chkOperacoes.Items.Count -1) do
      if chkOperacoes.Checked[I] then
          Writeln(F,AllTrim(chkOperacoes.Items[I]));
    WriteLn(F,'Vendas por ECF, NFC-e ou SAT');
    WriteLn(F,'');
  end;

  Form7.ibDataSet4.EnableControls;
end;


procedure TForm38.RelatorioAuditoria(var F: TextFile; dInicio, dFinal : TdateTime);
begin
  Screen.Cursor  := crAppStart;    // Cursor de Aguardo
  Form38.btnAvancar.Enabled := False;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');;
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Data</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Hora</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Ato</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>M�dulo</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Usu�rio</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Hist�rico</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>De</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Para</font></th>');
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    WriteLn(F,'');
    WriteLn(F,'Data     Hora     Ato        M�dulo     Usu�rio         Hist�rico                                De           Para        ');
    WriteLn(F,'-------- -------- ---------- ---------- --------------- ---------------------------------------- ------------ ------------');
  end;

  // ITENS001 - VENDAS
  Form7.ibDataSet99.Close;
  Form7.ibDataSet99.SelectSql.Clear;
  Form7.ibDataSet99.SelectSQL.Add('select * from AUDIT0RIA where DATA between '+QuotedStr(DateToStrInvertida(dInicio)) +
                            ' and ' + QuotedStr(DateToStrInvertida(dFinal)) +
                            ' and USUARIO='+QuotedStr(Form38.ComboBox1.Text)+
                            ' order by DATA, HORA');
  Form7.ibDataSet99.Open;

  while (not Form7.ibDataSet99.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    if Form1.bHtml1 then
    begin
      WriteLn(F,'   <tr>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByname('DATA').AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByname('HORA').AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByname('ATO').AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByname('MODULO').AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByname('USUARIO').AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByname('HISTORICO').AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet99.FieldByname('VALOR_DE').AsFloat])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfPreco+'n',[Form7.ibDataSet99.FieldByname('VALOR_PARA').AsFloat])+'<br></font></td>');
      WriteLn(F,'   </tr>');
    end else
    begin
      Write(F,Copy(Form7.ibDataSet99.FieldByname('DATA').AsString+Replicate(' ',8),1,8)+' ');
      Write(F,Copy(Form7.ibDataSet99.FieldByname('HORA').AsString+Replicate(' ',8),1,8)+' ');
      Write(F,Copy(Form7.ibDataSet99.FieldByname('ATO').AsString+Replicate(' ',10),1,10)+' ');
      Write(F,Copy(Form7.ibDataSet99.FieldByname('MODULO').AsString+Replicate(' ',10),1,10)+' ');
      Write(F,Copy(Form7.ibDataSet99.FieldByname('USUARIO').AsString+Replicate(' ',15),1,15)+' ');
      Write(F,Copy(Form7.ibDataSet99.FieldByname('HISTORICO').AsString+Replicate(' ',40),1,40)+' ');
      Write(F,Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet99.FieldByname('VALOR_DE').AsFloat])+' ');
      Writeln(F,Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet99.FieldByname('VALOR_PARA').AsFloat])+' ');
    end;

    Form7.ibDataSet99.Next;
  end;

  {Mauricio Parizotto 2024-05-31}
  if Form1.bHtml1 then
  begin
    WriteLn(F,'   </td>');
  end;

  ListaPeiodoSelecionado(F,dInicio, dFinal);
end;

procedure TForm38.RelatorioCurvaABC_Clientes(var F: TextFile; dInicio, dFinal : TdateTime);
var
  fTotal, fTotal1, fTotal3, vPercAcumulado, vPercIndividual : Real;
  sOperacoes : string;
  I : integer;
begin
  Form7.IBDataSet2.DisableControls;

  fTotal3 := 0;
  vPercAcumulado := 0;

  {Mauricio Parizotto 2023-05-24 Inicio}
  sOperacoes := '';

  sOperacoes := GetFiltroOperacao('VENDAS');

  // Vendas com NF
  Form7.IBDataSet99.Close;
  Form7.IBDataSet99.SelectSQL.Clear;
  Form7.IBDataSet99.SelectSQL.Add(SqlSelectCurvaAbcClientes(dinicio, dfinal, sOperacoes));
  Form7.IBDataSet99.Open;
  {Mauricio Parizotto 2023-05-24 Fim}

  Form7.ibDataSet99.First;
  while (not Form7.ibDataSet99.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    Application.ProcessMessages;

    Form7.ibDataSet2.Close;
    Form7.ibDataSet2.Selectsql.Clear;
    Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet99.FieldByname('CLIENTE').AsString)+' '); 
    Form7.ibDataSet2.Open;

    if (Form7.ibDataSet99.FieldByname('CLIENTE').AsString = Form7.iBDataSet2NOME.AsString) and (Form7.iBDataSet2NOME.AsString <>'') then
    begin
      if Form7.ibDataSet99.FieldByName('VTOTAL').AsFloat <> 0 then
      begin
        fTotal3 := fTotal3 + Form7.ibDataSet99.FieldByname('VTOTAL').asFloat;
      end;
    end;

    Form7.ibDataSet99.Next;
  end;

  fTotal  := 0;
  fTotal1 := 0;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');;
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}' width=150><font face="Verdana" size=1>Cliente</font></th>');
    WriteLn(F,'  <th '+{nowrap}' width=150><font face="Verdana" size=1>Contato</font></th>');
    WriteLn(F,'  <th '+{nowrap}' width=150><font face="Verdana" size=1>Cidade</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Verdana" size=1>UF</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Verdana" size=1>Telefone</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Verdana" size=1>�lt. venda</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Verdana" size=1>ABC</font></th>');
    WriteLn(F,'  <th '+{nowrap}' width=250><font face="Verdana" size=1>OBS</font></th>');
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    WriteLn(F,'');
    WriteLn(F,'Cliente                             Contato              Cidade               UF Telefone             �lt Venda  ABC');
    WriteLn(F,'----------------------------------- -------------------- -------------------- -- -------------------- ---------- ---');
  end;

  Form7.ibDataSet99.First;
  while (not Form7.ibDataSet99.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    Form7.ibDataSet2.Close;
    Form7.ibDataSet2.Selectsql.Clear;
    Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet99.FieldByname('CLIENTE').AsString)+' ');
    Form7.ibDataSet2.Open;

    if (Form7.ibDataSet99.FieldByname('CLIENTE').AsString = Form7.iBDataSet2NOME.AsString) and (Form7.iBDataSet2NOME.AsString <>'') then
    begin
      if Form7.ibDataSet99.FieldByName('VTOTAL').AsFloat <> 0 then
      begin
        if Form1.bHtml1 then
        begin
          WriteLn(F,'   <tr>');
          WriteLn(F,'    <td '+{nowrap}' width=150 valign=top bgcolor=#FFFFFF align=left><font face="Verdana" size=1>'+Form7.ibDataSet2NOME.AsString +'<br></font></td>');
          WriteLn(F,'    <td '+{nowrap}' width=150 valign=top bgcolor=#FFFFFF align=left><font face="Verdana" size=1>'+Form7.ibDataSet2CONTATO.AsString +'<br></font></td>');
          WriteLn(F,'    <td '+{nowrap}' width=150 valign=top bgcolor=#FFFFFF align=left><font face="Verdana" size=1>'+Form7.ibDataSet2CIDADE.AsString +'<br></font></td>');
          WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Verdana" size=1>'+Form7.ibDataSet2ESTADO.AsString +'<br></font></td>');
          WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Verdana" size=1>'+Form7.ibDataSet2FONE.AsString +'<br></font></td>');
          WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Verdana" size=1>'+DateToStr(Form7.ibDataSet2ULTIMACO.AsDateTime)+'<br></font></td>');

          {Mauricio Parizotto 2023-05-29 Inicio}

          vPercIndividual := (( Form7.ibDataSet99.FieldByName('VTOTAL').AsFloat )/fTotal3*100);
          vPercAcumulado  := vPercAcumulado + vPercIndividual;

          if (vPercAcumulado < 70) or (vPercIndividual > 30) then
            WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=center><font face="Verdana" size=1>'+'A'+'<br></font></td>') //
          else
            if vPercAcumulado < 90 then
              WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=center><font face="Verdana" size=1>'+'B'+'<br></font></td>')
            else
                WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=center><font face="Verdana" size=1>'+'C'+'<br></font></td>');
          WriteLn(F,'    <td '+{nowrap}' width=250 valign=top bgcolor=#FFFFFF align=left bgcolor=#'+Form1.sHtmlCor+' ><font face="Verdana" size=1>' + StrTran(Form7.ibDataSet2OBS.AsString,Chr(10),'<br>')+'<br></font></td>');

          WriteLn(F,'   </tr>');
        end else
        begin
          Write(F,Copy(Form7.ibDataSet2NOME.AsString+Replicate(' ',35),1,35)+' ');
          Write(F,Copy(Form7.ibDataSet2CONTATO.AsString+Replicate(' ',35),1,20)+' ');
          Write(F,Copy(Form7.ibDataSet2CIDADE.AsString+Replicate(' ',35),1,20)+' ');
          Write(F,Copy(Form7.ibDataSet2ESTADO.AsString+Replicate(' ',2),1,2)+' ');
          Write(F,Copy(Form7.ibDataSet2FONE.AsString+Replicate(' ',20),1,20)+' ');
          Write(F,DateToStr(Form7.ibDataSet2ULTIMACO.AsDateTime)+' ');

          vPercIndividual := (( Form7.ibDataSet99.FieldByName('VTOTAL').AsFloat )/fTotal3*100);
          vPercAcumulado  := vPercAcumulado + vPercIndividual;

          //if vPercAcumulado < 70 then
          if (vPercAcumulado < 70) or (vPercIndividual > 30) then
            WriteLn(F,'A  ')
          else
            if vPercAcumulado < 90 then
              WriteLn(F,'B  ') else WriteLn(F,'C  ');

          {Mauricio Parizotto 2023-05-29 Fim}
        end;
      end;
    end;

    Form7.ibDataSet99.Next;
  end;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'   </table>');
    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br>');

    {Mauricio Parizotto 2023-05-26 Inicio}
    // Filtros ativos
    WriteLn(F,'   <table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor=#FFFFFF align=left>');
    WriteLn(F,'     <td><P><font face="Microsoft Sans Serif" size=1><b>Opera��es listadas:</b><br>');
    for I := 0 to (chkOperacoes.Items.Count -1) do
      if chkOperacoes.Checked[I] then
          Writeln(F,'     <br><font face="Microsoft Sans Serif" size=1>'+AllTrim(chkOperacoes.Items[I]));

    Writeln(F,'     <br><font face="Microsoft Sans Serif" size=1>'+'Vendas por ECF, NFC-e ou SAT');
    WriteLn(F,'');
    Writeln(F,'      </td><br>');
    WriteLn(F,'     </td>');
    WriteLn(F,'    </table>');
    {Mauricio Parizotto 2023-05-26 Fim}

    // Filtros ativos
    WriteLn(F,'<br><font size=1>'+TraduzSql('Listando '+Form7.swhere+' '+Form7.sOrderBy,True)+'</font>');
    WriteLn(F,'</center>');

  end else
  begin
    WriteLn(F,'');
    Writeln(F,'Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'');

    // Filtros ativos
    WriteLn(F,TraduzSql('Listando '+Form7.swhere+' '+Form7.sOrderBy,True)+'');
  end;

  Form7.ibDataSet99.Close;
  Form7.ibDataSet2.EnableControls;
end;

procedure TForm38.RelatorioCurvaABC_Estoque(var F: TextFile; dInicio, dFinal : TdateTime);
var
  fTotal1, fTotal4, fTotal5 : Real;
begin
  Form38.btnAvancar.Enabled := False;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');;
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>C�digo</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Descri��o</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total faturado</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>%</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>% Acu.</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>ABC</font></th>');
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    WriteLn(F,'');
    WriteLn(F,'C�d   Descri��o                           Quantidade   Lucro bruto  %            % Acu.       ABC');
    WriteLn(F,'----- ----------------------------------- ------------ ------------ ------------ ------------ ---');
  end;

  Form7.ibQuery6.Close;
  Form7.ibQuery6.SQL.Clear;
  Form7.ibQuery6.SQL.Add(SqlSelectCurvaAbcEstoque(dInicio, dFinal));
  Form7.ibQuery6.Open;

  fTotal4 := 0;
  fTotal5 := 0;

  Form7.ibQuery6.First;
  while not Form7.ibQuery6.EOF do
  begin
    if AllTrim(Form7.ibQuery6.FieldByName('CODIGO').AsString) <> '' then
    begin
      fTotal5 := fTotal5 + (Form7.ibQuery6.FieldByName('TOTAL').AsFloat);
    end;
    Form7.ibQuery6.Next;
  end;

  Form7.ibQuery6.First;

  while not Form7.ibQuery6.EOF do
  begin
    if AllTrim(Form7.ibQuery6.FieldByName('CODIGO').AsString) <> '' then
    begin
      Form7.ibDataSet4.Close;
      Form7.ibDataSet4.Selectsql.Clear;
      Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibQuery6.FieldByName('CODIGO').AsString)+' ');
      Form7.ibDataSet4.Open;

      fTotal4 := fTotal4 + ((Form7.ibQuery6.FieldByName('TOTAL').AsFloat)/fTotal5*100);

      if Form1.bHtml1 then
      begin
        WriteLn(F,'   <tr>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet4CODIGO.AsString+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet4DESCRICAO.AsString +'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibQuery6.FieldByName('TOTAL').AsFloat])+'<br></font></td>');

        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.2n',[((Form7.ibQuery6.FieldByName('TOTAL').AsFloat)/fTotal5*100)])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.2n',[fTotal4])+'<br></font></td>');

        if fTotal4 < 70 then  WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=center><font face="Microsoft Sans Serif" size=1>'+'A'+'<br></font></td>') else
         if fTotal4 < 90 then  WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=center><font face="Microsoft Sans Serif" size=1>'+'B'+'<br></font></td>') else
           WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=center><font face="Microsoft Sans Serif" size=1>'+'C'+'<br></font></td>');
        WriteLn(F,'   </tr>');
      end else
      begin
        Write(F,Copy(Form7.ibDataSet4CODIGO.AsString+Replicate(' ',5),1,5)+' ');
        Write(F,Copy(Form7.ibDataSet4DESCRICAO.AsString+REplicate(' ',35),1,35)+' ');
        Write(F,Format('%12.2n',[Form7.ibQuery6.FieldByName('TOTAL').AsFloat])+' ');
        // Sandro Silva 2022-09-19 j� acumula antes de "if Form1.bHtml1 then"   fTotal4 := fTotal4 + ((Form7.ibQuery6.FieldByName('TOTAL').AsFloat)/fTotal5*100);
        Write(F,Format('%12.2n',[fTotal4])+' ');

        if fTotal4 < 70 then  WriteLn(F,'A  ') else
         if fTotal4 < 90 then  WriteLn(F,'B  ') else WriteLn(F,'C  ');
      end;

      fTotal1 := fTotal1 + Form7.ibQuery6.FieldByName('TOTAL').AsFloat;
    end;

    Form7.ibQuery6.Next;
  end;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%12.'+Form1.ConfPreco+'n',[fTotal1])+'<br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'    </tr>');
    WriteLn(F,'   </table>');
    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br>');

    // Filtros ativos
    WriteLn(F,'</center>');
  end else
  begin
    Writeln(F,'Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+' ');

    // Filtros ativos
    WriteLn(F,TraduzSql('Listando '+Form7.swhere+' '+Form7.sOrderBy,True)+'');
  end;
end;

procedure TForm38.RelatorioRankingClientes(var F: TextFile; dInicio, dFinal : TdateTime);
var
  Y : integer;
  fTotal : Real;
begin
  Form7.IBDataSet99.Close;
  Form7.IBDataSet99.SelectSQL.Clear;
  Form7.IBDataSet99.SelectSQL.Add('select VENDAS.CLIENTE, sum(VENDAS.TOTAL)as VTOTAL from VENDAS where EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and EMITIDA=''S'' group by VENDAS.CLIENTE order by VTOTAL desc');
  Form7.IBDataSet99.Open;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');;
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Ranking</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Cliente</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Cidade</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>UF</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Telefone</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>�lt. venda</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Valor das vendas</font></th>');
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    WriteLn(F,'');
    WriteLn(F,'Ranking Cliente                             Cidade                              UF Telefone             �lt. venda Valor d vendas');
    WriteLn(F,'------- ----------------------------------- ----------------------------------- -- -------------------- ---------- --------------');
  end;
  Form7.ibDataSet99.First;

  Y      := 0;
  fTotal := 0;

  while (not Form7.ibDataSet99.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    Form7.ibDataSet2.Close;
    Form7.ibDataSet2.Selectsql.Clear;
    Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet99.FieldByname('CLIENTE').AsString)+' ');  //
    Form7.ibDataSet2.Open;

    if (Form7.ibDataSet99.FieldByname('CLIENTE').AsString = Form7.iBDataSet2NOME.AsString) and (Form7.iBDataSet2NOME.AsString <>'') then
    begin
      Y := Y + 1;

      if Form1.bHtml1 then
      begin
        WriteLn(F,'   <tr>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=center><font face="Microsoft Sans Serif" size=1>'+IntTostr(Y)+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByname('CLIENTE').AsString +'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet2.FieldByname('CIDADE').AsString +'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet2.FieldByname('ESTADO').AsString +'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet2.FieldByname('FONE').AsString +'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+DateToStr(Form7.ibDataSet2.FieldByname('ULTIMACO').AsDateTime)+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet99.FieldByname('VTOTAL').AsFloat])+'<br></font></td>');
        WriteLn(F,'   </tr>');
      end else
      begin
        Write(F,StrZero(Y,7,0)+' ');
        Write(F,Copy(Form7.ibDataSet99.FieldByname('CLIENTE').AsString+Replicate(' ',35),1,35)+' ');
        Write(F,Copy(Form7.ibDataSet2.FieldByname('CIDADE').AsString+Replicate(' ',35),1,35)+' ');
        Write(F,Copy(Form7.ibDataSet2.FieldByname('ESTADO').AsString+Replicate(' ',35),1,35)+' ');
        Write(F,Copy(Form7.ibDataSet2.FieldByname('FONE').AsString+Replicate(' ',20),1,20)+' ');
        Write(F,DateToStr(Form7.ibDataSet2.FieldByname('ULTIMACO').AsDateTime)+' ');
        Writeln(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet99.FieldByname('VTOTAL').AsFloat])+'');
      end;

      fTotal := fTotal + Form7.ibDataSet99.FieldByname('VTOTAL').AsFloat;
    end;
    Form7.ibDataSet99.Next;
  end;

  if Form1.bHtml1 then
  begin
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1></font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1></font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1></font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1></font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1></font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1></font></th>');
    WriteLn(F,'  <th '+{nowrap}'  align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[fTotal])+'</font></th>');
    WriteLn(F,' </tr>');
    WriteLn(F,'   </table>');
    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br>');

    // Filtros ativos
    WriteLn(F,'<br><font size=1>'+TraduzSql('Listando '+Form7.swhere+' '+Form7.sOrderBy,True)+'</font>');
    WriteLn(F,'</center>');
  end else
  begin
    WriteLn(F,'                                                                                                                   --------------');
    WriteLn(F,'                                                                                                                   '+Format('%14.'+Form1.ConfPreco+'n',[fTotal])+'');
    WriteLn(F,'');
    Writeln(F,'Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'');

    // Filtros ativos
    WriteLn(F,TraduzSql('Listando '+Form7.swhere+' '+Form7.sOrderBy,True)+'');
    WriteLn(F,'');
  end;

  Form7.ibDataSet99.Close;
end;

procedure TForm38.RelatorioRankingDevedores(var F: TextFile; dInicio, dFinal : TdateTime);
var
  Y : Integer;
  fTotal : Real;
begin
  if Form38.ComboBox1.Text = '�ltimos tr�s meses' then
  begin
    Form7.IBDataSet99.Close;
    Form7.IBDataSet99.SelectSQL.Clear;
    Form7.IBDataSet99.SelectSQL.Add('select NOME, FONE , CIDADE, ESTADO, (select sum(VALOR_DUPL) from RECEBER where CLIFOR.NOME=RECEBER.NOME and Coalesce(RECEBER.VALOR_RECE,0)=0'+
    'and coalesce(ATIVO,9)<>1 and RECEBER.VENCIMENTO < CURRENT_DATE and RECEBER.VENCIMENTO>=(CURRENT_DATE-90)) as VENCIDO from CLIFOR '+Form7.sWhere+' order by VENCIDO desc');
    Form7.IBDataSet99.Open;
  end;

  if Form38.ComboBox1.Text = '�ltimos doze meses' then
  begin
    Form7.IBDataSet99.Close;
    Form7.IBDataSet99.SelectSQL.Clear;
    Form7.IBDataSet99.SelectSQL.Add('select NOME, FONE , CIDADE, ESTADO, (select sum(VALOR_DUPL) from RECEBER where CLIFOR.NOME=RECEBER.NOME and Coalesce(RECEBER.VALOR_RECE,0)=0'+
    'and coalesce(ATIVO,9)<>1 and RECEBER.VENCIMENTO < CURRENT_DATE  and RECEBER.VENCIMENTO>=(CURRENT_DATE-360)) as VENCIDO from CLIFOR '+Form7.sWhere+' order by VENCIDO desc');
    Form7.IBDataSet99.Open;
  end;

  if Form38.ComboBox1.Text = 'Todos' then
  begin
    Form7.IBDataSet99.Close;
    Form7.IBDataSet99.SelectSQL.Clear;
    Form7.IBDataSet99.SelectSQL.Add('select NOME, FONE , CIDADE, ESTADO, (select sum(VALOR_DUPL) from RECEBER where CLIFOR.NOME=RECEBER.NOME and Coalesce(RECEBER.VALOR_RECE,0)=0'+
    'and coalesce(ATIVO,9)<>1 and RECEBER.VENCIMENTO < CURRENT_DATE) as VENCIDO from CLIFOR '+Form7.sWhere+' order by VENCIDO desc');
    Form7.IBDataSet99.Open;
  end;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Ranking</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Cliente</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Telefone</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Cidade</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>UF</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Valor atrasado</font></th>');
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    WriteLn(F,'');
    WriteLn(F,'Ranking Cliente                             Telefone             Cidade               UF Valor atrasado');
    WriteLn(F,'------- ----------------------------------- -------------------- -------------------- -- --------------');
  end;

  Form7.ibDataSet99.First;
  Y := 0;
  fTotal := 0;

  while (not Form7.ibDataSet99.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    Application.ProcessMessages;
    if Form7.ibDataSet99.FieldByName('VENCIDO').AsFloat <> 0 then
    begin
      Y := Y + 1;

      if Form1.bHtml1 then
      begin
        WriteLn(F,'   <tr>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=center><font face="Microsoft Sans Serif" size=1>'+IntTostr(Y)+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByname('NOME').AsString   + '<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByname('FONE').AsString   + '<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByname('CIDADE').AsString + '<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByname('ESTADO').AsString + '<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet99.FieldByName('VENCIDO').AsFloat])+'<br></font></td>');
        WriteLn(F,'   </tr>');
      end else
      begin
        Write(F,StrZero(Y,7,0)+' ');
        Write(F,Copy(Form7.ibDataSet99.FieldByname('NOME').AsString+Replicate(' ',35),1,35)+' ');
        Write(F,Copy(Form7.ibDataSet99.FieldByname('FONE').AsString+Replicate(' ',20),1,20)+' ');
        Write(F,Copy(Form7.ibDataSet99.FieldByname('CIDADE').AsString+Replicate(' ',20),1,20)+' ');
        Write(F,Copy(Form7.ibDataSet99.FieldByname('ESTADO').AsString+Replicate(' ',2),1,2)+' ');
        WriteLn(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet99.FieldByName('VENCIDO').AsFloat])+'');
      end;

      fTotal := fTotal  + Form7.ibDataSet99.FieldByName('VENCIDO').AsFloat;
    end;

    Form7.ibDataSet99.Next;
  end;

  if Form1.bHtml1 then
  begin
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1></font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1></font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1></font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1></font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1></font></th>');
    WriteLn(F,'  <th '+{nowrap}' align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[fTotal])+'</font></th>');
    WriteLn(F,' </tr>');
    WriteLn(F,'</table>');
  end else
  begin
    WriteLn(F,'                                                                                         --------------');
    WriteLn(F,'                                                                                         '+Format('%14.'+Form1.ConfPreco+'n',[fTotal]));
  end;
  
  Form7.ibDataSet99.Close;
end;

procedure TForm38.RelatorioPecasOSAberta(var F: TextFile; dInicio, dFinal : TdateTime);
var
  fTotal : Real;
begin
  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>OS</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Descri��o</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Quantidade</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Unit�rio R$</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total R$</font></th>');
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    WriteLn(F,'');
    WriteLn(F,'OS         Descri��o                           Quantidade     Unit�rio R$    Total R$');
    WriteLn(F,'---------- ----------------------------------- -------------- -------------- --------------');
  end;

  Form38.Label17.Visible := False;
  Form38.Edit1.Visible   := False;

  Form7.ibDataSet99.Close;
  Form7.ibDataSet99.SelectSQL.Clear;
  Form7.IBDataSet99.SelectSQL.Add('select * from ITENS001, OS where ITENS001.NUMEROOS=OS.NUMERO and OS.DATA<='+QuotedStr(DateToStrInvertida(dFinal))+' and OS.DATA>='+QuotedStr(DateToStrInvertida(dInicio))+' ');
  Form7.ibDataSet99.Open;
  Form7.ibDataSet99.First;

  while not Form7.ibDataSet99.Eof do
  begin
    if (AllTrim(Form7.ibDataSet99.FieldByname('NUMERONF').AsString) = '') and (AllTrim(Form7.ibDataSet99.FieldByname('DESCRICAO').AsString) <> '')  then
    begin
      if Form1.bHtml1 then
      begin
        WriteLn(F,'   <tr>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByname('NUMEROOS').AsString+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByname('DESCRICAO').AsString+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[Form7.ibDataSet99.FieldByname('QUANTIDADE').AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet99.FieldByname('UNITARIO').AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet99.FieldByname('TOTAL').AsFloat])+'<br></font></td>');
        WriteLn(F,'   </tr>');
      end else
      begin
        Write(F,Copy(Form7.ibDataSet99.FieldByname('NUMEROOS').AsString+Replicate(' ',6),1,10)+' ');
        Write(F,Copy(Form7.ibDataSet99.FieldByname('DESCRICAO').AsString+Replicate(' ',35),1,35)+' ');
        Write(F,Format('%14.'+Form1.ConfCasas+'n',[Form7.ibDataSet99.FieldByname('QUANTIDADE').AsFloat])+' ');
        Write(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet99.FieldByname('UNITARIO').AsFloat])+' ');
        Writeln(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet99.FieldByname('TOTAL').AsFloat])+' ');
      end;
      
      fTotal := fTotal + (Form7.ibDataSet99.FieldByname('TOTAL').AsFloat);
    end;

    Form7.ibDataSet99.Next;
  end;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal])+'<br></font></td>');
    WriteLn(F,'    </tr>');
    WriteLn(F,'   </table>');
    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br>');
    WriteLn(F,'</center>');
  end else
  begin
    WriteLn(F,'                                                                             --------------');
    WriteLn(F,'                                                                             '+Format('%14.'+Form1.ConfPreco+'n',[fTotal])+'');
    WriteLn(F,'');
    Writeln(F,'Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'');
  end;
end;

procedure TForm38.RelatorioRomaneioCargas(var F: TextFile; dInicio, dFinal : TdateTime);
var
  fTotal, fTotal1 : Real;
begin
  fTotal  := 0;
  fTotal1 := 0;
  
  WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center><br>');
  WriteLn(F,'<center>');

  // Itens
  Form7.IBDataSet99.Close;
  Form7.IBDataSet99.SelectSQL.Clear;
  // Sandro Silva 2023-09-26 Form7.IBDataSet99.SelectSQL.Add('select ITENS001.CODIGO, sum(QUANTIDADE) from ITENS001 ,VENDAS where VENDAS.NUMERONF=ITENS001.NUMERONF and VENDAS.TRANSPORTA='+QuotedStr(Form7.ibDataSet18NOME.AsString)+' and VENDAS.EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and VENDAS.EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' group by ITENS001.CODIGO');
  Form7.IBDataSet99.SelectSQL.Text :=
    'select ITENS001.CODIGO, sum(ITENS001.QUANTIDADE) ' +
    'from VENDAS ' +
    'join ITENS001 ON ITENS001.NUMERONF = VENDAS.NUMERONF ' +
    'where VENDAS.EMISSAO between ' + QuotedStr(DateToStrInvertida(dInicio)) + ' and ' + QuotedStr(DateToStrInvertida(dFinal)) +
    ' and VENDAS.TRANSPORTA = ' + QuotedStr(Form7.ibDataSet18NOME.AsString) +
    ' and coalesce(VENDAS.STATUS, '''') not containing ' + QuotedStr('cancelada') +
    ' group by ITENS001.CODIGO';
  Form7.IBDataSet99.Open;
  Form7.ibDataSet99.First;

  WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
  WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
  WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>C�digo</font></th>');
  WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>C�digo de barras</font></th>');
  WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Descri��o</font></th>');
  WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Quantidade</font></th>');
  WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Medida</font></th>');
  WriteLn(F,' </tr>');

  while not Form7.IBDataSet99.Eof do
  begin
    Form7.IBDataSet100.Close;
    Form7.IBDataSet100.SelectSQL.Clear;
    Form7.IBDataSet100.SelectSQL.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet99.FieldByname('CODIGO').AsString)+' ');
    Form7.IBDataSet100.Open;
    Form7.ibDataSet100.First;

    WriteLn(F,'   <tr>');
    WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet100.FieldByname('CODIGO').AsString+'<br></font></td>');
    WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet100.FieldByname('REFERENCIA').AsString+'<br></font></td>');
    WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet100.FieldByname('DESCRICAO').AsString+'<br></font></td>');
    WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[Form7.ibDataSet99.FieldByname('SUM').AsFloat])+'<br></font></td>');
    WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet100.FieldByname('MEDIDA').AsString+'<br></font></td>');
    WriteLn(F,'   </tr>');

    Form7.IBDataSet99.Next;
  end;

  WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
  WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
  WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
  WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
  WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
  WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
  WriteLn(F,'    </tr>');
  WriteLn(F,'   </table>');

  WriteLn(F,'   </table>');
  Writeln(F,'   <font face="Microsoft Sans Serif" size=1><br>Per�odo de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br><br>');
  Writeln(F,'   <font face="Microsoft Sans Serif" size=1><br><b>Transportadora<br></b>');
  Writeln(F,'   <font face="Microsoft Sans Serif" size=1><br>Nome: '+ Form7.ibDataSet18NOME.AsString);
  Writeln(F,'   <font face="Microsoft Sans Serif" size=1><br>Placa: '+ Form7.ibDataSet18PLACA.AsString+'</center>');
end;

procedure TForm38.RelatorioRomaneioEntregas(var F: TextFile; dInicio, dFinal : TdateTime);
var
  fTotal, fTotal1 : Real;
begin
  fTotal  := 0;
  fTotal1 := 0;
  
  WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center><br>');
  WriteLn(F,'<center>');
  WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');;
  WriteLn(F,' <tr bgcolor=#'+Form1.sHtmlCor+'   align=left>');
  WriteLn(F,'  <th '+{nowrap}' ><font face="Microsoft Sans Serif" size=1>Cliente/Contato/Telefone</font></th>');
  WriteLn(F,'  <th '+{nowrap}' ><font face="Microsoft Sans Serif" size=1>Endere�o</font></th>');
  WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Entregar</font></th>');
  WriteLn(F,' </tr>');

  // Clientes
  Form7.IBDataSet99.Close;
  Form7.IBDataSet99.SelectSQL.Clear;
  Form7.IBDataSet99.SelectSQL.Add('select VENDAS.CLIENTE, sum(VENDAS.TOTAL)as VTOTAL from VENDAS where VENDAS.TRANSPORTA='+QuotedStr(Form7.ibDataSet18NOME.AsString)+' and VENDAS.EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and VENDAS.EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' group by VENDAS.CLIENTE order by VTOTAL');
  Form7.IBDataSet99.Open;
  Form7.ibDataSet99.First;

  Form7.IBDataset2.Close;
  Form7.IBDataset2.SelectSQL.Clear;
  Form7.IBDataset2.SelectSQL.Add('select * from CLIFOR order by CEP');
  Form7.IBDataset2.Open;
  Form7.IBDataset2.First;

  while (not Form7.ibDataSet2.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    if Form7.IBDataSet99.Locate('CLIENTE',Form7.ibDataSet2NOME.AsString,[]) then
    begin
      if Form7.ibDataSet99.FieldByName('VTOTAL').AsFloat <> 0 then
      begin
        Form7.IBDataSet15.Close;
        Form7.IBDataSet15.SelectSQL.Clear;
        Form7.IBDataSet15.SelectSQL.Add('select * from VENDAS where CLIENTE='+QuotedStr(Form7.ibDataSet2NOME.AsString)+' and EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and TRANSPORTA='+QuotedStr(Form7.ibDataSet18NOME.AsString)+' and EMITIDA=''S'' ');
        Form7.IBDataSet15.Open;
        Form7.IBDataSet15.First;
        
        WriteLn(F,'   <tr>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.ibDataSet2NOME.AsString +'<br>'
                                                                                                      + Form7.ibDataSet2CONTATO.AsString + '<br>'
                                                                                                                + Form7.ibDataSet2FONE.AsString
                                                                                                                +'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + Form7.ibDataSet2CEP.AsString + '<br>'
                                                                                                                + Form7.ibDataSet2CIDADE.AsString + ' - ' + Form7.ibDataSet2ESTADO.AsString + '<br>'
                                                                                                                + Form7.ibDataSet2ENDERE.AsString + '<br>'
                                                                                                                + Form7.ibDataSet2COMPLE.AsString
                                                                                                                   + '<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>');

        WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');;
        WriteLn(F,' <tr bgcolor=#E6E8FA align=left>');
        WriteLn(F,'  <th width=60><font face="Microsoft Sans Serif" size=1>NF</th>');
        WriteLn(F,'  <th width=60><font face="Microsoft Sans Serif" size=1>Qtd</th>');
        WriteLn(F,'  <th width=300><font face="Microsoft Sans Serif" size=1>Descri��o</th>');
        WriteLn(F,'  <th width=30><font face="Microsoft Sans Serif" size=1>C�digo</th>');
        WriteLn(F,' </tr>');

        while not (Form7.ibDataSet15.EOF) and (Form38.Caption <> 'Cancelar') do
        begin
          Application.ProcessMessages;

          Form7.ibDataSet16.Close;
          Form7.ibDataSet16.SelectSQL.Clear;
          Form7.ibDataSet16.SelectSQL.Add('select * from ITENS001 where NUMERONF='+QuotedStr(Form7.ibDataSet15NUMERONF.AsString)+'  and coalesce(QUANTIDADE,0) = coalesce(SINCRONIA,0)');
          Form7.ibDataSet16.Open;
          Form7.ibDataSet16.First;

          while not (Form7.ibDataSet16.EOF) and (Form38.Caption <> 'Cancelar') do
          begin
             Application.ProcessMessages;
            if Form7.ibDataSet16QUANTIDADE.AsFloat <> 0 then
            begin
              WriteLn(F,' <tr>');
              WriteLn(F,'  <td valign=top bgcolor=#FFFFFF align=Left><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet16NUMERONF.AsString,1,9)+'/'+Copy(Form7.ibDataSet16NUMERONF.AsString,10,3)+'</td>');
              WriteLn(F,'  <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%10.'+Form1.ConfCasas+'n',[Form7.ibDataSet16QUANTIDADE.AsFloat])+'</td>');
              WriteLn(F,'  <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet16DESCRICAO.AsString+'</td>');
              WriteLn(F,'  <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet16CODIGO.AsString+'</td>');
              WriteLn(F,' </tr>');
            end else
            begin
              WriteLn(F,' <tr>');
              WriteLn(F,'  <td valign=top bgcolor=#FFFFFF align=Left><font face="Microsoft Sans Serif" size=1></td>');
              WriteLn(F,'  <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1></td>');
              WriteLn(F,'  <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet16DESCRICAO.AsString+'</td>');
              WriteLn(F,'  <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1></td>');
              WriteLn(F,' </tr>');
            end;
            Form7.ibDataSet16.Next;
          end;
          Form7.ibDataSet15.Next;
        end;

        WriteLn(F,'  </td>');
        WriteLn(F,' </tr>');
        WriteLn(F,'</table>');
        WriteLn(F,'    </font></td>');

        WriteLn(F,'   </tr>');
      end;
    end;

    Form7.ibDataSet2.Next;
  end;

  WriteLn(F,'   </table>');
  Writeln(F,'   <font face="Microsoft Sans Serif" size=1><br>Per�odo de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br><br>');
  Writeln(F,'   <font face="Microsoft Sans Serif" size=1><br><b>Transportadora<br></b>');
  Writeln(F,'   <font face="Microsoft Sans Serif" size=1><br>Nome: '+ Form7.ibDataSet18NOME.AsString);
  Writeln(F,'   <font face="Microsoft Sans Serif" size=1><br>Placa: '+ Form7.ibDataSet18PLACA.AsString+'</center>');
end;


procedure TForm38.RelatorioProdutosMonofasicosCupom(var F: TextFile; dInicio, dFinal : TdateTime);
var
  fTotal, fTotal1, fTotal2 : Real;
  Rateio: TRateioBalcao;
  sCFOP: String;
  bAchouItem: Boolean;
  iItem: Integer;
  aCFOP: array of TCFOP;
  aCSTCSOSN: array of TCSTCSOSN;
  sCSTCSOSN : string;
  dTotalCFOP: Double;
  dTotalCSTCSOSN: Double;
begin
  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Data</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Caixa</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Cupom</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>C�digo</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Descri��o</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total R$</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CST</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>% PIS</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>R$ PIS</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>% COFINS</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>R$ COFINS</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CFOP</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>NCM</font></th>');
    {Sandro Silva 2022-09-30 inicio}
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CST ICMS</font></th>')
    else
      WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CSOSN</font></th>');
    {Sandro Silva 2022-09-30 fim}
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    WriteLn(F,'');
    {Sandro Silva 2022-09-30 inicio
    WriteLn(F,'Data       Cupom  C�digo Descri��o                           R$ Total       CST    % PIS    R$ PIS         % COFINS R$ COFINS      CFOP NCM          ');
    WriteLn(F,'---------- ------ ------ ----------------------------------- -------------- ------ -------- -------------- -------- -------------- ---- -------------');
    }
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
    begin
      WriteLn(F,'Data       Caixa Cupom  C�digo Descri��o                           R$ Total       CST    % PIS    R$ PIS         % COFINS R$ COFINS      CFOP NCM       CST ICMS ');
      WriteLn(F,'---------- ----- ------ ------ ----------------------------------- -------------- ------ -------- -------------- -------- -------------- ---- --------- --------');
    end
    else
    begin
      WriteLn(F,'Data       Caixa Cupom  C�digo Descri��o                           R$ Total       CST    % PIS    R$ PIS         % COFINS R$ COFINS      CFOP NCM       CSOSN ');
      WriteLn(F,'---------- ----- ------ ------ ----------------------------------- -------------- ------ -------- -------------- -------- -------------- ---- --------- -----');
    end;
    {Sandro Silva 2022-09-30 fim}
  end;

  fTotal  := 0;
  fTotal1 := 0;
  fTotal2 := 0;

  Form7.ibDataSet27.Close;
  Form7.ibDataSet27.SelectSQL.Clear;
  Form7.ibDataSet27.SelectSQL.Add('select');
  Form7.ibDataSet27.SelectSQL.Add('*');
  Form7.ibDataSet27.SelectSQL.Add('from ALTERACA');
  Form7.ibDataSet27.SelectSQL.Add('where (DATA<='+QuotedStr(DateToStrInvertida(dFinal))+') and (DATA>='+QuotedStr(DateToStrInvertida(dInicio))+')');
  Form7.ibDataSet27.SelectSQL.Add('and ((TIPO='+QuotedStr('BALCAO')+') or (TIPO='+QuotedStr('VENDA')+')) and (CST_PIS_COFINS=''04'')');
  {Dailon Parisotto (f-142) 2024-02-19 Inicio}
  // Valida��o para desconsiderar gerencial
  Form7.ibDataSet27.SelectSQL.Add('AND (COALESCE((SELECT COALESCE(MODELO,'''') FROM NFCE WHERE (NFCE.CAIXA=ALTERACA.CAIXA) AND (NFCE.NUMERONF=ALTERACA.PEDIDO)),'''') <> ''99'')');
  {Dailon Parisotto (f-142) 2024-02-19 Fim}
  Form7.ibDataSet27.SelectSQL.Add('order by DATA, PEDIDO');
  Form7.ibDataSet27.Open;
  Form7.ibDataSet27.First;

  Rateio := TRateioBalcao.Create;
  Rateio.IBTransaction := Form7.ibDataSet27.Transaction;
  while (not Form7.ibDataSet27.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    Form7.ibDataSet4.Close;
    Form7.ibDataSet4.Selectsql.Clear;
    Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet27.FieldByName('CODIGO').AsString)+' ');
    Form7.ibDataSet4.Open;

    Application.ProcessMessages;

    Rateio.CalcularRateio(Form7.ibDataSet27.FieldByName('CAIXA').AsString, Form7.ibDataSet27.FieldByName('PEDIDO').AsString, Form7.ibDataSet27.FieldByName('ITEM').AsString);

    sCFOP := Trim(Form7.ibDataSet27.FieldByName('CFOP').AsString);
    if sCFOP = '' then
      sCFOP := ' ';

    bAchouItem := False;
    for iItem := 0 to Length(aCFOP) - 1 do
    begin
      if aCFOP[iItem].CFOP = sCFOP then
      begin
        bAchouItem := True;
        Break;
      end;
    end;

    if bAchouItem = False then
    begin
      SetLength(aCFOP, Length(aCFOP) + 1);
      iItem := High(aCFOP);
      aCFOP[High(aCFOP)] := TCFOP.Create; // Sandro Silva 2019-06-13
      aCFOP[High(aCFOP)].CFOP := sCFOP;
    end;

    // Sandro Silva 2022-12-15 aCFOP[iItem].Valor     := aCFOP[iItem].Valor + StrToFloat(Format('%11.2n', [Form7.ibDataSet27.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem]));
    aCFOP[iItem].Valor     := aCFOP[iItem].Valor + StrToFloatFormat('%11.2n', Form7.ibDataSet27.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem);
    aCFOP[iItem].Acrescimo := aCFOP[iItem].Acrescimo + Rateio.RateioAcrescimoItem;
    aCFOP[iItem].Desconto  := aCFOP[iItem].Desconto + Rateio.DescontoItem + Rateio.RateioDescontoItem;
    {Sandro Silva 2022-09-29 fim}

    {Sandro Silva 2022-09-30 inicio}
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      sCSTCSOSN := Trim(Form7.ibDataSet27.FieldByName('CST_ICMS').AsString)
    else
      sCSTCSOSN := Trim(Form7.ibDataSet27.FieldByName('CSOSN').AsString);

    if sCSTCSOSN = '' then
      sCSTCSOSN := ' ';

    bAchouItem := False;
    for iItem := 0 to Length(aCSTCSOSN) - 1 do
    begin
      if aCSTCSOSN[iItem].CSTCSOSN = sCSTCSOSN then
      begin
        bAchouItem := True;
        Break;
      end;
    end;

    if bAchouItem = False then
    begin
      SetLength(aCSTCSOSN, Length(aCSTCSOSN) + 1);
      iItem := High(aCSTCSOSN);
      aCSTCSOSN[High(aCSTCSOSN)] := TCSTCSOSN.Create; // Sandro Silva 2019-06-13
      aCSTCSOSN[High(aCSTCSOSN)].CSTCSOSN := sCSTCSOSN;
    end;

    // Sandro Silva 2022-12-15 aCSTCSOSN[iItem].Valor     := aCSTCSOSN[iItem].Valor + StrToFloat(Format('%11.2n',[Form7.ibDataSet27.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem]));
    aCSTCSOSN[iItem].Valor     := aCSTCSOSN[iItem].Valor + StrToFloatFormat('%11.2n', Form7.ibDataSet27.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem);
    aCSTCSOSN[iItem].Acrescimo := aCSTCSOSN[iItem].Acrescimo + Rateio.RateioAcrescimoItem;
    aCSTCSOSN[iItem].Desconto  := aCSTCSOSN[iItem].Desconto + Rateio.DescontoItem + Rateio.RateioDescontoItem;
    {Sandro Silva 2022-09-30 fim}

    if Form1.bHtml1 then
    begin
      WriteLn(F,'   <tr>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet27DATA.AsDateTime)+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet27CAIXA.AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet27PEDIDO.AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet27CODIGO.AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+StrTran(StrTran(Form7.ibDataSet27DESCRICAO.AsString,'<',''),'>','')+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.2n',[Form7.ibDataSet27.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet27CST_PIS_COFINS.AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%8.4n',[Form7.ibDataSet27ALIQ_PIS.AsFloat])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.2n',[Form7.ibDataSet27ALIQ_PIS.AsFloat / 100 * (Form7.ibDataSet27.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem) ])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%8.4n',[Form7.ibDataSet27ALIQ_COFINS.AsFloat])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.2n',[Form7.ibDataSet27ALIQ_COFINS.AsFloat / 100 * (Form7.ibDataSet27.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem) ])+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet27CFOP.AsString+'<br></font></td>');
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet4CF.AsString+'<br></font></td>');
      {Sandro Silva 2022-09-30 inicio}
      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + sCSTCSOSN + '<br></font></td>');
      {Sandro Silva 2022-09-30 fim}
      WriteLn(F,'   </tr>');
    end else
    begin
      Write(F,DateTimeToStr(Form7.ibDataSet27DATA.AsDateTime)+' ');
      Write(F,Copy(Form7.ibDataSet27CAIXA.AsString+Replicate(' ', 5), 1, 5) + ' ');
      Write(F,Copy(Form7.ibDataSet27PEDIDO.AsString+Replicate(' ',6),1,6)+' ');
      Write(F,Copy(Form7.ibDataSet27CODIGO.AsString+Replicate(' ',6),1,6)+' ');
      Write(F,Copy(Form7.ibDataSet27DESCRICAO.AsString+Replicate(' ',35),1,35)+' ');
      Write(F,Format('%14.2n',[(Form7.ibDataSet27.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem)]) + ' ');
      Write(F,Copy(Form7.ibDataSet27CST_PIS_COFINS.AsString+Replicate(' ',6),1,6)+' ');
      Write(F,Format('%8.4n',[Form7.ibDataSet27ALIQ_PIS.AsFloat])+' ');
      Write(F,Format('%14.2n',[Form7.ibDataSet27ALIQ_PIS.AsFloat / 100 * (Form7.ibDataSet27.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem)]) + ' ');
      Write(F,Format('%8.4n',[Form7.ibDataSet27ALIQ_COFINS.AsFloat])+' ');
      Write(F,Format('%14.2n',[Form7.ibDataSet27ALIQ_COFINS.AsFloat / 100 * (Form7.ibDataSet27.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem)]) + ' ');
      Write(F,Copy(Form7.ibDataSet27CFOP.AsString+Replicate(' ',4),1,4)+' ');
      Write(F,Copy(Form7.ibDataSet4CF.AsString+Replicate(' ', 9), 1, 9)+' ');
      if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
        WriteLn(F, Copy(sCSTCSOSN + Replicate(' ', 9), 1, 9) + ' ')
      else
        WriteLn(F, Copy(sCSTCSOSN + Replicate(' ', 6), 1, 6) + ' ');
      {Sandro Silva 2022-09-30 fim}
    end;

    fTotal  := fTotal  + StrToFloatFormat('%14.2n', (Form7.ibDataSet27.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem));
    fTotal1 := fTotal1 + StrToFloatFormat('%14.2n', Form7.ibDataSet27ALIQ_PIS.AsFloat / 100 * (Form7.ibDataSet27.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem));
    fTotal2 := fTotal2 + StrToFloatFormat('%14.2n', Form7.ibDataSet27ALIQ_COFINS.AsFloat / 100 * (Form7.ibDataSet27.FieldByName('TOTAL').AsFloat + Rateio.DescontoItem + Rateio.RateioDescontoItem + Rateio.RateioAcrescimoItem));

    Form7.ibDataSet27.Next;
  end;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal])+'<br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal1])+'<br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[fTotal2])+'<br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    {Sandro Silva 2022-09-30 inicio}
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    {Sandro Silva 2022-09-30 fim}
    WriteLn(F,'    </tr>');
    WriteLn(F,'   </table>');

    {Sandro Silva 2022-09-29 inicio}
    WriteLn(F,'<br>');
    WriteLn(F,'<br>');
    WriteLn(F,'<br><font size=4 color=#000000><b>Acumulado por CFOP</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CFOP</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total</font></th>');
    WriteLn(F,'    </tr>');

    dTotalCFOP := 0.00;
    for iItem := 0 to Length(aCFOP) - 1 do
    begin
      dTotalCFOP := dTotalCFOP + aCFOP[iItem].Valor;
      WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCFOP[iItem].CFOP + '</font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n',[aCFOP[iItem].Valor])+'</font></td>');
      WriteLn(F,'    </tr>');
    end;
    WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n',[dTotalCFOP])+'<br></font></td>');
    WriteLn(F,'    </tr>');
    WriteLn(F,'   </table>');
    {Sandro Silva 2022-09-29 fim}

    {Sandro Silva 2022-09-30 inicio}
    WriteLn(F,'<br>');
    WriteLn(F,'<br>');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      WriteLn(F,'<br><font size=4 color=#000000><b>Acumulado por CST ICMS</b></font><br></center><br>')
    else
      WriteLn(F,'<br><font size=4 color=#000000><b>Acumulado por CSOSN</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CST ICMS</font></th>')
    else
      WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>CSOSN</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total</font></th>');
    WriteLn(F,'    </tr>');

    dTotalCSTCSOSN := 0.00;
    for iItem := 0 to Length(aCSTCSOSN) - 1 do
    begin
      dTotalCSTCSOSN := dTotalCSTCSOSN + aCSTCSOSN[iItem].Valor;
      WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>' + aCSTCSOSN[iItem].CSTCSOSN + '</font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>' + Format('%11.2n',[aCSTCSOSN[iItem].Valor])+'</font></td>');
      WriteLn(F,'    </tr>');
    end;
    WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.2n', [dTotalCSTCSOSN])+'<br></font></td>');
    WriteLn(F,'    </tr>');
    WriteLn(F,'   </table>');
    {Sandro Silva 2022-09-30 fim}

    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br>');
    WriteLn(F,'</center>');
  end else
  begin
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
      WriteLn(F,'---------- ----- ------ ------ ----------------------------------- -------------- ------ -------- -------------- -------- -------------- ---- --------- ---------')
    else
      WriteLn(F,'---------- ----- ------ ------ ----------------------------------- -------------- ------ -------- -------------- -------- -------------- ---- --------- ------');
    WriteLn(F,'                                                                   '+Format('%14.2n',[fTotal])+'                 '+Format('%14.2n',[fTotal1])+'          '+Format('%14.2n',[fTotal2])+'');
    WriteLn(F,'');

    {Sandro Silva 2022-10-14 inicio}
    WriteLn(F, '');
    WriteLn(F, '');
    WriteLn(F, 'Acumulado por CFOP');
    WriteLn(F, '');
    WriteLn(F, 'CFOP  Total          ');
    WriteLn(F, '----- -------------- ');
    dTotalCFOP             := 0.00;
    for iItem := 0 to Length(aCFOP) - 1 do
    begin
      dTotalCFOP             := dTotalCFOP + aCFOP[iItem].Valor;
      Write(F, Copy(aCFOP[iItem].CFOP + Replicate(' ', 5), 1, 5) + ' ');
      WriteLn(F, Format('%14.2n', [aCFOP[iItem].Valor]) + ' ');
    end;
    WriteLn(F, '      -------------- ');
    WriteLn(F, '      ' + Format('%14.2n',[dTotalCFOP]) + ' ');
    WriteLn(F, '');
    WriteLn(F, '');
    if Form7.ibDataSet13CRT.AsString = REGIME_NORMAL then
    begin
      WriteLn(F, 'Acumulado por CST ICMS');
      WriteLn(F, '');
      WriteLn(F, 'CST ICMS Total          ');
    end else
    begin
      WriteLn(F, 'Acumulado por CSOSN');
      WriteLn(F, '');
      WriteLn(F, 'CSOSN    Total          ');
    end;
    WriteLn(F, '-------- -------------- ');

    dTotalCSTCSOSN := 0.00;
    for iItem := 0 to Length(aCSTCSOSN) - 1 do
    begin
      dTotalCSTCSOSN             := dTotalCSTCSOSN + aCSTCSOSN[iItem].Valor;
      Write(F, Copy(aCSTCSOSN[iItem].CSTCSOSN + Replicate(' ', 8), 1, 8) + ' ');
      WriteLn(F, Format('%14.2n', [aCSTCSOSN[iItem].Valor]) + ' ');
    end;

    WriteLn(F, '         -------------- ');
    WriteLn(F, '         ' + Format('%14.2n', [dTotalCSTCSOSN]) + '');
    WriteLn(F,'');
    {Sandro Silva 2022-10-14 fim}
    Writeln(F,'Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'');
  end;

  {Sandro Silva 2022-09-30 inicio}
  for iItem := 0 to Length(aCSTCSOSN) - 1 do
  begin
    FreeAndNil(aCSTCSOSN[iItem]);
  end;
  aCSTCSOSN := nil;
  {Sandro Silva 2022-09-30 fim}

  {Sandro Silva 2022-09-29 inicio}
  for iItem := 0 to Length(aCFOP) - 1 do
  begin
    FreeAndNil(aCFOP[iItem]);
  end;
  aCFOP := nil;
  FreeAndNil(Rateio);
  {Sandro Silva 2022-09-29 fim}
end;

procedure TForm38.RelatorioVendasCupom(var F: TextFile; dInicio, dFinal : TdateTime);
var
  fTotal : Real;
begin
  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center><br>');
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+'   align=left>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Cupom</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Data</font></th>');
    if cbListarCodigos.Checked then
      WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>C�digo</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Descri��o do item</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Quantidade</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Unit�rio R$</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total R$</font></th>');
    WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Caixa</font></th>');
    WriteLn(F,' </tr>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    WriteLn(F,'');
    if cbListarCodigos.Checked then
    begin
      WriteLn(F,'Cupom  Data       C�digo  Descri��o do item                   Quantidade     Unit�rio R$    Total R$       Caixa');
      WriteLn(F,'------ ---------- ------- ----------------------------------- -------------- -------------- -------------- -----');
    end else
    begin
      WriteLn(F,'Cupom  Data       Descri��o do item                   Quantidade     Unit�rio R$    Total R$       Caixa');
      WriteLn(F,'------ ---------- ----------------------------------- -------------- -------------- -------------- -----');
    end;
  end;

  fTotal := 0;

  Form7.ibDataSet27.Close;
  Form7.ibDataSet27.SelectSQL.Clear;
  Form7.ibDataSet27.SelectSQL.Add(' Select ALTERACA.*'+
                                  ' From ALTERACA'+
                                  '   left join NFCE on (ALTERACA.PEDIDO = NFCE.NUMERONF) and (ALTERACA.CAIXA = NFCE.CAIXA)'+
                                  ' Where (ALTERACA.DATA<='+QuotedStr(DateToStrInvertida(dFinal))+')'+
                                  '   and (ALTERACA.DATA>='+QuotedStr(DateToStrInvertida(dInicio))+')'+
                                  '   and ((ALTERACA.TIPO='+QuotedStr('BALCAO')+') or (ALTERACA.TIPO='+QuotedStr('VENDA')+'))'+
  //Form7.ibDataSet27.SelectSQL.Add('and ((coalesce(NFCE.REGISTRO,'''') = '''') or (NFCE.STATUS containing ''Autorizad'') or (NFCE.STATUS containing ''Emitido com sucesso'') or (NFCE.STATUS containing ' + QuotedStr(_cNFCE_EMITIDA_EM_CONTINGENCIA) + ') or (NFCE.STATUS containing ' + QuotedStr(_cVENDA_GERENCIAL_FINALIZADA) + ') or (NFCE.STATUS containing ' + QuotedStr(_cVENDA_MEI_ANTIGA_FINALIZADA) + '))'); Mauricio Parizotto 2024-12-17
                                  SqlFiltroNFCEAutorizado('NFCE')+
                                  ' Order by ALTERACA.DATA, ALTERACA.PEDIDO');
  Form7.ibDataSet27.Open;
  Form7.ibDataSet27.First;

  while (not Form7.ibDataSet27.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    Application.ProcessMessages;

    if not ((Form7.ibDataSet27.fieldByname('TIPO').AsString='VENDA') and (Form7.ibDataSet27.fieldByname('VALORICM').AsFloat > 0)) then
    begin
      if (AllTrim(Form38.Edit1.Text) = '') or (Form38.Edit1.Text = Form7.ibDataSet27CAIXA.AsString) then
      begin
        if Form1.bHtml1 then
        begin
          WriteLn(F,'   <tr>');
          WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet27PEDIDO.AsString+'<br></font></td>');
          WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet27DATA.AsDateTime)+'<br></font></td>');
          if cbListarCodigos.Checked then
            WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+StrTran(StrTran(Form7.ibDataSet27CODIGO.AsString,'<',''),'>','')+'<br></font></td>');
          WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+StrTran(StrTran(Form7.ibDataSet27DESCRICAO.AsString,'<',''),'>','')+'<br></font></td>');
          WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[Form7.ibDataSet27QUANTIDADE.AsFloat])+'<br></font></td>');
          WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet27UNITARIO.AsFloat])+'<br></font></td>');
          WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet27QUANTIDADE.AsFloat * Form7.ibDataSet27UNITARIO.AsFloat])+'<br></font></td>');
          WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet27CAIXA.AsString+'<br></font></td>');
          WriteLn(F,'   </tr>');
        end else
        begin
          Write(F,Copy(Form7.ibDataSet27PEDIDO.AsString+Replicate(' ',6),1,6)+' ');
          Write(F,DateTimeToStr(Form7.ibDataSet27DATA.AsDateTime)+' ');
          if cbListarCodigos.Checked then
            Write(F,Copy(Form7.ibDataSet27CODIGO.AsString+Replicate(' ',7),1,7)+' ');
          Write(F,Copy(Form7.ibDataSet27DESCRICAO.AsString+Replicate(' ',35),1,35)+' ');
          Write(F,Format('%14.'+Form1.ConfCasas+'n',[Form7.ibDataSet27QUANTIDADE.AsFloat])+' ');
          Write(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet27UNITARIO.AsFloat])+' ');
          Write(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet27QUANTIDADE.AsFloat * Form7.ibDataSet27UNITARIO.AsFloat])+' ');
          Writeln(F,Copy(Form7.ibDataSet27CAIXA.AsString,1,3)+'   ');
        end;

        fTotal := fTotal + (Form7.ibDataSet27QUANTIDADE.AsFloat * Form7.ibDataSet27UNITARIO.AsFloat);
      end;
    end;

    Form7.ibDataSet27.Next;
  end;
  
  if Form1.bHtml1 then
  begin
    WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    if cbListarCodigos.Checked then
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal])+'<br></font></td>');
    WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'    </tr>');
    WriteLn(F,'   </table>');
    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br>');
    WriteLn(F,'</center>');
  end else
  begin
    if cbListarCodigos.Checked then
    begin
      WriteLn(F,'                                                                                            --------------');
      WriteLn(F,'                                                                                            '+Format('%14.'+Form1.ConfPreco+'n',[fTotal])+'');
    end else
    begin
      WriteLn(F,'                                                                                    --------------');
      WriteLn(F,'                                                                                    '+Format('%14.'+Form1.ConfPreco+'n',[fTotal])+'');
    end;
    WriteLn(F,EmptyStr);
    Writeln(F,'Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'');
  end;
end;

procedure TForm38.RelatorioOrcamentosPendentes(var F: TextFile; dInicio, dFinal : TdateTime);
var
  fTotal, fTotal1, fTotal2 : Real;
  sClifor : string;
begin
  fTotal1 := 0;
  fTotal2 := 0;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><font size=4 color=#000000><b>'+Form7.sModulo+'</b></font><br></center>');
  end else
  begin
    WriteLn(F,Form7.sModulo);
    WriteLn(F,'');
  end;

  Form7.ibDataSet37.Close;
  Form7.ibDataSet37.SelectSQL.Clear;
  Form7.ibDataSet37.SelectSQL.Add('select * from ORCAMENT where DATA<='+QuotedStr(DateToStrInvertida(dFinal))+' and DATA>='+QuotedStr(DateToStrInvertida(dInicio))+' and Coalesce(NUMERONF,'+QuotedStr('')+')='+QuotedStr('')+' and Coalesce(PEDIDO,'+QuotedStr('XXXXXX')+')<>'+QuotedStr('XXXXXX')+' order by PEDIDO');
  Form7.ibDataSet37.Open;
  Form7.ibDataSet37.First;

  fTotal  := 0;
  sClifor := 'XXXXXX';

  while (not Form7.ibDataSet37.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    Application.ProcessMessages;

    if (Form7.ibDataSet37PEDIDO.AsString <> sClifor) then
    begin
      if fTotal <> 0 then
      begin
        if Form1.bHtml1 then
        begin
          WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
          WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
          WriteLn(F,'     <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal])+'<br></font></td>');
          WriteLn(F,'    </tr>');
        end else
        begin
          WriteLn(F,'                                                                 --------------');
          WriteLn(F,'                                                                  '+ Format('%14.'+Form1.ConfPreco+'n',[fTotal])+'');
          WriteLn(F,' ');
        end;
        fTotal := 0;
      end;

      if Form1.bHtml1 then
      begin
        WriteLn(F,'   </table>');
        WriteLn(F,'  </td>');
        WriteLn(F,' </tr>');
        WriteLn(F,'</table>');
        WriteLn(F,'<center>');
        WriteLn(F,'<table border=0>');
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td  align="Left" width="550">');
        Writeln(F,'   <br><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet37CLIFOR.AsString);   // Linha de talhe
        Writeln(F,'   <br><font face="Microsoft Sans Serif" size=1>OR�AMENTO '+Form7.ibDataSet37PEDIDO.AsString+' '+DateToStr(Form7.ibDataSet37DATA.AsDateTime)+' '+Form7.ibDataSet37VENDEDOR.AsString);   // Linha de talhe
        WriteLn(F,'  </td>');
        WriteLn(F,' </tr>');
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td>');
        WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
        WriteLn(F,'    <tr  bgcolor=#'+Form1.sHtmlCor+'  align=left>');
        WriteLn(F,'     <th width="300"><font face="Microsoft Sans Serif" size=1>Descri��o do item</font></th>');
        WriteLn(F,'     <th width="80"><font face="Microsoft Sans Serif" size=1>Quantidade</font></th>');
        WriteLn(F,'     <th width="80"><font face="Microsoft Sans Serif" size=1>Unit�rio R$</font></th>');
        WriteLn(F,'     <th width="80"><font face="Microsoft Sans Serif" size=1>Total R$</font></th>');
        WriteLn(F,'    </tr>');
      end else
      begin
        WriteLn(F,'');
        Writeln(F,Form7.ibDataSet37CLIFOR.AsString);   // Linha de talhe
        Writeln(F,'OR�AMENTO '+Form7.ibDataSet37PEDIDO.AsString+' '+DateToStr(Form7.ibDataSet37DATA.AsDateTime)+' '+Form7.ibDataSet37VENDEDOR.AsString);   // Linha de talhe
        WriteLn(F,'');
        WriteLn(F,'Descri��o do item                   Quantidade    Unit�rio R$    Total R$');
        WriteLn(F,'----------------------------------- ------------- -------------- --------------');
      end;
      sClifor := Form7.ibDataSet37PEDIDO.AsString;
      fTotal2 := fTotal2 + 1;
    end;

    if Form1.bHtml1 then
    begin
      WriteLn(F,'     <tr>');
      WriteLn(F,'      <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet37DESCRICAO.AsString+'<br></font></td>');

      if Alltrim(Form7.IbDataSet37DESCRICAO.AsString) = 'Desconto' then
      begin
        WriteLn(F,'      <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><br></font></td>');
        WriteLn(F,'      <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1></font></td>');
        WriteLn(F,'      <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet37TOTAL.AsFloat*-1])+'<br></font></td>');
      end else
      begin
        WriteLn(F,'      <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[Form7.ibDataSet37QUANTIDADE.AsFloat])+'<br></font></td>');
        WriteLn(F,'      <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet37UNITARIO.AsFloat])+'<br></font></td>');
        WriteLn(F,'      <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet37QUANTIDADE.AsFloat * Form7.ibDataSet37UNITARIO.AsFloat])+'<br></font></td>');
      end;

      WriteLn(F,'     </tr>');
    end else
    begin
      if Alltrim(Form7.IbDataSet37DESCRICAO.AsString) = 'Desconto' then
      begin
        Write(F,Copy(Form7.ibDataSet37DESCRICAO.AsString+REplicate(' ',35),1,35)+'');
        Write(F,'               ');
        Write(F,'               ');
        WriteLn(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet37TOTAL.AsFloat*-1])+' ');
      end else
      begin
        Write(F,Copy(Form7.ibDataSet37DESCRICAO.AsString+REplicate(' ',35),1,35)+'');
        Write(F,Format('%14.'+Form1.ConfCasas+'n',[Form7.ibDataSet37QUANTIDADE.AsFloat])+' ');
        Write(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet37UNITARIO.AsFloat])+' ');
        WriteLn(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet37QUANTIDADE.AsFloat * Form7.ibDataSet37UNITARIO.AsFloat])+' ');
      end;
    end;

    if Alltrim(Form7.IbDataSet37DESCRICAO.AsString) = 'Desconto' then
    begin
      fTotal  := fTotal + (Form7.ibDataSet37TOTAL.AsFloat*-1);
      fTotal1 := ftotal1 + (Form7.ibDataSet37TOTAL.AsFloat*-1);

    end else
    begin
      fTotal := fTotal + (Form7.ibDataSet37QUANTIDADE.AsFloat * Form7.ibDataSet37UNITARIO.AsFloat);
      fTotal1 := fTotal1 + (Form7.ibDataSet37QUANTIDADE.AsFloat * Form7.ibDataSet37UNITARIO.AsFloat);
    end;
    Form7.ibDataSet37.Next;
  end;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+' >');
    WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal])+'<br></font></td>');
    WriteLn(F,'    </tr>');
    WriteLn(F,'    </table>');
    WriteLn(F,'   </td>');
    WriteLn(F,'  </tr>');
    WriteLn(F,' </td>');
    WriteLn(F,'</table>');
    Writeln(F,'<br><br><font face="Microsoft Sans Serif" size=1>'+  AllTrim(FloatToStr(fTotal2))  +' or�amentos pendentes, no valor total de R$ '+AllTrim(Format('%11.'+Form1.ConfPreco+'n',[fTotal1]))+'<br><br>');
    Writeln(F,'<font face="Microsoft Sans Serif" size=1><br>Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br>');
    WriteLn(F,'</center>');
  end else
  begin
    WriteLn(F,'                                                                 --------------');
    WriteLn(F,'                                                                  '+ Format('%14.'+Form1.ConfPreco+'n',[fTotal])+'');
    WriteLn(F,' ');
    Writeln(F,FloatToStr(fTotal2)+' or�amentos pendentes, no valor total de R$ '+Alltrim(Format('%11.'+Form1.ConfPreco+'n',[fTotal1])));
    WriteLn(F,' ');
    Writeln(F,'Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'');
  end;
end;

procedure TForm38.RelatorioVenda(var F: TextFile; dInicio, dFinal : TdateTime;  var fTotal, fTotal1, fTotal2, fTotal3, fTotal4, fTotal5, fTotal6  : Real);
var
  bCil : Boolean;
  I : integer;
begin
  fTotal1 := 0;
  fTotal2 := 0;
  fTotal3 := 0;
  fTotal4 := 0;
  fTotal5 := 0;
  fTotal6 := 0;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'   <table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor='+form1.sHtmlCor+' align=left>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Nota</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Data</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Cliente</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Produtos R$</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Servi�os R$</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Frete R$</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Desconto R$</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Outras R$</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total R$</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>ICMS R$</font></th>');
    WriteLn(F,'    </tr>');
  end else
  begin
    WriteLn(F,'Nota       Data       Cliente                             Produtos R$   Servi�os R$   Frete R$      Desconto R$   Outras R$     TOTAL R$      ICMS R$');
    WriteLn(F,'---------- ---------- ----------------------------------- ------------- ------------- ------------- ------------- ------------- ------------- -------------');
  end;

  Form7.IBDataSet15.Close;
  Form7.IBDataSet15.SelectSQL.Clear;
  Form7.IBDataSet15.SelectSQL.Add('select * from VENDAS where EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and EMITIDA=''S'' order by EMISSAO, NUMERONF');
  Form7.IBDataSet15.Open;
  Form7.IBDataSet15.First;

  while (not Form7.ibDataSet15.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    Application.ProcessMessages;
    bCil := False;
    for I := 0 to (chkOperacoes.Items.Count -1) do
       if chkOperacoes.Checked[I] then
         if chkOperacoes.Items[I] = Form7.ibDataSet15OPERACAO.AsString then
            bCil := True;
    if bCil then
    begin
      if Form1.bHtml1 then
      begin
        WriteLn(F,'   <tr>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9)+'/'+Copy(Form7.ibDataSet15NUMERONF.AsString,10,3)+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+DateToStr(Form7.ibDataSet15EMISSAO.AsDateTime)+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet15CLIENTE.AsString+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet15MERCADORIA.AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet15SERVICOS.AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet15FRETE.AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet15DESCONTO.AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet15DESPESAS.AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet15TOTAL.AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet15ICMS.AsFloat])+'<br></font></td>');
        WriteLn(F,'   </tr>');
      end else
      begin
        Write(F,Copy(Form7.ibDataSet15NUMERONF.AsString+Replicate(' ',9),1,9)+'  ');
        Write(F,DateToStr(Form7.ibDataSet15EMISSAO.AsDateTime)+' ');
        Write(F,Copy(Form7.ibDataSet15CLIENTE.AsString+Replicate(' ',35),1,35)+' ');
        Write(F,Format('%13.'+Form1.ConfPreco+'n',[Form7.ibDataSet15MERCADORIA.AsFloat])+' ');
        Write(F,Format('%13.'+Form1.ConfPreco+'n',[Form7.ibDataSet15SERVICOS.AsFloat])+' ');
        Write(F,Format('%13.'+Form1.ConfPreco+'n',[Form7.ibDataSet15FRETE.AsFloat])+' ');
        Write(F,Format('%13.'+Form1.ConfPreco+'n',[Form7.ibDataSet15DESCONTO.AsFloat])+' ');
        Write(F,Format('%13.'+Form1.ConfPreco+'n',[Form7.ibDataSet15DESPESAS.AsFloat])+' ');
        Write(F,Format('%13.'+Form1.ConfPreco+'n',[Form7.ibDataSet15TOTAL.AsFloat])+' ');
        WriteLn(F,Format('%13.'+Form1.ConfPreco+'n',[Form7.ibDataSet15ICMS.AsFloat])+'');
      end;

      fTotal := fTotal + Form7.ibDataSet15TOTAL.AsFloat;
      fTotal1 := fTotal1 + Form7.ibDataSet15ICMS.AsFloat;
      fTotal2 := fTotal2 + Form7.ibDataSet15MERCADORIA.AsFloat;
      fTotal3 := fTotal3 + Form7.ibDataSet15FRETE.AsFloat;
      fTotal4 := fTotal4 + Form7.ibDataSet15DESCONTO.AsFloat;
      fTotal5 := fTotal5 + Form7.ibDataSet15DESPESAS.AsFloat;
      fTotal6 := fTotal6 + Form7.ibDataSet15SERVICOS.AsFloat;
    end;

    Form7.ibDataSet15.Next;
  end;
end;

procedure TForm38.RelatorioVendaItem(var F: TextFile; dInicio, dFinal : TdateTime;  var fTotal, fTotal1, fTotal2, fTotal3, fTotal4, fTotal5, fTotal6  : Real);
var
  bCil : Boolean;
  I : integer;
begin
  if Form1.bHtml1 then
  begin
    WriteLn(F,'   <table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor='+form1.sHtmlCor+' align=left>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Nota</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Data</font></th>');
    if cbListarCodigos.Checked then
      WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>C�digo</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Descri��o do item</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Quantidade</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Vendido por</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Custo compra</font></th>');
    WriteLn(F,'    </tr>');
  end else
  begin
    if cbListarCodigos.Checked then
    begin
      WriteLn(F,'Nota      Data       C�digo  Descri��o do item                   Quantidade     Vendido por    Custo compra');
      WriteLn(F,'--------- ---------- ------- ----------------------------------- -------------- -------------- --------------');
    end else
    begin
      WriteLn(F,'Nota      Data       Descri��o do item                   Quantidade     Vendido por    Custo compra');
      WriteLn(F,'--------- ---------- ----------------------------------- -------------- -------------- --------------');
    end;
  end;

  Form7.IBDataSet15.Close;
  Form7.IBDataSet15.SelectSQL.Clear;
  Form7.IBDataSet15.SelectSQL.Add('select * from VENDAS where EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' and EMITIDA=''S'' order by EMISSAO, NUMERONF');
  Form7.IBDataSet15.Open;
  Form7.IBDataSet15.First;

  while (not Form7.ibDataSet15.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    Application.ProcessMessages;
    bCil := False;
    for I := 0 to (chkOperacoes.Items.Count -1) do
    begin
      if chkOperacoes.Checked[I] then
      begin
        if chkOperacoes.Items[I] =Form7.ibDataSet15OPERACAO.AsString then
        begin
          bcil := True;
        end;
      end;
    end;

    if bCil then
    begin
      Form7.ibDataSet16.Close;
      Form7.ibDataSet16.SelectSQL.Clear;
      Form7.ibDataSet16.SelectSQL.Add('select * from ITENS001 where NUMERONF='+QuotedStr(Form7.ibDataSet15NUMERONF.AsString)+'  and coalesce(QUANTIDADE,0) = coalesce(SINCRONIA,0)');
      Form7.ibDataSet16.Open;
      Form7.ibDataSet16.First;

      while (not Form7.ibDataSet16.EOF) and (Form38.Caption <> 'Cancelar') do
      begin
        Application.ProcessMessages;

        if Form1.bHtml1 then
        begin
          WriteLn(F,'   <tr>');
          WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9)+'/'+Copy(Form7.ibDataSet15NUMERONF.AsString,10,3)+'<br></font></td>');
          WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+DateToStr(Form7.ibDataSet15EMISSAO.AsDateTime)+'<br></font></td>');
          if cbListarCodigos.Checked then
            WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet16CODIGO.AsString+'<br></font></td>');
          WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet16DESCRICAO.AsString+'<br></font></td>');
          WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[Form7.ibDataSet16QUANTIDADE.AsFloat])+'<br></font></td>');
          WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet16QUANTIDADE.AsFloat * Form7.ibDataSet16UNITARIO.AsFloat ])+'<br></font></td>');
          WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet16QUANTIDADE.AsFloat * Form7.ibDataSet16CUSTO.AsFloat ])+'<br></font></td>');
          WriteLn(F,'   </tr>');
        end else
        begin
          Write(F,Copy(Form7.ibDataSet15NUMERONF.AsString+Replicate(' ',9),1,9)+' ');
          Write(F,DateToStr(Form7.ibDataSet15EMISSAO.AsDateTime)+' ');
          if cbListarCodigos.Checked then
            Write(F,Copy(Form7.ibDataSet16CODIGO.AsString+Replicate(' ',7),1,7)+' ');
          Write(F,Copy(Form7.ibDataSet16DESCRICAO.AsString+Replicate(' ',35),1,35)+' ');
          Write(F,Format('%14.'+Form1.ConfCasas+'n',[Form7.ibDataSet16QUANTIDADE.AsFloat])+' ');
          Write(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet16QUANTIDADE.AsFloat * Form7.ibDataSet16UNITARIO.AsFloat ])+' ');
          WriteLn(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet16QUANTIDADE.AsFloat * Form7.ibDataSet16CUSTO.AsFloat ])+'');
        end;

        fTotal := fTotal + (Form7.ibDataSet16QUANTIDADE.AsFloat * Form7.ibDataSet16UNITARIO.AsFloat);
        fTotal1 := fTotal1 + (Form7.ibDataSet16QUANTIDADE.AsFloat * Form7.ibDataSet16CUSTO.AsFloat);
        Form7.ibDataSet16.Next;
      end;
    end;

    Form7.ibDataSet15.Next;
  end;
end;


procedure TForm38.GeraRelatorioVendaEstado(var F: TextFile; dInicio, dFinal : TdateTime);
var
  bCil : Boolean;
  I : integer;
  fTotal, fTotalV : Real;
  qryRel : TIBQuery;
begin
  if Form1.bHtml1 then
  begin
    WriteLn(F,'  <center><table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor='+form1.sHtmlCor+' align=left>');
    WriteLn(F,'     <th><font face="Microsoft Sans Serif" size=1>Estado</font></th>');
    WriteLn(F,'     <th><font face="Microsoft Sans Serif" size=1>Vendas</font></th>');
    WriteLn(F,'     <th><font face="Microsoft Sans Serif" size=1>Total R$</font></th>');
    WriteLn(F,'    </tr>');
  end else
  begin
    WriteLn(F,'Estado  Vendas        Total R$     ');
    WriteLn(F,'------- ------------- -------------');
  end;

  fTotal := 0;

  try
    qryRel := CriaIBQuery(Form7.IBTransaction1);
    qryRel.SQL.Text := 'Select '+
                       '  C.ESTADO,'+
                       '  count(1) as VENDAS,'+
                       '  sum(V.TOTAL) as TOTAL'+
                       ' From VENDAS V '+
                       '   left join CLIFOR C on c.nome = v.cliente'+
                       ' Where V.EMISSAO between '+QuotedStr(DateToStrInvertida(dInicio))+' and '+QuotedStr(DateToStrInvertida(dFinal))+
                       GetFiltroOperacao('V')+
                       '  and V.EMITIDA=''S'''+
                       ' Group by C.ESTADO'+
                       ' Order by 3 desc';
    qryRel.Open;

    while (not qryRel.EOF) and (Form38.Caption <> 'Cancelar') do
    begin
      Application.ProcessMessages;

      if Form1.bHtml1 then
      begin
        WriteLn(F,'   <tr>');
        WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+qryRel.FieldByName('ESTADO').AsString +'<br></font></td>');
        WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+qryRel.FieldByName('VENDAS').AsString+'<br></font></td>');
        WriteLn(F,'    <td valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[qryRel.FieldByName('TOTAL').AsFloat])+'<br></font></td>');
        WriteLn(F,'   </tr>');
      end else
      begin
        Write(F,Copy(qryRel.FieldByName('ESTADO').AsString+Replicate(' ',7),1,7)+' ');
        Write(F,Format('%13.'+Form1.ConfPreco+'n',[qryRel.FieldByName('VENDAS').AsFloat])+' ');
        WriteLn(F,Format('%13.'+Form1.ConfPreco+'n',[qryRel.FieldByName('TOTAL').AsFloat])+' ');
      end;

      fTotal  := fTotal + qryRel.FieldByName('TOTAL').AsFloat;
      fTotalV := fTotalV + qryRel.FieldByName('VENDAS').AsFloat;

      qryRel.Next;
    end;

  finally
    FreeAndNil(qryRel);
  end;

  //Totais
  if Form1.bHtml1 then
  begin
    WriteLn(F,'    <tr bgcolor='+form1.sHtmlCor+' align=left>');
    WriteLn(F,'     <td valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
    WriteLn(F,'     <td valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+FloatToStr(fTotalV)+'<br></font></td>');
    WriteLn(F,'     <td valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal])+'<br></font></td>');
    WriteLn(F,'    </tr>');

    WriteLn(F,'   </table></center>');
  end else
  begin
    WriteLn(F,'------- ------------- -------------');
    Write(F,  '        ');
    Write(F,Format('%13.'+Form1.ConfPreco+'n',[fTotalV])+' ');
    WriteLn(F,Format('%13.'+Form1.ConfPreco+'n',[fTotal])+' ');
  end;
end;


procedure TForm38.RelatorioCompras(var F: TextFile; dInicio, dFinal : TdateTime;  var fTotal, fTotal1, fTotal2, fTotal3, fTotal4, fTotal5, fTotal6  : Real);
var
  bCil : Boolean;
  I : integer;
begin
  fTotal1 := 0;
  fTotal2 := 0;
  fTotal3 := 0;
  fTotal4 := 0;
  fTotal5 := 0;
  fTotal6 := 0;

  if Form1.bHtml1 then
  begin
    WriteLn(F,'   <table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor='+form1.sHtmlCor+' align=left>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Nota</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Data</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Fornecedor</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Produtos R$</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Servi�os R$</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Frete R$</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Desconto R$</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Outras R$</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Total R$</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>ICMS R$</font></th>');
    WriteLn(F,'    </tr>');
  end else
  begin
    WriteLn(F,'Nota       Data       Fornecedor                          Produtos R$   Servi�os R$   Frete R$      Desconto R$   Outras R$     TOTAL R$      ICMS R$');
    WriteLn(F,'---------- ---------- ----------------------------------- ------------- ------------- ------------- ------------- ------------- ------------- -------------');
  end;

  Form7.IBDataSet24.Close;
  Form7.IBDataSet24.SelectSQL.Clear;
  Form7.IBDataSet24.SelectSQL.Add('select * from COMPRAS where EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' order by EMISSAO');
  Form7.IBDataSet24.Open;
  Form7.IBDataSet24.First;

  while (not Form7.ibDataSet24.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    Application.ProcessMessages;
    bCil := False;
    for I := 0 to (chkOperacoes.Items.Count -1) do
       if chkOperacoes.Checked[I] then
         if chkOperacoes.Items[I] = Form7.ibDataSet24OPERACAO.AsString then
            bCil := True;
    if bCil then
    begin
      if Form1.bHtml1 then
      begin
        WriteLn(F,'   <tr>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataset24NUMERONF.AsString,1,9)+'/'+Copy(Form7.ibDataset24NUMERONF.AsString,10,3)+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+DateToStr(Form7.ibDataset24EMISSAO.AsDateTime)+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataset24FORNECEDOR.AsString+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataset24MERCADORIA.AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataset24SERVICOS.AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataset24FRETE.AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataset24DESCONTO.AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataset24DESPESAS.AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataset24TOTAL.AsFloat])+'<br></font></td>');
        WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataset24ICMS.AsFloat])+'<br></font></td>');
        WriteLn(F,'   </tr>');
      end else
      begin
        Write(F,Copy(Form7.ibDataset24NUMERONF.AsString+Replicate(' ',9),1,9)+'  ');
        Write(F,DateToStr(Form7.ibDataset24EMISSAO.AsDateTime)+' ');
        Write(F,Copy(Form7.ibDataset24FORNECEDOR.AsString+Replicate(' ',35),1,35)+' ');
        Write(F,Format('%13.'+Form1.ConfPreco+'n',[Form7.ibDataset24MERCADORIA.AsFloat])+' ');
        Write(F,Format('%13.'+Form1.ConfPreco+'n',[Form7.ibDataset24SERVICOS.AsFloat])+' ');
        Write(F,Format('%13.'+Form1.ConfPreco+'n',[Form7.ibDataset24FRETE.AsFloat])+' ');
        Write(F,Format('%13.'+Form1.ConfPreco+'n',[Form7.ibDataset24DESCONTO.AsFloat])+' ');
        Write(F,Format('%13.'+Form1.ConfPreco+'n',[Form7.ibDataset24DESPESAS.AsFloat])+' ');
        Write(F,Format('%13.'+Form1.ConfPreco+'n',[Form7.ibDataset24TOTAL.AsFloat])+' ');
        WriteLn(F,Format('%13.'+Form1.ConfPreco+'n',[Form7.ibDataset24ICMS.AsFloat])+'');
      end;

      fTotal := fTotal + Form7.ibDataSet24TOTAL.AsFloat;
      fTotal1 := fTotal1 + Form7.ibDataSet24ICMS.AsFloat;
      fTotal2 := fTotal2 + Form7.ibDataSet24MERCADORIA.AsFloat;
      fTotal3 := fTotal3 + Form7.ibDataSet24FRETE.AsFloat;
      fTotal4 := fTotal4 + Form7.ibDataSet24DESCONTO.AsFloat;
      fTotal5 := fTotal5 + Form7.ibDataSet24DESPESAS.AsFloat;
      fTotal6 := fTotal6 + Form7.ibDataSet24SERVICOS.AsFloat;
    end;
    
    Form7.ibDataSet24.Next;
  end;
end;

procedure TForm38.RelatorioComprasItem(var F: TextFile; dInicio, dFinal : TdateTime;  var fTotal, fTotal1, fTotal2, fTotal3, fTotal4, fTotal5, fTotal6  : Real);
var
  bCil : Boolean;
  I : integer;
begin
  if Form1.bHtml1 then
  begin
    WriteLn(F,'   <table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor='+form1.sHtmlCor+' align=left>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Nota</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Data</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>C�digo</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Descri��o do item</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Quantidade</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Comprado por</font></th>');
    WriteLn(F,'     <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>Custo compra</font></th>');
    WriteLn(F,'    </tr>');
  end else
  begin
    WriteLn(F,'Nota      Data       C�digo  Descri��o do item                   Quantidade     Comprado por   Custo compra');
    WriteLn(F,'--------- ---------- ------- ----------------------------------- -------------- -------------- --------------');
  end;

  Form7.IBDataSet24.Close;
  Form7.IBDataSet24.SelectSQL.Clear;
  Form7.IBDataSet24.SelectSQL.Add('select * from COMPRAS where EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' order by EMISSAO');
  Form7.IBDataSet24.Open;
  Form7.IBDataSet24.First;

  while (not Form7.ibDataSet24.EOF) and (Form38.Caption <> 'Cancelar') do
  begin
    Application.ProcessMessages;
    bCil := False;
    for I := 0 to (chkOperacoes.Items.Count -1) do
       if chkOperacoes.Checked[I] then
         if chkOperacoes.Items[I] = Form7.ibDataSet24OPERACAO.AsString then
            bCil := True;
    if bCil then
    begin
      Form7.ibDataSet23.Close;
      Form7.ibDataSet23.SelectSQL.Clear;
      Form7.ibDataSet23.SelectSQL.Add('select * from ITENS002 where NUMERONF='+QuotedStr(Form7.ibDataSet24NUMERONF.AsString)+' and FORNECEDOR='+QuotedStr(Form7.ibDataSet24FORNECEDOR.AsString)+' and UNITARIO<>0');
      Form7.ibDataSet23.Open;
      Form7.ibDataSet23.First;

      while (not Form7.ibDataSet23.EOF) and (Form38.Caption <> 'Cancelar') do
      begin
        Application.ProcessMessages;
        if Form1.bHtml1 then
        begin
          WriteLn(F,'    <tr>');
          WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet24NUMERONF.AsString,1,9)+'/'+Copy(Form7.ibDataSet24NUMERONF.AsString,10,3)+'<br></font></td>');
          WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+DateToStr(Form7.ibDataSet24EMISSAO.AsDateTime)+'<br></font></td>');
          WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet23CODIGO.AsString+'<br></font></td>');
          WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet23DESCRICAO.AsString+'<br></font></td>');
          WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[Form7.ibDataSet23QUANTIDADE.AsFloat])+'<br></font></td>');
          WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet23QUANTIDADE.AsFloat * Form7.ibDataSet23UNITARIO.AsFloat ])+'<br></font></td>');
          WriteLn(F,'     <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%11.'+Form1.ConfPreco+'n',[Form7.ibDataSet23QUANTIDADE.AsFloat * Form7.ibDataSet23CUSTO.AsFloat ])+'<br></font></td>');
          WriteLn(F,'    </tr>');
        end else
        begin
          Write(F,Copy(Form7.ibDataSet24NUMERONF.AsString+Replicate(' ',7),1,9)+' ');
          Write(F,DateToStr(Form7.ibDataSet24EMISSAO.AsDateTime)+' ');
          Write(F,Copy(Form7.ibDataSet23CODIGO.AsString+Replicate(' ',2),1,7)+' ');
          Write(F,Copy(Form7.ibDataSet23DESCRICAO.AsString+Replicate(' ',35),1,35)+' ');
          Write(F,Format('%14.'+Form1.ConfCasas+'n',[Form7.ibDataSet23QUANTIDADE.AsFloat])+' ');
          Write(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet23QUANTIDADE.AsFloat * Form7.ibDataSet23UNITARIO.AsFloat ])+' ');
          WriteLn(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet23QUANTIDADE.AsFloat * Form7.ibDataSet23CUSTO.AsFloat ])+'');
        end;

        fTotal := fTotal + (Form7.ibDataSet23QUANTIDADE.AsFloat * Form7.ibDataSet23UNITARIO.AsFloat);
        fTotal1 := fTotal1 + (Form7.ibDataSet23QUANTIDADE.AsFloat * Form7.ibDataSet23CUSTO.AsFloat);
        Form7.ibDataSet23.Next;
      end;
    end;

    Form7.ibDataSet24.Next;
  end;
end;

procedure TForm38.RelatorioComprasVenda(var F: TextFile; dInicio, dFinal : TdateTime);
var
   fTotal, fTotal1, fTotal2, fTotal3, fTotal4, fTotal5, fTotal6  : Real;
   I : integer;
begin
  {Mauricio Parizotto 2024-05-31 Inicio}
  GeraNomeRelatorio(F, Form7.sModulo);

  if Form1.bHtml1 then
  begin
    WriteLn(F,'<center>');
    WriteLn(F,'<table border=0>');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td>');
  end;

  if rbItemPorITem.Checked then
  begin
    if Form7.sModulo =  'Relat�rio de compras' then
    begin
      RelatorioComprasItem(F,dInicio,dFinal, fTotal, fTotal1, fTotal2, fTotal3, fTotal4, fTotal5, fTotal6);
    end else
    begin
      RelatorioVendaItem(F,dInicio,dFinal, fTotal, fTotal1, fTotal2, fTotal3, fTotal4, fTotal5, fTotal6);
    end;

    if Form1.bHtml1 then
    begin
      WriteLn(F,'    <tr bgcolor='+form1.sHtmlCor+' align=left>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      if (cbListarCodigos.Checked) or (Form7.sModulo =  'Relat�rio de compras') then
        WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal])+'<br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal1])+'<br></font></td>');
      WriteLn(F,'    </tr>');
      WriteLn(F,'   </table></center>');
    end else
    begin
      if (cbListarCodigos.Checked) or (Form7.sModulo =  'Relat�rio de compras') then
      begin
        WriteLn(F,DupeString(' ',80) + '-------------- --------------');
        Write(F,DupeString(' ',80) + Format('%14.'+Form1.ConfPreco+'n',[fTotal])+' ');
      end else
      begin
        WriteLn(F,DupeString(' ',72) + '-------------- --------------');
        Write(F,DupeString(' ',72) + Format('%14.'+Form1.ConfPreco+'n',[fTotal])+' ');
      end;
      WriteLn(F,Format('%14.'+Form1.ConfPreco+'n',[fTotal1])+'');
      WriteLn(F,'');
    end;
  end else
  begin
    if Form7.sModulo =  'Relat�rio de compras' then
    begin
      RelatorioCompras(F,dInicio,dFinal,fTotal, fTotal1, fTotal2, fTotal3, fTotal4, fTotal5, fTotal6);
    end else
    begin
      RelatorioVenda(F,dInicio,dFinal,fTotal, fTotal1, fTotal2, fTotal3, fTotal4, fTotal5, fTotal6);
    end;
              
    if Form1.bHtml1 then
    begin
      WriteLn(F,'    <tr bgcolor='+form1.sHtmlCor+' align=left>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal2])+'<br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal6])+'<br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal3])+'<br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal4])+'<br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal5])+'<br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal])+'<br></font></td>');
      WriteLn(F,'     <td '+{nowrap}' valign=top align=right><font face="Microsoft Sans Serif" size=1><b>'+ Format('%11.'+Form1.ConfPreco+'n',[fTotal1])+'<br></font></td>');
      WriteLn(F,'    </tr>');
      WriteLn(F,'   </table></center>');
    end else
    begin
      WriteLn(F,'                                                          ------------- ------------- ------------- ------------- ------------- ------------- -------------');
      Write(F,'                                                          ');
      Write(F,Format('%13.'+Form1.ConfPreco+'n',[fTotal2])+' ');
      Write(F,Format('%13.'+Form1.ConfPreco+'n',[fTotal6])+' ');
      Write(F,Format('%13.'+Form1.ConfPreco+'n',[fTotal3])+' ');
      Write(F,Format('%13.'+Form1.ConfPreco+'n',[fTotal4])+' ');
      Write(F,Format('%13.'+Form1.ConfPreco+'n',[fTotal5])+' ');
      Write(F,Format('%13.'+Form1.ConfPreco+'n',[fTotal])+' ');
      WriteLn(F,Format('%13.'+Form1.ConfPreco+'n',[fTotal1])+'');
    end;
  end;

  if (Form7.sModulo = 'Relat�rio de vendas') or (Form7.sModulo = 'Relat�rio de compras') then
  begin
    ListaOperacoesMarcadas(F);
  end;

  {Mauricio Parizotto 2024-05-31}
  if Form1.bHtml1 then
  begin
    WriteLn(F,'   </td>');
    WriteLn(F,'  </table>');
  end;

  ListaPeiodoSelecionado(F,dInicio, dFinal);
end;

procedure TForm38.RelatorioVendaEstado(var F: TextFile; dInicio, dFinal : TdateTime);
begin
  GeraNomeRelatorio(F,Form7.sModulo);
  GeraRelatorioVendaEstado(F,dInicio,dFinal);
  ListaOperacoesMarcadas(F);
  ListaPeiodoSelecionado(F,dInicio, dFinal);
end;

procedure TForm38.btnMarcarTodosClick(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to chkOperacoes.Items.Count -1 do
  begin
    chkOperacoes.Checked[i] := True;
  end;
end;

procedure TForm38.btnDesmarcarTodosClick(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to chkOperacoes.Items.Count -1 do
  begin
    chkOperacoes.Checked[i] := False;
  end;
end;

procedure TForm38.ListaOperacoesMarcadas(var F: TextFile); // Mauricio Parizotto 2024-05-31
var
  i : integer;
begin
  if Form1.bHtml1 then
  begin
    WriteLn(F,'<center><table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,'    <tr bgcolor=#FFFFFF align=left>');
    WriteLn(F,'     <td><P><font face="Microsoft Sans Serif" size=1><b>Opera��es listadas:</b><br>');
    for I := 0 to (chkOperacoes.Items.Count -1) do
      if chkOperacoes.Checked[I] then
          Writeln(F,'     <br><font face="Microsoft Sans Serif" size=1>'+AllTrim(chkOperacoes.Items[I]));
    Writeln(F,'      </td><br>');
    WriteLn(F,'     </td>');
    WriteLn(F,'    </table> </center>');
  end else
  begin
    WriteLn(F,'');
    WriteLn(F,'Opera��es listadas:');
    for I := 0 to (chkOperacoes.Items.Count -1) do
      if chkOperacoes.Checked[I] then
          Writeln(F,AllTrim(chkOperacoes.Items[I]));
    WriteLn(F,'');
  end;
end;

procedure TForm38.ListaPeiodoSelecionado(var F: TextFile; dInicio, dFinal : TdateTime); //Mauricio Parizotto 2024-05-31
begin
  if Form1.bHtml1 then
  begin
    Writeln(F,'<center>  <font face="Microsoft Sans Serif" size=1><br>Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'<br></center>');
  end else
  begin
    WriteLn(F,'');
    WriteLn(F,'');
    Writeln(F,'Per�odo analisado, de ' + DateTimeToStr(dInicio) + ' at� ' + DateTimeToStr(dFinal)+'');
  end;
end;


procedure Tform38.GeraNomeRelatorio(var F: TextFile; sNome:string);
begin
  if Form1.bHtml1 then
  begin
    WriteLn(F,'<br><center><font size=4 color=#000000><b>'+sNome+'</b></font><br></center><br>');
  end else
  begin
    WriteLn(F,sNome);
    WriteLn(F,'');
  end;
end;

procedure Tform38.RodapePadrao(var F: TextFile; tInicio : tTime);
begin
  if Form1.bHtml1 then
  begin
    WriteLn(F,'<center><br><font face="Microsoft Sans Serif" size=1>Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
    + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
    + Copy(DateTimeToStr(Date),7,4) + ' �s ' + TimeToStr(Time)+'</font><br>');

    if (Alltrim(Form7.ibDataSet13HP.AsString) = '') then
    begin
      WriteLn(F,'<font face="verdana" size=1><center>Relat�rio gerado pelo sistema Smallsoft, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
    end else
    begin
      WriteLn(F,'<font face="verdana" size=1><center><a href="http://'+Form7.ibDataSet13HP.AsString+'">'+Form7.ibDataSet13HP.AsString+'</a><font>');
    end;

    WriteLn(F,'<font face="Microsoft Sans Serif" size=1><center>Tempo para gerar este relat�rio: '+TimeToStr(Time - tInicio)+'</center>');
    if not Form1.bPDF then WriteLn(F,'<a href="http://www.smallsoft.com.br/meio_ambiente.htm"><center><font face="Webdings" size=5 color=#215E21>P<font face="Microsoft Sans Serif" size=1 color=#215E21> Antes de imprimir, pense no meio ambiente.</center></a>');
    WriteLn(F,'</html>');
  end else
  begin
    WriteLn(F,'Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
    + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
    + Copy(DateTimeToStr(Date),7,4) + ' �s ' + TimeToStr(Time)+'');

    WriteLn(F,'Tempo para gerar este relat�rio: '+TimeToStr(Time - tInicio)+'');

    if Form7.sModulo =  'Auditoria' then
    begin
      WriteLn(F,'Assinatura Digital:');
    end;
  end;
end;

function TForm38.GetFiltroOperacao(sAliasTabela:string):string;
var
  I : Integer;
  sOperacoes : string;
begin
  Result := '';

  for I := 0 to (chkOperacoes.Items.Count -1) do
  begin
    if not chkOperacoes.Checked[I] then
    begin
      sOperacoes := sOperacoes + ' and '+sAliasTabela+'.OPERACAO<>'+QuotedStr(chkOperacoes.Items[I])+' ';
    end;
  end;

  Result := sOperacoes;
end;


end.

