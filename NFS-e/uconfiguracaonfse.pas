(*

Tela para editar as configurações da NFS-e, contidas no arquivo nfseconfig.ini,
na Section [Informacoes obtidas na prefeitura]
*)
unit uconfiguracaonfse;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles, DB, Grids, DBGrids, DBClient, StdCtrls, Buttons;

type
  TFConfiguracaoNFSe = class(TForm)
    CDSConfig: TClientDataSet;
    DSConfig: TDataSource;
    DBGCONFIG: TDBGrid;
    CDSConfigPARAMETRO: TStringField;
    CDSConfigVALOR: TStringField;
    btnOk: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
    procedure CarregaConfiguracao;
    procedure GravarConfiguracao;
  public
    { Public declarations }
  end;

var
  FConfiguracaoNFSe: TFConfiguracaoNFSe;

implementation

uses uemissornfse;

{$R *.dfm}

{ TFConfiguracaoNFSe }

procedure TFConfiguracaoNFSe.CarregaConfiguracao;
var
  Ini: TIniFile;
  sSection: TStrings;
  iParam: Integer;
begin
  Ini := TIniFile.Create(FEmissorNFSe.sAtual + '\nfseConfig.ini');

  sSection := TStringList.Create;
  ini.ReadSectionValues('Informacoes obtidas na prefeitura', sSection);

  CDSConfig.EmptyDataSet;

  for iParam := 0 to sSection.Count - 1 do
  begin
    CDSConfig.Append;
    CDSConfig.FieldByName('PARAMETRO').AsString := Copy(sSection.Strings[iParam], 1, Pos('=', sSection.Strings[iParam]) - 1);
    CDSConfig.FieldByName('VALOR').AsString     := Copy(sSection.Strings[iParam], Pos('=', sSection.Strings[iParam]) + 1, Length(sSection.Strings[iParam]));
    CDSConfig.Post;

  end;
 
  Ini.Free;
end;

procedure TFConfiguracaoNFSe.FormCreate(Sender: TObject);
begin
  CDSConfig.CreateDataSet;
  CDSConfig.Open;
  CarregaConfiguracao;
end;

procedure TFConfiguracaoNFSe.GravarConfiguracao;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FEmissorNFSe.sAtual + '\nfseConfig.ini');

  ini.EraseSection('Informacoes obtidas na prefeitura');
  CDSConfig.First;
  while CDSConfig.Eof = False do
  begin

    if Trim(CDSConfig.FieldByName('PARAMETRO').AsString) <> '' then
      Ini.WriteString('Informacoes obtidas na prefeitura', CDSConfig.FieldByName('PARAMETRO').AsString, CDSConfig.FieldByName('VALOR').AsString);

    CDSConfig.Next;
  end;
  Ini.Free;

end;

procedure TFConfiguracaoNFSe.btnOkClick(Sender: TObject);
begin
  GravarConfiguracao;
  Close;
end;

end.

