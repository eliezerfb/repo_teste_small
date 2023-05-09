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
    FVBCFCP: Double;
    FPFCPST: Double;
    FVFCPST: Double;
    FPFCP: Double;
    FVFCP: Double;
    FVBCFCPST: Double;
    procedure SetFVFCP(const Value: Double);
    procedure SetFVFCPST(const Value: Double);
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
    property VBCFCP: Double read FVBCFCP write FVBCFCP;
    property PFCP: Double read FPFCP write FPFCP;
    property VFCP: Double read FVFCP write SetFVFCP;
    property VBCFCPST: Double read FVBCFCPST write FVBCFCPST;
    property PFCPST: Double read FPFCPST write FPFCPST;
    property VFCPST: Double read FVFCPST write SetFVFCPST;
  end;

  TITENS001List = class(TObjectList)
    private
      procedure SetItem(Index: Integer; const Value: TITENS001);
    public
      function GetItem(Index: Integer): TITENS001;
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
    FVFCPST: Double;
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
    property VFCPST: Double read FVFCPST write FVFCPST;
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
  protected
    FNotaFiscal: TVENDAS;
    function GetTotalMercadoria: Double;
    procedure AtualizaValoresNota(DataSetNF, DataSetItens: TibDataSet);
    procedure AtualizaValoresItens(DataSetItens: TibDataSet);
    procedure AtualizaDataSetNota(DataSetNF, DataSetItens: TibDataSet);
    procedure AtualizaDataSetItens(DataSetItens: TibDataSet);
  public
    constructor Create; virtual;
    procedure LimpaItens;
    property NotaFiscal: TVENDAS read FNotaFiscal write FNotaFiscal;
  end;

implementation

uses Mais;

{ TITENS001List }

function TITENS001List.Adiciona(DataSetItens: TibDataSet): TITENS001;
begin
  if DataSetItens.FieldByName('QUANTIDADE').AsFloat <= 0 then
    Exit;

  Result := TITENS001.Create;

  Result.Numeronf                 := DataSetItens.FieldByName('NUMERONF').AsString;
  Result.Codigo                   := DataSetItens.FieldByName('CODIGO').AsString;
  Result.Descricao                := DataSetItens.FieldByName('DESCRICAO').AsString;
  Result.St                       := DataSetItens.FieldByName('ST').AsString;
  Result.Ipi                      := DataSetItens.FieldByName('IPI').AsFloat;
  Result.Icm                      := DataSetItens.FieldByName('ICM').AsFloat;
  Result.Iss                      := DataSetItens.FieldByName('ISS').AsFloat;
  Result.Medida                   := DataSetItens.FieldByName('MEDIDA').AsString;
  Result.Quantidade               := DataSetItens.FieldByName('QUANTIDADE').AsFloat;
  Result.Sincronia                := DataSetItens.FieldByName('SINCRONIA').AsFloat;
  Result.Unitario                 := DataSetItens.FieldByName('UNITARIO').AsFloat;
  Result.Total                    := DataSetItens.FieldByName('TOTAL').AsFloat;
  Result.Lista                    := DataSetItens.FieldByName('LISTA').AsFloat;
  Result.Custo                    := DataSetItens.FieldByName('CUSTO').AsFloat;
  Result.Peso                     := DataSetItens.FieldByName('PESO').AsFloat;
  Result.Base                     := DataSetItens.FieldByName('BASE').AsFloat;
  Result.Baseiss                  := DataSetItens.FieldByName('BASEISS').AsFloat;
  Result.Aliquota                 := DataSetItens.FieldByName('ALIQUOTA').AsFloat;
  Result.Cfop                     := DataSetItens.FieldByName('CFOP').AsString;
  Result.Numeroos                 := DataSetItens.FieldByName('NUMEROOS').AsString;
  Result.Registro                 := DataSetItens.FieldByName('REGISTRO').AsString;
  Result.Vicms                    := DataSetItens.FieldByName('VICMS').AsFloat;
  Result.Vbc                      := DataSetItens.FieldByName('VBC').AsFloat;
  Result.Vbcst                    := DataSetItens.FieldByName('VBCST').AsFloat;
  Result.Vicmsst                  := DataSetItens.FieldByName('VICMSST').AsFloat;
  Result.Vipi                     := DataSetItens.FieldByName('VIPI').AsFloat;
  Result.Cst_pis_cofins           := DataSetItens.FieldByName('CST_PIS_COFINS').AsString;
  Result.Aliq_pis                 := DataSetItens.FieldByName('ALIQ_PIS').AsFloat;
  Result.Aliq_cofins              := DataSetItens.FieldByName('ALIQ_COFINS').AsFloat;
  Result.Cst_ipi                  := DataSetItens.FieldByName('CST_IPI').AsString;
  Result.Cst_icms                 := DataSetItens.FieldByName('CST_ICMS').AsString;
  Result.Xped                     := DataSetItens.FieldByName('XPED').AsString;
  Result.Nitemped                 := DataSetItens.FieldByName('NITEMPED').AsString;
  Result.Anvisa                   := DataSetItens.FieldByName('ANVISA').AsInteger;
  Result.Pfcpufdest               := DataSetItens.FieldByName('PFCPUFDEST').AsFloat;
  Result.Picmsufdest              := DataSetItens.FieldByName('PICMSUFDEST').AsFloat;
  Result.Encrypthash              := DataSetItens.FieldByName('ENCRYPTHASH').AsString;
  Result.Csosn                    := DataSetItens.FieldByName('CSOSN').AsString;
  Result.Vbc_pis_cofins           := DataSetItens.FieldByName('VBC_PIS_COFINS').AsFloat;
  Result.Identificadorplanocontas := DataSetItens.FieldByName('IDENTIFICADORPLANOCONTAS').AsString;
  Result.VBCFCP                   := DataSetItens.FieldByName('VBCFCP').AsFloat;
  Result.PFCP                     := DataSetItens.FieldByName('PFCP').AsFloat;
  Result.VFCP                     := DataSetItens.FieldByName('VFCP').AsFloat;
  Result.VBCFCPST                 := DataSetItens.FieldByName('VBCFCPST').AsFloat;
  Result.PFCPST                   := DataSetItens.FieldByName('PFCPST').AsFloat;
  Result.VFCPST                   := DataSetItens.FieldByName('VFCPST').AsFloat;

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
  i: integer;
  oItem: TITENS001;
  bEstadoFlag: Boolean;
