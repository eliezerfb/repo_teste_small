program frente;

{$R 'smallmanifest.res' 'smallmanifest.rc'}

uses
  Forms,
  Windows,
  Messages,
  SysUtils,
  Dialogs,
  SMALL_DBEDIT in '..\..\componentes\Smallsoft\SMALL_DBEDIT.pas',
  Unit22 in 'Unit22.pas' {Form22},
  FISCAL in 'FISCAL.PAS' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  Unit3 in 'Unit3.pas' {Form3},
  Unit4 in 'Unit4.pas' {Form4},
  Unit7 in 'Unit7.pas' {Form7},
  Unit10 in 'Unit10.pas' {Form10},
  Unit13 in 'Unit13.pas' {Form13},
  Unit6 in 'Unit6.pas' {Form6},
  formas in 'formas.pas' {FormasP},
  Unit8 in 'Unit8.pas' {Form8},
  UNIT9 in 'UNIT9.PAS' {Form9},
  Unit11 in 'Unit11.pas' {Form11},
  frame_teclado_1 in 'frame_teclado_1.pas' {Frame_teclado: TFrame},
  Unit12 in 'Unit12.pas' {Form12},
  Unit14 in 'Unit14.pas' {Form14},
  Unit15 in 'Unit15.pas' {Form15},
  SelecionaCertificado in 'SelecionaCertificado.pas' {frmSelectCertificate},
  udadospos in 'udadospos.pas' {FDadosPOS},
  ucadadquirentes in 'ucadadquirentes.pas' {FCadAdquirentes},
  uclassetransacaocartao in 'uclassetransacaocartao.pas',
  Unit27 in 'Unit27.pas' {Form27},
  uimpressaopdf in 'uimpressaopdf.pas',
  AJBarcode in 'AJBarcode.pas',
  _Small_IntegradorFiscal in '_Small_IntegradorFiscal.pas',
  ufuncoesfrente in 'ufuncoesfrente.pas',
  upesquisaparaimportar in 'upesquisaparaimportar.pas' {FPesquisaParaImportar},
  uatualizaestruturadb in 'uatualizaestruturadb.pas',
  ufuncoesfrentepaf in 'ufuncoesfrentepaf.pas',
  urequisitospafnfce in 'urequisitospafnfce.pas',
  upromocoesscanntech in 'upromocoesscanntech.pas',
  umontaxmlvendasat in 'umontaxmlvendasat.pas',
  uregistrosdopafecf in 'uregistrosdopafecf.pas',
  upafecfmenufiscal in 'upafecfmenufiscal.pas',
  urelatoriosgerenciais in 'urelatoriosgerenciais.pas',
  ufuncoestef in 'ufuncoestef.pas',
  usincronizamobile in 'usincronizamobile.pas',
  uconstantes_chaves_privadas in '..\..\uconstantes_chaves_privadas.pas',
  upafnfce in 'upafnfce.pas',
  ucredencialtecnospeed in '..\..\componentes\Smallsoft\ucredencialtecnospeed.pas',
  uTypesRecursos in '..\unit_compartilhada\uTypesRecursos.pas',
  uValidaRecursosDelphi7 in '..\unit_compartilhada\uValidaRecursosDelphi7.pas',
  uRecursosSistema in '..\unit_compartilhada\uRecursosSistema.pas',
  uCriptografia in '..\unit_compartilhada\uCriptografia.pas',
  uFuncoesPOS in 'uFuncoesPOS.pas',
  uConverteDocumentoParaDocFiscal in 'uConverteDocumentoParaDocFiscal.pas',
  _Small_2 in '_Small_2.pas',
  _Small_3 in '_Small_3.pas',
  _Small_12 in '_Small_12.pas',
  _Small_14 in '_Small_14.pas',
  _Small_15 in '_Small_15.pas',
  _Small_17 in '_Small_17.pas',
  _Small_59 in '_Small_59.pas',
  _small_65 in '_small_65.pas',
  _small_99 in '_small_99.pas',
  uConfiguracaoTEF in 'uConfiguracaoTEF.pas' {FConfiguracaoTEF},
  uSmallConsts in '..\unit_compartilhada\uSmallConsts.pas',
  ufrmEditaMovimento in 'ufrmEditaMovimento.pas' {FEditaMovimento},
  uSmallEnumerados in '..\unit_compartilhada\uSmallEnumerados.pas',
  uframeCampoCaixasRelatorio in 'uframeCampoCaixasRelatorio.pas' {frameCampoCaixasRel: TFrame},
  smallfunc_xe in '..\unit_compartilhada\smallfunc_xe.pas',
  uConectaBancoSmall in '..\unit_compartilhada\uConectaBancoSmall.pas',
  uDialogs in '..\unit_compartilhada\uDialogs.pas',
  md5_unicode in '..\unit_compartilhada\md5_unicode.pas',
  uFuncaoMD5 in '..\unit_compartilhada\uFuncaoMD5.pas',
  usmallsat in 'usmallsat.pas',
  uEmail in '..\unit_compartilhada\uEmail.pas',
  uITestaEmail in '..\unit_compartilhada\interfaces\uITestaEmail.pas',
  uTestaEmail in '..\unit_compartilhada\uTestaEmail.pas',
  CAPICOM_TLB_xe in '..\unit_compartilhada\CAPICOM_TLB_xe.pas',
  uValidaRecursos in '..\unit_compartilhada\uValidaRecursos.pas',
  ufrmQRCodePixEst in 'ufrmQRCodePixEst.pas' {FrmQRCodePixEst},
  ufrmSelecionarPIX in 'ufrmSelecionarPIX.pas' {FrmSelecionarPIX},
  uPagamentoPix in 'uPagamentoPix.pas',
  uQrCode in '..\unit_compartilhada\uQrCode.pas',
  uajustaresolucao in 'uajustaresolucao.pas',
  uIntegracaoItau in '..\unit_compartilhada\Itau\uIntegracaoItau.pas',
  uClassesItau in '..\unit_compartilhada\Itau\uClassesItau.pas',
  uWebServiceItau in '..\unit_compartilhada\Itau\uWebServiceItau.pas',
  uFrmTransacoesItau in 'uFrmTransacoesItau.pas' {FrmTransacoesItau};

