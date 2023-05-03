unit uValidaSistema;

interface

uses
  System.Classes, System.SysUtils, System.StrUtils, Vcl.Dialogs
  , Windows
  , System.IniFiles
  , Forms
  , IdBaseComponent
  , IBX.IBDatabase, IBX.IBQuery
  , LbCipher, LbClass
  , ShellApi
  , Vcl.DBCtrls
  , Vcl.StdCtrls
  , Vcl.Mask
  , smallfunc_xe, uconstantes_chaves_privadas
  ;

function BuscaSerialSmall:string;
function ValidaSistema(IBDATABASE: TIBDatabase; bFechaSistema: Boolean = True; bValidacaoNova: Boolean = True):Boolean;
function DiasParaExpirar(IBDATABASE: TIBDatabase; bValidacaoNova: Boolean = True): Integer;
function Legal_ok(IBDATABASE: TIBDatabase): Boolean;

implementation


function Legal_ok(IBDATABASE: TIBDatabase): Boolean;
var
  qyAux: TIBQuery;
  trAux: TIBTransaction;
  dtLimite: TDate;
begin
  Result := True; // Come�a otimista, que est� tudo ok. Torna false durante valida��o
  try
    trAux := CriaIBTransaction(IBDATABASE);
    qyAux := CriaIBQuery(trAux);

    qyAux.Close;
    qyAux.SQL.Clear;
    qyAux.SQL.Add('select gen_id(G_LEGAL,0) as LEGAL from rdb$database');
    qyAux.Open;

    if qyAux.FieldByname('LEGAL').AsString <> '0' then
    begin
      if qyAux.FieldByname('LEGAL').AsString = '19670926' then
      begin
        Result := False;
      end
      else
      begin
        dtLimite := StrToDate(Copy(qyAux.FieldByname('LEGAL').AsString,7,2)+'/'+Copy(qyAux.FieldByname('LEGAL').AsString,5,2)+'/'+Copy(qyAux.FieldByname('LEGAL').AsString,1,4));
        //if (Date >= StrToDate(Copy(qyAux.FieldByname('LEGAL').AsString,7,2)+'/'+Copy(qyAux.FieldByname('LEGAL').AsString,5,2)+'/'+Copy(qyAux.FieldByname('LEGAL').AsString,1,4))+31)
        //or (Date < StrToDate(Copy(qyAux.FieldByname('LEGAL').AsString,7,2)+'/'+Copy(qyAux.FieldByname('LEGAL').AsString,5,2)+'/'+Copy(qyAux.FieldByname('LEGAL').AsString,1,4)))
        //then
        if (Date >= dtLimite + 31) or (Date < dtLimite) then
        begin
          Result := False;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      Result := False;
    end;
  end;

  FreeAndNil(trAux);
  FreeAndNil(qyAux);
end;



function BuscaSerialSmall:string;
var
  INI : TInifile;
  slSeriais, slListaSection: TStringList;
  iVersao: Integer;
begin
  if FileExists(SysWinDir + '\wind0ws.l0g') then
  begin
    try
      Ini := TIniFile.create(SysWinDir + '\wind0ws.l0g');

      slSeriais      := TStringList.Create;
      slListaSection := TStringList.Create;

      Ini.ReadSections(slListaSection);

      slSeriais.Clear;
      for iVersao := 0 to slListaSection.Count - 1 do
      begin
        slSeriais.Add(INI.ReadString(slListaSection.Strings[iVersao], 'Ser', ''));
      end;

      slSeriais.Sorted := True;
      if slSeriais.Count > 0 then
        Result := slSeriais.Strings[slSeriais.Count - 1];
    finally
      FreeAndNil(slSeriais);
      FreeAndNil(slListaSection);
      FreeAndNil(Ini);
    end;
  end;
end;


function ValidaSistema(IBDATABASE: TIBDatabase; bFechaSistema: Boolean = True; bValidacaoNova: Boolean = True):Boolean;
var
  Serial, Empresa, CNPJ : string;
  qyAux: TIBQuery;
  trAux: TIBTransaction;
