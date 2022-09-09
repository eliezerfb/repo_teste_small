unit pesado1;

interface        

uses

  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Inifiles, SmallFunc, ShellApi, Menus;

  function AbrePorta(const Porta,BaudRate,DataBits,Paridade:Integer):Integer;stdcall;external 'P05.DLL';
  function FechaPorta:Integer;stdcall;external 'P05.DLL';
  function FechaPortaP05:Integer;stdcall;external 'P05.DLL';
  function PegaPeso(const OpcaoEscrita:integer;Peso,Local:Pchar):Integer;stdcall;external 'P05.DLL';
  function PegaPesoP05B(const OpcaoEscrita,PedeTara:integer;Peso,Local:Pchar):Integer;stdcall;external 'P05.DLL';
  procedure VersaoDLL(Versao:Pchar);stdcall;external 'P05.DLL';

type TDadosPeso = record
  Peso          : array[0..6] of char;
  Espaco        : char;
  Tara          : array[0..5] of char;
end;

type
  TBalancaUrano = class(TComponent)
    private
      DLL: THandle;
      AbrePortaSerial: function(Canal: String): Integer; stdcall;
      FechaPortaSerial: function(): Integer; stdcall;
      AlteraModeloBalanca: function(Modelo: Integer) : Integer; stdcall;
      AlteraModoOperacao: function(Modo: Integer): Integer; stdcall;
      LePeso: function(): Pchar; stdcall;
      FPeso1: AnsiString;
      FPeso2: AnsiString;
      procedure Import(var Proc: pointer; Name: Pchar);
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure CarregaDLL;
      procedure FinalizaDLL;
      property sPeso1: AnsiString read FPeso1 write FPeso1;
      property sPeso2: AnsiString read FPeso2 write FPeso2;
    published
end;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    PopupMenu1: TPopupMenu;
    ConfigurarbalanasTOLEDO1: TMenuItem;
    Configuraroutrasbalanas1: TMenuItem;
    N1: TMenuItem;
    Fecharoprograma1: TMenuItem;
    Label7: TLabel;
    N2: TMenuItem;
    Multiplicador1: TMenuItem;
    Divisor1: TMenuItem;
    ConfigurarbalanasURANO1: TMenuItem;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Configuraroutrasbalanas1Click(Sender: TObject);
    procedure ConfigurarbalanasTOLEDO1Click(Sender: TObject);
    procedure Fecharoprograma1Click(Sender: TObject);
    procedure PopupMenu1Change(Sender: TObject; Source: TMenuItem;
      Rebuild: Boolean);
    procedure Multiplicador1Click(Sender: TObject);
    procedure Divisor1Click(Sender: TObject);
    procedure ConfigurarbalanasURANO1Click(Sender: TObject);
  private
    { Private declarations }
    Urano: TBalancaUrano;
  public
    { Public declarations }
    sMarca  : String;
    sTipo   : String;
    sModelo : String;
    sPorta  : String;
    iTempo    : Integer;
    iCasas    : Integer;
    iSegundos : Integer;
    iBaudRate : Integer;
    iParidade : Integer;
    iDataBits : Integer;
    iMultiplicador, iDivisor  : Integer;
  end;

type

  PInteger = ^Integer;

var
  Form1: TForm1;

  //Variaveis que armazenarão os retornos da função ObtemParametrosBalanca
  Modelo, Porta, BaudRate: Integer;

  //Mascara para formatacao do peso com casas decimais
  Mascara : String;

  //Variável que armazenará o modelo da balança, função ObtemNomeBalanca
  CModelo: array[0..50] of char;

Const
  cSessaoConf   = 'BALANCA';
  cPorta        = 'Serial';
  cBaudRate     = 'BaudRate';
  cParidade     = 'Paridade';
  cDataBits     = 'DataBits';
  cDiponibi     = 'Diponibilizacao';
  cMinimizado   = 'Minimizado';
  cDirPESO      = 'DirPeso';
  cTempoLeitura = 'TempoLeitura';
  cTipoLeitura  = 'TipoLeitura';
  cContinuo     = 'Continuo';

implementation

uses Unit2, Unit3;

{$R *.DFM}

