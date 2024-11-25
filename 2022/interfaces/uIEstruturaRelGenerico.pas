unit uIEstruturaRelGenerico;

interface

uses
  uIEstruturaTipoRelatorioPadrao, IBDatabase, Classes;

type
  IEstruturaRelGenerico = interface
  ['{8C7A7168-97BF-4121-BBCD-8246E3661CCD}']
  function setUsuario(AcUsuario: String): IEstruturaRelGenerico;
  function setDataBase(AoDataBase: TIBDatabase): IEstruturaRelGenerico;
  function Estrutura: IEstruturaTipoRelatorioPadrao;
  end;

implementation

end.
                                             
