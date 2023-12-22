unit uFormRelatorioPadrao;

interface

//Form38 novo

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, IBDatabase, uSmallEnumerados,
  uIEstruturaRelatorioPadrao, uIEstruturaTipoRelatorioPadrao, uArquivosDAT;

type
  TfrmRelatorioPadrao = class(TForm)
    btnCancelar: TBitBtn;
    ImgRel: TImage;
    btnAvancar: TBitBtn;
    btnVoltar: TBitBtn;
    procedure btnCancelarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnAvancarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FoDataBase: TIBDataBase;
    FoTransaction: TIBTransaction;
    FcUsuario: String;
    function getImagem: TPicture;
    procedure setImagem(const Value: TPicture);
    function getDataBase: TIBDatabase;
    procedure setDataBase(const Value: TIBDatabase);
    function getUsuario: String;
    procedure setUsuario(const Value: String);
    procedure CriaArquivoDAT;
    function getTransaction: TIBTransaction;
    procedure setTransaction(const Value: TIBTransaction);
  public
    property Transaction: TIBTransaction read getTransaction write setTransaction;
    property DataBase: TIBDatabase read getDataBase write setDataBase;
    property Transaction: TIBTransaction read getTransaction write setTransaction;
    property Imagem: TPicture read getImagem write setImagem;
    property Usuario: String read getUsuario write setUsuario;
  protected
    FoArquivoDAT: TArquivosDAT;
    procedure Imprimir;
    function Estrutura: IEstruturaTipoRelatorioPadrao; virtual; abstract;
  end;

var
  frmRelatorioPadrao: TfrmRelatorioPadrao;

implementation

{$R *.dfm}

procedure TfrmRelatorioPadrao.btnCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

function TfrmRelatorioPadrao.getDataBase: TIBDatabase;
begin
  Result := FoDataBase;
end;

function TfrmRelatorioPadrao.getImagem: TPicture;
begin
  Result := ImgRel.Picture;
end;

procedure TfrmRelatorioPadrao.setDataBase(const Value: TIBDatabase);
begin
  FoDataBase := Value;
end;

procedure TfrmRelatorioPadrao.setImagem(const Value: TPicture);
begin
  ImgRel.Picture := Value;
end;

procedure TfrmRelatorioPadrao.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: btnCancelarClick(Self);
  end;
end;

function TfrmRelatorioPadrao.getUsuario: String;
begin
  Result := FcUsuario;
end;

procedure TfrmRelatorioPadrao.setUsuario(const Value: String);
begin
  FcUsuario := Value;

  CriaArquivoDAT;  
end;

procedure TfrmRelatorioPadrao.CriaArquivoDAT;
begin
  FoArquivoDAT := TArquivosDAT.Create(FcUsuario);
end;

procedure TfrmRelatorioPadrao.Imprimir;
begin
  Estrutura.Imprimir;
end;

procedure TfrmRelatorioPadrao.btnAvancarClick(Sender: TObject);
begin
  Imprimir;

  Self.Close;
end;

procedure TfrmRelatorioPadrao.FormShow(Sender: TObject);
begin
  // Deve ser igual ao da unit38.
  Self.ClientHeight := 262;
  Self.ClientWidth  := 454;
end;

procedure TfrmRelatorioPadrao.FormDestroy(Sender: TObject);
begin
  if Assigned(FoArquivoDAT) then
    FreeAndNil(FoArquivoDAT);
end;

function TfrmRelatorioPadrao.getTransaction: TIBTransaction;
begin
  Result := FoTransaction;
end;

procedure TfrmRelatorioPadrao.setTransaction(const Value: TIBTransaction);
begin
  FoTransaction := Value;
end;

end.
