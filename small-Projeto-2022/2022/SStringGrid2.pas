unit SStringGrid2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, dbtables, Unit7;

type
  TServico = Record
    Numero: String;
    Cliente: String;
    Situacao: String;
    Data_pro: TDate;
    Hora_pro: String;
    Tempo: String;
    Tecnico: String;
  end;
  TSStringGrid2 = class(TStringGrid)
  private
    { Private declarations }
    FHorFonte: TFont;
    FTitFonte: TFont;
    FHorInicial: Integer;
    FHorFinal: Integer;
    FCantoColor: TColor;
    FHorariosColor: TColor;
    FSelectColor: TColor;
    FTecnicos: TStringList;
    FSituacoes: TStringList;
    FSituacoesCor: TStringList;
    FTable: TTable;
    FData: TDate;
    FNumero: String;
    FHora: String;
    FTecnico: String;
    FTamBordaLat: Integer;
    h,v: Integer;
    FHoras: TStringList;
    FHorSel: String;
    LastRow, LastCol : Integer;
    VOnNumero: TNotifyEvent;
    Ordens: array of TServico;
    procedure SetHorFonte(const Value: TFont);
    procedure SetTitFonte(const Value: TFont);
    procedure SetCantoColor(Value: TColor);
    procedure SetHorariosColor(Value: TColor);
    procedure SetSelectColor(Value: TColor);
    procedure SetTecnicos(ATecnicos: TStringList);
    procedure SetSituacoes(ASituacoes: TStringList);
    procedure SetSituacoesCor(ASituacoesCor: TStringList);
    procedure SetHoras(AHoras: TStringList);
    function GetTable: TTable;
    procedure SetTable(Value: TTable);
  protected
    { Protected declarations }
    procedure DrawCell(ACol, ARow: Longint; mRect: TRect; AState: TGridDrawState); override;
    procedure DblClick; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

  public
    { Public declarations }
    procedure AjustaHorario;
    procedure CargaTecnicos;
    procedure GeraGrade;
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property HorFonte: TFont read FHorFonte write SetHorFonte;
    property TitFonte: TFont read FTitFonte write SetTitFonte;
    property HorInicial: Integer read FHorInicial write FHorInicial;
    property HorFinal: Integer read FHorFinal write FHorFinal;
    property CantoColor: TColor read FCantoColor write SetCantoColor;
    property HorariosColor: TColor read FHorariosColor write SetHorariosColor;
    property SelectColor: TColor read FSelectColor write SetSelectColor;
    property Tecnicos: TStringList read FTecnicos write SetTecnicos;
    property Situacoes: TStringList read FSituacoes write SetSituacoes;
    property SituacoesCor: TStringList read FSituacoesCor write SetSituacoesCor;
    property Table: TTable read GetTable write SetTable;
    property Data: TDate read FData write FData;
    property Horas: TStringList read FHoras write SetHoras;
    property Numero: String read FNumero write FNumero;
    property Hora: String read FHora write FHora;
    property Tecnico: String read FTecnico write FTEcnico;
    property TamBordaLat: Integer read FTamBordaLat write FTamBordaLat;
    property OnNumero: TNotifyEvent read VOnNumero write VOnNumero;
  end;

procedure Register;

implementation

constructor TSStringGrid2.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  Numero := '';
  Ctl3D := False;
  ShowHint := True;
  ParentShowHint := False;
  FixedCols := 0;
  RowCount := 2;
  ColCount := 1;
  HorariosColor := clBtnFace;
  CantoColor := clBtnFace;
  FHorFonte := TFont.Create;
  FTitFonte := TFont.Create;
  FTecnicos := TStringList.Create;
  FHoras := TStringList.Create;
  FSituacoes := TStringList.Create;
  FSituacoesCor := TStringList.Create;
end;

destructor TSStringGrid2.Destroy;
begin
  FHorFonte.Free;
  FTitFonte.Free;
  FTecnicos.Free;
  FHoras.Free;
  FSituacoes.Free;
  FSituacoesCor.Free;
  inherited Destroy;
end;

procedure TSStringGrid2.GeraGrade;
var
   Ht,Vt,Tec: String;
   Day,Month,Year: Word;
   Dia,Mes,Ano: String;
   PTec,I,C: Integer;
   HoraA,HoraI,HoraF: TTime;
