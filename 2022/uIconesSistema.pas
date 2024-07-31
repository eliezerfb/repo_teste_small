//Mauricio Parizotto 2023-09-20
unit uIconesSistema;

interface

uses
  Forms
  , Windows
  , Classes
  , ExtCtrls;

type
  TIconesSistema = class
    private
      imgNovo : Timage;
      imgNovoF : Timage;
      imgProcurar : Timage;
      imgProcurarF : Timage;
      imgVisualizar : Timage;
      imgVisualizarF : Timage;
      imgAnterior : Timage;
      imgAnteriorF : Timage;
      imgProximo : Timage;
      imgProximoF : Timage;
      imgApagar : Timage;
      imgApagarF : Timage;
      imgAlterar : Timage;
      imgAlterarF : Timage;
      imgLiberar : Timage;
      imgLiberarF : Timage;
      imgFiltrar : Timage;
      imgFiltrarF : Timage;

      imgOrcamento : Timage;
      imgOrcamentoF : Timage;
    public
     function GetIconNovo(F : Boolean) : Timage;
     function GetIconProcurar(F : Boolean) : Timage;
     function GetIconVisualizar(F : Boolean) : Timage;
     function GetIconAnterior(F : Boolean) : Timage;
     function GetIconProximo(F : Boolean) : Timage;
     function GetIconApagar(F : Boolean) : Timage;
     function GetIconAlterar(F : Boolean) : Timage;
     function GetIconLiberar(F : Boolean) : Timage;
     function GetIconFiltrar(F : Boolean) : Timage;

     function GetIconOrcamento(F : Boolean) : Timage;
     constructor Create;
  end;

var
  IconesSistema : TIconesSistema;

  procedure MostraImagemCoordenada(ImgOri: TImage; ImgDest: TImage; Linha:integer; Coluna: Integer; Tamanho : integer = 70);
  procedure CarregaIconesSistema;

implementation

uses SysUtils, uSmallConsts;

procedure MostraImagemCoordenada(ImgOri: TImage; ImgDest: TImage; Linha:integer; Coluna: Integer; Tamanho : integer = 70);
var
  iPosIniX,iPosIniY : integer;
  margemSup : integer;
begin
  ImgDest.Picture := nil;
  try
    if Linha > 4 then
      margemSup := 50
    else
      margemSup := 30;

    iPosIniY := margemSup + (Tamanho*(Linha-1));
    iPosIniX := 10 + (Tamanho*(Coluna-1));

    ImgDest.AutoSize := False;
    ImgDest.Height   := Tamanho;
    ImgDest.Width    := Tamanho;

    ImgDest.Canvas.CopyRect(Rect(0, 0, ImgDest.Height, ImgDest.Width), ImgOri.Canvas, Rect(iPosIniX, iPosIniY, iPosIniX + ImgDest.Height, iPosIniY + ImgDest.Width));
    ImgDest.Picture.Bitmap.TransparentColor := ImgDest.Picture.BitMap.Canvas.Pixels[1,1];
  except

  end;
end;


procedure CarregaIconesSistema;
var
  imgTemplate : TImage;
  DirImg : string;

  r1 : tRect;