begin
  try
    DataSetItens.DisableControls;

    bEstadoFlag := Form1.bFlagControlaLancamentoProduto; // Sandro Silva 2023-05-08

    for i := 0 to FNotaFiscal.FItens.Count -1 do
    begin
      oItem := FNotaFiscal.FItens.GetItem(i);

      if DataSetItens.Locate('REGISTRO', oItem.Registro, []) then
      begin
        DataSetItens.Edit;

        Form1.bFlagControlaLancamentoProduto := False; // Sandro Silva 2023-05-08

        //DataSetItens.FieldByName('NUMERONF').AsString       := oItem.Numeronf;
        //DataSetItens.FieldByName('CODIGO').AsString         := oItem.Codigo;
        //DataSetItens.FieldByName('DESCRICAO').AsString      := oItem.Descricao;
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
        //DataSetItens.FieldByName('NUMEROOS').AsString       := oItem.Numeroos;
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
        //DataSetItens.FieldByName('XPED').AsString           := oItem.Xped;
        DataSetItens.FieldByName('NITEMPED').AsString       := oItem.Nitemped;
        //DataSetItens.FieldByName('ANVISA').AsInteger        := oItem.Anvisa;
        DataSetItens.FieldByName('PFCPUFDEST').AsFloat      := oItem.Pfcpufdest;
        DataSetItens.FieldByName('PICMSUFDEST').AsFloat     := oItem.Picmsufdest;
        //DataSetItens.FieldByName('ENCRYPTHASH').AsString    := oItem.Encrypthash;
        DataSetItens.FieldByName('CSOSN').AsString          := oItem.Csosn;
        DataSetItens.FieldByName('VBC_PIS_COFINS').AsFloat  := oItem.Vbc_pis_cofins;
        //DataSetItens.FieldByName('IDENTIFICADORPLANOCONTAS').AsString := oItem.Identificadorplanocontas;

        DataSetItens.FieldByName('VBCFCP').AsFloat          := oItem.VBCFCP;
        DataSetItens.FieldByName('PFCP').AsFloat            := oItem.PFCP;
        DataSetItens.FieldByName('VFCP').AsFloat            := oItem.VFCP;
        DataSetItens.FieldByName('VBCFCPST').AsFloat        := oItem.VBCFCPST;
        DataSetItens.FieldByName('PFCPST').AsFloat          := oItem.PFCPST;
        DataSetItens.FieldByName('VFCPST').AsFloat          := oItem.VFCPST;

        DataSetItens.Post;
        Form1.bFlagControlaLancamentoProduto := bEstadoFlag; // Sandro Silva 2023-05-08
      end;
    end;
  finally
    Form1.bFlagControlaLancamentoProduto := bEstadoFlag; // Sandro Silva 2023-05-08
    DataSetItens.EnableControls;
  end
end;

procedure TNotaFiscalEletronica.AtualizaDataSetNota(DataSetNF,DataSetItens : TibDataSet);
begin
  //DataSetNF.FieldByName('NUMERONF').AsString        := FNotaFiscal.Numeronf;
  //DataSetNF.FieldByName('MODELO').AsString          := FNotaFiscal.Modelo;
  DataSetNF.FieldByName('VENDEDOR').AsString        := FNotaFiscal.Vendedor;
  DataSetNF.FieldByName('CLIENTE').AsString         := FNotaFiscal.Cliente;
  DataSetNF.FieldByName('OPERACAO').AsString        := FNotaFiscal.Operacao;
  DataSetNF.FieldByName('EMISSAO').AsDateTime       := FNotaFiscal.Emissao;
  DataSetNF.FieldByName('FRETE').AsFloat            := FNotaFiscal.Frete;
  DataSetNF.FieldByName('SEGURO').AsFloat           := FNotaFiscal.Seguro;
  DataSetNF.FieldByName('DESPESAS').AsFloat         := FNotaFiscal.Despesas;
  DataSetNF.FieldByName('DESCONTO').AsFloat         := FNotaFiscal.Desconto;
  DataSetNF.FieldByName('VFCPST').AsFloat           := FNotaFiscal.VFCPST;  
  //DataSetNF.FieldByName('VOLUMES').AsFloat          := FNotaFiscal.Volumes;
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
  FNotaFiscal.VFCPST          := DataSetNF.FieldByName('VFCPST').AsFloat;  
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


{ TITENS001 }

procedure TITENS001.SetFVFCP(const Value: Double);
begin
  FVFCP := Value;

  // Zera campos de FCP ST
  FVBCFCPST := 0.00;
  FPFCPST   := 0.00;
  FVFCPST   := 0.00;
end;

procedure TITENS001.SetFVFCPST(const Value: Double);
begin
  FVFCPST := Value;

  // Zera campos de FCP
  FVBCFCP := 0.00;
  FPFCP   := 0.00;
  FVFCP   := 0.00;
end;

end.