begin
  DecodeDate(FData, Year, Month, Day);
  Dia := IntToStr(Day);
  Mes := IntToStr(Month);
  Ano := IntToStr(Year);
  Form7.IBDataSet99.Close;
  Form7.IBDataSet99.SelectSQL.Clear;
  Form7.IBDataSet99.SelectSQL.Add('Select NUMERO,CLIENTE,SITUACAO,DATA_PRO,HORA_PRO,TEMPO,TECNICO from OS WHERE EXTRACT(DAY FROM DATA_PRO) = '+Dia+' AND EXTRACT(MONTH FROM DATA_PRO) = '+Mes+' AND EXTRACT(YEAR FROM DATA_PRO) = '+Ano);
  Form7.IBDataSet99.Open;
  Form7.IBDataSet99.First;
  SetLength(Ordens, Form7.IBDataSet99.RecordCount+1); // Seta o array com o tamanho igual a quantidade de registros
  C := 0;
  while not Form7.IBDataSet99.Eof do
  begin
    Tec := Trim(Form7.IBDataSet99.FieldByName('TECNICO').AsString);
    PTec := Tecnicos.IndexOf(Tec);
    h := PTec +1;
    HoraI := StrToDateTime(Form7.IBDataSet99.FieldByName('HORA_PRO').AsString);
    HoraF := StrToDateTime(Form7.IBDataSet99.FieldByName('HORA_PRO').AsString) + StrToDateTime(Form7.IBDataSet99.FieldByName('TEMPO').AsString);
    for I := 0 to FHoras.Count - 1 do
    begin
      HoraA := STRToDateTime(FHoras[I]);
      if (HoraA >= HoraI) and (HoraA < HoraF) then
      begin
        v := I + 1;
        Ht := IntToStr(h);
        if h < 10 then Ht := '0' + Ht;
        Vt := IntToStr(v);
        if v < 10 then Vt := '0' + Vt;
        FHorSel := FHorSel + Ht+','+Vt+';';
      end;
    end;
    // Carrega o array com dados do arquivo
    Ordens[C].Numero   := Form7.IBDataSet99.FieldByName('NUMERO').AsString;
    Ordens[C].Cliente  := Form7.IBDataSet99.FieldByName('CLIENTE').AsString;
    Ordens[C].Situacao := Form7.IBDataSet99.FieldByName('SITUACAO').AsString;
    Ordens[C].Data_pro := Form7.IBDataSet99.FieldByName('DATA_PRO').AsDateTime;
    Ordens[C].Hora_pro := Form7.IBDataSet99.FieldByName('HORA_PRO').AsString;
    Ordens[C].Tempo    := Form7.IBDataSet99.FieldByName('TEMPO').AsString;
    Ordens[C].Tecnico  := Form7.IBDataSet99.FieldByName('TECNICO').AsString;
    inc(C); // Incrementa a posição no array
    Form7.IBDataSet99.Next;
  end;
  Form7.IBDataSet99.Close;
end;

procedure TSStringGrid2.SetTecnicos(ATecnicos: TStringList);
begin
  FTecnicos.Assign(ATecnicos);
end;

procedure TSStringGrid2.SetHoras(AHoras: TStringList);
begin
  FHoras.Assign(AHoras);
end;

procedure TSStringGrid2.SetSituacoes(ASituacoes: TStringList);
begin
  FSituacoes.Assign(ASituacoes);
end;

procedure TSStringGrid2.SetSituacoesCor(ASituacoesCor: TStringList);
begin
  FSituacoesCor.Assign(ASituacoesCor);
end;


procedure TSStringGrid2.AjustaHorario;
var
   i : Integer;
   HC: String;
begin
    RowCount := ((FHorFinal - FHorInicial) * 4) + 1;
    FHoras.Clear;
    for i := FHorInicial to FHorFinal do
    begin
       HC := IntToStr(I);
       if I < 10 then HC := '0' + HC;
       FHoras.Add(HC+':00');
       FHoras.Add(HC+':15');
       FHoras.Add(HC+':30');
       FHoras.Add(HC+':45');
    end;
    FHorSel := '';
end;

procedure TSStringGrid2.CargaTecnicos;
begin
   if FTecnicos.Count > 0 then
      ColCount := FTecnicos.Count + 1;
   if ColCount > 1 then FixedCols := 1;
end;

procedure TSStringGrid2.SetCantoColor(Value: TColor);
begin
  if FCantoColor <> Value then
  begin
    FCantoColor := Value;
    Invalidate;
  end;
end;

procedure TSStringGrid2.SetHorariosColor(Value: TColor);
begin
  if FHorariosColor <> Value then
  begin
    FHorariosColor := Value;
    Invalidate;
  end;
end;

procedure TSStringGrid2.SetSelectColor(Value: TColor);
begin
  if FSelectColor <> Value then
  begin
    FSelectColor := Value;
    Invalidate;
  end;
end;


procedure TSStringGrid2.SetHorFonte(const Value: TFont);
begin
  FHorFonte.Assign(Value);
end;

procedure TSStringGrid2.SetTitFonte(const Value: TFont);
begin
  FTitFonte.Assign(Value);
end;


procedure TSStringGrid2.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  CR, AC, AR : Integer;
  C: TColor;
  HoraA,HoraI,HoraF: TTime;
begin
  If ShowHint = False Then ShowHint := True;
  MouseToCell(X, Y, AC, AR);
  If (AC > 0) And (AR > 0) then
  begin
     C := Canvas.Pixels[X,Y];
     Hint:= '';
