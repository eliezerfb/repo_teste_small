unit uNotaFiscalEletronica;

interface

uses
  Dialogs, Classes, SysUtils, SmallFunc,
  IBDatabase, IBCustomDataSet, IBTable, IBQuery, IBDatabaseInfo, IBServices,
  Forms, Windows,DB,
  Controls, Contnrs;

type
  TITENS001 = class;

  TITENS001 = class(TObjectList)
  private
    FNumeronf : string;
    FCodigo : string;
    FDescricao : string;
    FSt : string;
    FIpi : Double;
    FIcm : Double;
    FIss : Double;
    FMedida : string;
    FQuantidade : Double;
    FSincronia : Double;
    FUnitario : Double;
    FTotal : Double;
    FLista : Double;
    FCusto : Double;
    FPeso : Double;
    FBase : Double;
    FBaseiss : Double;
    FAliquota : Double;
    FCfop : string;
    FNumeroos : string;
    FRegistro : string;
    FVicms : Double;
    FVbc : Double;
    FVbcst : Double;
    FVicmsst : Double;
    FVipi : Double;
    FCst_pis_cofins : string;
    FAliq_pis : Double;
    FAliq_cofins : Double;
    FCst_ipi : string;
    FCst_icms : string;
    FXped : string;
    FNitemped : string;
    FAnvisa : Integer;
    FPfcpufdest : Double;
    FPicmsufdest : Double;
    FEncrypthash : string;
    FCsosn : string;
    FVbc_pis_cofins : Double;
    FIdentificadorplanocontas : string;
  published
    property Numeronf : string read FNumeronf write FNumeronf;
    property Codigo : string read FCodigo write FCodigo;
    property Descricao : string read FDescricao write FDescricao;
    property St : string read FSt write FSt;
    property Ipi : Double read FIpi write FIpi;
    property Icm : Double read FIcm write FIcm;
    property Iss : Double read FIss write FIss;
    property Medida : string read FMedida write FMedida;
    property Quantidade : Double read FQuantidade write FQuantidade;
    property Sincronia : Double read FSincronia write FSincronia;
    property Unitario : Double read FUnitario write FUnitario;
    property Total : Double read FTotal write FTotal;
    property Lista : Double read FLista write FLista;
    property Custo : Double read FCusto write FCusto;
    property Peso : Double read FPeso write FPeso;
    property Base : Double read FBase write FBase;
    property Baseiss : Double read FBaseiss write FBaseiss;
    property Aliquota : Double read FAliquota write FAliquota;
    property Cfop : string read FCfop write FCfop;
    property Numeroos : string read FNumeroos write FNumeroos;
    property Registro : string read FRegistro write FRegistro;
    property Vicms : Double read FVicms write FVicms;
    property Vbc : Double read FVbc write FVbc;
    property Vbcst : Double read FVbcst write FVbcst;
    property Vicmsst : Double read FVicmsst write FVicmsst;
    property Vipi : Double read FVipi write FVipi;
    property Cst_pis_cofins : string read FCst_pis_cofins write FCst_pis_cofins;
    property Aliq_pis : Double read FAliq_pis write FAliq_pis;
    property Aliq_cofins : Double read FAliq_cofins write FAliq_cofins;
    property Cst_ipi : string read FCst_ipi write FCst_ipi;
    property Cst_icms : string read FCst_icms write FCst_icms;
    property Xped : string read FXped write FXped;
    property Nitemped : string read FNitemped write FNitemped;
    property Anvisa : Integer read FAnvisa write FAnvisa;
    property Pfcpufdest : Double read FPfcpufdest write FPfcpufdest;
    property Picmsufdest : Double read FPicmsufdest write FPicmsufdest;
    property Encrypthash : string read FEncrypthash write FEncrypthash;
    property Csosn : string read FCsosn write FCsosn;
    property Vbc_pis_cofins : Double read FVbc_pis_cofins write FVbc_pis_cofins;
    property Identificadorplanocontas : string read FIdentificadorplanocontas write FIdentificadorplanocontas;
  end;


  TITENS001List = class(TObjectList)
    private
      function GetItem(Index: Integer): TITENS001;
      procedure SetItem(Index: Integer; const Value: TITENS001);
    public
      function Adiciona(DataSetItens: TibDataSet): TITENS001;
      property Items[Index: Integer]: TITENS001 read GetItem write SetItem;
  end;


  TVENDAS = class
  private
    FNumeronf : string; 
    FModelo : string;
    FVendedor : string;
    FCliente : string;
    FOperacao : string;
    FEmissao : TDateTime;
    FFrete : Double;
    FSeguro : Double;
    FDespesas : Double;
    FDesconto : Double;
    FVolumes : Double;
    FEspecie : string;
    FMarca : string;
    FTransporta : string;
    FFrete12 : string;
    FSaidah : string;
    FSaidad : TDateTime;
    FDuplicatas : Double;
    FBaseicm : Double;
    FBaseiss : Double;
    FIcms : Double;
    FIcmssubsti : Double;
    FBasesubsti : Double;
    FAliquota : Double;
    FIss : Double;
    FIpi : Double;
    FTotal : Double;
    FMercadoria : Double;
    FEmitida : string;
    FServicos : Double;
    FPesobruto : Double;
    FPesoliqui : Double;
    FRegistro : string;
    FNsuh : string;
    FNsu : string;
    FNsud : TDateTime;
    FIdentificador1 : string;
    FLoked : string;
    FNfeprotocolo : string;
    FStatus : string;
    FNfeid : string;
    FNferecibo : string;
    //Complemento : string, Blob
    FIcce : Integer;
    FNvol : string;
    FAnvisa : Integer;
    FPlaca : string;
    FData_cancel : TDateTime;
    FHora_cancel : string;
    FCod_sit : string;
    FFinnfe : string;
    FIndfinal : string;
    FIndpres : string;
    FEncrypthash : string;
    FMarketplace : string;
    FItens : TITENS001List;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  published
    property Numeronf : string read FNumeronf write FNumeronf;
    property Modelo : string read FModelo write FModelo;
    property Vendedor : string read FVendedor write FVendedor;
    property Cliente : string read FCliente write FCliente;
    property Operacao : string read FOperacao write FOperacao;
    property Emissao : TDateTime read FEmissao write FEmissao;
    property Frete : Double read FFrete write FFrete;
    property Seguro : Double read FSeguro write FSeguro;
    property Despesas : Double read FDespesas write FDespesas;
    property Desconto : Double read FDesconto write FDesconto;
    property Volumes : Double read FVolumes write FVolumes;
    property Especie : string read FEspecie write FEspecie;
    property Marca : string read FMarca write FMarca;
    property Transporta : string read FTransporta write FTransporta;
    property Frete12 : string read FFrete12 write FFrete12;
    property Saidah : string read FSaidah write FSaidah;
    property Saidad : TDateTime read FSaidad write FSaidad;
    property Duplicatas : Double read FDuplicatas write FDuplicatas;
    property Baseicm : Double read FBaseicm write FBaseicm;
    property Baseiss : Double read FBaseiss write FBaseiss;
    property Icms : Double read FIcms write FIcms;
    property Icmssubsti : Double read FIcmssubsti write FIcmssubsti;
    property Basesubsti : Double read FBasesubsti write FBasesubsti;
    property Aliquota : Double read FAliquota write FAliquota;
    property Iss : Double read FIss write FIss;
    property Ipi : Double read FIpi write FIpi;
    property Total : Double read FTotal write FTotal;
    property Mercadoria : Double read FMercadoria write FMercadoria;
    property Emitida : string read FEmitida write FEmitida;
    property Servicos : Double read FServicos write FServicos;
    property Pesobruto : Double read FPesobruto write FPesobruto;
    property Pesoliqui : Double read FPesoliqui write FPesoliqui;
    property Registro : string read FRegistro write FRegistro;
    property Nsuh : string read FNsuh write FNsuh;
    property Nsu : string read FNsu write FNsu;
    property Nsud : TDateTime read FNsud write FNsud;
    property Identificador1 : string read FIdentificador1 write FIdentificador1;
    property Loked : string read FLoked write FLoked;
    property Nfeprotocolo : string read FNfeprotocolo write FNfeprotocolo;
    property Status : string read FStatus write FStatus;
    property Nfeid : string read FNfeid write FNfeid;
    property Nferecibo : string read FNferecibo write FNferecibo;
    property Icce : Integer read FIcce write FIcce;
    property Nvol : string read FNvol write FNvol;
    property Anvisa : Integer read FAnvisa write FAnvisa;
    property Placa : string read FPlaca write FPlaca;
    property Data_cancel : TDateTime read FData_cancel write FData_cancel;
    property Hora_cancel : string read FHora_cancel write FHora_cancel;
    property Cod_sit : string read FCod_sit write FCod_sit;
    property Finnfe : string read FFinnfe write FFinnfe;
    property Indfinal : string read FIndfinal write FIndfinal;
    property Indpres : string read FIndpres write FIndpres;
    property Encrypthash : string read FEncrypthash write FEncrypthash;
    property Marketplace : string read FMarketplace write FMarketplace;
    property Itens : TITENS001List read FItens write FItens;
  end;


