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
  IBQCST: TIBQuery;
begin
  Result := '';

  if (Trim(sCodigo) <> '') and (Trim(sOperacao) <> '') then
  begin
    IBQCST      := Form7.CriaIBQuery(Form7.ibDataSet4.Transaction);
    IBQCST.DisableControls;

    {Sandro Silva f-21199 2024-10-29
    Primeiro verificar se tem CIT, se tiver buscar o CST do CIT.
    Se n�o tiver preenchido o CST no CIT, buscar o CST do topo da nota.
    Se o do topo da nota n�o tiver CST, buscar do estoque.
    }
    IBQCST.Close;
    IBQCST.SQL.Text :=
      'select ' +
      'I.CST as CST_CIT ' +
      ', I2.CST as CST_TOPO ' +
      ', E.CODIGO, E.DESCRICAO, E.ST, E.CST as CST_ESTOQUE ' +
      'from ESTOQUE E ' +
      'left join ICM I on I.ST = E.ST ' +
      'left join ICM I2 on I2.NOME = :OPERACAO_TOPO ' +
      'where CODIGO = :CODIGO';
    IBQCST.ParamByName('CODIGO').AsString        := sCodigo;
    IBQCST.ParamByName('OPERACAO_TOPO').AsString := sOperacao;
    IBQCST.Open;

    if Trim(IBQCST.FieldByName('CST_CIT').AsString) <> '' then // Primeiro verificar se tem CIT, se tiver buscar o CST do CIT.
      Result := Trim(IBQCST.FieldByName('CST_CIT').AsString)
    else if Trim(IBQCST.FieldByName('CST_TOPO').AsString) <> '' then // Se n�o tiver preenchido o CST no CIT, buscar o CST do topo da nota.
      Result := Trim(IBQCST.FieldByName('CST_TOPO').AsString)
    else
      Result := Trim(IBQCST.FieldByName('CST_ESTOQUE').AsString);
    {Sandro Silva (f-21199) 2024-10-29 fim}

    FreeAndNil(IBQCST);
  end;

  //Por garantia define como padr�o CST 000 e extrai as �ltimas 3 posi��es
  Result := Right('000' + Result, 3);

  if ItemNF <> nil then
  begin
    ItemNF.Codigo := sCodigo;
    ItemNF.Origem := Copy(Result, 1, 1); // Origem da Mercadoria (0-Nacional, 1-Estrangeira, 2-Estrangeira adiquirida no Merc. Interno)
    ItemNF.CST    := Right(Result, 2);
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

    if AllTrim(IBQESTOQUE.FieldByName('ST').AsString) <> '' then       // Quando alterar esta rotina alterar tamb�m retributa Ok 1/ Abril
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
