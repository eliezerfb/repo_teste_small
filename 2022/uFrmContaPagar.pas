unit uFrmContaPagar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit,
  uframeCampo;

type
  TFrmContaPagar = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    Label129: TLabel;
    edtDocumento: TSMALL_DBEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtHistorico: TSMALL_DBEdit;
    Label3: TLabel;
    Label4: TLabel;
    edtEmissao: TSMALL_DBEdit;
    Label5: TLabel;
    edtVencimento: TSMALL_DBEdit;
    Label6: TLabel;
    edtValor: TSMALL_DBEdit;
    Label7: TLabel;
    edtPago: TSMALL_DBEdit;
    Label8: TLabel;
    edtValorPago: TSMALL_DBEdit;
    Label9: TLabel;
    edtPortador: TSMALL_DBEdit;
    Label10: TLabel;
    edtNotaFiscal: TSMALL_DBEdit;
    btnReplicar: TBitBtn;
    fraPlanoContas: TfFrameCampo;
    fraFornecedor: TfFrameCampo;
    procedure DSCadastroDataChange(Sender: TObject; Field: TField);
    procedure lblNovoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnReplicarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
    procedure AtualizaObjComValorDoBanco;
  public
    { Public declarations }
  end;

var
  FrmContaPagar: TFrmContaPagar;

implementation

{$R *.dfm}

uses
  unit7
  , smallfunc_xe
  , uPermissaoUsuario
  , MAIS;

procedure TFrmContaPagar.btnReplicarClick(Sender: TObject);
var
  vCampo: array [1..7] of Variant; // Cria uma matriz com 6 elementos