type
  TNotaFiscalEletronica = class
  private
    FNotaFiscal: TVENDAS;
    function GetTotalMercadoria : Double;
    procedure AtualizaValoresNota(DataSetNF, DataSetItens : TibDataSet);
    procedure AtualizaValoresItens(DataSetItens : TibDataSet);
    procedure AtualizaDataSetNota(DataSetNF, DataSetItens : TibDataSet);
    procedure AtualizaDataSetItens(DataSetItens : TibDataSet);
    procedure CalculaCstPisCofins(DataSetNF, DataSetItens : TibDataSet);
    procedure CalculaImpostos;
  public
    Calculando : Boolean;
    constructor Create; virtual;
    procedure CalculaValores(DataSetNF, DataSetItens : TibDataSet);
    procedure LimpaItens;
    property NotaFiscal : TVENDAS read FNotaFiscal write FNotaFiscal;
  end;

implementation

uses Unit7, Mais, uFuncoesFiscais;


{ TITENS001List }

function TITENS001List.Adiciona(DataSetItens: TibDataSet): TITENS001;
begin
  if DataSetItens.FieldByName('QUANTIDADE').AsFloat <= 0 then
    Exit;

  Result := TITENS001.Create;

  Result.Numeronf       := DataSetItens.FieldByName('NUMERONF').AsString;
  Result.Codigo         := DataSetItens.FieldByName('CODIGO').AsString;
  Result.Descricao      := DataSetItens.FieldByName('DESCRICAO').AsString;
  Result.St             := DataSetItens.FieldByName('ST').AsString;
  Result.Ipi            := DataSetItens.FieldByName('IPI').AsFloat;
  Result.Icm            := DataSetItens.FieldByName('ICM').AsFloat;
  Result.Iss            := DataSetItens.FieldByName('ISS').AsFloat;
  Result.Medida         := DataSetItens.FieldByName('MEDIDA').AsString;
  Result.Quantidade     := DataSetItens.FieldByName('QUANTIDADE').AsFloat;
  Result.Sincronia      := DataSetItens.FieldByName('SINCRONIA').AsFloat;
  Result.Unitario       := DataSetItens.FieldByName('UNITARIO').AsFloat;
  Result.Total          := DataSetItens.FieldByName('TOTAL').AsFloat;
  Result.Lista          := DataSetItens.FieldByName('LISTA').AsFloat;
  Result.Custo          := DataSetItens.FieldByName('CUSTO').AsFloat;
  Result.Peso           := DataSetItens.FieldByName('PESO').AsFloat;
  Result.Base           := DataSetItens.FieldByName('BASE').AsFloat;
  Result.Baseiss        := DataSetItens.FieldByName('BASEISS').AsFloat;
  Result.Aliquota       := DataSetItens.FieldByName('ALIQUOTA').AsFloat;
  Result.Cfop           := DataSetItens.FieldByName('CFOP').AsString;
  Result.Numeroos       := DataSetItens.FieldByName('NUMEROOS').AsString;
  Result.Registro       := DataSetItens.FieldByName('REGISTRO').AsString;
  Result.Vicms          := DataSetItens.FieldByName('VICMS').AsFloat;
  Result.Vbc            := DataSetItens.FieldByName('VBC').AsFloat;
  Result.Vbcst          := DataSetItens.FieldByName('VBCST').AsFloat;
  Result.Vicmsst        := DataSetItens.FieldByName('VICMSST').AsFloat;
  Result.Vipi           := DataSetItens.FieldByName('VIPI').AsFloat;
  Result.Cst_pis_cofins := DataSetItens.FieldByName('CST_PIS_COFINS').AsString;
  Result.Aliq_pis       := DataSetItens.FieldByName('ALIQ_PIS').AsFloat;
  Result.Aliq_cofins    := DataSetItens.FieldByName('ALIQ_COFINS').AsFloat;
  Result.Cst_ipi        := DataSetItens.FieldByName('CST_IPI').AsString;
  Result.Cst_icms       := DataSetItens.FieldByName('CST_ICMS').AsString;
  Result.Xped           := DataSetItens.FieldByName('XPED').AsString;
  Result.Nitemped       := DataSetItens.FieldByName('NITEMPED').AsString;
  Result.Anvisa         := DataSetItens.FieldByName('ANVISA').AsInteger;
  Result.Pfcpufdest     := DataSetItens.FieldByName('PFCPUFDEST').AsFloat;
  Result.Picmsufdest    := DataSetItens.FieldByName('PICMSUFDEST').AsFloat;
  Result.Encrypthash    := DataSetItens.FieldByName('ENCRYPTHASH').AsString;
  Result.Csosn          := DataSetItens.FieldByName('CSOSN').AsString;
  Result.Vbc_pis_cofins := DataSetItens.FieldByName('VBC_PIS_COFINS').AsFloat;
  Result.Identificadorplanocontas := DataSetItens.FieldByName('IDENTIFICADORPLANOCONTAS').AsString;

  Add(Result);
end;

function TITENS001List.GetItem(Index: Integer): TITENS001;
begin
  Result := TITENS001(inherited Items[Index]);
end;


procedure TITENS001List.SetItem(Index: Integer; const Value: TITENS001);
begin
  Put(Index, Value);
end;


{ TVENDAS }

constructor TVENDAS.Create;
begin
  inherited Create;
  FItens := TITENS001List.Create;
end;

destructor TVENDAS.Destroy;
begin
  FItens.Free;

  inherited;
end;


{ TNotaFiscalEletronica }

procedure TNotaFiscalEletronica.AtualizaDataSetItens(DataSetItens: TibDataSet);
var
  i : integer;
  oItem : TITENS001;