//----------------------------------------------------------------//
{                   INICIO FUNCOES DA DLL PcScale                  }
//----------------------------------------------------------------//
{Declara a função ConfiguraBalanca existente na DLL "PcScale.dll"}
function ConfiguraBalanca(Balanca: Integer; Aplicativo: THandle): Boolean;
             stdcall; external 'PcScale.dll';

{Declara a função InicializaLeitura existente na DLL "PcScale.dll"}
function InicializaLeitura(Balanca: Integer): Boolean;
             stdcall; external 'PcScale.dll';

{Declara a função ObtemInformacao existente na DLL "PcScale.dll"}
function ObtemInformacao(Balanca: Integer; Campo: Integer): double;
             stdcall; external 'PcScale.dll';

{Declara a função FinalizaLeitura existente na DLL "PcScale.dll"}
function FinalizaLeitura(Balanca: Integer) : Boolean;
             stdcall; external 'PcScale.dll';

{Declara a função ExibeMsgErro existente na DLL "PcScale.dll"}
function EnviaPrecoCS(Balanca : integer; Preco : double) : Boolean;
             stdcall; external 'PcScale.dll';

{Declara a função FinalizaLeitura existente na DLL "PcScale.dll"}
function ObtemParametrosBalanca(Balanca: Integer; Modelo: PInteger;
                             Porta: PInteger; BaudRate: PInteger
                             ): Boolean
             stdcall; external 'PcScale.dll';

{Declara a função ObtemNomeBalanca existente na DLL "PcScale.dll"}
Procedure ObtemNomeBalanca(Modelo: Integer; Ret: PChar);
             stdcall; external 'PcScale.dll';

{Declara a função ExibeMsgErro existente na DLL "PcScale.dll"}
Procedure ExibeMsgErro(Aplicativo : THandle);
             stdcall; external 'PcScale.dll';

procedure TForm1.Timer1Timer(Sender: TObject);
var
  Mais1Ini : TIniFile;
  status   : Integer;
  Peso          : array[0..5]of char;
  PesoP05B      : array[0..14] of char;
  dadoPeso      : TDadosPeso;
  sPesoUrano: AnsiString;
