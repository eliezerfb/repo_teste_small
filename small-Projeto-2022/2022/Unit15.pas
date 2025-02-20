unit Unit15;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Gauges, IniFiles, Db, smallfunc_xe, printers,
  DBCtrls, Spin, Grids, DBGrids, IBCustomDataSet;

type

  TForm15 = class(TForm)
  PrintDialog1: TPrintDialog;
    Panel4: TPanel;
    Label8: TLabel;
    DBGrid2: TDBGrid;
    Panel5: TPanel;
    Button1: TButton;
    Button5: TButton;
    Button7: TButton;
    Panel1: TPanel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    GroupBox3: TGroupBox;
    Label7: TLabel;
    Label6: TLabel;
    Label14: TLabel;
    Label13: TLabel;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    RadioButton2: TRadioButton;
    RadioButton1: TRadioButton;
    SpinEdit1: TSpinEdit;
    GroupBox1: TGroupBox;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox1: TCheckBox;
    Label9: TLabel;
    Label10: TLabel;
    Edit1: TEdit;
    ComboBox2: TComboBox;
    Image1: TImage;
    IBDataSet1: TIBDataSet;
    Button2: TButton;
  procedure Button1Click(Sender: TObject);
  procedure Button5Click(Sender: TObject);
  procedure FormActivate(Sender: TObject);
  procedure CheckBox1Click(Sender: TObject);
  procedure CheckBox2Click(Sender: TObject);
  procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
  procedure ComboBox1Change(Sender: TObject);
  procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button7Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure SpinEdit1Exit(Sender: TObject);
    procedure DBGrid2KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure RadioButton6Click(Sender: TObject);
    procedure ComboBox2KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure RadioButton1Exit(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure ComboBox1Enter(Sender: TObject);
    procedure DBGrid2DrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure DBGrid2ColEnter(Sender: TObject);
  private
 { Private declarations }
  public

  sInformacao: array [1..5] of String;
  { Public declarations }
  end;

var
  Form15: TForm15;

implementation

uses Unit35, Unit7, Unit14, Mais, etiquet, Unit19, uDialogs;

Function VerificaAlteracoes(): Boolean;
begin
  VerificaAlteracoes := True;
  if form15.RadioButton4.Checked then
  begin
    while ((not Form15.ibDataSet1.Eof) and (Form15.ibDataSet1.FieldByName('ALTERADO').AsString <> '1')) or (Form15.ibDataSet1.FieldByname('ATIVO').AsString = '1') do
    begin
      if Form15.ibDataSet1.eof then exit;
      Form15.ibDataSet1.Next;
    end;
    if Form15.ibDataSet1.FieldByName('ALTERADO').AsString <> '1' then VerificaAlteracoes := False;
    Form15.ibDataSet1.Edit;
    Form15.ibDataSet1.FieldByName('ALTERADO').AsString := '0';
    Form15.ibDataSet1.Post;
  end;
end;

{Função que verifica o número de vezes que a etiqueta vai ser impressa}
Function VerQuantidade(): integer;
var
  iQtde : integer;
begin
   iQtde := 0;
   if form15.RadioButton6.Checked then
   begin
     Form7.ibDataset40.First;
     while not Form7.ibDataset40.Eof do
     begin
       if Form7.ibDataset40.FieldByName('CODIGO').AsString = Form15.ibDataset1.FieldByName('CODIGO').AsString then iQtde := Form7.ibDataset40.FieldByName('QTD').AsInteger;
       Form7.ibDataset40.Next;
     end;
   end else
   begin
     if (Form15.RadioButton1.Checked) and (Form15.RadioButton5.Checked) then iQtde := Form15.SpinEdit1.Value;
     if (Form7.sModulo = 'ESTOQUE') and (iQtde = 0) then
     begin
       if Form15.RadioButton3.Checked then
       begin
         if (Form15.RadioButton1.Checked) and (Form15.ibDataset1.FieldByName('qtd_compra').AsInteger > 0) then iQtde := Form15.SpinEdit1.Value else iQtde := Form15.ibDataset1.FieldByName('qtd_compra').AsInteger;
         if Form15.ibDataset1.eof = false then
         begin
           Form15.ibDataset1.Edit;
           Form15.ibDataset1.FieldByName('qtd_compra').AsInteger := 0;
           Form15.ibDataset1.Post;
         end;
       end else if Form15.RadioButton1.Checked then
       begin
         iQtde := Form15.SpinEdit1.Value;
       end else iQtde := Form15.ibDataset1.FieldByName('qtd_atual').AsInteger;
     end else if (Form7.sModulo <> 'ESTOQUE') then iQtde := 1;
   end;
   VerQuantidade := iQtde;
end;

{Função que converte de milímetros para pixels horizontalmente}
function Largura(MM : Double) : Longint;
var
  mmPointX : Real;
  PageSize, OffSetUL : TPoint;
begin
  mmPointX := Printer.PageWidth / GetDeviceCaps(Printer.Handle,HORZSIZE);
  Escape (Printer.Handle,GETPRINTINGOFFSET,0,nil,@OffSetUL);
  Escape (Printer.Handle,GETPHYSPAGESIZE,0,nil,@PageSize);
  if MM > 0 then Result := round ((MM * mmPointX) - OffSetUL.X) else Result := round (MM * mmPointX);
end;

{Função que converte de milímetros para pixels verticalmente}
function Altura(MM : Double) : Longint;
var
  mmPointY : Real;
  PageSize, OffSetUL : TPoint;
begin
  mmPointY := Printer.PageHeight / GetDeviceCaps(Printer.Handle,VERTSIZE);
  Escape (Printer.Handle,GETPRINTINGOFFSET,0,nil,@OffSetUL);
  Escape (Printer.Handle,GETPHYSPAGESIZE,0,nil,@PageSize);
  if MM > 0 then Result := round ((MM * mmPointY) - OffSetUL.Y) else Result := round (MM * mmPointY);
end;

{Função que localiza a porta da impressora selecionada}
Function PortaDaImpressora(sImpre : String) : String;
var
  p, p2 : pChar;
  i, iIndice : integer;
  sDriver, sPort :string;
  Impressoras, Portas : TStrings;
begin
  GetMem(p, 32767);
  p2 := p;
  //
  Portas := TStringList.Create;
  Impressoras := TStringList.Create;
  //
  if GetProfileString('devices', nil, '',p, 32767) <> 0 then begin
    while p2^ <> #0 do
    begin
      Impressoras.Add(StrPas(p2));
      p2 := @p2[lStrLen(p2) + 1];
    end;
  end;
  GetMem(p2, 32767);
  for i := 0 to (Impressoras.Count - 1) do
  begin
    StrPCopy(p2, Impressoras[i]);
    if GetProfileString('devices', p2, '',p, 32767) <> 0 then
    begin
       sDriver := StrPas(p);
       sPort := sDriver;
       Delete(sDriver, Pos(',', sDriver), Length(sDriver));
       Delete(sPort, 1, Pos(',', sPort));
       Portas.Add(sPort);
    end;
  end;
  FreeMem(p2, 32767);
  FreeMem(p, 32767);
  //
  i := 0;
  iIndice := 0;
  if copy(sImpre, 1,2) <> '\\' then
  begin
     Delete(sImpre, Pos(' on', sImpre), length(sImpre));
     while i < impressoras.Count do
     begin
       if sImpre = Impressoras.Strings[i] then iIndice := i;
       Inc(i);
     end;
  end else
  begin
     Portas.Strings[0] := sImpre;
     iIndice := 0
  end;
  sImpre := portas.Strings[iIndice];
  if copy(sImpre, Length(sImpre), 1) = ':' Then Delete(sImpre, Pos(':', sImpre), Length(sImpre));
  PortaDaImpressora := sImpre;
end;

{Função que converte o nome do campo para a máscara correta (acentos, cedilha...)}
Function NomeDoCampo(sNome : string) : string;
begin
  if sNome <> '' then NomeDocampo := Form15.ibDataset1.FieldByname(sNome).DisplayLabel+': ';
end;

{Função que verifica se o número de colunas selecionado não é maior que o máximo (5)}
Function TotalDeColunas(sTotal : String): Boolean;
begin
  TotalDeColunas := True;
  if StrToFloat(sTotal) > 8 Then // Número máximo de colunas é 5 // alterei pedido da sara de 5 para 8
  begin
    //MessageDlg('Número de colunas por linha fora dos padrões permitidos: 1 à 8 !', MtInformation, [mbok], 0);  Mauricio Parizotto 2023-10-25
    MensagemSistema('Número de colunas por linha fora dos padrões permitidos: 1 à 8 !',msgAtencao);
    TotalDeColunas := False;
  end;
end;
{$R *.DFM}

procedure TForm15.Button1Click(Sender: TObject);
var
  ArqIni  : TiniFile;
  sOpcoes : string;
begin
  if Form7.sModulo = 'ESTOQUE' then
  begin
    ArqINI := TiniFile.create(Form1.sAtual + '\etiquetas.inf');
    ArqIni.UpdateFile;
    if Form15.RadioButton3.Checked = True then sOpcoes := Form15.RadioButton3.Caption;
    if Form15.RadioButton4.Checked = True then sOpcoes := Form15.RadioButton4.Caption;
    if Form15.RadioButton5.Checked = True then sOpcoes := Form15.RadioButton5.Caption;
    ArqIni.WriteString('CONFIG', 'Número de etiquetas', sOpcoes);
    ArqIni.Free;
  end;
  
  Form35.ComboBox1.Items := Form15.ComboBox1.Items;
  Form35.ComboBox1.Text  := Form15.ComboBox1.Text;

  Form35.ShowModal;
  Form15.ComboBox1Change(Sender);
end;


procedure TForm15.Button5Click(Sender: TObject);
var
  j, k, i, iContato, iCont, iColuna, iLinha, iTamanho, iMala, iColMat, iQtde, iPage, iPageCont, iMoeda : Integer;
  fLinha, fTempLinha, fTempColuna, fLiNaEtiqueta, FTamanhoDoTexto, fLarguraDoTexto : Double;
  sNomeCampo1, sNomeCampo2, sNomeCampo3, sNomeCampo4, sNomeCampo5, sPortaImpressao, sFiltro : String;
  sDescMatricial, sMatricial1, sMatricial2, sMatricial3, sMatricial4, sMatricial5, sMatricial6, sMatricial7, sMatricial8, sAux : string;
  fContinua : Boolean;
  ArqIni, Arquivo_De_Etiquetas : TIniFile;
  F : TextFile;
  MeuBookMark : TBookMark;
begin
  //
  try
    Screen.Cursor := crHourGlass; // Cursor de Aguardo
    MeuBookMark  := ibDataset1.GetBookmark;
    sFiltro := ibDataset1.Filter;
    //
    if RadioButton6.Checked then
    begin
      sNomeCampo1 := '';
      Form7.ibDataset40.First;
      while not Form7.ibDataset40.Eof do
      begin
        sNomeCampo1 := sNomeCampo1 + 'codigo=''' + Form7.ibDataset40.FieldByName('CODIGO').AsString + '''';
        Form7.ibDataset40.Next;
        if not Form7.ibDataset40.Eof then sNomeCampo1 := sNomeCampo1 + ' or ';
      end;
      ibDataset1.Filter := sNomeCampo1;
      ibDataset1.Filtered := True;
    end;
    //
    //
    Form35.Close;
    //
    fContinua := False;
    Form35.ComboBox1.Items.Text := Form15.ComboBox1.Items.Text;
    Form35.ComboBox1.Text := Form15.ComboBox1.Text;
    Form35.FormActivate(Sender);
    //
    if Form7.sModulo = 'ESTOQUE' then Form15.CheckBox1Click(Sender) else Form15.CheckBox2Click(Sender);
    //
    for i := 0 to Form35.ComboBox1.Items.Count do if Form35.ComboBox1.text = Form35.ComboBox1.Items.Strings[i] then fContinua := True;
    if Form35.ComboBox1.Text <> 'Tamanho personalizado pelo usuário...' then fContinua := True;
    if fContinua = False then
    begin
      //MessageDlg('Escolha um modelo de etiquetas válido !', MtWarning, [mbok], 0); Mauricio Parizotto 2023-10-25
      MensagemSistema('Escolha um modelo de etiquetas válido !',msgAtencao);
      Exit;
    end;
    if TotalDeColunas(Form35.Edit7.text) = False then Exit;
    // Caso for selecionada impressora matricial, não é possível escolher o intervalo de páginas
    // Se encontrar alguma medida com decimais, muda a impressora pra Jato de Tinta
    if Form35.ComboBox2.Text = 'Matricial' then PrintDialog1.Options := [];
    {Caso confirmada a impressão}
    if PrintDialog1.Execute then
    begin
      printer.Title := 'Imprimindo etiquetas';
      sNomeCampo1 := '';
      sNomeCampo2 := '';
      sNomeCampo3 := '';
      sNomeCampo4 := '';
      sNomeCampo5 := '';
      iMala := 0;
      iMoeda := 0;
      iContato := 0;
      {Caso for selecionada a opção de impressão de mala direta, são direcionados os campos padrão}
      if (Form15.CheckBox2.State <> cbUnchecked) and (Form7.sModulo <> 'ESTOQUE') Then
      begin
        sInformacao[1] := 'NOME';
        sInformacao[2] := 'CONTATO';
        sInformacao[3] := 'ENDERE';
        sInformacao[4] := 'COMPLE';
        sInformacao[5] := 'CEP';
        iContato := 4;
        if CheckBox2.State = cbChecked then iMala := 4;
      end;
      // Inicializa o arquivo smallcom
      ArqIni := TInifile.Create(Form1.sAtual + '\smallcom.inf');
      // Inicializa o arquivo de etiquetas
      Arquivo_De_Etiquetas := TInifile.Create(Form1.sAtual + '\etiquetas.inf');
      Arquivo_De_Etiquetas.UpdateFile;
      // Caso for selecionada a opção de imprimir o nome do campo, é chamada a função que converte o nome do campo
      // para o estilo português
      if (Form35.RadioButton1.Checked = True) and (Form35.RadioButton1.Enabled = True) then
      begin
        sNomeCampo1 := NomeDoCampo(sInformacao[1]);
        sNomeCampo2 := NomeDoCampo(sInformacao[2]);
        sNomeCampo3 := NomeDoCampo(sInformacao[3]);
        sNomeCampo4 := NomeDoCampo(sInformacao[4]);
        sNomeCampo5 := NomeDoCampo(sInformacao[5]);
      end;
      //
      iColuna           := 1;
      iLinha            := 1;
      fContinua         := True;
      fLinha            := Altura(StrToFloat(Form35.Edit3.Text)+2); // Margem Superior
      fTempLinha        := 0;
      sAux              := '';
      fLiNaEtiqueta     := 0;
      j                 := 0;
      iQtde             := 0;
      //
      Screen.Cursor := crHourGlass; // Cursor de Aguardo
      if CheckBox3.Checked = False then ibDataset1.First;
      {XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
      {XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
      //
      // IMPRESSÃO EM IMPRESSORA MATRICIAL}
      //
      if Form35.ComboBox2.Text = 'Matricial' then
      begin
        Delete(sPortaImpressao, 1, Pos(' on', sPortaImpressao) + 3);
        sPortaImpressao := PortaDaImpressora(printer.Printers[printer.PrinterIndex]);
        //sPortaImpressao := 'c:\wagner.txt';//
        AssignFile(F, sPortaImpressao);
        Rewrite(F);
        //
        while (fContinua = true) and (Form15.Button7.tag = 0) do
        begin
            while (iColuna <= StrToInt(Form35.edit7.text)) and (Button7.tag = 0) do
            begin
              if (Form15.RadioButton4.Checked) and (iQtde <= 0) then
              begin
                if VerificaAlteracoes = False then
                begin
                  CloseFile(F);
                  Form15.Close;
                  Form35.ComboBox2.Tag  := 0;
                  exit;
                end;
              end else
              begin
                while (not ibDataset1.Eof) and (ibDataset1.FieldByName('ATIVO').AsString='1') do ibDataset1.Next;
              end;

              // alteração 2004 - permite escolher a quantidade de etiquetas para clientes e fornecedores
              if iQtde <= 0 then if Form7.sModulo = 'ESTOQUE' then iQtde := VerQuantidade else iQtde := StrToInt(Label7.Caption); //iQtde := VerQuantidade;
              //
              sMatricial1 := '';
              sMatricial2 := '';
              sMatricial3 := '';
              sMatricial4 := '';
              sMatricial5 := '';
              sMatricial6 := '';
              sMatricial7 := '';
              sMatricial8 := '';
              //
              I       := 1;
              iLinha  := 5;
              iColMat := 1;
              //
              While I <= StrToInt(Form35.Edit7.Text) do
              begin

                 // Preciso descobrir qual a linha que imprime o campo DESCRICAO
                 for k:=1 to 5 do if UpperCase(sInformacao[k]) = 'DESCRICAO' then j:=k;
                 sDescMatricial := '';

                 While (iColMat < (StrToInt(Form35.Edit8.Text) - StrToInt(Form35.Edit6.Text))) do
                 begin

                    {Se for selecionada a opção de comentário}
                    if Form35.CheckBox3.Checked = True then
                       sMatricial1 := sMatricial1 + Copy(Form35.Edit2.Text, iColMat, 1);

                    // coluna 2
                    if sInformacao[1] <> '' then
                    begin
                      if j = 1 then sDescMatricial := sDescMatricial + Copy(Copy('A: ' ,0,iMala) + sNomeCampo1 + ibDataset1.FieldByName(sInformacao[j]).asString, iColMat, 1);
                      if ibDataset1.FieldByName(sInformacao[1]).DataType = ftFloat then
                         sMatricial2 := sMatricial2 + Copy(Copy('A: ' ,0,iMala) + sNomeCampo1 + Format('%8.' + ArqIni.ReadString('outros', 'Casas decimais no preço', '2') + 'f', [ibDataset1.FieldByName(sInformacao[1]).AsFloat]), iColMat, 1)
                      else
                         sMatricial2 := sMatricial2 + Copy(Copy('A: ' ,0,iMala) + sNomeCampo1 + ibDataset1.FieldByName(sInformacao[1]).asString, iColMat, 1);
                    end;
                    // coluna 3
                    if sInformacao[2] <> '' then
                    begin
                      if j = 2 then sDescMatricial := sDescMatricial + Copy(Copy('A: ' ,0,iMala) + sNomeCampo2 + ibDataset1.FieldByName(sInformacao[j]).asString, iColMat, 1);
                      if ibDataset1.FieldByName(sInformacao[2]).DataType = ftFloat then
                         sMatricial3 := sMatricial3 + Copy(Copy('A/c ',0,iContato) + sNomeCampo2 + Format('%8.' + ArqIni.ReadString('outros', 'Casas decimais no preço', '2') + 'f', [ibDataset1.FieldByName(sInformacao[2]).AsFloat]), iColMat, 1)
                      else
                         sMatricial3 := sMatricial3 + Copy(Copy('A/c ',0,iContato) + sNomeCampo2 + ibDataset1.FieldByName(sInformacao[2]).asString, iColMat, 1);
                    end;
                    // coluna 4
                    if sInformacao[3] <> '' then
                    begin
                      if j = 3 then sDescMatricial := sDescMatricial + Copy(Copy('A: ' ,0,iMala) + sNomeCampo3 + ibDataset1.FieldByName(sInformacao[j]).asString, iColMat, 1);
                      if ibDataset1.FieldByName(sInformacao[3]).DataType = ftFloat then
                         sMatricial4 := sMatricial4 + Copy(sNomeCampo3 + Format('%8.' + ArqIni.ReadString('outros', 'Casas decimais no preço', '2') + 'f', [ibDataset1.FieldByName(sInformacao[3]).AsFloat]), iColMat, 1)
                      else
                         sMatricial4 := sMatricial4 + Copy(sNomeCampo3 + ibDataset1.FieldByName(sInformacao[3]).asString, iColMat, 1);
                    end;

                    // coluna 5
                    if sInformacao[4] <> ''  then
                    begin
                      if j = 4 then sDescMatricial := sDescMatricial + Copy(Copy('A: ' ,0,iMala) + sNomeCampo4 + ibDataset1.FieldByName(sInformacao[j]).asString, iColMat, 1);
                      if ibDataset1.FieldByName(sInformacao[4]).DataType = ftFloat then
                         sMatricial5 := sMatricial5 + Copy(sNomeCampo4 + Format('%8.' + ArqIni.ReadString('outros', 'Casas decimais no preço', '2') + 'f', [ibDataset1.FieldByName(sInformacao[4]).AsFloat]), iColMat, 1)
                      else
                         sMatricial5 := sMatricial5 + Copy(sNomeCampo4 + ibDataset1.FieldByName(sInformacao[4]).asString, iColMat, 1);
                    end;

                    //coluna 6
                    if sInformacao[5] <> '' then
                    begin
                      if j = 5 then sDescMatricial := sDescMatricial + Copy(Copy('A: ' ,0,iMala) + sNomeCampo5 + ibDataset1.FieldByName(sInformacao[j]).asString, iColMat, 1);
                      if ibDataset1.FieldByName(sInformacao[5]).DataType = ftFloat then
                         sMatricial6 := sMatricial6 + Copy(sNomeCampo5 + Format('%8.' + ArqIni.ReadString('outros', 'Casas decimais no preço', '2') + 'f', [ibDataset1.FieldByName(sInformacao[5]).AsFloat]), iColMat, 1)
                      else
                         sMatricial6 := sMatricial6 + Copy(sNomeCampo5 + ibDataset1.FieldByName(sInformacao[5]).asString, iColMat, 1);
                    end;

                    {Se for selecionada a opção de mala direta}
                    if iContato > 1 then
                       sMatricial7 := sMatricial7 + copy(ibDataset1.FieldByName('CIDADE').asString + ' - ' +
                       ibDataset1.FieldByName('ESTADO').asString, iColMat, 1);

                    //
                    Inc(iColMat);
                 end;

                 // Smatricial8 = campo utilizado para imprimir 2 linhas da descricao (quando possível)
                 if j = 1 then sMatricial8 := sMatricial8 + copy(sNomeCampo1 + ibDataset1.FieldByName(sInformacao[j]).asString, Length(sDescMatricial) + 1, Length(sDescMatricial));
                 if j = 2 then sMatricial8 := sMatricial8 + copy(sNomeCampo2 + ibDataset1.FieldByName(sInformacao[j]).asString, Length(sDescMatricial) + 1, Length(sDescMatricial));
                 if j = 3 then sMatricial8 := sMatricial8 + copy(sNomeCampo3 + ibDataset1.FieldByName(sInformacao[j]).asString, Length(sDescMatricial) + 1, Length(sDescMatricial));
                 if j = 4 then sMatricial8 := sMatricial8 + copy(sNomeCampo4 + ibDataset1.FieldByName(sInformacao[j]).asString, Length(sDescMatricial) + 1, Length(sDescMatricial));
                 if j = 5 then sMatricial8 := sMatricial8 + copy(sNomeCampo5 + ibDataset1.FieldByName(sInformacao[j]).asString, Length(sDescMatricial) + 1, Length(sDescMatricial));

                 if iContato > 1 then sMatricial5 := sMatricial5 + ' - ' + sMatricial6;

                 iQtde := iQtde - 1;
                 if iQtde <= 0 then
                 begin
                   while (not ibDataset1.eof) and (iQtde <= 0) do
                   begin
                     if Form15.RadioButton4.Checked then
                     begin
                       if VerificaAlteracoes = False then
                       begin
                         CloseFile(F);
                         Form15.Close;
                         Form35.ComboBox2.Tag  := 0;
                         exit;
                       end;
                     end else
                     begin
                       ibDataset1.Next;
                       Application.ProcessMessages;     { Permite ler outros processos que sejam executados}
                       while (not ibDataset1.Eof) and (ibDataset1.FieldByName('ATIVO').AsString='1') do
                       begin
                         ibDataset1.Next;
                         Application.ProcessMessages;     { Permite ler outros processos que sejam executados}
                       end;
                     end;

                     // alteração 2004 - permite escolher a quantidade de etiquetas para clientes e fornecedores
                     if Form7.sModulo = 'ESTOQUE' then iQtde := VerQuantidade else iQtde := StrToInt(Label7.Caption);
                     //                   iQtde := VerQuantidade;
                   end;
                 end;
                 //
                 iColMat := 1;
                 Form35.Edit7.Tag := I;
                 //
                 sMatricial1 := sMatricial1 + replicate(' ', ((StrToInt(Form35.Edit8.Text) - StrToInt(Form35.Edit6.Text)) * I) - Length(sMatricial1));
                 sMatricial2 := sMatricial2 + replicate(' ', ((StrToInt(Form35.Edit8.Text) - StrToInt(Form35.Edit6.Text)) * I) - Length(sMatricial2));
                 sMatricial3 := sMatricial3 + replicate(' ', ((StrToInt(Form35.Edit8.Text) - StrToInt(Form35.Edit6.Text)) * I) - Length(sMatricial3));
                 sMatricial4 := sMatricial4 + replicate(' ', ((StrToInt(Form35.Edit8.Text) - StrToInt(Form35.Edit6.Text)) * I) - Length(sMatricial4));
                 sMatricial5 := sMatricial5 + replicate(' ', ((StrToInt(Form35.Edit8.Text) - StrToInt(Form35.Edit6.Text)) * I) - Length(sMatricial5));
                 sMatricial6 := '';
                 sMatricial7 := sMatricial7 + replicate(' ', ((StrToInt(Form35.Edit8.Text) - StrToInt(Form35.Edit6.Text)) * I) - Length(sMatricial7));
                 sMatricial8 := sMatricial8 + replicate(' ', ((StrToInt(Form35.Edit8.Text) - StrToInt(Form35.Edit6.Text)) * I) - Length(sMatricial8));
                 //
                 Inc(I);
                 if ibDataset1.Eof then I := StrToInt(Form35.Edit7.Text) + 1;
              end;

              {Verifica o número de linhas que deve deixar em branco (margem superior)}
              if Form35.ComboBox2.Tag = 0 then
              begin
                 Write(F, CHR(15)); {comprime a impressão}
                 For I := 1 to StrToInt(Form35.Edit3.Text) do WriteLn(F,'');
                 Form35.ComboBox2.Tag := 1;
              end;

              {Se a impressora não for de 132 colunas, as informações que ultrapassam esta coluna são apagadas}
              if StrToInt(Form35.Edit4.Text) < 132 then
              begin
                 sMatricial1 := rTrim(Copy(sMatricial1,1,132));
                 sMatricial2 := rTrim(Copy(sMatricial2,1,132));
                 sMatricial3 := rTrim(Copy(sMatricial3,1,132));
                 sMatricial4 := rTrim(Copy(sMatricial4,1,132));
                 sMatricial5 := rTrim(Copy(sMatricial5,1,132));
                 sMatricial6 := rTrim(Copy(sMatricial6,1,132));
                 sMatricial7 := rTrim(Copy(sMatricial7,1,132));
                 sMatricial8 := rTrim(Copy(sMatricial8,1,132));
              end;

              {Imprime as informações}
              if Alltrim(sMatricial8) <> '' then k := 1 else k := 0;

              if StrToInt(Form35.Edit1.Text) >= 1 + k Then WriteLn(F, ConverteAcentos(sMatricial1));
              if (j = 1) and (Alltrim(sMatricial8) <> '') then WriteLn(F, ConverteAcentos(sMatricial8)); //
              if StrToInt(Form35.Edit1.Text) >= 2 + k Then WriteLn(F, ConverteAcentos(sMatricial2));
              if (j = 2) and (Alltrim(sMatricial8) <> '') then WriteLn(F, ConverteAcentos(sMatricial8)); //
              if StrToInt(Form35.Edit1.Text) >= 3 + k Then WriteLn(F, ConverteAcentos(sMatricial3));
              if (j = 3) and (Alltrim(sMatricial8) <> '') then WriteLn(F, ConverteAcentos(sMatricial8)); //
              if StrToInt(Form35.Edit1.Text) >= 4 + k Then WriteLn(F, ConverteAcentos(sMatricial4));
              if (j = 4) and (Alltrim(sMatricial8) <> '') then WriteLn(F, ConverteAcentos(sMatricial8)); //
              if StrToInt(Form35.Edit1.Text) >= 5 + k Then WriteLn(F, ConverteAcentos(sMatricial5));
              if (j = 5) and (Alltrim(sMatricial8) <> '') then WriteLn(F, ConverteAcentos(sMatricial8)); //

              { Se for selecionado para imprimir campo comentário, neste momento o mesmo é impresso}
              if Form35.CheckBox3.Checked = True then
              begin
                 if StrToInt(Form35.Edit1.Text) >= 7 Then WriteLn(F, ConverteAcentos(sMatricial7));
                 Inc(iLinha)
              end;
              //
              for I := 1 to StrToInt(Form35.Edit1.Text) - iLinha do WriteLn(F, ' ');
              //
              iColuna := iColuna + 1;
              if ibDataset1.Eof then {Caso chegue no final do arquivo, automaticamente é cancelado o while}
              begin
                 fContinua := False;
                 iColuna := StrToInt(Form35.Edit7.text) + 1;
              end;
           end;
           iColuna := 1;
        end;
        CloseFile(F);
        Form35.ComboBox2.Tag := 0;
      end else
      begin
  /////////////////////////////////////////////////////
        //
        // IMPRESSÃO EM JATO DE TINTA OU IMPRESSORA LASER
        //
        printer.BeginDoc;
        Printer.Canvas.Font.Name := 'Arial';
        //
        // alteração 2004 - permite escolher a quantidade de etiquetas para clientes e fornecedores
        //
        if Form7.sModulo = 'ESTOQUE' then iQtde := 0 else iQtde := StrToInt(Label7.Caption);
        //
        while (fContinua = true) and (Form15.Button7.tag = 0) do
        begin
          //
          while (iColuna <= StrToInt(Form35.edit7.text)) and (Button7.tag = 0) do
          begin
            //
            // Pula algumas etiquetas para iniciar da etiqueta certa
            //
{           if StrToInt(LimpaNumero(Label13.Caption)) <> 1 then
            begin
              //
              iLinha  := (StrToInt(LimpaNumero(Label13.Caption)) div StrToInt(Form35.edit7.text)) + 1;
              iColuna := (iLinha * StrToInt(Form35.edit7.text)) - StrToInt(LimpaNumero(Label13.Caption)) - 1;
              Label13.Caption := '1';
              //
              if iLinha >= 2 Then
              begin
                 fTempLinha := fTempLinha + StrToFloat(Form35.Edit1.Text);         // Altura da etiqueta
                 fLinha     := Altura(fTempLinha + StrToFloat(Form35.Edit3.Text)); // Margem Superior
              end;
              //
            end;
}
            //
            printer.canvas.font.size := StrToInt(Arquivo_De_Etiquetas.ReadString(ComboBox1.Text, 'Fonte', '8'));
            if (Form15.RadioButton4.Checked) and (iQtde <= 0) then
            begin
              if VerificaAlteracoes = False then
              begin
                Printer.EndDoc;
                Form15.Close;
                Form35.ComboBox2.Tag  := 0;
                exit;
              end;
            end;
            
            // Calcula a Coluna
            fTempColuna := Largura(                                      // Converte mm em largura
                        (iColuna * ( StrToFloat(Form35.Edit8.Text) + 3)) // Coluna vezes a largura
                        -StrToFloat(Form35.Edit8.Text)                   // Desconta a primeira
                        +StrToFloat(Form35.Edit6.Text)+2                 // Margem Esquerda
                        );

            if StrToInt(LimpaNumero(Label13.Caption)) = 1 then
            begin
              if (Form7.sModulo = 'ESTOQUE') and (iQtde = 0) then iQtde := VerQuantidade;
              //
              {Impressão de código de barras}
              if (Form35.CheckBox4.Checked = True) then //and ((iPage > PrintDialog1.FromPage) and (iPage < PrintDialog1.ToPage)) then
              begin
                if Form35.CheckBox1.Checked then Printer.canvas.TextOut(Printer.PageWidth - (Printer.Canvas.TextWidth(IntToStr(printer.PageNumber))), 10, IntToStr(printer.PageNumber));
                if (Length(ibDataset1.FieldByName('REFERENCIA').AsString) > 5) and (ibDataset1.FieldByName('ATIVO').AsString<>'1') and (iQtde > 0) then
                begin
                  printer.canvas.font.size := StrToInt(Arquivo_De_Etiquetas.ReadString(ComboBox1.Text, 'FonteB', '14'));
                  printer.Canvas.Font.Name := '3 of 9 Barcode';
                  printer.Canvas.TextOut(Round(fTempColuna), Round(fLinha), '*' + ibDataset1.FieldByName('REFERENCIA').AsString + '*');
                  printer.Canvas.TextOut(Round(fTempColuna), Round(fLinha) + Printer.Canvas.TextHeight(ibDataset1.FieldByName('REFERENCIA').AsString), '*' + ibDataset1.FieldByName('REFERENCIA').AsString + '*');
                  printer.Canvas.TextOut(Round(fTempColuna), Round(fLinha) + (Printer.Canvas.TextHeight(ibDataset1.FieldByName('REFERENCIA').AsString) * 2), '*' + ibDataset1.FieldByName('REFERENCIA').AsString + '*');

                  fTamanhoDoTexto := Printer.Canvas.TextHeight(ibDataset1.FieldByName('REFERENCIA').AsString) * 3;
                  fLarguraDoTexto := Printer.Canvas.TextWidth(ibDataset1.FieldByName('REFERENCIA').AsString);
                  printer.Canvas.Font.Size := Form35.SpinEdit1.Value;
                  printer.Canvas.Font.Name := 'Arial';
                  printer.canvas.Font.size := StrToInt(Arquivo_De_Etiquetas.ReadString(ComboBox1.Text, 'Fonte', '8'));

                  {Imprime o código de barras na fonte arial}
                  printer.Canvas.TextOut(Round(fTempColuna) + Round(((fLarguraDoTexto -
                  printer.Canvas.TextWidth(ibDataset1.FieldByName('REFERENCIA').AsString)) / 2) * 1.3),
                  Round(fLinha) + Round(fTamanhoDoTexto), ibDataset1.FieldByName('REFERENCIA').AsString);
                  fTamanhoDoTexto := fTamanhoDoTexto + Round(fLinha) + Round(printer.Canvas.TextHeight(ibDataset1.FieldByName('REFERENCIA').AsString));

                  {Imprime o nome do produto se o mesmo foi selecionado}
                  if Form35.CheckBox5.Checked = True then
                  begin
                    printer.Canvas.TextOut(Round(fTempColuna), Round(fTamanhoDoTexto), ibDataset1.FieldByName('DESCRICAO').AsString);
                    fTamanhoDoTexto := fTamanhoDoTexto + Round(printer.Canvas.TextHeight(ibDataset1.FieldByName('DESCRICAO').AsString));
                  end;

                  {Imprime o preço do produto se o mesmo foi selecionado}
                  if Form35.CheckBox6.Checked = True then
                  begin
                    printer.Canvas.Font.Style := [fsbold];
                    printer.canvas.font.size := StrToInt(Arquivo_De_Etiquetas.ReadString(ComboBox1.Text, 'FontePreco', '8'));
                    printer.Canvas.TextOut(Round(fTempColuna), Round(fTamanhoDoTexto), 'R$' + Format('%8.' + ArqIni.ReadString('outros', 'Casas decimais no preço', '2') + 'f', [ibDataset1.FieldByName('PRECO').AsFloat]));
                    fTamanhoDoTexto := fTamanhoDoTexto + printer.Canvas.TextHeight('R$' + Format('%8.' + ArqIni.ReadString('outros', 'Casas decimais no preço', '2') + 'f', [ibDataset1.FieldByName('PRECO').AsFloat]));
                    printer.canvas.font.size := StrToInt(Arquivo_De_Etiquetas.ReadString(ComboBox1.Text, 'Fonte', '8'));
                    printer.Canvas.Font.Style := [];
                  end;

                  {Imprime o campo comentário se o mesmo foi selecionado}
                  if Form35.CheckBox3.Checked = True then
                  begin
                    Printer.Canvas.Font.color := StrToInt(Arquivo_De_Etiquetas.ReadString('CONFIG', 'ComenCor', 'clBlack'));
                    printer.Canvas.TextOut(Round(fTempColuna),Round(fTamanhoDoTexto), Form35.Edit2.Text);
                    Printer.Canvas.Font.color := clBlack;
                  end;


                  if (ibDataset1.FieldByName('ATIVO').AsString<>'1') and (iQtde > 0) then inc(iColuna);// := iColuna + 1;
                end;
              end else if (ibDataset1.FieldByName('ATIVO').AsString<>'1') and (iQtde > 0) then
              begin
                 //
                 // Número da página
                 //
                 if Form35.CheckBox1.Checked then Printer.canvas.TextOut(Printer.PageWidth - (Printer.Canvas.TextWidth(IntToStr(printer.PageNumber))), 10, IntToStr(printer.PageNumber));
                 //
                 fLiNaEtiqueta := 0; // Incremento da Linha dentro de cada Etiqueta
                 //
                 // Impressão do campo comentário
                 //
                 if Form35.CheckBox3.Checked = True then
                 begin
                   if (iContato = 0) or ( Form7.sModulo = 'ESTOQUE') then Printer.Canvas.Font.Color := StrToInt(Arquivo_De_Etiquetas.ReadString('CONFIG', 'ComenCor', 'clBlack'));
                   Printer.Canvas.Font.Size  := StrToInt(Arquivo_De_Etiquetas.ReadString(Form15.ComboBox1.Text , 'Fonte', '8'));
                   //
                   if Pos('FONE:',UpperCase(Form35.Edit2.Text)) <> 0 then
                   begin
                     printer.canvas.TextOut(Round(fTempColuna), Round(fLinha), Form35.Edit2.Text+' '+Form7.ibDataset2FONE.AsString);
                   end else
                   begin
                     printer.canvas.TextOut(Round(fTempColuna), Round(fLinha), Form35.Edit2.Text);
                   end;
                   //
                   Printer.Canvas.Font.color := clBlack;
                   fLiNaEtiqueta := fLiNaEtiqueta + printer.Canvas.TextHeight( Form35.Edit2.Text ) + (printer.Canvas.TextHeight( Form35.Edit2.Text ) * 0.10); //
                 end;
                 //
                 // Final do Comentário
                 //
                 if sInformacao[1] <> '' then
                 begin
                   if UpperCase(sInformacao[1]) = 'PRECO' then
                   begin
                     Printer.Canvas.Font.Style := [fsbold];
                     printer.canvas.font.size := StrToInt(Arquivo_De_Etiquetas.ReadString(ComboBox1.Text, 'FontePreco', '8'));
                     iMoeda := 3; // Apresentar o R$ na impressão do preço
                   end;
                   //
                   if ibDataset1.FieldByName(sInformacao[1]).DataType = ftFloat then
                      printer.canvas.TextOut(Round(fTempColuna), Round(fLinha) + Round(fLiNaEtiqueta), sNomeCampo1 + Copy('R$ ', 0, iMoeda) + Alltrim(Format('%8.' + ArqIni.ReadString('outros', 'Casas decimais no preço', '2') + 'f', [ibDataset1.FieldByName(sInformacao[1]).AsFloat])))
                   else
                      printer.canvas.TextOut(Round(fTempColuna), Round(fLinha) + Round(fLiNaEtiqueta), Copy('À ',0,iMala) + sNomeCampo1 + ibDataset1.FieldByName(sInformacao[1]).asString );
                   fLiNaEtiqueta := fLiNaEtiqueta + printer.Canvas.TextHeight(sNomeCampo1 + ibDataset1.FieldByName(sInformacao[1]).asString) + (printer.Canvas.TextHeight(ibDataset1.FieldByName(sInformacao[1]).asString) * 0.10); //
                   //
                   Printer.Canvas.Font.Style := [];
                   printer.canvas.font.size := StrToInt(Arquivo_De_Etiquetas.ReadString(ComboBox1.Text, 'Fonte', '8'));
                   iMoeda := 0;
                 end;
                           //coluna 2
                 if sInformacao[2] <> '' then
                 begin
                   if UpperCase(sInformacao[2]) = 'PRECO' then
                   begin
                     Printer.Canvas.Font.Style := [fsbold];
                     printer.canvas.font.size := StrToInt(Arquivo_De_Etiquetas.ReadString(ComboBox1.Text, 'FontePreco', '8'));
                     iMoeda := 3; // Apresentar o R$ na impressão do preço
                   end;
                   //
                   if ibDataset1.FieldByName(sInformacao[2]).DataType = ftFloat then
                   begin
                      printer.canvas.TextOut( Round(fTempColuna), Round(fLinha) + Round(fLiNaEtiqueta), sNomeCampo2 + Copy('R$ ', 0, iMoeda) + Alltrim(Format('%8.' + ArqIni.ReadString('outros', 'Casas decimais no preço', '2') + 'f', [ibDataset1.FieldByName(sInformacao[2]).AsFloat])));
                      fLiNaEtiqueta := fLiNaEtiqueta + printer.Canvas.TextHeight(Copy('A/c ',0,iContato)+ ibDataset1.FieldByName(sInformacao[2]).asString) + (printer.Canvas.TextHeight(ibDataset1.FieldByName(sInformacao[2]).asString) * 0.10 );
                   end else
                   begin
                      if AllTrim(ibDataset1.FieldByName(sInformacao[2]).asString) <> '' then
                      begin
                        printer.canvas.TextOut(Round(fTempColuna), Round(fLinha) + Round(fLiNaEtiqueta), Copy('A/c ',0,iContato) + sNomeCampo2 + ibDataset1.FieldByName(sInformacao[2]).asString);
                        fLiNaEtiqueta := fLiNaEtiqueta + printer.Canvas.TextHeight(Copy('A/c ',0,iContato) + ibDataset1.FieldByName(sInformacao[2]).asString) + (printer.Canvas.TextHeight(ibDataset1.FieldByName(sInformacao[2]).asString) * 0.10); //
                      end;
                   end;
                   //
                   Printer.Canvas.Font.Style := [];
                   printer.canvas.font.size := StrToInt(Arquivo_De_Etiquetas.ReadString(ComboBox1.Text, 'Fonte', '8'));
                   iMoeda := 0;
                 end;
                           //coluna 3
                 if sInformacao[3] <> '' then
                 begin
                   if UpperCase(sInformacao[3]) = 'PRECO' then
                   begin
                    Printer.Canvas.Font.Style := [fsbold];
                    printer.canvas.font.size := StrToInt(Arquivo_De_Etiquetas.ReadString(ComboBox1.Text, 'FontePreco', '8'));
                     iMoeda := 3; // Apresentar o R$ na impressão do preço
                   end;

                   if ibDataset1.FieldByName(sInformacao[3]).DataType = ftFloat then
                      printer.canvas.TextOut(Round(fTempColuna),Round(fLinha) + Round(fLiNaEtiqueta), sNomeCampo3 + Copy('R$ ', 0, iMoeda) + Alltrim(Format('%8.' + ArqIni.ReadString('outros', 'Casas decimais no preço', '2') + 'f', [ibDataset1.FieldByName(sInformacao[3]).AsFloat])))
                   else
                      printer.canvas.TextOut(Round(fTempColuna),Round(fLinha) + Round(fLiNaEtiqueta), sNomeCampo3 + ibDataset1.FieldByName(sInformacao[3]).asString);
                   fLiNaEtiqueta := fLiNaEtiqueta + printer.Canvas.TextHeight(ibDataset1.FieldByName(sInformacao[3]).asString) + (printer.Canvas.TextHeight(ibDataset1.FieldByName(sInformacao[3]).asString) * 0.10); //
                   
                   Printer.Canvas.Font.Style := [];
                   printer.canvas.font.size := StrToInt(Arquivo_De_Etiquetas.ReadString(ComboBox1.Text, 'Fonte', '8'));
                   iMoeda := 0;
                 end;
                           //coluna 4
                 if sInformacao[4] <> '' then
                 begin
                   if UpperCase(sInformacao[4]) = 'PRECO' then
                   begin
                     Printer.Canvas.Font.Style := [fsbold];
                     printer.canvas.font.size := StrToInt(Arquivo_De_Etiquetas.ReadString(ComboBox1.Text, 'FontePreco', '8'));
                     iMoeda := 3; // Apresentar o R$ na impressão do preço
                   end;
                   
                   if ibDataset1.FieldByName(sInformacao[4]).DataType = ftFloat then
                      printer.canvas.TextOut(Round(fTempColuna), Round(fLinha) + Round(fLiNaEtiqueta), sNomeCampo4 + Copy('R$ ', 0, iMoeda) + Alltrim(Format('%8.' + ArqIni.ReadString('outros', 'Casas decimais no preço', '2') + 'f', [ibDataset1.FieldByName(sInformacao[4]).AsFloat])))
                   else
                      printer.canvas.TextOut(Round(fTempColuna), Round(fLinha) + Round(fLiNaEtiqueta), sNomeCampo4 + ibDataset1.FieldByName(sInformacao[4]).asString);
                   fLiNaEtiqueta := fLiNaEtiqueta + printer.Canvas.TextHeight(ibDataset1.FieldByName(sInformacao[4]).asString) + (printer.Canvas.TextHeight(ibDataset1.FieldByName(sInformacao[4]).asString) * 0.10); //
                   //
                   Printer.Canvas.Font.Style := [];
                   printer.canvas.font.size := StrToInt(Arquivo_De_Etiquetas.ReadString(ComboBox1.Text, 'Fonte', '8'));
                   iMoeda := 0;
                 end;
                           {Impressão de mala direta}
                 if iContato > 1 then
                 begin
                   printer.canvas.TextOut(Round(fTempColuna), Round(fLinha)+ Round(fLiNaEtiqueta), ibDataset1.FieldByName('CEP').asString + ' - '+ ibDataset1.FieldByName('CIDADE').asString + ' - ' + ibDataset1.FieldByName('ESTADO').asString);
                   fLiNaEtiqueta := fLiNaEtiqueta + printer.Canvas.TextHeight(ibDataset1.FieldByName('CEP').asString + ' - '+ ibDataset1.FieldByName('CIDADE').asString + ' - ' + ibDataset1.FieldByName('ESTADO').asString) + (printer.Canvas.TextHeight(ibDataset1.FieldByName(sInformacao[5]).asString) * 0.10);
                 end else
                 begin
                   if sInformacao[5] <> '' then
                   begin
                     if UpperCase(sInformacao[5]) = 'PRECO' then
                     begin
                       Printer.Canvas.Font.Style := [fsbold];
                       printer.canvas.font.size := StrToInt(Arquivo_De_Etiquetas.ReadString(ComboBox1.Text, 'FontePreco', '8'));
                       iMoeda := 3; // Apresentar o R$ na impressão do preço
                     end;
                     //
                     if ibDataset1.FieldByName(sInformacao[5]).DataType = ftFloat then
                        printer.canvas.TextOut(Round(fTempColuna), Round(fLinha) + Round(fLiNaEtiqueta), sNomeCampo5 + Copy('R$ ', 0, iMoeda) + Alltrim(Format('%8.' + ArqIni.ReadString('outros', 'Casas decimais no preço', '2') + 'f', [ibDataset1.FieldByName(sInformacao[5]).AsFloat])))
                     else
                        printer.canvas.TextOut(Round(fTempColuna), Round(fLinha) + Round(fLiNaEtiqueta), sNomeCampo5 + ibDataset1.FieldByName(sInformacao[5]).asString);
                   end;
                   //
                   Printer.Canvas.Font.Style := [];
                   printer.canvas.font.size := StrToInt(Arquivo_De_Etiquetas.ReadString(ComboBox1.Text, 'Fonte', '8'));
                   iMoeda := 0;
                 end;
                 if (ibDataset1.FieldByName('ATIVO').AsString<>'1') and (iQtde > 0) then inc(iColuna);
              end;
              //
              iQtde := iQtde - 1;
              if iQtde <= 0 then
              begin
                ibDataset1.Next;
                Application.ProcessMessages;     {Permite ler outros processos que sejam executados}
                // alteração 2005 - permite escolher a quantidade de etiquetas para clientes e fornecedores
                if Form7.sModulo = 'ESTOQUE' then iQtde := 0 else iQtde := StrToInt(Label7.Caption);
              end;
              //
              if ibDataset1.Eof then
              begin
                 fContinua := False;
                 iColuna := StrToInt(Form35.Edit7.text) + 1;
              end;
              //
            end else
            begin
              inc(iColuna);
              Label13.Caption := IntToStr(StrToInt(LimpaNumero(Label13.Caption))-1);
            end;
            //
          end;
          //
          iColuna := 1;
          Inc(iLinha);
          {Caso pule para a 2º linha, é criada uma variável que verifica em que posição irá ficar a próxima linha}
          if iLinha >= 2 Then
          begin
             fTempLinha := fTempLinha + StrToFloat(Form35.Edit1.Text);         // Altura da etiqueta
             fLinha     := Altura(fTempLinha + StrToFloat(Form35.Edit3.Text)); // Margem Superior
          end;
          {Caso chegar no final da folha, é ejetada a mesma e puxada outra para dar continuidade à impressão}
          if iLinha > StrToInt(Form35.Edit9.text) then // Passou do tamanho da etiqueta
          begin
            fLinha     := Altura(StrToFloat(Form35.Edit3.Text));
            fTempLinha := 0;
            iLinha     := 1;
            Inc(iPage);
            if not ibDataset1.eof then printer.NewPage;
          end;
        end;
        Printer.Enddoc;
        // Caso a impressão seja interrompida
        if Button7.Tag = 1 then
          //MessageDlg('Impressão interrompida pelo usuário !', mtWarning, [mbOk], 0); Mauricio Parizotto 2023-10-25
          MensagemSistema('Impressão interrompida pelo usuário !',msgAtencao);
      end;

      ibDataset1.Filter := sFiltro;
      ibDataset1.EnableControls;
      Form15.Close;
      ibDataset1.GotoBookmark(MeuBookMark);
      Form35.ComboBox2.Tag  := 0;
    end;
  except
  end;
  Screen.Cursor  := crDefault;
end;

procedure TForm15.FormActivate(Sender: TObject);
var
  ArqIni : TiniFile;
  sOpcoes : String;
  I, J : Integer;
  F      : TextFile;
begin
  Form15.Image1.Picture := Form7.imgImprimir.Picture;
  //
  if (not FileExists(Form1.sAtual + '\etiquetas.inf')) and (AllTrim(Form1.sAtual) <> '')  then
  begin
    AssignFile(F, Form1.sAtual + '\etiquetas.inf');
    Rewrite(F);
    WriteLn(F, '[CONFIG]');
    WriteLn(F, 'Número de etiquetas=Em estoque');
    WriteLn(F, 'Opcoes=FFT');
    WriteLn(F, 'Opcoes15=TFF');
    WriteLn(F, 'Barras=FFF');
    WriteLn(F, 'Comentário=F');
    WriteLn(F, 'ComenTexto=DESTINATARIO');
    WriteLn(F, 'ComenCor=$00000040');
    WriteLn(F, '');
//    WriteLn(F, '[ETIQUETAS PARA IMPRESSORA JATO DE TINTA OU LASER]');
//    WriteLn(F,'');
    //
    // Pequenas
    //
    WriteLn(F,'[A4251 - A4 Pimaco 13 X 5 (65 Etiquetas por folha)]');
    Writeln(F,'Margem superior=10');
    Writeln(F,'Margem esquerda=10');
    Writeln(F,'Altura da pagina=297');
    Writeln(F,'Largura da pagina=210');
    Writeln(F,'Tamanho vertical=21,2');
    Writeln(F,'Tamanho horizontal=38,2');
    Writeln(F,'Linhas por folha=13');
    Writeln(F,'Etiquetas por linha=5');
    Writeln(F,'Fonte=8');
    Writeln(F,'FontePreco=8');
    Writeln(F,'FonteB=11');
    Writeln(F,'Impressora=Jato de tinta');
    //
    // Endereçamento pequenas
    //
    WriteLn(F,'[A4256 - A4 Pimaco 11 X 3 (33 Etiquetas por folha)]');
    Writeln(F,'Margem superior=10');
    Writeln(F,'Margem esquerda=10');
    Writeln(F,'Altura da pagina=297');
    Writeln(F,'Largura da pagina=210');
    Writeln(F,'Tamanho vertical=25,4');
    Writeln(F,'Tamanho horizontal=63,5');
    Writeln(F,'Linhas por folha=11');
    Writeln(F,'Etiquetas por linha=3');
    Writeln(F,'Fonte=8');
    Writeln(F,'FontePreco=8');
    Writeln(F,'FonteB=8');
    Writeln(F,'Impressora=Jato de tinta');
    //
    // Endereçamento pequenas
    //
    WriteLn(F,'[6280 - Carta Pimaco 10 X 3 (30 Etiquetas por folha)]');
    Writeln(F,'Margem superior=14');
    Writeln(F,'Margem esquerda=5');
    Writeln(F,'Altura da pagina=279,4');
    Writeln(F,'Largura da pagina=215,9');
    Writeln(F,'Tamanho vertical=25,4');
    Writeln(F,'Tamanho horizontal=66,7');
    Writeln(F,'Linhas por folha=10');
    Writeln(F,'Etiquetas por linha=3');
    Writeln(F,'Fonte=8');
    Writeln(F,'FontePreco=8');
    Writeln(F,'FonteB=8');
    Writeln(F,'Impressora=Jato de tinta');
    //
    // Herdadas
    //
    WriteLn(F, '[50,8mm x 101,6mm - 5 linhas e 2 colunas (10 etiquetas por folha)]');
    Writeln(F, 'Margem superior=14');
    Writeln(F, 'Margem esquerda=6');
    Writeln(F, 'Altura da pagina=279');
    Writeln(F, 'Largura da pagina=216');
    Writeln(F, 'Tamanho vertical=51');
    Writeln(F, 'Tamanho horizontal=101');
    Writeln(F, 'Linhas por folha=5');
    Writeln(F, 'Etiquetas por linha=2');
    Writeln(F, 'Fonte=7');
    Writeln(F, 'FonteB=14');
    Writeln(F, 'Impressora=Jato de tinta');
    WriteLn(F,'');
    WriteLn(F, '[38,1mm x 99,0mm - 7 linhas e 2 colunas (14 etiquetas por folha)]');
    Writeln(F, 'Margem superior=16');
    Writeln(F, 'Margem esquerda=7');
    Writeln(F, 'Altura da pagina=298');
    Writeln(F, 'Largura da pagina=211');
    Writeln(F, 'Tamanho vertical=38');
    Writeln(F, 'Tamanho horizontal=99');
    Writeln(F, 'Linhas por folha=7');
    Writeln(F, 'Etiquetas por linha=2');
    Writeln(F, 'Fonte=7');
    Writeln(F, 'FonteB=14');
    Writeln(F, 'Impressora=Jato de tinta');
    WriteLn(F,'');



    WriteLn(F, '[25,4mm x 101,6mm - 10 linhas e 2 colunas (20 etiquetas por folha)]');
    Writeln(F, 'Margem superior=15');
    Writeln(F, 'Margem esquerda=7');
    Writeln(F, 'Altura da pagina=279');
    Writeln(F, 'Largura da pagina=216');
    Writeln(F, 'Tamanho vertical=25');
    Writeln(F, 'Tamanho horizontal=101');
    Writeln(F, 'Linhas por folha=10');
    Writeln(F, 'Etiquetas por linha=2');
    Writeln(F, 'Fonte=7');
    Writeln(F, 'FonteB=14');
    Writeln(F, 'Impressora=Jato de tinta');
    WriteLn(F,'');

    WriteLn(F, '[25,4mm x 66,7mm - 10 linhas e 3 colunas (30 etiquetas por folha)]');
    Writeln(F, 'Margem superior=15');
    Writeln(F, 'Margem esquerda=7');
    Writeln(F, 'Altura da pagina=279');
    Writeln(F, 'Largura da pagina=216');
    Writeln(F, 'Tamanho vertical=25');
    Writeln(F, 'Tamanho horizontal=67');
    Writeln(F, 'Linhas por folha=10');
    Writeln(F, 'Etiquetas por linha=3');
    Writeln(F, 'Fonte=7');
    Writeln(F, 'FonteB=14');
    Writeln(F, 'Impressora=Jato de tinta');
//    WriteLn(F, '[-----------------------------------]');
//    WriteLn(F, '[ETIQUETAS PARA IMPRESSORA MATRICIAL]');
//    WriteLn(F,'');
    WriteLn(F, '[ - Formulário contínuo - 8 linhas e 1 coluna (8 etiquetas por folha)]');
    Writeln(F, 'Margem superior=0');
    Writeln(F, 'Margem esquerda=0');
    Writeln(F, 'Altura da pagina=72');
    Writeln(F, 'Largura da pagina=72');
    Writeln(F, 'Tamanho vertical=9');
    Writeln(F, 'Tamanho horizontal=70');
    Writeln(F, 'Linhas por folha=8');
    Writeln(F, 'Etiquetas por linha=1');
    Writeln(F, 'Fonte=7');
    Writeln(F, 'Impressora=Matricial');
    WriteLn(F,'');
    WriteLn(F, '[ - Formulário contínuo - 12 linhas e 1 coluna (12 etiquetas por folha)]');
    Writeln(F, 'Margem superior=0');
    Writeln(F, 'Margem esquerda=0');
    Writeln(F, 'Altura da pagina=72');
    Writeln(F, 'Largura da pagina=60');
    Writeln(F, 'Tamanho vertical=6');
    Writeln(F, 'Tamanho horizontal=55');
    Writeln(F, 'Linhas por folha=12');
    Writeln(F, 'Etiquetas por linha=1');
    Writeln(F, 'Fonte=7');
    Writeln(F, 'Impressora=Matricial');
    WriteLn(F,'');
    WriteLn(F, '[ - Formulário - 8 linhas e 3 colunas (24 etiquetas por folha)]');
    Writeln(F, 'Margem superior=0');
    Writeln(F, 'Margem esquerda=0');
    Writeln(F, 'Altura da pagina=72');
    Writeln(F, 'Largura da pagina=155');
    Writeln(F, 'Tamanho vertical=9');
    Writeln(F, 'Tamanho horizontal=57');
    Writeln(F, 'Linhas por folha=8');
    Writeln(F, 'Etiquetas por linha=3');
    Writeln(F, 'Fonte=7');
    Writeln(F, 'Impressora=Matricial');
    WriteLn(F,'');
    WriteLn(F, '[ - Formulário contínuo - 12 linhas e 3 colunas (36 etiquetas por folha)]');
    Writeln(F, 'Margem superior=0');
    Writeln(F, 'Margem esquerda=0');
    Writeln(F, 'Altura da pagina=62');
    Writeln(F, 'Largura da pagina=185');
    Writeln(F, 'Tamanho vertical=6');
    Writeln(F, 'Tamanho horizontal=62');
    Writeln(F, 'Linhas por folha=12');
    Writeln(F, 'Etiquetas por linha=3');
    Writeln(F, 'Fonte=7');
    Writeln(F, 'Impressora=Matricial');
    WriteLn(F,'');
    WriteLn(F, '[ - Formulário contínuo - 18 linhas e 5 colunas (90 etiquetas por folha)]');
    Writeln(F, 'Margem superior=0');
    Writeln(F, 'Margem esquerda=0');
    Writeln(F, 'Altura da pagina=72');
    Writeln(F, 'Largura da pagina=97');
    Writeln(F, 'Tamanho vertical=4');
    Writeln(F, 'Tamanho horizontal=20');
    Writeln(F, 'Linhas por folha=18');
    Writeln(F, 'Etiquetas por linha=5');
    Writeln(F, 'Fonte=7');
    Writeln(F, 'Impressora=Matricial');
    WriteLn(F,'');
    CloseFile(F);
  end;
  //
  dbGrid2.FixedColor      := Form19.Image9.Picture.BitMap.canvas.pixels[600,500];
  dbGrid2.TitleFont.Color := clBlack;
  //
  CheckBox3.Enabled    := True;
  RadioButton1.Enabled := True;
  RadioButton2.Enabled := True;
  Panel4.Visible := False;
  Form15.Height  := 550 -160;
  Panel5.Top     := 475 -160;
  Form15.Position := poScreenCenter;
  //
  Button7.Tag   := 0;
  CheckBox3.Checked := False;
  RadioButton2.Checked := True;
  //
  Form15.ibDataset1 := Form7.TabelaAberta;
  //
  if Form15.ibDataset1 = Form7.ibDataset7 then Form15.ibDataset1 := Form7.ibDataset2;
  //
  //  ibDataset1.Refresh;
  //
  // zera os campos
  for i := 1 to 5 do Form15.sInformacao[i] := '';
  J := 1;
  for I := 1 to Form7.DbGrid1.FieldCount do
  begin
    if Form7.DbGrid1.Columns[I-1].Visible then
    begin
      if J <= 5 then Form15.sInformacao[J] := Form7.DbGrid1.Fields[I-1].FieldName;
      Inc(J);
    end;
  end;
  //
  if Form7.sModulo <> 'ESTOQUE' then
  begin
    //
    GroupBox3.Left   := 5;
    GroupBox3.Top    := 40;
    GroupBox3.Height := 90;
    GroupBox3.Width  := 350;
    //
    GroupBox1.Visible := False;
    GroupBox2.Visible := False;
    GroupBox3.Visible := True;
    //
    Form15.Label2.Visible    := True;
    Form35.CheckBox4.Enabled := False;
    CheckBox1.Visible        := False;
    CheckBox2.Visible        := True;
    //
    GroupBox3.Left  := GroupBox1.Left;
    GroupBox3.Top   := GroupBox1.Top;
    GroupBox3.Width := ComboBox1.Width;
    //
  end else
  begin
    //
    GroupBox3.Left   := 185;
    GroupBox3.Top    := 130;
    GroupBox3.Height := 040;
    GroupBox3.Width  := 170;
    //
    GroupBox1.Visible     := True;
    GroupBox2.Visible     := True;
    RadioButton1.Checked  := True;
    // Lê as configurações da tela conforme a última vez que foram confirmadas pelo botão Ok do Form35
    ArqINI := TiniFile.create(Form1.sAtual + '\etiquetas.inf');
    ArqIni.UpdateFile;
    sOpcoes := arqINI.ReadString('CONFIG' ,'Número de etiquetas', 'Em estoque');
    if sOpcoes = 'Em estoque'          then Form15.RadioButton5.Checked := True;
    if sOpcoes = 'Últimas compras'     then Form15.RadioButton3.Checked := True;
    if sOpcoes = 'Alterações de preço' then Form15.RadioButton4.Checked := True;
    //
    Form35.RadioButton2.Enabled := False;
    CheckBox1.Visible := True;
    Combobox1.Text    := arqINI.ReadString('CONFIG' ,'Última etiqueta','25,4mm x 101,6mm - 10 linhas e 2 colunas (20 etiquetas por folha)');
  end;
  if ComboBox1.Tag <> 1 then
  begin
    if ComboBox1.Text = '' then ComboBox1.Text := '25,4mm x 101,6mm - 10 linhas e 2 colunas (20 etiquetas por folha)';

    {Verifica a etiqueta configurada para o arquivo selecionado}
    ArqINI := TiniFile.create( Form1.sAtual + '\etiquetas.inf');
    ArqIni.UpdateFile;
    if Form7.sModulo = 'ESTOQUE' then
       if arqINI.ReadString('DEFAULT','Etiqueta Estoque','') <> ''      then ComboBox1.Text := arqINI.ReadString('DEFAULT','Etiqueta Estoque','0');
    if Form7.sModulo <> 'ESTOQUE' then
       if arqINI.ReadString('DEFAULT','Etiqueta Clientes/Fornecedores','') <> ''     then ComboBox1.Text := arqINI.ReadString('DEFAULT','Etiqueta Clientes','0');
    Combobox1.Text := arqINI.ReadString('CONFIG' ,'Última etiqueta','25,4mm x 101,6mm - 10 linhas e 2 colunas (20 etiquetas por folha)');
    Form15.ComboBox1Change(Sender);
  end;
  //
  try
    ArqINI          := TiniFile.create(Form1.sAtual + '\etiquetas.inf');
    Combobox1.Text  := arqINI.ReadString('CONFIG' ,'Última etiqueta','25,4mm x 101,6mm - 10 linhas e 2 colunas (20 etiquetas por folha)');
    ArqINI.Free;
  except end;
  //
  Form15.ComboBox1Change(Sender);
  if Form7.sModulo = 'ESTOQUE' then Form15.CheckBox2.Checked := False else Form15.CheckBox2.Checked := True;
  //
end;

procedure TForm15.CheckBox1Click(Sender: TObject);
var
  Arquivo_De_Etiquetas : TIniFile;
begin

  {Inicializa o arquivo de etiquetas}
  Arquivo_De_Etiquetas := TInifile.Create(Form1.sAtual + '\etiquetas.inf');
  Arquivo_De_Etiquetas.UpdateFile;

  if CheckBox1.Checked = True then
  begin
    Form35.RadioButton1.Enabled := False;
    Form35.RadioButton2.Enabled := False;
    Form35.RadioButton3.Enabled := False;
    Form35.CheckBox5.Enabled := True;
    Form35.CheckBox6.Enabled := True;
    Form35.SpinEdit2.Enabled := True;
    Form35.CheckBox4.Checked := True;
//    Form35.ComboBox2.Text    := 'Jato de tinta';
    Arquivo_De_Etiquetas.WriteString('CONFIG', 'Barras', 'TTT');
  end else
  begin
    Form35.CheckBox4.Checked := False;
    Form35.CheckBox4Click(Sender);
    Arquivo_De_Etiquetas.WriteString('CONFIG', 'Barras', 'FFF');
  end;
end;

procedure TForm15.CheckBox2Click(Sender: TObject);
var
  Arquivo_De_Etiquetas : TIniFile;
begin
  {Inicializa o arquivo de etiquetas}
  Arquivo_De_Etiquetas := TInifile.Create(Form1.sAtual + '\etiquetas.inf');
  Arquivo_De_Etiquetas.UpdateFile;

  if CheckBox2.Checked = True then
  begin
    Form35.RadioButton2.Checked := True;
    Form35.RadioButton1.Checked := False;
    Form35.RadioButton3.Checked := False;
    Form35.CheckBox4.Enabled    := False;
    //
    Arquivo_De_Etiquetas.WriteString('CONFIG', 'Opcoes', 'FTF');
  end else
  begin
    //Form35.RadioButton1.Checked := False;
    //Form35.RadioButton3.Checked := False;
    Form35.CheckBox4.Enabled    := False;
    if Form35.RadioButton1.Checked = False then Form35.RadioButton3.Checked := True;
    //
    if copy(Arquivo_De_Etiquetas.ReadString('CONFIG', 'Opcoes', 'FFT'), 2, 1) = 'T' then
       Arquivo_De_Etiquetas.WriteString('CONFIG', 'Opcoes', 'FFT');

  end;
  Arquivo_De_Etiquetas.Free;
  if CheckBox2.State = cbChecked then CheckBox2.Caption := 'Imprimir etiqueta de mala direta COM o " À "' else if CheckBox2.State = cbGrayed then CheckBox2.Caption := 'Imprimir etiqueta de mala direta SEM o " À "';
end;

procedure TForm15.ComboBox1KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key<>#13) and (Key<>#5) and (Key<>#24) then Key := #0;
  if Key=#13 then Button5.SetFocus;
end;

procedure TForm15.ComboBox1Change(Sender: TObject);
var
  X, Y, L, C, iMargemSuperior, iMargemEsquerda, iAltura, iLargura, iAlturaP, iLarguraP : Integer;
begin
  //
  Form35.ComboBox1.Text := Form15.ComboBox1.Text;
  Form35.ComboBox1Change(Sender);
  //
  Form15.Repaint;
  //
  if Form35.ComboBox2.Text <> 'Matricial' then
  begin
    try
      //
      X := 400;
      Y := 10;
      //
//      iMargemEsquerda := StrToInt(Form35.Edit6.text);
//      iMargemSuperior := StrToInt(Form35.Edit3.text);

      iMargemEsquerda := StrToInt(FloatToStr(StrToFloat(Form35.Edit6.text)*100)) div 100;
      iMargemSuperior := StrToInt(FloatToStr(StrToFloat(Form35.Edit3.text)*100)) div 100;

      iAltura         := StrToInt(FloatToStr(StrToFloat(Form35.Edit1.text)*100)) div 100;
      iLargura        := StrToInt(FloatToStr(StrToFloat(Form35.Edit8.text)*100)) div 100;

      iAlturaP        := StrToInt(FloatToStr(StrToFloat(Form35.Edit5.text)*100)) div 100;
      iLarguraP       := StrToInt(FloatToStr(StrToFloat(Form35.Edit4.text)*100)) div 100;

      //
      Form15.Canvas.Pen.Width   := 1;
      Form15.Canvas.Brush.Color := clWhite;
      //
      Form15.Canvas.Rectangle( X , Y, (iLarguraP + X),(iAlturaP + Y));
      //
      for L := 1 to StrToInt(Form35.Edit9.text) do
      begin
        for C := 1 to StrToInt(Form35.Edit7.text) do
        begin

            Form15.Canvas.Rectangle( X + C * iLargura - iLargura + iMargemEsquerda,
                                     Y + L * iAltura - iAltura + iMargemSuperior,
                                     X + C * iLargura + iMargemEsquerda-1,
                                     Y + L * iAltura + iMargemSuperior-1);

        end;
      end;
      //
      Form15.Canvas.Font.Name  := 'Arial';
      Form15.Canvas.Font.Color := clGreen;
      Form15.Canvas.Font.Style := [fsbold];
      Form15.Canvas.Font.Size := 40;
      //
      // Label com o número de etiquetasd
      //
      Form15.Canvas.Rectangle((X+(iLarguraP div 2)-(Form15.Canvas.TextWidth(IntToStr(StrToInt(Form35.Edit9.text)*StrToInt(Form35.Edit7.text))) div 2))-3,
                              (Y+(iAlturaP div 2)-(Form15.Canvas.TextHeight(IntToStr(StrToInt(Form35.Edit9.text)*StrToInt(Form35.Edit7.text))) div 2))-3,
                              (X+(iLarguraP div 2)-(Form15.Canvas.TextWidth(IntToStr(StrToInt(Form35.Edit9.text)*StrToInt(Form35.Edit7.text))) div 2)+Form15.Canvas.TextWidth(IntToStr(StrToInt(Form35.Edit9.text)*StrToInt(Form35.Edit7.text))))+3,
                              (Y+(iAlturaP div 2)-(Form15.Canvas.TextHeight(IntToStr(StrToInt(Form35.Edit9.text)*StrToInt(Form35.Edit7.text))) div 2)+Form15.Canvas.TextHeight(IntToStr(StrToInt(Form35.Edit9.text)*StrToInt(Form35.Edit7.text)))+3)
                              );

      Form15.Canvas.TextOut(X+(iLarguraP div 2)-(Form15.Canvas.TextWidth(IntToStr(StrToInt(Form35.Edit9.text)*StrToInt(Form35.Edit7.text))) div 2),Y+(iAlturaP div 2)-(Form15.Canvas.TextHeight(IntToStr(StrToInt(Form35.Edit9.text)*StrToInt(Form35.Edit7.text))) div 2),IntToStr(StrToInt(Form35.Edit9.text)*StrToInt(Form35.Edit7.text)));
      //
    except end;
  end;
  //
  //
end;

procedure TForm15.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ArqIni  : TiniFile;
begin
  Form15.ComboBox1.Tag := 0;
  Form35.Close;
  Form15.Close;
  RadioButton6.Checked := False;
  ArqINI := TiniFile.create(Form1.sAtual + '\etiquetas.inf');
  ArqIni.WriteString('CONFIG' ,'Última etiqueta',Combobox1.Text);
  ArqIni.Free;
end;

procedure TForm15.Button7Click(Sender: TObject);
begin
  Form35.Close;
  Form15.Close;
  Form15.Button7.tag := 1;
  Close;
end;


procedure TForm15.SpinEdit1Change(Sender: TObject);
begin
  if SpinEdit1.Value > 0 then Radiobutton1.Caption := IntToStr(SpinEdit1.Value) + ' para cada item';
end;

procedure TForm15.RadioButton1Click(Sender: TObject);
begin
  SpinEdit1.Visible := True;
  Label3.Visible := True;
  SpinEdit1.SetFocus;
  SpinEdit1.SelectAll;
end;

procedure TForm15.SpinEdit1Exit(Sender: TObject);
begin
  if not RadioButton1.Focused then
  begin
    SpinEdit1.Visible := False;
    Label3.Visible := False;
  end;
end;

procedure TForm15.DBGrid2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if Dbgrid2.SelectedIndex = 1 then
    begin
      Form7.ibDataset40.Next;
      if Form7.ibDataset40.Eof then Form7.ibDataset40.Append;
      Dbgrid2.SelectedIndex := 0;
    end else Dbgrid2.SelectedIndex := Dbgrid2.SelectedIndex + 1;
  end;
  //
  if Dbgrid2.SelectedIndex = 1 then
  begin
    if ((ord(key) < 48) or (ord(key) > 58)) and (ord(Key) <> 8) and (ord(key) <> 13) then key := #0;
  end;
end;

procedure TForm15.DBGrid2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  Form7.ibDataset40.Edit;
  Form7.ibDataset40.UpdateRecord;
  //
  if Key = Vk_Return then
  begin
    //
    if Length(LimpaNumero(Form7.ibDataset40.FieldByName('DESCRICAO').Text)) <= 5 then
    begin
      if Form7.ibDataset4.Locate('CODIGO',StrZero(StrToInt('0'+Limpanumero(Form7.ibDataset40.FieldByName('DESCRICAO').Text)),5,0),[]) then
      begin
        Form7.ibDataset40.FieldByName('DESCRICAO').AsString := Form7.ibDataset4.FieldByName('DESCRICAO' ).AsString;
      end;
    end;
    //
    if Alltrim(Form7.ibDataset40.FieldByName('DESCRICAO').AsString) <> AllTrim(Form7.ibDataset4.FieldByName('DESCRICAO' ).AsString) then
      if (Length(Form7.ibDataset40.FieldByName('DESCRICAO').Text) <= 13) and (Length(Form7.ibDataset40.FieldByName('DESCRICAO').Text) > 5) then if Form7.ibDataset4.Locate('REFERENCIA',AllTrim(Form7.ibDataset40.FieldByName('DESCRICAO').Text),[]) then Form7.ibDataset40.FieldByName('DESCRICAO').AsString := Form7.ibDataset4.FieldByName('DESCRICAO' ).AsString;
    //
    if Alltrim(Form7.ibDataset40.FieldByName('DESCRICAO').AsString) = AllTrim(Form7.ibDataset4.FieldByName('DESCRICAO' ).AsString) then
    begin
      Form7.ibDataset40.FieldByName('CODIGO'   ).AsString := Form7.ibDataset4.FieldByName('CODIGO'    ).AsString;
      Form7.ibDataset40.FieldByName('DESCRICAO').AsString := Form7.ibDataset4.FieldByName('DESCRICAO' ).AsString;
      Form7.ibDataset40.FieldByName('QTD'      ).AsFloat  := Form7.ibDataset4.FieldByName('QTD_ATUAL' ).AsFloat;
    end else
    begin
      Form7.ibDataset40.FieldByName('CODIGO'   ).AsString := '';
      Form7.ibDataset40.FieldByName('DESCRICAO').AsString := '';
      Form7.ibDataset40.FieldByName('QTD'      ).AsString := '';
    end;
  end;
  //
end;

procedure TForm15.Edit1Exit(Sender: TObject);
var
  bOk : boolean;
  i : integer;
begin
  //
  Edit1.Text := right('000000' + LimpaNumero(Edit1.Text),12);
  ComboBox2.Items.Clear;
  //
  Form7.ibDataset23.Close;
  Form7.ibDataset23.SelectSQL.Clear;
  Form7.ibDataset23.SelectSQL.Add('select * from ITENS002 where NUMERONF='+QuotedStr(Edit1.Text));
  Form7.ibDataset23.Open;
  //
  Form7.ibDataset23.First;
  while not Form7.ibDataset23.eof do
  begin
    if Form7.ibDataset23.FieldByName('NUMERONF').AsString = Edit1.Text then
    begin
      bOk := False;
      for i := 0 to ComboBox2.Items.Count - 1 do if Form7.ibDataset23.FieldByName('FORNECEDOR').AsString = ComboBox2.Items[i] then bOk := True;
      if bOk = False then ComboBox2.Items.Add(Form7.ibDataset23.FieldByName('FORNECEDOR').AsString);
    end;
    Form7.ibDataset23.Next;
  end;
  ComboBox2.ItemIndex := 0;
  if ComboBox2.Items.Count > 0 then
  begin
    if ComboBox2.CanFocus then ComboBox2.SetFocus;
  end;
  //
end;

procedure TForm15.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then Button2.SetFocus;
end;

procedure TForm15.RadioButton6Click(Sender: TObject);
begin
  CheckBox3.Enabled := False;
  CheckBox3.Checked := False;
  RadioButton1.Enabled := False;
  RadioButton2.Enabled := False;
  //
  Panel4.Visible := True;
  DbGrid2.SetFocus;
  //
  Form15.Height  := 550;
  Panel5.Top     := 475;
  //
  Form15.Position := poScreenCenter;
  DbGrid2.SetFocus;
  //
end;

procedure TForm15.ComboBox2KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then Button2.SetFocus;
end;

procedure TForm15.FormShow(Sender: TObject);
begin
  //
  if Form7.sModulo <> 'ESTOQUE' then ibDataSet1 := Form7.IBDataSet2 else ibDataSet1 := Form7.IBDataSet4;
  //
  Form7.ibDataset40.Close;
  Form7.ibDataset40.SelectSQL.Clear;
  Form7.ibDataset40.SelectSQL.Add('select * from ITENSETI');
  Form7.ibDataset40.Open;
  //
  // Apaga todos os registros da tabela
  //
  Form7.ibDataset40.First;
  while not Form7.ibDataset40.Eof do Form7.ibDataset40.Delete;
  //
//  Form15.Image1.Picture := Form14.Image2.Picture;
  //
  if RadioButton6.Checked = False then
  begin
    RadioButton1.Enabled := True;
    RadioButton2.Enabled := True;
    CheckBox3.Enabled := True;
    Panel4.Visible := False;
  end;
  //
  Form15.ComboBox1Change(Sender);
  //
end;

procedure TForm15.RadioButton1Exit(Sender: TObject);
begin
  if not SpinEdit1.Focused then
  begin
    SpinEdit1.Visible := False;
    Label3.Visible := False;
  end;
end;

procedure TForm15.Button2Click(Sender: TObject);
begin
  //
  Form7.ibDataSet23.Close;
  Form7.ibDataSet23.SelectSQL.Clear;
  Form7.ibDataSet23.SelectSQL.Add('select * from ITENS002 where NUMERONF='+QuotedStr(Edit1.Text)+' and FORNECEDOR='+QuotedStr(ComboBox2.Text)+' ');
  Form7.ibDataSet23.Open;
  Form7.ibDataSet23.First;
  //
  while not Form7.ibDataSet23.EOF do
  begin
    Form7.ibDataset40.Append;
    Form7.ibDataset40.FieldByName('CODIGO'   ).AsString := Form7.ibDataset23.FieldByName('CODIGO'    ).AsString;
    Form7.ibDataset40.FieldByName('DESCRICAO').AsString := Form7.ibDataset23.FieldByName('DESCRICAO' ).AsString;
    Form7.ibDataset40.FieldByName('QTD'      ).AsFloat  := Form7.ibDataset23.FieldByName('QUANTIDADE').AsFloat;
    Form7.ibDataset40.Post;
    Form7.ibDataset23.Next;
  end;
end;

procedure TForm15.ScrollBar1Change(Sender: TObject);
begin
  Label7.Caption := IntToStr(101-ScrollBar1.Position);
end;

procedure TForm15.ScrollBar2Change(Sender: TObject);
begin
  Label13.Caption := IntToStr(101-ScrollBar2.Position);
end;

procedure TForm15.RadioButton5Click(Sender: TObject);
begin
  CheckBox3.Enabled    := True;
  RadioButton1.Enabled := True;
  RadioButton2.Enabled := True;
  Panel4.Visible       := False;
  Form15.Height        := 550 -160;
  Panel5.Top           := 475 -160;
  Form15.Position      := poScreenCenter;
end;

procedure TForm15.ComboBox1Enter(Sender: TObject);
var
  F      : TextFile;
  sSecao : String;
  ch     : char;
  bOk    : Boolean;
begin
  bOk := false;
  AssignFile(F, Form1.sAtual + '\etiquetas.inf');
  Reset(F);
  sSecao := '';
  while not eof(F) do
  begin
    Read(F,ch);
    if ch=']' then
    begin
      bOk := false;
      if (sSecao <>'DEFAULT') and (sSecao <> 'CONFIG') then ComboBox1.Items.Add(sSecao);
      sSecao := '';
    end;
    if bOk = true then sSecao := sSecao + ch;
    if ch='[' then bOk := true;
  end;
  CloseFile(F);
end;

procedure TForm15.DBGrid2DrawDataCell(Sender: TObject; const Rect: TRect;
  Field: TField; State: TGridDrawState);
begin
//  dbGrid2.Canvas.Brush.Color := Form19.Image9.Picture.BitMap.canvas.pixels[600,500];
//  dbGrid2.Canvas.Rectangle(REct.Left-1,-1,Rect.Right+1,Rect.Bottom-Rect.Top+1);
end;

procedure TForm15.DBGrid2ColEnter(Sender: TObject);
begin
  DBGrid2.Repaint;
end;

end.