begin
  try
    DataSetItens.DisableControls;

    for i := 0 to FNotaFiscal.FItens.Count -1 do
    begin
      oItem := FNotaFiscal.FItens.GetItem(i);

      if DataSetItens.Locate('REGISTRO',oItem.Registro,[]) then
      begin
        DataSetItens.Edit;

        DataSetItens.FieldByName('NUMERONF').AsString       := oItem.Numeronf;
        DataSetItens.FieldByName('CODIGO').AsString         := oItem.Codigo;
        DataSetItens.FieldByName('DESCRICAO').AsString      := oItem.Descricao;
        DataSetItens.FieldByName('ST').AsString             := oItem.St;
        DataSetItens.FieldByName('IPI').AsFloat             := oItem.Ipi;
        DataSetItens.FieldByName('ICM').AsFloat             := oItem.Icm;
        DataSetItens.FieldByName('ISS').AsFloat             := oItem.Iss;
        DataSetItens.FieldByName('MEDIDA').AsString         := oItem.Medida;
        DataSetItens.FieldByName('QUANTIDADE').AsFloat      := oItem.Quantidade;
        DataSetItens.FieldByName('SINCRONIA').AsFloat       := oItem.Sincronia;
        DataSetItens.FieldByName('UNITARIO').AsFloat        := oItem.Unitario;
        DataSetItens.FieldByName('TOTAL').AsFloat           := oItem.Total;
        DataSetItens.FieldByName('LISTA').AsFloat           := oItem.Lista;
        DataSetItens.FieldByName('CUSTO').AsFloat           := oItem.Custo;
        DataSetItens.FieldByName('PESO').AsFloat            := oItem.Peso;
        DataSetItens.FieldByName('BASE').AsFloat            := oItem.Base;
        DataSetItens.FieldByName('BASEISS').AsFloat         := oItem.Baseiss;
        DataSetItens.FieldByName('ALIQUOTA').AsFloat        := oItem.Aliquota;
        DataSetItens.FieldByName('CFOP').AsString           := oItem.Cfop;
        DataSetItens.FieldByName('NUMEROOS').AsString       := oItem.Numeroos;
        DataSetItens.FieldByName('VICMS').AsFloat           := oItem.Vicms;
        DataSetItens.FieldByName('VBC').AsFloat             := oItem.Vbc;
        DataSetItens.FieldByName('VBCST').AsFloat           := oItem.Vbcst;
        DataSetItens.FieldByName('VICMSST').AsFloat         := oItem.Vicmsst;
        DataSetItens.FieldByName('VIPI').AsFloat            := oItem.Vipi;
        DataSetItens.FieldByName('CST_PIS_COFINS').AsString := oItem.Cst_pis_cofins;
        DataSetItens.FieldByName('ALIQ_PIS').AsFloat        := oItem.Aliq_pis;
        DataSetItens.FieldByName('ALIQ_COFINS').AsFloat     := oItem.Aliq_cofins;
        DataSetItens.FieldByName('CST_IPI').AsString        := oItem.Cst_ipi;
        DataSetItens.FieldByName('CST_ICMS').AsString       := oItem.Cst_icms;
        DataSetItens.FieldByName('XPED').AsString           := oItem.Xped;
        DataSetItens.FieldByName('NITEMPED').AsString       := oItem.Nitemped;
        DataSetItens.FieldByName('ANVISA').AsInteger        := oItem.Anvisa;
        DataSetItens.FieldByName('PFCPUFDEST').AsFloat      := oItem.Pfcpufdest;
        DataSetItens.FieldByName('PICMSUFDEST').AsFloat     := oItem.Picmsufdest;
        DataSetItens.FieldByName('ENCRYPTHASH').AsString    := oItem.Encrypthash;
        DataSetItens.FieldByName('CSOSN').AsString          := oItem.Csosn;
        DataSetItens.FieldByName('VBC_PIS_COFINS').AsFloat  :=  oItem.Vbc_pis_cofins;
        DataSetItens.FieldByName('IDENTIFICADORPLANOCONTAS').AsString := oItem.Identificadorplanocontas;

        DataSetItens.Post;
      end;
    end;
  finally
    DataSetItens.EnableControls;
  end
end;

procedure TNotaFiscalEletronica.AtualizaDataSetNota(DataSetNF,DataSetItens : TibDataSet);
begin
  DataSetNF.FieldByName('NUMERONF').AsString        := FNotaFiscal.Numeronf;
  DataSetNF.FieldByName('MODELO').AsString          := FNotaFiscal.Modelo;
  DataSetNF.FieldByName('VENDEDOR').AsString        := FNotaFiscal.Vendedor;
  DataSetNF.FieldByName('CLIENTE').AsString         := FNotaFiscal.Cliente;
  DataSetNF.FieldByName('OPERACAO').AsString        := FNotaFiscal.Operacao;
  DataSetNF.FieldByName('EMISSAO').AsDateTime       := FNotaFiscal.Emissao;
  DataSetNF.FieldByName('FRETE').AsFloat            := FNotaFiscal.Frete;
  DataSetNF.FieldByName('SEGURO').AsFloat           := FNotaFiscal.Seguro;
  DataSetNF.FieldByName('DESPESAS').AsFloat         := FNotaFiscal.Despesas;
  DataSetNF.FieldByName('DESCONTO').AsFloat         := FNotaFiscal.Desconto;
  DataSetNF.FieldByName('VOLUMES').AsFloat          := FNotaFiscal.Volumes;
  DataSetNF.FieldByName('ESPECIE').AsString         := FNotaFiscal.Especie;
  DataSetNF.FieldByName('MARCA').AsString           := FNotaFiscal.Marca;
  DataSetNF.FieldByName('TRANSPORTA').AsString      := FNotaFiscal.Transporta;
  DataSetNF.FieldByName('FRETE12').AsString         := FNotaFiscal.Frete12;
  DataSetNF.FieldByName('SAIDAH').AsString          := FNotaFiscal.Saidah;
  DataSetNF.FieldByName('SAIDAD').AsDateTime        := FNotaFiscal.Saidad;
  DataSetNF.FieldByName('DUPLICATAS').AsFloat       := FNotaFiscal.Duplicatas;
  DataSetNF.FieldByName('BASEICM').AsFloat          := FNotaFiscal.Baseicm;
  DataSetNF.FieldByName('BASEISS').AsFloat          := FNotaFiscal.Baseiss;
  DataSetNF.FieldByName('ICMS').AsFloat             := FNotaFiscal.Icms;
  DataSetNF.FieldByName('ICMSSUBSTI').AsFloat       := FNotaFiscal.Icmssubsti;
  DataSetNF.FieldByName('BASESUBSTI').AsFloat       := FNotaFiscal.Basesubsti;
  DataSetNF.FieldByName('ALIQUOTA').AsFloat         := FNotaFiscal.Aliquota;
  DataSetNF.FieldByName('ISS').AsFloat              := FNotaFiscal.Iss;
  DataSetNF.FieldByName('IPI').AsFloat              := FNotaFiscal.Ipi;
  DataSetNF.FieldByName('TOTAL').AsFloat            := FNotaFiscal.Total;
  DataSetNF.FieldByName('MERCADORIA').AsFloat       := FNotaFiscal.Mercadoria;
  DataSetNF.FieldByName('EMITIDA').AsString         := FNotaFiscal.Emitida;
  DataSetNF.FieldByName('SERVICOS').AsFloat         := FNotaFiscal.Servicos;
  DataSetNF.FieldByName('PESOBRUTO').AsFloat        := FNotaFiscal.Pesobruto;
  DataSetNF.FieldByName('PESOLIQUI').AsFloat        := FNotaFiscal.Pesoliqui;
  DataSetNF.FieldByName('REGISTRO').AsString        := FNotaFiscal.Registro;
  DataSetNF.FieldByName('NSUH').AsString            := FNotaFiscal.Nsuh;
  DataSetNF.FieldByName('NSU').AsString             := FNotaFiscal.Nsu;
  DataSetNF.FieldByName('NSUD').AsDateTime          := FNotaFiscal.Nsud;
  DataSetNF.FieldByName('IDENTIFICADOR1').AsString  := FNotaFiscal.Identificador1;
  DataSetNF.FieldByName('LOKED').AsString           := FNotaFiscal.Loked;
  DataSetNF.FieldByName('NFEPROTOCOLO').AsString    := FNotaFiscal.Nfeprotocolo;
  DataSetNF.FieldByName('STATUS').AsString          := FNotaFiscal.Status;
  DataSetNF.FieldByName('NFEID').AsString           := FNotaFiscal.Nfeid;
  DataSetNF.FieldByName('NFERECIBO').AsString       := FNotaFiscal.Nferecibo;
  DataSetNF.FieldByName('ICCE').AsInteger           := FNotaFiscal.Icce;
  DataSetNF.FieldByName('NVOL').AsString            := FNotaFiscal.Nvol;
  DataSetNF.FieldByName('ANVISA').AsInteger         := FNotaFiscal.Anvisa;
  DataSetNF.FieldByName('PLACA').AsString           := FNotaFiscal.Placa;
  DataSetNF.FieldByName('DATA_CANCEL').AsDateTime   := FNotaFiscal.Data_cancel;
  DataSetNF.FieldByName('HORA_CANCEL').AsString     := FNotaFiscal.Hora_cancel;
  DataSetNF.FieldByName('COD_SIT').AsString         := FNotaFiscal.Cod_sit;
  DataSetNF.FieldByName('FINNFE').AsString          := FNotaFiscal.Finnfe;
  DataSetNF.FieldByName('INDFINAL').AsString        := FNotaFiscal.Indfinal;
  DataSetNF.FieldByName('INDPRES').AsString         := FNotaFiscal.Indpres;
  DataSetNF.FieldByName('ENCRYPTHASH').AsString     := FNotaFiscal.Encrypthash;
  DataSetNF.FieldByName('MARKETPLACE').AsString     := FNotaFiscal.Marketplace;

  AtualizaDataSetItens(DataSetItens);
