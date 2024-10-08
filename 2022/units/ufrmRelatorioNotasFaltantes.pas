unit ufrmRelatorioNotasFaltantes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFormRelatorioPadrao, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls, System.DateUtils, uIEstruturaRelatorioPadrao,
  uIEstruturaTipoRelatorioPadrao, IBX.IBQuery, Data.DB, Datasnap.DBClient,
  uSmallEnumerados;

type
  TfrmRelatorioNotasFaltantes = class(TfrmRelatorioPadrao)
    pnlPrincipal: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    dtInicial: TDateTimePicker;
    dtFinal: TDateTimePicker;
    cdsNotasFaltantes: TClientDataSet;
    cdsNotasPendentes: TClientDataSet;
    cdsNotasFaltantesNUMERONF: TStringField;
    cdsNotasFaltantesSERIE: TStringField;
    cdsNotasFaltantesTIPODOC: TIntegerField;
    cdsNotasPendentesNUMERONF: TStringField;
    cdsNotasPendentesSTATUS: TStringField;
    cdsNotasPendentesTIPODOC: TIntegerField;
    cdsNotasPendentesSERIE: TStringField;
    cdsNotasPendentesDATA: TDateField;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAvancarClick(Sender: TObject);
  private
    fQryDocumentos: TIbQuery;
    fQryMaxNumero: TIbQuery;
    function RetornaDataDiaAnterior: TDateTime;
    function FazValidacoes: Boolean;
    procedure CarregaDados;
    procedure DefinirDadosClientDataSet;
    function RetornarNumeroNFAnterior(AenDoc: TDocsImprimirNotasFaltantes; AcSerie: String): string;
    function IncrementarNumeroNF(AcNumeroNf: String; AenDoc: TDocsImprimirNotasFaltantes): String;
    procedure CarregarMaxNumeracaoPorSerie;
    procedure CarregarDocumentos;
    procedure GeraEstruturaDocFaltante(AenDoc: TDocsImprimirNotasFaltantes; AoEstruturaTipoRel: IEstruturaTipoRelatorioPadrao);
    function RetornarDescricaoDoc(AenDoc: TDocsImprimirNotasFaltantes): string;
    procedure DefinirDadosClientDataSetNotasFaltante;
    procedure DefinirDadosClientDataSetNotasNaoTransmitidas;
    procedure GeraEstruturaDocPendentes(AenDoc: TDocsImprimirNotasFaltantes; AoEstruturaTipoRel: IEstruturaTipoRelatorioPadrao);
  public
    function Estrutura: IEstruturaTipoRelatorioPadrao; override;
  end;

var
  frmRelatorioNotasFaltantes: TfrmRelatorioNotasFaltantes;

const
  _cSerieNFCe = '10000';

implementation

uses
  uDialogs, uSmallConsts, uSmallResourceString, uEstruturaTipoRelatorioPadrao,
  uFuncoesBancoDados, smallfunc_xe, uEstruturaRelNotasFaltantes,
  uDadosRelatorioPadraoDAO, uFiltrosRodapeRelatorioPadrao,
  uIFiltrosRodapeRelatorio;

{$R *.dfm}

{ TfrmRelatorioNotasFaltantes }

procedure TfrmRelatorioNotasFaltantes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FoArquivoDAT.Usuario.Outros.PeriodoInicial := dtInicial.Date;
  FoArquivoDAT.Usuario.Outros.PeriodoFinal   := dtFinal.Date;
  inherited;
end;

procedure TfrmRelatorioNotasFaltantes.FormCreate(Sender: TObject);
begin
  inherited;
  if cdsNotasFaltantes.Active then
    cdsNotasFaltantes.Close;
  if cdsNotasPendentes.Active then
    cdsNotasPendentes.Close;

  cdsNotasFaltantes.CreateDataSet;
  cdsNotasPendentes.CreateDataSet;
end;

procedure TfrmRelatorioNotasFaltantes.FormDestroy(Sender: TObject);
begin
  if not Assigned(fQryDocumentos) then
    FreeAndNil(fQryDocumentos);
  if not Assigned(fQryMaxNumero) then
    FreeAndNil(fQryMaxNumero);
  inherited;
end;

