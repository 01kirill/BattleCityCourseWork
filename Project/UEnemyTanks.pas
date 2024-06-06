unit UEnemyTanks;

interface

uses
  Vcl.Graphics, Vcl.ExtCtrls, System.Classes;

const
  DirImgCnt = 4;
  DimPntCnt = 4;
  TankSize = 80;
  EnemyCount = 4;
  eTankSpeed = 5;

type
  TCoords = record
    X, Y: integer;
  end;

  TEnemyCoordSpawn = array [1 .. EnemyCount] of TCoords;

  TDimPntArr = array [0 .. DirImgCnt - 1] of TCoords;

  TDirImgArr = array [0 .. DirImgCnt - 1] of TBitMap;

  TEnemyTankr = record
    direction: integer;
    DP: TDimPntArr;
    isShotMade, isDestroyed: boolean;

  end;

  TEnemies = array [1 .. EnemyCount] of TEnemyTankr;

procedure EnemyTankImgArrInit();

procedure CreateEnemyTank(X: integer; Y: integer; num: integer);

procedure MoveEnemyTank(screen: TImage; num: integer);

procedure ShootEnemyTank1(num: integer);
procedure ShootEnemyTank2(num: integer);
procedure ShootEnemyTank3(num: integer);
procedure ShootEnemyTank4(num: integer);

var
  EnemyTankImg: TDirImgArr;
  EnemyTanks: TEnemies;
  EnemyCoordsSpawn: TEnemyCoordSpawn;

implementation

uses
  UGameInterface, UGameMap, UTTankType, UShellTYpe, UEnemyShells;

procedure CreateEnemyTank(X: integer; Y: integer; num: integer);

var
  i, j: integer;

begin
  EnemyTanks[num].direction := 2;
  EnemyTanks[num].isDestroyed := false;
  EnemyTanks[num].isShotMade := false;
  EnemyTanks[num].DP[0].X := X;
  EnemyTanks[num].DP[0].Y := Y;
  EnemyTanks[num].DP[1].X := X + TankSize - 1;
  EnemyTanks[num].DP[1].Y := Y;
  EnemyTanks[num].DP[2].X := X;
  EnemyTanks[num].DP[2].Y := Y + TankSize - 1;
  EnemyTanks[num].DP[3].X := X + TankSize - 1;
  EnemyTanks[num].DP[3].Y := Y + TankSize - 1;
  for i := EnemyTanks[num].DP[0].Y to EnemyTanks[num].DP[3].Y do
    for j := EnemyTanks[num].DP[0].X to EnemyTanks[num].DP[3].X do
      TankPxMap[i][j] := -num;
end;

procedure MoveEnemyTank(screen: TImage; num: integer);

  function CheckBorder(direction: integer): boolean;

  var
    res: boolean;

  begin
    res := false;
    case direction of
      0:
        res := ((EnemyTanks[num].DP[0].Y > 0) and
          (EnemyTanks[num].DP[1].Y > 0));
      1:
        res := ((EnemyTanks[num].DP[1].X < MapSize - 1) and
          (EnemyTanks[num].DP[3].X < MapSize - 1));
      2:
        res := ((EnemyTanks[num].DP[2].Y < MapSize - 1) and
          (EnemyTanks[num].DP[3].Y < MapSize - 1));
      3:
        res := ((EnemyTanks[num].DP[0].X > 0) and
          (EnemyTanks[num].DP[2].X > 0));
    end;
    result := res;
  end;

  function CheckObjId(Id: integer): boolean;

  var
    res: boolean;

  begin
    case Id of
      0:
        res := true;
      4 .. 5:
        res := true;
    else
      res := false;
    end;
    result := res;
  end;

  function CheckTank(Id, num: integer): boolean;

  var
    res: boolean;

  begin
    res := false;
    case num of
      1:
        case Id of
          - 2, -3, -4, -10:
            res := false;
          0:
            res := true;
        end;
      2:
        case Id of
          - 1, -3, -4, -10:
            res := false;
          0:
            res := true;
        end;
      3:
        case Id of
          - 2, -1, -4, -10:
            res := false;
          0:
            res := true;
        end;
      4:
        case Id of
          - 2, -3, -1, -10:
            res := false;
          0:
            res := true;
        end;
    end;
    result := res;
  end;

