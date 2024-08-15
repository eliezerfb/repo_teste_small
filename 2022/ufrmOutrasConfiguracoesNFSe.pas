unit ufrmOutrasConfiguracoesNFSe;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmPadrao, Data.DB, Vcl.StdCtrls,
  Vcl.Buttons, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids,
  System.IniFiles;

type
  TfrmOutrasConfiguracoesNFSe = class(TFrmPadrao)
    DBGCONFIG: TDBGrid;
    CDSConfig: TClientDataSet;
    CDSConfigPARAMETRO: TStringField;
    CDSConfigVALOR: TStringField;
    DSConfig: TDataSource;
    btnOk: TBitBtn;
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure CarregaConfiguracao;
    procedure GravarConfiguracao;
  public
    { Public declarations }
  end;

var
  frmOutrasConfiguracoesNFSe: TfrmOutrasConfiguracoesNFSe;

implementation

{$R *.dfm}

{ TFrmPadrao18 }

procedure TfrmOutrasConfiguracoesNFSe.btnOkClick(Sender: TObject);
begin
  inherited;
  GravarConfiguracao;
  Close;
end;

procedure TfrmOutrasConfiguracoesNFSe.CarregaConfiguracao;
var
  Ini: TIniFile;
  sSection: TStrings;
  iParam: Integer;
begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'nfse.ini');

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

procedure TfrmOutrasConfiguracoesNFSe.FormCreate(Sender: TObject);
begin
  inherited;
  DBGCONFIG.DrawingStyle := gdsClassic;
  CDSConfig.CreateDataSet;
  CDSConfig.Open;
  CarregaConfiguracao;
end;

procedure TfrmOutrasConfiguracoesNFSe.GravarConfiguracao;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'nfse.ini');

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

end.
