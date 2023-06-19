{ *********************************************************************** }
{                                                                         }
{ Smallsoft Tecnologia                                                    }
{ Rotina para geração de XML da NF-e                                      }
{                                                                         }
{ Copyright (c) Smallsoft                                                 }
{                                                                         }
{ *********************************************************************** }

unit ugeraxmlnfe;

interface

uses
  SysUtils
  , Classes
  , IniFiles
  , Forms
  , Controls
  , Windows
  , Dialogs
  , Math
  , DB
  , IBQuery // Sandro Silva 2022-11-10
  , ShellApi
  , SpdNFeDataSets
  , spdXMLUtils
  , spdNFeType
  , spdNFe
  , spdType
  , SmallFunc
  , unit7
  , unit11
  , unit29
  , unit12
  , Mais
;

type
  TItemNFe = class
  private
    FOrigem: String;
    FCSOSN: String;
    FCodigo: String;
    FCST: String;
  public
    property Codigo: String read FCodigo write FCodigo;
    property CSOSN: String read FCSOSN write FCSOSN;
    property Origem: String read FOrigem write FOrigem;
    property CST: String read FCST write FCST;
  end;


  function GeraXmlNFe: String;
  procedure CsosnComOrigemdoProdutoNaOperacao(sCodigo: String; sOperacao: String; ItemNF: TItemNFe);

implementation

uses uGeraXmlNFeEntrada, uGeraXmlNFeSaida;


function GeraXmlNFe: String;
var
  sJustificativa : String;
  fNFe: String; // Sandro Silva 2022-09-12
  sLote : String;
  F: TextFile;
  _file : TStringList;
begin
  try
    Form7.ibDataSet16.DisableControls; // Sandro Silva 2023-05-09
    Form7.ibDataSet23.DisableControls; // Sandro Silva 2023-05-09
    Screen.Cursor            := crHourGlass;
    Form7.Panel7.Caption     := 'Verificando status do serviço...'+replicate(' ',100);
    Form7.Panel7.Repaint;

    ConfiguraNFE(True);

    if LimpaNumero(AllTrim(Form7.ibDataSet13.FieldByname('TELEFO').AsString)) = '' then
    begin
      Form7.ibDataset15.Edit;
      Form7.ibDataSet15STATUS.AsString    := 'Erro: Verifique o telefone do emitente não foi informado.';
      Abort;
    end;

    if AllTrim(Form7.ibDataSet13.FieldByname('CEP').AsString) = '' then
    begin
      Form7.ibDataset15.Edit;
      Form7.ibDataSet15STATUS.AsString    := 'Erro: CEP do emitente inválido.';
      Abort;
    end;

    Form7.Panel7.Caption := 'Gerando arquivo XML...'+replicate(' ',100);
    Form7.Panel7.Repaint;

    if Form7.ibDataSet15EMITIDA.AsString = 'E' then
    begin
      //Entrada
      GeraXmlNFeEntrada;
    end else
    begin
      //Saida
      GeraXmlNFeSaida;
    end;

    // Grupo ZD. Informações do Responsável Técnico
