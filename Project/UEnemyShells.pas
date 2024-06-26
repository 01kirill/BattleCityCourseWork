unit UEnemyShells;

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

  TEnemyShellr = record
    direction: integer;
    DP: TDimPntArr;
    img: TBitMap;
  end;

  TEnemyShells = array [1 .. 4] of TEnemyShellr;

procedure CreateEnemyShell(direction, X, Y, num: integer);
procedure MoveEnemyShell1(screen: TImage; num: integer);
procedure MoveEnemyShell2(screen: TImage; num: integer);
procedure MoveEnemyShell3(screen: TImage; num: integer);
procedure MoveEnemyShell4(screen: TImage; num: integer);

var
  EnemyShells: TEnemyShells;
  Sender: Tobject;

implementation

uses UGameInterface, UGameMap, UTTankType, UShellTYpe, UEnemyTanks;

procedure CreateEnemyShell(direction, X, Y, num: integer);

begin
  EnemyShells[num].direction := direction;
  EnemyShells[num].img := TBitMap.Create;
  EnemyShells[num].img.LoadFromFile('..\icons\Shell\s.bmp');
  case direction of
    0:
      begin
        EnemyShells[num].DP[0].X := X + TankSize div 2 - ShellSize div 2;
        EnemyShells[num].DP[0].Y := Y - ShellSize;
      end;
    1:
      begin
        EnemyShells[num].DP[0].X := X + TankSize;
        EnemyShells[num].DP[0].Y := Y + TankSize div 2 - ShellSize div 2;
      end;
    2:
      begin
        EnemyShells[num].DP[0].X := X + TankSize div 2 - ShellSize div 2;
        EnemyShells[num].DP[0].Y := Y + TankSize;
      end;
    3:
      begin
        EnemyShells[num].DP[0].X := X - ShellSize;
        EnemyShells[num].DP[0].Y := Y - ShellSize div 2 + TankSize div 2;
      end;
  end;
  EnemyShells[num].DP[1].X := EnemyShells[num].DP[0].X + ShellSize - 1;
  EnemyShells[num].DP[1].Y := EnemyShells[num].DP[0].Y;
  EnemyShells[num].DP[2].X := EnemyShells[num].DP[0].X;
  EnemyShells[num].DP[2].Y := EnemyShells[num].DP[0].Y + ShellSize - 1;
  EnemyShells[num].DP[3].X := EnemyShells[num].DP[0].X + ShellSize - 1;
  EnemyShells[num].DP[3].Y := EnemyShells[num].DP[0].Y + ShellSize - 1;
end;

function CheckBorder(direction, num: integer): boolean;

var
  res: boolean;

begin
  res := false;
  case direction of
    0:
      res := ((EnemyShells[num].DP[0].Y > 0) and
        (EnemyShells[num].DP[1].Y > 0));
    1:
      res := ((EnemyShells[num].DP[1].X < MapSize - 1) and
        (EnemyShells[num].DP[3].X < MapSize - 1));
    2:
      res := ((EnemyShells[num].DP[2].Y < MapSize - 1) and
        (EnemyShells[num].DP[3].Y < MapSize - 1));
    3:
      res := ((EnemyShells[num].DP[0].X > 0) and
        (EnemyShells[num].DP[2].X > 0));
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
    - 10:
      res := false;
    0, -1, -2, -3, -4:
      res := true;
  end;
  result := res;
end;

procedure SetPntToMov(var PntToMov1, PntToMov2: TCoords; dir, num: integer);

begin
  case dir of
    0:
      begin
        PntToMov1 := EnemyShells[num].DP[0];
        PntToMov2 := EnemyShells[num].DP[1];
        dec(PntToMov1.Y);
        dec(PntToMov2.Y);
      end;
    1:
      begin
        PntToMov1 := EnemyShells[num].DP[1];
        PntToMov2 := EnemyShells[num].DP[3];
        inc(PntToMov1.X);
        inc(PntToMov2.X);
      end;
    2:
      begin
        PntToMov1 := EnemyShells[num].DP[2];
        PntToMov2 := EnemyShells[num].DP[3];
        inc(PntToMov1.Y);
        inc(PntToMov2.Y);
      end;
    3:
      begin
        PntToMov1 := EnemyShells[num].DP[0];
        PntToMov2 := EnemyShells[num].DP[2];
        dec(PntToMov1.X);
        dec(PntToMov2.X);
      end;
  end;
end;

procedure MoveEnemyShell1(screen: TImage; num: integer);

var
  i, line, column, k, l: integer;
  isAbleToMove1, isAbleToMove2: boolean;
  PntToMov1, PntToMov2: TCoords;

