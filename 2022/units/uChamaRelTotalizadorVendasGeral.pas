unit uChamaRelTotalizadorVendasGeral;

interface

uses
  IBDatabase, Graphics, uIChamaRelatorioPadrao;

type
  TChamaRelTotalizadorVendasGeral = class(TInterfacedObject, IChamaRelatorioPadrao)
  private
    constructor Create;
  public
    destructor Destroy; override;

    class function New: IChamaRelatorioPadrao;
    function setDataBase(AoDataBase: TIBDatabase): IChamaRelatorioPadrao;
    function setTransaction(AoTransaction: TIBTransaction): IChamaRelatorioPadrao;
    function setImagem(AoImagem: TPicture): IChamaRelatorioPadrao;
    function setUsuario(AcUsuario: string): IChamaRelatorioPadrao;
    function ChamarTela: IChamaRelatorioPadrao;
  end;

implementation

uses
  uRelatorioTotalGeralVenda, SysUtils;

{ TChamaRelTotalizadorVendasGeral }

function TChamaRelTotalizadorVendasGeral.ChamarTela: IChamaRelatorioPadrao;
begin
  Result := Self;

  frmRelTotalizadorGeralVenda.ShowModal;
end;

constructor TChamaRelTotalizadorVendasGeral.Create;
begin
  frmRelTotalizadorGeralVenda := TfrmRelTotalizadorGeralVenda.Create(nil);
end;

destructor TChamaRelTotalizadorVendasGeral.Destroy;
begin
  FreeAndNil(frmRelTotalizadorGeralVenda);
  inherited;
end;

class function TChamaRelTotalizadorVendasGeral.New: IChamaRelatorioPadrao;
begin
  Result := Self.Create;
end;

function TChamaRelTotalizadorVendasGeral.setDataBase(AoDataBase: TIBDatabase): IChamaRelatorioPadrao;
begin
  Result := Self;

  frmRelTotalizadorGeralVenda.DataBase := AoDataBase;
end;

function TChamaRelTotalizadorVendasGeral.setImagem(AoImagem: TPicture): IChamaRelatorioPadrao;
begin
  Result := Self;

  frmRelTotalizadorGeralVenda.Imagem := AoImagem;
end;

function TChamaRelTotalizadorVendasGeral.setUsuario(AcUsuario: string): IChamaRelatorioPadrao;
begin
  Result := Self;

  frmRelTotalizadorGeralVenda.Usuario := AcUsuario;
end;

function TChamaRelTotalizadorVendasGeral.setTransaction(AoTransaction: TIBTransaction): IChamaRelatorioPadrao;
begin
  Result := Self;

  frmRelTotalizadorGeralVenda.Transaction := AoTransaction;
end;

end.
