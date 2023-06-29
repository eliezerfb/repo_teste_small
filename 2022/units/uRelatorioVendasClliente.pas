unit uRelatorioVendasClliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFormRelatorioPadrao, StdCtrls, ComCtrls, Buttons, ExtCtrls,
  uIEstruturaTipoRelatorioPadrao;

type
  TfrmRelVendasPorCliente = class(TfrmRelatorioPadrao)
    dtInicial: TDateTimePicker;
    dtFinal: TDateTimePicker;
    cbItemAItem: TCheckBox;
    gbTipoRelatorio: TGroupBox;
    cbNota: TCheckBox;
    cbCupom: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
  private
    function FazValidacoes: Boolean;
  public
  protected
    function Estrutura: IEstruturaTipoRelatorioPadrao; override;
  end;

var
  frmRelVendasPorCliente: TfrmRelVendasPorCliente;

implementation

uses
  SmallFunc, uEstruturaRelVendasPorCliente, uSmallResourceString;

{$R *.dfm}

{ TfrmRelVendasPorCliente }

function TfrmRelVendasPorCliente.Estrutura: IEstruturaTipoRelatorioPadrao;
begin
  Result := TEstruturaRelVendasPorCliente.New
                                         .setUsuario(Usuario)
                                         .SetDataBase(DataBase)
                                         .setItemAItem(cbItemAItem.Checked)
                                         .setDataInicial(dtInicial.Date)
                                         .setDataFinal(dtFinal.Date)
                                         .ImprimeNota(cbNota.Checked)
                                         .ImprimeCupom(cbCupom.Checked)
                                         .Estrutura;
end;

procedure TfrmRelVendasPorCliente.FormShow(Sender: TObject);
begin
  inherited;
  dtInicial.Date := StrToDate('01/' + IntToStr(Month(Date)) + '/' + IntToStr(Year(Date)));
  dtFinal.Date := StrToDate(IntToStr(DiasPorMes(Year(Date), Month(Date)))+ '/' + IntToStr(Month(Date)) + '/' + IntToStr(Year(Date)));
end;

function TfrmRelVendasPorCliente.FazValidacoes: Boolean;
begin
  Result := False;
  
  if ((dtInicial.Date = 0) or (dtFinal.Date = 0)) or (dtInicial.Date > dtFinal.Date) then
  begin
    ShowMessage(_cPeriodoDataInvalida);
    dtInicial.SetFocus;
    Exit;
  end;
  if (not cbNota.Checked) and (not cbCupom.Checked) then
  begin
    ShowMessage(_cSemDocumentoMarcadoImpressao);
    cbNota.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TfrmRelVendasPorCliente.btnImprimirClick(Sender: TObject);
begin
  if not FazValidacoes then
    Exit;
    
  inherited;
end;

end.