begin
  screen.Canvas.Rectangle(EnemyShells[num].DP[0].X, EnemyShells[num].DP[0].Y,
    EnemyShells[num].DP[3].X + 1, EnemyShells[num].DP[3].Y + 1);
  isAbleToMove1 := CheckBorder(EnemyShells[num].direction, num);
  isAbleToMove2 := CheckBorder(EnemyShells[num].direction, num);
  SetPntToMov(PntToMov1, PntToMov2, EnemyShells[num].direction, num);
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
          case EnemyShells[num].direction of
            0:
              dec(EnemyShells[num].DP[i].Y, ShellSpeed);
            1:
              inc(EnemyShells[num].DP[i].X, ShellSpeed);
            2:
              inc(EnemyShells[num].DP[i].Y, ShellSpeed);
            3:
              dec(EnemyShells[num].DP[i].X, ShellSpeed);
          end;
        for i := 0 to length(waterObj) - 1 do
          screen.Canvas.Draw(waterObj[i].X, waterObj[i].Y, StaticObjImg[7]);
        screen.Canvas.Draw(EnemyShells[num].DP[0].X, EnemyShells[num].DP[0].Y,
          EnemyShells[num].img);
        for i := 0 to length(ForestObj) - 1 do
          screen.Canvas.Draw(ForestObj[i].X, ForestObj[i].Y, StaticObjImg[4]);
      end
      else
      begin
        if not isAbleToMove1 then
        begin
          if TankPxMap[PntToMov1.Y][PntToMov1.X] = -10 then
          begin
            GameInterface.Enemy1ShellMovement.Enabled := false;
            GameInterface.PlayerTankMovement.Enabled := false;
            PlayerTank.isDestroyed := true;
            GameInterface.PlayerRespawn.Enabled := true;
            screen.Canvas.Draw(PlayerTank.DP[0].X, PlayerTank.DP[0].Y, ExpBig);
            GameInterface.DeleteExpBigPlayer.Enabled := true;
            for k := PlayerTank.DP[0].X to PlayerTank.DP[3].X do
              for l := PlayerTank.DP[0].Y to PlayerTank.DP[3].Y do
                TankPxMap[l][k] := 0;
            EnemyTanks[num].isShotMade := false;
          end;
        end;
        if not isAbleToMove2 then
        begin
          if TankPxMap[PntToMov2.Y][PntToMov2.X] = -10 then
          begin
            GameInterface.Enemy1ShellMovement.Enabled := false;
            GameInterface.PlayerTankMovement.Enabled := false;
            PlayerTank.isDestroyed := true;
            GameInterface.PlayerRespawn.Enabled := true;
            screen.Canvas.Draw(PlayerTank.DP[0].X, PlayerTank.DP[0].Y, ExpBig);
            GameInterface.DeleteExpBigPlayer.Enabled := true;
            for k := PlayerTank.DP[0].X to PlayerTank.DP[3].X do
              for l := PlayerTank.DP[0].Y to PlayerTank.DP[3].Y do
                TankPxMap[l][k] := 0;
            EnemyTanks[num].isShotMade := false;
          end;
        end;
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
          deleteEnemy[num][1].line := line;
          deleteEnemy[num][1].column := column;
          GameInterface.DeleteExpSmallEnemy11.Enabled := true;
        end;
        if PxMap[line * subobjlen][column * subobjlen] = 3 then
        begin
          screen.Canvas.Draw(columnbase * subobjlen,
            lineBase * subobjlen, ExpBig);
          GameInterface.DeleteExpBigBase.Enabled := true;
        end;
        GameInterface.Enemy1ShellMovement.Enabled := false;

        EnemyTanks[num].isShotMade := false;
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
          deleteEnemy[num][2].line := line;
          deleteEnemy[num][2].column := column;
          GameInterface.DeleteExpSmallEnemy12.Enabled := true;
        end;
        if PxMap[line * subobjlen][column * subobjlen] = 3 then
        begin
          screen.Canvas.Draw(columnbase * subobjlen,
            lineBase * subobjlen, ExpBig);
          GameInterface.DeleteExpBigBase.Enabled := true;
        end;
        GameInterface.Enemy1ShellMovement.Enabled := false;
        EnemyTanks[num].isShotMade := false;
      end;
    end;
  end
  else
  begin
    GameInterface.Enemy1ShellMovement.Enabled := false;
    EnemyTanks[num].isShotMade := false;
  end;
end;

procedure MoveEnemyShell2(screen: TImage; num: integer);

