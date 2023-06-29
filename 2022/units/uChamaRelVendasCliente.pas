unit uChamaRelVendasCliente;

interface

uses
  IBDatabase, Graphics, uIChamaRelatorioPadrao;

type
  TChamaRelVendasCliente = class(TInterfacedObject, IChamaRelatorioPadrao)
  private
    constructor Create;
  public
    destructor Destroy; override;

    class function New: IChamaRelatorioPadrao;
    function setDataBase(AoDataBase: TIBDatabase): IChamaRelatorioPadrao;
    function setImagem(AoImagem: TPicture): IChamaRelatorioPadrao;
    function setUsuario(AcUsuario: string): IChamaRelatorioPadrao;    
    function ChamarTela: IChamaRelatorioPadrao;
  end;

implementation

uses
  uRelatorioVendasClliente, SysUtils;

{ TChamaRelVendasCliente }

function TChamaRelVendasCliente.ChamarTela: IChamaRelatorioPadrao;
begin
  Result := Self;

  frmRelVendasPorCliente.ShowModal;
end;

constructor TChamaRelVendasCliente.Create;
begin
  frmRelVendasPorCliente := TfrmRelVendasPorCliente.Create(nil);
end;

destructor TChamaRelVendasCliente.Destroy;
begin
  FreeAndNil(frmRelVendasPorCliente);
  
  inherited;
end;

class function TChamaRelVendasCliente.New: IChamaRelatorioPadrao;
begin
  Result := Self.Create;
end;

function TChamaRelVendasCliente.setDataBase(AoDataBase: TIBDatabase): IChamaRelatorioPadrao;
begin
  Result := Self;

  frmRelVendasPorCliente.DataBase := AoDataBase;
end;

function TChamaRelVendasCliente.setImagem(AoImagem: TPicture): IChamaRelatorioPadrao;
begin
  Result := Self;

  frmRelVendasPorCliente.Imagem := AoImagem;
end;

function TChamaRelVendasCliente.setUsuario(AcUsuario: string): IChamaRelatorioPadrao;
begin
  Result := Self;

  frmRelVendasPorCliente.Usuario := AcUsuario;
end;

end.
