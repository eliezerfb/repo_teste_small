unit upafecfmenufiscal;

interface

uses
  SysUtils
  , StrUtils
  , Classes
  , Controls
  , Forms
  , Windows
  , Dialogs
  , ShellApi
  ;

procedure PafEcfLeituraX;
procedure PafEcfLeituraMfCompletaPorData;
procedure PafEcfLeituraMfCompletaPorIntervalodeReducoes;
procedure PafEcfLeituraMfSimplificadaPorData;
procedure PafEcfLeituraMfSimplificadaPorIntervaloReducoes;
procedure PafEcfArquivoAC1704PorCOO;
procedure PafEcfArquivoAC1704PorData;
procedure PafEcfRelatorioGerancialDavEmitido;
procedure PafEcfArquivoEletronicoDavEmitido;
procedure PafEcfAtoCOTEPE0908;
procedure PafEcfConvenio57951;
procedure PAfEcfLeituraMfdPorData;
procedure PafEcfLeituraMfdPorFaixaDeCOO;

implementation

uses
  SmallFunc_xe
  , fiscal
  , _Small_1
  , _Small_2
  , _Small_3
  , _Small_12
  , _Small_14
  , _Small_15
  , _Small_17
  , _Small_59
  , _Small_65
  , _Small_99
  , unit7
  , ufuncoesfrente
  ;

function GravaNaPastaCerta(sAtual: String; sNomeNovo: String): Boolean;
var
  tsListaDeArquivos : TStringList;
  iI : Integer;
begin
  //
  ListaDeArquivos(tsListaDeArquivos, 'c:\');
  //
  for iI := 0 to tsListaDeArquivos.Count - 1 do
  begin
    //
    Application.ProcessMessages;
    //
    if Pos('.TXT', UpperCase('c:\' + Trim(tsListaDeArquivos[iI])))<>0 then // if Pos('.TXT',UpperCase('c:\' + AllTrim(tsListaDeArquivos[iI])))<>0 then
    begin
      //
      if Trim(sNomeNovo) = '' then sNomeNovo := tsListaDeArquivos[iI]; // if AllTrim(sNomeNovo) = '' then sNomeNovo := tsListaDeArquivos[iI];
      //
      CopyFile(pchar('c:\' + Trim(tsListaDeArquivos[iI])), pchar(Form1.sAtual + '\' + Trim(sNomeNovo)), False); // CopyFile(pchar('c:\' + AllTrim(tsListaDeArquivos[iI])),pchar(Form1.sAtual+'\'+AllTrim(sNomeNovo)), False);
      SmallMsg('O arquivo ' + Trim(sNomeNovo)+' foi gravado na pasta: '+Form1.sAtual); // SmallMsg('O arquivo '+AllTrim(sNomeNovo)+' foi gravado na pasta: '+Form1.sAtual);
      DeleteFile(pchar('c:\' + Trim(tsListaDeArquivos[iI]))); // DeleteFile(pchar('c:\' + AllTrim(tsListaDeArquivos[iI])));
    end;
  end;
  //
  Result := True;
  //
end;

procedure PafEcfLeituraX;
var
  bComandoOK: Boolean;
begin
  Form1.sAjuda := 'ecf_cotepe.htm#LX';

  if Form1.sModeloECF = '15' then // tempo para evitar ecf travar
    Sleep(2000); // Sandro Silva 2017-08-25

  Form1.Repaint;
  bComandoOK := False; // Sandro Silva 2016-04-01
  if Form1.sModeloECF = '01' then bComandoOK := _ecf01_LeituraX(True);
  if Form1.sModeloECF = '02' then bComandoOK := _ecf02_LeituraX(True);
  if Form1.sModeloECF = '03' then bComandoOK := _ecf03_LeituraX(True);
  if Form1.sModeloECF = '12' then bComandoOK := _ecf12_LeituraX(True);
  if Form1.sModeloECF = '14' then bComandoOK := _ecf14_LeituraX(True);
  if Form1.sModeloECF = '15' then bComandoOK := _ecf15_LeituraX(True);
  if Form1.sModeloECF = '17' then bComandoOK := _ecf17_LeituraX(True); // Ok 2015-08-24
  if Form1.sModeloECF = '59' then bComandoOK := _ecf59_LeituraX(True);
  if Form1.sModeloECF = '65' then bComandoOK := _ecf65_LeituraX(True);
  if Form1.sModeloECF = '99' then bComandoOK := _ecf99_LeituraX(True);
  {Sandro Silva 2021-07-22 inicio
  if Form1.sModeloECF = '04' then bComandoOK := _ecf04_LeituraX(True);
  if Form1.sModeloECF = '05' then bComandoOK := _ecf05_LeituraX(True);
  if Form1.sModeloECF = '06' then bComandoOK := _ecf06_LeituraX(True);
  if Form1.sModeloECF = '07' then bComandoOK := _ecf07_LeituraX(True);
  if Form1.sModeloECF = '08' then bComandoOK := _ecf08_LeituraX(True);
  if Form1.sModeloECF = '09' then bComandoOK := _ecf09_LeituraX(True);
  if Form1.sModeloECF = '10' then bComandoOK := _ecf10_LeituraX(True);
  if Form1.sModeloECF = '11' then bComandoOK := _ecf11_LeituraX(True);
  }
  //ShowMessage('Teste 01 24791'); // Sandro Silva 2017-08-25

  if Form1.sModeloECF = '15' then // tempo para evitar ecf travar
    Sleep(2000); // Sandro Silva 2017-08-25

  if bComandoOK then
    Form1.Demais('LX'); // 2015-09-18

  ////ShowMessage('Teste 01 24799'); // Sandro Silva 2017-08-25
end;

procedure PafEcfLeituraMfCompletaPorData;
begin
  //
  //
  Form7.CheckBox2.Visible := False;
  Form7.CheckBox2.Checked := False;
  //
  Form1.sTipo := 'c';
  Form7.sMfd  := '0';
  Form7.Label1.Caption          := 'Informe as condições para a leitura da MF ' +
                                   'e clique  <Avançar> para continuar.';
  Form7.DateTimePicker1.Visible := True;
  Form7.DateTimePicker2.Visible := True;
  Form7.MaskEdit1.Visible       := False;
  Form7.MaskEdit2.Visible       := False;
  Form7.Label3.Caption          := 'Data inicial:';
  Form7.Label5.Caption          := 'Data final:';
  Form7.Caption := 'Leitura de memória fiscal completa por data';
  Form7.ShowModal;
  if Form7.ModalResult = mrOK then
  begin
    Form1.Repaint;
    //
    Form1.SaveDialog1.FileName := Form1.sPAstaDoExecutavel+'\LMFC_DATA.TXT';
    Form1.SaveDialog1.FilterIndex := 1;
    //
    if Form7.CheckBox2.Checked then
    begin
      //
      // SmallMsg('Inicio: COTEPE 17/04 por DATA');
      //
  //    if Form1.SaveDialog1.Execute then
      begin
        //
        Form1.Display('Gerando arquivo COTEPE 17/04 - data.','');
        Screen.Cursor             := crHourGlass;    // Cursor de Aguardo
        CHDir(Form1.sAtual);
  //      Deletefile(pChar(Form1.SaveDialog1.FileName));
        Form7.sMfd := '0';
        //
        if Form1.sModeloECF = '59' then _ecf59_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),7,4)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),7,4)   // Ano
                                          );


        if Form1.sModeloECF = '01' then _ecf01_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),7,4)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),7,4)   // Ano
                                          );

        if Form1.sModeloECF = '02' then _ecf02_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),7,4)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),7,4)   // Ano
                                          );

        if Form1.sModeloECF = '03' then _ecf03_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        {Sandro Silva 2021-07-22 inicio 
        if Form1.sModeloECF = '04' then _ecf04_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '05' then _ecf05_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '06' then _ecf06_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '07' then _ecf07_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '08' then _ecf08_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '09' then _ecf09_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '10' then _ecf10_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '11' then _ecf11_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );
        }

        if Form1.sModeloECF = '12' then _ecf12_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '14' then _ecf14_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );


        if Form1.sModeloECF = '15' then _ecf15_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );
        if Form1.sModeloECF = '17' then _ecf17_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );
        if Form1.sModeloECF = '65' then _ecf65_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );
        if Form1.sModeloECF = '99' then _ecf99_LeituraDaMFD('','','');

        CHDir(Form1.sAtual);
        Screen.Cursor             := crDefault;    // Cursor de Aguardo
        //
      end;
      //
      GravaNaPastaCerta('c:\','');
      Form1.Display(Form1.sStatusECF,'');
      //
    end else
    begin
      //
      if Form7.CheckBox1.Checked then
      begin
  //      if Form1.SaveDialog1.Execute then
        begin
          //
          Form1.Display('Aguarde! Obtendo dados do ECF.','');
          Screen.Cursor             := crHourGlass;    // Cursor de Aguardo
          CHDir(Form1.sAtual);
          //
          Deletefile(pChar(Form1.SaveDialog1.FileName));
          //
          if Form1.sModeloECF = '59' then   _ecf59_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,
                                            Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                            ,
                                            Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                            );

          if Form1.sModeloECF = '01' then   _ecf01_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,
                                            Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                            ,
                                            Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                            );

          if Form1.sModeloECF = '02' then   _ecf02_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,
                                            Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                            ,
                                            Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                            );

          if Form1.sModeloECF = '03' then   _ecf03_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,
                                            Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                            ,
                                            Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                            );
          {Sandro Silva 2021-07-22 inicio
          if Form1.sModeloECF = '04' then   _ecf04_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,
                                            Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                            ,
                                            Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                            );

          if Form1.sModeloECF = '05' then   _ecf05_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,
                                            Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                            ,
                                            Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                            );

          if Form1.sModeloECF = '06' then   _ecf06_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,
                                            Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                            ,
                                            Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                            );

          if Form1.sModeloECF = '07' then   _ecf07_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,
                                            Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                            ,
                                            Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                            );

          if Form1.sModeloECF = '08' then   _ecf08_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,
                                            Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                            ,
                                            Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                            );

          if Form1.sModeloECF = '09' then   _ecf09_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,
                                            Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                            ,
                                            Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                            );

          if Form1.sModeloECF = '10' then   _ecf10_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,
                                            Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                            ,
                                            Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                            );

          if Form1.sModeloECF = '11' then   _ecf11_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,
                                            Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                            ,
                                            Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                            );
          }

          if Form1.sModeloECF = '12' then   _ecf12_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,
                                            Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                            ,
                                            Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                            );


          if Form1.sModeloECF = '14' then   _ecf14_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,
                                            Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                            ,
                                            Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                            );


          if Form1.sModeloECF = '15' then   _ecf15_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,
                                            Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                            ,
                                            Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                            );

          if Form1.sModeloECF = '17' then   _ecf17_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,
                                            Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                            ,
                                            Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                            );

          if Form1.sModeloECF = '65' then   _ecf65_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,
                                            Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                            ,
                                            Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                            Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                            Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                            );
          if Form1.sModeloECF = '99' then  _ecf99_leituraMemoriaFiscalEmDisco('', '', '');


          //
          Screen.Cursor             := crDefault;    // Cursor de Aguardo
          //
          if FileExists(Form1.SaveDialog1.FileName) then
          begin
            AssinaturaDigital(pChar(Form1.SaveDialog1.FileName));
          end;
        end;
      end else
      begin
        //
        if Form1.sModeloECF = '59' then _ecf59_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
        ,
        Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
        );


        if Form1.sModeloECF = '01' then _ecf01_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
        ,
        Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
        );

        if Form1.sModeloECF = '02' then _ecf02_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
        ,
        Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
        );

        if Form1.sModeloECF = '03' then _ecf03_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
        ,
        Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
        );

        {Sandro Silva 2021-07-22 inicio 
        if Form1.sModeloECF = '04' then _ecf04_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
        ,
        Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
        );

        if Form1.sModeloECF = '05' then _ecf05_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
        ,
        Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
        );

        if Form1.sModeloECF = '06' then _ecf06_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
        ,
        Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
        );

        if Form1.sModeloECF = '07' then _ecf07_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
        ,
        Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
        );

        if Form1.sModeloECF = '08' then _ecf08_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
        ,
        Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
        );

        if Form1.sModeloECF = '09' then _ecf09_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
        ,
        Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
        );

        if Form1.sModeloECF = '10' then _ecf10_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
        ,
        Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
        );

        if Form1.sModeloECF = '11' then _ecf11_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
        ,
        Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
        );
        }

        if Form1.sModeloECF = '12' then _ecf12_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
        ,
        Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
        );

        if Form1.sModeloECF = '14' then _ecf14_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
        ,
        Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
        );

        if Form1.sModeloECF = '15' then _ecf15_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
        ,
        Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
        );

        if Form1.sModeloECF = '17' then _ecf17_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
           Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
           Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
           ,
           Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
           Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
           Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
           );

        if Form1.sModeloECF = '65' then _ecf65_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
        ,
        Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
        Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
        Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
        );

        if Form1.sModeloECF = '99' then _ecf99_LeituraMemoriaFiscal('', '');

        Form1.Demais('MF');//2015-09-18
      end; // if Form7.CheckBox1.Checked then
    end;
  end;
  //
  Form7.CheckBox1.Visible := False;
  Form7.CheckBox1.Checked := False;

