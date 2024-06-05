unit UGameInterface;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, UGameMap, UTTankType,
  UShellType, UEnemyTanks, UEnemyShells,
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
    DeleteExpSmallPlayer1: TTimer;
    DeleteExpSmallPlayer2: TTimer;
    DeleteExpBigBase: TTimer;
    EnemyTank1Movement: TTimer;
    EnemyTank1SetDirection: TTimer;
    EnemyTank2Movement: TTimer;
    EnemyTank2SetDirection: TTimer;
    EnemyTank3Movement: TTimer;
    EnemyTank4Movement: TTimer;
    EnemyTank3SetDirection: TTimer;
    EnemyTank4SetDirection: TTimer;
    DeleteExpBigPlayer: TTimer;
    DeleteExpBigEnemy1: TTimer;
    DeleteExpBigEnemy2: TTimer;
    DeleteExpBigEnemy3: TTimer;
    DeleteExpBigEnemy4: TTimer;
    Enemy1ShellMovement: TTimer;
    DeleteExpSmallEnemy11: TTimer;
    DeleteExpSmallEnemy12: TTimer;
    Enemy2ShellMovement: TTimer;
    DeleteExpSmallEnemy21: TTimer;
    DeleteExpSmallEnemy22: TTimer;
    Enemy3ShellMovement: TTimer;
    DeleteExpSmallEnemy31: TTimer;
    DeleteExpSmallEnemy32: TTimer;
    Enemy4ShellMovement: TTimer;
    DeleteExpSmallEnemy41: TTimer;
    DeleteExpSmallEnemy42: TTimer;
    Enemy1Shoot: TTimer;
    Enemy2Shoot: TTimer;
    Enemy3Shoot: TTimer;
    Enemy4Shoot: TTimer;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PlayerTankMovementTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure PlayerShellMovementTimer(Sender: TObject);
    procedure DeleteExpSmallPlayer1Timer(Sender: TObject);
    procedure DeleteExpSmallPlayer2Timer(Sender: TObject);
    procedure DeleteExpBigBaseTimer(Sender: TObject);
    procedure EnemyTank1SetDirectionTimer(Sender: TObject);
    procedure EnemyTank1MovementTimer(Sender: TObject);
    procedure EnemyTank2MovementTimer(Sender: TObject);
    procedure EnemyTank2SetDirectionTimer(Sender: TObject);
    procedure EnemyTank3MovementTimer(Sender: TObject);
    procedure EnemyTank3SetDirectionTimer(Sender: TObject);
    procedure EnemyTank4MovementTimer(Sender: TObject);
    procedure EnemyTank4SetDirectionTimer(Sender: TObject);
    procedure DeleteExpBigPlayerTimer(Sender: TObject);
    procedure DeleteExpBigEnemy1Timer(Sender: TObject);
    procedure DeleteExpBigEnemy2Timer(Sender: TObject);
    procedure DeleteExpBigEnemy3Timer(Sender: TObject);
    procedure DeleteExpBigEnemy4Timer(Sender: TObject);
    procedure Enemy1ShellMovementTimer(Sender: TObject);
    procedure Enemy2ShellMovementTimer(Sender: TObject);
    procedure Enemy3ShellMovementTimer(Sender: TObject);
    procedure Enemy4ShellMovementTimer(Sender: TObject);
    procedure DeleteExpSmallEnemy11Timer(Sender: TObject);
    procedure DeleteExpSmallEnemy12Timer(Sender: TObject);
    procedure DeleteExpSmallEnemy21Timer(Sender: TObject);
    procedure DeleteExpSmallEnemy22Timer(Sender: TObject);
    procedure DeleteExpSmallEnemy31Timer(Sender: TObject);
    procedure DeleteExpSmallEnemy32Timer(Sender: TObject);
    procedure DeleteExpSmallEnemy41Timer(Sender: TObject);
    procedure DeleteExpSmallEnemy42Timer(Sender: TObject);
    procedure Enemy1ShootTimer(Sender: TObject);
    procedure Enemy2ShootTimer(Sender: TObject);
    procedure Enemy3ShootTimer(Sender: TObject);
    procedure Enemy4ShootTimer(Sender: TObject);
  end;

  TParam = record
    line, column, k: integer;
  end;

  TDeletePlayerArr = array [1 .. 4] of TParam;
  TEnemyArr = array [1 .. 4] of TDeletePlayerArr;