end;

procedure TNotaFiscalEletronica.AtualizaValoresItens(DataSetItens: TibDataSet);
begin
  LimpaItens;

  try
    DataSetItens.DisableControls;
    DataSetItens.First;

    while not DataSetItens.Eof do
    begin
      FNotaFiscal.Itens.Adiciona(DataSetItens);
      DataSetItens.Next;
    end;
  finally
    DataSetItens.EnableControls;
  end;
end;

procedure TNotaFiscalEletronica.AtualizaValoresNota(DataSetNF, DataSetItens : TibDataSet);
begin
  FNotaFiscal.Numeronf        := DataSetNF.FieldByName('NUMERONF').AsString;
  FNotaFiscal.Modelo          := DataSetNF.FieldByName('MODELO').AsString;
  FNotaFiscal.Vendedor        := DataSetNF.FieldByName('VENDEDOR').AsString;
  FNotaFiscal.Cliente         := DataSetNF.FieldByName('CLIENTE').AsString;
  FNotaFiscal.Operacao        := DataSetNF.FieldByName('OPERACAO').AsString;
  FNotaFiscal.Emissao         := DataSetNF.FieldByName('EMISSAO').AsDateTime;
  FNotaFiscal.Frete           := DataSetNF.FieldByName('FRETE').AsFloat;
  FNotaFiscal.Seguro          := DataSetNF.FieldByName('SEGURO').AsFloat;
  FNotaFiscal.Despesas        := DataSetNF.FieldByName('DESPESAS').AsFloat;
  FNotaFiscal.Desconto        := DataSetNF.FieldByName('DESCONTO').AsFloat;
  FNotaFiscal.Volumes         := DataSetNF.FieldByName('VOLUMES').AsFloat;
  FNotaFiscal.Especie         := DataSetNF.FieldByName('ESPECIE').AsString;
  FNotaFiscal.Marca           := DataSetNF.FieldByName('MARCA').AsString;
  FNotaFiscal.Transporta      := DataSetNF.FieldByName('TRANSPORTA').AsString;
  FNotaFiscal.Frete12         := DataSetNF.FieldByName('FRETE12').AsString;
  FNotaFiscal.Saidah          := DataSetNF.FieldByName('SAIDAH').AsString;
  FNotaFiscal.Saidad          := DataSetNF.FieldByName('SAIDAD').AsDateTime;
  FNotaFiscal.Duplicatas      := DataSetNF.FieldByName('DUPLICATAS').AsFloat;
  FNotaFiscal.Baseicm         := DataSetNF.FieldByName('BASEICM').AsFloat;
  FNotaFiscal.Baseiss         := DataSetNF.FieldByName('BASEISS').AsFloat;
  FNotaFiscal.Icms            := DataSetNF.FieldByName('ICMS').AsFloat;
  FNotaFiscal.Icmssubsti      := DataSetNF.FieldByName('ICMSSUBSTI').AsFloat;
  FNotaFiscal.Basesubsti      := DataSetNF.FieldByName('BASESUBSTI').AsFloat;
  FNotaFiscal.Aliquota        := DataSetNF.FieldByName('ALIQUOTA').AsFloat;
  FNotaFiscal.Iss             := DataSetNF.FieldByName('ISS').AsFloat;
  FNotaFiscal.Ipi             := DataSetNF.FieldByName('IPI').AsFloat;
  FNotaFiscal.Total           := DataSetNF.FieldByName('TOTAL').AsFloat;
  FNotaFiscal.Mercadoria      := DataSetNF.FieldByName('MERCADORIA').AsFloat;
  FNotaFiscal.Emitida         := DataSetNF.FieldByName('EMITIDA').AsString;
  FNotaFiscal.Servicos        := DataSetNF.FieldByName('SERVICOS').AsFloat;
  FNotaFiscal.Pesobruto       := DataSetNF.FieldByName('PESOBRUTO').AsFloat;
  FNotaFiscal.Pesoliqui       := DataSetNF.FieldByName('PESOLIQUI').AsFloat;
  FNotaFiscal.Registro        := DataSetNF.FieldByName('REGISTRO').AsString;
  FNotaFiscal.Nsuh            := DataSetNF.FieldByName('NSUH').AsString;
  FNotaFiscal.Nsu             := DataSetNF.FieldByName('NSU').AsString;
  FNotaFiscal.Nsud            := DataSetNF.FieldByName('NSUD').AsDateTime;
  FNotaFiscal.Identificador1  := DataSetNF.FieldByName('IDENTIFICADOR1').AsString;
  FNotaFiscal.Loked           := DataSetNF.FieldByName('LOKED').AsString;
  FNotaFiscal.Nfeprotocolo    := DataSetNF.FieldByName('NFEPROTOCOLO').AsString;
  FNotaFiscal.Status          := DataSetNF.FieldByName('STATUS').AsString;
  FNotaFiscal.Nfeid           := DataSetNF.FieldByName('NFEID').AsString;
  FNotaFiscal.Nferecibo       := DataSetNF.FieldByName('NFERECIBO').AsString;
  FNotaFiscal.Icce            := DataSetNF.FieldByName('ICCE').AsInteger;
  FNotaFiscal.Nvol            := DataSetNF.FieldByName('NVOL').AsString;
  FNotaFiscal.Anvisa          := DataSetNF.FieldByName('ANVISA').AsInteger;
  FNotaFiscal.Placa           := DataSetNF.FieldByName('PLACA').AsString;
  FNotaFiscal.Data_cancel     := DataSetNF.FieldByName('DATA_CANCEL').AsDateTime;
  FNotaFiscal.Hora_cancel     := DataSetNF.FieldByName('HORA_CANCEL').AsString;
  FNotaFiscal.Cod_sit         := DataSetNF.FieldByName('COD_SIT').AsString;
  FNotaFiscal.Finnfe          := DataSetNF.FieldByName('FINNFE').AsString;
  FNotaFiscal.Indfinal        := DataSetNF.FieldByName('INDFINAL').AsString;
  FNotaFiscal.Indpres         := DataSetNF.FieldByName('INDPRES').AsString;
  FNotaFiscal.Encrypthash     := DataSetNF.FieldByName('ENCRYPTHASH').AsString;
  FNotaFiscal.Marketplace     := DataSetNF.FieldByName('MARKETPLACE').AsString;

  AtualizaValoresItens(DataSetItens);
end;

procedure TNotaFiscalEletronica.CalculaCstPisCofins(DataSetNF, DataSetItens: TibDataSet);
var
  IBQTemp, IBQProduto: TIBQuery;

  sCST_PIS_COFINS: String;
  rpPIS, rpCOFINS, bcPISCOFINS_op : Real;

  //CIT campo ST
  sCST_PIS_COFINS_ITEM: String;
  rpPIS_ITEM, rpCOFINS_ITEM, bcPISCOFINS_op_ITEM : Real;

  vBC_PISCOFINS, vRaterioDesconto : Real;

  oItem : TITENS001;
  i : integer;
