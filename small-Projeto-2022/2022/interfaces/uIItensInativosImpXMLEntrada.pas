unit uIItensInativosImpXMLEntrada;

interface

uses
  IBDatabase;

type
  IItensInativosImpXMLEntrada = interface
  ['{FF196997-1943-4C9E-A7D2-F6165DE31D1D}']
  function setDataBase(AoDataBase: TIBDataBase;
    AoTransaction: TIBTransaction): IItensInativosImpXMLEntrada;
  function Executar(AcItens: String): IItensInativosImpXMLEntrada;
  end;

implementation

end.
