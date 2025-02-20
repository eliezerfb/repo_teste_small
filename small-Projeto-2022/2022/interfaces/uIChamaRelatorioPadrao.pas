unit uIChamaRelatorioPadrao;

interface

uses
  IBDatabase, Graphics;

type
  IChamaRelatorioPadrao = interface
  ['{FEF6F4A2-B8C5-4331-B886-3CD7E70E8F20}']
  function setDataBase(AoDataBase: TIBDatabase): IChamaRelatorioPadrao;
  function setImagem(AoImagem: TPicture): IChamaRelatorioPadrao;
  function setUsuario(AcUsuario: string): IChamaRelatorioPadrao;
  function ChamarTela: IChamaRelatorioPadrao;
  end;

implementation

end.