procedure TfrmRelatorioNotasFaltantes.FormShow(Sender: TObject);
begin
  inherited;

  dtInicial.Date := FoArquivoDAT.Usuario.Outros.PeriodoInicial;
  dtFinal.Date   := FoArquivoDAT.Usuario.Outros.PeriodoFinal;
end;

function TfrmRelatorioNotasFaltantes.RetornaDataDiaAnterior: TDateTime;
begin
  // Pega um dia antes para saber qual a numeracao de NOTA inicial
  Result := IncDay(dtInicial.Date, -1);
end;

function TfrmRelatorioNotasFaltantes.Estrutura: IEstruturaTipoRelatorioPadrao;
var
  oEstruturaRel: IEstruturaRelatorioPadrao;
  oFiltros: IFiltrosRodapeRelatorio;
  i: Integer;
begin
  oEstruturaRel := TEstruturaRelNotasFaltantes.New
                                              .setDAO(TDadosRelatorioPadraoDAO.New
                                                                              .setDataBase(DataBase)
                                                            );
  Result := TEstruturaTipoRelatorioPadrao.New
                                         .setUsuario(Usuario)
                                         .GerarImpressaoCabecalho(oEstruturaRel);
  CarregaDados;


  // Vai passar por todos os ENumerados
  for i := 0 to Ord(High(TDocsImprimirNotasFaltantes))do
    GeraEstruturaDocFaltante(TDocsImprimirNotasFaltantes(i), Result);

  Result.AdicionarTitulo('PENDENTES DE TRANSMISSÃO');

  // Vai passar por todos os ENumerados
  for i := 0 to Ord(High(TDocsImprimirNotasFaltantes))do
    GeraEstruturaDocPendentes(TDocsImprimirNotasFaltantes(i), Result);

  oFiltros := TFiltroRodapeRelPadrao.New
                                    .setFiltroData('Período analisado, de '+DateToStr(dtInicial.Date)+' até '+DateToStr(dtFinal.Date));

  Result.AdicionarRodape(oFiltros);
end;

procedure TfrmRelatorioNotasFaltantes.GeraEstruturaDocPendentes(AenDoc: TDocsImprimirNotasFaltantes; AoEstruturaTipoRel: IEstruturaTipoRelatorioPadrao);
var
  oEstruturaCat: IEstruturaRelatorioPadrao;
begin
  cdsNotasPendentes.Filtered := False;
  cdsNotasPendentes.Filter   := '(TIPODOC=' + Ord(AenDoc).ToString + ')';
  cdsNotasPendentes.Filtered := True;

  if AenDoc = dinfNFe then
    cdsNotasPendentesSERIE.DisplayLabel := 'Série'
  else
    cdsNotasPendentesSERIE.DisplayLabel := 'Caixa';

//  if cdsNotasPendentes.IsEmpty then
//    Exit;

  oEstruturaCat := TEstruturaRelNotasFaltantes.New
                                              .setDAO(TDadosRelatorioPadraoDAO.New
                                                                              .setDataBase(Transaction.DefaultDatabase)
                                                                              .CarregarDados(cdsNotasPendentes)
                                                            );

  AoEstruturaTipoRel.AdicionarTitulo(RetornarDescricaoDoc(AenDoc), (Ord(AenDoc) > 0), False);

  AoEstruturaTipoRel.GerarImpressaoAgrupado(oEstruturaCat, EmptyStr);
end;

procedure TfrmRelatorioNotasFaltantes.GeraEstruturaDocFaltante(AenDoc: TDocsImprimirNotasFaltantes; AoEstruturaTipoRel: IEstruturaTipoRelatorioPadrao);
var
  oEstruturaCat: IEstruturaRelatorioPadrao;
begin
  cdsNotasFaltantes.Filtered := False;
  cdsNotasFaltantes.Filter   := '(TIPODOC=' + Ord(AenDoc).ToString + ')';
  cdsNotasFaltantes.Filtered := True;

  cdsNotasFaltantesSERIE.Visible := (AenDoc = dinfNFe);