var
  GameInterface: TGameInterface;
  DeletePlayer: TDeletePlayerArr;
  DeleteEnemy: TEnemyArr;
  pressedKeyCode, kBase, EnemyTankNum: integer;

implementation

{$R *.dfm}

procedure TGameInterface.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  pressedKeyCode := Key;
end;

/// //////
procedure TGameInterface.DeleteExpBigBaseTimer(Sender: TObject);
begin
  if kBase = 1 then
  begin
    GameScreen.Canvas.Rectangle(ColumnBase * subobjlen, LineBase * subobjlen,
      ColumnBase * subobjlen + objlen, LineBase * subobjlen + objlen);
    kBase := 0;
    GameScreen.Canvas.Draw(ColumnBase * subobjlen, LineBase * subobjlen,
      staticobjimg[2]);
    self.DeleteExpBigBase.Enabled := false;
    self.PlayerTankMovement.Enabled := false;
    self.PlayerShellMovement.Enabled := false;
    self.EnemyTank1Movement.Enabled := false;
    self.EnemyTank1SetDirection.Enabled := false;
    self.Enemy1ShellMovement.Enabled := false;
    self.Enemy1Shoot.Enabled := false;
    self.EnemyTank2Movement.Enabled := false;
    self.EnemyTank2SetDirection.Enabled := false;
    self.Enemy2ShellMovement.Enabled := false;
    self.Enemy2Shoot.Enabled := false;
    self.EnemyTank3Movement.Enabled := false;
    self.EnemyTank3SetDirection.Enabled := false;
    self.Enemy3ShellMovement.Enabled := false;
    self.Enemy3Shoot.Enabled := false;
    self.EnemyTank4Movement.Enabled := false;
    self.EnemyTank4SetDirection.Enabled := false;
    self.Enemy4ShellMovement.Enabled := false;
    self.Enemy4Shoot.Enabled := false;
  end
  else
    inc(kBase);
end;

/// ////////
procedure TGameInterface.PlayerTankMovementTimer(Sender: TObject);
begin
  PlayerTank.PlayerMove(pressedKeyCode, GameInterface.GameScreen);
  PlayerTank.PlayerShoot(pressedKeyCode);
  pressedKeyCode := -100;
end;

procedure TGameInterface.PlayerShellMovementTimer(Sender: TObject);

begin
  PlayerShell.PlayerShellMove(GameInterface.GameScreen);
end;

procedure TGameInterface.DeleteExpSmallPlayer1Timer(Sender: TObject);
begin
  if DeletePlayer[1].k = 1 then
  begin
    GameScreen.Canvas.Rectangle(DeletePlayer[1].column * subobjlen,
      DeletePlayer[1].line * subobjlen, DeletePlayer[1].column * subobjlen +
      subobjlen, DeletePlayer[1].line * subobjlen + subobjlen);
    DeletePlayer[1].k := 0;
    self.DeleteExpSmallPlayer1.Enabled := false;
  end
  else
    inc(DeletePlayer[1].k);
end;

procedure TGameInterface.DeleteExpSmallPlayer2Timer(Sender: TObject);
begin
  if DeletePlayer[2].k = 1 then
  begin
    GameScreen.Canvas.Rectangle(DeletePlayer[2].column * subobjlen,
      DeletePlayer[2].line * subobjlen, DeletePlayer[2].column * subobjlen +
      subobjlen, DeletePlayer[2].line * subobjlen + subobjlen);
    DeletePlayer[2].k := 0;
    self.DeleteExpSmallPlayer2.Enabled := false;
  end
  else
    inc(DeletePlayer[2].k);
end;