end;

procedure PafEcfLeituraMfCompletaPorIntervalodeReducoes;
begin
  //
  Form7.CheckBox2.Visible := False;
  Form7.CheckBox2.Checked := False;
  //
  Form1.sTipo := 'c';
  Form7.sMfd  := '0';
  Form7.Label1.Caption          := 'Informe as condições para a leitura da MF ' +
                                   'e clique  <Avançar> para continuar.';;
  Form7.DateTimePicker1.Visible := False;
  Form7.DateTimePicker2.Visible := False;
  Form7.MaskEdit1.Visible       := True;
  Form7.MaskEdit2.Visible       := True;
  Form7.Label3.Caption          := 'Redução inicial:';
  Form7.Label5.Caption          := 'Redução final:';
  Form7.MaskEdit1.Width         := 55; // 2015-09-08
  Form7.MaskEdit2.Width         := Form7.MaskEdit1.Width;

  //
  Form7.Caption := 'Leitura de memória fiscal completa por intervalo de redução';
  Form7.ShowModal;
  if Form7.ModalResult = mrOK then
  begin
    Form1.Repaint;
    Form1.SaveDialog1.FileName := Form1.sPAstaDoExecutavel+'\LMFC_CRZ.TXT';
    Form1.SaveDialog1.FilterIndex := 1;
    //
    if Form7.CheckBox2.Checked then
    begin

      Form1.SaveDialog1.FileName := Form1.sPAstaDoExecutavel+'\COTEPE_17_04.TXT';

      //
      // SmallMsg('Inicio: COTEPE 17/04 por DATA');
      //
  //    if Form1.SaveDialog1.Execute then
      begin
        //
        Form1.Display('Gerando arquivo COTEPE 17/04 - CRZ.','');
        Screen.Cursor             := crHourGlass;    // Cursor de Aguardo
        CHDir(Form1.sAtual);
  //      Deletefile(pChar(Form1.SaveDialog1.FileName));
        Form7.sMfd := '0';
        //
        if Form1.sModeloECF = '59' then _ecf59_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),7,4)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),7,4)   // Ano
                                          );


        if Form1.sModeloECF = '01' then _ecf01_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),7,4)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),7,4)   // Ano
                                          );

        if Form1.sModeloECF = '02' then _ecf02_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),7,4)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),7,4)   // Ano
                                          );

        if Form1.sModeloECF = '03' then _ecf03_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        {Sandro Silva 2021-07-22 inicio 
        if Form1.sModeloECF = '04' then _ecf04_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '05' then _ecf05_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '06' then _ecf06_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '07' then _ecf07_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '08' then _ecf08_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '09' then _ecf09_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '10' then _ecf10_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '11' then _ecf11_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );
        }

        if Form1.sModeloECF = '12' then _ecf12_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );


        if Form1.sModeloECF = '14' then _ecf14_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );


        if Form1.sModeloECF = '15' then _ecf15_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );
        if Form1.sModeloECF = '17' then _ecf17_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '65' then _ecf65_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );
        if Form1.sModeloECF = '99' then _ecf99_LeituraDaMFD('', '', '');


        CHDir(Form1.sAtual);
        Screen.Cursor             := crDefault;    // Cursor de Aguardo
        //
      end;
      //
      if Form7.CheckBox2.Checked = False then //2015-08-17
        GravaNaPastaCerta('c:\','');
      Form1.Display(Form1.sStatusECF,'');
      //
    end else
    begin
      //
      if Form7.CheckBox1.Checked then
      begin
  //      if Form1.SaveDialog1.Execute then
        begin
          //
          Form1.Display('Aguarde! Obtendo dados do ECF.','');
          Screen.Cursor             := crHourGlass;    // Cursor de Aguardo
          CHDir(Form1.sAtual);
          //
          Deletefile(pChar(Form1.SaveDialog1.FileName));
          //
          if Form1.sModeloECF = '01' then _ecf01_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
          if Form1.sModeloECF = '02' then _ecf02_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
          if Form1.sModeloECF = '03' then _ecf03_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
          if Form1.sModeloECF = '12' then _ecf12_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
          if Form1.sModeloECF = '14' then _ecf14_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
          if Form1.sModeloECF = '15' then _ecf15_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
          if Form1.sModeloECF = '17' then _ecf17_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
          if Form1.sModeloECF = '59' then _ecf59_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
          if Form1.sModeloECF = '65' then _ecf65_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
          if Form1.sModeloECF = '99' then _ecf99_leituraMemoriaFiscalEmDisco('', '', '');

          {Sandro Silva 2021-07-22 inicio
          if Form1.sModeloECF = '04' then _ecf04_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
          if Form1.sModeloECF = '05' then _ecf05_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
          if Form1.sModeloECF = '06' then _ecf06_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
          if Form1.sModeloECF = '07' then _ecf07_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
          if Form1.sModeloECF = '08' then _ecf08_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
          if Form1.sModeloECF = '09' then _ecf09_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
          if Form1.sModeloECF = '10' then _ecf10_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
          if Form1.sModeloECF = '11' then _ecf11_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
          }

          //
          Screen.Cursor             := crDefault;    // Cursor de Aguardo
          //
          if FileExists(Form1.SaveDialog1.FileName) then
          begin
            AssinaturaDigital(pChar(Form1.SaveDialog1.FileName));
          end;
        end;
      end else
      begin
        //
        if Form1.sModeloECF = '01' then _ecf01_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
        if Form1.sModeloECF = '02' then _ecf02_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
        if Form1.sModeloECF = '03' then _ecf03_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
        if Form1.sModeloECF = '12' then _ecf12_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
        if Form1.sModeloECF = '14' then _ecf14_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
        if Form1.sModeloECF = '15' then _ecf15_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
        if Form1.sModeloECF = '17' then _ecf17_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
        if Form1.sModeloECF = '59' then _ecf59_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
        if Form1.sModeloECF = '65' then _ecf65_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
        if Form1.sModeloECF = '99' then _ecf99_LeituraMemoriaFiscal('', '');
        {Sandro Silva 2021-07-22 inicio
        if Form1.sModeloECF = '04' then _ecf04_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
        if Form1.sModeloECF = '05' then _ecf05_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
        if Form1.sModeloECF = '06' then _ecf06_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
        if Form1.sModeloECF = '07' then _ecf07_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
        if Form1.sModeloECF = '08' then _ecf08_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
        if Form1.sModeloECF = '09' then _ecf09_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
        if Form1.sModeloECF = '10' then _ecf10_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
        if Form1.sModeloECF = '11' then _ecf11_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
        }
        //
        Form1.Demais('MF');//2015-09-18
      end; // if Form7.CheckBox1.Checked then
      //
    end;
  end;
  //
  Form7.CheckBox1.Visible := False;
  Form7.CheckBox1.Checked := False;
end;

procedure PafEcfLeituraMfSimplificadaPorData;
begin
  Form1.sTipo := 's';
  Form7.sMfd  := '0';
  Form7.Label1.Caption          := 'Informe as condições para a leitura da MF ' +
                                   'e clique  <Avançar> para continuar.';  
  //Form7.Label2.Caption          := 'e clique  <Avançar> para continuar.';
  Form7.DateTimePicker1.Visible := True;
  Form7.DateTimePicker2.Visible := True;
  Form7.MaskEdit1.Visible       := False;
  Form7.MaskEdit2.Visible       := False;
  Form7.Label3.Caption          := 'Data inicial:';
  Form7.Label5.Caption          := 'Data final:';
  //
  Form7.Caption := 'Leitura de memória fiscal simplificada por data';
  Form7.ShowModal;
  if Form7.ModalResult = mrOK then
  begin
    Form1.Repaint;
    //
    Form1.SaveDialog1.FileName := Form1.sPAstaDoExecutavel+'\LMFS_DATA.TXT';
    Form1.SaveDialog1.FilterIndex := 1;
    //
    if Form7.CheckBox1.Checked then
    begin
      begin
        //
        Form1.Display('Aguarde! Obtendo dados do ECF.','');
        Screen.Cursor             := crHourGlass;    // Cursor de Aguardo
        CHDir(Form1.sAtual);
        //
        Deletefile(pChar(Form1.SaveDialog1.FileName));
        //

        if Form1.sModeloECF = '01' then   _ecf01_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName, Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '02' then   _ecf02_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName, Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '03' then   _ecf03_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName, Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                          );
        {Sandro Silva 2021-07-22 inicio
        
        if Form1.sModeloECF = '04' then   _ecf04_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName, Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '05' then   _ecf05_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName, Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '06' then   _ecf06_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName, Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '07' then   _ecf07_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName, Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '08' then   _ecf08_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName, Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '09' then   _ecf09_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName, Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '10' then   _ecf10_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName, Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '11' then   _ecf11_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName, Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                          );
        }

        if Form1.sModeloECF = '12' then   _ecf12_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName, Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                          );


        if Form1.sModeloECF = '14' then   _ecf14_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName, Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                          );


        if Form1.sModeloECF = '15' then   _ecf15_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName, Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '17' then   _ecf17_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName, Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                          );
                                          
        if Form1.sModeloECF = '59' then   _ecf59_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName, Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '65' then   _ecf65_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName, Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
                                          );
        if Form1.sModeloECF = '99' then   _ecf99_leituraMemoriaFiscalEmDisco('', '', '');


        //
        Screen.Cursor             := crDefault;    // Cursor de Aguardo
        //
        if FileExists(Form1.SaveDialog1.FileName) then
        begin
          AssinaturaDigital(pChar(Form1.SaveDialog1.FileName));
        end;
      end;
    end else
    begin
      //
      if Form1.sModeloECF = '59' then _ecf59_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
      ,
      Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
      );

      if Form1.sModeloECF = '01' then _ecf01_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
      ,
      Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
      );

      if Form1.sModeloECF = '02' then _ecf02_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
      ,
      Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
      );

      if Form1.sModeloECF = '03' then _ecf03_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
      ,
      Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
      );

      {Sandro Silva 2021-07-22 inicio 
      if Form1.sModeloECF = '04' then _ecf04_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
      ,
      Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
      );

      if Form1.sModeloECF = '05' then _ecf05_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
      ,
      Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
      );

      if Form1.sModeloECF = '06' then _ecf06_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
      ,
      Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
      );

      if Form1.sModeloECF = '07' then _ecf07_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
      ,
      Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
      );

      if Form1.sModeloECF = '08' then _ecf08_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
      ,
      Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
      );

      if Form1.sModeloECF = '09' then _ecf09_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
      ,
      Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
      );

      if Form1.sModeloECF = '10' then _ecf10_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
      ,
      Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
      );

      if Form1.sModeloECF = '11' then _ecf11_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
      ,
      Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
      );
      }

      if Form1.sModeloECF = '12' then _ecf12_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
      ,
      Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
      );

      if Form1.sModeloECF = '14' then _ecf14_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
      ,
      Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
      );

      if Form1.sModeloECF = '15' then _ecf15_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
      ,
      Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
      );

      if Form1.sModeloECF = '17' then _ecf17_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
      ,
      Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
      );
      if Form1.sModeloECF = '65' then _ecf65_LeituraMemoriaFiscal(      Copy(DateToStr(form7.DateTimePicker1.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker1.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker1.Date),9,2)   // Ano
      ,
      Copy(DateToStr(form7.DateTimePicker2.Date),1,2) + // Dia
      Copy(DateToStr(form7.DateTimePicker2.Date),4,2) + // Mês
      Copy(DateToStr(form7.DateTimePicker2.Date),9,2)   // Ano
      );
      if Form1.sModeloECF = '99' then _ecf99_LeituraMemoriaFiscal( '', '');

      Form1.Demais('MF');//2015-09-18
    end; // if Form7.CheckBox1.Checked then
  end;
  //

