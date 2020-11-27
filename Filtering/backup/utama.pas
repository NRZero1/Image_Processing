unit utama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ExtDlgs;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnLoad: TButton;
    btnLPF: TButton;
    btnHPF1: TButton;
    btnHPF0: TButton;
    Image1: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    procedure btnLoadClick(Sender: TObject);
    procedure btnLPFClick(Sender: TObject);
    function Grayscale(x,y: Integer): Byte;
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

uses
  windows;

var
  bitmapR, bitmapG, bitmapB: array[0..1000, 0..1000] of Byte;

procedure TForm1.btnLoadClick(Sender: TObject);
var
  x,y: Integer;
begin
  if OpenPictureDialog1.Execute then
  begin
    Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    for y:=0 to Image1.Height do
    begin
      for x:=0 to Image1.Width do
      begin
        bitmapR[x,y] := GetRValue(Image1.Canvas.Pixels[x,y]);
        bitmapG[x,y] := GetGValue(Image1.Canvas.Pixels[x,y]);
        bitmapB[x,y] := GetBValue(Image1.Canvas.Pixels[x,y]);
      end;
    end;
  end;
end;

procedure TForm1.btnLPFClick(Sender: TObject);
var
  x,y: Integer;
  kernel: array[1..3, 1..3] of Single =
  (
    (1.0/9.0, 1.0/9.0, 1.0/9.0),
    (1.0/9.0, 1.0/9.0, 1.0/9.0),
    (1.0/9.0, 1.0/9.0, 1.0/9.0)
  );
  i,j: Integer;
  index_x, index_y: Integer;
  filterR, filterG, filterB: Double;
begin
  for y:=0 to Image1.Height do
  begin
    for x:=0 to Image1.Width do
    begin
      filterR := 0;
      filterG := 0;
      filterB := 0;

      for i:=1 to 3 do
      begin
        for j:=1 to 3 do
        begin
          index_x := x - i - 2;
          index_y := y - j - 2;

          if index_x < 0 then
          begin
            index_x := 0;
          end;

          if index_x > Image1.Width-1 then
          begin
            index_x := Image1.Width-1;
          end;

          if index_y < 0 then
          begin
            index_y := 0;
          end;

          if index_y > Image1.Height-1 then
          begin
            index_y := Image1.Height-1;
          end;

          filterR := filterR + GetRValue(Image1.Canvas.Pixels[index_x, index_y]) * kernel[i,j];
          filterG := filterG + GetGValue(Image1.Canvas.Pixels[index_x, index_y]) * kernel[i,j];
          filterB := filterB + GetBValue(Image1.Canvas.Pixels[index_x, index_y]) * kernel[i,j];
        end;
      end;

      if filterR < 0 then
      begin
        filterR := 0;
      end;

      if filterR > 255 then
      begin
        filterR := 255;
      end;

      if filterG < 0 then
      begin
        filterG := 0;
      end;

      if filterG > 255 then
      begin
        filterG := 255;
      end;

      if filterB < 0 then
      begin
        filterB := 0;
      end;

      if filterB > 255 then
      begin
        filterB := 255;
      end;

      Image1.Canvas.Pixels[x,y] := RGB(Round(filterR), Round(filterG), Round(filterB));
    end;
  end;
end;

function TForm1.Grayscale(x,y: Integer): Byte;
var
  gray: Byte;
begin
  gray := (bitmapR[x,y] + bitmapG[x,y] + bitmapB[x,y]) div 3;
  Grayscale := gray;
end;

end.

