unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, FileInfo;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    function GetProjectVersion: string;
  public

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.FormActivate(Sender: TObject);
var
  Info: TFileVersionInfo;
begin
  Memo1.Lines.Clear;
  Label2.Caption:='verion ' + GetProjectVersion;
  Info := TFileVersionInfo.Create(nil);
  try
    Info.ReadFileInfo;
    Memo1.Lines.Add(Info.VersionStrings.Values['FileDescription']);
    //Memo1.Lines.Add('Версия: ' + Info.VersionStrings.Values['FileVersion']);
    //Memo1.Lines.Add('Компания: ' + Info.VersionStrings.Values['CompanyName']);
  finally
    Info.Free;
  end;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  Close
end;

function TForm2.GetProjectVersion: string;
var
  FileVerInfo: TFileVersionInfo;
begin
  FileVerInfo := TFileVersionInfo.Create(nil);
  try
    FileVerInfo.ReadFileInfo;
    Result := FileVerInfo.VersionStrings.Values['FileVersion'];
  finally
    FileVerInfo.Free;
  end;
end;

end.

