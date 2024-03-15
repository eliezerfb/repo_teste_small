unit Unit8;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SmallFunc_xe, Grids, Buttons, DB, IBCustomDataSet,
  IBQuery
  , uajustaresolucao;

const QUANTIDADE_COLUNAS = 7; // Sandro Silva 2022-02-04 const QUANTIDADE_COLUNAS = 6;
const COLUNA_CHECK                = 0;
const COLUNA_ITEM                 = 1;
const COLUNA_PRODUTO              = 2;
const COLUNA_QUANTIDADE           = 3;
const COLUNA_QUANTIDADE_TRANSFERE = 4;
const COLUNA_VALOR_TOTAL          = 5; // Sandro Silva 2022-02-04 const COLUNA_VALOR_TOTAL    = 4;
const COLUNA_REGISTRO             = 6; // Sandro Silva 2022-02-04 const COLUNA_REGISTRO = 5; // Sandro Silva 2019-09-03 ER 02.06 UnoChapeco
const MARCADO    = 'X';
const DESMARCADO = '';

procedure AlinhaTextoDireitaStringgrid(Canvas: TCanvas; Rect: TRect;
  Text: string);

type
  TForm8 = class(TForm)
    Button1: TBitBtn;
    Button2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    cbMesaOrigem: TComboBox;
    cbMesaDestino: TComboBox;
    GridOrigem: TStringGrid;
    CheckTodosOrigem: TCheckBox;
    lbTotalTransferencia: TLabel;
    IBQuery1: TIBQuery;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbMesaOrigemExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GridOrigemDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure GridOrigemKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckTodosOrigemClick(Sender: TObject);
    procedure GridOrigemKeyPress(Sender: TObject; var Key: Char);
    procedure GridOrigemMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure cbMesaOrigemChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure GridOrigemSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure GridOrigemSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
  private
    { Private declarations }
    iAlturaLinha: Integer;
    iLinhaAtual: Integer;
    iColunaAtual: Integer;
    procedure gridMesaDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure MarcaItem(Sender: TObject);
    procedure SelecionaProdutosDaMesa(sMesa: String);
    procedure MarcaDesmarcaTodos(Sender: TObject; bMarcar: Boolean);
    procedure TotalMarcado;
  public
    { Public declarations }
    procedure SelecionaMesas(sMesaOrigem, sMesaDestino: String);
  end;

var
  Form8: TForm8;

implementation

uses fiscal, ufuncoesfrente, urequisitospafnfce;

{$R *.dfm}

procedure AlinhaTextoDireitaStringgrid(Canvas: TCanvas; Rect: TRect;
  Text: string);
var
  nLeft: integer;
begin
  nLeft := Rect.Left + (Rect.Right - Rect.Left) - (Canvas.TextWidth(Text)) - 2;
  if nLeft < Rect.Left then nLeft := Rect.Left;
    Canvas.TextRect( Rect, nLeft, Rect.Top + 2, Text );
end;

procedure TForm8.Button2Click(Sender: TObject);
var
  iItem : Integer;
  iLinha: Integer;
  iCampo: Integer;
  bMarcado: Boolean;
  sCaixaConferencia: String; // Sandro Silva 2019-09-02 ER 02.06 UnoChapeco
  sCCFConferencia: String; // Sandro Silva 2019-09-02 ER 02.06 UnoChapeco
  sCOOConferencia: String; // Sandro Silva 2019-09-02 ER 02.06 UnoChapeco
  sSequencialContaOS: String; // Sandro Silva 2019-09-20 ER 02.06 UnoChapeco
  IBQITENS: TIBQuery;
