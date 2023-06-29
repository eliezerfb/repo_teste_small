unit uIEstruturaRelVendasPorCliente;

interface

uses
  uIEstruturaTipoRelatorioPadrao, IBDatabase;

type
  IEstruturaRelVendasPorCliente = interface
  ['{57111B3C-4065-4CA9-B52D-87C803B600A1}']
  function setUsuario(AcUsuario: String): IEstruturaRelVendasPorCliente;
  function setDataBase(AoDataBase: TIBDatabase): IEstruturaRelVendasPorCliente;
  function setItemAItem(AbItemAItem: Boolean): IEstruturaRelVendasPorCliente;
  function setDataInicial(AdData: TDateTime): IEstruturaRelVendasPorCliente;
  function setDataFinal(AdData: TDateTime): IEstruturaRelVendasPorCliente;
  function ImprimeNota(AbImprime: Boolean): IEstruturaRelVendasPorCliente;
  function ImprimeCupom(AbImprime: Boolean): IEstruturaRelVendasPorCliente;  
  function Estrutura: IEstruturaTipoRelatorioPadrao;
  end;

implementation

end.
                                             
