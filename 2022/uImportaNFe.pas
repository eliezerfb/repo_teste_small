(*
Rotina para realizar a importação de NF-e
*)
unit uImportaNFe;

interface

uses
  Controls
  , SysUtils
  , XMLIntf
  , xmldom
  , XMLDoc
  , Forms
  , Windows
  , Dialogs
  , DB
  , SmallFunc
  , Mais
  , unit7
  , Unit24
  ;

function ImportaNF(pP1: boolean; sP1: String):Boolean;

implementation

function ImportaNF(pP1: boolean; sP1: String):Boolean;
var
  //
  NodePrim, NodePai, NodeSec, NodeTmp: IXMLNode; // Node é um nó do XML
  Hora, Min, Seg, cent : Word;
  tInicio : tTime;
  sXML,
  sICMSTag,
  sNomeDaEmpresa,
  sIPI     ,
  sICMS    ,
  spICMS   ,
  sBC      ,
  sICMSST  ,
  spREDBC  ,
  spIPI    ,
  sCSTIPI  ,
  sCSTICMS ,
  sBCST    : String;
  sCodigoDeBarrasDoFornecedor : String;
  bProdutoCadastrado : Boolean;
  sCnpjCpf: String; // Sandro Silva 2023-02-22
  svBCFCP: String;
  spFCP: String;
  svFCP: String;
  svBCFCPST: String;
  spFCPST: String;
  svFCPST: String;
  //
begin
  //
  Result := True;
  //
  try
    //