begin
  //
  // Sandro Silva 2011-08-31
  //
  if (StrToIntDef(cbMesaDestino.Text, 0) <= 0) then
  begin
    ShowMessage(Form1.sMesaOuConta + ' destino inválida');
    cbMesaDestino.SetFocus;
    Exit;
  end;
  //
  if ((StrToIntDef(cbMesaOrigem.Text, 0) <= 0) or (StrToIntDef(cbMesaOrigem.Text, 0) > StrToInt(Form1.sMesas)))
   or
     ((StrToIntDef(cbMesaDestino.Text, 0) <= 0) or (StrToIntDef(cbMesaDestino.Text, 0) > StrToInt(Form1.sMesas))) then
  begin
    ShowMessage(Form1.sMesaOuConta + ' inválida');
    Exit;
  end;
  //
  if cbMesaOrigem.Text = cbMesaDestino.Text then
  begin
    ShowMessage(Form1.sMesasOuContas + ' devem ser diferentes');
    Exit;
  end;
  //
  // Verifica se existe algum item marcado para transferência
  //
  bMarcado := False;
  for iLinha := 1 to GridOrigem.RowCount - 1 do
  begin
    if GridOrigem.Cells[COLUNA_CHECK, iLinha] = MARCADO then
    begin
      bMarcado := True;
      Break;
    end;
  end;
  //
  if bMarcado = False then
  begin
    ShowMessage('Nenhum item marcado para transferir');
    Exit;
  end;

  begin
    CommitaTudo(True); // Transferência de mesas

    IBQITENS := CriaIBQuery(Form1.ibDataSet27.Transaction);

    // Verifica se mesa destino teve conferencia de mesa impressa
    IBQITENS.Close;
    IBQITENS.SQL.Clear;
    IBQITENS.SQL.Text :=
      'select * ' +
      'from ALTERACA ' +
      'where (TIPO=''MESA'' or TIPO=''DEKOL'') '+
      ' and PEDIDO='+QuotedStr(FormataNumeroDoCupom(StrToInt(cbMesaDestino.Text))); // Sandro Silva 2021-12-01 ' and PEDIDO='+QuotedStr(StrZero(StrToInt(cbMesaDestino.Text),6,0));
    IBQITENS.Open;

    sCaixaConferencia  := IBQITENS.FieldByName('CAIXA').AsString;
    sCCFConferencia    := IBQITENS.FieldByName('CCF').AsString;
    sCOOConferencia    := IBQITENS.FieldByName('COO').AsString;
    sSequencialContaOS := IBQITENS.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString; // Sandro Silva 2019-09-20 ER 02.06 UnoChapeco

    //
    // Passa por todos itens do grid e transfere os marcados
    //
    for iLinha := 1 to GridOrigem.RowCount - 1 do
    begin
      if GridOrigem.Cells[COLUNA_CHECK, iLinha] = MARCADO then
      begin
        // Usa dataset para assinar registros
        Form1.ibDataSet27.Close;
        Form1.ibDataSet27.SelectSQL.Clear;
        Form1.ibDataSet27.SelectSQL.Text :=
          'select * ' +
          'from ALTERACA ' +
          ' where (TIPO=''MESA'' or TIPO=''DEKOL'') '+
          ' and REGISTRO = ' + QuotedStr(GridOrigem.Cells[COLUNA_REGISTRO, iLinha]);
        Form1.ibDataSet27.Open;

        {Sandro Silva 2022-02-04 inicio
        try
          Form1.ibDataSet27.Edit;
          Form1.ibDataSet27.FieldByName('PEDIDO').AsString := FormataNumeroDoCupom(StrToInt(cbMesaDestino.Text)); // Sandro Silva 2021-12-01 Form1.ibDataSet27.FieldByName('PEDIDO').AsString := StrZero(StrToInt(cbMesaDestino.Text),6,0);
          Form1.ibDataSet27.FieldByName('DAV').AsString    := FormataNumeroDoCupom(StrToInt(cbMesaOrigem.Text)); // Sandro Silva 2021-12-01 Form1.ibDataSet27.FieldByName('DAV').AsString    := StrZero(StrToInt(cbMesaOrigem.Text),6,0);
          Form1.ibDataSet27.FieldByName('CAIXA').AsString  := sCaixaConferencia;
          if Form1.ibDataSet27.FieldByName('CAIXA').AsString = '' then
            Form1.ibDataSet27.FieldByName('CAIXA').Clear;
          Form1.ibDataSet27.FieldByName('CCF').AsString   := sCCFConferencia;
          if Form1.ibDataSet27.FieldByName('CCF').AsString = '' then
            Form1.ibDataSet27.FieldByName('CCF').Clear;
          Form1.ibDataSet27.FieldByName('COO').AsString   := sCOOConferencia;
          if Form1.ibDataSet27.FieldByName('COO').AsString = '' then
            Form1.ibDataSet27.FieldByName('COO').Clear;
          Form1.ibDataSet27.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString := sSequencialContaOS;
          if Form1.ibDataSet27.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString = '' then
            Form1.ibDataSet27.FieldByName('SEQUENCIALCONTACLIENTEOS').Clear;
          Form1.ibDataSet27.Post;
        except

        end;
        }
        try
          if StrToFloat(GridOrigem.Cells[COLUNA_QUANTIDADE, iLinha]) = StrToFloat(GridOrigem.Cells[COLUNA_QUANTIDADE_TRANSFERE, iLinha]) then
          begin

            //Transferindo a quantidade total lançada para o item

            Form1.ibDataSet27.Edit;
            Form1.ibDataSet27.FieldByName('PEDIDO').AsString                   := FormataNumeroDoCupom(StrToInt(cbMesaDestino.Text)); // Sandro Silva 2021-12-01 Form1.ibDataSet27.FieldByName('PEDIDO').AsString := StrZero(StrToInt(cbMesaDestino.Text),6,0);
            Form1.ibDataSet27.FieldByName('DAV').AsString                      := FormataNumeroDoCupom(StrToInt(cbMesaOrigem.Text)); // Sandro Silva 2021-12-01 Form1.ibDataSet27.FieldByName('DAV').AsString    := StrZero(StrToInt(cbMesaOrigem.Text),6,0);
            Form1.ibDataSet27.FieldByName('CAIXA').AsString                    := sCaixaConferencia;
            if Form1.ibDataSet27.FieldByName('CAIXA').AsString = '' then
              Form1.ibDataSet27.FieldByName('CAIXA').Clear;
            Form1.ibDataSet27.FieldByName('CCF').AsString                      := sCCFConferencia;
            if Form1.ibDataSet27.FieldByName('CCF').AsString = '' then
              Form1.ibDataSet27.FieldByName('CCF').Clear;
            Form1.ibDataSet27.FieldByName('COO').AsString                      := sCOOConferencia;
            if Form1.ibDataSet27.FieldByName('COO').AsString = '' then
              Form1.ibDataSet27.FieldByName('COO').Clear;
            Form1.ibDataSet27.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString := sSequencialContaOS;
            if Form1.ibDataSet27.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString = '' then
              Form1.ibDataSet27.FieldByName('SEQUENCIALCONTACLIENTEOS').Clear;
            Form1.ibDataSet27.Post;
          end
          else
          begin

            // Transferindo parte da quantidade do item

            // Valida se a diferença entre quantidades é maior que zero
            if StrToFloat(GridOrigem.Cells[COLUNA_QUANTIDADE_TRANSFERE, iLinha]) > 0 then
            begin

              //Seleciona o item que será transferido parte da quantidade
              IBQITENS.Close;
              IBQITENS.SQL.Clear;
              IBQITENS.SQL.Text :=
                'select * ' +
                'from ALTERACA ' +
                'where PEDIDO='+QuotedStr(FormataNumeroDoCupom(StrToInt(cbMesaOrigem.Text))) + // Sandro Silva 2021-12-01 'where PEDIDO='+QuotedStr(StrZero(StrToInt(cbMesaOrigem.Text),6,0)) +
                ' and (TIPO=''MESA'' or TIPO=''DEKOL'')' +
                ' and ITEM = ' + QuotedStr(FormatFloat('000000', StrToInt(GridOrigem.Cells[COLUNA_ITEM, iLinha])));
              IBQITENS.Open;

              if IBQITENS.FieldByName('CODIGO').AsString <> '' then // Se encontrou o item
              begin

                //Primeiro mantem na mesa atual a parte da quantidade não transferida
                Form1.ibDataSet27.Edit;
                Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat                := StrToFloat(GridOrigem.Cells[COLUNA_QUANTIDADE, iLinha]) - StrToFloat(GridOrigem.Cells[COLUNA_QUANTIDADE_TRANSFERE, iLinha]);
                Form1.ibDataSet27.FieldByName('TOTAL').AsFloat                     := StrToFloat(FormatFloat('0.00', Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat * Form1.ibDataSet27.FieldByName('UNITARIO').AsFloat));
                Form1.ibDataSet27.FieldByName('PEDIDO').AsString                   := FormataNumeroDoCupom(StrToInt(cbMesaOrigem.Text)); // Sandro Silva 2021-12-01 Form1.ibDataSet27.FieldByName('PEDIDO').AsString := StrZero(StrToInt(cbMesaDestino.Text),6,0);
                Form1.ibDataSet27.FieldByName('CCF').AsString                      := sCCFConferencia;
                if Form1.ibDataSet27.FieldByName('CCF').AsString = '' then
                  Form1.ibDataSet27.FieldByName('CCF').Clear;
                Form1.ibDataSet27.FieldByName('COO').AsString                      := sCOOConferencia;
                if Form1.ibDataSet27.FieldByName('COO').AsString = '' then
                  Form1.ibDataSet27.FieldByName('COO').Clear;
                Form1.ibDataSet27.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString := sSequencialContaOS;
                if Form1.ibDataSet27.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString = '' then
                  Form1.ibDataSet27.FieldByName('SEQUENCIALCONTACLIENTEOS').Clear;
                Form1.ibDataSet27.Post;

                // Inclui na mesa destino a parte da quantidade transferida
                Form1.ibDataSet27.Close;
                Form1.ibDataSet27.SelectSQL.Clear;
                Form1.ibDataSet27.SelectSQL.Text :=
                  'select * ' +
                  'from ALTERACA ' +
                  ' where (TIPO=''MESA'' or TIPO=''DEKOL'') ' +
                  ' and PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(StrToInt(cbMesaDestino.Text)));
                Form1.ibDataSet27.Open;

                Form1.ibDataSet27.Append;

                for iCampo := 0 to IBQITENS.FieldDefs.Count -1 do
                begin
                  if AnsiUpperCase(IBQITENS.Fields[iCampo].FieldName) <> 'REGISTRO' then
                  begin
                    Form1.ibDataSet27.FieldByName(IBQITENS.Fields[iCampo].FieldName).Value := IBQITENS.Fields[iCampo].Value;
                  end;
                end;

                Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat                := StrToFloat(GridOrigem.Cells[COLUNA_QUANTIDADE_TRANSFERE, iLinha]);
                Form1.ibDataSet27.FieldByName('TOTAL').AsFloat                     := StrToFloat(FormatFloat('0.00', Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat * Form1.ibDataSet27.FieldByName('UNITARIO').AsFloat));
                Form1.ibDataSet27.FieldByName('PEDIDO').AsString                   := FormataNumeroDoCupom(StrToInt(cbMesaDestino.Text)); // Sandro Silva 2021-12-01 Form1.ibDataSet27.FieldByName('PEDIDO').AsString := StrZero(StrToInt(cbMesaDestino.Text),6,0);
                Form1.ibDataSet27.FieldByName('DAV').AsString                      := FormataNumeroDoCupom(StrToInt(cbMesaOrigem.Text)); // Sandro Silva 2021-12-01 Form1.ibDataSet27.FieldByName('DAV').AsString    := StrZero(StrToInt(cbMesaOrigem.Text),6,0);
                Form1.ibDataSet27.FieldByName('CAIXA').AsString                    := sCaixaConferencia;
                if Form1.ibDataSet27.FieldByName('CAIXA').AsString = '' then
                  Form1.ibDataSet27.FieldByName('CAIXA').Clear;
                Form1.ibDataSet27.FieldByName('CCF').AsString                      := sCCFConferencia;
                if Form1.ibDataSet27.FieldByName('CCF').AsString = '' then
                  Form1.ibDataSet27.FieldByName('CCF').Clear;
                Form1.ibDataSet27.FieldByName('COO').AsString                      := sCOOConferencia;
                if Form1.ibDataSet27.FieldByName('COO').AsString = '' then
                  Form1.ibDataSet27.FieldByName('COO').Clear;
                Form1.ibDataSet27.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString := sSequencialContaOS;
                if Form1.ibDataSet27.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString = '' then
                  Form1.ibDataSet27.FieldByName('SEQUENCIALCONTACLIENTEOS').Clear;
                Form1.ibDataSet27.Post;

              end; // if IBQITENS.FieldByName('CODIGO').AsString <> '' then // Se encontrou o item

            end; // if (StrToFloat(GridOrigem.Cells[COLUNA_QUANTIDADE, iLinha]) - StrToFloat(GridOrigem.Cells[COLUNA_QUANTIDADE_TRANSFERE, iLinha])) > 0 then

          end;
          
        except

        end;
        {Sandro Silva 2022-02-04 fim}
      end;
    end;
    //
    IBQITENS.Close;
    IBQITENS.SQL.Clear;
    //
    // Seleciona apenas os campos usados (REGISTRO)
    //
    IBQITENS.SQL.Text :=
      'select REGISTRO ' +
      'from ALTERACA ' +
      'where PEDIDO='+QuotedStr(FormataNumeroDoCupom(StrToInt(cbMesaOrigem.Text))) + // Sandro Silva 2021-12-01 'where PEDIDO='+QuotedStr(StrZero(StrToInt(cbMesaOrigem.Text),6,0)) +
      ' and (TIPO=''MESA'' or TIPO=''DEKOL'')' +
      ' order by REGISTRO';
    IBQITENS.Open;
    //
    iItem := 0;
    //
    // Ordena os items da mesa Origem
    //
    IBQITENS.First;
    while not IBQITENS.Eof do
    begin
      //
      iItem := iItem + 1;
      //
      try
        // Usa dataset para assinar registros
        Form1.ibDataSet27.Close;
        Form1.ibDataSet27.SelectSQL.Clear;
        // Não limpar o campos CAIXA, CCF e COO porque elimina identificação se caso tenha ocorrido impressão de conferência de mesa
        Form1.ibDataSet27.SelectSQL.Text :=
          'select * ' +
          'from ALTERACA ' +
          ' where REGISTRO = ' + QuotedStr(IBQITENS.FieldByname('REGISTRO').AsString) + ' ';
        Form1.ibDataSet27.Open;

        Form1.ibDataSet27.Edit;
        Form1.ibDataSet27.FieldByName('ITEM').AsString := StrZero(iItem, 6, 0);
        Form1.ibDataSet27.Post;
      except

      end;

      //
      IBQITENS.Next;
      //
    end;
    //
    IBQITENS.Close;
    IBQITENS.SQL.Text :=
      'select REGISTRO  ' +
      'from ALTERACA ' +
      'where PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(StrToInt(cbMesaDestino.Text))) + // Sandro Silva 2021-12-02 'where PEDIDO = ' + QuotedStr(StrZero(StrToInt(cbMesaDestino.Text), 6, 0)) +
      ' and (TIPO = ''MESA'' or TIPO = ''DEKOL'')' +
      ' order by REGISTRO';
    IBQITENS.Open;
    //
    iItem := 0;
    //
    // Ordena os items da mesa Destino
    //
    IBQITENS.First;
    while not IBQITENS.Eof do
    begin
      //
      iItem := iItem + 1;
      //
      try
        // Usa dataset para assinar registros
        Form1.ibDataSet27.Close;
        Form1.ibDataSet27.SelectSQL.Clear;
        Form1.ibDataSet27.SelectSQL.Text :=
        'select * ' +
        'from ALTERACA ' +
        ' where REGISTRO = ' + QuotedStr(IBQITENS.FieldByname('REGISTRO').AsString) + ' '; // Sandro Silva 2016-03-07 POLIMIG
        Form1.ibDataSet27.Open;

        Form1.ibDataSet27.Edit;
        Form1.ibDataSet27.FieldByName('ITEM').AsString := StrZero(iItem,6,0);
        Form1.ibDataSet27.Post;
      except

      end;
      //
      IBQITENS.Next;
      //
    end;

    Commitatudo(True); // Sandro Silva 2016-02-26 Form8.Button2Click(
    Commitatudo2(True); // Sandro Silva 2016-02-26 Form8.Button2Click(

    FreeAndNil(IBQITENS);
    //
    Close;
    //
  end;
  //*)
  //
