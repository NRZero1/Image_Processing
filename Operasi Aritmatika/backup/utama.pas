unit utama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, ExtDlgs;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnBiner_1: TButton;
    btnBiner_2: TButton;
    btnLoad_1: TButton;
    btnReset: TButton;
    btnSave: TButton;
    btnLoad_2: TButton;
    btnStegano: TButton;
    btnBlending: TButton;
    btnExecute: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    groupMenu: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    lblBiner: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    OpenPictureDialog2: TOpenPictureDialog;
    radioJumlah: TRadioButton;
    radioKurang: TRadioButton;
    radioKali: TRadioButton;
    radioBagi: TRadioButton;
    radioOR: TRadioButton;
    radioAND: TRadioButton;
    radioXOR: TRadioButton;
    radioXNOR: TRadioButton;
    radioRed: TRadioButton;
    radioGreen: TRadioButton;
    radioBlue: TRadioButton;
    radioBlack: TRadioButton;
    SavePictureDialog1: TSavePictureDialog;
    trackBiner: TTrackBar;
    procedure btnBiner_1Click(Sender: TObject);
    procedure btnBiner_2Click(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure btnLoad_1Click(Sender: TObject);
    procedure btnLoad_2Click(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure GrayScale(functionCalls: Byte);
    //procedure EdgeDetection();
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
  bitmapR, bitmapG, bitmapB: array [0..1000, 0..1000] of Byte;
  bitmapR2, bitmapG2, bitmapB2: array [0..1000, 0..1000] of Byte;
  bitmapBiner: array[0..1000, 0..1000] of Boolean;
  bitmapBiner2: array[0..1000, 0..1000] of Boolean;
  bitmapBiner3: array[0..1000, 0..1000] of Boolean;

procedure TForm1.btnLoad_1Click(Sender: TObject);
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

procedure TForm1.btnLoad_2Click(Sender: TObject);
var
  x, y: Integer;
begin
  if OpenPictureDialog2.Execute then
  Image2.Picture.LoadFromFile(OpenPictureDialog2.FileName);
  begin
    for y:=0 to Image1.Height-1 do
    begin
      for x:=0 to Image1.Width-1 do
      begin
        bitmapR2[x,y] := GetRValue(Image2.Canvas.Pixels[x,y]);
        bitmapG2[x,y] := GetGValue(Image2.Canvas.Pixels[x,y]);
        bitmapB2[x,y] := GetBValue(Image2.Canvas.Pixels[x,y]);
      end;
    end;
  end;
end;

procedure TForm1.btnSaveClick(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
  begin
    Image3.Picture.SaveToFile(SavePictureDialog1.FileName);
  end;
end;

procedure TForm1.GrayScale(functionCalls: Byte);
var
  x, y: Integer;
  gray: Byte;
begin
  gray := 0;
  if functionCalls = 1 then
  begin
    for y:=0 to Image1.Height-1 do
    begin
      for x:=0 to Image1.Width-1 do
      begin
        gray := (bitmapR[x,y] + bitmapG[x,y] + bitmapB[x,y]) div 3;
        Image1.Canvas.Pixels[x,y] := RGB(gray, gray, gray);
      end;
    end;
  end;

  if functionCalls = 2 then
  begin
    for y:=0 to Image2.Height-1 do
    begin
      for x:=0 to Image2.Width-1 do
      begin
        gray := (bitmapR2[x,y] + bitmapG2[x,y] + bitmapB2[x,y]) div 3;
        Image2.Canvas.Pixels[x,y] := RGB(gray, gray, gray);
      end;
    end;
  end;
end;

procedure TForm1.btnBiner_1Click(Sender: TObject);
var
  x, y: Integer;
  functionCalls: Byte;
begin
  lblBiner.Caption := IntToStr(trackBiner.Position);
  functionCalls := 1;
  Grayscale(functionCalls);

  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      if Red(Image1.Canvas.Pixels[x,y]) > trackBiner.Position then
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
        Image1.Canvas.Pixels[x,y] := RGB(255, 255, 255)
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

procedure TForm1.btnBiner_2Click(Sender: TObject);
var
  x, y: Integer;
  functionCalls: Byte;
begin
  lblBiner.Caption := IntToStr(trackBiner.Position);
  functionCalls := 2;
  Grayscale(functionCalls);

  for y:=0 to Image2.Height-1 do
  begin
    for x:=0 to Image2.Width-1 do
    begin
      if Red(Image2.Canvas.Pixels[x,y]) > trackBiner.Position then
      begin
        bitmapBiner2[x,y] := true;
      end
      else
      begin
        bitmapBiner2[x,y] := false;
      end;
    end;
  end;

  for y:=0 to Image2.Height-1 do
  begin
    for x:=0 to Image2.Width-1 do
    begin
      if bitmapBiner2[x,y] then
      begin
        Image2.Canvas.Pixels[x,y] := RGB(255, 255, 255);
      end
      else
      begin
        if radioRed.Checked then
        begin
          Image2.Canvas.Pixels[x,y] := RGB(255, 0, 0);
        end
        else if radioGreen.Checked then
        begin
          Image2.Canvas.Pixels[x,y] := RGB(0, 255, 0);
        end
        else if radioBlue.Checked then
        begin
          Image2.Canvas.Pixels[x,y] := RGB(0, 0, 255);
        end
        else
        begin
          Image2.Canvas.Pixels[x,y] := RGB(0 ,0 ,0);
        end;
      end;
    end;
  end;
end;

{procedure TForm1.EdgeDetection();
var
  kernel: array[1..3, 1..3] of Integer =
    ((-1, -1, -1),
     (-1, 8, -1),
     (-1, -1 -1));
begin
end;}

procedure TForm1.btnExecuteClick(Sender: TObject);
var
  x, y: Integer;
  bitmapBinerTemp: array[0..1000, 0..1000] of Integer;
begin
  Image3.Width := Image1.Width;
  Image3.Height := Image1.Height;

  if radioJumlah.Checked then
  begin
    for y:=0 to Image1.Height-1 do
    begin
      for x:=0 to Image1.Width-1 do
      begin
        bitmapBinerTemp[x,y] := bitmapBiner[x,y].ToInteger + bitmapBiner2[x,y].ToInteger;
        bitmapBiner3[x,y] := bitmapBinerTemp[x,y].ToBoolean;
        if bitmapBiner3[x,y] then
        begin
          Image3.Canvas.Pixels[x,y] := RGB(255, 255, 255);
        end
        else
        begin
          if radioRed.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(255, 0, 0);
          end
          else if radioGreen.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 255, 0);
          end
          else if radioBlue.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 0, 255);
          end
          else
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 0, 0);
          end;
        end;
      end;
    end;
  end
  else if radioKurang.Checked then
  begin
    for y:=0 to Image1.Height-1 do
    begin
      for x:=0 to Image1.Width-1 do
      begin
        bitmapBinerTemp[x,y] := bitmapBiner[x,y].ToInteger - bitmapBiner2[x,y].ToInteger;
        bitmapBiner3[x,y] := bitmapBinerTemp[x,y].ToBoolean;
        if bitmapBiner3[x,y] then
        begin
          Image3.Canvas.Pixels[x,y] := RGB(255, 255, 255);
        end
        else
        begin
          if radioRed.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(255, 0, 0);
          end
          else if radioGreen.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 255, 0);
          end
          else if radioBlue.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 0, 255);
          end
          else
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 0, 0);
          end;
        end;
      end;
    end;
  end
  else if radioKali.Checked then
  begin
    for y:=0 to Image1.Height-1 do
    begin
      for x:=0 to Image1.Width-1 do
      begin
        bitmapBinerTemp[x,y] := bitmapBiner[x,y].ToInteger * bitmapBiner2[x,y].ToInteger;
        bitmapBiner3[x,y] := bitmapBinerTemp[x,y].ToBoolean;
        if bitmapBiner3[x,y] then
        begin
          Image3.Canvas.Pixels[x,y] := RGB(255, 255, 255);
        end
        else
        begin
          if radioRed.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(255, 0, 0);
          end
          else if radioGreen.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 255, 0);
          end
          else if radioBlue.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 0, 255);
          end
          else
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 0, 0);
          end;
        end;
      end;
    end;
  end
  else if radioBagi.Checked then
  begin
    for y:=0 to Image1.Height-1 do
    begin
      for x:=0 to Image1.Width-1 do
      begin
        bitmapBinerTemp[x,y] := bitmapBiner[x,y].ToInteger div bitmapBiner2[x,y].ToInteger;
        bitmapBiner3[x,y] := bitmapBinerTemp[x,y].ToBoolean;
        if bitmapBiner3[x,y] then
        begin
          Image3.Canvas.Pixels[x,y] := RGB(255, 255, 255);
        end
        else
        begin
          if radioRed.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(255, 0, 0);
          end
          else if radioGreen.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 255, 0);
          end
          else if radioBlue.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 0, 255);
          end
          else
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 0, 0);
          end;
        end;
      end;
    end;
  end
  else if radioAND.Checked then
  begin
    for y:=0 to Image1.Height-1 do
    begin
      for x:=0 to Image1.Width-1 do
      begin
        bitmapBiner3[x,y] := bitmapBiner[x,y] and bitmapBiner2[x,y];
        if bitmapBiner3[x,y] then
        begin
          Image3.Canvas.Pixels[x,y] := RGB(255, 255, 255);
        end
        else
        begin
          if radioRed.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(255, 0, 0);
          end
          else if radioGreen.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 255, 0);
          end
          else if radioBlue.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 0, 255);
          end
          else
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 0, 0);
          end;
        end;
      end;
    end;
  end
  else if radioOR.Checked then
  begin
    for y:=0 to Image1.Height-1 do
    begin
      for x:=0 to Image1.Width-1 do
      begin
        bitmapBiner3[x,y] := bitmapBiner[x,y] or bitmapBiner2[x,y];
        if bitmapBiner3[x,y] then
        begin
          Image3.Canvas.Pixels[x,y] := RGB(255, 255, 255);
        end
        else
        begin
          if radioRed.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(255, 0, 0);
          end
          else if radioGreen.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 255, 0);
          end
          else if radioBlue.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 0, 255);
          end
          else
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 0, 0);
          end;
        end;
      end;
    end;
  end
  else if radioXOR.Checked then
  begin
    for y:=0 to Image1.Height-1 do
    begin
      for x:=0 to Image1.Width-1 do
      begin
        bitmapBiner3[x,y] := bitmapBiner2[x,y] xor bitmapBiner[x,y] ;
        if bitmapBiner3[x,y] then
        begin
          Image3.Canvas.Pixels[x,y] := RGB(255, 255, 255);
        end
        else
        begin
          if radioRed.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(255, 0, 0);
          end
          else if radioGreen.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 255, 0);
          end
          else if radioBlue.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 0, 255);
          end
          else
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 0, 0);
          end;
        end;
      end;
    end;
  end
  else if radioXNOR.Checked then
  begin
    for y:=0 to Image1.Height-1 do
    begin
      for x:=0 to Image1.Width-1 do
      begin
        bitmapBiner3[x,y] := not(bitmapBiner[x,y] xor bitmapBiner2[x,y]);
        if bitmapBiner3[x,y] then
        begin
          Image3.Canvas.Pixels[x,y] := RGB(255, 255, 255);
        end
        else
        begin
          if radioRed.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(255, 0, 0);
          end
          else if radioGreen.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 255, 0);
          end
          else if radioBlue.Checked then
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 0, 255);
          end
          else
          begin
            Image3.Canvas.Pixels[x,y] := RGB(0, 0, 0);
          end;
        end;
      end;
    end;
  end;
end;

end.