begin
  if AllTrim(Form7.ibDataSet8DOCUMENTO.AsString) <> '' then
  begin
    if copy(Form7.ibDataSet8DOCUMENTO.AsString,Length(Trim(Form7.ibDataSet8DOCUMENTO.AsString)),1) = '9' then
      vCampo[1] := copy(Form7.ibDataSet8DOCUMENTO.AsString,1,Length(Trim(Form7.ibDataSet8DOCUMENTO.AsString))-1)+'A' else
       if copy(Form7.ibDataSet8DOCUMENTO.AsString,Length(Trim(Form7.ibDataSet8DOCUMENTO.AsString)),1) = 'Z' then
         vCampo[1] := copy(Form7.ibDataSet8DOCUMENTO.AsString,1,Length(Trim(Form7.ibDataSet8DOCUMENTO.AsString))-1)+'a'
            else vCampo[1] := copy(Form7.ibDataSet8DOCUMENTO.AsString,1,Length(Trim(Form7.ibDataSet8DOCUMENTO.AsString))-1)+ chr(Ord(Form7.ibDataSet8DOCUMENTO.AsString[Length(Trim(Form7.ibDataSet8DOCUMENTO.AsString))])+1); // documento


  end else
  begin
    vCampo[1] := 'A';
  end;

  vCampo[2] := Form7.ibDataSet8HISTORICO.AsString;                 // Histórico
  vCampo[3] := Form7.ibDataSet8VALOR_DUPL.AsFloat;                 // Valor
  vCampo[4] := Form7.ibDataSet8EMISSAO.AsDateTime;                 // Emissão
  vCampo[5] := SomaDias(Form7.ibDataSet8VENCIMENTO.AsDateTime,30); // Vencimento
  vCampo[6] := Form7.ibDataSet8NOME.AsString;                      // Nome do Cliente
  vCampo[7] := Form7.ibDataSet8CONTA.AsString;                     // Portador
  { Incrementa o mês no historico }
  if Pos('dezembro',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],'dezembro'  ,'janeiro') else
    if Pos('DEZEMBRO',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],'DEZEMBRO'  ,'JANEIRO') else
      if Pos(' DEZ ',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],' DEZ '  ,' JAN ') else
        if Pos(' DEZ.',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],' DEZ.'  ,' JAN.') else
          if Pos(' dez ',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],' dez '  ,' jan ') else
            if Pos(' dez.',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],' dez.'  ,' jan.') else
            begin
              vCampo[2] := strtran(vCampo[2],'novembro'  ,'dezembro');
              vCampo[2] := strtran(vCampo[2],'outubro'   ,'novembro');
              vCampo[2] := strtran(vCampo[2],'setembro'  ,'outubro');
              vCampo[2] := strtran(vCampo[2],'agosto'    ,'setembro');
              vCampo[2] := strtran(vCampo[2],'julho'     ,'agosto');
              vCampo[2] := strtran(vCampo[2],'junho'     ,'julho');
              vCampo[2] := strtran(vCampo[2],'maio'      ,'junho');
              vCampo[2] := strtran(vCampo[2],'abril'     ,'maio');
              vCampo[2] := strtran(vCampo[2],'março'     ,'abril');
              vCampo[2] := strtran(vCampo[2],'fevereiro' ,'março');
              vCampo[2] := strtran(vCampo[2],'janeiro'   ,'fevereiro');

              vCampo[2] := strtran(vCampo[2],'NOVEMBRO'  ,'DEZEMBRO');
              vCampo[2] := strtran(vCampo[2],'OUTUBRO'   ,'NOVEMBRO');
              vCampo[2] := strtran(vCampo[2],'SETEMBRO'  ,'OUTUBRO');
              vCampo[2] := strtran(vCampo[2],'AGOSTO'    ,'SETEMBRO');
              vCampo[2] := strtran(vCampo[2],'JULHO'     ,'AGOSTO');
              vCampo[2] := strtran(vCampo[2],'JUNHO'     ,'JULHO');
              vCampo[2] := strtran(vCampo[2],'MAIO'      ,'JUNHO');
              vCampo[2] := strtran(vCampo[2],'ABRIL'     ,'MAIO');
              vCampo[2] := strtran(vCampo[2],'MARÇO'     ,'ABRIL');
              vCampo[2] := strtran(vCampo[2],'FEVEREIRO' ,'MARÇO');
              vCampo[2] := strtran(vCampo[2],'JANEIRO'   ,'FEVEREIRO');

              vCampo[2] := strtran(vCampo[2],' NOV '  ,' DEZ ');
              vCampo[2] := strtran(vCampo[2],' OUT '  ,' NOV ');
              vCampo[2] := strtran(vCampo[2],' SET '  ,' OUT ');
              vCampo[2] := strtran(vCampo[2],' AGO '  ,' SET ');
              vCampo[2] := strtran(vCampo[2],' JUL '  ,' AGO ');
              vCampo[2] := strtran(vCampo[2],' JUN '  ,' JUL ');
              vCampo[2] := strtran(vCampo[2],' MAI '  ,' JUN ');
              vCampo[2] := strtran(vCampo[2],' ABR '  ,' MAI ');
              vCampo[2] := strtran(vCampo[2],' MAR '  ,' ABR ');
              vCampo[2] := strtran(vCampo[2],' FEV '  ,' MAR ');
              vCampo[2] := strtran(vCampo[2],' JAN '  ,' FEV ');

              vCampo[2] := strtran(vCampo[2],' NOV.'  ,' DEZ.');
              vCampo[2] := strtran(vCampo[2],' OUT.'  ,' NOV.');
              vCampo[2] := strtran(vCampo[2],' SET.'  ,' OUT.');
              vCampo[2] := strtran(vCampo[2],' AGO.'  ,' SET.');
              vCampo[2] := strtran(vCampo[2],' JUL.'  ,' AGO.');
              vCampo[2] := strtran(vCampo[2],' JUN.'  ,' JUL.');
              vCampo[2] := strtran(vCampo[2],' MAI.'  ,' JUN.');
              vCampo[2] := strtran(vCampo[2],' ABR.'  ,' MAI.');
              vCampo[2] := strtran(vCampo[2],' MAR.'  ,' ABR.');
              vCampo[2] := strtran(vCampo[2],' FEV.'  ,' MAR.');
              vCampo[2] := strtran(vCampo[2],' JAN.'  ,' FEV.');

              vCampo[2] := strtran(vCampo[2],' nov.'  ,' dez.');
              vCampo[2] := strtran(vCampo[2],' out.'  ,' nov.');
              vCampo[2] := strtran(vCampo[2],' set.'  ,' out.');
              vCampo[2] := strtran(vCampo[2],' ago.'  ,' set.');
              vCampo[2] := strtran(vCampo[2],' jul.'  ,' ago.');
              vCampo[2] := strtran(vCampo[2],' jun.'  ,' jul.');
              vCampo[2] := strtran(vCampo[2],' mai.'  ,' jun.');
              vCampo[2] := strtran(vCampo[2],' abr.'  ,' mai.');
              vCampo[2] := strtran(vCampo[2],' mar.'  ,' abr.');
              vCampo[2] := strtran(vCampo[2],' fev.'  ,' mar.');
              vCampo[2] := strtran(vCampo[2],' jan.'  ,' fev.');
            end;

  Form7.ibDataSet8.Append;                            // Registro Novo
  Form7.ibDataSet8DOCUMENTO.asString    := vCampo[1]; // documento
  Form7.ibDataSet8HISTORICO.AsString    := vCampo[2]; // Histórico
  Form7.ibDataSet8VALOR_DUPL.AsFloat    := vCampo[3]; // Valor
  Form7.ibDataSet8EMISSAO.AsDateTime    := vCampo[4]; // Emissão
  Form7.ibDataSet8VENCIMENTO.AsDAtetime := vCampo[5]; // Vencimento
  Form7.ibDataSet8NOME.AsString         := vCampo[6]; // Nome do Fornecedor
  Form7.ibDataSet8CONTA.AsString        := vCampo[7]; // Portador
  Form7.ibDataSet8.Post;

  if edtDocumento.CanFocus then
    edtDocumento.SetFocus;