var
  i, line, column, k, l: integer;
  isAbleToMove1, isAbleToMove2: boolean;
  PntToMov1, PntToMov2: TCoords;

begin
  screen.Canvas.Rectangle(EnemyShells[num].DP[0].X, EnemyShells[num].DP[0].Y,
    EnemyShells[num].DP[3].X + 1, EnemyShells[num].DP[3].Y + 1);
  isAbleToMove1 := CheckBorder(EnemyShells[num].direction, num);
  isAbleToMove2 := CheckBorder(EnemyShells[num].direction, num);
  SetPntToMov(PntToMov1, PntToMov2, EnemyShells[num].direction, num);
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
          case EnemyShells[num].direction of
            0:
              dec(EnemyShells[num].DP[i].Y, ShellSpeed);
            1:
              inc(EnemyShells[num].DP[i].X, ShellSpeed);
            2:
              inc(EnemyShells[num].DP[i].Y, ShellSpeed);
            3:
              dec(EnemyShells[num].DP[i].X, ShellSpeed);
          end;
        for i := 0 to length(waterObj) - 1 do
          screen.Canvas.Draw(waterObj[i].X, waterObj[i].Y, StaticObjImg[7]);
        screen.Canvas.Draw(EnemyShells[num].DP[0].X, EnemyShells[num].DP[0].Y,
          EnemyShells[num].img);
        for i := 0 to length(ForestObj) - 1 do
          screen.Canvas.Draw(ForestObj[i].X, ForestObj[i].Y, StaticObjImg[4]);
      end
      else
      begin
        if not isAbleToMove1 then
        begin
          if TankPxMap[PntToMov1.Y][PntToMov1.X] = -10 then
          begin
            GameInterface.Enemy2ShellMovement.Enabled := false;
            GameInterface.PlayerTankMovement.Enabled := false;
            PlayerTank.isDestroyed := true;
            GameInterface.PlayerRespawn.Enabled := true;
            screen.Canvas.Draw(PlayerTank.DP[0].X, PlayerTank.DP[0].Y, ExpBig);
            GameInterface.DeleteExpBigPlayer.Enabled := true;
            for k := PlayerTank.DP[0].X to PlayerTank.DP[3].X do
              for l := PlayerTank.DP[0].Y to PlayerTank.DP[3].Y do
                TankPxMap[l][k] := 0;
            EnemyTanks[num].isShotMade := false;
          end;
        end;
        if not isAbleToMove2 then
        begin
          if TankPxMap[PntToMov2.Y][PntToMov2.X] = -10 then
          begin
            GameInterface.Enemy2ShellMovement.Enabled := false;
            GameInterface.PlayerTankMovement.Enabled := false;
            PlayerTank.isDestroyed := true;
            GameInterface.PlayerRespawn.Enabled := true;
            screen.Canvas.Draw(PlayerTank.DP[0].X, PlayerTank.DP[0].Y, ExpBig);
            GameInterface.DeleteExpBigPlayer.Enabled := true;
            for k := PlayerTank.DP[0].X to PlayerTank.DP[3].X do
              for l := PlayerTank.DP[0].Y to PlayerTank.DP[3].Y do
                TankPxMap[l][k] := 0;
            EnemyTanks[num].isShotMade := false;
          end;
        end;
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
          deleteEnemy[num][1].line := line;
          deleteEnemy[num][1].column := column;
          GameInterface.DeleteExpSmallEnemy21.Enabled := true;
        end;
        if PxMap[line * subobjlen][column * subobjlen] = 3 then
        begin
          screen.Canvas.Draw(columnbase * subobjlen,
            lineBase * subobjlen, ExpBig);
          GameInterface.DeleteExpBigBase.Enabled := true;
        end;
        GameInterface.Enemy2ShellMovement.Enabled := false;

        EnemyTanks[num].isShotMade := false;
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
          deleteEnemy[num][2].line := line;
          deleteEnemy[num][2].column := column;
          GameInterface.DeleteExpSmallEnemy22.Enabled := true;
        end;
        if PxMap[line * subobjlen][column * subobjlen] = 3 then
        begin
          screen.Canvas.Draw(columnbase * subobjlen,
            lineBase * subobjlen, ExpBig);
          GameInterface.DeleteExpBigBase.Enabled := true;
        end;
        GameInterface.Enemy2ShellMovement.Enabled := false;
        EnemyTanks[num].isShotMade := false;
      end;
    end;
  end
  else
  begin
    GameInterface.Enemy2ShellMovement.Enabled := false;
    EnemyTanks[num].isShotMade := false;
  end;
end;

procedure MoveEnemyShell3(screen: TImage; num: integer);