end;
procedure PafEcfLeituraMfSimplificadaPorIntervaloReducoes;
begin
  Form1.sTipo := 's';
  Form7.sMfd  := '0';
  Form7.Label1.Caption          := 'Informe as condições para a leitura da MF ' +
                                   'e clique  <Avançar> para continuar.'; 
  //Form7.Label2.Caption          := 'e clique  <Avançar> para continuar.';
  Form7.DateTimePicker1.Visible := False;
  Form7.DateTimePicker2.Visible := False;
  Form7.MaskEdit1.Visible       := True;
  Form7.MaskEdit2.Visible       := True;

  Form7.Label3.Caption          := 'Redução inicial:';
  Form7.Label5.Caption          := 'Redução final:';
  Form7.MaskEdit1.Width         := 55; // 2015-09-08
  Form7.MaskEdit2.Width         := Form7.MaskEdit1.Width;

  Form7.ShowModal;
  if Form7.ModalResult = mrOK then
  begin
    Form1.Repaint;
    Form1.SaveDialog1.FileName := Form1.sPAstaDoExecutavel+'\LMFS_CRZ.TXT';
    Form1.SaveDialog1.FilterIndex := 1;
    //
    if Form7.CheckBox1.Checked then
    begin
  //    if Form1.SaveDialog1.Execute then
      begin
        //
        Form1.Display('Aguarde! Obtendo dados do ECF.','');
        Screen.Cursor             := crHourGlass;    // Cursor de Aguardo
        CHDir(Form1.sAtual);
        //
        Deletefile(pChar(Form1.SaveDialog1.FileName));
        //
        if Form1.sModeloECF = '01' then _ecf01_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
        if Form1.sModeloECF = '02' then _ecf02_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
        if Form1.sModeloECF = '03' then _ecf03_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
        if Form1.sModeloECF = '12' then _ecf12_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
        if Form1.sModeloECF = '14' then _ecf14_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
        if Form1.sModeloECF = '15' then _ecf15_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
        if Form1.sModeloECF = '17' then _ecf17_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
        if Form1.sModeloECF = '59' then _ecf59_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
        if Form1.sModeloECF = '65' then _ecf65_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
        if Form1.sModeloECF = '99' then _ecf99_leituraMemoriaFiscalEmDisco('', '', '');

        {Sandro Silva 2021-07-22 inicio
        if Form1.sModeloECF = '04' then _ecf04_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
        if Form1.sModeloECF = '05' then _ecf05_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
        if Form1.sModeloECF = '06' then _ecf06_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
        if Form1.sModeloECF = '07' then _ecf07_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
        if Form1.sModeloECF = '08' then _ecf08_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
        if Form1.sModeloECF = '09' then _ecf09_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
        if Form1.sModeloECF = '10' then _ecf10_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
        if Form1.sModeloECF = '11' then _ecf11_leituraMemoriaFiscalEmDisco(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
        }
        //
        Screen.Cursor             := crDefault;    // Cursor de Aguardo
        //
        if FileExists(Form1.SaveDialog1.FileName) then
        begin
          AssinaturaDigital(pChar(Form1.SaveDialog1.FileName));
        end;
      end;
    end else
    begin
      //
      if Form1.sModeloECF = '01' then _ecf01_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
      if Form1.sModeloECF = '02' then _ecf02_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
      if Form1.sModeloECF = '03' then _ecf03_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
      if Form1.sModeloECF = '12' then _ecf12_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
      if Form1.sModeloECF = '14' then _ecf14_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
      if Form1.sModeloECF = '15' then _ecf15_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
      if Form1.sModeloECF = '17' then _ecf17_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
      if Form1.sModeloECF = '59' then _ecf59_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
      if Form1.sModeloECF = '65' then _ecf65_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
      if Form1.sModeloECF = '99' then _ecf99_LeituraMemoriaFiscal('', '');
      {Sandro Silva 2021-07-22 inicio
      if Form1.sModeloECF = '04' then _ecf04_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
      if Form1.sModeloECF = '05' then _ecf05_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
      if Form1.sModeloECF = '06' then _ecf06_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
      if Form1.sModeloECF = '07' then _ecf07_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
      if Form1.sModeloECF = '08' then _ecf08_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
      if Form1.sModeloECF = '09' then _ecf09_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
      if Form1.sModeloECF = '10' then _ecf10_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
      if Form1.sModeloECF = '11' then _ecf11_LeituraMemoriaFiscal(form7.MaskEdit1.Text,form7.MaskEdit2.Text);
      }
      //
      Form1.Demais('MF');//2015-09-18
    end; // if Form7.CheckBox1.Checked then
  end;
  //
end;

procedure PafEcfArquivoAC1704PorCOO;
begin
  //
  Form7.CheckBox2.Visible := False;
  Form7.CheckBox2.Checked := True;
  Form7.CheckBox1.Visible := False;
  //
  Form1.sTipo := 'c';
  Form7.sMfd  := '2';
  Form7.Label1.Caption          := 'Informe as condições para a leitura da MFD ' +
                                   'e clique  <Avançar> para continuar.';
  //Form7.Label2.Caption          := 'e clique  <Avançar> para continuar.';
  Form7.DateTimePicker1.Visible := False;
  Form7.DateTimePicker2.Visible := False;
  Form7.MaskEdit1.Visible       := True;
  Form7.MaskEdit2.Visible       := True;
  Form7.MaskEdit1.Width         := 55; // 2015-09-08
  Form7.MaskEdit2.Width         := Form7.MaskEdit1.Width;
  Form7.Label3.Caption          := 'COO inicial:';
  Form7.Label5.Caption          := 'COO final:';
  //
  Form7.Caption := 'Arq. AC 17/04 por intervalo de COO';//'Leitura de memória fiscal completa por intervalo de redução';
  Form7.ShowModal;
  if Form7.ModalResult = mrOK then
  begin
    Form1.Repaint;
    Form1.SaveDialog1.FileName := Form1.sPAstaDoExecutavel+'\MFD' + Form1.sNumeroDeSerieDaImpressora + '_' + FormatDateTime('yyyymmdd_HHnnss', Now) + '.TXT'; //
    Form1.SaveDialog1.FilterIndex := 1;
    //
    if Form7.CheckBox2.Checked then
    begin
      //
      // SmallMsg('Inicio: COTEPE 17/04 por DATA');
      //
  //    if Form1.SaveDialog1.Execute then
      begin
        //
        Form1.Display('Aguarde! Gerando arquivo COTEPE 17/04 - COO.','Gerando arquivo COTEPE 17/04 - COO'); // Sandro Silva 2018-05-18 Display('Gerando arquivo COTEPE 17/04 - COO.','');
        Screen.Cursor             := crHourGlass;    // Cursor de Aguardo
        CHDir(Form1.sAtual);
        //Form7.sMfd := '0';
        //
        if Form1.sModeloECF = '59' then _ecf59_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),7,4)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),7,4)   // Ano
                                          );


        if Form1.sModeloECF = '01' then _ecf01_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),7,4)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),7,4)   // Ano
                                          );

        if Form1.sModeloECF = '02' then _ecf02_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),7,4)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),7,4)   // Ano
                                          );

        if Form1.sModeloECF = '03' then _ecf03_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        {Sandro Silva 2021-07-22 inicio 
        if Form1.sModeloECF = '04' then _ecf04_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '05' then _ecf05_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '06' then _ecf06_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '07' then _ecf07_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '08' then _ecf08_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '09' then _ecf09_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '10' then _ecf10_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '11' then _ecf11_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );
        }

        if Form1.sModeloECF = '12' then _ecf12_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );


        if Form1.sModeloECF = '14' then _ecf14_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );


        if Form1.sModeloECF = '15' then _ecf15_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '17' then _ecf17_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '65' then _ecf65_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '99' then _ecf99_LeituraDaMFD('', '', '');

        CHDir(Form1.sAtual);
        Screen.Cursor             := crDefault;    // Cursor de Aguardo
        //
      end;
      //
      if FileExists(Form1.SaveDialog1.FileName) then
      begin
        AssinaturaDigital(pChar(Form1.SaveDialog1.FileName));
      end;

      //
      if (Form1.sModeloECF <> '02') and (Form1.sModeloECF <> '15') and (Form1.sModeloECF <> '17') then
        if Form7.CheckBox2.Checked = False then //2015-08-17
          GravaNaPastaCerta('c:\','');
      Form1.Display(Form1.sStatusECF,'');
      //
    end;
  end;
  //
  Form7.CheckBox2.Checked := False;
end;

procedure PafEcfArquivoAC1704PorData;
begin
  //
  //
  Form7.CheckBox2.Visible := False;
  Form7.CheckBox2.Checked := True;
  Form7.CheckBox1.Visible := False;
  //
  Form1.sTipo := 'c';
  Form7.sMfd  := '2';
  Form7.Label1.Caption          := 'Informe as condições para a leitura da MFD ' +
                                   'e clique  <Avançar> para continuar.';
  //Form7.Label2.Caption          := 'e clique  <Avançar> para continuar.';
  Form7.DateTimePicker1.Visible := True;
  Form7.DateTimePicker2.Visible := True;
  Form7.MaskEdit1.Visible       := False;
  Form7.MaskEdit2.Visible       := False;
  Form7.Label3.Caption          := 'Data inicial:';
  Form7.Label5.Caption          := 'Data final:';

  Form7.Caption                 := 'Arq. AC 17/04 por data'; //'Leitura de memória fiscal completa por data';
  Form7.ShowModal;
  if Form7.ModalResult = mrOK then
  begin
    Form1.Repaint;
    //
    Form1.SaveDialog1.FileName := Form1.sPAstaDoExecutavel+'\MFD' + Form1.sNumeroDeSerieDaImpressora + '_' + FormatDateTime('yyyymmdd_HHnnss', Now) + '.TXT'; // '\LMFC_DATA.TXT';
    Form1.SaveDialog1.FilterIndex := 1;
    //
    if Form7.CheckBox2.Checked then
    begin
      //
      // SmallMsg('Inicio: COTEPE 17/04 por DATA');
      //
      //    if Form1.SaveDialog1.Execute then
      begin
        //
        Form1.Display('Aguarde! Gerando arquivo COTEPE 17/04 - Data','Gerando arquivo COTEPE 17/04 - Data'); // Sandro Silva 2018-05-18 Display('Aguarde! Gerando arquivo COTEPE 17/04 - data.','');
        Screen.Cursor             := crHourGlass;    // Cursor de Aguardo
        CHDir(Form1.sAtual);
        //      Deletefile(pChar(Form1.SaveDialog1.FileName));
        //Form7.sMfd := '0';
        //
        if Form1.sModeloECF = '59' then _ecf59_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),7,4)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),7,4)   // Ano
                                          );


        if Form1.sModeloECF = '01' then _ecf01_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),7,4)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),7,4)   // Ano
                                          );

        if Form1.sModeloECF = '02' then _ecf02_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),7,4)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),7,4)   // Ano
                                          );

        if Form1.sModeloECF = '03' then _ecf03_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        {Sandro Silva 2021-07-22 inicio 
        if Form1.sModeloECF = '04' then _ecf04_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '05' then _ecf05_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '06' then _ecf06_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '07' then _ecf07_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '08' then _ecf08_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '09' then _ecf09_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '10' then _ecf10_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '11' then _ecf11_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );
        }
        if Form1.sModeloECF = '12' then _ecf12_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '14' then _ecf14_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '15' then _ecf15_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '17' then _ecf17_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '65' then _ecf65_LeituraDaMFD(Form1.SaveDialog1.FileName,
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                          ,
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                          Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                          );

        if Form1.sModeloECF = '99' then _ecf99_LeituraDaMFD('', '', '');


        CHDir(Form1.sAtual);
        Screen.Cursor             := crDefault;    // Cursor de Aguardo
        //
      end;

      //Sleep(50000); // 2015-11-12 Gerou com assinatura inválida

      //SmallMsg('Teste 01 GEROU');

      if FileExists(Form1.SaveDialog1.FileName) then
      begin
        AssinaturaDigital(pChar(Form1.SaveDialog1.FileName));
      end;

      //
      if (Form1.sModeloECF <> '02') and (Form1.sModeloECF <> '15') and (Form1.sModeloECF <> '17') then
      begin
        GravaNaPastaCerta('c:\','');
      end;
      Form1.Display(Form1.sStatusECF,'');
      //
    end;
  end;
  //
  Form7.CheckBox2.Checked := False;
end;

procedure PafEcfRelatorioGerancialDavEmitido;
var
  sCupomfiscalVinculado : String;
  fTotal  : Real;
  bRetornoComando: Boolean;
begin
  //
  Form7.sMfd  := '9';
  Form7.Label1.Caption:='Informe o período para o relatório de DAV ' +
                        'emitidos e clique em <Avançar> para continuar.';
  //Form7.Label2.Caption:='emitidos e clique em <Avançar> para continuar.';
  Form7.DateTimePicker1.Visible := True;
  Form7.DateTimePicker2.Visible := True;
  Form7.MaskEdit1.Visible       := False;
  Form7.MaskEdit2.Visible       := False;
  Form7.CheckBox1.Visible       := False;
  Form7.Label3.Caption          := 'Data inicial:';
  Form7.Label5.Caption          := 'Data final:';
  //
  Form7.Caption := 'DAV Emitidos por DATA - Relatório gerencial';
  Form1.Timer2.Enabled := False; // Sandro Silva 2016-03-23
  if Form1.bData then
    Form7.ShowModal;

  if Form7.ModalResult = mrOK then
  begin
    CommitaTudo(True);// Relatriogerancial1Click// 2015-09-12

    Form1.Repaint;
    //
    //----------------------------------------- //
    //                                          //
    //           O R Ç A M E N T O              //
    //                                          //
    //  Imprime um Relatório Gerencial no ECF   //
    //  contendo o número de cada orçamento e   //
    //  o valor total, que será arquivado com   //
    //  as respectivaas vias do orçamento.      //
    //----------------------------------------- //
    sCupomFiscalVinculado := '             DAV EMITIDOS        '+Chr(10)+Chr(10)+
    'DAV        DATA       TITULO   TOTAL      CCF   '+Chr(10)+
    '---------- ---------- -------- ---------- ------'+Chr(10);
    //
    if Form1.bData then
    begin
      //
      Form1.ibDataSet99.Close;
      Form1.ibDataSet99.SelectSQL.Clear;
      Form1.ibDataSet99.SelectSQL.Add('select PEDIDO, NUMERONF, DATA, sum(TOTAL) from ORCAMENT where DESCRICAO<>'+QuotedStr('Desconto')+' and DATA>='+QuotedStr( DateToStrInvertida(Form7.DateTimePicker1.Date ))+ ' and DATA<='+QuotedStr( DateToStrInvertida(Form7.DateTimePicker2.Date ))+' group by PEDIDO, NUMERONF, DATA order by PEDIDO');
      Form1.ibDataSet99.Open;
      Form1.ibDataSet99.First;
      //
      fTotal := 0;
      //
      while not Form1.ibDataSet99.EOF do
      begin
        //
        sCupomfiscalVinculado := sCupomfiscalVinculado +
                                     StrZero(Form1.ibDataSet99.FieldByName('PEDIDO').AsFloat,10,0)+ ' ' +
                                     Form1.ibDataSet99.FieldByName('DATA').AsString + ' ' +
                                     'ORCAMENT ' +
                                     Format('%10.2n',[Form1.ibDataSet99.FieldByName('SUM').AsFloat])+' '+Form1.ibDataSet99.FieldByName('NUMERONF').AsString+chr(10);
        //
        fTotal := fTotal + Form1.ibDataSet99.FieldByName('SUM').AsFloat;
        Form1.ibDataSet99.Next;
        //
      end;
    end;
    //
    Form1.ibDataSet99.Close;
    Form1.ibDataSet99.SelectSQL.Clear;
    Form1.ibDataSet99.SelectSQL.Add('select NUMERO, DATA, TOTAL_OS from OS where DATA>='+QuotedStr( DateToStrInvertida(Form7.DateTimePicker1.Date ))+ ' and DATA<='+QuotedStr( DateToStrInvertida(Form7.DateTimePicker2.Date ))+' order by NUMERO');
    Form1.ibDataSet99.Open;
    Form1.ibDataSet99.First;
    //
    fTotal := 0;
    //
    while not Form1.ibDataSet99.EOF do
    begin
      //
      sCupomfiscalVinculado := sCupomfiscalVinculado +
                                   StrZero(Form1.ibDataSet99.FieldByName('NUMERO').AsFloat,10,0)+ ' ' +
                                   Form1.ibDataSet99.FieldByName('DATA').AsString + ' ' +
                                   'OS      ' +
                                   Format('%10.2n',[Form1.ibDataSet99.FieldByName('TOTAL_OS').AsFloat]) + chr(10);
      //
      fTotal := fTotal + Form1.ibDataSet99.FieldByName('TOTAL_OS').AsFloat;
      Form1.ibDataSet99.Next;
      //
    end;
    //
    if Length(sCupomfiscalVinculado) > 80 then
    begin
      bRetornoComando := Form1.PDV_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado));
      //
      if bRetornoComando then // 2015-10-06
        Form1.Demais('RG');
      //
    end;
  end;
  ////////////////
  //            //
  // Orçamento  //
  //            //
  ////////////////
  if Form1.ImportarvendasdoSmallMobile1.Checked then // Sandro Silva 2016-03-23
    Form1.Timer2.Enabled := True;