{$R *.RES}

procedure ECFConvenio0909;
//Sandro Silva 2015-11-10 Quando tem 2 ECF e cada ECF precisa de um configuração específica
var
  sCaminho: String;
  sAtualOnLine: String;
begin
  sCaminho := ExtractFilePath(Application.ExeName);
  Getdir(0, sAtualOnLine);

  if FileExists(sAtualOnLine+'\small.ini') and not FileExists(PChar(sCaminho + 'offline.fdb')) then // Sandro Silva 2019-03-15 if FileExists(sAtualOnLine+'\small.ini') and not FileExists(PChar(sCaminho + 'offline' + EXTENSAO_BANCO)) then
  begin
    // Online
  end
  else
  begin
    // Offline

    // ECF DARUMA e BEMATECH, convênio 09/09, usam configurações diferentes.
    // Sempre usar arquivo de configuração local

    // Destino do atalho
    try

      if DeleteFile(PChar(sAtualOnLine + '\Bemafi32.ini')) then
        Sleep(500);

    except
    end;

    try
      if CopyFile(PChar(sCaminho + 'darumaframework.xml'), PChar(sAtualOnLine + '\darumaframework.xml'), False) then
        Sleep(500);
    except
    end;

  end;
end;

var
  Hwnd: THandle;
  sExeName: String;
