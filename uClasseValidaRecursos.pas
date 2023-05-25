{ *********************************************************************** }
{                                                                         }
{                                                                         }
{ Autor: Sandro Luis da Silva                                             }
{ *********************************************************************** }

unit uClasseValidaRecursos;

interface

uses
  Classes
  , SysUtils
  , Controls
  , DateUtils
  , IBDatabase
  , IBQuery
  , uTypesRecursos
  , uClasseRecursos
  ;

type
  TRecurcosDisponiveis = class(TComponent)
  private
    FIBTransaction: TIBTransaction;
    FRecursos: TResourceModule;
    FQtdDocumentosFrente: Integer;
    FSerial: String;
    FLimiteUsuarios: Integer;
    //function ValidaQtdDocumentoFrente: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RefreshRecursos;
    function ValidaQtdDocumentoFrente: Boolean;
    function PermiteRecursoParaSerial: Boolean;
    property IBQTransaction: TIBTransaction read FIBTransaction write FIBTransaction;
    //property Recursos: TResourceModule read FRecursos write FRecursos;
    property QtdDocumentosFrente: Integer read FQtdDocumentosFrente write FQtdDocumentosFrente;
    property Serial: String read FSerial write FSerial;
    property LimiteUsuarios: Integer read FLimiteUsuarios write FLimiteUsuarios;
  end;

implementation

//Criar uma unit para conter todas as funções de uso em comum em todos .exe
function CriaIBQuery(IBTRANSACTION: TIBTransaction): TIBQuery;
// Sandro Silva 2011-04-12 inicio Cria um objeto TIBQuery
begin
  try
    Result := TIBQuery.Create(nil); // Sandro Silva 2019-06-18 Result := TIBQuery.Create(Application);
    Result.Database    := IBTRANSACTION.DefaultDataBase;
    Result.Transaction := IBTRANSACTION;
    Result.BufferChunks := 100; // 2014-02-26 Erro de out of memory
  except
    on E: Exception do
    begin
      Result := nil;
    end
  end;
end;

{ TRecurcosDisponiveis }

constructor TRecurcosDisponiveis.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRecursos := TResourceModule.Create(AOwner);
  FRecursos.Inicializa;
end;

destructor TRecurcosDisponiveis.Destroy;
begin
  FreeAndNil(FRecursos);
  inherited;
end;

function TRecurcosDisponiveis.PermiteRecursoParaSerial: Boolean;
begin
  Result := True;
  if Copy(FSerial, 4, 1) = 'T' then
    Result := False;
end;

procedure TRecurcosDisponiveis.RefreshRecursos;
begin
  if FRecursos.Inicializada = False then
    FRecursos.Inicializa;

  if FRecursos.Inicializada then
  begin

    // FSerial := ler do banco quando estiver usando Delphi unicode

    FQtdDocumentosFrente := FRecursos.Quantidade(rcQtdNFCE);
    FSerial              := FRecursos.SerialSistema;
    FLimiteUsuarios      := FRecursos.LimiteUsuarios;

  end;
end;

function TRecurcosDisponiveis.ValidaQtdDocumentoFrente: Boolean;
const LimiteDocFiscal = 100;
const SituacaoSatEmitidoOuCancelado  = ' (MODELO = ''59'' and coalesce(NFEXML, '''') containing ''Id="'' and coalesce(NFEXML, '''') containing ''versao="'' and coalesce(NFEXML, '''') containing ''<SignatureValue>'' and coalesce(NFEXML, '''') containing ''<DigestValue>'') ' ;
const SituacaoNFCeEmitidoOuCancelado = ' (MODELO = ''65'' and coalesce(NFEXML, '''') containing ''<xMotivo>'' and coalesce(NFEIDSUBSTITUTO, '''') = '''' ) ';
const SituacaoMEIEmitidoOuCancelado  = ' (MODELO = ''99'' and (coalesce(STATUS, '''') containing ''Finalizada'' or coalesce(STATUS, '''') containing ''Cancelada'')) ';
var
  iQtdEmitido: Integer;
  iQtdPermitido: Integer;
  IBQDOC: TIBQuery;
  dtDataServidor: TDate;
begin
  Result := False;

//criar unit com objeto para amazenar as permissões e recursos, já executar os SQLs de limites para o Commerce e NFC-e/SAT

  if FRecursos.Inicializada then
  begin

    iQtdPermitido := FQtdDocumentosFrente; // FRecursos.Quantidade(rcQtdNFCE);

    Result := False;

    if iQtdPermitido = -1 then
    begin
      Result := True;
    end
    else
    begin
      if FIBTRANSACTION <> nil then
      begin
        IBQDOC := CriaIBQuery(FIBTRANSACTION);

        IBQDOC.Close;
        IBQDOC.SQL.Text := 'select current_date as DATAATUAL from RDB$DATABASE';
        IBQDOC.Open;
        dtDataServidor := IBQDOC.FieldByName('DATAATUAL').AsDateTime;

        IBQDOC.Close;
        IBQDOC.SQL.Text :=
          'select count(NUMERONF) as DOCUMENTOSEMITIDOS ' +
          'from NFCE ' +
          'where DATA between :INI and :FIM ' +
          'and ( ' + SituacaoSatEmitidoOuCancelado + '  or ' + SituacaoNFCeEmitidoOuCancelado + '  or ' + SituacaoMEIEmitidoOuCancelado + ' )';
        IBQDOC.ParamByName('INI').AsString := FormatDateTime('yyyy-mm-', dtDataServidor) + '01';
        IBQDOC.ParamByName('FIM').AsString := FormatDateTime('yyyy-mm-', dtDataServidor) + FormatFloat('00', DaysInAMonth(YearOf(dtDataServidor), MonthOf(dtDataServidor)));
        IBQDOC.Open;

        iQtdEmitido := IBQDOC.FieldByName('DOCUMENTOSEMITIDOS').AsInteger;

        if (iQtdEmitido >= 1) and (iQtdEmitido <= iQtdPermitido) then
          Result := True;
      end;
    end;

  end;

end;

end.
