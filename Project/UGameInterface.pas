unit UGameInterface;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, UGameMap, UTTankType,
  UShellType, UEnemyTanks, UEnemyShells, UMainMenu,
  System.Actions, Vcl.ActnList, Vcl.StdCtrls;

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
    PlayerRespawn: TTimer;
    Enemy1Respawn: TTimer;
    Enemy2Respawn: TTimer;
    Enemy3Respawn: TTimer;
    Enemy4Respawn: TTimer;
    EnemyLivesDespription: TLabel;
    EnemyLives: TLabel;
    UpdateInfoPanel: TTimer;
    PlayerLivesDescription: TLabel;
    PlayerLives: TLabel;
    GameCompleted: TLabel;
    CurrentLevelDescription: TLabel;
    CurrentlevelInfo: TLabel;
    LevelInit: TTimer;
    PlayerNameDescription: TLabel;
    ScoreDescription: TLabel;
    PlayerName: TLabel;
    Score: TLabel;
    WinLabel: TLabel;
    procedure EndGame(Sender: TObject; win: boolean);
    procedure StartLevel(Sender: TObject; path: string);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PlayerTankMovementTimer(Sender: TObject);
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
    procedure PlayerRespawnTimer(Sender: TObject);
    procedure Enemy1RespawnTimer(Sender: TObject);
    procedure Enemy2RespawnTimer(Sender: TObject);
    procedure Enemy3RespawnTimer(Sender: TObject);
    procedure Enemy4RespawnTimer(Sender: TObject);
    procedure UpdateInfoPanelTimer(Sender: TObject);
    procedure LevelInitTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  end;

  TParam = record
    line, column, k: integer;
  end;

  TDeletePlayerArr = array [1 .. 4] of TParam;
  TEnemyArr = array [1 .. 4] of TDeletePlayerArr;
  TLivesArr = array [0 .. 4] of integer;

var
  GameInterface: TGameInterface;
  DeletePlayer: TDeletePlayerArr;
  DeleteEnemy: TEnemyArr;
  path: string;
  pressedKeyCode, kBase, EnemyTankNum, currentLevel, PlayerScore: integer;
  lives: TLivesArr;
  pause: boolean;

implementation

{$R *.dfm}

procedure TGameInterface.FormActivate(Sender: TObject);
begin
  randomize;
  
  self.GameScreen.Canvas.Brush.Color := clblack;
  self.GameScreen.Canvas.Pen.Color := clblack;
  self.GameScreen.Height := MapSize;
  self.GameScreen.Width := MapSize;

  StaticObjImgArrInit(staticobjimg);
  PlayerTankImgArrInit();
  EnemyTankImgArrInit();
  ExpImgInit();

  EnemyTankNum := 1;
  currentLevel := 1;
  PlayerScore := 0;

  pause := false;

  path := '..\maps\level' + IntToStr(currentLevel) + '.txt';
  GameScreen.Canvas.Rectangle(0, 0, MapSize, MapSize);
  self.GameCompleted.Caption := 'Уровень ' + IntToStr(currentLevel);
  self.GameCompleted.Visible := true;
  self.LevelInit.Enabled := true;
end;

procedure TGameInterface.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  EndGame(Sender, false);
  self.WinLabel.Visible := false;
  self.Destroy;
  MainMenu.Show;
end;

procedure TGameInterface.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if MessageDlg('Вы уверены, что хотите выйти?', mtConfirmation, [mbOk, mbCancel], 0) = mrCancel then
    CanClose := false;
end;

procedure TGameInterface.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  pressedKeyCode := Key;
end;

procedure TGameInterface.LevelInitTimer(Sender: TObject);
begin
  StartLevel(Sender, path);
  self.GameCompleted.Visible := false;
  self.LevelInit.Enabled := false;
end;

procedure TGameInterface.UpdateInfoPanelTimer(Sender: TObject);

var
  i, sum: integer;
  Show: string;