//  if cdsNotasFaltantes.IsEmpty then
//    Exit;

  oEstruturaCat := TEstruturaRelNotasFaltantes.New
                                              .setDAO(TDadosRelatorioPadraoDAO.New
                                                                              .setDataBase(Transaction.DefaultDatabase)
                                                                              .CarregarDados(cdsNotasFaltantes)
                                                            );

  AoEstruturaTipoRel.AdicionarTitulo(RetornarDescricaoDoc(AenDoc), (Ord(AenDoc) > 0), False);

  AoEstruturaTipoRel.GerarImpressaoAgrupado(oEstruturaCat, EmptyStr);
end;

function TfrmRelatorioNotasFaltantes.RetornarDescricaoDoc(AenDoc: TDocsImprimirNotasFaltantes): string;
begin
  case AenDoc of
    dinfNFe : Result := 'NF-e';
    dinfNFCe: Result := 'NFC-e';
  end;
end;

function TfrmRelatorioNotasFaltantes.FazValidacoes: Boolean;
begin
  Result := False;

  if ((dtInicial.Date = 0) or (dtFinal.Date = 0)) or (dtInicial.Date > dtFinal.Date) then
  begin
    MensagemSistema(_cPeriodoDataInvalida,msgAtencao);
    dtInicial.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TfrmRelatorioNotasFaltantes.CarregarDocumentos;
begin
  if not Assigned(fQryDocumentos) then
    fQryDocumentos := CriaIBQuery(Transaction);

  fQryDocumentos.Close;
  fQryDocumentos.SQL.Clear;
  fQryDocumentos.SQL.Add('select');
  fQryDocumentos.SQL.Add('    '+Ord(dinfNFe).ToString+' as TIPODOC');
  fQryDocumentos.SQL.Add('    , substring(VENDAS.NUMERONF from 1 for 9) as NUMERONF');
  fQryDocumentos.SQL.Add('    , VENDAS.STATUS');
  fQryDocumentos.SQL.Add('    , substring(VENDAS.NUMERONF from 10 for 3) as SERIE');
  fQryDocumentos.SQL.Add('    , VENDAS.EMISSAO as DATA');
  fQryDocumentos.SQL.Add('from VENDAS');
  fQryDocumentos.SQL.Add('where');
  fQryDocumentos.SQL.Add('    (VENDAS.MODELO=''55'')');
  fQryDocumentos.SQL.Add('    and (coalesce(VENDAS.NUMERONF,'''') <> '''')');
  fQryDocumentos.SQL.Add('    and (VENDAS.EMISSAO between :XDATAINI and :XDATAFIM)');
  fQryDocumentos.SQL.Add('union all');
  fQryDocumentos.SQL.Add('select');
  fQryDocumentos.SQL.Add('    '+Ord(dinfNFCe).ToString+' as TIPODOC');
  fQryDocumentos.SQL.Add('    , NFCE.NUMERONF');
  fQryDocumentos.SQL.Add('    , NFCE.STATUS');
  fQryDocumentos.SQL.Add('    , '+QuotedStr(_cSerieNFCe)+' as SERIE');
  fQryDocumentos.SQL.Add('    , NFCE.DATA');
  fQryDocumentos.SQL.Add('from NFCE');
  fQryDocumentos.SQL.Add('where');
  fQryDocumentos.SQL.Add('    (NFCE.MODELO=''65'')');
  fQryDocumentos.SQL.Add('    and (coalesce(NFCE.NUMERONF,'''') <> '''')');
  fQryDocumentos.SQL.Add('    and (NFCE.DATA between :XDATAINI and :XDATAFIM)');
  fQryDocumentos.SQL.Add('order by 1,4,2');
  fQryDocumentos.ParamByName('XDATAINI').AsDate := dtInicial.Date;
  fQryDocumentos.ParamByName('XDATAFIM').AsDate := dtFinal.Date;
  fQryDocumentos.Open;
  fQryDocumentos.First;
end;

procedure TfrmRelatorioNotasFaltantes.btnAvancarClick(Sender: TObject);
begin
  if not FazValidacoes then
    Exit;
  inherited;
end;

procedure TfrmRelatorioNotasFaltantes.CarregaDados;
begin
  CarregarMaxNumeracaoPorSerie;
  CarregarDocumentos;
  DefinirDadosClientDataSet;
end;