begin
  IBQTemp := Form7.CriaIBQuery(DataSetNF.Transaction);
  IBQProduto := Form7.CriaIBQuery(DataSetNF.Transaction);

  IBQTemp.Close;
  IBQTemp.SQL.Text := ' Select *'+
                      ' From ICM '+
                      ' Where NOME = '+QuotedStr(FNotaFiscal.Operacao);
  IBQTemp.Open;

  sCST_PIS_COFINS := IBQTemp.FieldByname('CSTPISCOFINS').AsString;
  rpPIS           := IBQTemp.FieldByname('PPIS').AsFloat;
  rpCOFINS        := IBQTemp.FieldByname('PCOFINS').AsFloat;
  bcPISCOFINS_op  := IBQTemp.FieldByname('BCPISCOFINS').AsFloat;

  //Atualiza Item por Item

  for i := 0 to FNotaFiscal.FItens.Count -1 do
  begin
    oItem := FNotaFiscal.FItens.GetItem(i);
    //Começa usando configurações da nota
    sCST_PIS_COFINS_ITEM := sCST_PIS_COFINS;
    rpPIS_ITEM           := rpPIS;
    rpCOFINS_ITEM        := rpCOFINS;
    bcPISCOFINS_op_ITEM  := bcPISCOFINS_op;

    //Pega Info do Produto
    IBQProduto.Close;
    IBQProduto.SQL.Text := ' Select * '+
                           ' From ESTOQUE'+
                           ' Where DESCRICAO = '+QuotedStr(oItem.DESCRICAO);
    IBQProduto.Open;

    //Raterio Desconto
    if FNotaFiscal.Desconto <> 0 then
      vRaterioDesconto := Arredonda((FNotaFiscal.Desconto / FNotaFiscal.Mercadoria * oItem.TOTAL),2)
    else
      vRaterioDesconto := 0;

    //Verifica se tem CIT  
    if IBQProduto.FieldByName('ST').AsString <> '' then
    begin
      IBQTemp.Close;
      IBQTemp.SQL.Text := ' Select *'+
                          ' From ICM '+
                          ' Where ST = '+QuotedStr(IBQProduto.FieldByName('ST').AsString);
      IBQTemp.Open;
                         
      if not IBQTemp.IsEmpty then
      begin
        sCST_PIS_COFINS_ITEM := IBQTemp.FieldByname('CSTPISCOFINS').AsString;
        rpPIS_ITEM           := IBQTemp.FieldByname('PPIS').AsFloat;
        rpCOFINS_ITEM        := IBQTemp.FieldByname('PCOFINS').AsFloat;
        bcPISCOFINS_op_ITEM  := IBQTemp.FieldByname('BCPISCOFINS').AsFloat;
      end;
    end;

    if Alltrim(sCST_PIS_COFINS_ITEM) <> '' then
    begin
      oItem.CST_PIS_COFINS  := sCST_PIS_COFINS_ITEM;
      oItem.ALIQ_PIS        := rpPIS_ITEM;
      oItem.ALIQ_COFINS     := rpCOFINS_ITEM;
      vBC_PISCOFINS         := 0;

      if (rpPIS_ITEM * bcPISCOFINS_op_ITEM <> 0) then
      begin
        vBC_PISCOFINS := oItem.TOTAL - vRaterioDesconto - oItem.VICMS;

        //Base Reduzida
        vBC_PISCOFINS := vBC_PISCOFINS * (bcPISCOFINS_op_ITEM / 100);
      end;

      oItem.VBC_PIS_COFINS := vBC_PISCOFINS;
    end else
    begin
      if (IBQProduto.FieldByname('ALIQ_PIS_SAIDA').AsFloat <> 0) then
      begin
        oItem.CST_PIS_COFINS := IBQProduto.FieldByname('CST_PIS_COFINS_SAIDA').AsString;

        // Pega o CST PIS COFINS e o PERCENTUAL do iten
        if Copy(IBQProduto.FieldByname('CST_PIS_COFINS_SAIDA').AsString,1,2) = '03' then // Pis por unidade
        begin
          oItem.VBC_PIS_COFINS     := oItem.TOTAL; // Valor da Base de Cálculo
          oItem.ALIQ_PIS           := 0;
          oItem.ALIQ_COFINS        := 0;
        end else
        begin
          oItem.ALIQ_PIS        := IBQProduto.FieldByname('ALIQ_PIS_SAIDA').AsFloat;
          oItem.ALIQ_COFINS     := IBQProduto.FieldByname('ALIQ_COFINS_SAIDA').AsFloat;

          if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('BCPISCOFINS',IBQProduto.FieldByname('TAGS_').AsString)) <> '' then  // A tag BCPISCOFINS está preenchida
          begin
            oItem.VBC_PIS_COFINS := StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('BCPISCOFINS',Form7.ibDataSet4.FieldByname('TAGS_').AsString)));
          end else
          begin
            oItem.VBC_PIS_COFINS := oItem.TOTAL - vRaterioDesconto - oItem.VICMS;
          end;
        end;
      end else
      begin
        oItem.CST_PIS_COFINS  := '08';// Codigo de Situacao Tributária - ver opções no Manual
        oItem.ALIQ_PIS        := 0;
        oItem.ALIQ_COFINS     := 0;
        oItem.VBC_PIS_COFINS  := 0;
      end;
    end;
  end;

  FreeAndNil(IBQTemp);
  FreeAndNil(IBQProduto);
end;

procedure TNotaFiscalEletronica.CalculaImpostos;
var
  fFCP, fPercentualFCP, fPercentualFCPST, fTotalMercadoria, fRateioDoDesconto, fIPIPorUnidade, fSomaNaBase, TotalBASE, TotalICMS : Real;
  sreg, sReg4, sEstado : String;
  tInicio : tTime;
  Hora, Min, Seg, cent: Word;

  vlBalseIPI, vlFreteRateadoItem : Double;
  vlBalseICMSItem, vlICMSItem : Double;
  vFreteSobreIPI, vIPISobreICMS : Boolean;

  fFCPRetido : Real;

  oItem : TITENS001;
  i : integer;
