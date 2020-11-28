unit utama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, ExtDlgs;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnBiner: TButton;
    btnErosi: TButton;
    btnDilasi: TButton;
    btnOpening: TButton;
    btnClosing: TButton;
    btnLoad: TButton;
    btnSave: TButton;
    btnReset: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Image1: TImage;
    lblBiner: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    radioRed: TRadioButton;
    radioGreen: TRadioButton;
    radioBlue: TRadioButton;
    radioBlack: TRadioButton;
    SavePictureDialog1: TSavePictureDialog;
    trackBiner: TTrackBar;
    procedure btnBinerClick(Sender: TObject);
    procedure btnDilasiClick(Sender: TObject);
    procedure btnErosiClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure trackBinerChange(Sender: TObject);
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
  bitmapBiner: array[0..1000, 0..1000] of Boolean;
  SE: array[1..3, 1..3] of Byte = ((1, 1, 1), (1, 1, 1), (1, 1, 1));
  erosi, dilasi: array[0..1000, 0..1000] of Byte;

procedure TForm1.FormShow(Sender: TObject);
begin
  trackBinerChange(Sender);
end;

procedure TForm1.trackBinerChange(Sender: TObject);
begin
  lblBiner.Caption := IntToStr(trackBiner.Position);
end;

procedure TForm1.btnLoadClick(Sender: TObject);
var
  x, y: Integer;
begin
  if OpenPictureDialog1.Execute then
  begin
    Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    for y:=0 to Image1.Height-1 do
    begin
      for x:=0 to Image1.Width-1 do
      begin
        bitmapR[x,y] := GetRValue(Image1.Canvas.Pixels[x,y]);
        bitmapG[x,y] := GetGValue(Image1.Canvas.Pixels[x,y]);
        bitmapB[x,y] := GetBValue(Image1.Canvas.Pixels[x,y]);
      end;
    end;
  end;
end;

procedure TForm1.btnResetClick(Sender: TObject);
var
  x,y : Integer;
begin
  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      Image1.Canvas.Pixels[x,y] := RGB(bitmapR[x,y], bitmapG[x,y], bitmapB[x,y]);
    end;
  end;
end;

procedure TForm1.btnBinerClick(Sender: TObject);
var
  x,y: Integer;
begin
  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      Image1.Canvas.Pixels[x,y] := Grayscale(x,y);
    end;
  end;

  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      if GetRValue(Image1.Canvas.Pixels[x,y]) > trackBiner.Position then
      begin
        bitmapBiner[x,y] := true;
      end
      else
      begin
        bitmapBiner[x,y] := false;
      end;
    end;
  end;

  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      if bitmapBiner[x,y] then
      begin
        Image1.Canvas.Pixels[x,y] := RGB(255, 255, 255);
      end
      else
      begin
        if radioRed.Checked then
        begin
          Image1.Canvas.Pixels[x,y] := RGB(255, 0, 0);
        end
        else if radioGreen.Checked then
        begin
          Image1.Canvas.Pixels[x,y] := RGB(0, 255, 0);
        end
        else if radioBlue.Checked then
        begin
          Image1.Canvas.Pixels[x,y] := RGB(0, 0, 255);
        end
        else
        begin
          Image1.Canvas.Pixels[x,y] := RGB(0, 0, 0);
        end;
      end;
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

procedure TForm1.btnErosiClick(Sender: TObject);
var
  x,y: Integer;
  i,j: Integer;
  index_x, index_y: Integer;
begin
  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      erosi[x,y] := 0;
    end;
  end;

  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      if bitmapBiner[x,y] then
      begin
        for j:=1 to 3 do
        begin
          for i:=1 to 3 do
          begin
            index_x := x - (i - 2);
            index_y := y - (j - 2);

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

            erosi[index_x, index_y] := erosi[index_x, index_y] + SE[i,j];
          end;
        end;
      end;

      if erosi[x,y] = 1 then
      begin
        Image1.Canvas.Pixels[x,y] := RGB(0, 0, 0);
      end
      else
      begin
        Image1.Canvas.Pixels[x,y] := RGB(255, 255, 255);
      end;
    end;
  end;
end;

procedure TForm1.btnDilasiClick(Sender: TObject);
var
  x,y: Integer;
  i,j: Integer;
  index_x, index_y: Integer;
begin
  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      dilasi[x,y] := 0;
    end;
  end;

  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      if bitmapBiner[x,y] then
      begin
        for j:=1 to 3 do
        begin
          for i:=1 to 3 do
          begin
            index_x := x - (i - 2);
            index_y := y - (j - 2);

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

            dilasi[index_x, index_y] := erosi[index_x, index_y] + SE[i,j];
          end;
        end;
      end;

      if dilasi[x,y] = 1 then
      begin
        Image1.Canvas.Pixels[x,y] := RGB(255, 255, 255);
      end
      else
      begin
        Image1.Canvas.Pixels[x,y] := RGB(0, 0, 0);
      end;
    end;
  end;
end;

end.