end;

procedure PafEcfArquivoEletronicoDavEmitido;
var
  iP2 : Integer;
  sModeloECF, sEvidencia : String;
  F: TextFile;
begin
  //
  Form7.sMfd  := '9';
  Form7.Label1.Caption := 'Informe o período para o relatório de DAV ' +
                          'emitidos e clique em <Avançar> para continuar.';
  //Form7.Label2.Caption:='emitidos e clique em <Avançar> para continuar.';
  Form7.DateTimePicker1.Visible := True;
  Form7.DateTimePicker2.Visible := True;
  Form7.MaskEdit1.Visible       := False;
  Form7.MaskEdit2.Visible       := False;
  Form7.CheckBox1.Visible       := False;
  Form7.Label3.Caption          := 'Data inicial:';
  Form7.Label5.Caption          := 'Data final:';
  //
  Form7.Caption := 'DAV Emitidos por DATA - Arquivo Eletrônico';
  Form1.Timer2.Enabled := False; // Sandro Silva 2016-03-23
  Form7.ShowModal;
  if Form7.ModalResult = mrOK then
  begin
    CommitaTudo(True); // ArquivoEletrnico1Click // 2015-09-12
    Form1.Repaint;
    //
    Form1.SaveDialog1.FileName := Form1.sPAstaDoExecutavel+'\DAVEMITIDOS.TXT';
    //
  //  if Form1.SaveDialog1.Execute then
    begin
      //
      DeleteFile(PChar(Form1.SaveDialog1.FileName));
      AssignFile(F, Form1.SaveDialog1.FileName);
      Rewrite(F);                           // Abre para gravação
      //
      Writeln(F, 'D1' +
                 Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) +
                 Copy(LimpaNumero(Form1.ibDataSet13.FieldByName('IE').AsString) + Replicate(' ', 14), 1, 14) +
                 Copy(LimpaNumero(Form1.ibDataSet13.FieldByName('IM').AsString) + Replicate(' ', 14), 1, 14) +
                 Copy(Form1.ibDataSet13.FieldByName('NOME').AsString + Replicate(' ', 50), 1, 50) +
                 Replicate(' ', 32));
      //
      iP2                   := 0;
      //
      Form1.ibDataSet99.Close;
      Form1.ibDataSet99.SelectSQL.Clear;
      Form1.ibDataSet99.SelectSQL.Add('select PEDIDO, CAIXA, DATA, NUMERONF, COO, sum(TOTAL), CLIFOR from ORCAMENT where DESCRICAO<>'+QuotedStr('Desconto')+' and DATA>='+QuotedStr( DateToStrInvertida(Form7.DateTimePicker1.Date ))+ ' and DATA<='+QuotedStr( DateToStrInvertida(Form7.DateTimePicker2.Date ))+' group by PEDIDO, CAIXA, DATA, NUMERONF, COO, CLIFOR order by PEDIDO');
      Form1.ibDataSet99.Open;
      Form1.ibDataSet99.First;
      //
      Form1.ibDataSet37.DisableControls; // Sandro Silva 2020-11-06 Evitar problemas que Ronei teve no Small que ficava travado porque DisableControls estava dentro de loop e o EnableControls era executado apenas uma vez
      //
      while not Form1.ibDataSet99.EOF do
      begin
        //
        Form1.ibDataset88.Close;
        Form1.ibDataset88.SelectSQL.Clear;
        Form1.ibDataset88.SelectSQL.Add('select * from REDUCOES where PDV='+QuotedStr(Form1.ibDataSet99.FieldByName('CAIXA').AsString)+' order by DATA');
        Form1.ibDataset88.Open;
        Form1.ibDataset88.Last;
        //
        Form1.ibDataSet37.Close;
        Form1.ibDataSet37.SelectSQL.Clear;
        Form1.ibDataSet37.SelectSQL.Add('select * from ORCAMENT where PEDIDO='+QuotedStr(Form1.ibDataSet99.FieldByName('PEDIDO').AsString)+' ');
        Form1.ibDataSet37.Open;
        // Sandro Silva 2020-11-06  Form1.ibDataSet37.DisableControls;
        //
        sEvidencia := ' ';
        //
        while not Form1.ibDataSet37.Eof do
        begin
          if not AssinaRegistro('ORCAMENT', Form1.ibDataSet37, False) then
            sEvidencia := '?';
          Form1.ibDataSet37.Next;
        end;
        //
        if sEvidencia = '?' then
          sModeloECF := Copy(StrTran(Form1.ibDataset88.FieldByName('MODELOECF').AsString+Replicate(' ',20),' ',sEvidencia),1,20)
        else
          sModeloECF := Copy(Form1.ibDataset88.FieldByName('MODELOECF').AsString+Replicate(' ',20),1,20);
        //
        if Alltrim(Form1.ibDataSet99.FieldByName('CAIXA').AsString) <> '' then
        begin
          Form1.ibDataSet2.Close;
          Form1.ibDataSet2.SelectSQL.Text :=
            'select * ' +// Sandro Silva 2018-02-08  'select CGC, NOME ' +
            'from CLIFOR ' +
            'where NOME = ' + QuotedStr(Trim(Form1.ibDataSet99.FieldByName('CLIFOR').AsString)) +
            ' and coalesce(CGC, '''') <> '''' ';
          Form1.ibDataSet2.Open;

          Writeln(F, 'D2' +
                     Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) +
                     Copy(Form1.ibDataset88.FieldByName('SERIE').AsString+Replicate(' ',20),1,20)+    // Número de fabricação do ECF Ok
                     ' '+                                                             // Letra indicativa de memória adicional
                     Copy(Form1.ibDataset88.FieldByName('TIPOECF').AsString+Replicate(' ',7),1,7)+       // Tipo de ECF
                     Copy(Form1.ibDataset88.FieldByName('MARCAECF').AsString+Replicate(' ',20),1,20)+    // Marca do ECF
                     sModeloECF+   // Modelo do ECF
                     Copy(Form1.ibDataSet99.FieldByName('COO').AsString + Replicate('0',9) ,1, 9) + // COO Contador de Ordem de Operação
                     Copy('000'+Form1.ibDataSet99.FieldByName('PEDIDO').AsString+'0000000000000',1, 13) + // Número do DAV
                     Copy(DateToStr(Form1.ibDataSet99.FieldByName('DATA').AsDateTime),7,4)+ // AAAA
                     Copy(DateToStr(Form1.ibDataSet99.FieldByName('DATA').AsDateTime),4,2)+ // MM
                     Copy(DateToStr(Form1.ibDataSet99.FieldByName('DATA').AsDateTime),1,2)+ // DD
                     Copy('ORCAMENT'+Replicate(' ',30),1,30) + // Título
                     StrZero(Form1.ibDataSet99.FieldByName('SUM').AsFloat*100,8,0)+  // Valor total do DAV
                     RightStr('000000000' + Form1.ibDataSet99.FieldByName('NUMERONF').AsString, 9)+ // Contador de Ordem de Operação do documento fiscal vinculado
                     RightStr('001' + Form1.ibDataSet99.FieldByName('CAIXA').AsString, 3)+ // Número sequencial do ECF emissao do documento fiscal vinculado
                     Copy(Form1.ibDataSet99.FieldByName('CLIFOR').AsString + Replicate(' ',40), 1, 40)+ // Nome do cliente
                     Right('00000000000000' + LimpaNumero(Form1.ibDataSet2.FieldByName('CGC').AsString), 14) // CPF ou CNPJ do adquirente
                     );
          iP2 := ip2 + 1;
        end;
        //
        Form1.ibDataSet99.Next;
        //
      end;
      //
      Form1.ibDataSet37.EnableControls; // Sandro Silva 2020-11-06
      //
      Writeln(F, 'D9' +
                 Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) +
                 Copy(LimpaNumero(Form1.ibDataSet13.FieldByName('IE').AsString + Replicate(' ', 14)), 1, 14) +
                 StrZero(iP2,6,0));
      CloseFile(F);                                    // Fecha o arquivo
      //
    end;
    //
    AssinaturaDigital(pChar(Form1.SaveDialog1.FileName));
    CHDir(Form1.sAtual);
  end;
  //
  if Form1.ImportarvendasdoSmallMobile1.Checked then // Sandro Silva 2016-03-23
    Form1.Timer2.Enabled := True;
