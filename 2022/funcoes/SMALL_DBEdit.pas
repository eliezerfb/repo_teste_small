unit SMALL_DBEdit;


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, DBCtrls, DB;

type
  TSMALL_DBEdit = class(TDBEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
     procedure KeyPress(var Key:Char); override;
  public
    { Public declarations }
  published
    { Published declarations }
    property DataField;

  end;

procedure Register;

implementation

procedure TSMALL_DBEdit.KeyPress(var Key:Char);
begin
   {se for um campo numérico e for um ponto substitui por virgula}
   if Field.DataType=ftFloat then
      if Key = chr(46) then Key := chr(44);
   inherited KeyPress(Key);
end;
procedure Register;
begin
  RegisterComponents('Samples', [TSMALL_DBEdit]);
end;

end.