begin
  sum := 0;
  for i := 1 to 4 do
    sum := sum + lives[i];
  Show := IntToStr(sum);
  if sum = 0 then
    EndGame(Sender, true);
  self.EnemyLives.Caption := Show;
  Show := IntToStr(lives[0]);
  self.PlayerLives.Caption := Show;
  Show := IntToStr(currentLevel);
  self.CurrentlevelInfo.Caption := Show;

  Show := IntToStr(PlayerScore);
  self.Score.Caption := Show;
end;

procedure TGameInterface.StartLevel(Sender: TObject; path: string);

begin
  PlayerTank := TTank.Create(320, 960);
  EnemyTanks[1] := TEnemyTank.Create(EnemyCoordsSpawn[1].X,
    EnemyCoordsSpawn[1].Y, 1);
  EnemyTanks[2] := TEnemyTank.Create(EnemyCoordsSpawn[2].X,
    EnemyCoordsSpawn[2].Y, 2);
  EnemyTanks[3] := TEnemyTank.Create(EnemyCoordsSpawn[3].X,
    EnemyCoordsSpawn[3].Y, 3);
  EnemyTanks[4] := TEnemyTank.Create(EnemyCoordsSpawn[4].X,
    EnemyCoordsSpawn[4].Y, 4);
  PlayerShell := TShell.Create(PlayerTank.direction, PlayerTank.DP[0].X,
    PlayerTank.DP[0].Y);
  EnemyShells[1] := TEnemyShell.Create(EnemyTanks[1].direction,
    EnemyTanks[1].DP[0].X, EnemyTanks[1].DP[0].Y);
  EnemyShells[2] := TEnemyShell.Create(EnemyTanks[2].direction,
    EnemyTanks[2].DP[0].X, EnemyTanks[2].DP[0].Y);
  EnemyShells[3] := TEnemyShell.Create(EnemyTanks[3].direction,
    EnemyTanks[3].DP[0].X, EnemyTanks[3].DP[0].Y);
  EnemyShells[4] := TEnemyShell.Create(EnemyTanks[4].direction,
    EnemyTanks[4].DP[0].X, EnemyTanks[4].DP[0].Y);

  DrawBackGround(GameInterface.GameScreen);
  LoadMapFromFile(GameInterface.GameScreen, path);

  self.UpdateInfoPanel.Enabled := true;
  self.PlayerTankMovement.Enabled := true;
  self.EnemyTank1Movement.Enabled := true;
  self.EnemyTank1SetDirection.Enabled := true;
  self.Enemy1Shoot.Enabled := true;
  self.EnemyTank2Movement.Enabled := true;
  self.EnemyTank2SetDirection.Enabled := true;
  self.Enemy2Shoot.Enabled := true;
  self.EnemyTank3Movement.Enabled := true;
  self.EnemyTank3SetDirection.Enabled := true;
  self.Enemy3Shoot.Enabled := true;
  self.EnemyTank4Movement.Enabled := true;
  self.EnemyTank4SetDirection.Enabled := true;
  self.Enemy4Shoot.Enabled := true;

  lives[0] := 3;
  for var i := 1 to 4 do
    lives[i] := 5;
end;

procedure TGameInterface.EndGame(Sender: TObject; win: boolean);

begin
  self.UpdateInfoPanel.Enabled := false;
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
  if win then
  begin
    inc(currentLevel);
    if currentLevel = 6 then
    begin
      inc(PlayerScore, 6000);
      GameScreen.Canvas.Rectangle(0, 0, MapSize, MapSize);
      self.WinLabel.Caption := 'Спасибо за прохождение игры!';
      self.WinLabel.Visible := true;
    end
    else
    begin
      SetLength(waterObj, 0);
      SetLength(forestObj, 0);
      SetLength(steelObj, 0);
      path := '..\maps\level' + IntToStr(currentLevel) + '.txt';
      GameScreen.Canvas.Rectangle(0, 0, MapSize, MapSize);
      self.GameCompleted.Caption := 'Уровень ' + IntToStr(currentLevel);
      inc(PlayerScore, 1000);
      self.GameCompleted.Visible := true;
      self.LevelInit.Enabled := true;
    end;
  end
  else
  begin
    GameScreen.Canvas.Rectangle(0, 0, MapSize, MapSize);
    self.WinLabel.Caption := 'Повезет в следующий раз...';
    self.WinLabel.Visible := true;
  end;
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
    EndGame(Sender, false);
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

