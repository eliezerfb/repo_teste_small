unit uEmail;

interface

function ValidaEmail(email: String): Boolean;

implementation

function ValidaEmail(email: String): Boolean;
begin
  Result := TTestaEmail.New.setEmail(email).Testar;
end;

end.