begin
  //
  Label1.Caption := TimeToStr(Time)+' Aguarde... ';
  //
  if sMarca = 'TOLEDO' then
  begin
    //
    try
      Timer1.Enabled := False;
      //
      Label2.Caption := FormatFloat('0.'+Replicate('0',iCasas),0);
      Label5.Caption   := 'Porta: '+sPorta;
      //
      if iBaudRate = 0 then Label6.Caption   := 'Velocidade: 2400';
      if iBaudRate = 1 then Label6.Caption   := 'Velocidade: 4800';
      if iBaudRate = 2 then Label6.Caption   := 'Velocidade: 9600';
      if iBaudRate = 3 then Label6.Caption   := 'Velocidade: 1200';
      if iBaudRate = 4 then Label6.Caption   := 'Velocidade: 19200';
      //
      if sTipo = '1' then
      begin
        Label4.Caption   := 'Modelo: ' + 'Toledo protocolo P05B';
        FillChar(PesoP05B,sizeof(PesoP05B),0);
        //
        if (PegaPesoP05B(1,0,PesoP05B,'c:\') = 1) then
        begin
          //
          FillChar(dadoPeso,sizeof(dadoPeso),0);
          Move(PesoP05B,dadoPeso,length(StrPas(PesoP05B)));
          Label2.Caption := FormatFloat('0.'+Replicate('0',iCasas), StrToFloat('0'+Limpanumero(AllTrim(dadoPeso.Peso))) / StrtoInt('1'+Replicate('0',iCasas)) );
          Label2.Repaint;
          //
          if (AllTrim(Label2.Caption) <> '0,000') then
          begin
            //
            Mais1ini := TIniFile.Create('PESO.TXT');
            Mais1Ini.WriteString('BALANCA','Peso',Label2.Caption);
            Mais1Ini.Free;
            //
            Sleep(1000);
            Close;
          end else
          begin
            //
            Label1.Caption:='Erro usando protocolo P05B!';
            Label1.Repaint;
            Sleep(1000);
            Timer1.Enabled := True;
            //
          end;
          //
        end else
        begin
          Timer1.Enabled := True;
        end;
      end else
      begin
        Label4.Caption   := 'Modelo: ' + 'Toledo protocolo P05';
        if (PegaPeso(1,Peso,'c:\') = 1) then
        begin
          //
          Label2.Caption := FormatFloat('0.'+Replicate('0',iCasas), StrToFloat('0'+Limpanumero(AllTrim(StrPas(Peso)))) / StrtoInt('1'+Replicate('0',iCasas)) );
          //
          if (AllTrim(Label2.Caption) <> '0,000') then
          begin
            //
            Label2.Repaint;
            Mais1ini := TIniFile.Create('PESO.TXT');
            Mais1Ini.WriteString('BALANCA','Peso',Label2.Caption);
            Mais1Ini.Free;
            //
            Sleep(1000);
            Close;
            //
          end else
          begin
            Label1.Caption:='Erro usando protocolo P05!';
            Label1.Repaint;
            Sleep(1000);
            Timer1.Enabled := True;
          end;
        end else
        begin
          Timer1.Enabled := True;
        end;
      end;
      //
      Label1.Repaint;
      //
    except ShowMessage('Erro de retorno na balança toledo...') end;
    //
  end
  else if sMarca = 'URANO' then
  begin
    Label1.Caption := 'Aguarde...';
    Label2.Caption := '0,000';

    try
      Urano.FechaPortaSerial;

      //----------------------------------------------
      // Inicio da Defição do Modelo da Balança
      if sModelo = 'URANO 10 ou 11' then
        Urano.AlteraModeloBalanca(0)
      else if sModelo = 'URANO 6' then
        Urano.AlteraModeloBalanca(1)
      else if sModelo = 'URANO 12 Ou UDC POP' then
        Urano.AlteraModeloBalanca(2)
      else if sModelo = 'US POP' then
        Urano.AlteraModeloBalanca(3)
      else if sModelo = 'CP POP L0' then
        Urano.AlteraModeloBalanca(4)
      else if sModelo = 'URANO CP POP1' then
        Urano.AlteraModeloBalanca(5)
      else if sModelo = 'URANO C' then
        Urano.AlteraModeloBalanca(6);
      // Fim da Defição do Modelo da Balança
      //----------------------------------------------

      {
      Não funciona definindo modo operação
      //----------------------------------------------
      // Inicio Modo de Operação
      if mbalanca = 'Computador Requisita' then
       _AlteraModoOperacao(0)
      else if mbalanca = 'Pressionar tecla I' then
        _AlteraModoOperacao(1);
      // Fim Modo de Operação
      //----------------------------------------------
      }

      if Urano.AbrePortaSerial(sPorta) > 0 then
      begin
        try
          SetLength(sPesoUrano, 69);
          sPesoUrano := Urano.LePeso();
        except
        end;

        {
        sPesoUrano := AnsiUpperCase(sPesoUrano);
        if Pos('*PESO:', sPesoUrano) > 0 then
        begin
          // Tratamento para evitar problema quando usar tara
          sPesoUrano := Trim(StringReplace(sPesoUrano, '*PESO:', '', [rfReplaceAll]));
          if Copy(sPesoUrano, 1, 1) = '-' then // Peso negativo
          begin
            sPesoUrano := '0';
          end
          else
          begin
            sPesoUrano := LimpaNumero(sPesoUrano);
          end;
        end;
        }

        if Pos('-', sPesoUrano) > 0 then
        begin
          // Tratamento para evitar problema quando usar tara, peso retorna negativo
          sPesoUrano := '0';
        end;
        
        if Urano.sPeso1 = '' then
          Urano.sPeso1 := sPesoUrano
        else if Urano.sPeso2 = '' then
          Urano.sPeso2 := sPesoUrano;

        //Label2.Caption := FormatFloat('0.'+Replicate('0',iCasas), StrToFloat('0'+Limpanumero(AllTrim(StrPas(Peso)))) / StrtoInt('1'+Replicate('0',iCasas)) );
        Label2.Caption := FormatFloat('0.'+Replicate('0',iCasas), StrToFloat('0'+Limpanumero(AllTrim(sPesoUrano))) / StrtoInt('1'+Replicate('0',iCasas)) );
        //
        // 2015-12-08 if (AllTrim(Label2.Caption) <> '0,000') then
        if (Urano.sPeso1 <> '') and (Urano.sPeso2 <> '') then
        begin
          if (AllTrim(Label2.Caption) <> '0,000')  and (Urano.sPeso1 = sPesoUrano) and (sPesoUrano = Urano.sPeso2)then
          //Transcorrido o tempo máximo (timeout) para efetuar a leitura do peso, essa string é preenchida com asteriscos (*).
          //if (Pos('*********', AllTrim(Label2.Caption)) > 0) then
          begin
            //
            Label2.Repaint;
            Timer1.Enabled := False;
            Mais1ini := TIniFile.Create('PESO.TXT');
            Mais1Ini.WriteString('BALANCA','Peso',Label2.Caption);
            Mais1Ini.Free;
            //  
            Sleep(1000);
            Close;
            //
          end
          else
          begin
            Urano.sPeso1 := '';
            Urano.sPeso2 := '';
          end;
        end;

      end;// if Urano.AbrePortaSerial(sPorta) > 0 then
    except
      ShowMessage('Erro de retorno na balança URANO...')
    end;
  end else
  begin
    //
    Label1.Caption := 'Aguarde...';
    Label2.Caption := '0,000';
    //
    status := StrToInt(FloatToStr(ObtemInformacao(0,0)));
    case status of
      0:  Label1.Caption := 'Status: Falha na comunicação com a balança.';
      1:  Label1.Caption := 'Status: Peso Oscilando.';
      2:  Label1.Caption := 'Status: Peso Estável.';
      3:  Label1.Caption := 'Status: Sobrecarga de Peso ou Alivio de Plataforma.';
      4:  Label1.Caption := 'Status: Erro lendo licensa do Software.';
    end;
    //
    if ( status = 1 ) or ( status = 2 ) then
    begin
      Label2.Caption := FormatFloat('0.000', ObtemInformacao(0,1) / iDivisor * iMultiplicador);
    end;
    //
    if (AllTrim(Label1.Caption) = 'Status: Peso Estável.') and (AllTrim(Label2.Caption) <> '0,000') then
    begin
      //
//      ShowMessage(FloatToStr(ObtemInformacao(0,1)));
      //
      Label2.Repaint;
      Timer1.Enabled := False;
      Mais1ini := TIniFile.Create('PESO.TXT');
      Mais1Ini.WriteString('BALANCA','Peso',Label2.Caption);
      Mais1Ini.Free;
      //
      Sleep(1000);
      Close;
      //
    end;
    //
  end;
  //
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  // ObtemConfiguracoes;
end;

procedure TForm1.FormActivate(Sender: TObject);
var
  Mais1Ini : TIniFile;
begin
  //
  CHDir('c:\windows');
  //
  Mais1ini := TIniFile.Create('BALANCA.INI');
  sMarca   := Mais1Ini.ReadString('BALANCA','MARCA','?');
  //
  if sMarca = 'URANO' then
  begin
    // Sandro Silva 2015-12-03
    sPorta         := Mais1ini.ReadString('URANO','Porta','');
    sTipo          := Mais1ini.ReadString('URANO','Tipo','1');
    sModelo        := Mais1ini.ReadString('URANO','Modelo','URANO 12 Ou UDC POP');
    iCasas         := Mais1ini.ReadInteger('URANO','Casas',3);
    iSegundos      := Mais1ini.ReadInteger('URANO','Time out',15);
    iBaudRate      := Mais1ini.ReadInteger('URANO','BaudRate',0);
    iParidade      := Mais1ini.ReadInteger('URANO','Paridade',2);
    iDataBits      := Mais1ini.ReadInteger('URANO','DataBits',0);
  end
  else
  begin
    sPorta         := Mais1ini.ReadString('TOLEDO','Porta','');
    sTipo          := Mais1ini.ReadString('TOLEDO','Tipo','1');
    sModelo        := Mais1ini.ReadString('TOLEDO','Modelo','Balança Computadora Eletrônica modelo Prix III');
    iCasas         := Mais1ini.ReadInteger('TOLEDO','Casas',3);
    iSegundos      := Mais1ini.ReadInteger('TOLEDO','Time out',15);
    iBaudRate      := Mais1ini.ReadInteger('TOLEDO','BaudRate',0);
    iParidade      := Mais1ini.ReadInteger('TOLEDO','Paridade',2);
    iDataBits      := Mais1ini.ReadInteger('TOLEDO','DataBits',0);
  end;
  iDivisor       := Mais1ini.ReadInteger('FILIZOLA','Divisor',1);
  iMultiplicador := Mais1ini.ReadInteger('FILIZOLA','Multiplicador',1);
  //
  Mais1ini.Free;
  //
  Form1.Width  := 500;
  Form1.Height := 200;
  //
  Label1.Caption := 'Tentando comunicação...';
  Label2.Caption := '0,000';
  //
  if sMarca <> '?' then
  begin
    if sMarca = 'URANO' then
    begin
      // Sandro Silva 2015-12-03
      Label4.Caption   := 'Modelo: ' + sModelo;
      Label5.Caption   := 'Porta: ' + sPorta;

      if Urano = nil then
      begin
        Urano := TBalancaUrano.Create(Application);
      end;

      //ShowMessage('Teste 01 Fechar porta');
      //Urano.FechaPortaSerial;
      //Sleep(1000);

      //ShowMessage('Teste 01 define modelo e tipo de comunicação');
      //Urano.Conectar(sPorta, sModelo);

      //ShowMessage('Teste 01 abre porta');

      if Urano.AbrePortaSerial(sPorta) < 1 then
      begin
        //
        ShowMessage('Erro ao abrir a porta serial '+sPorta);
        //
        Halt(1);
        Halt(1);
        //
      end
      else
      begin
        //ShowMessage('Teste 01 Abriu a porta');
        //Timer1.Interval := 2500;
        Timer1.Enabled := True;
        //Timer1Timer(Self);
      end;
    end
    else
    begin
      //
      if AbrePorta(StrtoInt(Copy(sPorta,4,1)),iBaudRate,iDataBits,iParidade) = 1 then
      begin
        Timer1.Enabled := True;
      end else
      begin
        //
        ShowMessage('Erro ao abrir a porta serial '+sPorta);
        //
        Halt(1);
        Halt(1);
        //
      end;
    end;
    //
  end else
  begin
    //
    if ParamCount = 1 then PopUpMenu1.Popup(Form1.Left,Form1.Top);
    //
    //
    if InicializaLeitura(0) then Timer1.Enabled := True;
      //    //
      //    if not Timer1.Enabled then
      //    begin
      //      ConfiguraBalanca(0, Self.Handle);
      //      if InicializaLeitura(0) then Timer1.Enabled := True;
      //    end;
    //
    if ObtemParametrosBalanca(0, @Modelo, @Porta, @BaudRate) then
    begin
      //
      ObtemNomeBalanca(Modelo, CModelo);
      //
      Label4.Caption   := 'Modelo: ' + CModelo;
      Label5.Caption   := 'Porta: COM' + IntToStr(Porta);
      Label6.Caption   := 'Velocidade: ' + IntToStr(BaudRate);
      //
    end;
  end;
  //
  //
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  //
  // ConfiguraBalanca(0, Self.Handle);
  //
end;

procedure TForm1.Image1DblClick(Sender: TObject);
var
  Mais1Ini : TIniFile;
begin
  //
  Timer1.Enabled := False;
  Mais1ini := TIniFile.Create('PESO.TXT');
  Mais1Ini.WriteString('BALANCA','Peso',Label2.Caption);
  Mais1Ini.Free;
  //
  Close;
  //
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if sMarca = 'TOLEDO' then
  begin
    FechaPorta();
    FechaPortaP05();
  end;
end;

procedure TForm1.Configuraroutrasbalanas1Click(Sender: TObject);
var
  Mais1ini : TIniFile;
begin
  //
  Timer1.Enabled := False;
  Mais1ini := TIniFile.Create('BALANCA.INI');
  Mais1ini.WriteString('BALANCA','MARCA','?');
  Mais1ini.Free;
  //
  ConfiguraBalanca(0, Self.Handle);
  //
  Form1.FormActivate(Sender);
  Timer1.Enabled := True;
  //
end;

procedure TForm1.ConfigurarbalanasTOLEDO1Click(Sender: TObject);
var
  Mais1ini : TIniFile;
begin
  //
  Mais1ini := TIniFile.Create('BALANCA.INI');
  Mais1ini.WriteString('BALANCA','MARCA','TOLEDO');
  Mais1ini.Free;
  //
  Timer1.Enabled := False;
  Form2.ShowModal;
  Timer1.Enabled := True;
  //
  //  ShellExecute( 0, 'Open', 'NOTEPAD.EXE','BALANCA.INI', '', SW_SHOW);
  //
end;

procedure TForm1.Fecharoprograma1Click(Sender: TObject);
var
  Mais1Ini : TIniFile;
begin
  //
  Timer1.Enabled := False;
  Mais1ini := TIniFile.Create('PESO.TXT');
  Mais1Ini.WriteString('BALANCA','Peso',Label2.Caption);
  Mais1Ini.Free;
  //
  Close;
  Halt(1);
  Halt(1);
  //
end;

procedure TForm1.PopupMenu1Change(Sender: TObject; Source: TMenuItem;
  Rebuild: Boolean);
begin
  Timer1.Enabled := False;
end;

procedure TForm1.Multiplicador1Click(Sender: TObject);
var
  sValor : String;
  Mais1ini : TIniFile;
begin
  //
  sValor    := InputBox('Multiplicador','Multiplicar o resultado por',sValor);
  sValor    := LimpaNumeroDeixandoaVirgula(sValor);
  if Alltrim(sValor)='' then sValor := '1';
  //
  Mais1ini := TIniFile.Create('BALANCA.INI');
  Mais1ini.WriteString('FILIZOLA','Multiplicador',sValor);
  Mais1ini.Free;
  //
end;

procedure TForm1.Divisor1Click(Sender: TObject);
var
  sValor : String;
  Mais1ini : TIniFile;
begin
  //
  sValor    := InputBox('Divisor','Dividir o resultado por',sValor);
  sValor    := LimpaNumeroDeixandoaVirgula(sValor);
  if Alltrim(sValor)='' then sValor := '1';
  //
  Mais1ini := TIniFile.Create('BALANCA.INI');
  Mais1ini.WriteString('FILIZOLA','Multiplicador',sValor);
  Mais1ini.Free;
  //


end;

procedure TForm1.ConfigurarbalanasURANO1Click(Sender: TObject);
var
  Mais1ini : TIniFile;
begin
  // Sandro Silva 2015-12-03
  //
  Mais1ini := TIniFile.Create('BALANCA.INI');
  Mais1ini.WriteString('BALANCA','MARCA','URANO');
  Mais1ini.Free;
  //
  Timer1.Enabled := False;
  Form3.ShowModal;
  Urano.FechaPortaSerial;

  Timer1.Enabled := True;
end;

{ TBalancaUrano }

procedure TBalancaUrano.CarregaDLL;
begin
  // Sandro Silva 2015-12-03
  try
    DLL := LoadLibrary(PChar('LePeso.dll')); //carregando dll
    if DLL = 0 then
      raise Exception.Create('Não foi possível carregar a biblioteca LePeso.dll');

    Import(@AbrePortaSerial, '_AbrePortaSerial');
    Import(@FechaPortaSerial, '_FechaPortaSerial');
    Import(@AlteraModeloBalanca, '_AlteraModeloBalanca');
    Import(@AlteraModoOperacao, '_AlteraModoOperacao');
    Import(@LePeso, '_LePeso');
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao carregar comandos para ler o peso' + #13 + E.Message);
    end;
  end;
end;

constructor TBalancaUrano.Create(AOwner: TComponent);
begin
  // Sandro Silva 2015-12-03
  inherited;
  CarregaDLL;
end;

destructor TBalancaUrano.Destroy;
begin
  // Sandro Silva 2015-12-03
  FinalizaDLL;
  inherited;
end;

procedure TBalancaUrano.FinalizaDLL;
begin
  // Sandro Silva 2015-12-03
  AbrePortaSerial     := nil;
  FechaPortaSerial    := nil;
  AlteraModeloBalanca := nil;
  AlteraModoOperacao  := nil;
  LePeso              := nil;
end;

procedure TBalancaUrano.Import(var Proc: pointer; Name: Pchar);
begin
  // Sandro Silva 2015-12-03
  if not Assigned(Proc) then
  begin
    Proc := GetProcAddress(DLL, Pchar(Name));
    if Proc = nil then
      raise Exception.Create('Não foi possível carregar a função ' + Name + ' da biblioteca LePeso.dll');
  end;
end;

end.