procedure TGameInterface.PlayerRespawnTimer(Sender: TObject);
begin
  if PlayerTank.isDestroyed and (lives[0] > 0) then
  begin
    dec(lives[0]);
    if lives[0] > 0 then
    begin
      PlayerTank := TTank.Create(320, 960);
      self.PlayerTankMovement.Enabled := true;
      self.PlayerRespawn.Enabled := false;
    end
    else
      EndGame(Sender, false);
  end;
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

procedure TGameInterface.Enemy1RespawnTimer(Sender: TObject);
begin
  if EnemyTanks[1].isDestroyed and (lives[1] > 0) then
  begin
    inc(PlayerScore, 100);
    dec(lives[1]);
    if lives[1] > 0 then
    begin
      EnemyTanks[1] := TEnemyTank.Create(EnemyCoordsSpawn[1].X,
        EnemyCoordsSpawn[1].Y, 1);
      GameInterface.EnemyTank1Movement.Enabled := true;
      GameInterface.Enemy1Shoot.Enabled := true;
      GameInterface.EnemyTank1SetDirection.Enabled := true;
      EnemyTanks[1].isDestroyed := false;
      self.Enemy1Respawn.Enabled := false;
    end
  end;
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

procedure TGameInterface.Enemy2RespawnTimer(Sender: TObject);
begin
  if EnemyTanks[2].isDestroyed and (lives[2] > 0) then
  begin
    inc(PlayerScore, 100);
    dec(lives[2]);
    if lives[2] > 0 then
    begin
      EnemyTanks[2] := TEnemyTank.Create(EnemyCoordsSpawn[2].X,
        EnemyCoordsSpawn[2].Y, 2);
      GameInterface.EnemyTank2Movement.Enabled := true;
      GameInterface.Enemy2Shoot.Enabled := true;
      GameInterface.EnemyTank2SetDirection.Enabled := true;
      EnemyTanks[2].isDestroyed := false;
      self.Enemy2Respawn.Enabled := false;
    end
  end;
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

procedure TGameInterface.Enemy3RespawnTimer(Sender: TObject);
begin
  if EnemyTanks[3].isDestroyed and (lives[3] > 0) then
  begin
    inc(PlayerScore, 100);
    dec(lives[3]);
    if lives[3] > 0 then
    begin
      EnemyTanks[3] := TEnemyTank.Create(EnemyCoordsSpawn[3].X,
        EnemyCoordsSpawn[3].Y, 3);
      GameInterface.EnemyTank3Movement.Enabled := true;
      GameInterface.Enemy3Shoot.Enabled := true;
      GameInterface.EnemyTank3SetDirection.Enabled := true;
      EnemyTanks[3].isDestroyed := false;
      self.Enemy3Respawn.Enabled := false;
    end
  end;
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

procedure TGameInterface.Enemy4RespawnTimer(Sender: TObject);
begin
  if EnemyTanks[4].isDestroyed and (lives[4] > 0) then
  begin
    inc(PlayerScore, 100);
    dec(lives[4]);
    if lives[4] > 0 then
    begin
      EnemyTanks[4] := TEnemyTank.Create(EnemyCoordsSpawn[4].X,
        EnemyCoordsSpawn[4].Y, 4);
      GameInterface.EnemyTank4Movement.Enabled := true;
      GameInterface.Enemy4Shoot.Enabled := true;
      GameInterface.EnemyTank4SetDirection.Enabled := true;
      EnemyTanks[4].isDestroyed := false;
      self.Enemy4Respawn.Enabled := false;
    end
  end;
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

end.
