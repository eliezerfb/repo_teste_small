unit uITestaEmail;

interface

type
  ITestaEmail = interface
  ['{203C81BA-406A-476A-8720-C61D8A3905DD}']
  function setEmail(AcEmail: String): ITestaEmail;
  function Testar: Boolean;
  end;

implementation

end.
