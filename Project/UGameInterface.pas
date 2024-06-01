unit UGameInterface;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, UGameMap, UTTankType,
  UShellType,
  System.Actions, Vcl.ActnList;

type
  TGameInterface = class(TForm)
    PaddingPanelUp: TPanel;
    PaddingPanelLeft: TPanel;
    PaddingPanelBottom: TPanel;
    GameInfo: TPanel;
    GameScreen: TImage;
    PlayerTankMovement: TTimer;
    PlayerShellMovement: TTimer;
    DeleteExpSmall1: TTimer;
    DeleteExpSmall2: TTimer;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PlayerTankMovementTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure PlayerShellMovementTimer(Sender: TObject);
    procedure DeleteExpSmall1Timer(Sender: TObject);
    procedure DeleteExpSmall2Timer(Sender: TObject);
  end;

var
  GameInterface: TGameInterface;
  pressedKeyCode, deleteLine1, deleteColumn1, deleteLine2, deleteColumn2, k1, k2: integer;

implementation

{$R *.dfm}

procedure TGameInterface.DeleteExpSmall1Timer(Sender: TObject);
begin
  if k1 = 1 then
  begin
    GameScreen.Canvas.Rectangle(deleteColumn1 * subobjlen,
      deleteLine1 * subobjlen, deleteColumn1 * subobjlen + subobjlen,
      deleteLine1 * subobjlen + subobjlen);
    k1 := 0;
    self.DeleteExpSmall1.Enabled := false;
  end;
  inc(k1);
end;

procedure TGameInterface.DeleteExpSmall2Timer(Sender: TObject);
begin
  if k2 = 1 then
  begin
    GameScreen.Canvas.Rectangle(deleteColumn2 * subobjlen,
      deleteLine2 * subobjlen, deleteColumn2 * subobjlen + subobjlen,
      deleteLine2 * subobjlen + subobjlen);
    k2 := 0;
    self.DeleteExpSmall2.Enabled := false;
  end;
  inc(k2);
end;

procedure TGameInterface.FormActivate(Sender: TObject);
begin
  self.GameScreen.Canvas.Brush.Color := clBlack;
  self.GameScreen.Canvas.Pen.Color := clBlack;
  self.GameScreen.Height := MapSize;
  self.GameScreen.Width := MapSize;

  StaticObjImgArrInit(StaticObjImg);
  PlayerTankImgArrInit();
  ExpImgInit();

  DrawBackGround(GameInterface.GameScreen);
  LoadMapFromFile(GameInterface.GameScreen, '..\maps\level1.txt');

  self.DeleteExpSmall1.enabled := true;
  self.PlayerTankMovement.enabled := true;
  self.PlayerTankMovement.Interval := 1;
  self.PlayerShellMovement.enabled := false;

  PlayerTank := TTank.Create(320, 960);
end;

procedure TGameInterface.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  pressedKeyCode := Key;
end;

procedure TGameInterface.PlayerShellMovementTimer(Sender: TObject);

begin
  PlayerShell.PlayerShellMove(GameInterface.GameScreen);
end;

procedure TGameInterface.PlayerTankMovementTimer(Sender: TObject);
begin
  PlayerTank.PlayerMove(pressedKeyCode, GameInterface.GameScreen);
  PlayerTank.PlayerShoot(pressedKeyCode);
  pressedKeyCode := -100;
end;

end.
