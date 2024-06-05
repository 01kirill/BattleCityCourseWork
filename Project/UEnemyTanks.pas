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

  TEnemyTank = class
    direction, num, lives: integer;
    DP: TDimPntArr;
    isShotMade, isDestroyed: boolean;

    constructor Create(X, Y, num: integer);
    procedure EnemyMove(screen: TImage);
    procedure EnemyShoot();
  end;

  TEnemies = array [1 .. EnemyCount] of TEnemyTank;

procedure EnemyTankImgArrInit();

var
  EnemyTankImg: TDirImgArr;
  EnemyTanks: TEnemies;
  EnemyCoordsSpawn: TEnemyCoordSpawn;

implementation

uses
  UGameInterface, UGameMap, UTTankType, UShellTYpe, UEnemyShells;

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

constructor TEnemyTank.Create(X: integer; Y: integer; num: integer);

var
  i, j: integer;

begin
  self.direction := 2;
  self.lives := 5;
  self.isDestroyed := false;
  self.num := num;
  self.isShotMade := false;
  self.DP[0].X := X;
  self.DP[0].Y := Y;
  self.DP[1].X := X + TankSize - 1;
  self.DP[1].Y := Y;
  self.DP[2].X := X;
  self.DP[2].Y := Y + TankSize - 1;
  self.DP[3].X := X + TankSize - 1;
  self.DP[3].Y := Y + TankSize - 1;
  for i := self.DP[0].Y to self.DP[3].Y do
    for j := self.DP[0].X to self.DP[3].X do
      TankPxMap[i][j] := -num;
end;

procedure TEnemyTank.EnemyMove(screen: TImage);

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
  screen.Canvas.Rectangle(self.DP[0].X, self.DP[0].Y, self.DP[3].X + 1,
    self.DP[3].Y + 1);
  for k := self.DP[0].Y to self.DP[3].Y do
    for l := self.DP[0].X to self.DP[3].X do
      TankPxMap[k][l] := 0;
  isAbleToMove1 := CheckBorder(self.direction);
  isAbleToMove2 := CheckBorder(self.direction);
  if isAbleToMove1 and isAbleToMove2 then
  begin
    case self.direction of
      0:
        begin
          PntToMov1 := self.DP[0];
          PntToMov2 := self.DP[1];
          dec(PntToMov1.Y);
          dec(PntToMov2.Y);
          PntToMov3.X := PntToMov1.X + TankSize div 2 - 1;
          PntToMov3.Y := PntToMov1.Y;
        end;
      1:
        begin
          PntToMov1 := self.DP[1];
          PntToMov2 := self.DP[3];
          inc(PntToMov1.X);
          inc(PntToMov2.X);
          PntToMov3.X := PntToMov1.X;
          PntToMov3.Y := PntToMov1.Y + TankSize div 2 - 1;
        end;
      2:
        begin
          PntToMov1 := self.DP[2];
          PntToMov2 := self.DP[3];
          inc(PntToMov1.Y);
          inc(PntToMov2.Y);
          PntToMov3.X := PntToMov1.X + TankSize div 2 - 1;
          PntToMov3.Y := PntToMov1.Y;
        end;
      3:
        begin
          PntToMov1 := self.DP[0];
          PntToMov2 := self.DP[2];
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
    isAbleToMove1 := CheckTank(TankPxMap[PntToMov1.Y][PntToMov1.X], self.num);
    isAbleToMove2 := CheckTank(TankPxMap[PntToMov2.Y][PntToMov2.X], self.num);
    if isAbleToMove1 and isAbleToMove2 then
      for i := 0 to DimPntCnt - 1 do
        case self.direction of
          0:
            dec(self.DP[i].Y, eTankSpeed);
          1:
            inc(self.DP[i].X, eTankSpeed);
          2:
            inc(self.DP[i].Y, eTankSpeed);
          3:
            dec(self.DP[i].X, eTankSpeed);
        end;
  end;
  screen.Canvas.Draw(self.DP[0].X, self.DP[0].Y, EnemyTankImg[self.direction]);
  for k := self.DP[0].Y to self.DP[3].Y do
    for l := self.DP[0].X to self.DP[3].X do
      TankPxMap[k][l] := -self.num;

  for i := 0 to length(ForestObj) - 1 do
    screen.Canvas.Draw(ForestObj[i].X, ForestObj[i].Y, StaticObjImg[4]);
  for i := 0 to length(SteelObj) - 1 do
    screen.Canvas.Draw(SteelObj[i].X, SteelObj[i].Y, StaticObjImg[6]);

end;

procedure TEnemyTank.EnemyShoot();

var
  code: integer;

begin
  if not self.isShotMade then
  begin
    code := random(2);
    case code of
      1:
        self.isShotMade := true;
      0:
        self.isShotMade := false;
    end;
    if self.isShotMade then
      case self.num of
        1:
          begin
            EnemyShells[1] := TEnemyShell.Create(self.direction, self.DP[0].X,
              self.DP[0].Y);
            GameInterface.Enemy1ShellMovement.Enabled := true;
          end;
        2:
          begin
            EnemyShells[2] := TEnemyShell.Create(self.direction, self.DP[0].X,
              self.DP[0].Y);
            GameInterface.Enemy2ShellMovement.Enabled := true;
          end;
        3:
          begin
            EnemyShells[3] := TEnemyShell.Create(self.direction, self.DP[0].X,
              self.DP[0].Y);
            GameInterface.Enemy3ShellMovement.Enabled := true;
          end;
        4:
          begin
            EnemyShells[4] := TEnemyShell.Create(self.direction, self.DP[0].X,
              self.DP[0].Y);
            GameInterface.Enemy4ShellMovement.Enabled := true;
          end;
      end;
  end;
end;

end.
