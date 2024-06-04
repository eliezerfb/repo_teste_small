unit uPermissaoUsuario;

interface

uses
  System.IniFiles, System.SysUtils, Vcl.Forms;

    function SomenteLeitura(sModulo, sUsuario : string) : Boolean;

implementation


function SomenteLeitura(sModulo, sUsuario : string) : Boolean;
var
  Mais1Ini : TiniFile;
begin
  try
    Result := False;
    Mais1Ini   := TIniFile.Create(ExtractFilePath(Application.ExeName)+'EST0QUE.DAT');

    if sModulo = 'NOTA'     then
    begin
      if Trim(Mais1Ini.ReadString(sUsuario,'B1','0'))  <> '1' then
        Result := True;
    end;

    if sModulo = 'ESTOQUE'  then
    begin
      if Trim(Mais1Ini.ReadString(sUsuario,'B2','0'))  <> '1' then
        Result := True;
    end;

    if sModulo = 'CLIENTES' then
    begin
      if Trim(Mais1Ini.ReadString(sUsuario,'B3','0'))  <> '1' then
        Result := True;
    end;

    if sModulo = 'RECEBER'  then
    begin
      if Trim(Mais1Ini.ReadString(sUsuario,'B4','0'))  <> '1' then
        Result := True;
    end;

    if sModulo = 'PAGAR'    then
    begin
      if Trim(Mais1Ini.ReadString(sUsuario,'B10','0')) <> '1' then
        Result := True;
    end;

    if sModulo = 'CAIXA'    then
    begin
      if Trim(Mais1Ini.ReadString(sUsuario,'B5','0'))  <> '1' then
        Result := True;
    end;

    if sModulo = 'BANCOS'   then
    begin
      if Trim(Mais1Ini.ReadString(sUsuario,'B6','0'))  <> '1' then
        Result := True;
    end;

    Mais1Ini.Free;
  except
  end;
end;

end.
