unit UGameInterface;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, UGameMap;

type
  TGameInterface = class(TForm)
    PaddingPanelUp: TPanel;
    PaddingPanelLeft: TPanel;
    PaddingPanelBottom: TPanel;
    GameInfo: TPanel;
    GameScreen: TImage;
    procedure FormActivate(Sender: TObject);
  end;

var
  GameInterface: TGameInterface;

implementation

{$R *.dfm}

procedure TGameInterface.FormActivate(Sender: TObject);
begin
  self.GameScreen.Canvas.Brush.Color := clBlack;
  self.GameScreen.Canvas.Pen.Color := clBlack;
  self.GameScreen.Height := MapSize;
  self.GameScreen.Width := MapSize;
  StaticObjImgArrInit(StaticObjImg, StaticObjImgCnt);
  DrawBackGround(MapSize);
  LoadMapFromFile('D:\work\Delphi\BattleCityCourseWork\Project\maps\level1.txt', PxMap, ObjCnt * SubObjCnt);
end;

end.
