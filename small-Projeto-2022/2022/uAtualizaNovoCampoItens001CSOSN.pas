// Unit criada para atualizar novo campo ITENS001.CSOSN
// O campo será atualizado apenas nos registros referentes as NF-e emitidas no
// período definido.
// A atualização não é feita quando o campo é criado para evitar que o sistema
// fique lento na atualização do banco.
// Conforme o usuário for gerando os relatórios ITENS001.CSOSN será atualizado

unit uAtualizaNovoCampoItens001CSOSN;

interface

uses
  IBDatabase
  , IBQuery
  , Controls
  , SysUtils
  ;

function AtualizaItens001CsosnFromXML(IBTransaction: TIBTransaction;
  dtInicio: TDate; dtFim: TDate): Boolean;

implementation

uses
  uSmallNFeUtils
  ;

function AtualizaItens001CsosnFromXML(IBTransaction: TIBTransaction;
  dtInicio: TDate; dtFim: TDate): Boolean;
var
  IBQVendas: TIBQuery;
  IBQItens001: TIBQuery;
  IBQEstoque: TIBQuery;
  NFe: TSmallNFeUtils;
  sCSOSN: String;
  sPathCSOSN: String;
  iNode: Integer;
  sReferencia: String;
  sCodigo: String;
begin
  Result := False; 
  IBQVendas   := TIBQuery.Create(nil);
  IBQItens001 := TIBQuery.Create(nil);
  IBQEstoque  := TIBQuery.Create(nil);

  IBQVendas.Transaction   := IBTransaction;
  IBQItens001.Transaction := IBTransaction;
  IBQEstoque.Transaction  := IBTransaction;

  NFe := TSmallNFeUtils.Create;

  IBQVendas.DisableControls;
  IBQItens001.DisableControls;

  // Identifica se exite o campo ITENS001.CSOSN
  IBQItens001.Close;
  IBQItens001.SQL.Text :=
      'select F.RDB$RELATION_NAME, F.RDB$FIELD_NAME ' +
      'from RDB$RELATION_FIELDS F ' +
      'join RDB$RELATIONS R on F.RDB$RELATION_NAME = R.RDB$RELATION_NAME ' +
      'and R.RDB$VIEW_BLR is null ' +
      'and (R.RDB$SYSTEM_FLAG is null or R.RDB$SYSTEM_FLAG = 0) ' +
      'and upper(F.RDB$RELATION_NAME) = ''ITENS001'' ' +
      ' and upper(F.RDB$FIELD_NAME) = ''CSOSN'' ';
  IBQItens001.Open;

  if IBQItens001.IsEmpty = False then
  begin
    // Entre nesse if apenas se o campo existir no banco

    IBQItens001.Close;
    IBQItens001.SQL.Text :=
      'select first 1 I1.REGISTRO ' +
      'from VENDAS V ' +
      'join ITENS001 I1 on I1.NUMERONF = V.NUMERONF ' +
      'where V.STATUS containing ''Autorizad'' ' +
      ' and V.EMISSAO between :DTINI and :DTFIM ' +
      ' and coalesce(I1.CSOSN, '''') = '''' ';
    IBQItens001.ParamByName('DTINI').AsDate := dtInicio;
    IBQItens001.ParamByName('DTFIM').AsDate := dtFim;
    IBQItens001.Open;

    //Valida se existem registros com CSOSN para serem preenchido
    if IBQItens001.FieldByName('REGISTRO').AsString <> '' then
    begin

      IBQVendas.UniDirectional := True;

      IBQVendas.Close;
      IBQVendas.SQL.Text :=
        'select distinct V.NUMERONF, V.NFEXML ' +
        'from VENDAS V ' +
        'join ITENS001 I1 on I1.NUMERONF = V.NUMERONF ' +
        'where V.STATUS containing ''Autorizad'' ' +
        ' and V.EMISSAO between :DTINI and :DTFIM ' +
        ' and coalesce(V.NFEXML, '''') containing ''</CSOSN>'' ' +
        ' and coalesce(I1.CSOSN, '''') = '''' ';
      IBQVendas.ParamByName('DTINI').AsDate := dtInicio;
      IBQVendas.ParamByName('DTFIM').AsDate := dtFim;
      IBQVendas.Open;

      while IBQVendas.Eof = False do
      begin
        try
          NFe.Xml := IBQVendas.FieldByName('NFEXML').AsString;
          //
          for iNode := 0 to NFe.NodeItens.length -1 do
          begin

            sCSOSN     := '';
            sPathCSOSN := '';
            if Trim(NFe.NodeValue('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN101/CSOSN')) <> '' then // 101
              sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN101/'
            else
              if Trim(NFe.NodeValue('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN102/CSOSN')) <> '' then // 102
                sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN102/'
              else
                if Trim(NFe.NodeValue('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN201/CSOSN')) <> '' then // 201
                  sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN201/'
                else
                  if Trim(NFe.NodeValue('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN202/CSOSN')) <> '' then // 202
                    sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN202/'
                  else
                    if Trim(NFe.NodeValue('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN500/CSOSN')) <> '' then // 500
                      sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN500/'
                    else
                      if Trim(NFe.NodeValue('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN900/CSOSN')) <> '' then // 900
                        sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN900/';

            if sPathCSOSN <> '' then
            begin
              sCSOSN      := Trim(NFe.NodeValue(sPathCSOSN + 'CSOSN'));
    //          sOrigem := Copy(Trim(NFe.NodeValue(sPathCSOSN + 'orig')) + '0', 1, 1);
              sCodigo     := Trim(NFe.NodeValue('//det[' + IntToStr(iNode) + ']/prod/cProd'));
              sReferencia := StringReplace(Trim(NFe.NodeValue('//det[' + IntToStr(iNode) + ']/prod/cEAN')), 'SEM GTIN', '', [rfReplaceAll]);
              {Sandro Silva 2022-10-10 inicio
              if sReferencia = '' then
              begin
                if Length(sCodigo) > 5 then
                  sReferencia := sCodigo;
              end;

              IBQEstoque.Close;
              if (sReferencia <> '') then
              begin
                IBQEstoque.SQL.Text :=
                  'select CODIGO ' +
                  'from ESTOQUE ' +
                  'where REFERENCIA = ' + QuotedStr(sReferencia);
                IBQEstoque.Open;
              end
              else
              begin
                IBQEstoque.SQL.Text :=
                  'select CODIGO ' +
                  'from ESTOQUE ' +
                  'where CODIGO = ' + QuotedStr(sCodigo);
                IBQEstoque.Open;
              end;
              }

              IBQEstoque.Close;
              IBQEstoque.SQL.Text :=
                'select CODIGO ' +
                'from ESTOQUE ' +
                'where coalesce(REFERENCIA, '''') <> '''' ' +
                ' and REFERENCIA = ' + QuotedStr(sReferencia);
              IBQEstoque.Open;


              if Trim(IBQEstoque.FieldByName('CODIGO').AsString) = '' then
              begin
                // Não encontrou pelo EAN

                IBQEstoque.Close;
                IBQEstoque.SQL.Text :=
                  'select CODIGO ' +
                  'from ESTOQUE ' +
                  'where CODIGO = ' + QuotedStr(sCodigo) +  ' or TAGS_ like ' + QuotedStr('%<cProd>' + sCodigo + '</cProd>%') +
                  ' order by CODIGO';
                IBQEstoque.Open;
              end;

              {Sandro Silva 2022-10-10 fim}

              if IBQEstoque.Active then
              begin

                if Trim(IBQEstoque.FieldByName('CODIGO').AsString) <> '' then
                begin
                  IBQItens001.Close;
                  IBQItens001.SQL.Text :=
                    'update ITENS001 set ' +
                    'CSOSN = :CSOSN ' +
                    'where CODIGO = :CODIGO ' +
                    ' and NUMERONF = :NUMERONF ' +
                    ' and coalesce(CSOSN, '''') = '''' ';
                  IBQItens001.ParamByName('CSOSN').AsString    := sCSOSN;
                  IBQItens001.ParamByName('CODIGO').AsString   := IBQEstoque.FieldByName('CODIGO').AsString;
                  IBQItens001.ParamByName('NUMERONF').AsString := IBQVendas.FieldByName('NUMERONF').AsString;
                  IBQItens001.ExecSQL;
                end;
              end;

            end;

          end;

        except
        end;

        IBQVendas.Next;
      end;
      Result := True;
    end; // if IBQItens001.FieldByName('REGISTRO').AsString <> '' then

  end; //if IBQItens001.IsEmpty = False then

  FreeAndNil(NFe);

  FreeAndNil(IBQEstoque);
  FreeAndNil(IBQVendas);
  FreeAndNil(IBQItens001);

end;

end.