begin
  Result := False;

  if DiasParaExpirar(IBDATABASE,bValidacaoNova) < 0 then // Permite usar at� o dia que expira Sandro Silva 2019-11-19
  begin
    try
      trAux := CriaIBTransaction(IBDATABASE);
      qyAux := CriaIBQuery(trAux);

      qyAux.Database := IBDATABASE;
      qyAux.SQL.Text := 'Select CGC,NOME from EMITENTE';
      qyAux.Open;

      Empresa := qyAux.FieldByName('NOME').AsString;
      CNPJ    := qyAux.FieldByName('CGC').AsString;
    finally
      FreeAndNil(qyAux);
      FreeAndNil(trAux);
    end;

    Serial  := BuscaSerialSmall;

    if SmallMsgBox(PChar('N�o foi poss�vel liberar o sistema para uso neste computador'+chr(10)+
                         'com o n�mero de s�rie '+ StrTran(Serial, 'N�mero de s�rie: ', '') +', para: '+chr(10)+chr(10)+
                          AllTrim(Empresa)+chr(10)+chr(10)+
                          AllTrim(CNPJ)+chr(10)+chr(10)+
                         'C�digo: 2020 '+chr(10)+chr(10)+
                         'Adquirir uma licen�a de uso atualizada?'),
                         'Aten��o', MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON1) = idYes then
    begin
      ShellExecute(Application.Handle, nil, PChar('https://smallsoft.com.br/loja/atualiza-via-small?serial=' + StrTran(Serial, 'N�mero de s�rie: ', '') + '&cnpj=' + LimpaNumero(CNPJ)), nil, nil, SW_SHOWMAXIMIZED);
    end;

    //Fecha aplica��o
    if bFechaSistema then
    begin
      FecharAplicacao(ExtractFileName(Application.ExeName));
      Sleep(2000); //Aguarda para fechar a aplica��o
      FecharAplicacao(ExtractFileName(Application.ExeName));
      Application.Terminate; //Garante que n�o prosiga
    end;

    Result := False;
    Exit;
  end;


  if (Legal_ok(IBDATABASE) = False) then // Com bloqueio com paratudo pela Small/Revenda   Ficha 4918
  begin
    SmallMsgBox(PChar('Sistema bloqueado!'+chr(10)+chr(10)+
                      'Abra o Small, confirme os dados no cadastro do Emitente' + Chr(10) +
                      'e entre em um dos m�dulos do Small'),
                      'Aten��o', MB_ICONWARNING + MB_OK);

    //Fecha aplica��o
    if bFechaSistema then
    begin
      FecharAplicacao(ExtractFileName(Application.ExeName));
      Sleep(2000); //Aguarda para fechar a aplica��o
      FecharAplicacao(ExtractFileName(Application.ExeName));
      Application.Terminate; //Garante que n�o prosiga
    end;

    Result := False;
    Exit;
  end;

  //Se passou por tudo retorna ok
  Result := True;
end;



function DiasParaExpirar(IBDATABASE: TIBDatabase;
  bValidacaoNova: Boolean = True): Integer;
var
  qyAux: TIBQuery;
  trAux: TIBTransaction;
  Blowfish: TLbBlowfish;
  sDataLimite: String; // Sandro Silva 2022-11-14
begin

  try
    trAux := CriaIBTransaction(IBDATABASE);
    qyAux := CriaIBQuery(trAux);

    Blowfish := TLbBlowfish.Create(Application);

    qyAux.Close;
    qyAux.SQL.Clear;
    qyAux.SQL.Add('select LICENCA from EMITENTE');
    qyAux.Open;

    Blowfish.GenerateKey(CHAVE_CIFRAR); // Minha chave secreta

    if AllTrim(qyAux.FieldByname('LICENCA').AsString) <> '' then
    begin
      {Sandro Silva 2022-11-14 inicio
      Result := Trunc(365 - (Date - StrToDate(Copy(Blowfish.DecryptString(qyAux.FieldByname('LICENCA').AsString),7,2)+'/'+Copy(Blowfish.DecryptString(qyAux.FieldByname('LICENCA').AsString),5,2)+'/'+Copy(Blowfish.DecryptString(qyAux.FieldByname('LICENCA').AsString),1,4))));
      }
      //sDataLimite := Copy(Blowfish.DecryptString(qyAux.FieldByname('LICENCA').AsString),7,2)+'/'+Copy(Blowfish.DecryptString(qyAux.FieldByname('LICENCA').AsString),5,2)+'/'+Copy(Blowfish.DecryptString(qyAux.FieldByname('LICENCA').AsString),1,4);     //Mauricio Parizotto 2023-01-11
      sDataLimite := Copy(Blowfish.DecryptString(AllTrim(qyAux.FieldByname('LICENCA').AsString)),7,2)+'/'+Copy(Blowfish.DecryptString(AllTrim(qyAux.FieldByname('LICENCA').AsString)),5,2)+'/'+Copy(Blowfish.DecryptString(AllTrim(qyAux.FieldByname('LICENCA').AsString)),1,4);

      if bValidacaoNova = False then
      begin
        Result := Trunc(365 - (Date - StrToDate(sDataLimite)));
      end else
      begin
        // Calcula o n�mero de dias restantes para usar o sistema
        // Data limite - data atual do PC
        Result := Trunc((StrToDate(sDataLimite) - Date));
      end;
    end else
    begin
      Result := -1; // 0 dias ainda pode usar
      Application.MessageBox(PChar('Cadastro do emitente desatualizado' + Chr(10) + Chr(10) +
        'Entre antes no programa "Small" e confirme os dados no Cadastro do emitente.'), 'Aten��o', MB_OK + MB_ICONWARNING);
      //FecharAplicacao(ExtractFileName(Application.ExeName));
    end;
  except
    on E: Exception do
    begin
      if AnsiContainsText(E.Message, 'Column unknown') and AnsiContainsText(E.Message, 'LICENCA') then
      begin
        Application.MessageBox(PChar('Seu banco de dados est� desatualizado' + Chr(10) + Chr(10) +
          'Entre antes no programa "Small" para ajustar os arquivos.'), 'Aten��o', MB_OK + MB_ICONWARNING);
        FecharAplicacao(ExtractFileName(Application.ExeName));
        Abort;
      end;
      Result := -1; // 0 dias ainda pode usar
    end;
  end;

  FreeAndNil(trAux);
  FreeAndNil(qyAux);
  FreeAndNil(Blowfish);
end;




end.