//  if Form1.bHomologacao then
    begin
      Form7.spdNFeDataSets.Campo('CNPJ_ZD02').Value                         := LimpaNumero(CNPJ_SMALLSOFT); //'07426598000124';
      Form7.spdNFeDataSets.Campo('xContato_ZD04').Value                     := 'Alessio Mainardi';
      Form7.spdNFeDataSets.Campo('email_ZD05').Value                        := 'smallsoft@smallsoft.com.br';
      Form7.spdNFeDataSets.Campo('fone_ZD06').Value                         := '4934255800';
    end;
    
    if Form1.bModoSVC then
    begin
      sJustificativa := ConverteAcentos2(Form1.Small_InputForm('Atenção',chr(10)+'Para imprimir a nf-e em modo de SVC informe uma justificativa (min. 15 caracteres)'+chr(10)+chr(10), ''));
      
      if Length(sJustificativa) >= 15 then
      begin
        Form7.spdNFeDataSets.Campo('xJust_B29').Value    := sJustificativa;
        Form7.spdNFeDataSets.Campo('dhCont_B28').Value   := StrTran(DateToStrInvertida(Date),'/','-')+'T'+TimeToStr(Time)+Form7.sFuso; // Data de Emissão da Nota Fiscal
      end else
      begin
        if AllTrim(sJustificativa) <> '' then
        begin
          ShowMessage('A justificativa tem que ter no minimo 15 caracteres.');
          Abort;
        end;
      end;
    end;
    
    if Form1.bModoScan then
    begin
      sJustificativa := ConverteAcentos2(Form1.Small_InputForm('Atenção',chr(10)+'Para imprimir a nf-e em modo de SCAN informe uma justificativa (min. 15 caracteres)'+chr(10)+chr(10), ''));

      if Length(sJustificativa) >= 15 then
      begin
         Form7.spdNFeDataSets.Campo('xJust_B29').Value    := sJustificativa;
         Form7.spdNFeDataSets.Campo('dhCont_B28').Value   := StrTran(DateToStrInvertida(Date),'/','-')+'T'+TimeToStr(Time)+Form7.sFuso; // Data de Emissão da Nota Fiscal
      end else
      begin
        if AllTrim(sJustificativa) <> '' then
        begin
          ShowMessage('A justificativa tem que ter no minimo 15 caracteres.');
          Abort;
        end;
      end;
    end;
    
    if Form7.bContingencia then
    begin
      sJustificativa := ConverteAcentos2(Form1.Small_InputForm('Atenção',chr(10)+
                                        'Esta opção somente deve ser usada em caso de emergência, quando o servidor da receita não estiver disponível.'+Chr(10)+Chr(10)+
                                        'Quando o servidor estiver disponível novamente esta NF-e deverá ser transmitida e autorizada.'+Chr(10)+Chr(10)+
                                        'O formulário de contingência deve ser autorizado pelo fisco.'+Chr(10)+Chr(10)+
                                        'Para imprimir a nf-e em modo de contingência informe uma justificativa (min. 15 caracteres)'+chr(10)+chr(10), ''));
      
      if Length(sJustificativa) >= 15 then
      begin
         Form7.spdNFeDataSets.Campo('xJust_B29').Value         := sJustificativa;
         Form7.spdNFeDataSets.Campo('dhCont_B28').Value   := StrTran(DateToStrInvertida(Date),'/','-')+'T'+TimeToStr(Time)+Form7.sFuso; // Data de Emissão da Nota Fiscal
      end else
      begin
        if AllTrim(sJustificativa) <> '' then
        begin
          ShowMessage('A justificativa tem que ter no minimo 15 caracteres.');
          Abort;
        end;
      end;
    end;
    
    if LimpaNumero(Form7.ibDataSet13.FieldByname('CRT').AsString) <> '' then
    begin
      Form7.spdNFeDataSets.Campo('CRT_C21').Value      := LimpaNumero(Form7.ibDataSet13.FieldByname('CRT').AsString); // 1 - Simples nacional 2 - Simples Nacional excesso 3 - Regime normal
    end else
    begin
      Form7.spdNFeDataSets.Campo('CRT_C21').Value      := '1'; // 1 - Simples nacional 2 - Simples Nacional excesso 3 - Regime normal
    end;

    if Form1.sVersaoLayout = '4.00' then
    begin
      Form7.spdNFeDataSets.Campo('versao_A02').Value  := '4.00'; // Versão do Layout que está utilizando
    end else
    begin
      Form7.spdNFeDataSets.Campo('versao_A02').Value  := '3.10'; // Versão do Layout que está utilizando
    end;
    
    try
      Form7.spdNFeDataSets.Salvar; // Salva DataSets e Converte em XML montando um LOTE de XMLS a ser assinados
    except
      on E: Exception do
      begin
        Application.MessageBox(pChar(E.Message+chr(10)+
        chr(10)+'Leia atentamente a mensagem acima e tente resolver o problema. Considere pedir ajuda ao seu contador para o preenchimento correto da NF-e.'
        ),'Atenção',mb_Ok + MB_ICONWARNING);
        
        Form7.ibDataSet15.Edit;
        Form7.ibDataSet15STATUS.AsString    := 'Erro: Ao salvar XML.';
        Abort;
      end;
    end;

    try
      Form7.Panel7.Caption          := 'Fechando arquivo XML...'+replicate(' ',100);
      Form7.Panel7.Repaint;
      fNFe := Form7.spdNFeDataSets.LoteNFe.GetText;  //Copia XML que está Componente p/ Field fNFe
    except
      Form7.ibDataset15.Edit;
      Form7.ibDataSet15STATUS.AsString    := 'Erro: No XML';
      Form7.ibDataset15.Post;
      Form7.ibDataset15.Edit;
      Abort;
    end;

    // Permite alterar quaquer coisa na nfe modo DBUG
    sLote := Form7.ibDataSet15.FieldByname('NUMERONF').AsString;

    if Form1.sModoDbug = 'S0S' then
    begin
      AssignFile(F,pChar(Form1.sAtual+'\dbug.txt'));  // Direciona o arquivo F para EXPORTA.TXT
      Rewrite(F);
      Writeln(F,fNFe);
      CloseFile(F);

      ShellExecute( 0, 'Open',pChar(Form1.sAtual+'\dbug.txt'),'','', SW_SHOWMAXIMIZED);
      ShowMessage('Tecle Ok para continuar');

      if FileExists(pChar(Form1.sAtual+'\dbug.txt')) then
      begin
        _file := TStringList.Create;
        _file.LoadFromFile(pChar(Form1.sAtual+'\dbug.txt'));

        fNFe := _File.Text;
      end;
    end;

    Result := fNFe;
  finally
    if Form7.ibDataSet16.Active then
      Form7.ibDataSet16.First;
    Form7.ibDataSet16.EnableControls; // Sandro Silva 2023-05-09
    if Form7.ibDataSet23.Active then
      Form7.ibDataSet23.First;
    Form7.ibDataSet23.EnableControls; // Sandro Silva 2023-05-09
  end;
