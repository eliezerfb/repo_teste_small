unit ublocox_unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs
  , IniFiles
  , Smallfunc
  , ufuncoesfrente
  , ufuncoesfrentepaf
  , StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    sAtual: String;
    sCaminhoBanco: String;
    bBlocoxRZPendente: Boolean;
    bBlocoxEstoquePendente: Boolean;
    sCNPJEmitente: String;
    sUFEmitente: String;
    bRetaguarda: Boolean; // Sandro Silva 2019-09-09 ER 02.06 UnoChapeco
    procedure ProcessaDadosDoEstoque(sCNPJ: String);
    procedure ProcessaDadosDaReducaoZ(sCNPJ: String);
    function CaminhoBancoDeDados: String;
    function BlocoxConsultarRecibo1: Boolean;
    function BlocoxTransmitirPendente1(sTipo: String; sSerieECF: String;
      bAlerta: Boolean = True): Integer;
    function BlocoXAlertarPendente1(sTipo: String; sSerieECF: String;
      bExibirAlerta: Boolean; bRetaguarda: Boolean = False): String;
    function BlocoXServidorConfigurado1: Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses uconstantes_chaves_privadas;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  bRetaguarda := False;
  _BlocoX := TSmallBlocoX.Create(Application);
  sAtual := ExtractFileDir(Application.ExeName);
  sCaminhoBanco := CaminhoBancoDeDados;
  BringToFront;
end;

function TForm1.CaminhoBancoDeDados: String;
var
  Mais1Ini: TIniFile;
  Url: String;
  IP: String;
  Alias: String;
begin
  Mais1Ini := TIniFile.Create(Form1.sAtual+'\small.ini');
  Url      := Mais1Ini.ReadString('Firebird','Server url','');
  IP       := AllTrim(Mais1Ini.ReadString('Firebird','Server IP',''));
  Alias    := AllTrim(Mais1Ini.ReadString('Firebird','Alias',''));

  //LogFrente('Teste 01: IP ' + Form1.sAtual+'\small.ini' + ' ' + ip);

  //
  if IP = '' then IP := GetIp;

  //LogFrente('Teste 01: depois getip ' + ' ' + ip);

  //
  if IP <> '' then
    Url := IP+':'+Url+'\small.fdb' // Sandro Silva 2019-03-15 Url := IP+':'+Url+'\small' + EXTENSAO_BANCO
  else
    Url:= Url+'\small.fdb'; // Sandro Silva 2019-03-15 Url:= Url+'\small' + EXTENSAO_BANCO;
  //
  if Alltrim(Alias) <> '' then
  begin
    Url := IP+':'+Alias;
  end;
  //
  Mais1Ini.Free;
  Result := Url;
end;

procedure TForm1.ProcessaDadosDoEstoque(sCNPJ: String);
var
  bOK: Boolean;
begin
  bOk := True;
  if _BlocoX.ValidaCertificadoDigital(LimpaNumero(sCNPJ)) = False then // Sandro Silva 2018-10-18 if _BlocoX.ValidaCertificadoDigital(Form1.IBDatabase1.DatabaseName, Form1.sAtual) = False then
  begin
    Application.ProcessMessages;
    Application.BringToFront;

    bOk := False;
  end;

  if bOk then
  begin
    //_BlocoX.IdentificaRetornosComErroTratandoTodos(PAnsiChar(IBDatabase1.DatabaseName), PAnsiChar(Form1.sAtual), PAnsiChar('ESTOQUE'));
    _BlocoX.IdentificaRetornosComErroTratandoTodos(PAnsiChar(sCaminhoBanco), PAnsiChar(Form1.sAtual), PAnsiChar('ESTOQUE'));

    Label1.Caption := 'Aguarde... REQUISITO LIX - Consultando';
    Form1.BlocoxConsultarRecibo1;

    //ShowMessage('Teste 01 46790'); // Sandro Silva 2018-11-27

    Label1.Caption := 'Aguarde... REQUISITO LIX - Enviando os XML';
    BlocoxTransmitirPendente1('ESTOQUE', ''); // Sandro Silva 2017-03-21

  end;
  BlocoXAlertarPendente1('ESTOQUE', '', True);// Sandro Silva 2017-11-08 Polimig  BlocoXAlertarPendente('', Form1.sNumeroDeSerieDaImpressora, True);

end;

function TForm1.BlocoxConsultarRecibo1: Boolean;
begin
  Result := False; // Sandro Silva 2018-06-28
  //if (Form1.sModeloECF <> '59') and (Form1.sModeloECF <> '65') then
  //begin
    if BlocoXServidorConfigurado1 then
    begin
      _BlocoX.ConsultarRecibo(PAnsiChar(sCaminhoBanco), PAnsiChar(Form1.sAtual), '');
    end;

    ChDir(Form1.sAtual); // Sandro Silva 2017-03-31
    Result := True; // Sandro Silva 2018-06-28
  //end; // if (Form1.sModeloECF <> '59') and (Form1.sModeloECF <> '65') then