var
  isAbleToMove1, isAbleToMove2, isAbleToMove3: boolean;
  i, k, l: integer;
  PntToMov1, PntToMov2, PntToMov3: TCoords;

begin
  isAbleToMove3 := false;
  screen.Canvas.Rectangle(EnemyTanks[num].DP[0].X, EnemyTanks[num].DP[0].Y,
    EnemyTanks[num].DP[3].X + 1, EnemyTanks[num].DP[3].Y + 1);
  for k := EnemyTanks[num].DP[0].Y to EnemyTanks[num].DP[3].Y do
    for l := EnemyTanks[num].DP[0].X to EnemyTanks[num].DP[3].X do
      TankPxMap[k][l] := 0;
  isAbleToMove1 := CheckBorder(EnemyTanks[num].direction);
  isAbleToMove2 := CheckBorder(EnemyTanks[num].direction);
  if isAbleToMove1 and isAbleToMove2 then
  begin
    case EnemyTanks[num].direction of
      0:
        begin
          PntToMov1 := EnemyTanks[num].DP[0];
          PntToMov2 := EnemyTanks[num].DP[1];
          dec(PntToMov1.Y);
          dec(PntToMov2.Y);
          PntToMov3.X := PntToMov1.X + TankSize div 2 - 1;
          PntToMov3.Y := PntToMov1.Y;
        end;
      1:
        begin
          PntToMov1 := EnemyTanks[num].DP[1];
          PntToMov2 := EnemyTanks[num].DP[3];
          inc(PntToMov1.X);
          inc(PntToMov2.X);
          PntToMov3.X := PntToMov1.X;
          PntToMov3.Y := PntToMov1.Y + TankSize div 2 - 1;
        end;
      2:
        begin
          PntToMov1 := EnemyTanks[num].DP[2];
          PntToMov2 := EnemyTanks[num].DP[3];
          inc(PntToMov1.Y);
          inc(PntToMov2.Y);
          PntToMov3.X := PntToMov1.X + TankSize div 2 - 1;
          PntToMov3.Y := PntToMov1.Y;
        end;
      3:
        begin
          PntToMov1 := EnemyTanks[num].DP[0];
          PntToMov2 := EnemyTanks[num].DP[2];
          dec(PntToMov1.X);
          dec(PntToMov2.X);
          PntToMov3.X := PntToMov1.X;
          PntToMov3.Y := PntToMov1.Y + TankSize div 2 - 1;
        end;
    end;
    isAbleToMove1 := CheckObjId(PxMap[PntToMov1.Y][PntToMov1.X]);
    isAbleToMove2 := CheckObjId(PxMap[PntToMov2.Y][PntToMov2.X]);
    isAbleToMove3 := CheckObjId(PxMap[PntToMov3.Y][PntToMov3.X]);
  end;
  if isAbleToMove1 and isAbleToMove2 and isAbleToMove3 then
  begin
    isAbleToMove1 := CheckTank(TankPxMap[PntToMov1.Y][PntToMov1.X], num);
    isAbleToMove2 := CheckTank(TankPxMap[PntToMov2.Y][PntToMov2.X], num);
    if isAbleToMove1 and isAbleToMove2 then
      for i := 0 to DimPntCnt - 1 do
        case EnemyTanks[num].direction of
          0:
            dec(EnemyTanks[num].DP[i].Y, eTankSpeed);
          1:
            inc(EnemyTanks[num].DP[i].X, eTankSpeed);
          2:
            inc(EnemyTanks[num].DP[i].Y, eTankSpeed);
          3:
            dec(EnemyTanks[num].DP[i].X, eTankSpeed);
        end;
  end;
  screen.Canvas.Draw(EnemyTanks[num].DP[0].X, EnemyTanks[num].DP[0].Y,
    EnemyTankImg[EnemyTanks[num].direction]);
  for k := EnemyTanks[num].DP[0].Y to EnemyTanks[num].DP[3].Y do
    for l := EnemyTanks[num].DP[0].X to EnemyTanks[num].DP[3].X do
      TankPxMap[k][l] := -num;

  for i := 0 to length(ForestObj) - 1 do
    screen.Canvas.Draw(ForestObj[i].X, ForestObj[i].Y, StaticObjImg[4]);
  for i := 0 to length(SteelObj) - 1 do
    screen.Canvas.Draw(SteelObj[i].X, SteelObj[i].Y, StaticObjImg[6]);