begin
  IconesSistema := TIconesSistema.create;

  try
    imgTemplate := TImage.Create(nil);

    DirImg := ExtractFilePath(Application.ExeName)+_DirImagemIcones;

    if FileExists(DirImg) then
    begin
      imgTemplate.Picture.LoadFromFile(DirImg);
    end;

    MostraImagemCoordenada(imgTemplate,IconesSistema.imgNovo,2,1);
    MostraImagemCoordenada(imgTemplate,IconesSistema.imgNovoF,6,1);
    MostraImagemCoordenada(imgTemplate,IconesSistema.imgProcurar,2,3);
    MostraImagemCoordenada(imgTemplate,IconesSistema.imgProcurarF,6,3);
    MostraImagemCoordenada(imgTemplate,IconesSistema.imgVisualizar,2,5);
    MostraImagemCoordenada(imgTemplate,IconesSistema.imgVisualizarF,6,5);
    MostraImagemCoordenada(imgTemplate,IconesSistema.imgAnterior,3,1);
    MostraImagemCoordenada(imgTemplate,IconesSistema.imgAnteriorF,7,1);
    MostraImagemCoordenada(imgTemplate,IconesSistema.imgProximo,3,2);
    MostraImagemCoordenada(imgTemplate,IconesSistema.imgProximoF,7,2);
    MostraImagemCoordenada(imgTemplate,IconesSistema.imgApagar,2,2);
    MostraImagemCoordenada(imgTemplate,IconesSistema.imgApagarF,6,2);
    MostraImagemCoordenada(imgTemplate,IconesSistema.imgAlterar,1,2);
    MostraImagemCoordenada(imgTemplate,IconesSistema.imgAlterarF,5,2);
    MostraImagemCoordenada(imgTemplate,IconesSistema.imgLiberar,2,9);
    MostraImagemCoordenada(imgTemplate,IconesSistema.imgLiberarF,6,9);
    MostraImagemCoordenada(imgTemplate,IconesSistema.imgFiltrar,2,7);
    MostraImagemCoordenada(imgTemplate,IconesSistema.imgFiltrarF,6,7);

    //Mauricio Parizotto 2024-07-31
    //Módulos
    MostraImagemCoordenada(imgTemplate,IconesSistema.imgOrcamento,2,7);
    MostraImagemCoordenada(imgTemplate,IconesSistema.imgOrcamentoF,6,7);

  finally
    FreeAndNil(imgTemplate);
  end;

end;


{ TIconesSistema }

constructor TIconesSistema.Create;
begin
  imgNovo         := Timage.Create(nil);
  imgNovoF        := Timage.Create(nil);
  imgProcurar     := Timage.Create(nil);
  imgProcurarF    := Timage.Create(nil);
  imgVisualizar   := Timage.Create(nil);
  imgVisualizarF  := Timage.Create(nil);
  imgAnterior     := Timage.Create(nil);
  imgAnteriorF    := Timage.Create(nil);
  imgProximo      := Timage.Create(nil);
  imgProximoF     := Timage.Create(nil);
  imgApagar       := Timage.Create(nil);
  imgApagarF      := Timage.Create(nil);
  imgAlterar      := Timage.Create(nil);
  imgAlterarF     := Timage.Create(nil);
  imgLiberar      := Timage.Create(nil);
  imgLiberarF     := Timage.Create(nil);
  imgFiltrar      := Timage.Create(nil);
  imgFiltrarF     := Timage.Create(nil);

  //Módulos
  imgOrcamento    := Timage.Create(nil);
  imgOrcamentoF   := Timage.Create(nil);
end;

function TIconesSistema.GetIconAlterar(F: Boolean): Timage;
begin
  if F then
    Result := imgAlterarF
  else
    Result := imgAlterar;
end;

function TIconesSistema.GetIconAnterior(F : Boolean): Timage;
begin
  if F then
    Result := imgAnteriorF
  else
    Result := imgAnterior;
end;

function TIconesSistema.GetIconApagar(F: Boolean): Timage;
begin
  if F then
    Result := imgApagarF
  else
    Result := imgApagar;
end;

function TIconesSistema.GetIconFiltrar(F: Boolean): Timage;
begin
  if F then
    Result := imgFiltrarF
  else
    Result := imgFiltrar;
end;

function TIconesSistema.GetIconLiberar(F: Boolean): Timage;
begin
  if F then
    Result := imgLiberarF
  else
    Result := imgLiberar;
end;

function TIconesSistema.GetIconNovo(F : Boolean): Timage;
begin
  if F then
    Result := imgNovoF
  else
    Result := imgNovo;
end;

function TIconesSistema.GetIconOrcamento(F: Boolean): Timage;
begin
  if F then
    Result := imgOrcamentoF
  else
    Result := imgOrcamento;
end;

function TIconesSistema.GetIconProcurar(F : Boolean): Timage;
begin
  if F then
    Result := imgProcurarF
  else
    Result := imgProcurar;
end;

function TIconesSistema.GetIconProximo(F : Boolean): Timage;
begin
  if F then
    Result := imgProximoF
  else
    Result := imgProximo;
end;

function TIconesSistema.GetIconVisualizar(F : Boolean): Timage;
begin
  if F then
    Result := imgVisualizarF
  else
    Result := imgVisualizar;
end;


end.


