unit uTestaEmail;

interface

uses
  uITestaEmail;

type
  TTestaEmail = class(TInterfacedObject, ITestaEmail)
  private
    FcEmail: String;
  public
    class function New: ITestaEmail;
    function setEmail(AcEmail: String): ITestaEmail;
    function Testar: Boolean;
  end;

implementation

uses SysUtils
  {$IFDEF VER150}
  , smallfunc_xe
  {$ELSE}
  , smallfunc_xe
  {$ENDIF}
;

{ TTestaEmail }

class function TTestaEmail.New: ITestaEmail;
begin
  Result := Self.Create;
end;

function TTestaEmail.setEmail(AcEmail: String): ITestaEmail;
begin
  Result := Self;
  
  FcEmail := AcEmail;
end;

function TTestaEmail.Testar: Boolean;
var
  i: Integer;
begin
  Result := False;

  if (Pos('@',FcEmail)<>0) then
    Result := True;
  if (Pos('@.',FcEmail)<>0) or
     (Pos('.@',FcEmail)<>0) or
     (Pos('..',FcEmail)<>0) then
  begin
    Result := False;
  end;
  //
  for i := 1 to 57 do
  begin
    if Pos(Copy(' "!#$%¨*()+=^]}{,|?ÁÀÂÄÃÉÈÊËÍÎÏÓÔÕÚÜÇáàâäãéèêëíîïóôõúüç*',i,1),AllTrim(FcEmail)) <> 0 then
    begin
      Result := False;
    end;
  end;
end;

end.
 