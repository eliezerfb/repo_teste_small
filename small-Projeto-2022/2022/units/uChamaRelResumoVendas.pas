unit uChamaRelResumoVendas;

interface

uses
  IBDatabase, Graphics, uIChamaRelatorioPadrao;

type
  TChamaRelResumoVendas = class(TInterfacedObject, IChamaRelatorioPadrao)
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
  uRelatorioResumoVendas, SysUtils;

{ TChamaRelVendasCliente }

function TChamaRelResumoVendas.ChamarTela: IChamaRelatorioPadrao;
begin
  Result := Self;

  frmRelResumoVendas.ShowModal;
end;

constructor TChamaRelResumoVendas.Create;
begin
  frmRelResumoVendas := TfrmRelResumoVendas.Create(nil);
end;

destructor TChamaRelResumoVendas.Destroy;
begin
  FreeAndNil(frmRelResumoVendas);
  
  inherited;
end;

class function TChamaRelResumoVendas.New: IChamaRelatorioPadrao;
begin
  Result := Self.Create;
end;

function TChamaRelResumoVendas.setDataBase(AoDataBase: TIBDatabase): IChamaRelatorioPadrao;
begin
  Result := Self;

  frmRelResumoVendas.DataBase := AoDataBase;
end;

function TChamaRelResumoVendas.setImagem(AoImagem: TPicture): IChamaRelatorioPadrao;
begin
  Result := Self;

  frmRelResumoVendas.Imagem := AoImagem;
end;

function TChamaRelResumoVendas.setUsuario(AcUsuario: string): IChamaRelatorioPadrao;
begin
  Result := Self;

  frmRelResumoVendas.Usuario := AcUsuario;
end;

end.
