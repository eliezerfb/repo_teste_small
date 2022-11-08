unit Unit27;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, frame_teclado_1, StdCtrls, IniFiles, ComCtrls, Buttons,
  Printers, StrUtils, Types, ufuncoesfrente
  ;

type
  //TTipoInfoCombo = (tiInfoComboModeloSAT, tiInfoComboImpressoras, tiInfoComboFusoHorario, tiInfoComboContaClienteOS);

  TForm27 = class(TForm)
    Label2: TLabel;
    Label1: TLabel;
    Button1: TBitBtn;
    Panel2: TPanel;
    Frame_teclado1: TFrame_teclado;
    ComboBox1: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ComboBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Enter(Sender: TObject);
  private
    { Private declarations }
    FFabricanteModelo: String;
    FTipoInformacaoCombo: TTipoInfoCombo;
  public
    { Public declarations }
    property FabricanteModelo: String read FFabricanteModelo write FFabricanteModelo;
    property TipoInformacaoCombo: TTipoInfoCombo read FTipoInformacaoCombo write FTipoInformacaoCombo;
  end;

var
  Form27: TForm27;

implementation

uses
  Fiscal
  , SmallFunc
  , uajustaresolucao;

{$R *.dfm}

procedure TForm27.Button1Click(Sender: TObject);
var
  iItem: Integer; // Sandro Silva 2017-12-15
  sTexto: String; // Sandro Silva 2017-12-15
begin
  //
  if TipoInformacaoCombo = tiInfoComboContaClienteOS then
  begin
    sTexto := Form27.ComboBox1.Text;
    if Length(LimpaNumero(sTexto)) <= 3 then
    begin
      for iItem := 0 to Form27.ComboBox1.Items.Count - 1 do
      begin
        if Copy(Form27.ComboBox1.Items.Strings[iItem], 1, 3) = Right('00' + LimpaNumero(sTexto), 3) then
        begin
          Form27.ComboBox1.ItemIndex := iItem;
          Break;
        end;
      end;
    end;
  end;
  Close;
  //
end;

procedure TForm27.Image6Click(Sender: TObject);
begin
  Form27.Button1Click(Sender);
end;

procedure TForm27.FormActivate(Sender: TObject);
  function ItemIndex(const S: String; Items: TStrings): Integer;
  begin
    for Result := 0 to Items.Count - 1 do
      if Pos(s, Items.Strings[Result]) = 1 then
        Exit;
    Result := -1;
  end;
var
  iConta: Integer;
