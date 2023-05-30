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
  , uClasseDllRecursos
  ;

type
  TRecurcosDisponiveisParaLicenca = class(TComponent)
  private
    FIBTransaction: TIBTransaction;
    FRecursos: TRecursosLicenca;
    FQtdDocumentosFrente: Integer;
    FSerial: String;
    FLimiteUsuarios: Integer;
    function GetSerial: String;
    function GetLimiteUsuarios: Integer;
    function GetQtdDocumentosFrente: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ValidaQtdDocumentoFrente: Boolean;
    function PermiteRecursoParaSerial: Boolean;
    property IBQTransaction: TIBTransaction read FIBTransaction write FIBTransaction;
    property QtdDocumentosFrente: Integer read GetQtdDocumentosFrente write FQtdDocumentosFrente;
    property Serial: String read GetSerial write FSerial;
    property LimiteUsuarios: Integer read GetLimiteUsuarios write FLimiteUsuarios;
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

{ TRecurcosDisponiveisParaLicenca }

constructor TRecurcosDisponiveisParaLicenca.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIBTransaction := TIBTransaction.Create(nil);
  FRecursos := TRecursosLicenca.Create; // Create(AOwner);
  FRecursos.Inicializa;
end;

destructor TRecurcosDisponiveisParaLicenca.Destroy;
begin
  FRecursos.Free;
  //FreeAndNil(FRecursos);
// causa exception (não entendi porque)
  inherited;
end;

function TRecurcosDisponiveisParaLicenca.GetLimiteUsuarios: Integer;
begin
  FLimiteUsuarios := FRecursos.LimiteUsuarios;
  Result := FLimiteUsuarios;
end;

function TRecurcosDisponiveisParaLicenca.GetQtdDocumentosFrente: Integer;
begin
  FQtdDocumentosFrente := FRecursos.Quantidade(rcQtdNFCE);
  Result := FQtdDocumentosFrente;
end;

function TRecurcosDisponiveisParaLicenca.GetSerial: String;
begin
  FSerial := FRecursos.SerialSistema;
  Result := FSerial;
end;

function TRecurcosDisponiveisParaLicenca.PermiteRecursoParaSerial: Boolean;
begin
  Result := True;
  if Copy(FSerial, 4, 1) = 'T' then
    Result := False;
end;

function TRecurcosDisponiveisParaLicenca.ValidaQtdDocumentoFrente: Boolean;
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

    iQtdPermitido := FRecursos.Quantidade(rcQtdNFCE);// FQtdDocumentosFrente; // FRecursos.Quantidade(rcQtdNFCE);

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
          'where DATA >= :INI  ' + // Sandro Silva 2023-05-30'where DATA between :INI and :FIM ' +
          'and ( ' + SituacaoSatEmitidoOuCancelado + '  or ' + SituacaoNFCeEmitidoOuCancelado + '  or ' + SituacaoMEIEmitidoOuCancelado + ' )';
        IBQDOC.ParamByName('INI').AsString := '01' + FormatDateTime('/mm/yyyy', dtDataServidor);
        //IBQDOC.ParamByName('FIM').AsString := FormatFloat('00', DaysInAMonth(YearOf(dtDataServidor), MonthOf(dtDataServidor))) + FormatDateTime('/mm/yyyy', dtDataServidor);
        IBQDOC.Open;

        iQtdEmitido := IBQDOC.FieldByName('DOCUMENTOSEMITIDOS').AsInteger;

        IBQDOC.Close;

        //if (iQtdEmitido >= 1) and (iQtdEmitido <= iQtdPermitido) then
        if (iQtdPermitido - iQtdEmitido) > 0 then
          Result := True;

      end;

    end;

  end;

  if IBQDOC <> nil then
    FreeAndNil(IBQDOC);

end;

end.