end;

procedure TForm8.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm8.SelecionaMesas(sMesaOrigem, sMesaDestino: String);
{Sandro Silva 2011-08-30 inicio
Seleciona as mesas que são listadas nos combos}
var
  iMesa: Integer;
  sModeloECFOld: String;
begin
  CheckTodosOrigem.Checked  := False;

  gridOrigem.RowCount := 2;

  //Limpa os combos
  cbMesaOrigem.Clear;
  cbMesaDestino.Clear;
  cbMesaOrigem.Enabled := True;

  //Preenche combo destino com o número de mesas configurados
  for iMesa := 1 to StrToIntDef(Form1.sMesas, 1) do
    cbMesaDestino.Items.Add(FormatFloat('000', iMesa));

  if (sMesaOrigem <> '') and (sMesaDestino <> '') and Consumo then
  begin

    if Consumo then //2015-09-12
    begin
      cbMesaOrigem.Enabled := False;
      cbMesaOrigem.Items.Add(FormatFloat('000', StrToInt(sMesaOrigem)));
    end;
  end
  else
  begin // Transfêrencia através do menu F10
    if Consumo = False then //2015-09-12
    begin
      //Seleciona as mesas com itens lançados que podem ser transferidos
      Form1.IBQuery1.Close;
      Form1.IBQuery1.SQL.Text :=
        'select distinct PEDIDO as MESA ' +
        'from ALTERACA ' +
        'where (TIPO = ''MESA'' or TIPO = ''DEKOL'')';
      Form1.IBQuery1.Open;

      while Form1.IBQuery1.Eof = False do
      begin
        cbMesaOrigem.Items.Add(FormatFloat('000', Form1.IBQuery1.FieldByName('MESA').AsInteger));
        Form1.IBQuery1.Next;
      end;

      if cbMesaOrigem.Items.Count < 1 then
      begin
        cbMesaOrigem.Enabled := False;
      end;
    end
    else
    begin
      cbMesaOrigem.Items.Add(FormatFloat('000', StrToInt(sMesaOrigem)));
      cbMesaOrigem.Enabled := False;
    end;
  end; // if (sMesaOrigem <> '') and (sMesaDestino <> '') then

  cbMesaOrigem.ItemIndex  := cbMesaOrigem.Items.IndexOf(FormatFloat('000', StrToInt(sMesaOrigem))); // 2015-09-14
  SelecionaProdutosDaMesa(cbMesaOrigem.Text); // 2015-09-14
  if Trim(sMesaDestino) = '' then
    cbMesaDestino.ItemIndex  := - 1
  else
    cbMesaDestino.ItemIndex  := cbMesaDestino.Items.IndexOf(FormatFloat('000', StrToInt(sMesaDestino))); //2015-09-14
  CheckTodosOrigem.Checked := True;// Inicialmente marca todos, avaliar qual situação ocorre com maior frequência, ver com Pereti
  GridOrigem.Repaint;
  if (sMesaOrigem <> '') and Consumo then
  begin
    sModeloECFOld     := Form1.sModeloECF;
    Form1.iMesaAberta := StrToInt(sMesaOrigem);
    // 2015-10-26 Form1.Confernciademesa1Click(Self);
    Form1.sModeloECF  := sModeloECFOld;
    Form1.iMesaAberta := 0;
  end;