begin
  //
  //
  Form27.Frame_teclado1.Led_FISCAL.Picture := Form1.Frame_teclado1.Led_FISCAL.Picture;
  Form27.Frame_teclado1.Led_FISCAL.Hint    := Form1.Frame_teclado1.Led_FISCAL.Hint;
  //
  Form27.Frame_teclado1.Led_ECF.Picture    := Form1.Frame_teclado1.Led_ECF.Picture;
  Form27.Frame_teclado1.Led_ECF.Hint       := Form1.Frame_teclado1.Led_ECF.Hint;
  //
  Form27.Frame_teclado1.Led_REDE.Picture   := Form1.Frame_teclado1.Led_REDE.Picture;
  Form27.Frame_teclado1.Led_REDE.Hint      := Form1.Frame_teclado1.Led_REDE.Hint;
  //

  ComboBox1.Clear;
  ComboBox1.Style := csDropDown; // Sandro Silva 2017-09-06

  case FTipoInformacaoCombo of
    tiInfoComboImpressoras:
      begin
        Printer.Refresh; // Atualiza a lista de impressoras instaladas Sandro Silva 2017-09-11
        ComboBox1.Items.Assign(Printer.Printers);
        ComboBox1.Items.Add(IMPRESSORA_PADRAO_WINDOWS);
        ComboBox1.Style := csDropDownList; // Sandro Silva 2017-09-06
        ComboBox1.ItemIndex := ItemIndex(IfThen(Form1.sImpressoraDestino = '', IMPRESSORA_PADRAO_WINDOWS, Form1.sImpressoraDestino), ComboBox1.Items);
      end;
    tiInfoComboFusoHorario: // Sandro Silva 2017-10-19 Lista os fusos horários para evitar erro no preenchimento do parâmetro
      begin
        ComboBox1.Items.Add('-01:00');
        ComboBox1.Items.Add('-02:00');
        ComboBox1.Items.Add('-03:00');
        ComboBox1.Items.Add('-04:00');
        ComboBox1.Items.Add('-05:00');
        ComboBox1.ItemIndex := ItemIndex(IfThen(Form1.sFuso = '', '-03:00', Form1.sFuso), ComboBox1.Items);
      end;
    tiInfoComboContaClienteOS: // Sandro Silva 2017-12-15
      begin
        if Copy(Form1.sConcomitante,1,2) = 'OS' then
        begin

          // Seleciona todas a contas de clientes abertas
          Form1.IBQuery1.Close;
          Form1.IBQuery1.SQL.Clear;
          Form1.IBQuery1.SQL.Add('select PEDIDO, max(SEQUENCIALCONTACLIENTEOS) as SEQUENCIALCONTACLIENTEOS from ALTERACA where (TIPO=''MESA'' or TIPO=''DEKOL'') group by PEDIDO order by PEDIDO');
          Form1.IBQuery1.Open;

          for iConta := 1 to StrToInt(Form1.sMesas) do
          begin

            {Sandro Silva 2021-12-02 inicio
            Form1.IBQuery1.Close;
            Form1.IBQuery1.SQL.Clear;
            Form1.IBQuery1.SQL.Add('select PEDIDO, max(SEQUENCIALCONTACLIENTEOS) as SEQUENCIALCONTACLIENTEOS from ALTERACA where (TIPO=''MESA'' or TIPO=''DEKOL'') and PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(iConta)) + ' group by PEDIDO order by PEDIDO'); // Sandro Silva 2021-12-02 Form1.IBQuery1.SQL.Add('select PEDIDO, max(SEQUENCIALCONTACLIENTEOS) as SEQUENCIALCONTACLIENTEOS from ALTERACA where (TIPO=''MESA'' or TIPO=''DEKOL'') and PEDIDO = ' + QuotedStr(StrZero(iConta, 6, 0)) + ' group by PEDIDO order by PEDIDO');
            Form1.IBQuery1.Open;
            if Form1.IBQuery1.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString = '' then // Sandro Silva 2018-12-12
              ComboBox1.Items.Add(StrZero(iConta, 3, 0))
            else
              ComboBox1.Items.Add(StrZero(iConta, 3, 0) + '-' + Form1.IBQuery1.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString);
            }
            // Para cada conta que será adicionada no combobox faz a verificação se está aberta e concatena o número da conta com sequencial dela
            if Form1.IBQuery1.Locate('PEDIDO', FormataNumeroDoCupom(iConta), []) and (Form1.IBQuery1.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString <> '') then // Sandro Silva 2018-12-12
              ComboBox1.Items.Add(StrZero(iConta, 3, 0) + '-' + Form1.IBQuery1.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString)
            else
              ComboBox1.Items.Add(StrZero(iConta, 3, 0));
            {Sandro Silva 2021-12-02 fim}

          end;

        end;

      end;
  else
    begin
      if AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString) = 'CE' then
      begin
        ComboBox1.Items.Add('0201 - SWEDA SMFE');
        ComboBox1.Items.Add('0301 - TANCA TM-1000');
        ComboBox1.Items.Add('0401 - GERTEC GERMFE');
        ComboBox1.Items.Add('0601 - BEMATECH TM-1000');
        ComboBox1.Items.Add('0701 - ELGIN LINKERC1');
        ComboBox1.Items.Add('1301 - CS DEVICES MFECR-A1'); // Sandro Silva 2019-06-24
      end
      else
      begin
        ComboBox1.Items.Add('0101 - DIMEP D-SAT');
        ComboBox1.Items.Add('0102 - DIMEP D-SAT 2.0');
        ComboBox1.Items.Add('0201 - SWEDA SS-1000');
        ComboBox1.Items.Add('0202 - SWEDA SS-2000');
        ComboBox1.Items.Add('0301 - TANCA TS-1000');
        ComboBox1.Items.Add('0401 - GERTEC GerSat');
        ComboBox1.Items.Add('0402 - GERTEC GerSAT-W');
        ComboBox1.Items.Add('0501 - URANO SAT UR');
        ComboBox1.Items.Add('0502 - URANO U-S@T');
        ComboBox1.Items.Add('0601 - BEMATECH RB-1000');
        ComboBox1.Items.Add('0602 - BEMATECH RB-2000');
        ComboBox1.Items.Add('0603 - BEMATECH S@T Go');// Sandro Silva 2018-12-14
        ComboBox1.Items.Add('0701 - ELGIN Linker');
        ComboBox1.Items.Add('0702 - ELGIN Linker II');
        ComboBox1.Items.Add('0703 - ELGIN Smart');        
        ComboBox1.Items.Add('0801 - KRYPTUS EASYS@T');
        ComboBox1.Items.Add('0901 - NITERE NSAT-4200');
        ComboBox1.Items.Add('1001 - DARUMA DS-100i');
        ComboBox1.Items.Add('1101 - EPSON SAT-A10'); // Sandro Silva 2017-07-17
        ComboBox1.Items.Add('1201 - CONTROLID S@T-iD'); // Sandro Silva 2018-03-29
        ComboBox1.Items.Add('1301 - CS DEVICES SATCR-A1'); // Sandro Silva 2019-06-24
      end;
      ComboBox1.ItemIndex := ItemIndex(FFabricanteModelo, ComboBox1.Items);
    end;
  end;

  if ComboBox1.CanFocus then
  begin
    ComboBox1.SetFocus;
  end;
  //
end;

procedure TForm27.ComboBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if TipoInformacaoCombo = tiInfoComboContaClienteOS then
    begin

      Button1.Click;
    end
    else
    begin
      Perform(Wm_NextDlgCtl,0,0);
      Button1.Click;
    end;
  end;
  if Key = VK_DOWN then
  begin
    // Perform(Wm_NextDlgCtl,0,0);
    if SendMessage(TComboBox(Sender).Handle, CB_GETDROPPEDSTATE, 0, 0) <> 1 then
      SendMessage(TComboBox(Sender).Handle, CB_SHOWDROPDOWN, 1, 0);
  end;
end;

procedure TForm27.FormCreate(Sender: TObject);
begin
  Form27.Top    := Form1.Panel1.Top;
  Form27.Left   := Form1.Panel1.Left;
  Form27.Height := Form1.Panel1.Height;
  Form27.Width  := Form1.Panel1.Width;

  AjustaResolucao(Form27);
  AjustaResolucao(Form27.Frame_teclado1);
  Form1.Image7Click(Sender);
end;

procedure TForm27.ComboBox1Enter(Sender: TObject);
begin
  SendMessage(ComboBox1.Handle, CB_SHOWDROPDOWN, Integer(True), 0);
end;

end.
