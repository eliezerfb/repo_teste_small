unit uvinculador;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SmallFunc, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    edcnpjemitente: TEdit;
    Label1: TLabel;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses DateUtils;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
  function GerarSatsignAC(sCNPJEmitente: String): String;
  {Sandro Silva 2014-10-29 inicio
  Gera assinatura do AC basedo no cnpj da software house + cnpj emitente
  Assinatura gera deverá ser salva no frente.ini, seção [sat-cfe], chave Assinatura Associada}
  var
    sFileName: String;
    sFileAssinturaBin: String;
    sFileCNPJAssinado: String;
    Cursor: TCursor;
    Memo: TMemo;
  begin
    Result := '';
    Cursor        := Screen.Cursor;
    Screen.Cursor := crHourGlass;

    sFileName        := LimpaNumero(sCNPJEmitente) + '.txt';
    sFileAssinturaBin := LimpaNumero(sCNPJEmitente) + '.bin';
    sFileCNPJAssinado := LimpaNumero(sCNPJEmitente) + '_assinado.txt';

    // Exclui se existir
    DeleteFile(sFileName);
    DeleteFile(sFileAssinturaBin);
    DeleteFile(sFileCNPJAssinado);

    Memo := TMemo.Create(Application);
    Memo.Parent      := Application.MainForm;
    Memo.Visible     := False;
    Memo.WordWrap    := False;
    Memo.WantReturns := False;

    try
      Memo.Text := LimpaNumero('07426598000124') + LimpaNumero(sCNPJEmitente);//CNPJ_SOFTWARE_HOUSE + LimpaNumero(sCNPJEmitente);
      Memo.Lines.SaveToFile(sFileName);

      Sleep(50);

      if FileExists('openssl.exe') and FileExists('libeay32.dll') and FileExists('ssleay32.dll') then
      begin
        if FileExists(sFileName) then
        begin

          // Gerando o arquivo .bin, com o conteudo de .txt, assinado pelo seu .pem
          WinExec(PChar('openssl dgst -sha256 -sign 07426598000124.pem -out '+ sFileAssinturaBin + ' ' + sFileName), SWP_HIDEWINDOW);

          Sleep(300);

          if FileExists(sFileAssinturaBin) then
          begin
            //o conteúdo de .bin não é legível, o comando abaixo transforma o mesmo para Base64
            WinExec(PChar('openssl enc -base64 -in ' + sFileAssinturaBin + ' -out ' + sFileCNPJAssinado), SWP_HIDEWINDOW);

            Sleep(300);

            if FileExists(sFileCNPJAssinado) then
            begin
              with TStringList.Create do
              begin
                LoadFromFile(sFileCNPJAssinado);
                Result := Text;
                Free;
              end;

              Result := StringReplace(Result, #13#10, '', [rfReplaceAll]); // Elimina quebra de linha
            end;
          end;
        end;
      end;
    finally
      DeleteFile(sFileName);
      DeleteFile(sFileAssinturaBin);
      DeleteFile(sFileCNPJAssinado);

      if Memo <> nil then
        FreeAndNil(Memo);

      Screen.Cursor := Cursor;
    end;
  end;

begin
  Memo2.Clear;
  memo2.Text := GerarSatsignAC(edcnpjemitente.Text);
end;

end.