end;

procedure TForm8.cbMesaOrigemExit(Sender: TObject);
begin
  if ((StrToIntDef(cbMesaOrigem.Text, 0) <= 0) or (StrToIntDef(cbMesaOrigem.Text, 0) > StrToInt(Form1.sMesas))) then
  begin
    ShowMessage(Form1.sMesaOuConta + ' inválida');
  end;

  if cbMesaOrigem.Text <> '' then
  begin
    if (cbMesaOrigem.Text = cbMesaDestino.Text) then
    begin
      ShowMessage('As ' + Form1.sMesasOuContas + ' devem ser diferentes');
      cbMesaDestino.SetFocus;
    end;
  end;
end;

procedure TForm8.FormCreate(Sender: TObject);
begin
  lbTotalTransferencia.Alignment := taRightJustify;

  GridOrigem.ColCount := QUANTIDADE_COLUNAS;

  GridOrigem.Cells[COLUNA_CHECK,                0] := '';
  GridOrigem.Cells[COLUNA_ITEM,                 0] := 'Item';
  GridOrigem.Cells[COLUNA_PRODUTO,              0] := 'Produto';
  GridOrigem.Cells[COLUNA_QUANTIDADE,           0] := 'Quantidade';
  GridOrigem.Cells[COLUNA_QUANTIDADE_TRANSFERE, 0] := 'Quantidade Transfere'; // Sandro Silva 2022-02-04
  GridOrigem.Cells[COLUNA_VALOR_TOTAL,          0] := 'Preço R$';
  GridOrigem.Cells[COLUNA_REGISTRO,             0] := 'Registro';// Sandro Silva 2019-09-03 ER 02.06 UnoChapeco

  GridOrigem.ColWidths[COLUNA_QUANTIDADE_TRANSFERE] := GridOrigem.ColWidths[COLUNA_QUANTIDADE] + 20; // Sandro Silva 2022-02-04

  //Posiciona checktodos na coluna 0 da linha 0
  AjustaResolucao(Form8);
  Form8.Height := AjustaAltura(Form8.Height);
  Form8.Width  := AjustaLargura(580); // Sandro Silva 2022-02-04 Form8.Width  := AjustaLargura(530);

  iAlturaLinha := AjustaAltura(GridOrigem.RowHeights[0]);
  GridOrigem.ColWidths[COLUNA_CHECK]                := AjustaLargura(GridOrigem.ColWidths[COLUNA_CHECK]);
  GridOrigem.ColWidths[COLUNA_ITEM]                 := AjustaLargura(GridOrigem.ColWidths[COLUNA_ITEM]);
  GridOrigem.ColWidths[COLUNA_PRODUTO]              := AjustaLargura(GridOrigem.ColWidths[COLUNA_PRODUTO]);
  GridOrigem.ColWidths[COLUNA_QUANTIDADE]           := AjustaLargura(GridOrigem.ColWidths[COLUNA_QUANTIDADE]);
  GridOrigem.ColWidths[COLUNA_QUANTIDADE_TRANSFERE] := AjustaLargura(GridOrigem.ColWidths[COLUNA_QUANTIDADE_TRANSFERE]);
  GridOrigem.ColWidths[COLUNA_VALOR_TOTAL]          := AjustaLargura(GridOrigem.ColWidths[COLUNA_VALOR_TOTAL]);
  GridOrigem.ColWidths[COLUNA_REGISTRO]             := 0; // Permanece oculta Sandro Silva 2019-09-03 ER 02.06 UnoChapeco

  cbMesaOrigem.Height := cbMesaDestino.Height;
  cbMesaOrigem.Top    := cbMesaDestino.Top;
  cbMesaOrigem.Font   := cbMesaDestino.Font;

  GridOrigem.Left  := AjustaLargura(GridOrigem.Left);
  GridOrigem.Top   := cbMesaOrigem.BoundsRect.Bottom + AjustaAltura(1);
  GridOrigem.Width := GridOrigem.Width - GridOrigem.Left;

  GridOrigem.Font.Size    := AjustaAltura(GridOrigem.Font.Size);

  CheckTodosOrigem.Font   := GridOrigem.Font;

  CheckTodosOrigem.Top    := GridOrigem.Top + AjustaAltura(4); // GridOrigem.Top + ((GridOrigem.RowHeights[0] - CheckTodosOrigem.Height) div 2); //GridOrigem.Top + Form1.AjustaAltura(4);
  CheckTodosOrigem.Left   := GridOrigem.Left + AjustaLargura(4);// GridOrigem.Left + ((GridOrigem.ColWidths[0] - CheckTodosOrigem.Width) div 2); //GridOrigem.Left + Form1.AjustaLargura(4);
  CheckTodosOrigem.Height := GridOrigem.RowHeights[0];

  cbMesaDestino.Left := GridOrigem.BoundsRect.Right - cbMesaDestino.Width;
  Label2.Left := cbMesaDestino.Left;

  lbTotalTransferencia.Width    := AjustaLargura(256);
  lbTotalTransferencia.WordWrap := False;
  lbTotalTransferencia.Left     := Form8.Width - lbTotalTransferencia.Width - AjustaLargura(24);
  if Consumo then
  begin
    // Sandro Silva 2022-02-04 GridOrigem.ColWidths[COLUNA_VALOR_TOTAL] := 0;
    // Sandro Silva 2022-02-04 Form8.Width := AjustaLargura(525); // Sandro Silva 2022-02-04 Form8.Width := AjustaLargura(450);
    Form8.Width := Form8.Width - GridOrigem.ColWidths[COLUNA_VALOR_TOTAL];
    GridOrigem.ColWidths[COLUNA_VALOR_TOTAL] := 0; // Sandro Silva 2022-02-04

    lbTotalTransferencia.Alignment := taCenter;
    lbTotalTransferencia.WordWrap  := True;
    lbTotalTransferencia.Width     := AjustaLargura(140);
    lbTotalTransferencia.Top       := AjustaAltura(329);
    lbTotalTransferencia.Height    := AjustaAltura(58);
    lbTotalTransferencia.Left      := Form8.Width - lbTotalTransferencia.Width - AjustaLargura(24);
    lbTotalTransferencia.Visible   := False; // Sandro Silva 2019-08-23 UnoChapeco
  end;

  lbTotalTransferencia.Top := GridOrigem.BoundsRect.Bottom + AjustaAltura(12);

  Button1.Left := GridOrigem.Left;
  Button1.Top  := GridOrigem.BoundsRect.Bottom + AjustaAltura(5);
  Button2.Top  := Button1.Top;