procedure TfrmRelatorioNotasFaltantes.CarregarMaxNumeracaoPorSerie;
begin
  if not Assigned(fQryMaxNumero) then
    fQryMaxNumero := CriaIBQuery(Transaction);

  fQryMaxNumero.Close;
  fQryMaxNumero.SQL.Clear;
  fQryMaxNumero.SQL.Add('select');
  fQryMaxNumero.SQL.Add('    '+Ord(dinfNFe).ToString+' as TIPODOC');
  fQryMaxNumero.SQL.Add('    , substring(VENDAS.NUMERONF from 10 for 3) as SERIE');
  fQryMaxNumero.SQL.Add('    , max(substring(VENDAS.NUMERONF from 1 for 9)) as NUMERO');
  fQryMaxNumero.SQL.Add('from VENDAS');
  fQryMaxNumero.SQL.Add('where');
  fQryMaxNumero.SQL.Add('    (VENDAS.MODELO=''55'')');
  fQryMaxNumero.SQL.Add('    and (coalesce(VENDAS.NUMERONF,'''') <> '''')');
  fQryMaxNumero.SQL.Add('    and (VENDAS.EMISSAO <= :XDATA)');
  fQryMaxNumero.SQL.Add('group by 2');
  fQryMaxNumero.SQL.Add('union all');
  fQryMaxNumero.SQL.Add('select');
  fQryMaxNumero.SQL.Add('    '+Ord(dinfNFCe).ToString+' as TIPODOC');
  fQryMaxNumero.SQL.Add('    , '+QuotedStr(_cSerieNFCe)+' as SERIE'); // NFCe não tem controle de caixa
  fQryMaxNumero.SQL.Add('    , max(NFCE.NUMERONF) as NUMERO');
  fQryMaxNumero.SQL.Add('from NFCE');
  fQryMaxNumero.SQL.Add('where');
  fQryMaxNumero.SQL.Add('    (NFCE.MODELO=''65'')');
  fQryMaxNumero.SQL.Add('    and (coalesce(NFCE.NUMERONF,'''') <> '''')');
  fQryMaxNumero.SQL.Add('    and (NFCE.DATA <= :XDATA)');
  fQryMaxNumero.SQL.Add('group by 2');
  fQryMaxNumero.SQL.Add('order by 1,2');
  fQryMaxNumero.ParamByName('XDATA').AsDate := RetornaDataDiaAnterior;
  fQryMaxNumero.Open;
  fQryMaxNumero.First;
end;

procedure TfrmRelatorioNotasFaltantes.DefinirDadosClientDataSet;
begin
  DefinirDadosClientDataSetNotasFaltante;
  DefinirDadosClientDataSetNotasNaoTransmitidas;
end;

procedure TfrmRelatorioNotasFaltantes.DefinirDadosClientDataSetNotasNaoTransmitidas;
const
  _cStatusIgnorar = ';Autorizado o uso da NF-e;'+
                    'NF-e cancelada;' +
                    'Autorizado o uso da NFC-e;'+
                    'Cancelamento Registrado e vinculado a NFCe;' +
                    'Autorizado o uso da NFC-e em ambiente de homologação;';
begin
  fQryDocumentos.First;
  while not fQryDocumentos.Eof do
  begin
    if Pos(';'+AnsiUpperCase(FQryDocumentos.FieldByName('STATUS').AsString)+';', AnsiUpperCase(_cStatusIgnorar)) <= 0 then
    begin
      cdsNotasPendentes.Append;
      cdsNotasPendentesTIPODOC.AsInteger := fQryDocumentos.FieldByName('TIPODOC').AsInteger;
      cdsNotasPendentesNUMERONF.AsString := fQryDocumentos.FieldByName('NUMERONF').AsString;
      cdsNotasPendentesSERIE.AsString    := fQryDocumentos.FieldByName('SERIE').AsString;
      cdsNotasPendentesDATA.AsDateTime   := fQryDocumentos.FieldByName('DATA').AsDateTime;
      cdsNotasPendentesSTATUS.AsString   := fQryDocumentos.FieldByName('STATUS').AsString;
      cdsNotasPendentes.Post;
    end;

    fQryDocumentos.Next;
  end;
end;