end;



procedure CsosnComOrigemdoProdutoNaOperacao(sCodigo: String; sOperacao: String;
  ItemNF: TItemNFe);
var
  IBQESTOQUE: TIBQuery;
  IBQICM: TIBQuery;
  sReg: String;
begin
  if (Trim(sCodigo) <> '') and (Trim(sOperacao) <> '') then
  begin
    IBQESTOQUE := Form7.CriaIBQuery(Form7.ibDataSet4.Transaction);
    IBQICM     := Form7.CriaIBQuery(Form7.ibDataSet4.Transaction);

    IBQESTOQUE.Close;
    IBQESTOQUE.SQL.Text := ' select ST, CSOSN, CST ' +
                           ' from ESTOQUE ' +
                           ' where CODIGO = :CODIGO';
    IBQESTOQUE.ParamByName('CODIGO').AsString := sCodigo;
    IBQESTOQUE.Open;

    IBQICM.Close;
    IBQICM.SQL.Text := ' select * ' +
                       ' from ICM ' +
                       ' where upper(NOME) = upper(:OPERACAO) ' +
                       ' order by upper(NOME)';
    IBQICM.ParamByName('OPERACAO').AsString := sOperacao;
    IBQICM.Open;

    if AllTrim(IBQESTOQUE.FieldByName('ST').AsString) <> '' then       // Quando alterar esta rotina alterar também retributa Ok 1/ Abril
    begin
      sReg := IBQICM.FieldByName('REGISTRO').AsString;
      IBQICM.DisableControls;
      IBQICM.Close;
      IBQICM.SQL.Clear;
      IBQICM.SQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
      IBQICM.Open;
      if not IBQICM.Locate('ST', IBQESTOQUE.FieldByName('ST').AsString, [loCaseInsensitive, loPartialKey]) then
        IBQICM.Locate('REGISTRO', sReg, []);
      IBQICM.EnableControls;

      if not (AllTrim(IBQICM.FieldByName('CSOSN').AsString) <> '') then
      begin
        IBQICM.DisableControls;
        IBQICM.Close;
        IBQICM.SQL.Clear;
        IBQICM.SQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
        IBQICM.Open;
        IBQICM.Locate('NOME', sOperacao, []);
        IBQICM.EnableControls;
      end;
    end else
    begin
      IBQICM.DisableControls;
      IBQICM.Close;
      IBQICM.SQL.Clear;
      IBQICM.SQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
      IBQICM.Open;
      IBQICM.Locate('NOME', sOperacao, []);
      IBQICM.EnableControls;
    end;

    if Trim(IBQICM.FieldByName('CSOSN').AsString) <> '' then
      ItemNF.CSOSN := IBQICM.FieldByname('CSOSN').AsString
    else
      ItemNF.CSOSN := IBQESTOQUE.FieldByname('CSOSN').AsString;
    ItemNF.Codigo := sCodigo;

    try
      if AllTrim(IBQICM.FieldByName('CST').AsString) <> '' then
        ItemNF.Origem   := Copy(LimpaNumero(IBQICM.FieldByname('CST').AsString) + '000', 1, 1) //Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
      else
        ItemNF.Origem   := Copy(LimpaNumero(IBQESTOQUE.FieldByname('CST').AsString) + '000', 1, 1); //Origemd da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)

    except
      ItemNF.Origem   := '0';
    end;

    FreeAndNil(IBQESTOQUE);
    FreeAndNil(IBQICM);
  end;
end;


end.