end;

procedure TForm8.GridOrigemDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  gridMesaDrawCell(Sender, ACol, ARow, Rect, State);
  if (ACol in [COLUNA_ITEM, COLUNA_QUANTIDADE, COLUNA_QUANTIDADE_TRANSFERE, COLUNA_VALOR_TOTAL]) and (ARow > 0) then // Sandro Silva 2022-02-04 if (ACol in [COLUNA_ITEM, COLUNA_QUANTIDADE, COLUNA_VALOR_TOTAL]) and (ARow > 0) then
    AlinhaTextoDireitaStringgrid(TStringGrid(Sender).Canvas, Rect, TStringGrid(Sender).Cells[ACol, ARow]);
end;

procedure TForm8.gridMesaDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  CorFonte: TColor;
begin
  CorFonte := TStringGrid(Sender).Font.Color; // Sandro Silva 2022-02-04

  if (ACol = 0) and (ARow > 0) then
  begin

    if gdFixed in State then
      (Sender AS TStringGrid).Canvas.Brush.Color := clWindow;

    if gdSelected in State then
    begin
      (Sender AS TStringGrid).Canvas.Brush.Color := clWindow;
      (Sender AS TStringGrid).Canvas.Font.Color  := (Sender AS TStringGrid).Canvas.Brush.Color; //clWindow;
    end;

    TStringGrid(Sender).Canvas.Font.Color := (Sender AS TStringGrid).Color;
    TStringGrid(Sender).Canvas.TextRect(Rect, Rect.Left, Rect.Top, (Sender AS TStringGrid).Cells[ACol, ARow]);

   if ((Sender as TStringGrid).Cells[ACol,ARow] = MARCADO) then
     DrawFrameControl((Sender as TStringGrid).Canvas.Handle, Rect, DFC_BUTTON, DFCS_BUTTONCHECK or DFCS_CHECKED) // Desenha o CheckBox desmarcado
   else
     DrawFrameControl((Sender as TStringGrid).Canvas.Handle, Rect, DFC_BUTTON, DFCS_BUTTONCHECK); // Desenha o CheckBox marcado
  end;

  {Sandro Silva 2022-02-04 inicio}

  if (ACol = COLUNA_QUANTIDADE_TRANSFERE) then
    TStringGrid(Sender).Canvas.Font.Style := [fsBold];

  if (ACol > 0) and (ARow > 0) then
  begin

    if TStringGrid(Sender).Cells[COLUNA_VALOR_TOTAL, ARow] = '<cancelado>' then
    begin
      TStringGrid(Sender).Canvas.Brush.Color := clBtnFace;
      TStringGrid(Sender).Canvas.FillRect(Rect);
    end;

    (Sender AS TStringGrid).Canvas.Font.Color := CorFonte;// (Sender AS TStringGrid).Color;
    (Sender AS TStringGrid).Canvas.TextRect(Rect, Rect.Left + 1, Rect.Top + 2, (Sender as TStringGrid).Cells[ACol, ARow]);
  end;
  {Sandro Silva 2022-02-04 fim}

