unit uRetornaBuildEXE;

interface

uses
  uIRetornaBuildEXE, Windows;

type
  TRetornarBuildEXE = class(TInterfacedObject, IRetornabuildEXE)
  private
  public
    class function New: IRetornabuildEXE;
    function Retornar(AbSomenteNumeros: Boolean = False): String;    
  end;

implementation

uses
  SmallFunc;

{ TRetornarBuildEXE }

class function TRetornarBuildEXE.New: IRetornabuildEXE;
begin
  Result := Self.Create;
end;

function TRetornarBuildEXE.Retornar(AbSomenteNumeros: Boolean = False): String;
var
  Size, Size2: DWord;
  Pt, Pt2: Pointer;

  {$IFDEF VER150}
  {$ELSE}
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
  {$ENDIF}
begin
  Size := GetFileVersionInfoSize(PChar (ParamStr (0)), Size2);
  GetMem (Pt, Size);
  try
    {$IFDEF VER150}
    GetFileVersionInfo (PChar (ParamStr (0)), 0, Size, Pt);
    VerQueryValue(Pt,'\StringFileInfo\041604E4\FileVersion',Pt2, Size2);
    Result := PChar (pt2);
    {$ELSE}
    GetFileVersionInfo (PChar (ParamStr (0)), 0, Size, Pt);

    VerQueryValue(Pt, '\', Pointer(FI), VerSize);

    Result:= Concat(IntToStr(FI.dwFileVersionMS shr 16), '.',
                    IntToStr(FI.dwFileVersionMS and $FFFF), '.',
                    IntToStr(FI.dwFileVersionLS shr 16), '.',
                    IntToStr(FI.dwFileVersionLS and $FFFF));
    {$ENDIF}

    if AbSomenteNumeros then
      Result := SmallFunc.LimpaNumero(Result);
  finally
    FreeMem(Pt);
  end;
end;

end.