procedure TGameInterface.DeleteExpBigPlayerTimer(Sender: TObject);
begin
  if DeletePlayer[4].k = 1 then
  begin
    GameScreen.Canvas.Rectangle(PlayerTank.DP[0].X, PlayerTank.DP[0].Y,
      PlayerTank.DP[3].X + 1, PlayerTank.DP[3].Y + 1);
    DeletePlayer[4].k := 0;
    self.DeleteExpBigPlayer.Enabled := false;
  end
  else
    inc(DeletePlayer[4].k);
end;

/// ////////
procedure TGameInterface.EnemyTank1SetDirectionTimer(Sender: TObject);

begin
  EnemyTanks[1].direction := random(4);
end;

procedure TGameInterface.EnemyTank1MovementTimer(Sender: TObject);

begin
  EnemyTanks[1].EnemyMove(GameInterface.GameScreen);
end;

procedure TGameInterface.Enemy1ShellMovementTimer(Sender: TObject);
begin
  EnemyShells[1].EnemyShellMove(GameInterface.GameScreen, 1);
end;

procedure TGameInterface.Enemy1ShootTimer(Sender: TObject);
begin
  EnemyTanks[1].EnemyShoot();
end;

procedure TGameInterface.DeleteExpSmallEnemy11Timer(Sender: TObject);
begin
  if DeleteEnemy[1][1].k = 1 then
  begin
    GameScreen.Canvas.Rectangle(DeleteEnemy[1][1].column * subobjlen,
      DeleteEnemy[1][1].line * subobjlen, DeleteEnemy[1][1].column * subobjlen +
      subobjlen, DeleteEnemy[1][1].line * subobjlen + subobjlen);
    DeleteEnemy[1][1].k := 0;
    self.DeleteExpSmallEnemy11.Enabled := false;
  end
  else
    inc(DeleteEnemy[1][1].k);
end;

procedure TGameInterface.DeleteExpSmallEnemy12Timer(Sender: TObject);
begin
  if DeleteEnemy[1][2].k = 1 then
  begin
    GameScreen.Canvas.Rectangle(DeleteEnemy[1][2].column * subobjlen,
      DeleteEnemy[1][2].line * subobjlen, DeleteEnemy[1][2].column * subobjlen +
      subobjlen, DeleteEnemy[1][2].line * subobjlen + subobjlen);
    DeleteEnemy[1][2].k := 0;
    self.DeleteExpSmallEnemy12.Enabled := false;
  end
  else
    inc(DeleteEnemy[1][2].k);
end;

procedure TGameInterface.DeleteExpBigEnemy1Timer(Sender: TObject);

begin
  if DeleteEnemy[1][4].k = 1 then
  begin
    GameScreen.Canvas.Rectangle(EnemyTanks[1].DP[0].X, EnemyTanks[1].DP[0].Y,
      EnemyTanks[1].DP[3].X + 1, EnemyTanks[1].DP[3].Y + 1);
    DeleteEnemy[1][4].k := 0;
    self.DeleteExpBigEnemy1.Enabled := false;
  end
  else
    inc(DeleteEnemy[1][4].k);
end;

/// ///////////
procedure TGameInterface.EnemyTank2MovementTimer(Sender: TObject);
begin
  EnemyTanks[2].EnemyMove(GameInterface.GameScreen);
end;

procedure TGameInterface.EnemyTank2SetDirectionTimer(Sender: TObject);
begin
  EnemyTanks[2].direction := random(4);
end;

procedure TGameInterface.Enemy2ShellMovementTimer(Sender: TObject);
begin
  EnemyShells[2].EnemyShellMove(GameInterface.GameScreen, 2);
end;

procedure TGameInterface.Enemy2ShootTimer(Sender: TObject);
begin
  EnemyTanks[2].EnemyShoot();
end;

procedure TGameInterface.DeleteExpSmallEnemy21Timer(Sender: TObject);
begin
  if DeleteEnemy[2][1].k = 1 then
  begin
    GameScreen.Canvas.Rectangle(DeleteEnemy[2][1].column * subobjlen,
      DeleteEnemy[2][1].line * subobjlen, DeleteEnemy[2][1].column * subobjlen +
      subobjlen, DeleteEnemy[2][1].line * subobjlen + subobjlen);
    DeleteEnemy[2][1].k := 0;
    self.DeleteExpSmallEnemy21.Enabled := false;
  end
  else
    inc(DeleteEnemy[2][1].k);
