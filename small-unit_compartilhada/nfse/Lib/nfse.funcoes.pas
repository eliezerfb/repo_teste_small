unit nfse.funcoes;


interface

uses
  System.Classes, System.SysUtils, System.Types, IOUtils, System.IniFiles,

  ACBrNFSeXConversao,

  nfse.classe.retorno,
  nfse.classe.search,
  nfse.constants,
  nfse.retorna_filaws;

type
  TXML = class
  private
    Fcnpj: string;
    FarquivoSoap: boolean;
  public
    property cnpj: string read Fcnpj write Fcnpj;
    property arquivoSoap : boolean read FarquivoSoap write FarquivoSoap;

    function anexa_xml: TStringList;
    procedure deleta_xml;
  end;


function TemAtributo(Attr, Val: Integer): Boolean;
function MsgAllowOffLine(AMsg: String): Boolean;
function InsereXMLConsulta(ClasseSearch: TClasseSearch) : TStringList;
function InsereXML(cnpj: string; salvar_arquivoSoap : boolean) : TStringList;
function getEndPointSend: string;
function getEndPointSearch: string;
function getEndPointCancel: string;
function getEndPointEnviaXml: string;
function getPathSchemas(): String;
function SoNumero(ATexto: String): variant;
function getSectionIni(ASection: String): String;
function getArquivoPfx(): String;

procedure DeleteXML(cnpj : string);
function GetModoEnvio(AModoEnvioFacil: Integer): TmodoEnvio;


implementation

function SoNumero(ATexto: String): variant;
var
	aChar: Char;
begin
	Result := string.Empty;
	for aChar in ATexto do
		if aChar in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] then
			Result := Result + aChar;
end;
function getEndPointSend() : string;
begin
  var endPointSend: String := getSectionIni(INI_ENDPOINT_SEND_TEST);

  if endPointSend <> EmptyStr then
    Result := endPointSend
  else
    Result := endpoint_send;
end;

function getEndPointSearch() : string;
begin
  var endPointSearch: String := getSectionIni(INI_ENDPOINT_SEARCH_TEST);

  if endPointSearch <> EmptyStr then
    Result := endPointSearch
  else
    Result := endpoint_search;
end;

function getEndPointCancel : string;
begin
  var endPointCancel: String := getSectionIni(INI_ENDPOINT_CANCEL_TEST);

  if endPointCancel <> EmptyStr then
    Result := endPointCancel
  else
    Result := endpoint_cancel;
end;

function getEndPointEnviaXml : string;
begin
  var endPointEnviaXML: String := getSectionIni(INI_ENDPOINT_ENVIA_XML_TEST);

  if endPointEnviaXML <> EmptyStr then
    Result := endPointEnviaXML
  else
    Result := endpoint_envia_xml;
end;

function TemAtributo(Attr, Val: Integer): Boolean;
begin
  Result := Attr and Val = Val;
end;

function MsgAllowOffLine(AMsg: String): Boolean;
begin
  if pos('Host not found', AMsg) > 0 then
    Exit(True);

  if pos('Connection refused', AMsg) > 0 then
    Exit(True);

  Result := False;
end;

function InsereXMLConsulta(ClasseSearch : TClasseSearch) : TStringList;

var
  anexaxml : TXML;
begin
  anexaxml := TXML.Create;
  try
    anexaxml.cnpj := ClasseSearch.Provedor.EmitenteCnpj;
    anexaxml.arquivoSoap := ClasseSearch.Provedor.SalvarArquivoSoap;
    Result := anexaxml.anexa_xml;
  finally
//    FreeAndNil(anexaxml);
  end;
end;

function InsereXML(cnpj : string; salvar_arquivoSoap : boolean) : TStringList;
var
  anexaxml : TXML;
begin
  anexaxml := TXML.Create;
  try
    anexaxml.cnpj := cnpj;
    anexaxml.arquivoSoap := salvar_arquivoSoap;
    Result := anexaxml.anexa_xml;
  finally
    FreeAndNil(anexaxml);
  end;
