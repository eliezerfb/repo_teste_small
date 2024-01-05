unit Unit33;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, ComObj, ActiveX, shellapi, smallfunc_xe; //, OleAuto;

type
  TForm33 = class(TForm)
    Panel2: TPanel;
    Image1: TImage;
    Label5: TLabel;
    Label7: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Button4: TButton;
    Button2: TButton;
    Label6: TLabel;
    Button1: TButton;
    procedure Button4Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Label10Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    bVisualizar : Boolean;
  end;

var
  Form33: TForm33;

implementation

uses Unit7, Mais, Unit34, Unit14, uDialogs;

{$R *.DFM}

procedure TForm33.Button4Click(Sender: TObject);
var
  WinWord, Docs, Doc: Variant;
  iDoc, I : Integer;
begin
  //
  Screen.Cursor  := crHourGlass;    // Cursor de Aguardo
  //
  if Form7.sModulo = 'RECEBER' then
  begin
    //
    if FileExists(Form1.sAtual+'\cobrança.doc') then
    begin
      //
      CoInitialize(nil);
      WinWord := CreateOleObject('Word.Application');  // Cria objeto principal de controle                       //
      Docs := WinWord.Documents;                       // Pega uma interface para objeto que manipula documentos  //
      //WinWord.Visible := True;                       // Mostra o word                                           //
      //
      iDoc := 0;
      //
      Form7.ibDataSet7.First;
      while not Form7.ibDataSet7.EOF do
      begin
        //
        Form7.ibDataSet2.Close;
        Form7.ibDataSet2.Selectsql.Clear;
        Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet7NOME.AsString)+' ');  //
        Form7.ibDataSet2.Open;
        //
        if Form7.ibDataSet2NOME.AsString = Form7.ibDataSet7NOME.AsString then
        begin
          //
          iDoc := iDoc + 1;
          Doc  := Docs.Open(Form1.sAtual+'\cobrança.doc');   // Abre um documento                                       //
          //
          for I := 1 to 4 do                                 // Substitui o texto via 'named parenteses'                //
          begin
            // CLIENTES
            Doc.Content.Find.Execute(FindText:='<NOME>'          ,ReplaceWith := Form7.ibDataSet2.FieldByName('NOME'     ).AsString);
            Doc.Content.Find.Execute(FindText:='<CONTATO>'       ,ReplaceWith := Form7.ibDataSet2.FieldByName('CONTATO'  ).AsString);
            Doc.Content.Find.Execute(FindText:='<IE>'            ,ReplaceWith := Form7.ibDataSet2.FieldByName('IE'       ).AsString);
            Doc.Content.Find.Execute(FindText:='<CGC>'           ,ReplaceWith := Form7.ibDataSet2.FieldByName('CGC'      ).AsString);
            Doc.Content.Find.Execute(FindText:='<ENDERECO>'      ,ReplaceWith := Form7.ibDataSet2.FieldByName('ENDERE'   ).AsString);
            Doc.Content.Find.Execute(FindText:='<BAIRRO>'        ,ReplaceWith := Form7.ibDataSet2.FieldByName('COMPLE'   ).AsString);
            Doc.Content.Find.Execute(FindText:='<CIDADE>'        ,ReplaceWith := Form7.ibDataSet2.FieldByName('CIDADE'   ).AsString);
            Doc.Content.Find.Execute(FindText:='<UF>'            ,ReplaceWith := Form7.ibDataSet2.FieldByName('ESTADO'   ).AsString);
            Doc.Content.Find.Execute(FindText:='<CEP>'           ,ReplaceWith := Form7.ibDataSet2.FieldByName('CEP'      ).AsString);
            Doc.Content.Find.Execute(FindText:='<FONE>'          ,ReplaceWith := Form7.ibDataSet2.FieldByName('FONE'     ).AsString);
            Doc.Content.Find.Execute(FindText:='<FAX>'           ,ReplaceWith := Form7.ibDataSet2.FieldByName('FAX'      ).AsString);
            Doc.Content.Find.Execute(FindText:='<EMAIL>'         ,ReplaceWith := Form7.ibDataSet2.FieldByName('EMAIL'    ).AsString);
            Doc.Content.Find.Execute(FindText:='<OBS>'           ,ReplaceWith := Form7.ibDataSet2.FieldByName('OBS'      ).AsString);
            Doc.Content.Find.Execute(FindText:='<CELULAR>'       ,ReplaceWith := Form7.ibDataSet2.FieldByName('CELULAR'  ).AsString);
            Doc.Content.Find.Execute(FindText:='<CREDITO>'       ,ReplaceWith := Form7.ibDataSet2.FieldByName('CREDITO'  ).AsString);
            Doc.Content.Find.Execute(FindText:='<IDENTIFICADOR1>',ReplaceWith := Form7.ibDataSet2.FieldByName('IDENTIFICADOR1').AsString);
            Doc.Content.Find.Execute(FindText:='<IDENTIFICADOR2>',ReplaceWith := Form7.ibDataSet2.FieldByName('IDENTIFICADOR2').AsString);
            Doc.Content.Find.Execute(FindText:='<IDENTIFICADOR3>',ReplaceWith := Form7.ibDataSet2.FieldByName('IDENTIFICADOR3').AsString);
            Doc.Content.Find.Execute(FindText:='<IDENTIFICADOR4>',ReplaceWith := Form7.ibDataSet2.FieldByName('IDENTIFICADOR4').AsString);
            Doc.Content.Find.Execute(FindText:='<IDENTIFICADOR5>',ReplaceWith := Form7.ibDataSet2.FieldByName('IDENTIFICADOR5').AsString);
            Doc.Content.Find.Execute(FindText:='<CONVENIO>'      ,ReplaceWith := Form7.ibDataSet2.FieldByName('CONVENIO' ).AsString);
            Doc.Content.Find.Execute(FindText:='<DATANAS>'       ,ReplaceWith := Form7.ibDataSet2.FieldByName('DATANAS'  ).AsString);
            Doc.Content.Find.Execute(FindText:='<CADASTRO>'      ,ReplaceWith := Form7.ibDataSet2.FieldByName('CADASTRO' ).AsString);
            Doc.Content.Find.Execute(FindText:='<ULTIMA COMPRA>' ,ReplaceWith := Form7.ibDataSet2.FieldByName('ULTIMACO' ).AsString);
            // CONTAS A RECEBER
            Doc.Content.Find.Execute(FindText:='<HISTORICO>'     ,ReplaceWith := Form7.ibDataSet7.FieldByName('HISTORICO'     ).AsString);
            Doc.Content.Find.Execute(FindText:='<PORTADOR>'      ,ReplaceWith := Form7.ibDataSet7.FieldByName('PORTADOR'      ).AsString);
            Doc.Content.Find.Execute(FindText:='<DOCUMENTO>'     ,ReplaceWith := Form7.ibDataSet7.FieldByName('DOCUMENTO'     ).AsString);
            Doc.Content.Find.Execute(FindText:='<EMISSAO>'       ,ReplaceWith := Form7.ibDataSet7.FieldByName('EMISSAO'       ).AsString);
            Doc.Content.Find.Execute(FindText:='<VENCIMENTO>'    ,ReplaceWith := Form7.ibDataSet7.FieldByName('VENCIMENTO'    ).AsString);
            //
            Doc.Content.Find.Execute(FindText:='<VALOR_DUPL>'    ,ReplaceWith := AllTrim(Format('%12.2n',[Form7.ibDataSet7.FieldByName('VALOR_DUPL').AsFloat])));
            Doc.Content.Find.Execute(FindText:='<VALOR_JURO>'    ,ReplaceWith := AllTrim(Format('%12.2n',[Form7.ibDataSet7.FieldByName('VALOR_JURO').AsFloat])));
            Doc.Content.Find.Execute(FindText:='<CODEBAR>'       ,ReplaceWith := Form7.ibDataSet7.FieldByName('CODEBAR').AsString);
            Doc.Content.Find.Execute(FindText:='<LOCAL_E_DATA>'  ,ReplaceWith := Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
                                                                                  + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
                                                                                  + Copy(DateTimeToStr(Date),7,4));

            Doc.Content.Find.Execute(FindText:='<TELEFONE_DO_EMITENTE>',ReplaceWith := Form7.ibDataSet13TELEFO.AsString);
            Doc.Content.Find.Execute(FindText:='<NOME_EMITENTE>',ReplaceWith        := Form7.ibDataSet13NOME.AsString);
            Doc.Content.Find.Execute(FindText:='<ENDERECO_EMITENTE>',ReplaceWith    := Form7.ibDataSet13ENDERECO.AsString);
            Doc.Content.Find.Execute(FindText:='<BAIRRO_EMITENTE>',ReplaceWith      := Form7.ibDataSet13COMPLE.AsString);
            Doc.Content.Find.Execute(FindText:='<CEP_EMITENTE>',ReplaceWith         := Form7.ibDataSet13CEP.AsString);
            Doc.Content.Find.Execute(FindText:='<CIDADE_EMITENTE>',ReplaceWith      := Form7.ibDataSet13MUNICIPIO.AsString);
            Doc.Content.Find.Execute(FindText:='<UF_EMITENTE>',ReplaceWith          := UpperCase(Form7.ibDataSet13ESTADO.AsString));
            //
          end;
          //
          while FileExists(Form1.sAtual+'\COBRA'+StrZero(iDoc,3,0)+'.doc') do DeleteFile(Form1.sAtual+'\COBRA'+StrZero(iDoc,3,0)+'.doc');
          Doc.SAveAs(Form1.sAtual+'\COBRA'+StrZero(iDoc,3,0)+'.doc'); // Grava com outro nome
          while not FileExists(Form1.sAtual+'\COBRA'+StrZero(iDoc,3,0)+'.doc') do Sleep(1000);

          if not bVisualizar then
          begin
            //ShowMessage('Tecle <Enter> para imprimir.'); Mauricio Parizotto 2023-10-25
            MensagemSistema('Tecle <Enter> para imprimir.');
            Doc.PrintOut(False);
            Doc.Close(True);
          end else
          begin
            WinWord.Visible := True;
          end;
        end;
        Form7.ibDataSet7.Next;
      end;
      
      if bVisualizar then
        //ShowMessage('Tecle <Enter> para fechar o Word.'); Mauricio Parizotto 2023-10-25
        MensagemSistema('Tecle <Enter> para fechar o Word.');

      WinWord.Quit;
    end;
  end else
  begin
    if FileExists(Form1.sAtual+'\carta.doc') then
    begin
      //
      CoInitialize(nil);
      WinWord := CreateOleObject('Word.Application');  // Cria objeto principal de controle                       //
      Docs := WinWord.Documents;                       // Pega uma interface para objeto que manipula documentos  //
      //
      // WinWord.Visible := True;                      // Mostra o word                                           //
      //
      iDoc := 0;
      //
      Form7.ibDataSet2.First;
      while not Form7.ibDataSet2.EOF do
      begin
        //
        if Form7.ibDataSet2ATIVO.AsString<>'1' then
        begin
          iDoc := iDoc + 1;
          Doc  := Docs.Open(Form1.sAtual+'\carta.doc');      // Abre um documento                                       //
          for I := 1 to 4 do                                 // Substitui o texto via 'named parenteses'                //
          begin                                              // ------------------------------------------------------- //
            Doc.Content.Find.Execute(FindText:='<NOME>'          ,ReplaceWith := Form7.ibDataSet2.FieldByName('NOME'     ).AsString);
            Doc.Content.Find.Execute(FindText:='<CONTATO>'       ,ReplaceWith := Form7.ibDataSet2.FieldByName('CONTATO'  ).AsString);
            Doc.Content.Find.Execute(FindText:='<IE>'            ,ReplaceWith := Form7.ibDataSet2.FieldByName('IE'       ).AsString);
            Doc.Content.Find.Execute(FindText:='<CGC>'           ,ReplaceWith := Form7.ibDataSet2.FieldByName('CGC'      ).AsString);
            Doc.Content.Find.Execute(FindText:='<ENDERECO>'      ,ReplaceWith := Form7.ibDataSet2.FieldByName('ENDERE'   ).AsString);
            Doc.Content.Find.Execute(FindText:='<BAIRRO>'        ,ReplaceWith := Form7.ibDataSet2.FieldByName('COMPLE'   ).AsString);
            Doc.Content.Find.Execute(FindText:='<CIDADE>'        ,ReplaceWith := Form7.ibDataSet2.FieldByName('CIDADE'   ).AsString);
            Doc.Content.Find.Execute(FindText:='<UF>'            ,ReplaceWith := Form7.ibDataSet2.FieldByName('ESTADO'   ).AsString);
            Doc.Content.Find.Execute(FindText:='<CEP>'           ,ReplaceWith := Form7.ibDataSet2.FieldByName('CEP'      ).AsString);
            Doc.Content.Find.Execute(FindText:='<FONE>'          ,ReplaceWith := Form7.ibDataSet2.FieldByName('FONE'     ).AsString);
            Doc.Content.Find.Execute(FindText:='<FAX>'           ,ReplaceWith := Form7.ibDataSet2.FieldByName('FAX'      ).AsString);
            Doc.Content.Find.Execute(FindText:='<EMAIL>'         ,ReplaceWith := Form7.ibDataSet2.FieldByName('EMAIL'    ).AsString);
            Doc.Content.Find.Execute(FindText:='<OBS>'           ,ReplaceWith := Form7.ibDataSet2.FieldByName('OBS'      ).AsString);
            Doc.Content.Find.Execute(FindText:='<CELULAR>'       ,ReplaceWith := Form7.ibDataSet2.FieldByName('CELULAR'  ).AsString);
            Doc.Content.Find.Execute(FindText:='<CREDITO>'       ,ReplaceWith := Form7.ibDataSet2.FieldByName('CREDITO'  ).AsString);
            Doc.Content.Find.Execute(FindText:='<IDENTIFICADOR1>',ReplaceWith := Form7.ibDataSet2.FieldByName('IDENTIFICADOR1').AsString);
            Doc.Content.Find.Execute(FindText:='<IDENTIFICADOR2>',ReplaceWith := Form7.ibDataSet2.FieldByName('IDENTIFICADOR2').AsString);
            Doc.Content.Find.Execute(FindText:='<IDENTIFICADOR3>',ReplaceWith := Form7.ibDataSet2.FieldByName('IDENTIFICADOR3').AsString);
            Doc.Content.Find.Execute(FindText:='<IDENTIFICADOR4>',ReplaceWith := Form7.ibDataSet2.FieldByName('IDENTIFICADOR4').AsString);
            Doc.Content.Find.Execute(FindText:='<IDENTIFICADOR5>',ReplaceWith := Form7.ibDataSet2.FieldByName('IDENTIFICADOR5').AsString);
            Doc.Content.Find.Execute(FindText:='<CONVENIO>'      ,ReplaceWith := Form7.ibDataSet2.FieldByName('CONVENIO' ).AsString);
            Doc.Content.Find.Execute(FindText:='<DATANAS>'       ,ReplaceWith := Form7.ibDataSet2.FieldByName('DATANAS'  ).AsString);
            Doc.Content.Find.Execute(FindText:='<CADASTRO>'      ,ReplaceWith := Form7.ibDataSet2.FieldByName('CADASTRO' ).AsString);
            Doc.Content.Find.Execute(FindText:='<ULTIMA COMPRA>' ,ReplaceWith := Form7.ibDataSet2.FieldByName('ULTIMACO' ).AsString);
            //
            Doc.Content.Find.Execute(FindText:='<LOCAL_E_DATA>'  ,ReplaceWith := Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
                                                                                  + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
                                                                                  + Copy(DateTimeToStr(Date),7,4));


            Doc.Content.Find.Execute(FindText:='<TELEFONE_DO_EMITENTE>',ReplaceWith := Form7.ibDataSet13TELEFO.AsString);
            Doc.Content.Find.Execute(FindText:='<NOME_EMITENTE>',ReplaceWith        := Form7.ibDataSet13NOME.AsString);
            Doc.Content.Find.Execute(FindText:='<ENDERECO_EMITENTE>',ReplaceWith    := Form7.ibDataSet13ENDERECO.AsString);
            Doc.Content.Find.Execute(FindText:='<BAIRRO_EMITENTE>',ReplaceWith      := Form7.ibDataSet13COMPLE.AsString);
            Doc.Content.Find.Execute(FindText:='<CEP_EMITENTE>',ReplaceWith         := Form7.ibDataSet13CEP.AsString);
            Doc.Content.Find.Execute(FindText:='<CIDADE_EMITENTE>',ReplaceWith      := Form7.ibDataSet13MUNICIPIO.AsString);
            Doc.Content.Find.Execute(FindText:='<UF_EMITENTE>',ReplaceWith          := UpperCase(Form7.ibDataSet13ESTADO.AsString));
          end;
          
          while FileExists(Form1.sAtual+'\CARTA'+StrZero(iDoc,3,0)+'.doc') do DeleteFile(Form1.sAtual+'\CARTA'+StrZero(iDoc,3,0)+'.doc');
          Doc.SAveAs(Form1.sAtual+'\CARTA'+StrZero(iDoc,3,0)+'.doc'); // Grava com outro nome
          while not FileExists(Form1.sAtual+'\CARTA'+StrZero(iDoc,3,0)+'.doc') do Sleep(1000);

          if not bVisualizar then
          begin
            //ShowMessage('Tecle <Enter> para imprimir.'); Mauricio Parizotto 2023-10-25
            MensagemSistema('Tecle <Enter> para imprimir.');
            Doc.PrintOut(False);                           // Imprime
            Doc.Close(True);
          end else
          begin
            WinWord.Visible := True;                       // Mostra o word
          end;
        end;
        Form7.ibDataSet2.Next;
      end;
      
      if bVisualizar then
        //ShowMessage('Tecle <Enter> para fechar o Word.'); Mauricio Parizotto 2023-10-25
        MensagemSistema('Tecle <Enter> para fechar o Word.');

      WinWord.Quit;
    end;
  end;

  Screen.Cursor  := crDefault;    // Cursor normal
  Close;
end;


procedure TForm33.FormActivate(Sender: TObject);
begin
  bVisualizar := False;
  Image1.Picture := Form7.imgImprimir.Picture;
end;

procedure TForm33.Button2Click(Sender: TObject);
begin
  Close;
end;


procedure TForm33.Label7Click(Sender: TObject);
begin
  Form7.Cartaparamaladireta1Click(Sender);
end;

procedure TForm33.Label10Click(Sender: TObject);
begin
  bVisualizar := True;
  Button4Click(Sender);
end;

procedure TForm33.Image2Click(Sender: TObject);
begin
  bVisualizar := True;
  Button4Click(Sender);
end;

procedure TForm33.Button1Click(Sender: TObject);
begin
  bVisualizar := True;
  Button4Click(Sender);
end;

end.






