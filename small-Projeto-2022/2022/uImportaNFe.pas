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
  , smallfunc_xe
  , Mais
  , unit7
  , Unit24
  , IBQuery
  , uItensInativosImpXMLEntrada
  ;

function ImportaNF(pP1: boolean; sP1: String):Boolean;
function GetICMSTag(NodeSec:IXMLNode):string;

implementation

uses uFuncoesRetaguarda, uParametroTributacao, uDialogs,
  uFuncoesBancoDados;

function ImportaNF(pP1: boolean; sP1: String):Boolean;
  function RetornarCodProdInativo: String;
  begin
    Result := QuotedStr(Form7.ibDataSet4CODIGO.AsString) + ',';
  end;
var
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
  spICMSST, // 2024-03-21
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
  svICMSDESON: String;

  sIdDest : integer;
  sIniCFOP : string;
  sItens: String;

  IBQConversaoCFOP: TIBQuery;
  SizeDescricaoProd : integer;

  CaminhoArquivo : string;

  CST_Conv, CSOSN_Conv, Filtro_Conv : string;
begin
  Result := True;

  try
    SizeDescricaoProd := TamanhoCampoFB(Form7.IBDatabase1,'ESTOQUE','DESCRICAO');

    if AllTrim(sP1) = '' then
    begin
      // Importa de um arquivo XML informado pelo usuário
      Form7.OpenDialog1.FileName := '';
      Form7.OpenDialog1.Filter := 'XML|*.xml';  //Mauricio Parizotto 2024-02-15
      Form7.OpenDialog1.Title    := 'Importar Nota Fiscal';

      if not Form7.OpenDialog1.Execute then
      begin
        Form7.OpenDialog1.Filter := '';
        Exit;
      end;

      Form7.OpenDialog1.Filter := '';

      //Mauricio Parizotto 2024-02-01
      CaminhoArquivo := Form7.OpenDialog1.FileName;
      if pos('.',CaminhoArquivo) = 0 then
        CaminhoArquivo := CaminhoArquivo+'.xml';

      if not FileExists(CaminhoArquivo) then
        Exit;

      //if LowerCase(Right(Form7.OpenDialog1.FileName,4))='.xml' then
      if LowerCase(Right(CaminhoArquivo,4))='.xml' then
      begin
        try
          Form7.XMLDocument1.DOMVendor := GetDOMVendor('Open XML');
          //Form7.XMLDocument1.LoadFromFile(Form7.OpenDialog1.FileName); Mauricio Parizotto 2024-02-01
          Form7.XMLDocument1.LoadFromFile(CaminhoArquivo);
        except
          Form7.XMLDocument1.DOMVendor := GetDOMVendor('MSXML');
          //Form7.XMLDocument1.LoadFromFile(Form7.OpenDialog1.FileName); Mauricio Parizotto 2024-02-01
          Form7.XMLDocument1.LoadFromFile(CaminhoArquivo);
        end;
      end;

      // Novo
      Form7.Image101Click(Form7.imgNovo);
    end else
    begin
      // Importa atravez do XML gravado no COMPRAS automaticamento por download (ConsultarDistribuicaoDFeChave)
      try
        Form7.XMLDocument1.DOMVendor := GetDOMVendor('Open XML');
        Form7.XMLDocument1.XML.Text  := sP1;
      except
        Form7.XMLDocument1.DOMVendor := GetDOMVendor('MSXML');
        Form7.XMLDocument1.XML.Text  := sP1;
      end;

      try
        Form7.XMLDocument1.Active    := True;
      except
        on E: Exception do
        begin
          //Application.MessageBox(pChar(E.Message),'Erro 1 importa NF',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
          MensagemSistema(E.Message+' Erro 1 importa NF',msgErro);
        end;
      end;

      // Alterar
      try
        Form7.Image106Click(Form7.imgEditar);
      except
        on E: Exception do
        begin
          //Application.MessageBox(pChar(E.Message),'Erro 2 importa NF',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
          MensagemSistema(E.Message+' Erro 2 importa NF',msgErro);
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      //Application.MessageBox(pChar(E.Message),'Erro 3 importa NF',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
      MensagemSistema(E.Message+' Erro 3 importa NF',msgErro);
    end;
  end;
  Form7.bDescontaICMSDeso := False;

  Screen.Cursor            := crHourGlass;
  tInicio := time;

  try
    sXML := Form7.XMLDocument1.XML.Text;
  except
    on E: Exception do
    begin
      //Application.MessageBox(pChar(E.Message),'Erro ao caregar XML da NF-e',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
      MensagemSistema(E.Message+' Erro ao caregar XML da NF-e',msgErro);
    end;
  end;

  try
    Form7.ibDataset2.DisableControls;
    Form7.ibDataset23.DisableControls;
    //LogRetaguarda('uimportanfe ibDataSet23.DisableControls 156'); // Sandro Silva 2023-12-04
    Form7.ibDataset24.DisableControls;

    //LogRetaguarda('ibDataSet24.DisableControls; 158'); // Sandro Silva 2023-11-27

    Form7.ibDataset4.DisableControls;

    //Mauricio Parizotto 2023-05-02
    sIdDest := StrToIntDef(AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//nfeProc/NFe/infNFe/ide/idDest')),1);

    //1 dentro do estado 2 fora do estado
    if sIdDest = 1 then
      sIniCFOP := '1'
    else
      sIniCFOP := '2';

    try
      if AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//nfeProc/NFe/infNFe/ide/mod')) = '55' then
      begin
        NodePrim := Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe');
        NodePai  := NodePrim.ChildNodes.FindNode('infNFe');
        NodeSec  := NodePai.ChildNodes.FindNode('emit');
        NodeSec.ChildNodes.First;

        Form7.ibDataSet2.Close;
        Form7.ibDataSet2.Selectsql.Clear;
        Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR'); 
        Form7.ibDataSet2.Open;


        {Mauricio Parizotto 2023-08-29 Inicio}
        IBQConversaoCFOP := Form7.CriaIBQuery(Form7.ibDataSet24.Transaction);

        {
        IBQConversaoCFOP.Close;
        IBQConversaoCFOP.DisableControls;
        IBQConversaoCFOP.SQL.Text := 'Select * From CFOPCONVERSAO';
        IBQConversaoCFOP.Open;
        Mauricio Parizotto 2024-03-22}
        {Mauricio Parizotto 2023-08-29 Fim}

        sNomeDaEmpresa := PrimeiraMaiuscula(AllTrim(Copy(CaracteresHTML((AllTrim(XmlNodeValue(NodeSec.ChildNodes['xNome'].XML,'//xNome'))))+replicate(' ',60),1,60)));
        {Sandro Silva 2023-02-22 inicio}
        sCnpjCpf := Trim(NodeSec.ChildNodes['CNPJ'].Text);
        if sCnpjCpf = '' then
          sCnpjCpf := Trim(NodeSec.ChildNodes['CPF'].Text);
        {Sandro Silva 2023-02-22 fim}

        // Sandro Silva 2023-02-22 if (not Form7.IBDataSet2.Locate('CGC',ConverteCpfCgc(AllTrim(NodeSec.ChildNodes['CNPJ'].Text)),[])) or (AllTrim(Form7.IBDataSet2NOME.AsString) = '') then
        if (not Form7.IBDataSet2.Locate('CGC',ConverteCpfCgc(Trim(sCnpjCpf)),[])) or (AllTrim(Form7.IBDataSet2NOME.AsString) = '') then
        begin
          Form7.IBDataSet2.Append;
          Form7.IBDataSet2CGC.AsString  := ConverteCpfCgc(Trim(sCnpjCpf)); // Sandro Silva 2023-02-22 Form7.IBDataSet2CGC.AsString  := ConverteCpfCgc(AllTrim(NodeSec.ChildNodes['CNPJ'].Text));

          Form1.ibQuery2.Close;
          Form1.ibQuery2.SQL.Clear;
          Form1.ibQuery2.SQL.Add('select * from CLIFOR where Upper(NOME)='+QuotedStr(UpperCase(sNomeDaEmpresa)));
          Form1.ibQuery2.Open;

          while sNomeDaEmpresa = Form1.IBQuery2.FieldByName('NOME').AsString do
          begin
            //sNomeDaEmpresa := Copy(sNomeDaEmpresa,1,Length(sNomeDaEmpresa)-2); mauricio parizotto 2023-07-10
            sNomeDaEmpresa := Trim(Copy(sNomeDaEmpresa,1,55))+' '+ Copy(sCnpjCpf,9,4);


            Form1.ibQuery2.Close;
            Form1.ibQuery2.SQL.Clear;
            Form1.ibQuery2.SQL.Add('select * from CLIFOR where NOME='+QuotedStr(sNomeDaEmpresa));
            Form1.ibQuery2.Open;
          end;

          Form7.IBDataSet2NOME.AsString := sNomeDaEmpresa;
          Form7.IBDataSet2IE.AsString   := AllTrim(NodeSec.ChildNodes['IE'].Text);

          NodeTmp  := NodeSec.ChildNodes['enderEmit']; // tag <prod> dentro de <det>
          NodeTmp.ChildNodes.First;

          //Form7.IBDataSet2ENDERE.AsString := PrimeiraMaiuscula(CaracteresHTML((AllTrim(XmlNodeValue(NodeTmp.ChildNodes['xLgr'].XML,'//xLgr'))))+' '+AllTrim(NodeTmp.ChildNodes['nro'].Text)); Mauricio Parizotto 2024-01-10
          Form7.IBDataSet2ENDERE.AsString := Copy(PrimeiraMaiuscula(CaracteresHTML((AllTrim(XmlNodeValue(NodeTmp.ChildNodes['xLgr'].XML,'//xLgr'))))+' '+AllTrim(NodeTmp.ChildNodes['nro'].Text)) ,1,40);
          //Form7.IBDataSet2COMPLE.AsString := PrimeiraMaiuscula(CaracteresHTML((AllTrim(XmlNodeValue(NodeTmp.ChildNodes['xBairro'].XML,'//xBairro'))))); Mauricio Parizotto 2024-01-10
          Form7.IBDataSet2COMPLE.AsString := Copy(PrimeiraMaiuscula(CaracteresHTML((AllTrim(XmlNodeValue(NodeTmp.ChildNodes['xBairro'].XML,'//xBairro'))))),1,35);
          Form7.IBDataSet2CIDADE.AsString := CaracteresHTML((AllTrim(XmlNodeValue(NodeTmp.ChildNodes['xMun'].XML,'//xMun'))));
          Form7.IBDataSet2ESTADO.AsString := AllTrim(NodeTmp.ChildNodes['UF'].Text);
          Form7.IBDataSet2CEP.AsString    := Copy(AllTrim(NodeTmp.ChildNodes['CEP'].Text+'00000000'),1,5)+'-'+Copy(AllTrim(NodeTmp.ChildNodes['CEP'].Text+'00000000'),5,3);
          Form7.IBDataSet2FONE.AsString   := '(0xx'+Copy(AllTrim(NodeTmp.ChildNodes['fone'].Text+'         '),1,2)+')'+Copy(AllTrim(NodeTmp.ChildNodes['fone'].Text+'         '),2,9);
          Form7.IBDataSet2.Post;
        end else
        begin
          sNomeDaEmpresa := Form7.IBDataSet2NOME.AsString;
        end;

        NodePrim := Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe');
        NodePai  := NodePrim.ChildNodes.FindNode('infNFe');
        NodeSec  := NodePai.ChildNodes.FindNode('ide');

        NodeSec.ChildNodes.First;

        Form7.ibDataset99.Close;
        Form7.ibDataset99.SelectSql.Clear;
        Form7.ibDataset99.SelectSql.Add('select NUMERONF from COMPRAS where NUMERONF='+QuotedStr( Right(StrZero(StrToFloat(NodeSec.ChildNodes['nNF'].Text),9,0),9)+StrZero(StrToInt(LimpaNumero('0'+NodeSec.ChildNodes['serie'].Text)),3,0) )+' and FORNECEDOR='+QuotedStr(sNomeDaEmpresa)+' ');
        Form7.IBDataSet99.Open;

        if (AllTrim(Form7.ibDAtaSet99.FieldByname('NUMERONF').AsString) <> '') and (sP1='') then
        begin
          //ShowMessage('Nota Fiscal Já Cadastrada.'); Mauricio Parizotto 2023-10-25
          MensagemSistema('Nota Fiscal Já Cadastrada.');
          Form24.Close;

          Form7.sModulo := 'DUPLA';
          Form7.ibDataSet24.Delete;
          Form7.sModulo := 'COMPRA';

          Abort;
        end else
        begin
          Form7.ibDataSet24.Edit;
          Form7.ibDataSet24FORNECEDOR.AsString := Form7.IBDataSet2NOME.AsString;
          Form7.ibDataSet24FRETE12.AsString    := '1';
          Form7.ibDataSet24MODELO.AsString     := '55';
          Form7.ibDataSet24EMISSAO.Value       := Date;

          Form24.Label64.Caption := 'Mod: '+Form7.ibDataSet24MODELO.AsString;

          if not Form7.ibDataSet14.Locate('CFOP','2102',[]) then
            Form7.ibDataSet14.Locate('CFOP','1102',[]);

          Form7.ibDataSet24OPERACAO.AsString    := Form7.ibDataSet14NOME.AsString;

          if pP1 then
          begin
            Form7.ibDataSet24NUMERONF.AsString := Right(StrZero(StrToFloat(NodeSec.ChildNodes['nNF'].Text),9,0),9)+StrZero(StrToInt(LimpaNumero('0'+NodeSec.ChildNodes['serie'].Text)),3,0);// Número da NF

            Form24.Edit2.Text := Right(StrZero(StrToFloat(NodeSec.ChildNodes['nNF'].Text),9,0),9)+'/'+StrZero(StrToInt(LimpaNumero('0'+NodeSec.ChildNodes['serie'].Text)),3,0);// Número da NF
            Form24.Edit2.Repaint;
          end else
          begin
            Form7.ibDataset99.Close;
            Form7.ibDataset99.SelectSql.Clear;
            Form7.ibDataset99.SelectSql.Add('select gen_id(G_SERIE1,0) from rdb$database');
            Form7.IBDataSet99.Open;

            Form7.ibDataSet24NUMERONF.AsString := StrZero(StrtoFloat(Form7.ibDataSet99.FieldByname('GEN_ID').AsString)+1,9,0)+'001'; // Número da NF
            Form7.IBDataSet99.Close;
          end;

          try
            NodePrim := Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('protNFe');
            NodePai  := NodePrim.ChildNodes.FindNode('infProt');

            Form7.ibDataSet24SAIDAD.AsString := Copy(NodePai.ChildNodes['dhRecbto'].Text,9,2)+'/'+Copy(NodePai.ChildNodes['dhRecbto'].Text,6,2)+'/'+Copy(NodePai.ChildNodes['dhRecbto'].Text,1,4); // Data da saida
            Form7.ibDataSet24SAIDAH.AsString := Copy(NodePai.ChildNodes['dhRecbto'].Text,12,8);// Hora da saída
          except
            //ShowMessage('Verigique se esta NF-e foi autorizada'); Mauricio Parizotto 2023-10-25
            MensagemSistema('Verigique se esta NF-e foi autorizada',msgAtencao);
          end;

          NodePrim := Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe');
          NodePai  := NodePrim.ChildNodes.FindNode('infNFe');
          NodeSec  := NodePai.ChildNodes.FindNode('det');

          NodeSec.ChildNodes.First;

          Screen.Cursor            := crHourGlass;


          repeat
            try
              NodeTmp  := NodeSec.ChildNodes['prod']; // tag <prod> dentro de <det>
              NodeTmp.ChildNodes.First;
            except
              on E: Exception do
              begin
                //Application.MessageBox(pChar(E.Message),'Erro X importa NF',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
                MensagemSistema(E.Message+' Erro X importa NF',msgErro);
              end;
            end;

            if NodeTmp <> nil then
            begin
              try
                if Alltrim(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))) <> '' then
                begin
                  try
                    bProdutoCadastrado := False;
                    // Procura primeiro pelo Código de Barras cEAN
                    if (NodeTmp.ChildNodes['cEAN'].Text <> '') and (NodeTmp.ChildNodes['cEAN'].Text <> 'SEM GTIN')  then
                    begin
                      Form7.ibDataSet4.Close;
                      Form7.ibDataSet4.SelectSQL.Clear;
                      Form7.ibDataSet4.SelectSQL.Add('select * from ESTOQUE where REFERENCIA='+QuotedStr(NodeTmp.ChildNodes['cEAN'].Text)+' ');
                      Form7.ibDataSet4.Open;

                      if (AllTrim(Form7.ibDataSet4REFERENCIA.AsString) = AllTrim(NodeTmp.ChildNodes['cEAN'].Text)) and (AllTrim(Form7.ibDataSet4REFERENCIA.AsString) <> '') then
                      begin
                        bProdutoCadastrado := True;
                        sItens := sItens + RetornarCodProdInativo;
                      end;
                    end;

                    //Mauricio Parizotto 2023-10-04
                    sICMSTag := GetICMSTag(NodeSec);

                    if not bProdutoCadastrado then
                    begin
                      // Procura pelo CODIGO de Barras do fornecedor relacionado no arquivo CODEBAR
                      if (NodeTmp.ChildNodes['cEAN'].Text = '') or (NodeTmp.ChildNodes['cEAN'].Text = 'SEM GTIN')  then
                      begin
                        sCodigoDeBarrasDoFornecedor := AllTrim(NodeTmp.ChildNodes['cProd'].Text);
                      end else
                      begin
                        sCodigoDeBarrasDoFornecedor := NodeTmp.ChildNodes['cEAN'].Text;
                      end;

                      Form7.ibQuery1.Close;
                      Form7.ibQuery1.Sql.Clear;
                      Form7.ibQuery1.Sql.Add('select * from CODEBAR where FORNECEDOR='+QuotedStr(Form7.ibDataSet24FORNECEDOR.AsString)+' and EAN='+QuotedStr(sCodigoDeBarrasDoFornecedor)+' ');
                      Form7.ibQuery1.Open;

                      if AllTrim(Form7.ibQuery1.FieldByname('EAN').AsString) <> '' then
                      begin
                        sCodigoDeBarrasDoFornecedor := Form7.ibQuery1.FieldByname('CODIGO').AsString;
                        
                        Form7.ibDataSet4.Close;
                        Form7.ibDataSet4.SelectSQL.Clear;
                        Form7.ibDataSet4.SelectSQL.Add('select * from ESTOQUE where CODIGO='+QuotedStr(sCodigoDeBarrasDoFornecedor)+' ');
                        Form7.ibDataSet4.Open;

                        if form7.ibDataSet4CODIGO.AsString = sCodigoDeBarrasDoFornecedor then
                        begin
                          bProdutoCadastrado := True;
                          sItens := sItens + RetornarCodProdInativo;
                        end;
                      end;
                    end;
                    
                    if not bProdutoCadastrado then
                    begin
                      //  Procura pelo código de barras / quando não tem descricao
                      Form7.ibQuery1.Close;
                      Form7.ibQuery1.Sql.Clear;
                      Form7.ibQuery1.Sql.Add('select * from CODEBAR where FORNECEDOR='+QuotedStr(Form7.ibDataSet24FORNECEDOR.AsString)+' and CODIGO='+QuotedStr(AllTrim(Form7.ibDataSet4CODIGO.AsString))+' ');
                      Form7.ibQuery1.Open;

                      if AllTrim(Form7.IBQuery1.FieldByName('EAN').AsString) = '' then
                      begin
                        Form7.ibDataSet4.Close;
                        Form7.ibDataSet4.SelectSQL.Clear;
                        //Form7.ibDataSet4.SelectSQL.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(AllTrim(Copy(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))+Replicate(' ',45),1,45)))+' '); Mauricio Parizotto 2023-12-19
                        Form7.ibDataSet4.SelectSQL.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(AllTrim(Copy(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))+Replicate(' ',SizeDescricaoProd),1,SizeDescricaoProd))));
                        Form7.ibDataSet4.Open;

                        bProdutoCadastrado := AllTrim(Form7.ibDataSet4CODIGO.AsString) <> EmptyStr;
                        if bProdutoCadastrado then
                          sItens := sItens + RetornarCodProdInativo;
                      end;
                    end;

                    if not bProdutoCadastrado then  // Não encontrou
                    begin
                      // Cria um novo produto
                      Form7.iKey := 0;
                      Form7.ibDataSet4.Append; // Importa NF XML
                      Form7.ibDataSet4REFERENCIA.AsString := NodeTmp.ChildNodes['cEAN'].Text;

                      if AllTrim(NodeTmp.ChildNodes['cProd'].Text) <> '' then
                      begin
                        // Inclui automaticamente no CODEBAR para saber numa futura compra do mesmo fornecedor que este código é referente a este produto
                        try
                          Form7.IBDataSet6.Append;
                          Form7.IBDataSet6CODIGO.AsString       := Form7.ibDataSet4CODIGO.AsString;
                          Form7.IBDataSet6EAN.AsString          := AllTrim(NodeTmp.ChildNodes['cProd'].Text);
                          Form7.IBDataSet6FORNECEDOR.AsString   := Form7.ibDataSet24FORNECEDOR.AsString;
                          Form7.IBDataSet6.Post;
                        except
                        end;
                      end;

                      // Procura para ver se já existe um nome igual
                      Form7.ibQuery1.Close;
                      Form7.ibQuery1.Sql.Clear;
                      //Form7.ibQuery1.Sql.Add('select DESCRICAO from ESTOQUE where DESCRICAO='+QuotedStr(AllTrim(Copy(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))+Replicate(' ',45),1,45)))+' '); Mauricio Parizotto 2023-12-19
                      Form7.ibQuery1.Sql.Add('select DESCRICAO from ESTOQUE where DESCRICAO='+QuotedStr(AllTrim(Copy(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))+Replicate(' ',SizeDescricaoProd),1,SizeDescricaoProd))));
                      Form7.ibQuery1.Open;

                      //if Form7.IBQuery1.FieldByName('DESCRICAO').AsString = AllTrim(Copy(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))+Replicate(' ',45),1,45)) then Mauricio Parizotto 2023-12-19
                      if Form7.IBQuery1.FieldByName('DESCRICAO').AsString = AllTrim(Copy(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))+Replicate(' ',SizeDescricaoProd),1,SizeDescricaoProd)) then
                      begin
                        // Se já existe cria o nome com o código no final
                        //Form7.ibDataSet4DESCRICAO.AsString  := AllTrim(Copy(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))+Replicate(' ',39),1,39))+' '+Form7.ibDataSet4CODIGO.AsString; Mauricio Parizotto 2023-12-19
                        Form7.ibDataSet4DESCRICAO.AsString  := AllTrim(Copy(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))+Replicate(' ',SizeDescricaoProd-6),1,SizeDescricaoProd-6))+' '+Form7.ibDataSet4CODIGO.AsString;
                      end else
                      begin
                        //Form7.ibDataSet4DESCRICAO.AsString  := AllTrim(Copy(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))+Replicate(' ',39),1,39))+' '+Form7.ibDataSet4CODIGO.AsString; Mauricio Parizotto 2023-12-19
                        Form7.ibDataSet4DESCRICAO.AsString  := AllTrim(Copy(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))+Replicate(' ',SizeDescricaoProd-6),1,SizeDescricaoProd-6))+' '+Form7.ibDataSet4CODIGO.AsString;
                      end;

                      //Form7.ibDataSet4MEDIDA.AsString     := AllTrim(NodeTmp.ChildNodes['uCom'].Text); Mauricio Parizotto 2024-01-10
                      Form7.ibDataSet4MEDIDA.AsString     := Copy(AllTrim(NodeTmp.ChildNodes['uCom'].Text) ,1,3);
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

                      //Mauricio Parizotto 2023-09-19
                      //sICMSTag := GetICMSTag(NodeSec);

                      //Mauricio Parizotto 2023-09-19
                      //Parametros de tributação
                      if Assigned(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag)) then
                      begin
                        try
                          Form7.StatusTrocaPerfil := 'PR';

                          SetValoresParTributacao(NodeTmp.ChildNodes['CFOP'].Text,
                                                  NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['orig'].Text,
                                                  NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['CST'].Text,
                                                  NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['CSOSN'].Text,
                                                  NodeTmp.ChildNodes['NCM'].Text,
                                                  StrToFloatDef(StringReplace(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['pICMS'].Text,'.',',',[rfReplaceAll]),0),
                                                  Form7.ibDataSet4);

                          Form7.StatusTrocaPerfil := 'OK';
                        except
                        end;
                      end;


                      Form7.ibDataSet4.Post;
                    end;

                    // FCI
                    if AllTrim(NodeTmp.ChildNodes['nFCI'].Text) <> '' then
                    begin
                      Form7.ibDataSet4.Edit;
                      Form7.ibDataSet4CODIGO_FCI.AsString := AllTrim(NodeTmp.ChildNodes['nFCI'].Text);
                      Form7.ibDataSet4.Edit;
                    end;
                    
                    Form1.bFlag := False;
                    Form7.sModulo := 'NAO';

                    Form24.edtFatorC.Text := FloatToStr(Form7.ibDataSet4FATORC.AsFloat);//Mauricio Parizotto 2024-02-21

                    Form7.ibDAtaSet23.Append;
                    Form7.ibDataSet23CODIGO.AsString       := Form7.ibDataSet4CODIGO.AsString; // Importar NF
                    Form7.ibDataSet23DESCRICAO.AsString    := Form7.ibDataSet4DESCRICAO.AsString;
                    Form7.ibDataSet23QTD_ORIGINAL.AsString := StrTran(NodeTmp.ChildNodes['qCom'].Text,'.',',');
                    Form7.ibDataSet23TOTAL.AsString        := StrTran(NodeTmp.ChildNodes['vProd'].Text,'.',',');

                    try
                      Form7.ibDataSet23UNITARIO_O.AsString   := StrTran(NodeTmp.ChildNodes['vUnCom'].Text,'.',',');
                    except
                    end;

                    if (NodeTmp.ChildNodes['cEAN'].Text = '') or (NodeTmp.ChildNodes['cEAN'].Text = 'SEM GTIN')  then
                    begin
                      Form7.ibDataSet23EAN_ORIGINAL.AsString := AllTrim(NodeTmp.ChildNodes['cProd'].Text);
                    end else
                    begin
                      Form7.ibDataSet23EAN_ORIGINAL.AsString := NodeTmp.ChildNodes['cEAN'].Text;
                    end;

                    Form7.ibDataSet23.Post;
                    Form7.ibDataSet23.Edit;

                    // Impostos
                    try
                      Form7.ibDataSet23BASE.AsFloat       := 0;
                      Form7.ibDataSet23ICM.AsString          := '0';
                      // ICM
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

                      svICMSDESON := '0.00';

                      // Ver como resolver ester try Quando nao existem os campos
                      {
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
                      Mauricio Parizotto 2023-09-19 Trocado pela funcao GetICMSTag}

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
                        {Sandro Silva 2024-03-21 inicio}
                        spICMSST := EmptyStr; // Dailon Parisotto (f-18658) 2024-05-13
                        if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).XML, '//pICMSST')) <> '' then
                          spICMSST  := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['pICMSST'].Text;
                        {Sandro Silva 2024-03-21 fim}

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

                        if Trim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).XML, '//vICMSDeson')) <> '' then
                          svICMSDESON := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['vICMSDeson'].Text;

                      end;

                      try
                        if Assigned(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('IPI')) then
                        begin
                          if Assigned(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('IPI').ChildNodes.FindNode('IPITrib')) then
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
                              {Dailon Parisotto (f-18123) 2024-04-16 Inicio}
                              if StrToFloatDef(StrTran(sIPI,'.',','), 0) > 0 then
                              {Dailon Parisotto (f-18123) 2024-04-16 Fim}
                                sCSTIPI := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('IPI').ChildNodes.FindNode('IPITrib').ChildNodes['CST'].Text;
                            except
                            end;
                          end;
                        end;
                      except
                      end;


                      // Ver como resolver ester try Quando nao existem os campos
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

                      {Sandro Silva 2024-03-21 inicio}
                      try
                        Form7.ibDataSet23PICMSST.AsString   := StrTran(spICMSST,'.',',');
                      except
                      end;
                      {Sandro Silva 2024-03-21 fim}

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

                      {$Region'//// Conversão de CFOP ////'}
                      try
                        //Mauricio Parizotto 2023-05-02
                        {
                        Form7.ibDataSet23CFOP.AsString   := sIniCFOP+Copy(NodeTmp.ChildNodes['CFOP'].Text,2,3);
                        }

                        //Mauricio Parizotto 2023-08-29
                        //Faz a conversão de CFOP
                        {Mauricio Parizotto 2024-03-22 Inicio
                        if IBQConversaoCFOP.Locate('CFOP_ORIGEM',NodeTmp.ChildNodes['CFOP'].Text,[]) then
                        begin
                          Form7.ibDataSet23CFOP.AsString   := IBQConversaoCFOP.FieldByName('CFOP_CONVERSAO').AsString;
                        end else
                        begin
                          Form7.ibDataSet23CFOP.AsString   := sIniCFOP+Copy(NodeTmp.ChildNodes['CFOP'].Text,2,3);
                        end;
                        }

                        CST_Conv    := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['CST'].Text;
                        CSOSN_Conv  := NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode(sICMSTag).ChildNodes['CSOSN'].Text;

                        Filtro_Conv := ' 1=2 ';

                        if CST_Conv <> '' then
                        begin
                          Filtro_Conv := 'CST = '+QuotedStr(CST_Conv);
                        end;

                        if CSOSN_Conv <> '' then
                        begin
                          Filtro_Conv := 'CSOSN = '+QuotedStr(CSOSN_Conv);
                        end;

                        IBQConversaoCFOP.Close;
                        IBQConversaoCFOP.SQL.Text := ' Select First 1 CFOP_CONVERSAO '+
                                                     ' From CFOPCONVERSAO '+
                                                     ' Where CFOP_ORIGEM = '+QuotedStr(NodeTmp.ChildNodes['CFOP'].Text) +
                                                     '   and ( '+
                                                     '         Coalesce(CONSIDERACSTCSOSN,''N'') = ''N''  '+
                                                     '         or (Coalesce(CONSIDERACSTCSOSN,''N'') = ''S''  and  '+Filtro_Conv+' ) '+
                                                     '       )'+
                                                     ' Order By CONSIDERACSTCSOSN Desc ';
                        IBQConversaoCFOP.Open;

                        if not(IBQConversaoCFOP.IsEmpty) then
                        begin
                          Form7.ibDataSet23CFOP.AsString   := IBQConversaoCFOP.FieldByName('CFOP_CONVERSAO').AsString;
                        end else
                        begin
                          Form7.ibDataSet23CFOP.AsString   := sIniCFOP+Copy(NodeTmp.ChildNodes['CFOP'].Text,2,3);
                        end;

                        {Mauricio Parizotto 2024-03-22 Fim}

                      except
                      end;
                      {$Endregion}

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

                      //Mauricio Parizotto 2023-07-18
                      try
                        Form7.ibDataSet23ICMS_DESONERADO.AsString := StringReplace(svICMSDESON, '.', ',', [rfReplaceAll]);
                      except
                      end;

                      Form7.ibDataSet23.Post;
                      Form7.ibDataSet23.Edit;
                    except
                    end;
                  except
                  end;
                end;
              except
                {
                ShowMessage('Erro ao ler o produto código: '+sCodigoDeBarrasDoFornecedor+chr(10)+chr(10)+
                            'Este item não foi importado. Deve ser digitado manualmente.'+chr(10));
                Mauricio Parizotto 2023-10-25}
                MensagemSistema('Erro ao ler o produto código: '+sCodigoDeBarrasDoFornecedor+chr(10)+chr(10)+
                                'Este item não foi importado. Deve ser digitado manualmente.'+chr(10)
                                ,msgAtencao);

              end;
            end;

            NodeSec := NodeSec.NextSibling; // Next
            NodeTmp.ChildNodes.Clear;
            //
          until NodeSec = nil;

          //Mauricio Parizotto 2024-01-10
          Form7.TotalizaItensCompra;

          try
            Form7.ibDataSet24.Edit;
          except
          end;

          try Form7.ibDataSet24NFEID.VAlue              := Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('protNFe').ChildNodes.FindNode('infProt').ChildNodes.FindNode('chNFe').Text;  except end;
          try Form7.ibDataSet24ICMSSUBSTI.AsString      := StrTran(Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe').ChildNodes.FindNode('infNFe').ChildNodes.FindNode('total').ChildNodes.FindNode('ICMSTot').ChildNodes.FindNode('vST').Text,'.',','); except end;
          try Form7.ibDataSet24BASESUBSTI.AsString      := StrTran(Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe').ChildNodes.FindNode('infNFe').ChildNodes.FindNode('total').ChildNodes.FindNode('ICMSTot').ChildNodes.FindNode('vBCST').Text,'.',','); except end;
          try Form7.ibDataSet24DESCONTO.AsString        := StrTran(Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe').ChildNodes.FindNode('infNFe').ChildNodes.FindNode('total').ChildNodes.FindNode('ICMSTot').ChildNodes.FindNode('vDesc').Text,'.',','); except end;
          try Form7.ibDataSet24FRETE.AsString           := StrTran(Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe').ChildNodes.FindNode('infNFe').ChildNodes.FindNode('total').ChildNodes.FindNode('ICMSTot').ChildNodes.FindNode('vFrete').Text,'.',','); except end;
          try Form7.ibDataSet24DESPESAS.AsString        := StrTran(Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe').ChildNodes.FindNode('infNFe').ChildNodes.FindNode('total').ChildNodes.FindNode('ICMSTot').ChildNodes.FindNode('vOutro').Text,'.',','); except end;
          try Form7.ibDataSet24SEGURO.AsString          := StrTran(Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe').ChildNodes.FindNode('infNFe').ChildNodes.FindNode('total').ChildNodes.FindNode('ICMSTot').ChildNodes.FindNode('vSeg').Text,'.',','); except end;
          try Form7.ibDataSet24ICMS_DESONERADO.AsString := StrTran('0','.',','); except end;

          try
            if Assigned(Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe').ChildNodes.FindNode('infNFe').ChildNodes.FindNode('total').ChildNodes.FindNode('ICMSTot').ChildNodes.FindNode('vFCPST')) then
              Form7.ibDataSet24VFCPST.AsString      := StringReplace(Form7.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe').ChildNodes.FindNode('infNFe').ChildNodes.FindNode('total').ChildNodes.FindNode('ICMSTot').ChildNodes.FindNode('vFCPST').Text, '.', ',', [rfReplaceAll]);
          except
          end;

          {Sandro Silva 2023-07-03 inicio}
          try
            if xmlNodeValue(SXML, '//vol/pesoB') <> '' then
              Form7.ibDataSet24PESOBRUTO.AsFloat := XmlValueToFloat(xmlNodeValue(SXML, '//vol/pesoB'));
            if xmlNodeValue(SXML, '//vol/pesoL') <> '' then
              Form7.ibDataSet24PESOLIQUI.AsFloat := XmlValueToFloat(xmlNodeValue(SXML, '//vol/pesoL'));
          except

          end;
          {Sandro Silva 2023-07-03 fim}

          // Mauricio Parizotto 2024-01-10
          Form7.CalculaTotalNota;

          try
            Form7.ibDataSet24NFEXML.AsString := sXML;
          except
            //ShowMessage('Não foi possível gravar o XML'); Mauricio Parizotto 2023-10-25
            MensagemSistema('Não foi possível gravar o XML',msgErro);
          end;

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
              //Application.MessageBox(pChar(E.Message),'Erro 10 importa NF',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
              MensagemSistema(E.Message+' Erro 10 importa NF',msgErro);
            end;
          end;
        end;

        //Mauricio Parizotto 2023-08-29
        FreeAndNil(IBQConversaoCFOP);
      end;


      // Conhecimento de Transporte Eletrônico
      if AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/mod')) = '57' then
      begin
        // CT-e
        Form7.ibDataSet2.Close;
        Form7.ibDataSet2.Selectsql.Clear;
        Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR');
        Form7.ibDataSet2.Open;

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
        end;

        Form7.ibDataset99.Close;
        Form7.ibDataset99.SelectSql.Clear;
        Form7.ibDataset99.SelectSql.Add('select NUMERONF from COMPRAS where NUMERONF='+QuotedStr( Right(StrZero(StrToFloat(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/nCT')),9,0),9)+StrZero(StrToInt(LimpaNumero('0'+xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/serie'))),3,0) )+' and FORNECEDOR='+QuotedStr(Form7.IBDataSet2NOME.AsString)+' ');
        Form7.IBDataSet99.Open;

        if Form7.ibDAtaSet99.FieldByname('NUMERONF').AsString =Right(StrZero(StrToFloat(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/nCT')),9,0),9)+StrZero(StrToInt(LimpaNumero('0'+xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/serie'))),3,0) then
        begin
          //ShowMessage('Nota Fiscal Já Cadastrada.'); Mauricio Parizotto 2023-10-25
          MensagemSistema('Nota Fiscal Já Cadastrada.',msgAtencao);
          Form24.Close;
          Form7.ibDataSet24.Delete;
        end else
        begin
          Form7.ibDataSet24.Edit;
          Form7.ibDataSet24FORNECEDOR.AsString := Form7.IBDataSet2NOME.AsString;
          Form7.ibDataSet24MODELO.AsString     := '57';

          Form24.Label64.Caption := 'Mod: '+Form7.ibDataSet24MODELO.AsString;

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

          Form7.ibDataSet24OPERACAO.AsString    := Form7.ibDataSet14NOME.AsString;
          Form7.ibDataSet24NUMERONF.AsString := Right(StrZero(StrToFloat(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/nCT')),9,0),9)+StrZero(StrToInt(LimpaNumero('0'+xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/serie'))),3,0);
          Form24.Edit2.Text := Right(StrZero(StrToFloat(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/nCT')),9,0),9)+'/'+StrZero(StrToInt(LimpaNumero('0'+xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/serie'))),3,0);
          Form24.Edit2.Repaint;

          Form7.ibDataSet24SAIDAD.AsString := Copy(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/dhEmi'),9,2)+'/'+Copy(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/dhEmi'),6,2)+'/'+Copy(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/dhEmi'),1,4); // Data da saida
          Form7.ibDataSet24SAIDAH.AsString := Copy(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/CTe/infCte/ide/dhEmi'),12,8);// Hora da saída
          Form7.ibDataSet24NFEID.AsString  := xmlNodeValue(Form7.XMLDocument1.XML.Text,'//cteProc/protCTe/infProt/chCTe'); // COVID19

          Form1.bFlag := False;
          Form7.sModulo := 'NAO';

          if not Form7.ibDataSet4.Locate('DESCRICAO','Frete',[]) then
          begin
            Form7.ibDataSet4.Append;  // Inclui um produto chamado FRETE
            Form7.ibDataSet4.Edit;
            Form7.ibDataSet4DESCRICAO.AsString := 'Frete';
            Form7.ibDataSet4.Post;
          end;

          try
            Form7.ibDAtaSet23.Append;
            Form7.ibDataSet23CODIGO.AsString     := Form7.ibDataSet4CODIGO.AsString; // Importar NF
            Form7.ibDataSet23DESCRICAO.AsString  := Form7.ibDataSet4DESCRICAO.AsString;
            Form7.ibDataSet23QUANTIDADE.AsString := '1';
          except
          end;

          try
            Form7.ibDataSet23UNITARIO_O.AsString :=  StrTran(AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//imp/ICMS/ICMS00/vBC')),'.',',');
            Form7.ibDataSet23ICM.AsString        :=  StrTran(AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//imp/ICMS/ICMS00/pICMS')),'.',',');
            Form7.ibDataSet23VICMS.AsString      :=  StrTran(AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//imp/ICMS/ICMS00/vICMS')),'.',',');
            Form7.ibDataSet23vBC.AsString        :=  StrTran(AllTrim(xmlNodeValue(Form7.XMLDocument1.XML.Text,'//imp/ICMS/ICMS00/vBC')),'.',',');
          except
          end;

          try
            Form7.ibDataSet23.Post;
            Form7.ibDataSet23.Edit;
          except
            on E: Exception do
            begin
              //Application.MessageBox(pChar(E.Message),'Erro 11 importa NF',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
              MensagemSistema(E.Message+' Erro 11 importa NF',msgErro);
            end;
          end;
        end;
      end;
    except
      on E: Exception do
      begin
        //Application.MessageBox(pChar(E.Message),'Estrutura do arquivo XML da NF-e inválida.',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
        MensagemSistema(E.Message+' Estrutura do arquivo XML da NF-e inválida.',msgErro);
      end;
    end;
    TItensInativosImpXMLEnt.New
                           //.setDataBase(Form7.IBDatabase1) Mauricio Parizotto 2024-01-19
                           .setDataBase(Form7.IBDatabase1,Form7.IBTransaction1)
                           .Executar(sItens);
  except
    on E: Exception do
    begin
      //Application.MessageBox(pChar(E.Message),'Erro ao importar XML da NF-e',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
      MensagemSistema(E.Message+' Erro ao importar XML da NF-e',msgErro);
    end;
  end;

  try
    Form1.bFlag := True;
    Form7.sModulo := 'COMPRA';

    DecodeTime((Time - tInicio), Hora, Min, Seg, cent);
  except
  end;

  try
    Form7.ibDataset2.EnableControls
  except
  end;

  try
    Form7.ibDataset23.EnableControls;
    //LogRetaguarda('uimportanfe ibDataSet23.EnableControls 981'); // Sandro Silva 2023-12-04
  except
  end;

  try
    Form7.ibDataset24.EnableControls;

    //LogRetaguarda('Form7.ibDataSet24.EnableControls; 986'); // Sandro Silva 2023-11-27

  except
  end;

  try
    Form7.ibDataset4.EnableControls
  except
  end;

  Screen.Cursor            := crDefault;
end;

function GetICMSTag(NodeSec:IXMLNode):string;
begin
  Result := '';

  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS00/CST')) <> '' then
    Result := 'ICMS00';
  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS02/CST')) <> '' then //Mauricio Parizotto 2023-09-19
    Result := 'ICMS02';
  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS10/CST')) <> '' then
    Result := 'ICMS10';
  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS15/CST')) <> '' then //Mauricio Parizotto 2023-09-19
    Result := 'ICMS15';
  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS20/CST')) <> '' then
    Result := 'ICMS20';
  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS30/CST')) <> '' then
    Result := 'ICMS30';
  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS40/CST')) <> '' then
    Result := 'ICMS40';
  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS51/CST')) <> '' then
    Result := 'ICMS51';
  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS53/CST')) <> '' then //Mauricio Parizotto 2023-09-19
    Result := 'ICMS53';
  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS60/CST')) <> '' then
    Result := 'ICMS60';
  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS61/CST')) <> '' then //Mauricio Parizotto 2023-09-19
    Result := 'ICMS61';
  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS70/CST')) <> '' then
    Result := 'ICMS70';
  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMS90/CST')) <> '' then
    Result := 'ICMS90';

  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMSST/CST')) <> '' then //Mauricio Parizotto 2023-10-31
    Result := 'ICMSST';
  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMSPart/CST')) <> '' then //Mauricio Parizotto 2023-10-31
    Result := 'ICMSPart';

  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMSSN101/CSOSN')) <> '' then
    Result := 'ICMSSN101';
  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMSSN102/CSOSN')) <> '' then
    Result := 'ICMSSN102';
  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMSSN201/CSOSN')) <> '' then
    Result := 'ICMSSN201';
  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMSSN202/CSOSN')) <> '' then
    Result := 'ICMSSN202';
  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMSSN500/CSOSN')) <> '' then
    Result := 'ICMSSN500';
  if AllTrim(xmlNodeValue(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').XML, '//ICMSSN900/CSOSN')) <> '' then
    Result := 'ICMSSN900';
end;

end.