procedure TfrmRelatorioNotasFaltantes.DefinirDadosClientDataSetNotasFaltante;
var
  cNota, cSerie: string;
  enTipoDoc: TDocsImprimirNotasFaltantes;
begin
  cNota  := EmptyStr;
  cSerie := EmptyStr;

  fQryDocumentos.First;
  while not fQryDocumentos.Eof do
  begin
    if enTipoDoc <> TDocsImprimirNotasFaltantes(fQryDocumentos.FieldByName('TIPODOC').AsInteger) then
    begin
      cNota  := EmptyStr;
      cSerie := EmptyStr;
    end;
    case TDocsImprimirNotasFaltantes(fQryDocumentos.FieldByName('TIPODOC').AsInteger) of
      dinfNFe:
      begin
        if (cSerie <> fQryDocumentos.FieldByName('SERIE').AsString) or (enTipoDoc <> TDocsImprimirNotasFaltantes(fQryDocumentos.FieldByName('TIPODOC').AsInteger)) then
        begin
          enTipoDoc := TDocsImprimirNotasFaltantes(fQryDocumentos.FieldByName('TIPODOC').AsInteger);
          cSerie := fQryDocumentos.FieldByName('SERIE').AsString;
          cNota := RetornarNumeroNFAnterior(enTipoDoc, cSerie);
        end;
        if cNota = EmptyStr then
          cNota := fQryDocumentos.FieldByName('NUMERONF').AsString;
      end;
      dinfNFCe:
      begin
        enTipoDoc := TDocsImprimirNotasFaltantes(fQryDocumentos.FieldByName('TIPODOC').AsInteger);
        if cNota = EmptyStr then
        begin
          cNota := RetornarNumeroNFAnterior(enTipoDoc, _cSerieNFCe);
          if cNota = EmptyStr then
            cNota := fQryDocumentos.FieldByName('NUMERONF').AsString;
        end;

        cSerie := EmptyStr; // NFCe não controla caixa
      end;
    end;

    while cNota.ToInteger < (FQryDocumentos.FieldByName('NUMERONF').AsString).ToInteger do
    begin
      cNota := IncrementarNumeroNF(cNota, enTipoDoc);

      if cNota <> fQryDocumentos.FieldByName('NUMERONF').AsString then
      begin
        cdsNotasFaltantes.Append;
        cdsNotasFaltantesTIPODOC.AsInteger := Ord(enTipoDoc);
        cdsNotasFaltantesNUMERONF.AsString := cNota;
        cdsNotasFaltantesSERIE.AsString    := cSerie;
        cdsNotasFaltantes.Post;
      end;
    end;

    fQryDocumentos.Next;
  end;
end;

function TfrmRelatorioNotasFaltantes.IncrementarNumeroNF(AcNumeroNf: String; AenDoc: TDocsImprimirNotasFaltantes): String;
begin
  case AenDoc of
    dinfNFe:
    begin
      Result := StrZero(StrToFloat(IntToStr(StrToInt(AcNumeroNf)+1)),9,0);
    end;
    dinfNFCe: Result := StrZero(StrToFloat(IntToStr(StrToInt(AcNumeroNf)+1)),6,0);
  end;
end;

function TfrmRelatorioNotasFaltantes.RetornarNumeroNFAnterior(AenDoc: TDocsImprimirNotasFaltantes; AcSerie: String): String;
begin
  Result := EmptyStr;

  if (AcSerie = fQryMaxNumero.FieldByName('SERIE').AsString) and (AenDoc = TDocsImprimirNotasFaltantes(fQryMaxNumero.FieldByName('TIPODOC').AsInteger)) then
    Result := fQryMaxNumero.FieldByName('NUMERO').AsString
  else
  begin
    fQryMaxNumero.First;

    while not fQryMaxNumero.Eof do
    begin
      if (AcSerie = fQryMaxNumero.FieldByName('SERIE').AsString) and (AenDoc = TDocsImprimirNotasFaltantes(fQryMaxNumero.FieldByName('TIPODOC').AsInteger)) then
      begin
        Result := fQryMaxNumero.FieldByName('NUMERO').AsString;
        Break;
      end;

      fQryMaxNumero.Next;
    end;
  end;
end;

end.