end;

procedure TForm8.MarcaItem(Sender: TObject);
begin
  if (Sender as TStringGrid).Col = COLUNA_CHECK then
  begin

    if (Sender as TStringGrid).Cells[COLUNA_ITEM, (Sender as TStringGrid).Row] <> '' then
    begin // Apenas linha com item listado

      if ((Sender as TStringGrid).Cells[COLUNA_CHECK, (Sender as TStringGrid).Row] = DESMARCADO) then
        ((Sender as TStringGrid).Cells[COLUNA_CHECK, (Sender as TStringGrid).Row] := MARCADO)
      else
        ((Sender as TStringGrid).Cells[COLUNA_CHECK, (Sender as TStringGrid).Row] := DESMARCADO);
        
    end; // if (Sender as TStringGrid).Cells[1, (Sender as TStringGrid).Row] <> '' then
    
  end;
  TotalMarcado;
end;

procedure TForm8.GridOrigemKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key in [VK_RETURN, VK_SPACE] then // Teclou enter ou espaço
    MarcaItem(Sender);

end;

procedure TForm8.SelecionaProdutosDaMesa(sMesa: String);
{Sandro Silva 2011-08-31 inicio
Seleciona os produtos lançados para a mesa informada e preeche a gridOrigem}
var
  iLinha: Integer;