begin
  try
    ECFConvenio0909;
  except

  end;
  //
  Hwnd := FindWindow('TForm1', 'Programa Aplicativo Fiscal (PAF-ECF)');

  sExeName := AnsiLowerCase(ExtractFileName(Application.ExeName));

  if (sExeName = 'gerencial.exe') or (sExeName = 'pafnfce.exe') or (sExeName = 'nfce.exe') or (sExeName = 'cfesat.exe') then // Sandro Silva 2023-07-28 if (sExeName = 'nfce.exe') or (sExeName = 'cfesat.exe') then
  begin
    if (sExeName = 'gerencial.exe') then
    begin
      Hwnd := FindWindow ('TForm1', 'Aplicativo Gerencial');
      FecharAplicacao('nfce.exe');
      FecharAplicacao('cfesat.exe');
      FecharAplicacao('mei.exe');
      FecharAplicacao('pafnfce.exe');
    end;

    if (sExeName = 'pafnfce.exe') then
    begin
      Hwnd := FindWindow ('TForm1', 'Aplicativo emissor NFC-e');
      FecharAplicacao('nfce.exe');
      FecharAplicacao('cfesat.exe');
      FecharAplicacao('mei.exe');
      FecharAplicacao('gerencial.exe');
    end;

    if (sExeName = 'nfce.exe') then
    begin
      Hwnd := FindWindow ('TForm1', 'Aplicativo emissor NFC-e');
      FecharAplicacao('pafnfce.exe');
      FecharAplicacao('cfesat.exe');
      FecharAplicacao('mei.exe');
      FecharAplicacao('gerencial.exe');
    end;

    if (sExeName = 'cfesat.exe') then
    begin
      Hwnd := FindWindow ('TForm1', 'Aplicativo emissor CF-e'); // Sandro Silva 2018-08-01 Hwnd := FindWindow ('TForm1', 'Aplicativo emissor CF-e-SAT');
      FecharAplicacao('nfce.exe');
      FecharAplicacao('pafnfce.exe');
      FecharAplicacao('mei.exe');
      FecharAplicacao('gerencial.exe');
    end;
    //    FecharAplicacao('pafnfce.exe');
    FecharAplicacao('frente.exe');
    //FecharAplicacao('mei.exe');
    //FecharAplicacao('gerencial.exe'); // Sandro Silva 2023-06-23
  end;

  {Sandro Silva 2023-07-28 inicio
  if (PAFNFCe) then
  begin
    Hwnd := FindWindow ('TForm1', 'Aplicativo emissor NFC-e (PAF-NFC-e)');
  end;
  }
  
  if Hwnd = 0 then
  begin
    //
    Form22 := TForm22.Create(Application);
    Form22.Inicio := Time;
    Form22.Show;
    Form22.Update;
    //

    {Sandro Silva 2021-05-20 inicio}
    if LerParametroIni('FRENTE.INI', 'Contingencia', 'Caixa Online', '') <> '' then
    begin
      //Se fechou app estando em contingência, ao abrir acerta dados para sempre iniciar em modo normal (não contingência)
      GravarParametroIni('FRENTE.INI', 'Frente de caixa', 'Caixa', LerParametroIni('FRENTE.INI', 'Contingencia', 'Caixa Online', ''));
      // Sandro Silva 2023-07-18 GravarParametroIni('FRENTE.INI', 'Frente de caixa', 'Tipo Documento', LerParametroIni('FRENTE.INI', 'Contingencia', 'Tipo Documento Online', ''));
      
      GravarParametroIni('FRENTE.INI', 'Contingencia', 'Tipo Documento Online', '');
      GravarParametroIni('FRENTE.INI', 'Contingencia', 'Caixa Online', '');
    end;
    {Sandro Silva 2021-05-20 fim}                                                                                        

    Application.Initialize;
    Application.Title    := 'Programa Aplicativo Fiscal (PAF-ECF)';
    {Sandro Silva 2023-07-18 inicio
    if (PAFNFCe) then
    begin
      Application.Title := 'Aplicativo emissor NFC-e (PAF-NFC-e)';
    end;
    }
    if (sExeName = 'nfce.exe') or (NFCe) then // if sExeName = 'nfce.exe' then
    begin
      Application.Title := 'Aplicativo emissor NFC-e';
    end;

    if (sExeName = 'pafnfce.exe') or (NFCe) then // if sExeName = 'nfce.exe' then
    begin
      Application.Title := 'Aplicativo emissor PAF-NFC-e';
    end;

    if (sExeName = 'cfesat.exe') or (SAT) or (MFE) then // Sandro Silva 2021-03-19 if sExeName = 'cfesat.exe' then
    begin
      Application.Title := 'Aplicativo emissor de CF-e';
    end;

    {Sandro Silva 2023-06-23 inicio
    if (sExeName = 'mei.exe') or (MEI) then // Sandro Silva 2021-03- if sExeName = 'mei.exe' then
    begin
      Application.Title := 'Aplicativo MEI';
    end;
    }   
    if (sExeName = 'gerencial.exe') or (Gerencial) then
    begin
      Application.Title := 'Aplicativo Gerencial';
    end;
    {Sandro Silva 2023-06-23 fim}

    Application.HelpFile := '';
    Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm10, Form10);
  Application.CreateForm(TForm13, Form13);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TFormasP, FormasP);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TForm9, Form9);
  Application.CreateForm(TForm11, Form11);
  Application.CreateForm(TForm12, Form12);
  Application.CreateForm(TForm14, Form14);
  Application.CreateForm(TForm15, Form15);
  Application.CreateForm(TfrmSelectCertificate, frmSelectCertificate);
  Application.CreateForm(TFDadosPOS, FDadosPOS);
  Application.CreateForm(TFCadAdquirentes, FCadAdquirentes);
  Application.CreateForm(TForm27, Form27);
  Application.Run;
    //
  end else
  begin
    if not IsWindowVisible (Hwnd) then
      PostMessage(Hwnd, wm_User, 0, 0);
    SetForegroundWindow(Hwnd);
  end;
end.