end;

procedure PafEcfAtoCOTEPE0908;
var
  sNomeDoArquivo : String;
begin
  CommitaTudo(True);// AtoCOTEPE09081Click// 2015-09-12
  //
  //sNomeDoArquivo := 'URB'+StrTran(DateToStr(Date),'/','')+StrTran(TimeToStr(Time),':','')+'.TXT';
  sNomeDoArquivo := NUMERO_LAUDO_PAF_ECF+StrTran(DateToStr(Date),'/','')+StrTran(TimeToStr(Time),':','')+'.TXT';
  DeleteFile('FIMSPED.TXT');
  if FileExists('COTEPE0908.EXE') then
    ShellExecute( 0, 'Open', 'COTEPE0908.EXE', pChar(sNOmeDoArquivo), '', SW_SHOW)
  else
    SmallMsg('O executável COTEPE0908.EXE não foi encontrado na pasta de instalação do programa.');
  Form1.Repaint;
  while not FileExists('FIMSPED.TXT') do
  begin
    Sleep(100);
  end;
  Application.BringToFront; // 2015-10-15
  //
  CopyFile(pchar(Form1.sAtual+'\'+sNomeDoArquivo),pchar(Form1.sPastaDoExecutavel+'\'+sNomeDoArquivo), False); // Sandro Silva 2019-08-21 CopyFile(pchar(Form1.sAtual+'\'+sNomeDoArquivo),pchar(Form1.sPastaDoExecutavel+'\'+sNomeDoArquivo),True);
  AssinaturaDigital(pChar(Form1.sPastaDoExecutavel+'\'+sNomeDoArquivo));
  //
end;

procedure PafEcfConvenio57951;
var
  sNomeDoArquivo : String;
begin
  CommitaTudo(True); // Convnio57951Click// 2015-09-12
  //
  //sNomeDoArquivo := 'URB'+StrTran(DateToStr(Date),'/','')+StrTran(TimeToStr(Time),':','')+'.TXT';
  sNomeDoArquivo := NUMERO_LAUDO_PAF_ECF+StrTran(DateToStr(Date),'/','')+StrTran(TimeToStr(Time),':','')+'.TXT';
  DeleteFile('FIMSINTEGRA.TXT');
  if FileExists('ICMS5795.EXE') then
   ShellExecute( 0, 'Open', 'ICMS5795.EXE', pChar(sNOmeDoArquivo), '', SW_SHOW) else
  SmallMsg('O executável ICMS5795.EXE não foi encontrado na pasta de instalação do programa.');
  Form1.Repaint;
  while not FileExists('FIMSINTEGRA.TXT') do
  begin
    Sleep(100);
  end;
  Application.BringToFront; // 2015-10-15
  //
  CopyFile(pchar(Form1.sAtual+'\'+sNomeDoArquivo),pchar(Form1.sPastaDoExecutavel+'\'+sNomeDoArquivo),False); // Sandro Silva 2019-08-21 CopyFile(pchar(Form1.sAtual+'\'+sNomeDoArquivo),pchar(Form1.sPastaDoExecutavel+'\'+sNomeDoArquivo),True);
  AssinaturaDigital(pChar(Form1.sPastaDoExecutavel+'\'+sNomeDoArquivo));
  //
end;

procedure PafEcfLeituraMfdPorData;
begin
  //
  Form7.sMfd  := '1';
  //
  Form7.Label1.Caption          := 'Informe as condições para a leitura da MFD ' +
                                   'e clique  <Avançar> para continuar.';
  //Form7.Label2.Caption          := 'e clique  <Avançar> para continuar.';
  Form7.DateTimePicker1.Visible := True;
  Form7.DateTimePicker2.Visible := True;
  Form7.MaskEdit1.Visible       := False;
  Form7.MaskEdit2.Visible       := False;
  Form7.CheckBox1.Visible       := False;
  Form7.Label3.Caption          := 'Data inicial:';
  Form7.Label5.Caption          := 'Data final:';
  //
  Form7.Caption := 'Espelho da MFD por data';
  Form7.ShowModal;
  if Form7.ModalResult = mrOK then
  begin
    Form1.Repaint;
    //
    Form1.SaveDialog1.FileName := Form1.sPAstaDoExecutavel+'\ESPELHO_DATA.TXT';
    Form1.SaveDialog1.FilterIndex := 1;
    //
  //  if Form1.SaveDialog1.Execute then
    begin
      //
      Form1.Display('Aguarde! Obtendo dados do ECF.','Espelho da MFD por data'); // Sandro Silva 2018-05-18 Display('Aguarde! Obtendo dados do ECF.','');
      Screen.Cursor             := crHourGlass;    // Cursor de Aguardo
      CHDir(Form1.sAtual);
      //
      Deletefile(pChar(Form1.SaveDialog1.FileName));
      //
      if Form1.sModeloECF = '59' then _ecf59_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                        ,
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                        );

      if Form1.sModeloECF = '01' then _ecf01_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                        ,
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                        );

      if Form1.sModeloECF = '02' then _ecf02_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                        ,
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                        );

      if Form1.sModeloECF = '03' then _ecf03_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                        ,
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                        );

      {Sandro Silva 2021-07-22 inicio 
      if Form1.sModeloECF = '04' then _ecf04_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                        ,
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                        );

      if Form1.sModeloECF = '05' then _ecf05_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                        ,
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                        );

      if Form1.sModeloECF = '06' then _ecf06_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                        ,
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                        );

      if Form1.sModeloECF = '07' then _ecf07_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                        ,
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                        );

      if Form1.sModeloECF = '08' then _ecf08_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                        ,
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                        );

      if Form1.sModeloECF = '09' then _ecf09_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                        ,
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                        );

      if Form1.sModeloECF = '10' then _ecf10_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                        ,
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                        );

      if Form1.sModeloECF = '11' then _ecf11_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                        ,
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                        );
      }

      if Form1.sModeloECF = '12' then _ecf12_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                        ,
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                        );


      if Form1.sModeloECF = '14' then _ecf14_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                        ,
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                        );


      if Form1.sModeloECF = '15' then _ecf15_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                        ,
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                        );

      if Form1.sModeloECF = '17' then _ecf17_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                        ,
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                        );

      if Form1.sModeloECF = '65' then _ecf65_LeituraDaMFD(Form1.SaveDialog1.FileName,                                          Copy(DateToStr(Form7.DateTimePicker1.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker1.Date),9,2)   // Ano
                                        ,
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),1,2) + // Dia
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),4,2) + // Mês
                                        Copy(DateToStr(Form7.DateTimePicker2.Date),9,2)   // Ano
                                        );

      if Form1.sModeloECF = '99' then _ecf99_LeituraDaMFD('', '', '');

      CHDir(Form1.sAtual);
      //
      Screen.Cursor             := crDefault;    // Cursor de Aguardo
      Form1.Display(Form1.sStatusECF,'');
  //    Form1.Image2.Visible := False;
  //    Form1.Panel9.Visible := False;
      //
      if FileExists(Form1.SaveDialog1.FileName) then
      begin
        AssinaturaDigital(pChar(Form1.SaveDialog1.FileName));
      end;
      //
    end;
  end;
  //