begin
  Button2.Enabled := False; // 2015-09-12
  //Primeiro limpa os items que existem na grid
  for iLinha := 1 to GridOrigem.RowCount -1 do
    GridOrigem.Rows[iLinha].Clear;

  //Sempre começa com 2 linhas cada grid;
  GridOrigem.RowCount  := 2;

  CommitaTudo(True); // Conferencia de mesas

  iLinha := 0;
  if Trim(sMesa) <> '' then // 2015-09-16
  begin
    //Seleciona os itens da mesa origem
    Form1.IBQuery1.SQL.Text :=
      'select REGISTRO, ITEM, DESCRICAO, QUANTIDADE, TOTAL, VENDEDOR ' +
      'from ALTERACA ' +
      'where (TIPO=''MESA'' or TIPO=''DEKOL'') ' +
      'and PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(StrToInt(sMesa))) + // Sandro Silva 2021-12-02 'and PEDIDO = ' + QuotedStr(FormatFloat('000000', StrToInt(sMesa))) +
      ' order by ITEM';
    Form1.IBQuery1.Open;

    GridOrigem.RowHeights[0] := iAlturaLinha; // Sandro Silva 2017-09-28;    
    while Form1.IBQuery1.Eof = False do
    begin
      Inc(iLinha);
      if iLinha > (GridOrigem.RowCount -1) then
         GridOrigem.RowCount := GridOrigem.RowCount + 1;

      GridOrigem.RowHeights[iLinha] := iAlturaLinha; // Sandro Silva 2017-09-28; 

      GridOrigem.Cells[COLUNA_CHECK,                iLinha] := '';
      GridOrigem.Cells[COLUNA_ITEM,                 iLinha] := FormatFloat('000', Form1.IBQuery1.FieldByName('ITEM').AsInteger);
      GridOrigem.Cells[COLUNA_PRODUTO,              iLinha] := Form1.IBQuery1.FieldByName('DESCRICAO').AsString;
      GridOrigem.Cells[COLUNA_QUANTIDADE,           iLinha] := Form1.IBQuery1.FieldByName('QUANTIDADE').AsString;
      GridOrigem.Cells[COLUNA_QUANTIDADE_TRANSFERE, iLinha] := Form1.IBQuery1.FieldByName('QUANTIDADE').AsString;
      GridOrigem.Cells[COLUNA_VALOR_TOTAL,          iLinha] := Form1.IBQuery1.FieldByName('TOTAL').AsString;
      if AnsiUpperCase(Form1.IBQuery1.FieldByName('VENDEDOR').AsString) = '<CANCELADO>' then
        GridOrigem.Cells[COLUNA_VALOR_TOTAL,   iLinha] := Form1.IBQuery1.FieldByName('VENDEDOR').AsString;
      GridOrigem.Cells[COLUNA_REGISTRO, iLinha] := Form1.IBQuery1.FieldByName('REGISTRO').AsString;// Sandro Silva 2019-09-03 ER 02.06 UnoChapeco

      Form1.IBQuery1.Next;
    end; // while Form1.IBQuery1.Eof = False do
  end; //if Trim(sMesa) <> '' then // 2015-09-16
  if iLinha > 0 then
    Button2.Enabled := True;
end;

procedure TForm8.MarcaDesmarcaTodos(Sender: TObject; bMarcar: Boolean);
{Sandro Silva 2011-08-31 inicio
Marca ou desmarca todos itens da grid}
var
  iLinha: Integer;
begin
  for iLinha := 1 to (Sender as TStringGrid).RowCount -1 do
  begin
    if bMarcar then
      (Sender as TStringGrid).Cells[0, iLinha] := MARCADO
    else
      (Sender as TStringGrid).Cells[0, iLinha] := DESMARCADO;
  end;

  TotalMarcado;