end;

procedure TGameInterface.DeleteExpSmallEnemy22Timer(Sender: TObject);
begin
  if DeleteEnemy[2][2].k = 1 then
  begin
    GameScreen.Canvas.Rectangle(DeleteEnemy[2][2].column * subobjlen,
      DeleteEnemy[2][2].line * subobjlen, DeleteEnemy[2][2].column * subobjlen +
      subobjlen, DeleteEnemy[2][2].line * subobjlen + subobjlen);
    DeleteEnemy[2][2].k := 0;
    self.DeleteExpSmallEnemy22.Enabled := false;
  end
  else
    inc(DeleteEnemy[2][2].k);
end;

procedure TGameInterface.DeleteExpBigEnemy2Timer(Sender: TObject);
begin
  if DeleteEnemy[2][4].k = 1 then
  begin
    GameScreen.Canvas.Rectangle(EnemyTanks[2].DP[0].X, EnemyTanks[2].DP[0].Y,
      EnemyTanks[2].DP[3].X + 1, EnemyTanks[2].DP[3].Y + 1);
    DeleteEnemy[2][4].k := 0;
    self.DeleteExpBigEnemy2.Enabled := false;
  end
  else
    inc(DeleteEnemy[2][4].k);
end;

/// /////////
procedure TGameInterface.EnemyTank3MovementTimer(Sender: TObject);
begin
  EnemyTanks[3].EnemyMove(GameInterface.GameScreen);
end;

procedure TGameInterface.EnemyTank3SetDirectionTimer(Sender: TObject);
begin
  EnemyTanks[3].direction := random(4);
end;

procedure TGameInterface.Enemy3ShellMovementTimer(Sender: TObject);
begin
  EnemyShells[3].EnemyShellMove(GameInterface.GameScreen, 3);
end;

procedure TGameInterface.Enemy3ShootTimer(Sender: TObject);
begin
  EnemyTanks[3].EnemyShoot();
end;

procedure TGameInterface.DeleteExpSmallEnemy31Timer(Sender: TObject);
begin
  if DeleteEnemy[3][1].k = 1 then
  begin
    GameScreen.Canvas.Rectangle(DeleteEnemy[3][1].column * subobjlen,
      DeleteEnemy[3][1].line * subobjlen, DeleteEnemy[3][1].column * subobjlen +
      subobjlen, DeleteEnemy[3][1].line * subobjlen + subobjlen);
    DeleteEnemy[3][1].k := 0;
    self.DeleteExpSmallEnemy31.Enabled := false;
  end
  else
    inc(DeleteEnemy[3][1].k);
end;

procedure TGameInterface.DeleteExpSmallEnemy32Timer(Sender: TObject);
begin
  if DeleteEnemy[3][2].k = 1 then
  begin
    GameScreen.Canvas.Rectangle(DeleteEnemy[3][2].column * subobjlen,
      DeleteEnemy[3][2].line * subobjlen, DeleteEnemy[3][2].column * subobjlen +
      subobjlen, DeleteEnemy[3][2].line * subobjlen + subobjlen);
    DeleteEnemy[3][2].k := 0;
    self.DeleteExpSmallEnemy32.Enabled := false;
  end
  else
    inc(DeleteEnemy[3][2].k);
end;

procedure TGameInterface.DeleteExpBigEnemy3Timer(Sender: TObject);
begin
  if DeleteEnemy[3][4].k = 1 then
  begin
    GameScreen.Canvas.Rectangle(EnemyTanks[3].DP[0].X, EnemyTanks[3].DP[0].Y,
      EnemyTanks[3].DP[3].X + 1, EnemyTanks[3].DP[3].Y + 1);
    DeleteEnemy[3][4].k := 0;
    self.DeleteExpBigEnemy3.Enabled := false;
  end
  else
    inc(DeleteEnemy[3][4].k);