end;

procedure PafEcfLeituraMfdPorFaixaDeCOO;
begin
  //
  Form7.sMfd  := '1';
  //
  Form7.Label1.Caption          := 'Informe as condições para a leitura da MFD ' +
                                   'e clique  <Avançar> para continuar.';
  //Form7.Label2.Caption          := 'e clique  <Avançar> para continuar.';
  Form7.DateTimePicker1.Visible := False;
  Form7.DateTimePicker2.Visible := False;
  Form7.MaskEdit1.Visible       := True;
  Form7.MaskEdit2.Visible       := True;
  Form7.CheckBox1.Visible       := False;
  Form7.Label3.Caption          := 'COO inicial:';
  Form7.Label5.Caption          := 'COO final:';
  Form7.Caption := 'Espelho da MFD por COO';
  Form7.MaskEdit1.Width         := 55; // 2015-09-08
  Form7.MaskEdit2.Width         := Form7.MaskEdit1.Width;

  Form7.ShowModal;
  if Form7.ModalResult = mrOK then
  begin
    Form1.Repaint;
    //
    Form1.SaveDialog1.FileName := Form1.sPAstaDoExecutavel+'\ESPELHO_COO.TXT';
    Form1.SaveDialog1.FilterIndex := 1;
    //
  //  if Form1.SaveDialog1.Execute then
    begin
      //
      Form1.Display('Aguarde! Obtendo dados do ECF.','Espelho da MFD por COO'); // Sandro Silva 2018-05-18 Display('Aguarde! Obtendo dados do ECF.',''); 
      Screen.Cursor             := crHourGlass;    // Cursor de Aguardo
      CHDir(Form1.sAtual);
      //
      Deletefile(pChar(Form1.SaveDialog1.FileName));
      //
      if Form1.sModeloECF = '01' then _ecf01_LeituraDaMFD(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
      if Form1.sModeloECF = '02' then _ecf02_LeituraDaMFD(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
      if Form1.sModeloECF = '03' then _ecf03_LeituraDaMFD(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
      if Form1.sModeloECF = '12' then _ecf12_LeituraDaMFD(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
      if Form1.sModeloECF = '14' then _ecf14_LeituraDaMFD(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
      if Form1.sModeloECF = '15' then _ecf15_LeituraDaMFD(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
      if Form1.sModeloECF = '17' then _ecf17_LeituraDaMFD(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),6,0), StrZero(StrToInt(form7.MaskEdit2.Text),6,0));
      if Form1.sModeloECF = '59' then _ecf59_LeituraDaMFD(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
      if Form1.sModeloECF = '65' then _ecf65_LeituraDaMFD(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
      if Form1.sModeloECF = '99' then _ecf99_LeituraDaMFD('', '', '');
      {Sandro Silva 2021-07-22 inicio
      if Form1.sModeloECF = '04' then _ecf04_LeituraDaMFD(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
      if Form1.sModeloECF = '05' then _ecf05_LeituraDaMFD(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
      if Form1.sModeloECF = '06' then _ecf06_LeituraDaMFD(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
      if Form1.sModeloECF = '07' then _ecf07_LeituraDaMFD(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
      if Form1.sModeloECF = '08' then _ecf08_LeituraDaMFD(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
      if Form1.sModeloECF = '09' then _ecf09_LeituraDaMFD(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
      if Form1.sModeloECF = '10' then _ecf10_LeituraDaMFD(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
      if Form1.sModeloECF = '11' then _ecf11_LeituraDaMFD(Form1.SaveDialog1.FileName,StrZero(StrToInt(form7.MaskEdit1.Text),4,0), StrZero(StrToInt(form7.MaskEdit2.Text),2,0));
      }  
      //
      CHDir(Form1.sAtual);
      //
      Screen.Cursor             := crDefault;    // Cursor de Aguardo
      //
      if FileExists(Form1.SaveDialog1.FileName) then
      begin
        AssinaturaDigital(pChar(Form1.SaveDialog1.FileName));
      end;
      //
    end;
  end;
  //
end;

end.