var
  i, line, column, k, l: integer;
  isAbleToMove1, isAbleToMove2: boolean;
  PntToMov1, PntToMov2: TCoords;

begin
  screen.Canvas.Rectangle(EnemyShells[num].DP[0].X, EnemyShells[num].DP[0].Y,
    EnemyShells[num].DP[3].X + 1, EnemyShells[num].DP[3].Y + 1);
  isAbleToMove1 := CheckBorder(EnemyShells[num].direction, num);
  isAbleToMove2 := CheckBorder(EnemyShells[num].direction, num);
  SetPntToMov(PntToMov1, PntToMov2, EnemyShells[num].direction, num);
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
          case EnemyShells[num].direction of
            0:
              dec(EnemyShells[num].DP[i].Y, ShellSpeed);
            1:
              inc(EnemyShells[num].DP[i].X, ShellSpeed);
            2:
              inc(EnemyShells[num].DP[i].Y, ShellSpeed);
            3:
              dec(EnemyShells[num].DP[i].X, ShellSpeed);
          end;
        for i := 0 to length(waterObj) - 1 do
          screen.Canvas.Draw(waterObj[i].X, waterObj[i].Y, StaticObjImg[7]);
        screen.Canvas.Draw(EnemyShells[num].DP[0].X, EnemyShells[num].DP[0].Y,
          EnemyShells[num].img);
        for i := 0 to length(ForestObj) - 1 do
          screen.Canvas.Draw(ForestObj[i].X, ForestObj[i].Y, StaticObjImg[4]);
      end
      else
      begin
        if not isAbleToMove1 then
        begin
          if TankPxMap[PntToMov1.Y][PntToMov1.X] = -10 then
          begin
            GameInterface.Enemy3ShellMovement.Enabled := false;
            GameInterface.PlayerTankMovement.Enabled := false;
            PlayerTank.isDestroyed := true;
            GameInterface.PlayerRespawn.Enabled := true;
            screen.Canvas.Draw(PlayerTank.DP[0].X, PlayerTank.DP[0].Y, ExpBig);
            GameInterface.DeleteExpBigPlayer.Enabled := true;
            for k := PlayerTank.DP[0].X to PlayerTank.DP[3].X do
              for l := PlayerTank.DP[0].Y to PlayerTank.DP[3].Y do
                TankPxMap[l][k] := 0;
            EnemyTanks[num].isShotMade := false;
          end;
        end;
        if not isAbleToMove2 then
        begin
          if TankPxMap[PntToMov2.Y][PntToMov2.X] = -10 then
          begin
            GameInterface.Enemy3ShellMovement.Enabled := false;
            GameInterface.PlayerTankMovement.Enabled := false;
            PlayerTank.isDestroyed := true;
            GameInterface.PlayerRespawn.Enabled := true;
            screen.Canvas.Draw(PlayerTank.DP[0].X, PlayerTank.DP[0].Y, ExpBig);
            GameInterface.DeleteExpBigPlayer.Enabled := true;
            for k := PlayerTank.DP[0].X to PlayerTank.DP[3].X do
              for l := PlayerTank.DP[0].Y to PlayerTank.DP[3].Y do
                TankPxMap[l][k] := 0;
            EnemyTanks[num].isShotMade := false;
          end;
        end;
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
          deleteEnemy[num][1].line := line;
          deleteEnemy[num][1].column := column;
          GameInterface.DeleteExpSmallEnemy31.Enabled := true;
        end;
        if PxMap[line * subobjlen][column * subobjlen] = 3 then
        begin
          screen.Canvas.Draw(columnbase * subobjlen,
            lineBase * subobjlen, ExpBig);
          GameInterface.DeleteExpBigBase.Enabled := true;
        end;
        GameInterface.Enemy3ShellMovement.Enabled := false;

        EnemyTanks[num].isShotMade := false;
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
          deleteEnemy[num][2].line := line;
          deleteEnemy[num][2].column := column;
          GameInterface.DeleteExpSmallEnemy32.Enabled := true;
        end;
        if PxMap[line * subobjlen][column * subobjlen] = 3 then
        begin
          screen.Canvas.Draw(columnbase * subobjlen,
            lineBase * subobjlen, ExpBig);
          GameInterface.DeleteExpBigBase.Enabled := true;
        end;
        GameInterface.Enemy3ShellMovement.Enabled := false;
        EnemyTanks[num].isShotMade := false;
      end;
    end;
  end
  else
  begin
    GameInterface.Enemy3ShellMovement.Enabled := false;
    EnemyTanks[num].isShotMade := false;
  end;
end;

procedure MoveEnemyShell4(screen: TImage; num: integer);

