unit controller.status;

interface

Uses
  Horse,
  System.SysUtils,
  nfse.constants,
  System.Classes;

  Type
  TcontrollerStatus = class
    public
     class procedure status(Req: THorseRequest;
                                Res: THorseResponse; Next: TProc);
     class procedure Registry;
  end;

implementation


{ TcontrollerStatus }

class procedure TcontrollerStatus.Registry;
begin
  THorse.Get('/'+CONS_STATUS, status);
end;

class procedure TcontrollerStatus.status(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
begin
  Try
    Res.Send('pong');
  Finally
  End;
end;

end.