end;

function TForm1.BlocoxTransmitirPendente1(sTipo, sSerieECF: String;
  bAlerta: Boolean): Integer;
begin
  Result := 0; // Sandro Silva 2017-05-20
  //if (Form1.sModeloECF <> '59') and (Form1.sModeloECF <> '65') then
  //begin
    if BlocoXServidorConfigurado1 then
    begin
      _BlocoX.TransmitirXmlPendente(sCaminhoBanco, Form1.sAtual, sTipo, sSerieECF, bAlerta);
    end;

    ChDir(Form1.sAtual); // Sandro Silva 2017-03-31
  //end;
end;

function TForm1.BlocoXAlertarPendente1(sTipo, sSerieECF: String;
  bExibirAlerta: Boolean; bRetaguarda: Boolean = False): String;
var
  bXmlPendente: Boolean;
begin
  try

    if (sTipo = 'REDUCAO') or (sTipo = '') then
    begin

      if (Copy(PerfilPAF(CHAVE_CIFRAR),1,1) = 'T') then // Sandro Silva 2019-06-25 ER 02.06 if (Copy(Form1.sPerfil,1,1) = 'T') or (Copy(Form1.sPerfil,1,1) = 'U') then // Sandro Silva 2017-11-10 Polimig
      begin
        bBlocoxRZPendente := False;
      end
      else
      begin
        bXmlPendente := _BlocoX.AlertaXmlPendente(sCaminhoBanco, Form1.sAtual, 'REDUCAO', sSerieECF, bExibirAlerta, bRetaguarda);
        bBlocoxRZPendente := bXmlPendente;
      end;

    end;

    if (sTipo = 'ESTOQUE') or (sTipo = '') then
    begin
      bXmlPendente := _BlocoX.AlertaXmlPendente(sCaminhoBanco, Form1.sAtual, 'ESTOQUE', sSerieECF, bExibirAlerta, bRetaguarda);
      bBlocoxEstoquePendente := bXmlPendente;
    end;

  except

  end;

  ChDir(Form1.sAtual); // Sandro Silva 2017-03-31
end;

function TForm1.BlocoXServidorConfigurado1: Boolean;
begin
  Result := False; // Sandro Silva 2017-05-20
  try
    Result := _BlocoX.ServidorSefazConfigurado(sUFEmitente);
  except
    Result := False;
  end;
  ChDir(Form1.sAtual); // Sandro Silva 2017-03-31
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  try
    if ParamCount = 3 then
      bRetaguarda := True;
    if ParamCount >= 3 then
    begin
      sCNPJEmitente := ParamStr(1);
      sUFEmitente   := ParamStr(2);
      
      if ParamStr(3) = 'ESTOQUE' then
      begin
        ProcessaDadosDoEstoque(sCNPJEmitente);
      end;
      if ParamStr(3) = 'REDUCAO' then
      begin
        ProcessaDadosDaReducaoZ(sCNPJEmitente);
      end;
    end;
  except

  end;
  FreeAndNil(_BlocoX);
  Close;
  FecharAplicacao(ExtractFileName(Application.ExeName));
end;

procedure TForm1.ProcessaDadosDaReducaoZ(sCNPJ: String);
var
  bOk: Boolean;
begin
  Label1.Caption := 'Aguarde... REQUISITO LVIII - Enviando os XML';
  Screen.Cursor := crHourGlass;
  bOk := True;
  if _BlocoX.ValidaCertificadoDigital(LimpaNumero(sCNPJ)) = False then // Sandro Silva 2018-10-18 if _BlocoX.ValidaCertificadoDigital(Form1.IBDatabase1.DatabaseName, Form1.sAtual) = False then
  begin
    Application.ProcessMessages;
    Application.BringToFront;
    bOk := False;
  end;

  if bOk then
  begin
    _BlocoX.IdentificaRetornosComErroTratandoTodos(PAnsiChar(sCaminhoBanco), PAnsiChar(Form1.sAtual), PAnsiChar('REDUCAO'));

    Form1.BlocoxConsultarRecibo1;

    BlocoxTransmitirPendente1('REDUCAO', '', False);
    BlocoxTransmitirPendente1('REDUCAO', '', False); // Sandro Silva 2018-10-11 Transmitir dos demais ECF
  end;
  BlocoXAlertarPendente1('REDUCAO', '', True, bRetaguarda);// Sandro Silva 2017-11-08 Polimig  BlocoXAlertarPendente('', Form1.sNumeroDeSerieDaImpressora, True);

  Screen.Cursor := crDefault;

end;

end.
