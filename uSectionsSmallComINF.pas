unit uSectionsSmallComINF;

interface

uses
  uSectionDATPadrao;

type
  TSectionUso = class(TSectionDATPadrao)
  private
    function getUso: String;
    procedure setUso(const Value: String);
  public
    property Uso: String read getUso write setUso;
  protected
    function Section: String; override;
  end;

  TSectionOutros = class(TSectionDATPadrao)
  private
    function getCasasDecimaisPreco: Integer;
    function getCasasDecimaisQuantidade: Integer;
    procedure setCasasDecimaisPreco(const Value: Integer);
    procedure setCasasDecimaisQuantidade(const Value: Integer);
  public
    property CasasDecimaisQuantidade: Integer read getCasasDecimaisQuantidade write setCasasDecimaisQuantidade;
    property CasasDecimaisPreco: Integer read getCasasDecimaisPreco write setCasasDecimaisPreco;
  protected
    function Section: String; override;
  end;

  TSectionOrcamento = class(TSectionDATPadrao)
  private
    function getObservacao: String;
    procedure setObservacao(const Value: String);
  public
    property Observacao: String read getObservacao write setObservacao;
  protected
    function Section: String; override;
  end;

implementation

uses SysUtils, uSmallConsts, IniFiles;

{ TSectionUso }

function TSectionUso.getUso: String;
begin
  Result := FoIni.ReadString(Section, _cIdentUso, '1');
end;

function TSectionUso.Section: String;
begin
  Result := _cSectionUso;
end;

procedure TSectionUso.setUso(const Value: String);
begin
  FoIni.WriteString(Section, _cIdentUso, Value);
end;

{ TSectionOutros }

function TSectionOutros.getCasasDecimaisPreco: Integer;
begin
  Result := FoIni.ReadInteger(Section, _cIdentCasasDecimaisPreco, 2);
end;

function TSectionOutros.getCasasDecimaisQuantidade: Integer;
begin
  Result := FoIni.ReadInteger(Section, _cIdentCasasDecimaisQtde, 2);
end;

function TSectionOutros.Section: String;
begin
  Result := _cSectionSmallComOutros;
end;

procedure TSectionOutros.setCasasDecimaisPreco(const Value: Integer);
begin
  FoIni.WriteString(Section, _cIdentCasasDecimaisPreco, IntToStr(Value));
end;

procedure TSectionOutros.setCasasDecimaisQuantidade(const Value: Integer);
begin
  FoIni.WriteString(Section, _cIdentCasasDecimaisQtde, IntToStr(Value));
end;

{ TSectionOrcamento }

function TSectionOrcamento.getObservacao: String;
begin
  Result := FoIni.ReadString(Section, _cIdentObservacao, EmptyStr);
end;

function TSectionOrcamento.Section: String;
begin
  Result := _cSectionOrcamentoSemAcento;
end;

procedure TSectionOrcamento.setObservacao(const Value: String);
begin
  FoIni.WriteString(Section, _cIdentObservacao, Value);
end;

end.
