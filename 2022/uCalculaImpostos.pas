{ *********************************************************************** }
{                                                                         }
{ Smallsoft Tecnologia                                                    }
{ Rotina para calculo de impostos                                         }
{                                                                         }
{ Copyright (c) Smallsoft                                                 }
{                                                                         }
{ *********************************************************************** }

unit uCalculaImpostos;

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
  , IBQuery
//  , ShellApi
//  , SpdNFeDataSets
//  , spdNFe
  , smallfunc_xe
  , unit7
//  , unit11
//  , unit29
//  , unit12
//  , Mais
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

  function CstComOrigemdoProdutoNaOperacao(sCodigo: String;
    sOperacao: String; ItemNF: TItemNFe): String;
  procedure CsosnComOrigemdoProdutoNaOperacao(sCodigo: String;
    sOperacao: String; ItemNF: TItemNFe);
  function GetPercentualDiferenciado(IcmObs: String): String;
  function ValorIcms(dAliquota: Double; dValorTotal: Double;
    dBase: Double): Double;
  function ValorIcmsDiferenciado(dValorIcms: Double;
    dPercentualDiferenciado: Double): Double;
  function CSTCalculaST(sCst: String): Boolean;

implementation

function CstComOrigemdoProdutoNaOperacao(sCodigo: String; sOperacao: String;
  ItemNF: TItemNFe): String;
var
  IBQESTOQUE: TIBQuery;
  IBQICM: TIBQuery;
begin
  {
  Combinado com Gian e Fernanda que a ordem para selecionar o CST ficará:
  Se o produto tiver CIT configurado, busca o CST do CIT
  Se não tiver CIT ou se o CIT configurado não tiver CST, busca o CST do estoque
  Se no estoque não tiver CST configurado usará por padrão “000”
  }

  if (Trim(sCodigo) <> '') and (Trim(sOperacao) <> '') then
  begin
    Result := '000';
    IBQESTOQUE  := Form7.CriaIBQuery(Form7.ibDataSet4.Transaction);
    IBQICM      := Form7.CriaIBQuery(Form7.ibDataSet4.Transaction);

    IBQESTOQUE.Close;
    IBQESTOQUE.SQL.Text :=
      'select ST, CST ' +
      'from ESTOQUE ' +
      'where CODIGO = :CODIGO';
    IBQESTOQUE.ParamByName('CODIGO').AsString := sCodigo;
    IBQESTOQUE.Open;

    IBQICM.DisableControls;
    IBQICM.Close;
    IBQICM.SQL.Clear;
    IBQICM.SQL.Text :=
      'select * from ICM ' +
      'where (substring(CFOP from 1 for 1) in (''5'', ''6'', ''7'')  or coalesce(CFOP,''XXX'') = ''XXX'') ' +
      'order by upper(NOME)';
    IBQICM.Open;

    if ItemNF <> nil then    
      ItemNF.Codigo := sCodigo;

    if (Trim(IBQESTOQUE.FieldByName('ST').AsString) <> '') 
      or ((Trim(IBQESTOQUE.FieldByName('ST').AsString) = '') and (Trim(IBQESTOQUE.FieldByname('CST').AsString) <> '')) then
    begin
      // Produto tem CIT preenchido
      if IBQICM.Locate('ST', IBQESTOQUE.FieldByName('ST').AsString, []) then
      begin
        // Cadastro do CIT tem CST 
        Result := Right('000' + Trim(IBQICM.FieldByname('CST').AsString), 3);
        if ItemNF <> nil then            
        begin
          ItemNF.Origem := Copy(LimpaNumero(IBQICM.FieldByname('CST').AsString) + '000', 1, 1); // Origem da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
          ItemNF.CST    := Right('00' + Trim(IBQICM.FieldByname('CST').AsString), 2);
        end;        
      end
      else
      begin
        // Cadastro do CIT NÃO tem CST 
        Result := Right('000' + Trim(IBQESTOQUE.FieldByname('CST').AsString), 3);
        if ItemNF <> nil then            
        begin
          ItemNF.Origem := Copy(LimpaNumero(IBQESTOQUE.FieldByname('CST').AsString) + '000', 1, 1); // Origem da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
          ItemNF.CST    := Right('00' + Trim(IBQESTOQUE.FieldByname('CST').AsString), 2);
        end;
      end;
    end
    else
    begin
      // Produto NÃO tem CIT configurado, usar CST da operação do topo da nota
      
      //Por garantia define como padrão CST 00
      Result := '000';
      if ItemNF <> nil then            
      begin
        ItemNF.Origem := '0'; // Origem da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
        ItemNF.CST    := '00';     
      end;

      if IBQICM.Locate('NOME', sOperacao, []) then
      begin
        // Posiciona na operação da nota
        Result := Right('000' + Trim(IBQICM.FieldByname('CST').AsString), 3);
        if ItemNF <> nil then            
        begin
          ItemNF.Origem := Copy(LimpaNumero(IBQICM.FieldByname('CST').AsString) + '000', 1, 1); // Origem da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
          ItemNF.CST    := Right('00' + Trim(IBQICM.FieldByname('CST').AsString), 2);     
        end;
      end;
    end;        

    FreeAndNil(IBQESTOQUE);
    FreeAndNil(IBQICM);
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

function GetPercentualDiferenciado(IcmObs: String): String;
begin
  Result := RetornaValorDaTagNoCampo('pDif', IcmObs);
end;

function ValorIcms(dAliquota: Double; dValorTotal: Double;
  dBase: Double): Double;
begin
  Result := (dAliquota * dValorTotal / 100 * dBase / 100);
end;

function ValorIcmsDiferenciado(dValorIcms: Double;
  dPercentualDiferenciado: Double): Double;
begin
  Result := dValorIcms * dPercentualDiferenciado / 100;
end;

function CSTCalculaST(sCst: String): Boolean;
begin
  Result := False;
  if (sCst = '10')
    or (sCst = '30')
    or (sCst = '70')
    or (sCst = '90') then
    Result := True;
end;

end.