end;

procedure TForm8.CheckTodosOrigemClick(Sender: TObject);
begin
  MarcaDesmarcaTodos(GridOrigem, CheckTodosOrigem.Checked);
end;

procedure TForm8.GridOrigemKeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) in [VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT] then
    Key := #0;

  {Sandro Silva 2022-02-04 inicio}
  if TStringGrid(Sender).Col = COLUNA_QUANTIDADE_TRANSFERE then
  begin

    if (Key = ',') and (Pos(',', TStringGrid(Sender).Cells[iColunaAtual, iLinhaAtual]) > 0) then // Aceitar apenas 1 vírgula
      Key := #0;

    if not (Key in['0'..'9', ',', #8, #46]) then // Aceitar apenas números, vírgula, backspace e delete
      Key := #0;

    if Ord(Key) = Ord('.') then
      Key := #0;

  end;
  {Sandro Silva 2022-02-04 fim}

end;

procedure TForm8.GridOrigemMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  iColunaClic, iLinhaClic: Integer;
  Pt: TPoint;
begin
  GetCursorPos(Pt);
  Pt := GridOrigem.ScreenToClient(Pt);

  GridOrigem.MouseToCell(Pt.X, Pt.Y, iColunaClic, iLinhaClic);

  if ((iColunaClic <= GridOrigem.ColCount - 1) and (iColunaClic >= 0)) and
     ((iLinhaClic <= GridOrigem.RowCount - 1) and (iLinhaClic >= 1)) then
  begin
    if (Sender as TStringGrid).Col = COLUNA_CHECK then
    begin
      MarcaItem(Sender);
    end;
  end;

end;

procedure TForm8.TotalMarcado;
{Sandro Silva 2011-08-31 inicio
Calcula o valor total marcado para transferir}
var
  iLinha: Integer;
  dTotal: Double;
  iLinhaAtual: Integer;
begin
  dTotal := 0;
  iLinhaAtual := GridOrigem.Row;
  for iLinha := 1 to GridOrigem.RowCount -1 do
  begin
    if GridOrigem.Cells[COLUNA_CHECK, iLinha] = MARCADO then
      dTotal := dTotal + StrToFloatDef(GridOrigem.Cells[COLUNA_VALOR_TOTAL, iLinha], 0);
  end;
  lbTotalTransferencia.Caption := 'Total da transferência: R$ ' + FormatFloat(',0.00', dTotal);
  GridOrigem.Row := iLinhaAtual;
end;

procedure TForm8.FormClose(Sender: TObject; var Action: TCloseAction);
var
  iLinha: Integer;
begin
  for iLinha := 1 to GridOrigem.RowCount -1 do
    gridOrigem.Rows[iLinha].Clear;
  gridOrigem.RowCount := 2;
end;

procedure TForm8.FormShow(Sender: TObject);
begin
  if cbMesaOrigem.CanFocus then
    cbMesaOrigem.SetFocus
  else
    GridOrigem.SetFocus;
end;

procedure TForm8.cbMesaOrigemChange(Sender: TObject);
begin
  if cbMesaOrigem.Text <> '' then
  begin
    CheckTodosOrigem.Checked := False;
    SelecionaProdutosDaMesa(cbMesaOrigem.Text);
    CheckTodosOrigem.Checked := True;
  end;
end;

procedure TForm8.FormActivate(Sender: TObject);
begin
  Form8.Caption  := 'Transferência de ' + Form1.sMesasOuContas; // 2015-09-12
  {Sandro Silva 2020-12-07 inicio}
  //if PAFNFCe and (Form1.sModeloECF_Reserva <> '99') then // Sandro Silva 2023-06-27 if PAFNFCe then
  if PAFNFCe then
    Form8.Caption := Form8.Caption + ' - ' + MSG_ALERTA_MENU_FISCAL_INACESSIVEL;
  {Sandro Silva 2020-12-07 fim}

  if Pos('CONTA', AnsiUpperCase(Form1.sMesaOuConta)) > 0 then
  begin
    Label1.Caption := 'Da Conta'; // 2015-09-12
    Label2.Caption := 'Para Conta'; // 2015-09-12
  end;

  if cbMesaOrigem.Items.Count < 1 then
  begin
    ShowMessage('Todas as ' + Form1.sMesasOuContas + ' estão vazias');
    Button1Click(Sender);
  end;

end;

procedure TForm8.GridOrigemSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  {Sandro Silva 2022-02-04 inicio}
  iLinhaAtual  := ARow;
  iColunaAtual := ACol;
  TStringGrid(Sender).Options := TStringGrid(Sender).Options - [goEditing];
  if (ACol = COLUNA_QUANTIDADE_TRANSFERE) and (TStringGrid(Sender).Cells[COLUNA_VALOR_TOTAL, ARow] <> '<cancelado>') then
    TStringGrid(Sender).Options := TStringGrid(Sender).Options + [goEditing];
  {Sandro Silva 2022-02-04 fim}
end;

procedure TForm8.GridOrigemSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  {Sandro Silva 2022-02-04 inicio}
  if StrToFloatDef(TStringGrid(Sender).Cells[ACol, ARow], 0) > StrToFloatDef(TStringGrid(Sender).Cells[COLUNA_QUANTIDADE, ARow], 0) then
    TStringGrid(Sender).Cells[ACol, ARow] := TStringGrid(Sender).Cells[COLUNA_QUANTIDADE, ARow];
  {Sandro Silva 2022-02-04 fim}
end;

end.