end;

procedure TFrmContaPagar.DSCadastroDataChange(Sender: TObject; Field: TField);
begin
  inherited;

  if DSCadastro.DataSet.State in ([dsEdit, dsInsert]) then
    Exit;

  AtualizaObjComValorDoBanco;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmContaPagar.FormActivate(Sender: TObject);
begin
  inherited;
  AtualizaObjComValorDoBanco;
end;

procedure TFrmContaPagar.FormShow(Sender: TObject);
begin
  inherited;

  if edtDocumento.CanFocus then
    edtDocumento.SetFocus;
end;

function TFrmContaPagar.GetPaginaAjuda: string;
begin
  Result := 'cp.htm';
end;

procedure TFrmContaPagar.lblNovoClick(Sender: TObject);
begin
  inherited;

  AtualizaObjComValorDoBanco;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;

  try
    if edtDocumento.CanFocus then
      edtDocumento.SetFocus;
  except
  end;
end;

procedure TFrmContaPagar.SetaStatusUso;
begin
  inherited;

  bSomenteLeitura := SomenteLeitura(Form7.sModulo,MAIS.Usuario);

  edtDocumento.Enabled   := not(bEstaSendoUsado) and not (bSomenteLeitura);
  fraPlanoContas.Enabled := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtHistorico.Enabled   := not(bEstaSendoUsado) and not (bSomenteLeitura);
  fraFornecedor.Enabled  := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtEmissao.Enabled     := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtVencimento.Enabled  := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtValor.Enabled       := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtPago.Enabled        := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtValorPago.Enabled   := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtPortador.Enabled    := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtNotaFiscal.Enabled  := not(bEstaSendoUsado) and not (bSomenteLeitura);
  btnReplicar.Enabled    := not (bSomenteLeitura);
end;

procedure TFrmContaPagar.AtualizaObjComValorDoBanco;
begin
  //Se não estiver ativo não carrega informações
  if not FormularioAtivo(Self) then
    Exit;

  //Plano de Contas
  try
    fraPlanoContas.TipoDePesquisa               := tpLocate;
    fraPlanoContas.GravarSomenteTextoEncontrato := True;
    fraPlanoContas.CampoVazioAbrirGridPesquisa  := True;
    fraPlanoContas.CampoCodigo                  := Form7.ibDataSet8CONTA;
    fraPlanoContas.CampoCodigoPesquisa          := 'NOME';
    fraPlanoContas.sCampoDescricao              := 'NOME';
    fraPlanoContas.sTabela                      := 'CONTAS';
    fraPlanoContas.CampoAuxExiber               := ',CONTA';
    fraPlanoContas.CarregaDescricao;
  except
  end;

  //Fornecedor
  try
    fraFornecedor.TipoDePesquisa                := tpSelect;
    fraFornecedor.GravarSomenteTextoEncontrato  := True;
    fraFornecedor.CampoVazioAbrirGridPesquisa   := True;
    fraFornecedor.CampoCodigo                   := Form7.ibDataSet8NOME;
    fraFornecedor.CampoCodigoPesquisa           := 'NOME';
    fraFornecedor.sCampoDescricao               := 'NOME';
    fraFornecedor.sTabela                       := 'CLIFOR';
    fraFornecedor.sFiltro                       := ' and coalesce(ATIVO,0)=0 ';
    fraFornecedor.CarregaDescricao;
  except
  end;
end;

end.