var
  i, line, column, k, l: integer;
  isAbleToMove1, isAbleToMove2: boolean;
  PntToMov1, PntToMov2: TCoords;

begin
  screen.Canvas.Rectangle(EnemyShells[num].DP[0].X, EnemyShells[num].DP[0].Y,
    EnemyShells[num].DP[3].X + 1, EnemyShells[num].DP[3].Y + 1);
  isAbleToMove1 := CheckBorder(EnemyShells[num].direction, num);
  isAbleToMove2 := CheckBorder(EnemyShells[num].direction, num);
  SetPntToMov(PntToMov1, PntToMov2, EnemyShells[num].direction, num);
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
          case EnemyShells[num].direction of
            0:
              dec(EnemyShells[num].DP[i].Y, ShellSpeed);
            1:
              inc(EnemyShells[num].DP[i].X, ShellSpeed);
            2:
              inc(EnemyShells[num].DP[i].Y, ShellSpeed);
            3:
              dec(EnemyShells[num].DP[i].X, ShellSpeed);
          end;
        for i := 0 to length(waterObj) - 1 do
          screen.Canvas.Draw(waterObj[i].X, waterObj[i].Y, StaticObjImg[7]);
        screen.Canvas.Draw(EnemyShells[num].DP[0].X, EnemyShells[num].DP[0].Y,
          EnemyShells[num].img);
        for i := 0 to length(ForestObj) - 1 do
          screen.Canvas.Draw(ForestObj[i].X, ForestObj[i].Y, StaticObjImg[4]);
      end
      else
      begin
        if not isAbleToMove1 then
        begin
          if TankPxMap[PntToMov1.Y][PntToMov1.X] = -10 then
          begin
            GameInterface.Enemy4ShellMovement.Enabled := false;
            GameInterface.PlayerTankMovement.Enabled := false;
            PlayerTank.isDestroyed := true;
            GameInterface.PlayerRespawn.Enabled := true;
            screen.Canvas.Draw(PlayerTank.DP[0].X, PlayerTank.DP[0].Y, ExpBig);
            GameInterface.DeleteExpBigPlayer.Enabled := true;
            for k := PlayerTank.DP[0].X to PlayerTank.DP[3].X do
              for l := PlayerTank.DP[0].Y to PlayerTank.DP[3].Y do
                TankPxMap[l][k] := 0;
            EnemyTanks[num].isShotMade := false;
          end;
        end;
        if not isAbleToMove2 then
        begin
          if TankPxMap[PntToMov2.Y][PntToMov2.X] = -10 then
          begin
            GameInterface.Enemy4ShellMovement.Enabled := false;
            GameInterface.PlayerTankMovement.Enabled := false;
            PlayerTank.isDestroyed := true;
            GameInterface.PlayerRespawn.Enabled := true;
            screen.Canvas.Draw(PlayerTank.DP[0].X, PlayerTank.DP[0].Y, ExpBig);
            GameInterface.DeleteExpBigPlayer.Enabled := true;
            for k := PlayerTank.DP[0].X to PlayerTank.DP[3].X do
              for l := PlayerTank.DP[0].Y to PlayerTank.DP[3].Y do
                TankPxMap[l][k] := 0;
            EnemyTanks[num].isShotMade := false;
          end;
        end;
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
          deleteEnemy[num][1].line := line;
          deleteEnemy[num][1].column := column;
          GameInterface.DeleteExpSmallEnemy41.Enabled := true;
        end;
        if PxMap[line * subobjlen][column * subobjlen] = 3 then
        begin
          screen.Canvas.Draw(columnbase * subobjlen,
            lineBase * subobjlen, ExpBig);
          GameInterface.DeleteExpBigBase.Enabled := true;
        end;
        GameInterface.Enemy4ShellMovement.Enabled := false;

        EnemyTanks[num].isShotMade := false;
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
          deleteEnemy[num][2].line := line;
          deleteEnemy[num][2].column := column;
          GameInterface.DeleteExpSmallEnemy42.Enabled := true;
        end;
        if PxMap[line * subobjlen][column * subobjlen] = 3 then
        begin
          screen.Canvas.Draw(columnbase * subobjlen,
            lineBase * subobjlen, ExpBig);
          GameInterface.DeleteExpBigBase.Enabled := true;
        end;
        GameInterface.Enemy4ShellMovement.Enabled := false;
        EnemyTanks[num].isShotMade := false;
      end;
    end;
  end
  else
  begin
    GameInterface.Enemy4ShellMovement.Enabled := false;
    EnemyTanks[num].isShotMade := false;
  end;
end;

end.