//     if C = SelectColor then
     if C <> Color then
     begin
        HoraA := StrToDateTime(FHoras[AR-1]);
        for CR := Low(Ordens) to High(Ordens) do
        begin
          HoraI := StrToDateTime(Ordens[CR].Hora_pro);
          HoraF := StrToDateTime(Ordens[CR].Hora_pro) + StrToDateTime(Ordens[CR].Tempo);
          if (HoraA >= HoraI) and (HoraA < HoraF) and (Trim(Tecnicos[AC-1]) = Ordens[CR].Tecnico) then
          begin
             Hint := 'OS: '+Ordens[CR].Numero + #13#10 + 'Cliente: '+Ordens[CR].Cliente + #13#10 + 'Situação: '+Ordens[CR].Situacao;
             FNumero := Ordens[CR].Numero;
             Break;
          end;
        end;
     end else
     begin
        FNumero := '';
        FHora := FHoras[AR-1];
        FTecnico := Trim(Tecnicos[AC-1]);
     end;
     If (AC<>LastCol) or (AR<>LastRow) Then
     begin
       Application.CancelHint;
       LastCol:=AC;
       LastRow:=AR;
     end;
  end;
end;

procedure TSStringGrid2.DblClick;
begin

  ShowMEssage(Numero+chr(10)+Hora+chr(10)+tecnico);

//ShowMEssage('Teste 1');
//  VOnNumero(Self);
//ShowMEssage('Teste 2');

end;

procedure TSStringGrid2.DrawCell(ACol, ARow: Integer; mRect: TRect;  AState: TGridDrawState);
var
  PC,CR: Integer;
  f,p: Double;
  Ct,Rt,Texto,aa: String;
  HoraA,HoraI,HoraF: TTime;
begin
  Ctl3D := False;
  if (Astate = [gdSelected]) then
  begin
      Canvas.Brush.Color := Color;
      Canvas.FillRect(mRect);
      Exit;
  end;
  if (ACol = 0) and (ARow = 0) then
  begin
     Canvas.Brush.Color := CantoColor;
     Canvas.FillRect(mRect);
     Exit;
  end;
  if (ARow = 0) and (ACol > 0) then
  begin
     Texto := ' '+FTecnicos[ACol-1];
     Canvas.Font := TitFonte;
     Canvas.FillRect(mRect);
     DrawText(Canvas.Handle,PChar(Texto),StrLen(PChar(Texto)),mRect,DT_LEFT);
     Exit;
  end;

  if (ARow > 0) and (ACol > 0) then
  begin
     Ct := IntToStr(ACol);
     if ACol < 10 then Ct := '0' + Ct;

     Rt := IntToStr(ARow);
     if ARow < 10 then Rt := '0' + Rt;

     aa := Ct+','+Rt;
     if pos(aa,FHorSel) <> 0 then
     begin

        Canvas.Brush.Color := SelectColor;

        HoraA := StrToDateTime(FHoras[ARow-1]);

        for CR := Low(Ordens) to High(Ordens) do
        begin
          HoraI := StrToDateTime(Ordens[CR].Hora_pro);
          HoraF := StrToDateTime(Ordens[CR].Hora_pro) + StrToDateTime(Ordens[CR].Tempo);
          if (HoraA >= HoraI) and (HoraA < HoraF) then
          begin
            if Ordens[CR].Tecnico = Tecnicos[ACol-1] then
            begin
              // Texto := '   '+Ordens[CR].Numero;

              PC := FSituacoes.IndexOf(Ordens[CR].Situacao);
              if PC <> -1 then Canvas.Brush.Color := StringToColor(FSituacoesCor[PC]);
              Break;
            end;
          end;
        end;
 //       Texto := Ordens[CR].Situacao;

        mRect.Top := mRect.Top + FTamBordaLat;
        mRect.Bottom := mRect.Bottom + GridlineWidth - FTamBordaLat;
        mRect.Left := mRect.Left + FTamBordaLat;
        mRect.Right := mRect.Right - FTamBordaLat;
        Canvas.FillRect(mRect);
        DrawText(Canvas.Handle,PChar(Texto),StrLen(PChar(Texto)),mRect,DT_LEFT);

     end;
     Exit;
  end;

  if (ACol > 0) or (ARow = 0) then Exit;
  f := Frac((aRow-1) / 4);
  p := Int((aRow-1) / 4);
  if f = 0 then
  begin
     mRect.Bottom := mRect.Bottom + GridlineWidth;
     Texto := FloatToStr(p+HorInicial)+':00 ';
  end else
  if f = 0.25 then
  begin
     mRect.Bottom := mRect.Bottom + GridlineWidth;
     Texto := ':15 ';
  end else
  if f = 0.5 then
  begin
     mRect.Bottom := mRect.Bottom + GridlineWidth;
     Texto := ':30 ';
  end else
  if f = 0.75 then
  begin
     Texto := ':45 ';
  end;
  if (ARow = 0) or (ACol = 0) then
  begin
     Canvas.Font := HorFonte;
     Canvas.Brush.Color := HorariosColor;
     Canvas.FillRect(mRect);
     DrawText(Canvas.Handle,PChar(Texto),StrLen(PChar(Texto)),mRect,DT_RIGHT);
  end;
end;

procedure TSStringGrid2.SetTable(Value: TTable);
begin
   FTable := Value;
end;

function TSStringGrid2.GetTable: TTable;
begin
end;



procedure Register;
begin
  RegisterComponents('Small', [TSStringGrid2]);
end;

end.
