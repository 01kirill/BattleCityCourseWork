unit UShellType;

interface

uses
  Vcl.Graphics, Vcl.ExtCtrls, System.Classes, System.SysUtils;

const
  DimPntCnt = 4;
  ShellSize = 10;
  ShellSpeed = 10;

type
  TCoords = record
    X, Y: integer;
  end;

  TDimPntArr = array [0 .. DimPntCnt - 1] of TCoords;

  TShell = class
    direction: integer;
    DP: TDimPntArr;
    img: TBitMap;
    constructor Create(direction, X, Y: integer);
    procedure PlayerShellMove(screen: TImage);
  end;

procedure ExpImgInit();

var
  PlayerShell: TShell;
  ExpBig, ExpSmall: TBitMap;

implementation

uses UGameInterface, UGameMap, UTTankType, UEnemyTanks, UEnemyShells;

procedure ExpImgInit();

begin
  ExpBig := TBitMap.Create;
  ExpBig.LoadFromFile('..\icons\Shell\e80.bmp');
  ExpSmall := TBitMap.Create;
  ExpSmall.LoadFromFile('..\icons\Shell\e40.bmp');
end;

constructor TShell.Create(direction, X, Y: integer);

begin
  self.direction := direction;
  self.img := TBitMap.Create;
  self.img.LoadFromFile('..\icons\Shell\s.bmp');
  case direction of
    0:
      begin
        self.DP[0].X := X + TankSize div 2 - ShellSize div 2;
        self.DP[0].Y := Y - ShellSize;
      end;
    1:
      begin
        self.DP[0].X := X + TankSize;
        self.DP[0].Y := Y + TankSize div 2 - ShellSize div 2;
      end;
    2:
      begin
        self.DP[0].X := X + TankSize div 2 - ShellSize div 2;
        self.DP[0].Y := Y + TankSize;
      end;
    3:
      begin
        self.DP[0].X := X - ShellSize;
        self.DP[0].Y := Y - ShellSize div 2 + TankSize div 2;
      end;
  end;
  self.DP[1].X := self.DP[0].X + ShellSize - 1;
  self.DP[1].Y := self.DP[0].Y;
  self.DP[2].X := self.DP[0].X;
  self.DP[2].Y := self.DP[0].Y + ShellSize - 1;
  self.DP[3].X := self.DP[0].X + ShellSize - 1;
  self.DP[3].Y := self.DP[0].Y + ShellSize - 1;
end;

procedure TShell.PlayerShellMove(screen: TImage);

  function CheckBorder(direction: integer): boolean;

  var
    res: boolean;

  begin
    res := false;
    case direction of
      0:
        res := ((self.DP[0].Y > 0) and (self.DP[1].Y > 0));
      1:
        res := ((self.DP[1].X < MapSize - 1) and (self.DP[3].X < MapSize - 1));
      2:
        res := ((self.DP[2].Y < MapSize - 1) and (self.DP[3].Y < MapSize - 1));
      3:
        res := ((self.DP[0].X > 0) and (self.DP[2].X > 0));
    end;
    result := res;
  end;

  function CheckObj(id: integer): boolean;

  var
    res: boolean;

  begin
    res := false;
    case id of
      0, 4, 5, 7:
        res := true;
      1, 2, 3, 6:
        res := false;
    end;
    result := res;
  end;

  function CheckEnemyTank(id: integer): boolean;

  var
    res: boolean;

  begin
    res := false;
    case id of
      - 1, -2, -3, -4:
        res := false;
      0, -10:
        res := true;
    end;
    result := res;
  end;

var
  i, line, column, k, l: integer;
  isAbleToMove1, isAbleToMove2: boolean;
  PntToMov1, PntToMov2: TCoords;

