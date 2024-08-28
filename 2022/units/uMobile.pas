unit uMobile;

interface

uses
  Windows, SysUtils, Messages, Classes, Graphics,
  IniFiles, DB, JPEG, ExtDlgs;

  function AtualizaMobile(sP1: Boolean): Boolean;

implementation

uses
  Unit7
  , Mais, smallfunc_xe, uDialogs;

function AtualizaMobile(sP1: Boolean): Boolean;  //Mauricio Parizotto 2024-06-20
var
  s, sSenha: String;

  Mais1Ini: TIniFile;
  sSecoes: TStrings;
  I, iI: Integer;
  sCNPJ: String;
  _bmp: TBitmap;
  Picture: TPicture;

  jp: TJPEGImage;
  F: TExtFile;
  Rect: tRect;
  BlobStream: TStream;
  fDesconto: Real;
begin
  try
    DownloadDoArquivo(PChar('http://www.smallsoft.com.br/2.php'),PChar('2.php'));
  except end;

  Form1.DownloadSmallMobile1Click(Form1.SincronizarSmallMobile1);

  DeleteFile(pChar(Form1.sAtual+'\estoque.sql'));
  DeleteFile(pChar(Form1.sAtual+'\clifor.sql'));
  DeleteFile(pChar(Form1.sAtual+'\usuarios.sql'));
  DeleteFile(pChar(Form1.sAtual+'\emitente.sql'));//Mauricio Parizotto 2024-07-15

  sCNPJ := AllTrim(LimpaNumero(Form7.ibDataSet13.FieldByname('CGC').AsString));

  try
    if sCNPJ <> '' then
    begin
      {$Region'//// Estoque ////'}
      try
        // estoque.sql
        Form7.IBDataSet4.DisableControls;
        Form7.IBDataSet4.Close;
        Form7.IBDataSet4.SelectSQL.Clear;
        Form7.IBDataSet4.SelectSQL.Add('select * from ESTOQUE where Coalesce(Ativo,0)=0 order by CODIGO');
        Form7.IBDataSet4.Open;

        AssignFile(F,pchar(Form1.sAtual+'\estoque.sql'));
        Rewrite(F);
        WriteLN(F,'delete from estoque where EMITENTE = '+QuotedStr(sCNPJ)+'; '); // Apaga somente as inf atuais deste CNPJ

        Form7.IBDataSet4.First;

        while not Form7.IBDataSet4.Eof do
        begin
          try
            try
              DeleteFile(pChar(Form1.sAtual+'\tempo.bmp'));
              DeleteFile(pChar('_t_'+Form7.ibDataset4CODIGO.AsString+'.jpg'));
            except
            end;

            if sP1 then
            begin
              try
                if Form7.IBDataSet4FOTO.BlobSize <> 0 then
                begin
                  BlobStream:= Form7.IBDataSet4.CreateBlobStream(Form7.IBDataSet4FOTO,bmRead);
                  jp := TJPEGImage.Create;
                  try
                    jp.LoadFromStream(BlobStream);
                    //Form10.Image5.Picture.Assign(jp); //Mauricio Parizotto 2024-06-20
                  except
                  end;

                  jp.SaveToFile('_t_'+Form7.ibDataset4CODIGO.AsString+'.jpg'); //Mauricio Parizotto 2024-06-20

                  BlobStream.Free;
                  jp.Free;

                  //Form10.Image5.Picture.SaveToFile('_t_'+Form7.ibDataset4CODIGO.AsString+'.jpg'); //Mauricio Parizotto 2024-06-20

                  // JPG para BMP
                  if FileExists(Form1.sAtual+'\_t_'+Form7.ibDataset4CODIGO.AsString+'.jpg') then
                  begin
                    Picture := graphics.TPicture.Create;
                    _bmp    := graphics.TBitmap.Create;
                    Picture.LoadFromFile('_t_'+Form7.ibDataset4CODIGO.AsString+'.jpg');

                    try
                      _bmp.Assign(Picture.Graphic);
                      _bmp.SavetoFile('tempo.bmp');
                      Form1.Image1.Picture.LoadFromFile('tempo.bmp');
                    except
                    end;

                    _bmp.Free;
                    Picture.Free;
                  end;

                  if FileExists(Form1.sAtual+'\tempo.bmp') then
                  begin
                    Form1.Image1.Picture.LoadFromFile(Form1.sAtual+'\tempo.bmp');

                    Rect.Top := 0;
                    Rect.Left := 0;

                    if Form1.Image1.Picture.Width > Form1.Image1.Picture.Height then
                    begin
                      Form1.Image1.Picture.Bitmap.Height := Form1.Image1.Picture.Bitmap.Width;
                      Rect.Right  := StrToInt(StrZero((Form1.Image1.Picture.Width   * (100 / Form1.Image1.Picture.Width)),4,0));
                      Rect.Bottom := StrToInt(StrZero((Form1.Image1.Picture.Height  * (100 / Form1.Image1.Picture.Width)),4,0));
                    end else
                    begin
                      Form1.Image1.Picture.Bitmap.Width := Form1.Image1.Picture.Bitmap.Height;
                      Rect.Right  := StrToInt(StrZero((Form1.Image1.Picture.Width   * (100 / Form1.Image1.Picture.Height)),4,0));
                      Rect.Bottom := StrToInt(StrZero((Form1.Image1.Picture.Height  * (100 / Form1.Image1.Picture.Height)),4,0));
                    end;

                    Form1.Image1.Canvas.stretchdraw(Rect,Form1.Image1.Picture.Graphic);

                    Form1.Image1.Picture.Bitmap.Width  := Rect.Right;
                    Form1.Image1.Picture.Bitmap.Height := Rect.Bottom;

                    try
                      jp := TJPEGImage.Create;
                      jp.Assign(Form1.Image1.Picture.Bitmap);
                      jp.CompressionQuality := 80;
                      jp.SaveToFile('_m_'+Form7.ibDataset4CODIGO.AsString+'.jpg');
                    except
                    end;

                    jp.Free;
                  end;
                  try
                    DeleteFile(pChar(Form1.sAtual+'\tempo.bmp'));
                    DeleteFile(pChar('_t_'+Form7.ibDataset4CODIGO.AsString+'.jpg'));
                  except
                  end;
                end;
              except
              end;
            end;

            WriteLN(F,'insert into estoque (EMITENTE, CODIGO, CST, DESCRICAO, MEDIDA, PRECO, QTD_ATUAL, ST) values ('
              +QuotedStr(sCNPJ)+', '
              +QuotedStr(StrTran(Form7.IBDataSet4.FieldByname('CODIGO').AsString,'''',''))+', '
              +QuotedStr(StrTran(Form7.IBDataSet4.FieldByname('CST').AsString,'''',''))+', '
              +QuotedStr(ConverteAcentosPHP(Form7.IBDataSet4.FieldByname('DESCRICAO').AsString)) +', '
              +QuotedStr(StrTran(Form7.IBDataSet4.FieldByname('MEDIDA').AsString,'''',''))+', '
              +QuotedStr(StrTRan(Form7.IBDataSet4.FieldByname('PRECO').AsString,',','.'))+', '
              +QuotedStr(StrTRan(Form7.IBDataSet4.FieldByname('QTD_ATUAL').AsString,',','.'))+', '
              +QuotedStr(StrTran(Form7.IBDataSet4.FieldByname('ST').AsString,'''',''))+' ); ');
          except
          end;

          Form7.IBDataSet4.Next;
        end;

        CloseFile(F);
      except
        try
          CloseFile(F);
        except
        end;
      end;
      {$Endregion}

      {$Region'//// CLiesntes/Fornecedores ////'}
      try
        // clifor.off
        Form1.IBQuery1.Close;
        Form1.IBQuery1.SQL.Clear;
        Form1.IBQuery1.SQL.Add('select * from CLIFOR');
        Form1.IBQuery1.Open;

        AssignFile(F,pchar(Form1.sAtual+'\clifor.sql'));
        Rewrite(F);
        WriteLN(F,'delete from clifor where EMITENTE = '+QuotedStr(sCNPJ)+'; '); // Apaga somente as inf atuais deste CNPJ
        Form1.ibQuery1.First;

        while not Form1.ibQuery1.Eof do
        begin
          try
            if LimpaNumero(Form1.ibQuery1.FieldByname('CGC').AsString) <> '' then
            begin
              if AllTrim(Form1.ibQuery1.FieldByname('CONVENIO').AsString) <> '' then
              begin
                Form7.ibDataSet29.Locate('NOME',Form1.ibQuery1.FieldByname('CONVENIO').AsString,[]);
                fDesconto := Form7.ibDataSet29DESCONTO.AsFloat;
              end else
                fDesconto := 0;

              WriteLN(F,'insert into clifor (EMITENTE, NOME, CGC, IE, CEP, EMAIL, CIDADE, COMPLE, ENDERE, ESTADO, FONE, DESCONTO_CONVENIO) values ('
                +QuotedStr(sCNPJ)+', '
                +QuotedStr(ConverteAcentosPHP(Form1.ibQuery1.FieldByname('NOME').AsString))+', '
                +QuotedStr(LimpaNumero(Form1.ibQuery1.FieldByname('CGC').AsString))+', '
                +QuotedStr(Form1.ibQuery1.FieldByname('IE').AsString)+', '
                +QuotedStr(Form1.ibQuery1.FieldByname('CEP').AsString)+', '
                +QuotedStr(Form1.ibQuery1.FieldByname('EMAIL').AsString)+', '
                +QuotedStr(ConverteAcentosPHP(Form1.ibQuery1.FieldByname('CIDADE').AsString))+', '
                +QuotedStr(ConverteAcentosPHP(Form1.ibQuery1.FieldByname('COMPLE').AsString))+', '
                +QuotedStr(ConverteAcentosPHP(Form1.ibQuery1.FieldByname('ENDERE').AsString))+', '
                +QuotedStr(Form1.ibQuery1.FieldByname('ESTADO').AsString)+', '
                +QuotedStr(Form1.ibQuery1.FieldByname('FONE').AsString)+','
                +QuotedStr(StrTRan(FloatToStr(fDesconto),',','.'))+' ); ');
            end;
          except
          end;

          Form1.ibQuery1.Next;
        end;

        CloseFile(F);
      except
        try
          CloseFile(F);
        except
        end;
      end;
      {$Endregion}

      {$Region'//// Usuários ////'}
      try
        // usuarios.off
        AssignFile(F,pchar(Form1.sAtual+'\usuarios.sql'));
        Rewrite(F);
        WriteLN(F,'delete from usuarios where EMITENTE = '+QuotedStr(sCNPJ)+'; '); // Apaga somente as inf atuais deste CNPJ

        sSecoes := TStringList.Create;

        Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
        Mais1Ini.ReadSections(sSecoes);

        for I := 0 to (sSecoes.Count - 1) do
        begin
          s := '';
          if Mais1Ini.ReadString(sSecoes[I],'Chave','ÁstreloPitecus') <> 'ÁstreloPitecus' then
          begin
            if AllTrim(sSecoes[I]) <> 'Administrador' then
            begin
              sSenha   := Mais1Ini.ReadString(sSecoes[I],'Chave','15706143431572013809150491382314104');
              // ----------------------------- //
              // Fórmula para ler a nova senha //
              // ----------------------------- //
              for iI := 1 to (Length(sSenha) div 5) do
              begin
                s := Chr((StrToInt(
                              Copy(sSenha,(iI*5)-4,5)
                              )+((Length(sSenha) div 5)-iI+1)*7) div 137) + s;
              end;

              if Mais1Ini.ReadString(sSecoes[I],'Chave','') <> '' then
              begin
                WriteLN(F,'insert into usuarios (EMITENTE, NOME, SENHA, STATUS) values ('
                  +QuotedStr(sCNPJ)+', '
                  +QuotedStr(sSecoes[I])+', '
                  +QuotedStr(s)+', '
                  +QuotedStr(
                    StrTran(StrTran(StrTran(
                    Mais1Ini.ReadString(sSecoes[I],'B1','1')+  // NFCE/NFE/Orçamento
                    Mais1Ini.ReadString(sSecoes[I],'B2','1')+  // Estoque
                    Mais1Ini.ReadString(sSecoes[I],'B3','1')+  // Cadastro
                    Mais1Ini.ReadString(sSecoes[I],'B5','1')       // Caixa
                    ,'1','X'),'0','1'),'X','0') // Xoor - Inverte 0 pra um e 1 pra zero
                    )+');');
              end;
            end;
          end;
        end;

        CloseFile(F);
      except
        try
          CloseFile(F);
        except
        end;
      end;
      {$Endregion}

      {$Region'//// Emitentes ////'}
      try
        //Mauricio Parizotto 2024-07-15
        AssignFile(F,pchar(Form1.sAtual+'\emitente.sql'));
        Rewrite(F);
        WriteLN(F,'delete from emitentes where cpf_cnpj = '+QuotedStr(sCNPJ)+'; '); // Apaga somente as inf atuais deste CNPJ

        WriteLN(F,'Insert into emitentes (nome_razao_social, contato, endereco, bairro, municipio, cep, uf, cpf_cnpj, ie, fone, email, site, im, crt, cnae) values ('+
                 QuotedStr(Copy(ConverteAcentosPHP(Form7.ibDataSet13.FieldByname('NOME').AsString),1,60)) +','+
                 QuotedStr(Copy(ConverteAcentosPHP(Form7.ibDataSet13.FieldByname('CONTATO').AsString),1,35)) +','+
                 QuotedStr(Copy(ConverteAcentosPHP(Form7.ibDataSet13.FieldByname('ENDERECO').AsString),1,35)) +','+
                 QuotedStr(Copy(ConverteAcentosPHP(Form7.ibDataSet13.FieldByname('COMPLE').AsString),1,20)) +','+
                 QuotedStr(Copy(ConverteAcentosPHP(Form7.ibDataSet13.FieldByname('MUNICIPIO').AsString),1,40)) +','+
                 QuotedStr(Copy(Form7.ibDataSet13.FieldByname('CEP').AsString,1,9)) +','+
                 QuotedStr(Copy(Form7.ibDataSet13.FieldByname('ESTADO').AsString,1,2)) +','+
                 QuotedStr(sCNPJ)+','+
                 QuotedStr(Copy(Form7.ibDataSet13.FieldByname('IE').AsString,1,16)) +','+
                 QuotedStr(Copy(Form7.ibDataSet13.FieldByname('TELEFO').AsString,1,16)) +','+
                 QuotedStr(Copy(Form7.ibDataSet13.FieldByname('EMAIL').AsString,1,132)) +','+
                 QuotedStr(Copy(ConverteAcentosPHP(Form7.ibDataSet13.FieldByname('HP').AsString),1,130)) +','+
                 QuotedStr(Copy(Form7.ibDataSet13.FieldByname('IM').AsString,1,16)) +','+
                 QuotedStr(Copy(Form7.ibDataSet13.FieldByname('CRT').AsString,1,1)) +','+
                 QuotedStr(Copy(Form7.ibDataSet13.FieldByname('CNAE').AsString,1,8)) +
                ');');

        CloseFile(F);
      except
        try
          CloseFile(F);
        except
        end;
      end;
      {$Endregion}

      Form7.LbBlowfish1.GenerateKey(Form1.sPasta);

      // Envia os arquivos
      // logo.jpg
      if FileExists(Form1.sAtual+'\LOGOTIP.BMP') then
      begin
        Rect.Top := 0;
        Rect.Left := 0;
        Rect.Right := 360;
        Rect.Bottom := 90;

        Form1.Image1.Picture.LoadFromFile(Form1.sAtual+'\LOGOTIP.BMP');
        Form1.Image1.Canvas.stretchdraw(Rect,Form1.Image1.Picture.Graphic);

        Form1.Image1.Picture.Bitmap.Width  := 360;
        Form1.Image1.Picture.Bitmap.Height := 90;

        jp := TJPEGImage.Create;
        jp.Assign(Form1.Image1.Picture.Bitmap);
        jp.CompressionQuality := 100;
        jp.SaveToFile('logo.jpg');
      end;

      if sP1 then
      begin
        try
          Form7.ibDataSet4.First;
          while not Form7.ibDAtaSet4.Eof do
          begin
            if FileExists(Form1.sAtual+'\_m_'+Form7.ibDataset4CODIGO.AsString+'.jpg') then
              UploadMobile(pChar('_m_'+Form7.ibDataset4CODIGO.AsString+'.jpg'));
            DeleteFile(pChar('_t_'+Form7.ibDataset4CODIGO.AsString+'.jpg'));
            Form7.ibDataSet4.Next;
          end;
        except
        end;
      end;

      UploadMobile(pChar('clifor.sql'));
      UploadMobile(pChar('usuarios.sql'));
      UploadMobile(pChar('estoque.sql'));
      UploadMobile(pChar('logo.jpg'));
      UploadMobile(pChar('emitente.sql'));//Mauricio Parizotto 2024-07-15

      DeleteFile(pChar(Form1.sAtual+'\usuarios.sql'));
    end else
    begin
      MensagemSistema('CNPJ do emitente inválido.',msgAtencao);
    end;
  except
  end;

  Result := True;
end;


end.