end;

procedure ShootEnemyTank1(num: integer);

var
  code: integer;

begin
  if not EnemyTanks[num].isShotMade then
  begin
    code := random(2);
    case code of
      1:
        EnemyTanks[num].isShotMade := true;
      0:
        EnemyTanks[num].isShotMade := false;
    end;
    if EnemyTanks[num].isShotMade then
    begin
      CreateEnemyShell(EnemyTanks[num].direction, EnemyTanks[num].DP[0].X,
        EnemyTanks[num].DP[0].Y, num);
      GameInterface.Enemy1ShellMovement.Enabled := true;
    end;
  end;
end;

procedure ShootEnemyTank2(num: integer);

var
  code: integer;

begin
  if not EnemyTanks[num].isShotMade then
  begin
    code := random(2);
    case code of
      1:
        EnemyTanks[num].isShotMade := true;
      0:
        EnemyTanks[num].isShotMade := false;
    end;
    if EnemyTanks[num].isShotMade then
    begin
      CreateEnemyShell(EnemyTanks[num].direction, EnemyTanks[num].DP[0].X,
        EnemyTanks[num].DP[0].Y, num);
      GameInterface.Enemy2ShellMovement.Enabled := true;
    end;
  end;
end;

procedure ShootEnemyTank3(num: integer);

var
  code: integer;

begin
  if not EnemyTanks[num].isShotMade then
  begin
    code := random(2);
    case code of
      1:
        EnemyTanks[num].isShotMade := true;
      0:
        EnemyTanks[num].isShotMade := false;
    end;
    if EnemyTanks[num].isShotMade then
    begin
      CreateEnemyShell(EnemyTanks[num].direction, EnemyTanks[num].DP[0].X,
        EnemyTanks[num].DP[0].Y, num);
      GameInterface.Enemy3ShellMovement.Enabled := true;
    end;
  end;
end;

procedure ShootEnemyTank4(num: integer);

var
  code: integer;

begin
  if not EnemyTanks[num].isShotMade then
  begin
    code := random(2);
    case code of
      1:
        EnemyTanks[num].isShotMade := true;
      0:
        EnemyTanks[num].isShotMade := false;
    end;
    if EnemyTanks[num].isShotMade then
    begin
      CreateEnemyShell(EnemyTanks[num].direction, EnemyTanks[num].DP[0].X,
        EnemyTanks[num].DP[0].Y, num);
      GameInterface.Enemy4ShellMovement.Enabled := true;
    end;
  end;
end;

procedure EnemyTankImgArrInit();

var
  i: integer;

begin
  for i := 0 to DirImgCnt - 1 do
    EnemyTankImg[i] := TBitMap.Create;
  EnemyTankImg[0].LoadFromFile('..\icons\EnemyTank\etUp.bmp');
  EnemyTankImg[1].LoadFromFile('..\icons\EnemyTank\etRight.bmp');
  EnemyTankImg[2].LoadFromFile('..\icons\EnemyTank\etDown.bmp');
  EnemyTankImg[3].LoadFromFile('..\icons\EnemyTank\etLeft.bmp');
  EnemyCoordsSpawn[1].X := 0;
  EnemyCoordsSpawn[1].Y := 0;
  EnemyCoordsSpawn[2].X := 320;
  EnemyCoordsSpawn[2].Y := 0;
  EnemyCoordsSpawn[3].X := 640;
  EnemyCoordsSpawn[3].Y := 0;
  EnemyCoordsSpawn[4].X := 960;
  EnemyCoordsSpawn[4].Y := 0;
end;

end.
