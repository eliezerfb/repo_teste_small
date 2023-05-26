unit uFrmTermosUso;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, IniFiles;

type
  TFrmTermosUso = class(TForm)
    rcTermo: TRichEdit;
    Label1: TLabel;
    Label2: TLabel;
    btnAceita: TButton;
    btnNaoAceita: TButton;
    Label3: TLabel;
    procedure btnAceitaClick(Sender: TObject);
    procedure btnNaoAceitaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmTermosUso: TFrmTermosUso;
  vTermoAceito : Boolean;

  function GetTermoUso : Boolean;

implementation

uses SmallFunc
  , Mais
  , uSmallConsts;


{$R *.dfm}



function GetTermoUso : Boolean;
var
  ArqINI : TIniFile;
  VercaoTermo : integer;
begin
  Result := False;

  if FileExists(Form1.sAtual+'\termo.zct')
    and FileExists(Form1.sAtual+'\smallcom.inf') then
  begin
    try
      ArqINI := TIniFile.Create(Form1.sAtual + '\smallcom.inf');
      VercaoTermo := ArqINI.ReadInteger('Outros', 'TERMO', -1);
    finally
      FreeAndNil(ArqINI);
    end;

    //Verifica se a versão do termo aceito é diferente da versão atual
    if VercaoTermo < _cVersaoTermoUso then
    begin
      FrmTermosUso := TFrmTermosUso.Create(Application);
      try
        FrmTermosUso.ShowModal;
      finally
        Result := vTermoAceito;

        FreeAndNil(FrmTermosUso);
      end;
    end;
  end;

  //Se não existir é porque foi aceito pelo instal shield
  if not FileExists(Form1.sAtual+'\smallcom.inf') then
  begin
    try
      ArqINI := TIniFile.Create(Form1.sAtual + '\smallcom.inf');
      ArqINI.WriteInteger('Outros', 'TERMO', _cVersaoTermoUso);
    finally
      FreeAndNil(ArqINI);
    end;
  end;
end;


procedure TFrmTermosUso.btnAceitaClick(Sender: TObject);
var
  ArqINI : TIniFile;
begin
  //Mauricio Parizotto 2023-05-15
  vTermoAceito := True;

  //Grava Versão aceitou termo
  try
    ArqINI := TIniFile.Create(Form1.sAtual + '\smallcom.inf');
    ArqINI.WriteInteger('Outros', 'TERMO', _cVersaoTermoUso);
  finally
    FreeAndNil(ArqINI);
  end;

  Close;
end;

procedure TFrmTermosUso.btnNaoAceitaClick(Sender: TObject);
begin
  vTermoAceito := False;
  
  Close;
  FecharAplicacao(ExtractFileName(Application.ExeName));

  Sleep(2000);  
  Application.Terminate;
end;

procedure TFrmTermosUso.FormCreate(Sender: TObject);
begin
  rcTermo.Lines.LoadFromFile(Form1.sAtual+'\termo.zct' );
end;

end.
