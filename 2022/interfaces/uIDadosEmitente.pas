unit uIDadosEmitente;

interface

uses
  IBDataBase, IbQuery;

type
  IDadosEmitente = interface
  ['{CF96DF24-F0BE-43D9-997E-F767A3F25A44}']
  function setDataBase(AoDataBase: TIBDatabase): IDadosEmitente;
  function getQuery: TIBQuery;
  end;

implementation

end.