begin
  FNotaFiscal.Mercadoria := 0;
  FNotaFiscal.Baseicm    := 0;
  FNotaFiscal.Baseiss    := 0;
  FNotaFiscal.Icms       := 0;
  FNotaFiscal.Ipi        := 0;
  FNotaFiscal.Iss        := 0;
  FNotaFiscal.Pesoliqui  := 0;
  FNotaFiscal.Basesubsti := 0;
  FNotaFiscal.Icmssubsti := 0;
  fFCPRetido  := 0;

  sReg4  := Form7.ibDataSet4REGISTRO.AsString;

  if FNotaFiscal.Finnfe = '4' then // Devolucao Devolução
  begin
    for i := 0 to FNotaFiscal.FItens.Count -1 do
    begin
      oItem := FNotaFiscal.FItens.GetItem(i);

      if oItem.Quantidade <> 0 then
      begin
        FNotaFiscal.Mercadoria := FNotaFiscal.Mercadoria + Arredonda(oItem.Total,2);
        FNotaFiscal.Baseicm    := FNotaFiscal.Baseicm    + Arredonda(oItem.Vbc,2);
        FNotaFiscal.Icms       := FNotaFiscal.Icms       + Arredonda(oItem.Vicms,2);
        FNotaFiscal.Ipi        := FNotaFiscal.Ipi        + Arredonda(oItem.Vipi,2);
        FNotaFiscal.Icmssubsti := FNotaFiscal.Icmssubsti + Arredonda(oItem.Vicmsst,2);
        FNotaFiscal.Basesubsti := FNotaFiscal.Basesubsti + Arredonda(oItem.Vbcst,2);
        FNotaFiscal.Pesoliqui  := FNotaFiscal.Pesoliqui  + oItem.Peso * oItem.Quantidade;
      end;
    end;
  end else
  begin
    //Mauricio Parizotto 2023-04-03
    fTotalMercadoria := GetTotalMercadoria;

    //Mauricio Parizotto 2023-03-28
    vFreteSobreIPI := CampoICMporNatureza('FRETESOBREIPI',FNotaFiscal.Operacao ,Form7.ibDataSet15.Transaction) = 'S';
    vIPISobreICMS  := CampoICMporNatureza('SOBREIPI',FNotaFiscal.Operacao,Form7.ibDataSet15.Transaction) = 'S';


    for i := 0 to FNotaFiscal.FItens.Count -1 do
    begin
      oItem := FNotaFiscal.FItens.GetItem(i);
      
      Form7.ibDataSet4.Close;
      Form7.ibDataSet4.Selectsql.Clear;
      Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(oItem.Codigo)+' ');  //
      Form7.ibDataSet4.Open;

      try
        if FNotaFiscal.Desconto <> 0 then
          fRateioDoDesconto  := Arredonda((FNotaFiscal.Desconto / fTotalMErcadoria * oItem.Total),2)
        else
          fRateioDoDesconto := 0;
      except
        fRateioDoDesconto := 0;
      end;

      if AllTrim(Form7.ibDataSet4ST.Value) <> '' then       // Quando alterar esta rotina alterar também retributa Ok 1/ Abril
      begin
        // Nova rotina para posicionar na tabéla de CFOP
        Form7.IBQuery14.Close;
        Form7.IBQuery14.SQL.Clear;
        Form7.IBQuery14.SQL.Add('select * from ICM where ST='+QuotedStr(Form7.ibDataSet4ST.AsString)+''); // Nova rotina
        Form7.IBQuery14.Open;

        if Form7.IBQuery14.FieldByName('ST').AsString <> Form7.ibDataSet4ST.AsString then
        begin
          Form7.IBQuery14.Close;
          Form7.IBQuery14.SQL.Clear;
          Form7.IBQuery14.SQL.Add('select * from ICM where NOME='+QuotedStr(FNotaFiscal.Operacao)+' ');
          Form7.IBQuery14.Open;
        end;
      end else
      begin
        Form7.IBQuery14.Close;
        Form7.IBQuery14.SQL.Clear;
        Form7.IBQuery14.SQL.Add('select * from ICM where NOME='+QuotedStr(FNotaFiscal.Operacao)+' ');
        Form7.IBQuery14.Open;
      end;

      if oItem.Quantidade <> 0 then
      begin
        FNotaFiscal.Pesoliqui := FNotaFiscal.Pesoliqui + oItem.Peso * oItem.Quantidade;

        if (Pos(Alltrim(oItem.Cfop),Form1.CFOP5124) = 0) then// 5124 Industrialização efetuada para outra empresa não soma na base
        begin
          FNotaFiscal.Baseiss := FNotaFiscal.Baseiss + (oItem.TOTAL * oItem.BASEISS / 100 );
          if oItem.BASE > 0 then
          begin
            // NOTA DEVOLUCAO D E V
            if ((Form7.ibDAtaset13.FieldByname('CRT').AsString = '1') and ( (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '900') or (Form7.ibDataSet14.FieldByname('CSOSN').AsString = '900') ))
            or ((Form7.ibDAtaset13.FieldByname('CRT').AsString <> '1') and (
                                                                       (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '00') or
                                                                       (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '10') or
                                                                       (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '20') or
                                                                       (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '51') or
                                                                       (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '70') or
                                                                       (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '90')))
            then
            begin
              FNotaFiscal.Baseicm    := FNotaFiscal.Baseicm  + Arredonda((oItem.TOTAL * oItem.BASE / 100 ),2);
              FNotaFiscal.Icms       := FNotaFiscal.Icms     + Arredonda(( (oItem.TOTAL) * oItem.BASE / 100 *  oItem.ICM / 100 ),2); // Acumula em 16 After post
              oItem.Vicms            := Arredonda(( (oItem.TOTAL) * oItem.BASE / 100 *  oItem.ICM / 100 ),2);
            end;
          end;

          FNotaFiscal.Iss := FNotaFiscal.Iss  + ( oItem.TOTAL * oItem.ISS / 100 );
        end;

        // Soma o CFOP 5124 ou 6124 no TOTAL da nota mas não soma na MERCADORIA
        // 5124 Industrialização efetuada para outra empresa
        if (oItem.BASEISS <> 100) and (Pos(Alltrim(oItem.CFOP),Form1.CFOP5124) = 0) then // 5124 Industrialização efetuada para outra empresa não soma na base
        begin
          FNotaFiscal.Mercadoria := FNotaFiscal.Mercadoria + Arredonda(oItem.TOTAL,2);
        end;

        if (Copy(Form7.ibQuery14.FieldByname('CFOP').AsString,1,4) = '5101') or (Copy(Form7.ibQuery14.FieldByname('CFOP').AsString,1,4) = '6101') or (Pos('IPI',Form7.ibQuery14.FieldByname('OBS').AsString) <> 0) then
        begin
          // IPI
          {Mauricio Parizotto 2023-03-30 Inicio}
          if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
          begin
            FNotaFiscal.Ipi := FNotaFiscal.Ipi + Arredonda2((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',form7.ibDataSet4.FieldByname('TAGS_').AsString)))),2);

            //if ((Form7.ibQuery14.FieldByname('SOBREIPI').AsString = 'S')) then
            if vIPISobreICMS then
            begin
              FNotaFiscal.Baseicm   := FNotaFiscal.Baseicm + Arredonda((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',form7.ibDataSet4.FieldByname('TAGS_').AsString)))),2); //
              FNotaFiscal.ICMS      := FNotaFiscal.ICMS    + Arredonda(((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',form7.ibDataSet4.FieldByname('TAGS_').AsString))) * oItem.BASE / 100 * oItem.ICM / 100 )),2); // Acumula em 16 After post
              oItem.Vicms           := Arredonda(((oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',form7.ibDataSet4.FieldByname('TAGS_').AsString))) * oItem.BASE / 100 * oItem.ICM / 100 )),2);
            end;
          end else
          begin
            vlFreteRateadoItem := 0;

            if vFreteSobreIPI then
              vlFreteRateadoItem := Arredonda((FNotaFiscal.Frete / fTotalMercadoria)
                                               * oItem.TOTAL,2);

            vlBalseIPI := oItem.TOTAL + vlFreteRateadoItem;

            FNotaFiscal.IPI := FNotaFiscal.Ipi + Arredonda2((vlBalseIPI * ( oItem.IPI / 100 )),2);

            {FNotaFiscal.IPI.Value         := FNotaFiscal.IPI.Value +
                                 Arredonda2((oItem.QUANTIDADE').Asfloat *
                                 oItem.UNITARIO').AsFloat   *
                                 ( oItem.IPI').Value / 100 )),2); // 450 Valor IPI do item Uso o int para arredondar 2 casas}

            {Mauricio Parizotto 2023-03-30 Fim}
          end;

          // Calcula o ICM
          if (vIPISobreICMS) and (oItem.IPI<>0) then
          begin
            if oItem.BASE > 0 then
            begin
              if Form7.ibDataSet4PIVA.AsFloat > 0 then
              begin
                // NOTA DEVOLUCAO D E V
                if ((Form7.ibDAtaset13.FieldByname('CRT').AsString = '1') and ( (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '900') or (Form7.ibDataSet14.FieldByname('CSOSN').AsString = '900') ))
                or ((Form7.ibDAtaset13.FieldByname('CRT').AsString <> '1') and (
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '00') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '10') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '20') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '51') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '70') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '90')))
                then
                begin
                  vlBalseICMSItem := Arredonda(( ((oItem.IPI * oItem.TOTAL) / 100) * oItem.BASE / 100 ),2);
                  vlICMSItem      := Arredonda(( ((oItem.IPI * oItem.TOTAL) / 100) * oItem.BASE / 100 * oItem.ICM / 100 ),2);

                  FNotaFiscal.Baseicm  := FNotaFiscal.Baseicm + vlBalseICMSItem;
                  FNotaFiscal.Icms     := FNotaFiscal.Icms    + vlICMSItem;
                  oItem.Vicms          := vlICMSItem;
                end;

                // CALCULO DO IVA
                if AliqICMdoCliente101() <= Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
                begin
                  //
                  if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
                  begin
                    // VINICULAS
                    try
                      FNotaFiscal.Basesubsti := Arredonda(FNotaFiscal.Basesubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100) * Form7.ibDataset4PIVA.AsFloat ),2); // Rateio desconto
                      FNotaFiscal.Icmssubsti := Arredonda(FNotaFiscal.Icmssubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 * Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100) * Form7.ibDataset4PIVA.AsFloat),2); // Acumula em 16 After post                        //  // Rateio desconto
                    except end;
                  end else
                  begin
                    FNotaFiscal.Basesubsti := Arredonda(FNotaFiscal.Basesubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100) * Form7.ibDataset4PIVA.AsFloat ),2);
                    FNotaFiscal.Icmssubsti := Arredonda(FNotaFiscal.Icmssubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100) * Form7.ibDataset4PIVA.AsFloat),2); // Acumula em 16 After post                        //
                  end;

                  // Desconta do ICMS substituido o ICMS normal
                  FNotaFiscal.Icmssubsti := Arredonda(FNotaFiscal.Icmssubsti - ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * AliqICMdoCliente101() / 100 ),2); // Acumula em 16 After post
                end else
                begin
                  if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
                  begin
                    // VINICULAS
                    try
                      FNotaFiscal.Basesubsti := Arredonda(FNotaFiscal.Basesubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100) * Form7.ibDataset4PIVA.AsFloat ),2);
                      FNotaFiscal.Icmssubsti := Arredonda(FNotaFiscal.Icmssubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 * AliqICMdoCliente101() / 100) * Form7.ibDataset4PIVA.AsFloat),2); // Acumula em 16 After post                        //
                    except end;
                  end else
                  begin
                    FNotaFiscal.Basesubsti := Arredonda(FNotaFiscal.Basesubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100) * Form7.ibDataset4PIVA.AsFloat ),2);
                    FNotaFiscal.Icmssubsti := Arredonda(FNotaFiscal.Icmssubsti + ( ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * AliqICMdoCliente101() / 100) * Form7.ibDataset4PIVA.AsFloat),2); // Acumula em 16 After post                        //
                  end;

                  // Desconta do ICMS substituido o ICMS normal
                  FNotaFiscal.Icmssubsti := Arredonda(FNotaFiscal.Icmssubsti - ((oItem.IPI * (oItem.TOTAL-fRateioDoDesconto) / 100) * oItem.BASE / 100 * Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 ),2); // Acumula em 16 After post
                end;
              end else
              begin
                // NOTA DEVOLUCAO D E V
                if ((Form7.ibDAtaset13.FieldByname('CRT').AsString = '1') and ( (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '900') or (Form7.ibDataSet14.FieldByname('CSOSN').AsString = '900') ))
                or ((Form7.ibDAtaset13.FieldByname('CRT').AsString <> '1') and (
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '00') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '10') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '20') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '51') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '70') or
                                                                           (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '90')))
                then
                begin
                  vlBalseICMSItem := Arredonda(( ((oItem.IPI * oItem.TOTAL) / 100) * oItem.BASE / 100 ),2);
                  vlICMSItem      := Arredonda(( ((oItem.IPI * oItem.TOTAL) / 100) * oItem.BASE / 100 * oItem.ICM / 100 ),2);

                  FNotaFiscal.Baseicm  := FNotaFiscal.Baseicm    + vlBalseICMSItem;
                  FNotaFiscal.Icms     := FNotaFiscal.Icms       + vlICMSItem;
                  oItem.Vicms          := vlICMSItem;
                end;
              end;
            end;
          end;
        end;

        // Fundo de combate a pobresa
        if (
            (LimpaNumero(Form7.ibDAtaset13.FieldByname('CRT').AsString) <> '0') and
            (
             (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '10') or
             (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '30') or
             (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '70') or
             (Copy(LimpaNumero(Form7.ibDataSet4.FieldByname('CST').AsString)+'000',2,2) = '90')
            )
           ) or
           (
            (LimpaNumero(Form7.ibDAtaset13.FieldByname('CRT').AsString) = '1') and
            (
             (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '900')                           or
             (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '201')                           or
             (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '202')                           or
             (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '203')
            )
           ) then
        begin
          // 1 - Simples nacional
          // 2 - Simples nacional - Excesso de Sublimite de Receita Bruta
          // 3 - Regime normal
          //
          // Fundo de combate a pobresa Retido deve somar no total da nota
          //
          // ShowMessage('CRT: '+LimpaNumero(ibDAtaset13.FieldByname('CRT').AsString)+chr(10)+
          //             'CST: '+LimpaNumero(ibDataSet4.FieldByname('CST').AsString)+Chr(10)+
          //             'CSOSN: '+ibDataSet4.FieldByname('CSOSN').AsString);
          // <FCP>


          if (oItem.PFCPUFDEST <> 0) or (oItem.PICMSUFDEST <> 0) then
          begin
            // Quando preenche na nota não vai nada nessas tags
            fPercentualFCP := 0;
            fPercentualFCPST := 0; // fPercentualFCP; // tributos da NF-e 16 AfterPost
          end else
          begin
            if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCP',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
            begin
              fPercentualFCP := StrTofloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCP',Form7.ibDataSet4.FieldByname('TAGS_').AsString))); // tributos da NF-e
            end else
            begin
              fPercentualFCP := 0;
            end;

            // fPercentualFCPST 16 AfterPost
            if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCPST',Form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
            begin
              fPercentualFCPST := StrTofloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('FCPST',Form7.ibDataSet4.FieldByname('TAGS_').AsString))); // tributos da NF-e 16 AfterPost
            end else
            begin
              fPercentualFCPST := 0; // fPercentualFCP; // tributos da NF-e 16 AfterPost
            end;
          end;

          if fPercentualFCP <> 0 then
          begin
            fFCP       := Arredonda((oItem.TOTAL*fPercentualFCP/100),2); // Valor do Fundo de Combate à Pobreza (FCP)
          end else
          begin
            fFCP       := 0;
          end;

          if fPercentualFCPST <> 0 then
          begin
            if (UpperCase(Form7.ibDataSet2ESTADO.AsString) = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (UpperCase(Form7.ibDataSet13ESTADO.AsString)='RJ') then
            begin
              fFCPRetido := ((fFCPRetido + Arredonda( (oItem.TOTAL * Form7.ibDataSet4PIVA.AsFloat * fPercentualFCPST / 100),2))-fFCP); // Valor do Fundo de Combate à Pobreza (FCP)
            end else
            begin
              fFCPRetido := ((fFCPRetido + Arredonda( (oItem.TOTAL * Form7.ibDataSet4PIVA.AsFloat * fPercentualFCPST / 100),2))); // Valor do Fundo de Combate à Pobreza (FCP)
            end;
          end;

          // FCP - Fundo de Combate a Pobresa
        end;

        // SUBSTITUIÇÃO TRIBUTÁRIA
        try
          if Form7.ibDataSet4PIVA.AsFloat > 0 then
          begin
            // IPI Por Unidade
            fIPIPorUnidade := 0;
            if LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',form7.ibDataSet4.FieldByname('TAGS_').AsString)) <> '' then
            begin
              fIPIPorUnidade := (oItem.QUANTIDADE * StrToFloat(LimpaNumeroDeixandoAvirgula(RetornaValorDaTagNoCampo('vUnid',form7.ibDataSet4.FieldByname('TAGS_').AsString))));
            end;

            // CALCULO DO IVA
            if AliqICMdoCliente101() <= Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat then
            begin
              if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
              begin
                // VINICULAS
                try
                  FNotaFiscal.Basesubsti := FNotaFiscal.Basesubsti + Arredonda((
                  (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                   * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 * Form7.ibDataSet4PIVA.AsFloat),2);
                  //
                  FNotaFiscal.Icmssubsti := Arredonda(FNotaFiscal.Icmssubsti +
                  (((
                  (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                  ) * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100
                   *  Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataset4PIVA.AsFloat ),2);
                except
                  on E: Exception do
                  begin
                    Application.MessageBox(pChar(E.Message+chr(10)+chr(10)+'no calculo do ICMS substituição. Verifique o valor da tag <BCST> Erro: 16687'
                    ),'Atenção',mb_Ok + MB_ICONWARNING);
                  end;
                end;
              end else
              begin
                FNotaFiscal.Basesubsti := Arredonda(FNotaFiscal.Basesubsti +
                ((oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                 * oItem.BASE / 100 * Form7.ibDataSet4PIVA.AsFloat),2);

                FNotaFiscal.Icmssubsti := Arredonda(FNotaFiscal.Icmssubsti +
                (((
                ((oItem.TOTAL-fRateioDoDesconto) + fIPIPorUnidade)
                ) * oItem.BASE / 100
                 *  Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 )* Form7.ibDataset4PIVA.AsFloat ),2); // Não pode arredondar aqui
              end;

              // Desconta do ICMS substituido o ICMS normal
              FNotaFiscal.Icmssubsti := Arredonda(FNotaFiscal.Icmssubsti - (((oItem.TOTAL-fRateioDoDesconto)
              ) * oItem.BASE / 100 *  AliqICMdoCliente101() / 100 ),2); // Acumula em 16 After post
            end else
            begin
              if pos('<BCST>',Form7.ibDataSet14OBS.AsString) <> 0 then
              begin
                // VINICULAS
                try
                  FNotaFiscal.Basesubsti := FNotaFiscal.Basesubsti + Arredonda((
                  (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade) *
                  StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100 * Form7.ibDataset4PIVA.AsFloat),2);
                  //
                  FNotaFiscal.Icmssubsti := Arredonda(FNotaFiscal.Icmssubsti +
                  (((
                  (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                  ) * StrToFloat(Copy(Form7.ibDataSet14OBS.AsString,pos('<BCST>',Form7.ibDataSet14OBS.AsString)+6,5)) / 100
                   * AliqICMdoCliente101() / 100 )* Form7.ibDataset4PIVA.AsFloat ),2);
                except
                end;
              end else
              begin
                FNotaFiscal.Basesubsti := FNotaFiscal.Basesubsti + Arredonda((
                (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade) *
                oItem.BASE / 100 * Form7.ibDataset4PIVA.AsFloat),2);
                
                FNotaFiscal.Icmssubsti := Arredonda(FNotaFiscal.Icmssubsti +
                (((
                (oItem.TOTAL-fRateioDoDesconto + fIPIPorUnidade)
                ) * oItem.BASE / 100
                 * AliqICMdoCliente101() / 100 )* Form7.ibDataset4PIVA.AsFloat ),2);
              end;

              // Desconta do ICMS substituido o ICMS normal
              FNotaFiscal.Icmssubsti := Arredonda(FNotaFiscal.Icmssubsti - ((
              ((oItem.TOTAL-fRateioDoDesconto)
              )) * oItem.BASE / 100 *   Form7.ibQuery14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 ),2); // Acumula em 16 After post
            end;
          end;
        except
        end;
      end;
    end;

    // Passa novamente para calcular a regra de tres de frete desconto outras
    for i := 0 to FNotaFiscal.FItens.Count -1 do
    begin
      oItem := FNotaFiscal.FItens.GetItem(i);
      if oItem.QUANTIDADE <> 0 then
      begin
        if (Pos(Alltrim(oItem.CFOP),Form1.CFOP5124) = 0) then// 5124 Industrialização efetuada para outra empresa não soma na base
        begin
          if oItem.BASE > 0 then
          begin
            if not ( Form7.ibDataSet4PIVA.AsFloat > 0 ) or (Copy(Form7.ibDataSet4.FieldByname('CST').AsString,2,2)='70') or (Copy(Form7.ibDataSet4.FieldByname('CST').AsString,2,2)='10') or (Form7.ibDataSet4.FieldByname('CSOSN').AsString = '900') then
            begin
              if (LimpaNumero(Form7.ibDAtaset13.FieldByname('CRT').AsString) <> '1')
              or (Copy(oItem.CFOP,2,3) = '201')
              or (Copy(oItem.CFOP,2,3) = '202')
              or (Copy(oItem.CFOP,2,3) = '411') then
              begin
                fSomaNaBase := 0;

                //Soma o Frete no ICMS
                if FNotaFiscal.Frete <> 0 then
                begin
                  if (FNotaFiscal.Frete / FNotaFiscal.Mercadoria * oItem.TOTAL) > 0.01 then
                    fSomaNaBase  := fSomanaBase + (FNotaFiscal.Frete / FNotaFiscal.Mercadoria * oItem.TOTAL); // REGRA DE TRÊS ratiando o valor Total do Frete

                  //Frete Sobre IPI e IPI sobre ICMS
                  if (vFreteSobreIPI) and (vIPISobreICMS) then
                  begin
                    vlFreteRateadoItem := Arredonda((FNotaFiscal.Frete / fTotalMercadoria)
                                                     * oItem.TOTAL,2);

                    fSomaNaBase := fSomaNaBase + Arredonda2((vlFreteRateadoItem * ( oItem.IPI / 100 )),2);
                  end;
                end;

                if FNotaFiscal.Seguro   <> 0 then
                  if (FNotaFiscal.Seguro / FNotaFiscal.Mercadoria * oItem.TOTAL) > 0.01 then
                    fSomaNaBase  := fSomanaBase + (FNotaFiscal.Seguro / FNotaFiscal.Mercadoria * oItem.TOTAL); // REGRA DE TRÊS ratiando valor do Seguro

                // Soma na base de calculo
                if (Form7.ibDataSet14SOBREOUTRAS.AsString = 'S') then
                begin
                  if FNotaFiscal.Despesas <> 0 then
                    if (FNotaFiscal.Despesas / FNotaFiscal.Mercadoria * oItem.TOTAL) > 0.01 then
                      fSomaNaBase  := fSomanaBase + (FNotaFiscal.Despesas / FNotaFiscal.MERCADORIA * oItem.TOTAL); // REGRA DE TRÊS ratiando o valor de outras
                end;

                if FNotaFiscal.Desconto <> 0 then
                  if (FNotaFiscal.Desconto / FNotaFiscal.Mercadoria * oItem.TOTAL) > 0.01 then
                    fSomaNaBase  := fSomanaBase - (FNotaFiscal.Desconto / FNotaFiscal.Mercadoria * oItem.TOTAL); // REGRA DE TRÊS ratiando o valor do frete descontando

                FNotaFiscal.Baseicm := FNotaFiscal.Baseicm + Arredonda((oItem.BASE*fSomaNaBase/100),2);
                FNotaFiscal.Icms    := FNotaFiscal.Icms    + Arredonda(((oItem.BASE*fSomaNaBase/100) * oItem.ICM / 100 ),2); // Acumula em 16 After post
                oItem.Vicms        := oItem.Vicms + Arredonda(((oItem.BASE*fSomaNaBase/100) * oItem.ICM / 100 ),2);
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  Form7.ibDataSet4.Locate('REGISTRO',sReg4,[]);

  // Particularidades do calculo do total do ICMS
  try
    // Verifica se pode usar tributação interestadual
    if UpperCase(Copy(Form7.ibDataSet2IE.AsString,1,2)) = 'PR' then // Quando é produtor rural não precisa ter CGC
    begin
      sEstado := Form7.ibDataSet2ESTADO.AsString;
      if AllTrim(Form7.ibDataSet2CGC.AsString) = '' then sEstado := UpperCase(Form7.ibDataSet13ESTADO.AsString); // Quando é produtor rural tem que ter CPF
    end else
    begin
      if AllTrim((Limpanumero(Form7.ibDataSet2IE.AsString))) <> '' then
        sEstado := Form7.ibDataSet2ESTADO.AsString
      else
        sEstado := UpperCase(Form7.ibDataSet13ESTADO.AsString);

      if not CpfCgc(LimpaNumero(Form7.ibDataSet2CGC.AsString)) then
        sEstado := UpperCase(Form7.ibDataSet13ESTADO.AsString);

      if Length(AllTrim(Form7.ibDataSet2CGC.AsString)) < 18 then
        sEstado := UpperCase(Form7.ibDataSet13ESTADO.AsString);
    end;

    sEstado := Form7.ibDataSet2ESTADO.AsString;

    if Pos('1'+sEstado+'2','1AC21AL21AM21AP21BA21CE21DF21ES21GO21MA21MG21MS21MT21PA21PB21PE21PI21PR21RJ21RN21RO21RR21RS21SC21SE21SP21TO21EX2') = 0 then
      sEstado := 'MG';
  except
  end;
end;

procedure TNotaFiscalEletronica.CalculaValores(DataSetNF, DataSetItens: TibDataSet);
begin
  if not Calculando then
  begin
    try
      Calculando := True;
      AtualizaValoresNota(DataSetNF, DataSetItens);

      //Calcula Impostos
      CalculaImpostos;

      //Calcula CST PIS COFINS
      CalculaCstPisCofins(DataSetNF, DataSetItens);

      AtualizaDataSetNota(DataSetNF,DataSetItens);
    finally
      Calculando := False;
    end;
  end;
end;

constructor TNotaFiscalEletronica.Create;
begin
  NotaFiscal := TVENDAS.Create;
end;


function TNotaFiscalEletronica.GetTotalMercadoria: Double;
var
  vAcumulado : Double;
  i : integer;
  vItens : TITENS001;
begin
  Result      := 0;
  vAcumulado  := 0;

  for i := 0 to FNotaFiscal.FItens.Count -1 do
  begin
    vItens := FNotaFiscal.FItens.GetItem(i);
    vAcumulado := vAcumulado + vItens.Total;
  end;

  Result := vAcumulado;
end;

procedure TNotaFiscalEletronica.LimpaItens;
var
  i : integer;
begin
  FreeAndNil(FNotaFiscal.FItens);
  FNotaFiscal.FItens := TITENS001List.Create;

  {for i := 0 to FNotaFiscal.FItens.Count -1 do
  begin
    FNotaFiscal.Itens[i].Destroy;
  end;}
end;

end.