end;

/// ////////
procedure TGameInterface.EnemyTank4MovementTimer(Sender: TObject);
begin
  EnemyTanks[4].EnemyMove(GameInterface.GameScreen);
end;

procedure TGameInterface.EnemyTank4SetDirectionTimer(Sender: TObject);
begin
  EnemyTanks[4].direction := random(4);
end;

procedure TGameInterface.Enemy4ShellMovementTimer(Sender: TObject);
begin
  EnemyShells[4].EnemyShellMove(GameInterface.GameScreen, 4);
end;

procedure TGameInterface.Enemy4ShootTimer(Sender: TObject);
begin
  EnemyTanks[4].EnemyShoot();
end;

procedure TGameInterface.DeleteExpSmallEnemy41Timer(Sender: TObject);
begin
  if DeleteEnemy[4][1].k = 1 then
  begin
    GameScreen.Canvas.Rectangle(DeleteEnemy[4][1].column * subobjlen,
      DeleteEnemy[4][1].line * subobjlen, DeleteEnemy[4][1].column * subobjlen +
      subobjlen, DeleteEnemy[4][1].line * subobjlen + subobjlen);
    DeleteEnemy[4][1].k := 0;
    self.DeleteExpSmallEnemy41.Enabled := false;
  end
  else
    inc(DeleteEnemy[4][1].k);
end;

procedure TGameInterface.DeleteExpSmallEnemy42Timer(Sender: TObject);
begin
  if DeleteEnemy[4][2].k = 1 then
  begin
    GameScreen.Canvas.Rectangle(DeleteEnemy[4][2].column * subobjlen,
      DeleteEnemy[4][2].line * subobjlen, DeleteEnemy[4][2].column * subobjlen +
      subobjlen, DeleteEnemy[4][2].line * subobjlen + subobjlen);
    DeleteEnemy[4][2].k := 0;
    self.DeleteExpSmallEnemy42.Enabled := false;
  end
  else
    inc(DeleteEnemy[4][2].k);
end;

procedure TGameInterface.DeleteExpBigEnemy4Timer(Sender: TObject);
begin
  if DeleteEnemy[4][4].k = 1 then
  begin
    GameScreen.Canvas.Rectangle(EnemyTanks[4].DP[0].X, EnemyTanks[4].DP[0].Y,
      EnemyTanks[4].DP[3].X + 1, EnemyTanks[4].DP[3].Y + 1);
    DeleteEnemy[4][4].k := 0;
    self.DeleteExpBigEnemy4.Enabled := false;
  end
  else
    inc(DeleteEnemy[4][4].k);
end;

/// ///////////

procedure TGameInterface.FormActivate(Sender: TObject);
begin
  randomize;

  self.GameScreen.Canvas.Brush.Color := clBlack;
  self.GameScreen.Canvas.Pen.Color := clBlack;
  self.GameScreen.Height := MapSize;
  self.GameScreen.Width := MapSize;

  StaticObjImgArrInit(staticobjimg);
  PlayerTankImgArrInit();
  EnemyTankImgArrInit();
  ExpImgInit();

  EnemyTankNum := 1;

  DrawBackGround(GameInterface.GameScreen);
  LoadMapFromFile(GameInterface.GameScreen, '..\maps\level1.txt');

  PlayerTank := TTank.Create(320, 960);
  EnemyTanks[1] := TEnemyTank.Create(EnemyCoordsSpawn[1].X,
    EnemyCoordsSpawn[1].Y, 1);
  EnemyTanks[2] := TEnemyTank.Create(EnemyCoordsSpawn[2].X,
    EnemyCoordsSpawn[2].Y, 2);
  EnemyTanks[3] := TEnemyTank.Create(EnemyCoordsSpawn[3].X,
    EnemyCoordsSpawn[3].Y, 3);
  EnemyTanks[4] := TEnemyTank.Create(EnemyCoordsSpawn[4].X,
    EnemyCoordsSpawn[4].Y, 4);
end;

end.