end;


{ TenviaXML }

{ TAnexarXML }

procedure DeleteXML(cnpj : string);
var
  DeletaXML : TXML;
begin
  DeletaXML := TXML.Create;
  try
    DeletaXML.cnpj := cnpj;
    DeletaXML.deleta_xml;
  finally
   FreeAndNil(DeletaXML);
  end;
end;

function TXML.anexa_xml: TStringList;
var
  xml : TStringList;
  caminho : string;

  procedure anexa_arquivos(caminho : string);
  var
    temp : string;
  begin
    if DirectoryExists(caminho) then
    begin
      for temp in TDirectory.GetFiles(caminho) do
      begin
        if not arquivoSoap then
        begin
          if pos('soap',temp) = 0 then
            XML.Add(temp);
        end
        else
        begin
          if pos('-ped-can.xml',temp) = 0 then
            XML.Add(temp);
        end;
      end;
    end;
  end;
begin
  xml := TStringList.Create;
  try
    if FileExists('/home/ian/ian.txt') then
      caminho := ExtractFileDir(GetCurrentDir)+ '/servernfse/'+cnpj
    else
      caminho := './'+cnpj;
    anexa_arquivos(caminho+'/Recibos');
    anexa_arquivos(caminho+'/Eventos');
    anexa_arquivos(caminho+'/Notas');
  finally
    Result := xml;
  end;
end;

procedure TXML.deleta_xml;
var
  caminho : string;
  arquivos: TStringDynArray;

  procedure deleta_arquivos(caminho : string);
  var
    temp : string;
  begin
    if TDirectory.Exists(caminho) then
    begin
      arquivos := TDirectory.GetFiles(caminho);
      for temp in arquivos do
      begin
        TFile.Delete(temp);
      end;
      if TDirectory.IsEmpty(caminho) then
      begin
        TDirectory.Delete(caminho);
      end;
    end;
  end;
begin
  if FileExists('/home/ian/ian.txt') then
    caminho := ExtractFileDir(GetCurrentDir)+ '/servernfse/'+cnpj
  else
    caminho := './'+cnpj;

  deleta_arquivos(caminho+'/Recibos');
  deleta_arquivos(caminho+'/Notas');
  deleta_arquivos(caminho+'/Eventos');
  deleta_arquivos(caminho);
end;

function getPathSchemas(): String;
begin
  Result := './Schemas';

  if FileExists('/home/ian/ian.txt') then
    Result := '/home/ian/Schemas'
  else
  begin
    var schemas: String := getSectionIni(INI_PATH_SCHEMAS);

    if (schemas <> EmptyStr) and (DirectoryExists(schemas)) then
      Result := schemas;
  end;
end;

function getArquivoPfx(): String;
begin
  Result := '';

  var arquivoPfx := getSectionIni(INI_ARQUIVO_PFX);

  if (arquivoPfx <> EmptyStr) and (FileExists(arquivoPfx)) then
    Result := arquivoPfx;
end;

function getSectionIni(ASection: String): String;
begin
  Result := '';

  if not(FileExists(INI_CONFIG_FILE)) then
    Exit('');

  var iniFile := TiniFile.Create(INI_CONFIG_FILE);
  try
    var sectionIni := iniFile.ReadString('NFSE', ASection, '');
    Result := Trim(StringReplace(sectionIni, '''', '', [rfReplaceAll]));
  finally
    iniFile.Free;
  end;
end;

function GetModoEnvio(AModoEnvioFacil: Integer): TmodoEnvio;
begin
  if AModoEnvioFacil = METODO_TESTE then
    Exit(meTeste);

  if AModoEnvioFacil = METODO_LOTEASSINCRONO then
    Exit(meLoteAssincrono);

  if AModoEnvioFacil = METODO_LOTESINCRONO then
    Exit(meLoteSincrono);

  if AModoEnvioFacil = METODO_UNITARIO then
    Exit(meUnitario);

  Result := meAutomatico;
end;


end.
