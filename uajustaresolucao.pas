unit uajustaresolucao;

interface

uses Classes, ExtCtrls, Controls, StdCtrls, Graphics, Forms
  , SysUtils, TypInfo, Mask, DBGrids, ComCtrls, SMALL_DBEdit
  , CheckLst;

const SCREEN_HEIGHT_PADRAO = 768; // Sandro Silva 2016-07-28
const SCREEN_WIDTH_PADRAO  = 1024;

function AjustaLargura(pI: Integer): Integer;
function AjustaAltura(pI: Integer): Integer;
function AjustaResolucao(Obj: TObject): Boolean;

implementation

uses
  Vcl.Buttons, Vcl.Grids;

function AjustaLargura(pI: Integer): Integer;
begin
  Result := Trunc(pI*Screen.Width div SCREEN_WIDTH_PADRAO);
end;

function AjustaAltura(pI: Integer): Integer;
begin
  Result := Trunc(pI*Screen.Height div SCREEN_HEIGHT_PADRAO);
end;

function AjustaResolucao(Obj: TObject): Boolean;
var
  I : Integer;
  dHeight: Double;
  dWidth: Double;
  bAutoSizeOld: Boolean; // Sandro Silva 2017-05-16

  procedure Dimensao(Obj: TComponent);
  begin
    TWinControl(Obj).Top    := Trunc(TWinControl(Obj).Top * dHeight);
    TWinControl(Obj).Height := Trunc(TWinControl(Obj).Height * dHeight);
    TWinControl(Obj).Left   := Trunc(TWinControl(Obj).Left * dWidth);
    TWinControl(Obj).Width  := Trunc(TWinControl(Obj).Width * dWidth);
  end;

  function AjusteEspecial(FontName: String): Integer;
  begin
    Result := 0;
    if AnsiUpperCase(FontName) = 'COURIER NEW' then
      Result := 1;
  end;

  procedure DimensionaFonte(Obj: TComponent; iParametro: Double);
  var
    PropInfo: PPropInfo;
    Fonte: TFont;
  begin

    PropInfo := GetPropInfo(Obj, 'Font');

    if PropInfo <> nil then
    begin
      Fonte := TFont(GetObjectProp(Obj, 'Font', TFont));

      if (Fonte.Size * iParametro) - (Trunc(Fonte.Size * iParametro) )  > 0.5 then
      begin
        Fonte.Size := Trunc(Fonte.Size * iParametro);
      end else
      begin
        Fonte.Size := Trunc(Fonte.Size * iParametro) + AjusteEspecial(Fonte.Name); // Sandro Silva 2017-10-23   + 1;
      end;

      if PropInfo^.PropType^.Kind = tkClass then
        SetObjectProp(Obj, PropInfo, Fonte);

    end;
  end;

begin
  //
  with Obj as TComponent do
  begin
    dHeight := Screen.Height / SCREEN_HEIGHT_PADRAO;
    dWidth  := Screen.Width / SCREEN_WIDTH_PADRAO;
    //
    for I := 0 To ComponentCount-1 do
    begin
      //
      if (Components[ I ] is TButton) or (Components[ I ] is TBitBtn) then // Sandro Silva 2024-01-22 if Components[ I ] is TButton then
      begin
        //

        Dimensao(Components[I]);
        //
        DimensionaFonte(Components[I], dHeight);
        //
      end;
      //
      if Components[ I ] is TFrame then
      begin
        //
        Dimensao(Components[I]);
        //
      end;
      {Sandro Silva (smal-778) 2024-12-03 inicio}
      if Components[ I ] is TBevel then
      begin
        Dimensao(Components[I]);
      end;
      {Sandro Silva (smal-778) 2024-12-03 fim}
      //
      if Components[ I ] is TPanel then
      begin

        Dimensao(Components[I]);
        //
        DimensionaFonte(Components[I], dHeight);
        //
      end;
      //
      if Components[ I ] is TMemo then
      begin

        Dimensao(Components[I]);
        //
        // Aqui é melhor usar o Width
        //
        DimensionaFonte(Components[I], dWidth);
        //
      end;
      //
      if Components[ I ] is TImage then
      begin
        //
        TImage(Components[I]).AutoSize    := False;
        TImage(Components[I]).Stretch     := True;

        Dimensao(Components[I]);
        //
      end;
      //
      if Components[ I ] is TLabel then
      begin
        bAutoSizeOld := TLabel(Components[I]).AutoSize; // Sandro Silva 2017-05-16
        //
        TLabel(Components[I]).AutoSize    := False;

        Dimensao(Components[I]);
        //DimensionaFonte(Components[I]);

        //
        // O LAbel ficou melhor usando o Height como parametro
        //
        DimensionaFonte(Components[I], dHeight);

        TLabel(Components[I]).AutoSize := bAutoSizeOld; // Sandro Silva 2017-05-16
        //
      end;
      //
      if Components[ I ] is TEdit then
      begin
        //

        Dimensao(Components[I]);

        //
        DimensionaFonte(Components[I], dHeight);
        //
      end;
      //
      if Components[ I ] is TSmall_dbEdit then
      begin
        //

        Dimensao(Components[I]);
        //
        DimensionaFonte(Components[I], dHeight);
        //
      end;
      //
      if Components[ I ] is TMaskEdit then
      begin
        //

        Dimensao(Components[I]);

        // Sandro Silva 2016-08-01 faz 2x  tMaskEdit(Components[I]).Font.Size   := Trunc(tMaskEdit(Components[I]).Font.Size * dWidth);
        //
        DimensionaFonte(Components[I], dHeight);
        //
      end;
      //
      if Components[ I ] is TDBGrid then
      begin
        //

        Dimensao(Components[I]);
        DimensionaFonte(Components[I], dHeight);
        TDBGrid(Components[I]).DrawingStyle := gdsClassic; // Migração para Delphi Alexandria 2024-01-23 Sandro Silva
        //
      end;
      //
      if Components[ I ] is TComboBox then
      begin
        //
        Dimensao(Components[I]);
        //
        DimensionaFonte(Components[I], dHeight);
        //
      end;
      //
      if Components[ I ] is TDateTimePicker then
      begin
        //
        Dimensao(Components[I]);
        //
        DimensionaFonte(Components[I], dHeight);
        //
      end;
      //
      if Components[ I ] is TCheckBox then
      begin
        //
        Dimensao(Components[I]);
        //
        DimensionaFonte(Components[I], dHeight);
        //
      end;
      {Sandro Silva 2023-11-01 inicio}
      if Components[ I ] is TCheckListBox then
      begin
        Dimensao(Components[I]);
        DimensionaFonte(Components[I], dHeight);
      end;
      {Sandro Silva 2023-11-01 fim}
      //
    end;
  end;
  //
  Result := True;
  //
end;

end.
