unit uCalculaFCP;

interface

uses
  IBCustomDataSet
  , SysUtils
  , SmallFunc
  ;

type
  TFCP = class
  private
    FPercentualFCP: Double;
    FPercentualFCPST: Double;
    FVFCP: Double;
    FVFCPST: Double;
    FVFCPRETIDO: Double;
  public
    property PFCP: Double read FPercentualFCP write FPercentualFCP;
    property PFCPST: Double read FPercentualFCPST write FPercentualFCPST;
    property VFCP: Double read FVFCP;// write FFCP;
    property VFCPST: Double read FVFCPST;// write FFCPST;
    property VFCPRetido: Double read FVFCPRETIDO;// write FFCPRETIDO;
    procedure CalculaFCP(dBCFCP: Double;
      dPFCPUFDEST: Double; dPICMSUFDEST: Double;
      sUFEmitente: String; sUFDestino: String; dPIVA: Double);
  end;

implementation

uses
  Unit7
  ;

{ TFCP }

procedure TFCP.CalculaFCP(dBCFCP: Double;
  dPFCPUFDEST: Double; dPICMSUFDEST: Double; sUFEmitente: String;
  sUFDestino: String; dPIVA: Double);
begin
  FVFCP       := 0.00;
  FVFCPRetido := 0.00;

  if (dPFCPUFDEST <> 0) or (dPICMSUFDEST <> 0) then
  begin
    // Quando preenche na nota não vai nada nessas tags
    FPercentualFCP   := 0;
    FPercentualFCPST := 0; // fPercentualFCP; // tributos da NF-e 16 AfterPost
  end else
  begin
    {
    if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCP',DataSetProdutos.FieldByname('TAGS_').AsString)) <> '' then
    begin
      fPercentualFCP := StrTofloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCP',DataSetProdutos.FieldByname('TAGS_').AsString))); // tributos da NF-e
    end else
    begin
      fPercentualFCP := 0;
    end;
    }

    {
    // fPercentualFCPST 16 AfterPost
    if sAliquotaFCPSTEstoque <> '' then
    begin
      fPercentualFCPST := StrTofloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCPST',DataSetProdutos.FieldByname('TAGS_').AsString))); // tributos da NF-e 16 AfterPost
    end else
    begin
      fPercentualFCPST := 0; // fPercentualFCP; // tributos da NF-e 16 AfterPost
    end;
    }
  end;
  {
  if fPercentualFCP <> 0 then
  begin
    fFCP := Arredonda((dBCFCP * fPercentualFCP/100),2); // Valor do Fundo de Combate à Pobreza (FCP)
  end
  else
  begin
    FFCP := 0;
  end;
  }
  if fPercentualFCP <> 0 then
  begin
    FVFCP := Arredonda((dBCFCP * fPercentualFCP / 100), 2); // Valor do Fundo de Combate à Pobreza (FCP)
  end;

  if FPercentualFCPST <> 0 then
  begin

    FVFCPST := Arredonda( (dBCFCP * dPIVA * FPercentualFCPST / 100), 2);

    if (UpperCase(sUFDestino) = UpperCase(sUFEmitente)) and (UpperCase(sUFEmitente) = 'RJ') then
    begin
      //FFCPRETIDO := ((Arredonda( (dBCFCP * dPIVA * fPercentualFCPST / 100), 2)) - FFCP); // Valor do Fundo de Combate à Pobreza (FCP)
      FVFCPRETIDO := (FVFCPST - FVFCP); // Valor do Fundo de Combate à Pobreza (FCP)
    end else
    begin
      //FFCPRETIDO := ((Arredonda( (dBCFCP * dPIVA * fPercentualFCPST / 100), 2))); // Valor do Fundo de Combate à Pobreza (FCP)
      FVFCPRETIDO := FVFCPST; // Valor do Fundo de Combate à Pobreza (FCP)
    end;
  end;

end;

end.