//    sP1 := AnsiToUTF8(sP1);
    // Tira o cariage return (CR) e Line Fid (LF)
    //
    //
    if AllTrim(sP1) = '' then
    begin
      //
      // Importa de um arquivo XML informado pelo usuário
      //
      Form7.OpenDialog1.FileName := '';
      Form7.OpenDialog1.Title    := 'Importar Nota Fiscal';
      //
      if not Form7.OpenDialog1.Execute then
        Exit;
      if LowerCase(Right(Form7.OpenDialog1.FileName,4))='.xml' then
      begin
        try
          Form7.XMLDocument1.DOMVendor := GetDOMVendor('Open XML');
          Form7.XMLDocument1.LoadFromFile(Form7.OpenDialog1.FileName);
        except
          Form7.XMLDocument1.DOMVendor := GetDOMVendor('MSXML');
          Form7.XMLDocument1.LoadFromFile(Form7.OpenDialog1.FileName);
        end;
      end;
      //
      // Novo
      //
      Form7.Image101Click(Form7.Image201);
      //
    end else
    begin
      //
      // Importa atravez do XML gravado no COMPRAS automaticamento por download (ConsultarDistribuicaoDFeChave)
      //
      try
        Form7.XMLDocument1.DOMVendor := GetDOMVendor('Open XML');
        Form7.XMLDocument1.XML.Text  := sP1;
      except
        Form7.XMLDocument1.DOMVendor := GetDOMVendor('MSXML');
        Form7.XMLDocument1.XML.Text  := sP1;
      end;
      //
      try
        Form7.XMLDocument1.Active    := True;
      except
        on E: Exception do
        begin
          Application.MessageBox(pChar(E.Message),'Erro 1 importa NF',mb_Ok + MB_ICONWARNING);
        end;
      end;
      //
      // Alterar
      //
      try
        Form7.Image106Click(Form7.Image206);
      except
        on E: Exception do
        begin
          Application.MessageBox(pChar(E.Message),'Erro 2 importa NF',mb_Ok + MB_ICONWARNING);
        end;
      end;
      //
    end;
  except
    on E: Exception do
    begin
      Application.MessageBox(pChar(E.Message),'Erro 3 importa NF',mb_Ok + MB_ICONWARNING);
    end;
  end;
  //
  Screen.Cursor            := crHourGlass;
  tInicio := time;
  //
  try
    sXML := Form7.XMLDocument1.XML.Text;
  except
    on E: Exception do
    begin
      Application.MessageBox(pChar(E.Message),'Erro ao caregar XML da NF-e',mb_Ok + MB_ICONWARNING);
    end;
  end;
  //
  try
    //
    Form7.ibDataset2.DisableControls;
    Form7.ibDataset23.DisableControls;
    Form7.ibDataset24.DisableControls;
    Form7.ibDataset4.DisableControls;
    //
    try
      //
      if AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//nfeProc/NFe/infNFe/ide/mod')) = '55' then
      begin
        //
        NodePrim := Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe');
        NodePai  := NodePrim.ChildNodes.FindNode('infNFe');
        NodeSec  := NodePai.ChildNodes.FindNode('emit');
        NodeSec.ChildNodes.First;
        //
        Form7.ibDataSet2.Close;
        Form7.ibDataSet2.Selectsql.Clear;
        Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR');  //
        Form7.ibDataSet2.Open;
        //
        sNomeDaEmpresa := PrimeiraMaiuscula(AllTrim(Copy(CaracteresHTML((AllTrim(XmlNodeValue(NodeSec.ChildNodes['xNome'].XML,'//xNome'))))+replicate(' ',60),1,60)));
        {Sandro Silva 2023-02-22 inicio}
        sCnpjCpf := Trim(NodeSec.ChildNodes['CNPJ'].Text);
        if sCnpjCpf = '' then
          sCnpjCpf := Trim(NodeSec.ChildNodes['CPF'].Text);
        {Sandro Silva 2023-02-22 fim}

        //
        // Sandro Silva 2023-02-22 if (not Form7.IBDataSet2.Locate('CGC',ConverteCpfCgc(AllTrim(NodeSec.ChildNodes['CNPJ'].Text)),[])) or (AllTrim(Form7.IBDataSet2NOME.AsString) = '') then
        if (not Form7.IBDataSet2.Locate('CGC',ConverteCpfCgc(Trim(sCnpjCpf)),[])) or (AllTrim(Form7.IBDataSet2NOME.AsString) = '') then
        begin
          //
          Form7.IBDataSet2.Append;
          Form7.IBDataSet2CGC.AsString  := ConverteCpfCgc(Trim(sCnpjCpf)); // Sandro Silva 2023-02-22 Form7.IBDataSet2CGC.AsString  := ConverteCpfCgc(AllTrim(NodeSec.ChildNodes['CNPJ'].Text));
          //
          Form1.ibQuery2.Close;
          Form1.ibQuery2.SQL.Clear;
          Form1.ibQuery2.SQL.Add('select * from CLIFOR where Upper(NOME)='+QuotedStr(UpperCase(sNomeDaEmpresa)));
          Form1.ibQuery2.Open;
          //
          while sNomeDaEmpresa = Form1.IBQuery2.FieldByName('NOME').AsString do
          begin
            //
            sNomeDaEmpresa := Copy(sNomeDaEmpresa,1,Length(sNomeDaEmpresa)-2);
            //
            Form1.ibQuery2.Close;
            Form1.ibQuery2.SQL.Clear;
            Form1.ibQuery2.SQL.Add('select * from CLIFOR where NOME='+QuotedStr(sNomeDaEmpresa));
            Form1.ibQuery2.Open;
          end;
          //
          Form7.IBDataSet2NOME.AsString := sNomeDaEmpresa;
          Form7.IBDataSet2IE.AsString   := AllTrim(NodeSec.ChildNodes['IE'].Text);
          //
          NodeTmp  := NodeSec.ChildNodes['enderEmit']; // tag <prod> dentro de <det>
          NodeTmp.ChildNodes.First;
          //
          Form7.IBDataSet2ENDERE.AsString := PrimeiraMaiuscula(CaracteresHTML((AllTrim(XmlNodeValue(NodeTmp.ChildNodes['xLgr'].XML,'//xLgr'))))+' '+AllTrim(NodeTmp.ChildNodes['nro'].Text));
          Form7.IBDataSet2COMPLE.AsString := PrimeiraMaiuscula(CaracteresHTML((AllTrim(XmlNodeValue(NodeTmp.ChildNodes['xBairro'].XML,'//xBairro')))));
          Form7.IBDataSet2CIDADE.AsString := CaracteresHTML((AllTrim(XmlNodeValue(NodeTmp.ChildNodes['xMun'].XML,'//xMun'))));
          Form7.IBDataSet2ESTADO.AsString := AllTrim(NodeTmp.ChildNodes['UF'].Text);
          Form7.IBDataSet2CEP.AsString    := Copy(AllTrim(NodeTmp.ChildNodes['CEP'].Text+'00000000'),1,5)+'-'+Copy(AllTrim(NodeTmp.ChildNodes['CEP'].Text+'00000000'),5,3);
          Form7.IBDataSet2FONE.AsString   := '(0xx'+Copy(AllTrim(NodeTmp.ChildNodes['fone'].Text+'         '),1,2)+')'+Copy(AllTrim(NodeTmp.ChildNodes['fone'].Text+'         '),2,9);
          Form7.IBDataSet2.Post;
          //
        end
        else
        begin
          sNomeDaEmpresa := Form7.IBDataSet2NOME.AsString;
        end;
        //
        NodePrim := Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe');
        NodePai  := NodePrim.ChildNodes.FindNode('infNFe');
        NodeSec  := NodePai.ChildNodes.FindNode('ide');
        //
        NodeSec.ChildNodes.First;
        //
        // ShowMessage('*'+NodeSec.ChildNodes['serie'].Text+'*');
        //
        Form7.ibDataset99.Close;
        Form7.ibDataset99.SelectSql.Clear;
        Form7.ibDataset99.SelectSql.Add('select NUMERONF from COMPRAS where NUMERONF='+QuotedStr( Right(StrZero(StrToFloat(NodeSec.ChildNodes['nNF'].Text),9,0),9)+StrZero(StrToInt(LimpaNumero('0'+NodeSec.ChildNodes['serie'].Text)),3,0) )+' and FORNECEDOR='+QuotedStr(sNomeDaEmpresa)+' ');
        Form7.IBDataSet99.Open;
        //
        if (AllTrim(Form7.ibDAtaSet99.FieldByname('NUMERONF').AsString) <> '') and (sP1='') then
        begin
          //
          ShowMessage('Nota Fiscal Já Cadastrada.');
          Form24.Close;
          //
          Form7.sModulo := 'DUPLA';
          Form7.ibDataSet24.Delete;
          Form7.sModulo := 'COMPRA';
          //
          Abort;
          //
        end
        else
        begin
          //
          Form7.ibDataSet24.Edit;
          Form7.ibDataSet24FORNECEDOR.AsString := Form7.IBDataSet2NOME.AsString;
          Form7.ibDataSet24FRETE12.AsString    := '1';
          Form7.ibDataSet24MODELO.AsString     := '55';
          Form7.ibDataSet24EMISSAO.Value       := Date;
          //
          Form24.Label64.Caption := 'Mod: '+Form7.ibDataSet24MODELO.AsString;
          //
          if not Form7.ibDataSet14.Locate('CFOP','2102',[]) then
            Form7.ibDataSet14.Locate('CFOP','1102',[]);
          //
          Form7.ibDataSet24OPERACAO.AsString    := Form7.ibDataSet14NOME.AsString;
          //
          if pP1 then
          begin
            //
            Form7.ibDataSet24NUMERONF.AsString := Right(StrZero(StrToFloat(NodeSec.ChildNodes['nNF'].Text),9,0),9)+StrZero(StrToInt(LimpaNumero('0'+NodeSec.ChildNodes['serie'].Text)),3,0);// Número da NF
            //
            Form24.Edit2.Text := Right(StrZero(StrToFloat(NodeSec.ChildNodes['nNF'].Text),9,0),9)+'/'+StrZero(StrToInt(LimpaNumero('0'+NodeSec.ChildNodes['serie'].Text)),3,0);// Número da NF
            Form24.Edit2.Repaint;
          end
          else
          begin
            //
            Form7.ibDataset99.Close;
            Form7.ibDataset99.SelectSql.Clear;
            Form7.ibDataset99.SelectSql.Add('select gen_id(G_SERIE1,0) from rdb$database');
            Form7.IBDataSet99.Open;
            //
            Form7.ibDataSet24NUMERONF.AsString := StrZero(StrtoFloat(Form7.ibDataSet99.FieldByname('GEN_ID').AsString)+1,9,0)+'001'; // Número da NF
            Form7.IBDataSet99.Close;
            //
          end;
          //
          try
            NodePrim := Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('protNFe');
            NodePai  := NodePrim.ChildNodes.FindNode('infProt');
            //
            Form7.ibDataSet24SAIDAD.AsString := Copy(NodePai.ChildNodes['dhRecbto'].Text,9,2)+'/'+Copy(NodePai.ChildNodes['dhRecbto'].Text,6,2)+'/'+Copy(NodePai.ChildNodes['dhRecbto'].Text,1,4); // Data da saida
            Form7.ibDataSet24SAIDAH.AsString := Copy(NodePai.ChildNodes['dhRecbto'].Text,12,8);// Hora da saída
            //
          except
            ShowMessage('Verigique se esta NF-e foi autorizada');
          end;
          //
          NodePrim := Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe');
          NodePai  := NodePrim.ChildNodes.FindNode('infNFe');
          NodeSec  := NodePai.ChildNodes.FindNode('det');
          //
          NodeSec.ChildNodes.First;
          //
          Screen.Cursor            := crHourGlass;
          //
          repeat

            //
            //
            try
              NodeTmp  := NodeSec.ChildNodes['prod']; // tag <prod> dentro de <det>
              NodeTmp.ChildNodes.First;
            except
              on E: Exception do
              begin
                Application.MessageBox(pChar(E.Message),'Erro X importa NF',mb_Ok + MB_ICONWARNING);
              end;
            end;
            //

            if NodeTmp <> nil then
            begin
              try
                if Alltrim(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))) <> '' then
                begin
                  try
                    //
                    bProdutoCadastrado := False;
                    //
                    // Procura primeiro pelo Código de Barras cEAN
                    //
                    if (NodeTmp.ChildNodes['cEAN'].Text <> '') and (NodeTmp.ChildNodes['cEAN'].Text <> 'SEM GTIN')  then
                    begin
                      //
                      Form7.ibDataSet4.Close;
                      Form7.ibDataSet4.SelectSQL.Clear;
                      Form7.ibDataSet4.SelectSQL.Add('select * from ESTOQUE where REFERENCIA='+QuotedStr(NodeTmp.ChildNodes['cEAN'].Text)+' ');
                      Form7.ibDataSet4.Open;
                      //
                      if (AllTrim(Form7.ibDataSet4REFERENCIA.AsString) = AllTrim(NodeTmp.ChildNodes['cEAN'].Text)) and (AllTrim(Form7.ibDataSet4REFERENCIA.AsString) <> '') then
                      begin
                        bProdutoCadastrado := True;
                      end;
                      //
                    end;
                    //
                    if not bProdutoCadastrado then
                    begin
                      //
                      // Procura pelo CODIGO de Barras do fornecedor relacionado no arquivo CODEBAR
                      //
                      if (NodeTmp.ChildNodes['cEAN'].Text = '') or (NodeTmp.ChildNodes['cEAN'].Text = 'SEM GTIN')  then
                      begin
                        sCodigoDeBarrasDoFornecedor := AllTrim(NodeTmp.ChildNodes['cProd'].Text);
                      end else
                      begin
                        sCodigoDeBarrasDoFornecedor := NodeTmp.ChildNodes['cEAN'].Text;
                      end;
                      //
                      Form7.ibQuery1.Close;
                      Form7.ibQuery1.Sql.Clear;
                      Form7.ibQuery1.Sql.Add('select * from CODEBAR where FORNECEDOR='+QuotedStr(Form7.ibDataSet24FORNECEDOR.AsString)+' and EAN='+QuotedStr(sCodigoDeBarrasDoFornecedor)+' ');
                      Form7.ibQuery1.Open;
                      //
                      if AllTrim(Form7.ibQuery1.FieldByname('EAN').AsString) <> '' then
                      begin
                        //
                        sCodigoDeBarrasDoFornecedor := Form7.ibQuery1.FieldByname('CODIGO').AsString;
                        //
                        Form7.ibDataSet4.Close;
                        Form7.ibDataSet4.SelectSQL.Clear;
                        Form7.ibDataSet4.SelectSQL.Add('select * from ESTOQUE where CODIGO='+QuotedStr(sCodigoDeBarrasDoFornecedor)+' ');
                        Form7.ibDataSet4.Open;
                        //
                        if form7.ibDataSet4CODIGO.AsString = sCodigoDeBarrasDoFornecedor then
                        begin
                          bProdutoCadastrado := True;
                        end;
                        //
                      end;
                    end;
                    //
                    if not bProdutoCadastrado then
                    begin
                      //
                      //  Procura pelo código de barras / quando não tem descricao
                      //
                      Form7.ibQuery1.Close;
                      Form7.ibQuery1.Sql.Clear;
                      Form7.ibQuery1.Sql.Add('select * from CODEBAR where FORNECEDOR='+QuotedStr(Form7.ibDataSet24FORNECEDOR.AsString)+' and CODIGO='+QuotedStr(AllTrim(Form7.ibDataSet4CODIGO.AsString))+' ');
                      Form7.ibQuery1.Open;
                      //
                      if AllTrim(Form7.IBQuery1.FieldByName('EAN').AsString) = '' then
                      begin
                        //
                        Form7.ibDataSet4.Close;
                        Form7.ibDataSet4.SelectSQL.Clear;
                        Form7.ibDataSet4.SelectSQL.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(AllTrim(Copy(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))+Replicate(' ',45),1,45)))+' ');
                        Form7.ibDataSet4.Open;
                        //
                        if AllTrim(Form7.ibDataSet4CODIGO.AsString) <> '' then
                        begin
                          bProdutoCadastrado := True;
                        end else
                        begin
                          bProdutoCadastrado := False;
                        end;
                        //
                      end;
                    end;
                    //
                    if not bProdutoCadastrado then  // Não encontrou
                    begin
                      //
                      // Cria um novo produto
                      //
                      Form7.iKey := 0;
                      Form7.ibDataSet4.Append; // Importa NF XML
                      Form7.ibDataSet4REFERENCIA.AsString := NodeTmp.ChildNodes['cEAN'].Text;
                      //
                      //
                      //
                      if AllTrim(NodeTmp.ChildNodes['cProd'].Text) <> '' then
                      begin
                        //
                        // Inclui automaticamente no CODEBAR para saber numa futura compra do mesmo fornecedor que este código é referente a este produto
                        //
                        try
                          Form7.IBDataSet6.Append;
                          Form7.IBDataSet6CODIGO.AsString       := Form7.ibDataSet4CODIGO.AsString;
                          Form7.IBDataSet6EAN.AsString          := AllTrim(NodeTmp.ChildNodes['cProd'].Text);
                          Form7.IBDataSet6FORNECEDOR.AsString   := Form7.ibDataSet24FORNECEDOR.AsString;
                          Form7.IBDataSet6.Post;
                        except
                        end;
                      end;
                      //
                      // Procura para ver se já existe um nome igual
                      //
                      Form7.ibQuery1.Close;
                      Form7.ibQuery1.Sql.Clear;
                      Form7.ibQuery1.Sql.Add('select DESCRICAO from ESTOQUE where DESCRICAO='+QuotedStr(AllTrim(Copy(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))+Replicate(' ',45),1,45)))+' ');
                      Form7.ibQuery1.Open;
                      //
                      if Form7.IBQuery1.FieldByName('DESCRICAO').AsString = AllTrim(Copy(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))+Replicate(' ',45),1,45)) then
                      begin
                        //
                        // Se já existe cria o nome com o código no final
                        //
                        Form7.ibDataSet4DESCRICAO.AsString  := AllTrim(Copy(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))+Replicate(' ',39),1,39))+' '+Form7.ibDataSet4CODIGO.AsString;
                        //
                      end
                      else
                      begin
                        Form7.ibDataSet4DESCRICAO.AsString  := AllTrim(Copy(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))+Replicate(' ',39),1,39))+' '+Form7.ibDataSet4CODIGO.AsString;
                      end;
                      //
                      Form7.ibDataSet4MEDIDA.AsString     := AllTrim(NodeTmp.ChildNodes['uCom'].Text);
                      Form7.ibDataSet4PRECO.AsFloat       := 0.01;
                      Form7.ibDataSet4ALTERADO.AsString   := '3';
                      try
                        Form7.ibDataSet4CF.AsString     := AllTrim(Copy(NodeTmp.ChildNodes['NCM'].Text+Replicate(' ',45),1,45));
                      except
                      end;
                      try
                        Form7.ibDataSet4CEST.AsString   := AllTrim(Copy(NodeTmp.ChildNodes['CEST'].Text+Replicate(' ',7),1,7));
                      except
                      end;
                      Form7.ibDataSet4.Post;
                      //
                    end;
                    //
                    // FCI
                    //
                    if AllTrim(NodeTmp.ChildNodes['nFCI'].Text) <> '' then
                    begin
                      Form7.ibDataSet4.Edit;
                      Form7.ibDataSet4CODIGO_FCI.AsString := AllTrim(NodeTmp.ChildNodes['nFCI'].Text);
                      Form7.ibDataSet4.Edit;
                    end;
                    //
                    Form1.bFlag := False;
                    Form7.sModulo := 'NAO';
                    //
                    Form7.ibDAtaSet23.Append;
                    Form7.ibDataSet23CODIGO.AsString       := Form7.ibDataSet4CODIGO.AsString; // Importar NF
                    Form7.ibDataSet23DESCRICAO.AsString    := Form7.ibDataSet4DESCRICAO.AsString; // NodeTmp.ChildNodes['xProd'].Text;
                    Form7.ibDataSet23QTD_ORIGINAL.AsString := StrTran(NodeTmp.ChildNodes['qCom'].Text,'.',',');
                    Form7.ibDataSet23TOTAL.AsString        := StrTran(NodeTmp.ChildNodes['vProd'].Text,'.',',');
                    //
                    try
                      Form7.ibDataSet23UNITARIO_O.AsString   := StrTran(NodeTmp.ChildNodes['vUnCom'].Text,'.',',');
                    except
                    end;
                    //
                    if (NodeTmp.ChildNodes['cEAN'].Text = '') or (NodeTmp.ChildNodes['cEAN'].Text = 'SEM GTIN')  then
                    begin
                      Form7.ibDataSet23EAN_ORIGINAL.AsString := AllTrim(NodeTmp.ChildNodes['cProd'].Text);
                    end
                    else
                    begin
                      Form7.ibDataSet23EAN_ORIGINAL.AsString := NodeTmp.ChildNodes['cEAN'].Text;
                    end;
                    //
                    Form7.ibDataSet23.Post;
                    Form7.ibDataSet23.Edit;
                    //
                    // Impostos
                    //
                    try
                      //
                      Form7.ibDataSet23BASE.AsFloat       := 0;
                      Form7.ibDataSet23ICM.AsString          := '0';
                      //
                      //
                      // ICM
                      //
                      spICMS   := '0.00';
                      sPRedBC  := '0.00';
                      sICMS    := '0.00';
                      sBC      := '0.00';
                      sBCST    := '0.00';
                      sICMSST  := '0.00';
                      sIPI     := '0.00';
                      spIPI    := '0.00';
                      sCSTIPI  := '';
                      sCSTICMS := '';

                      {Sandro Silva 2023-04-10 inicio}
                      svBCFCP   := '0.00';
                      spFCP     := '0.00';
                      svFCP     := '0.00';
                      svBCFCPST := '0.00';
                      spFCPST   := '0.00';
                      svFCPST   := '0.00';
                      {Sandro Silva 2023-04-10 fim}

                      //
                      // Ver como resolver ester try Quando nao existem os campos
                      //
                      if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS00/CST')) <> '' then
                        sICMSTag := 'ICMS00';
                      if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS10/CST')) <> '' then
                      sICMSTag := 'ICMS10';
                      if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS20/CST')) <> '' then
                        sICMSTag := 'ICMS20';
                      if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS30/CST')) <> '' then
                        sICMSTag := 'ICMS30';
                      if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS40/CST')) <> '' then
                        sICMSTag := 'ICMS40';
                      if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS51/CST')) <> '' then
                        sICMSTag := 'ICMS51';
                      if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS60/CST')) <> '' then
                        sICMSTag := 'ICMS60';
                      if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS70/CST')) <> '' then
                        sICMSTag := 'ICMS70';
                      if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS90/CST')) <> '' then
                        sICMSTag := 'ICMS90';
                      //
                      if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMSSN101/CSOSN')) <> '' then
                        sICMSTag := 'ICMSSN101';
                      if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMSSN102/CSOSN')) <> '' then
                        sICMSTag := 'ICMSSN102';
                      if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMSSN201/CSOSN')) <> '' then
                        sICMSTag := 'ICMSSN201';
                      if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMSSN202/CSOSN')) <> '' then
                        sICMSTag := 'ICMSSN202';
                      if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMSSN500/CSOSN')) <> '' then
                        sICMSTag := 'ICMSSN500';
                      if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMSSN900/CSOSN')) <> '' then
                        sICMSTag := 'ICMSSN900';
                      //
                      if Assigned(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag)) then
                      begin
                        if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).XML, '//vICMS'))   <> '' then
                          sICMS    := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['vICMS'].Text;
                        if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).XML, '//vBC'))     <> '' then
                          sBC      := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['vBC'].Text;
                        if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).XML, '//vICMSST')) <> '' then
                          sICMSST  := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['vICMSST'].Text;
                        if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).XML, '//vBCST'))   <> '' then
                          sBCST    := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['vBCST'].Text;
                        if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).XML, '//pICMS'))   <> '' then
                          spICMS   := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['pICMS'].Text;
                        if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).XML, '//pRedBC'))  <> '' then
                          spREDBC  := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['pRedBC'].Text;
                        if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).XML, '//CST'))     <> '' then
                          sCSTICMS := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['orig'].Text + NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['CST'].Text;


                        {Sandro Silva 2023-04-10 inicio}
                        if Trim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).XML, '//vBCFCP')) <> '' then
                          svBCFCP := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['vBCFCP'].Text;

                        if Trim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).XML, '//pFCP')) <> '' then
                          spFCP := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['pFCP'].Text;

                        if Trim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).XML, '//vFCP')) <> '' then
                          svFCP := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['vFCP'].Text;

                        if Trim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).XML, '//vBCFCPST')) <> '' then
                          svBCFCPST := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['vBCFCPST'].Text;

                        if Trim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).XML, '//pFCPST')) <> '' then
                          spFCPST := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['pFCPST'].Text;

                        if Trim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).XML, '//vFCPST')) <> '' then
                          svFCPST := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['vFCPST'].Text;
                        {Sandro Silva 2023-04-10 fim}

                      end;
                      //
                      try
                        if Assigned(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('IPI')) then
                        begin
                          try
                            sIPI    := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('IPI').ChildNodes.FindNode('IPITrib').ChildNodes['vIPI'].Text;
                          except
                          end;
                          try
                            spIPI   := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('IPI').ChildNodes.FindNode('IPITrib').ChildNodes['pIPI'].Text;
                          except
                          end;
                          try
                            sCSTIPI := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('IPI').ChildNodes.FindNode('IPITrib').ChildNodes['CST'].Text;
                          except
                          end;
                        end;
                      except
                      end;
                      //
                      //      ShowMessage('vBCST: ' + sBCST + chr(10) +
                      //                  'vICMSST: ' + sICMSST);
                      //

                      // Ver como resolver ester try Quando nao existem os campos
                      //
                      try
                         Form7.ibDataSet23ICM.AsString       := StrTran(spICMS,'.',',');
                      except
                      end;
                      try
                         Form7.ibDataSet23BASE.AsFloat       := 100 - StrToFloat(StrTran(sPRedBC,'.',','));
                      except
                      end;
                      try
                        Form7.ibDataSet23VICMS.AsString     := StrTran(sICMS,'.',',');
                      except
                      end;
                      try
                        Form7.ibDataSet23VBC.AsString       := StrTran(sBC,'.',',');
                      except
                      end;
                      try
                        Form7.ibDataSet23VBCST.AsString     := StrTran(sBCST,'.',',');
                      except
                      end;
                      try
                        Form7.ibDataSet23vICMSST.AsString   := StrTran(sICMSST,'.',',');
                      except
                      end;
                      try
                        Form7.ibDataSet23vIPI.AsString      := StrTran(sIPI,'.',',');
                      except
                      end;
                      try
                        Form7.ibDataSet23IPI.AsString       := StrTran(spIPI,'.',',');
                      except
                      end;
                      try
                        Form7.ibDataSet23CST_IPI.AsString   := sCSTIPI;
                      except
                      end;
                      try
                        Form7.ibDataSet23CST_ICMS.AsString  := sCSTICMS;
                      except
                      end;
                      try
                        Form7.ibDataSet23CFOP.AsString   := Copy(Form7.ibDataSet14CFOP.AsString,1,1)+Copy(NodeTmp.ChildNodes['CFOP'].Text,2,3);
                      except
                      end;

                      {Sandro Silva 2023-04-11 inicio}
                      try
                        Form7.ibDataSet23VBCFCP.AsString := StringReplace(svBCFCP, '.', ',', [rfReplaceAll]);
                      except
                      end;

                      try
                        Form7.ibDataSet23PFCP.AsString := StringReplace(spFCP, '.', ',', [rfReplaceAll]);
                      except
                      end;

                      try
                        Form7.ibDataSet23VFCP.AsString := StringReplace(svFCP, '.', ',', [rfReplaceAll]);
                      except
                      end;

                      try
                        Form7.ibDataSet23VBCFCPST.AsString := StringReplace(svBCFCPST, '.', ',', [rfReplaceAll]);
                      except
                      end;

                      try
                        Form7.ibDataSet23PFCPST.AsString := StringReplace(spFCPST, '.', ',', [rfReplaceAll]);
                      except
                      end;

                      try
                        Form7.ibDataSet23VFCPST.AsString := StringReplace(svFCPST, '.', ',', [rfReplaceAll]);
                      except
                      end;
                      {Sandro Silva 2023-04-11 fim}
                      //
                      Form7.ibDataSet23.Post;
                      Form7.ibDataSet23.Edit;
                      //
                    except
                    end;
                    //
                  except end;
                end;
              except
                ShowMessage('Erro ao ler o produto código: '+sCodigoDeBarrasDoFornecedor+chr(10)+chr(10)+
                            'Este item não foi importado. Deve ser digitado manualmente.'+chr(10));

              end;
              //
            end;
            //
            NodeSec := NodeSec.NextSibling; // Next
            NodeTmp.ChildNodes.Clear;
            //
          until NodeSec = nil;
          //
          try Form7.ibDataSet24.Edit; except end;
          //
          try Form7.ibDataSet24NFEID.VAlue          := Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('protNFe').ChildNodes.FindNode('infProt').ChildNodes.FindNode('chNFe').Text;  except end;
          try Form7.ibDataSet24ICMSSUBSTI.AsString  := StrTran(Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe').ChildNodes.FindNode('infNFe').ChildNodes.FindNode('total').ChildNodes.FindNode('ICMSTot').ChildNodes.FindNode('vST').Text,'.',','); except end;
          try Form7.ibDataSet24BASESUBSTI.AsString  := StrTran(Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe').ChildNodes.FindNode('infNFe').ChildNodes.FindNode('total').ChildNodes.FindNode('ICMSTot').ChildNodes.FindNode('vBCST').Text,'.',','); except end;
          try Form7.ibDataSet24DESCONTO.AsString    := StrTran(Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe').ChildNodes.FindNode('infNFe').ChildNodes.FindNode('total').ChildNodes.FindNode('ICMSTot').ChildNodes.FindNode('vDesc').Text,'.',','); except end;
          try Form7.ibDataSet24FRETE.AsString       := StrTran(Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe').ChildNodes.FindNode('infNFe').ChildNodes.FindNode('total').ChildNodes.FindNode('ICMSTot').ChildNodes.FindNode('vFrete').Text,'.',','); except end;
          try Form7.ibDataSet24DESPESAS.AsString    := StrTran(Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe').ChildNodes.FindNode('infNFe').ChildNodes.FindNode('total').ChildNodes.FindNode('ICMSTot').ChildNodes.FindNode('vOutro').Text,'.',','); except end;
          try Form7.ibDataSet24SEGURO.AsString      := StrTran(Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe').ChildNodes.FindNode('infNFe').ChildNodes.FindNode('total').ChildNodes.FindNode('ICMSTot').ChildNodes.FindNode('vSeg').Text,'.',','); except end;
          //
          try
            Form7.ibDataSet24NFEXML.AsString := sXML;
          except
            ShowMessage('Não foi possível gravar o XML');
          end;
          //
          try
            Form7.ibDataSet24.Post;
            Form1.bFlag := True;
            Form7.sModulo := 'COMPRA';
            if not (Form7.ibDataset23.State in ([dsEdit, dsInsert])) then
              Form7.ibDataset23.Edit;
            Form7.ibDataSet23DESCRICAOChange(Form7.ibDataSet23DESCRICAO);
          except
            on E: Exception do
            begin
              Application.MessageBox(pChar(E.Message),'Erro 10 importa NF',mb_Ok + MB_ICONWARNING);
            end;
          end;
          //
        end;
        //
      end;
      //
      // Conhecimento de Transporte Eletrônico
      //
      if AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/mod')) = '57' then
      begin
        //
        // CT-e
        //
        //
        Form7.ibDataSet2.Close;
        Form7.ibDataSet2.Selectsql.Clear;
        Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR');  //
        Form7.ibDataSet2.Open;
        //
        if not Form7.IBDataSet2.Locate('CGC',ConverteCpfCgc(AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//emit/CNPJ'))),[]) then
        begin
          Form7.IBDataSet2.Append;
          Form7.IBDataSet2CGC.AsString    := ConverteCpfCgc(AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//emit/CNPJ')));
          Form7.IBDataSet2NOME.AsString   := AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//emit/xNome'));
          Form7.IBDataSet2IE.AsString     := AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//emit/IE'));
          Form7.IBDataSet2ENDERE.AsString := AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//emit/enderEmit/xLgr'))+' '+AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//emit/enderEmit/nro'));
          Form7.IBDataSet2COMPLE.AsString := AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//emit/enderEmit/xBairro'));
          Form7.IBDataSet2CIDADE.AsString := AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//emit/enderEmit/xMun'));
          Form7.IBDataSet2ESTADO.AsString := AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//emit/enderEmit/UF'));
          Form7.IBDataSet2CEP.AsString    := Copy(AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//emit/enderEmit/CEP'))+'00000',1,5)+'-'+Copy(AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//emit/enderEmit/CEP'))+'00000000',6,3);
          Form7.IBDataSet2FONE.AsString   := '(0xx'+Copy(AllTrim( AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//emit/enderEmit/fone'))  +'         '),1,2)+')'+Copy(AllTrim(AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//emit/enderEmit/fone'))+'         '),2,9);
          Form7.IBDataSet2.Post;
          //
        end;
        //
        Form7.ibDataset99.Close;
        Form7.ibDataset99.SelectSql.Clear;
        Form7.ibDataset99.SelectSql.Add('select NUMERONF from COMPRAS where NUMERONF='+QuotedStr( Right(StrZero(StrToFloat(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/nCT')),9,0),9)+StrZero(StrToInt(LimpaNumero('0'+xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/serie'))),3,0) )+' and FORNECEDOR='+QuotedStr(Form7.IBDataSet2NOME.AsString)+' ');
        Form7.IBDataSet99.Open;
        //
        if Form7.ibDAtaSet99.FieldByname('NUMERONF').AsString =Right(StrZero(StrToFloat(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/nCT')),9,0),9)+StrZero(StrToInt(LimpaNumero('0'+xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/serie'))),3,0) then
        begin
          //
          ShowMessage('Nota Fiscal Já Cadastrada.');
          Form24.Close;
          Form7.ibDataSet24.Delete;
          //
        end else
        begin
          //
          Form7.ibDataSet24.Edit;
          Form7.ibDataSet24FORNECEDOR.AsString := Form7.IBDataSet2NOME.AsString;
          Form7.ibDataSet24MODELO.AsString     := '57';
          //
          Form24.Label64.Caption := 'Mod: '+Form7.ibDataSet24MODELO.AsString;
          //
          if Form7.IBDataSet2ESTADO.AsString <> Form7.IBDataSet13ESTADO.AsString then
          begin
            if not Form7.ibDataSet14.Locate('CFOP','2'+copy(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/CFOP'),2,3),[]) then
            begin
              Form7.ibDataSet14.Append;
              Form7.ibDataSet14CFOP.AsString := '2'+copy(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/CFOP'),2,3);
              Form7.ibDataSet14NOME.AsString := xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/natOp');
              Form7.ibDataSet14.Post;
            end;
          end else
          begin
            if not Form7.ibDataSet14.Locate('CFOP','1'+copy(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/CFOP'),2,3),[]) then
            begin
              Form7.ibDataSet14.Append;
              Form7.ibDataSet14CFOP.AsString := '1'+copy(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/CFOP'),2,3);
              Form7.ibDataSet14NOME.AsString := xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/natOp');
              Form7.ibDataSet14.Post;
            end;
          end;
          //
          Form7.ibDataSet24OPERACAO.AsString    := Form7.ibDataSet14NOME.AsString;
          Form7.ibDataSet24NUMERONF.AsString := Right(StrZero(StrToFloat(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/nCT')),9,0),9)+StrZero(StrToInt(LimpaNumero('0'+xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/serie'))),3,0);
          Form24.Edit2.Text := Right(StrZero(StrToFloat(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/nCT')),9,0),9)+'/'+StrZero(StrToInt(LimpaNumero('0'+xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/serie'))),3,0);
          Form24.Edit2.Repaint;
          //
          Form7.ibDataSet24SAIDAD.AsString := Copy(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/dhEmi'),9,2)+'/'+Copy(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/dhEmi'),6,2)+'/'+Copy(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/dhEmi'),1,4); // Data da saida
          Form7.ibDataSet24SAIDAH.AsString := Copy(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/dhEmi'),12,8);// Hora da saída
          Form7.ibDataSet24NFEID.AsString  := xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/protCTe/infProt/chCTe'); // COVID19
          //
          Form1.bFlag := False;
          Form7.sModulo := 'NAO';
          //
          if not Form7.ibDataSet4.Locate('DESCRICAO','Frete',[]) then
          begin
            Form7.ibDataSet4.Append;  // Inclui um produto chamado FRETE
            Form7.ibDataSet4.Edit;
            Form7.ibDataSet4DESCRICAO.AsString := 'Frete';
            Form7.ibDataSet4.Post;
          end;
          //
          try
            Form7.ibDAtaSet23.Append;
            Form7.ibDataSet23CODIGO.AsString     := Form7.ibDataSet4CODIGO.AsString; // Importar NF
            Form7.ibDataSet23DESCRICAO.AsString  := Form7.ibDataSet4DESCRICAO.AsString;
            Form7.ibDataSet23QUANTIDADE.AsString := '1';
          except
          end;
          //
          try
            Form7.ibDataSet23UNITARIO_O.AsString :=  StrTran(AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//imp/ICMS/ICMS00/vBC')),'.',',');
            Form7.ibDataSet23ICM.AsString        :=  StrTran(AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//imp/ICMS/ICMS00/pICMS')),'.',',');
            Form7.ibDataSet23VICMS.AsString      :=  StrTran(AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//imp/ICMS/ICMS00/vICMS')),'.',',');
            Form7.ibDataSet23vBC.AsString        :=  StrTran(AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//imp/ICMS/ICMS00/vBC')),'.',',');
          except
          end;
          //
          try
            Form7.ibDataSet23.Post;
            Form7.ibDataSet23.Edit;
          except
            on E: Exception do
            begin
              Application.MessageBox(pChar(E.Message),'Erro 11 importa NF',mb_Ok + MB_ICONWARNING);
            end;
          end;
          //
        end;
        //
      end;
      //
    except
      on E: Exception do
      begin
        Application.MessageBox(pChar(E.Message),'Estrutura do arquivo XML da NF-e inválida.',mb_Ok + MB_ICONWARNING);
      end;
    end;
    //
  except
    on E: Exception do
    begin
      Application.MessageBox(pChar(E.Message),'Erro ao importar XML da NF-e',mb_Ok + MB_ICONWARNING);
    end;
  end;
  //
  try
    //
    Form1.bFlag := True;
    Form7.sModulo := 'COMPRA';
    //
    DecodeTime((Time - tInicio), Hora, Min, Seg, cent);
    //
  except end;
  //
  try
    Form7.ibDataset2.EnableControls
  except
  end;
  try
    Form7.ibDataset23.EnableControls
  except
  end;
  try
    Form7.ibDataset24.EnableControls
  except
  end;
  try
    Form7.ibDataset4.EnableControls
  except
  end;
  //
  //
  Screen.Cursor            := crDefault;
  //
  // ShowMessage('Tempo: '+TimeToStr(Time - tInicio)+' ´ '+StrZero(cent,3,0)+chr(10));
  //
  // Fim
  //
end;

end.