begin
  screen.Canvas.Rectangle(self.DP[0].X, self.DP[0].Y, self.DP[3].X + 1,
    self.DP[3].Y + 1);
  isAbleToMove1 := CheckBorder(self.direction);
  isAbleToMove2 := CheckBorder(self.direction);
  case self.direction of
    2:
      begin
        PntToMov1 := self.DP[0];
        PntToMov2 := self.DP[1];
        dec(PntToMov1.Y);
        dec(PntToMov2.Y);
      end;
    3:
      begin
        PntToMov1 := self.DP[1];
        PntToMov2 := self.DP[3];
        inc(PntToMov1.X);
        inc(PntToMov2.X);
      end;
    0:
      begin
        PntToMov1 := self.DP[2];
        PntToMov2 := self.DP[3];
        inc(PntToMov1.Y);
        inc(PntToMov2.Y);
      end;
    1:
      begin
        PntToMov1 := self.DP[0];
        PntToMov2 := self.DP[2];
        dec(PntToMov1.X);
        dec(PntToMov2.X);
      end;
  end;
  if isAbleToMove1 and isAbleToMove2 then
  begin

    isAbleToMove1 := CheckObj(PxMap[PntToMov1.Y][PntToMov1.X]);
    isAbleToMove2 := CheckObj(PxMap[PntToMov2.Y][PntToMov2.X]);
    if isAbleToMove1 and isAbleToMove2 then
    begin
      isAbleToMove1 := CheckEnemyTank(TankPxMap[PntToMov1.Y][PntToMov1.X]);
      isAbleToMove2 := CheckEnemyTank(TankPxMap[PntToMov2.Y][PntToMov2.X]);
      if isAbleToMove1 and isAbleToMove2 then
      begin
        for i := 0 to DimPntCnt - 1 do
          case self.direction of
            0:
              dec(self.DP[i].Y, ShellSpeed);
            1:
              inc(self.DP[i].X, ShellSpeed);
            2:
              inc(self.DP[i].Y, ShellSpeed);
            3:
              dec(self.DP[i].X, ShellSpeed);
          end;
        for i := 0 to length(waterObj) - 1 do
          screen.Canvas.Draw(waterObj[i].X, waterObj[i].Y, StaticObjImg[7]);
        screen.Canvas.Draw(self.DP[0].X, self.DP[0].Y, self.img);
        for i := 0 to length(ForestObj) - 1 do
          screen.Canvas.Draw(ForestObj[i].X, ForestObj[i].Y, StaticObjImg[4]);
      end
      else
      begin
        if not isAbleToMove1 then
        begin
          case TankPxMap[PntToMov1.Y][PntToMov1.X] of
            - 1:
              begin
                gameInterface.EnemyTank1Movement.Enabled := false;
                gameInterface.Enemy1Shoot.Enabled := false;
                gameInterface.EnemyTank1SetDirection.Enabled := false;
                Enemytanks[1].isDestroyed := true;
                gameInterface.Enemy1Respawn.Enabled := true;
                screen.Canvas.Draw(Enemytanks[1].DP[0].X,
                  Enemytanks[1].DP[0].Y, ExpBig);
                gameInterface.DeleteExpBigEnemy1.Enabled := true;
                for k := Enemytanks[1].DP[0].X to Enemytanks[1].DP[3].X do
                  for l := Enemytanks[1].DP[0].Y to Enemytanks[1].DP[3].Y do
                    TankPxMap[l][k] := 0;
              end;
            -2:
              begin
                gameInterface.EnemyTank2Movement.Enabled := false;
                gameInterface.Enemy2Shoot.Enabled := false;
                gameInterface.EnemyTank2SetDirection.Enabled := false;
                Enemytanks[2].isDestroyed := true;
                gameInterface.Enemy2Respawn.Enabled := true;
                screen.Canvas.Draw(Enemytanks[2].DP[0].X,
                  Enemytanks[2].DP[0].Y, ExpBig);
                gameInterface.DeleteExpBigEnemy2.Enabled := true;
                for k := Enemytanks[2].DP[0].X to Enemytanks[2].DP[3].X do
                  for l := Enemytanks[2].DP[0].Y to Enemytanks[2].DP[3].Y do
                    TankPxMap[l][k] := 0;
              end;
            -3:
              begin
                gameInterface.EnemyTank3Movement.Enabled := false;
                gameInterface.Enemy3Shoot.Enabled := false;
                gameInterface.EnemyTank3SetDirection.Enabled := false;
                Enemytanks[3].isDestroyed := true;
                gameInterface.Enemy3Respawn.Enabled := true;
                screen.Canvas.Draw(Enemytanks[3].DP[0].X,
                  Enemytanks[3].DP[0].Y, ExpBig);
                gameInterface.DeleteExpBigEnemy3.Enabled := true;
                for k := Enemytanks[3].DP[0].X to Enemytanks[2].DP[3].X do
                  for l := Enemytanks[3].DP[0].Y to Enemytanks[2].DP[3].Y do
                    TankPxMap[l][k] := 0;
              end;
            -4:
              begin
                gameInterface.EnemyTank4Movement.Enabled := false;
                gameInterface.Enemy4Shoot.Enabled := false;
                gameInterface.EnemyTank4SetDirection.Enabled := false;
                gameInterface.Enemy4Respawn.Enabled := true;
                Enemytanks[4].isDestroyed := true;
                screen.Canvas.Draw(Enemytanks[4].DP[0].X,
                  Enemytanks[4].DP[0].Y, ExpBig);
                gameInterface.DeleteExpBigEnemy4.Enabled := true;
                for k := Enemytanks[4].DP[0].X to Enemytanks[4].DP[3].X do
                  for l := Enemytanks[4].DP[0].Y to Enemytanks[4].DP[3].Y do
                    TankPxMap[l][k] := 0;
              end;
          end;
        end;
        if not isAbleToMove2 then
        begin
          case TankPxMap[PntToMov2.Y][PntToMov2.X] of
            - 1:
              begin
                gameInterface.EnemyTank1Movement.Enabled := false;
                gameInterface.Enemy1Shoot.Enabled := false;
                gameInterface.EnemyTank1SetDirection.Enabled := false;
                Enemytanks[1].isDestroyed := true;
                gameInterface.Enemy1Respawn.Enabled := true;
                screen.Canvas.Draw(Enemytanks[1].DP[0].X,
                  Enemytanks[1].DP[0].Y, ExpBig);
                gameInterface.DeleteExpBigEnemy1.Enabled := true;
                for k := Enemytanks[1].DP[0].X to Enemytanks[1].DP[3].X do
                  for l := Enemytanks[1].DP[0].Y to Enemytanks[1].DP[3].Y do
                    TankPxMap[l][k] := 0;
              end;
            -2:
              begin
                gameInterface.EnemyTank2Movement.Enabled := false;
                gameInterface.Enemy2Shoot.Enabled := false;
                gameInterface.EnemyTank2SetDirection.Enabled := false;
                Enemytanks[2].isDestroyed := true;
                gameInterface.Enemy2Respawn.Enabled := true;
                screen.Canvas.Draw(Enemytanks[2].DP[0].X,
                  Enemytanks[2].DP[0].Y, ExpBig);
                gameInterface.DeleteExpBigEnemy2.Enabled := true;
                for k := Enemytanks[2].DP[0].X to Enemytanks[2].DP[3].X do
                  for l := Enemytanks[2].DP[0].Y to Enemytanks[2].DP[3].Y do
                    TankPxMap[l][k] := 0;
              end;
            -3:
              begin
                gameInterface.EnemyTank3Movement.Enabled := false;
                gameInterface.Enemy3Shoot.Enabled := false;
                gameInterface.EnemyTank3SetDirection.Enabled := false;
                Enemytanks[3].isDestroyed := true;
                gameInterface.Enemy3Respawn.Enabled := true;
                screen.Canvas.Draw(Enemytanks[3].DP[0].X,
                  Enemytanks[3].DP[0].Y, ExpBig);
                gameInterface.DeleteExpBigEnemy3.Enabled := true;
                for k := Enemytanks[3].DP[0].X to Enemytanks[3].DP[3].X do
                  for l := Enemytanks[3].DP[0].Y to Enemytanks[3].DP[3].Y do
                    TankPxMap[l][k] := 0;
              end;
            -4:
              begin
                gameInterface.EnemyTank4Movement.Enabled := false;
                gameInterface.Enemy4Shoot.Enabled := false;
                gameInterface.EnemyTank4SetDirection.Enabled := false;
                Enemytanks[4].isDestroyed := true;
                gameInterface.Enemy4Respawn.Enabled := true;
                screen.Canvas.Draw(Enemytanks[4].DP[0].X,
                  Enemytanks[4].DP[0].Y, ExpBig);
                gameInterface.DeleteExpBigEnemy4.Enabled := true;
                for k := Enemytanks[4].DP[0].X to Enemytanks[4].DP[3].X do
                  for l := Enemytanks[4].DP[0].Y to Enemytanks[4].DP[3].Y do
                    TankPxMap[l][k] := 0;
              end;
          end;
        end;
        gameInterface.PlayerShellMovement.Enabled := false;
        PlayerTank.isShotMade := false;
      end;
    end
    else
    begin
      if not isAbleToMove1 then
      begin
        line := PntToMov1.Y div subobjlen;
        column := PntToMov1.X div subobjlen;
        if (PxMap[line * subobjlen][column * subobjlen] <> 6) and
          (PxMap[line * subobjlen][column * subobjlen] <> 3) then
        begin
          for k := line * subobjlen to line * subobjlen + subobjlen - 1 do
            for l := column * subobjlen to column * subobjlen + subobjlen - 1 do
              PxMap[k][l] := 0;
          screen.Canvas.Draw(column * subobjlen, line * subobjlen, ExpSmall);
          deletePlayer[1].line := line;
          deletePlayer[1].column := column;
          gameInterface.DeleteExpSmallPlayer1.Enabled := true;
        end;
        if PxMap[line * subobjlen][column * subobjlen] = 3 then
        begin
          screen.Canvas.Draw(columnbase * subobjlen,
            lineBase * subobjlen, ExpBig);
          gameInterface.DeleteExpBigBase.Enabled := true;
        end;
        gameInterface.PlayerShellMovement.Enabled := false;
        PlayerTank.isShotMade := false;
      end;
      if not isAbleToMove2 then
      begin
        line := PntToMov2.Y div subobjlen;
        column := PntToMov2.X div subobjlen;
        if (PxMap[line * subobjlen][column * subobjlen] <> 6) and
          (PxMap[line * subobjlen][column * subobjlen] <> 3) then
        begin
          for k := line * subobjlen to line * subobjlen + subobjlen - 1 do
            for l := column * subobjlen to column * subobjlen + subobjlen - 1 do
              PxMap[k][l] := 0;
          screen.Canvas.Draw(column * subobjlen, line * subobjlen, ExpSmall);
          deletePlayer[2].line := line;
          deletePlayer[2].column := column;
          gameInterface.DeleteExpSmallPlayer2.Enabled := true;
        end;
        if PxMap[line * subobjlen][column * subobjlen] = 3 then
        begin
          screen.Canvas.Draw(columnbase * subobjlen,
            lineBase * subobjlen, ExpBig);
          gameInterface.DeleteExpBigBase.Enabled := true;
        end;
        gameInterface.PlayerShellMovement.Enabled := false;
        PlayerTank.isShotMade := false;
      end;
    end;
  end
  else
  begin
    gameInterface.PlayerShellMovement.Enabled := false;
    PlayerTank.isShotMade := false;
  end;

end;

end.
