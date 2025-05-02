unit Unit1;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DelphiZXingQRCode,
  StdCtrls, ExtCtrls, Clipbrd, Buttons;

type

  { TForm1 }

  TForm1 = class(TForm)
    Bevel1: TBevel;
    btnGenerate: TButton;
    btnSave: TButton;
    Button1: TButton;
    edtText: TEdit;
    ImageList1: TImageList;
    imgQR: TImage;
    SaveDialog1: TSaveDialog;
    SpeedButton1: TSpeedButton;
    procedure btnGenerateClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    QRCode: TDelphiZXingQRCode;
    procedure GenerateQRCode(AText: string);
    function GetTextFromClipboard: string;
  public

  end;

var
  Form1: TForm1;

implementation
uses Unit2;

{$R *.lfm}

procedure TForm1.btnGenerateClick(Sender: TObject);
begin
  btnSave.Enabled:=false;
  GenerateQRCode(edtText.Text);
  if length(edtText.Text) > 0 then btnSave.Enabled:=true;
end;

procedure TForm1.btnSaveClick(Sender: TObject);
begin
  if imgQR.Picture.Bitmap.Empty then Exit;

  SaveDialog1.Filter := 'PNG Image|*.png|Bitmap|*.bmp';
  if SaveDialog1.Execute then
  begin
    if ExtractFileExt(SaveDialog1.FileName) = '.png' then
      imgQR.Picture.SaveToFile(SaveDialog1.FileName)
    else
      imgQR.Picture.Bitmap.SaveToFile(SaveDialog1.FileName);
    ShowMessage('QR-код сохранен!');
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  With TForm2.Create(Application) do
      try
        ShowModal
      finally
        Free
      end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  edtText.Text:=GetTextFromClipboard;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  edtText.Text:=GetTextFromClipboard;
end;

procedure TForm1.GenerateQRCode(AText: string);
var
  Bitmap: TBitmap;
  Row, Column: Integer;
begin
  if AText = '' then Exit;

  QRCode := TDelphiZXingQRCode.Create;
  try
    QRCode.Data := AText;
    QRCode.Encoding := 0; // Auto
    QRCode.QuietZone := 4;

    Bitmap := TBitmap.Create;
    try
      Bitmap.SetSize(QRCode.Rows, QRCode.Columns);
      Bitmap.Canvas.Brush.Color := clWhite;
      Bitmap.Canvas.FillRect(0, 0, Bitmap.Width, Bitmap.Height);

      for Row := 0 to QRCode.Rows - 1 do
        for Column := 0 to QRCode.Columns - 1 do
          if QRCode.IsBlack[Row, Column] then
            Bitmap.Canvas.Pixels[Column, Row] := clBlack;

      imgQR.Picture.Assign(Bitmap);
      imgQR.Stretch := True;
    finally
      Bitmap.Free;
    end;
  finally
    QRCode.Free;
  end;
end;

function TForm1.GetTextFromClipboard: string;
begin
  Result := '';
  // Проверяем, есть ли в буфере обмена текст
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    Result := Clipboard.AsText;
  end
  else
  begin
    MessageDlg('Буфер обмена не содержит текста!', mtWarning, [mbOK], 0);
    Result := '';
  end;
end;

end.

