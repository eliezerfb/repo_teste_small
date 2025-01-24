unit uSectionDATPadrao;

interface

uses
  IniFiles
  , IBQuery
  , Ibdatabase
  , Variants
  , uFuncoesBancoDados
  ;

type
  TSectionDATPadrao = class
  private
  public
    constructor Create(AoArqIni: TIniFile);
  protected
    FoIni: TIniFile;
    function Section: String; virtual; abstract;
  end;

//Mauricio Parizotto 2023-11-20
type
  TSectionBD = class
  private
    SecTransaction: TIBTransaction;
    SecName : string;
  public
    constructor Create(IBTRANSACTION: TIBTransaction; Modulo:string);
    function getValorBD(nome: string): string;
    procedure setValorBD(nome,descricao,valor: string);
    destructor Destroy; override;
  protected
    FoQConfiguracoes: TIBQuery;
    procedure CarregarTabela; virtual;
  end;

implementation

uses SysUtils, uDialogs;

{ TSectionDATPadrao }

constructor TSectionDATPadrao.Create(AoArqIni: TIniFile);
begin
  FoIni := AoArqIni;
end;

{ TSectionBD }

constructor TSectionBD.Create(IBTRANSACTION: TIBTransaction; Modulo:string);
begin
  SecTransaction := IBTRANSACTION;
  SecName := Modulo;
  CarregarTabela;
end;

procedure TSectionBD.CarregarTabela;
begin
  FoQConfiguracoes := CriaIBQuery(SecTransaction);
  FoQConfiguracoes.SQL.Text := ' Select * '+
                               ' From CONFIGURACAOSISTEMA'+
                               ' Where MODULO = '+QuotedStr(SecName);
  FoQConfiguracoes.Open;
end;

function TSectionBD.getValorBD(nome: string): string;
begin
  Result := '';

  {Sandro Silva 2024-04-24 inicio}
  // Valida se a query está fechada por ter realizado algum commit durante o uso do objeto
  // Se estiver fechada tentará abrir
  try
    if FoQConfiguracoes.Active = False then
      FoQConfiguracoes.Open;
  except
    Exit;
  end;  

  {Sandro Silva 2024-04-24 fim}
  if FoQConfiguracoes.Locate('NOME;MODULO', VarArrayOf([nome,SecName]),[]) then
    Result := FoQConfiguracoes.FieldByName('VALOR').AsString;
end;

procedure TSectionBD.setValorBD(nome,descricao,valor: string);
begin
  try
    if FoQConfiguracoes.Locate('NOME;MODULO', VarArrayOf([nome,SecName]),[]) then
    begin
      //Atualiza
      ExecutaComando(' Update CONFIGURACAOSISTEMA '+
                     ' Set VALOR ='+QuotedStr(valor)+
                     ' Where  IDCONFIGURACAOSISTEMA ='+FoQConfiguracoes.FieldByName('IDCONFIGURACAOSISTEMA').AsString,
                     SecTransaction);
    end else
    begin
      //Insere
      ExecutaComando(' Insert into CONFIGURACAOSISTEMA (IDCONFIGURACAOSISTEMA, NOME, MODULO, VALOR, DESCRICAO) '+
                     ' values((select gen_id(G_CONFIGURACAOSISTEMA,1) from rdb$database) ,'+
                     QuotedStr(nome)+','+
                     QuotedStr(SecName)+','+
                     QuotedStr(valor)+','+
                     QuotedStr(descricao)+
                     ')',
                     SecTransaction);
    end;
  except
    on e:exception do
      MensagemSistema('Não foi possível salvar as configurações. Tente novamente!',msgAtencao);
  end;

  FoQConfiguracoes.Close;
  FoQConfiguracoes.Open;
end;

destructor TSectionBD.Destroy;
begin
  FreeAndNil(FoQConfiguracoes);
  inherited;
end;

end.



