unit UTTankType;

interface

uses
  Vcl.Graphics, Vcl.ExtCtrls, System.Classes;

const
  DirImgCnt = 4;
  DimPntCnt = 4;
  TankSize = 80;
  TankSpeed = 10;

type
  TCoords = record
    X, Y: integer;
  end;

  TDimPntArr = array [0 .. DirImgCnt - 1] of TCoords;

  TDirImgArr = array [0 .. DirImgCnt - 1] of TBitMap;

  TTank = class
    direction: integer;
    DP: TDimPntArr;
    lives: integer;
    isShotMade, isDestroyed: boolean;

    constructor Create(X, Y: integer);
    procedure PlayerMove(key: integer; screen: TImage);
    procedure PlayerShoot(key: integer);
  end;

procedure PlayerTankImgArrInit();

var
  PlayerTankImg: TDirImgArr;
  PlayerTank: TTank;

implementation

uses
  UGameInterface, UGameMap, UShellType, UEnemyTanks, UEnemyShells;

procedure PlayerTankImgArrInit();

var
  i: integer;

begin
  for i := 0 to DirImgCnt - 1 do
    PlayerTankImg[i] := TBitMap.Create;
  PlayerTankImg[0].LoadFromFile('..\icons\PlayerTank\tUp.bmp');
  PlayerTankImg[1].LoadFromFile('..\icons\PlayerTank\tRight.bmp');
  PlayerTankImg[2].LoadFromFile('..\icons\PlayerTank\tDown.bmp');
  PlayerTankImg[3].LoadFromFile('..\icons\PlayerTank\tLeft.bmp');
end;

constructor TTank.Create(X: integer; Y: integer);

var
  i, j: integer;

begin
  self.direction := 0;
  self.lives := 3;
  self.isDestroyed := false;
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
      TankPxMap[i][j] := -10;
end;

procedure TTank.PlayerMove(key: integer; screen: TImage);

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

  function CheckEnemyTank(Id: integer): boolean;

  var
    res: boolean;

  begin
    res := false;
    case Id of
      - 1, -2, -3, -4:
        res := false;
      0:
        res := true;
    end;
    result := res;
  end;

var
  isAbleToMove1, isAbleToMove2, isAbleToMove3, isKeyPressed: boolean;
  i, k, l: integer;
  PntToMov1, PntToMov2, PntToMov3: TCoords;

begin
  isAbleToMove3 := false;
  screen.Canvas.Rectangle(self.DP[0].X, self.DP[0].Y, self.DP[3].X + 1,
    self.DP[3].Y + 1);
  for k := self.DP[0].Y to self.DP[3].Y do
    for l := self.DP[0].X to self.DP[3].X do
      TankPxMap[k][l] := 0;
  isKeyPressed := true;
  case key of
    38, 87:
      self.direction := 0;
    40, 83:
      self.direction := 2;
    37, 65:
      self.direction := 3;
    39, 68:
      self.direction := 1;
    -100, 32:
      isKeyPressed := false;
  end;
  if isKeyPressed then
  begin
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
    if isAbleToMove1 and isAbleToMove2 and isAbletoMove3 then
    begin
      isAbleToMove1 := CheckEnemyTank(TankPxMap[PntToMov1.Y][PntToMov1.X]);
      isAbleToMove2 := CheckEnemyTank(TankPxMap[PntToMov2.Y][PntToMov2.X]);
      if isAbleToMove1 and isAbleToMove2 then
        for i := 0 to DimPntCnt - 1 do
          case self.direction of
            0:
              dec(self.DP[i].Y, TankSpeed);
            1:
              inc(self.DP[i].X, TankSpeed);
            2:
              inc(self.DP[i].Y, TankSpeed);
            3:
              dec(self.DP[i].X, TankSpeed);
          end;
    end;
  end;
  for k := self.DP[0].Y to self.DP[3].Y do
    for l := self.DP[0].X to self.DP[3].X do
      TankPxMap[k][l] := -10;
  if not self.isShotMade then
  begin
    for i := 0 to length(WaterObj) - 1 do
      screen.Canvas.Draw(WaterObj[i].X, WaterObj[i].Y, StaticObjImg[7]);
  end;
  screen.Canvas.Draw(self.DP[0].X, self.DP[0].Y, PlayerTankImg[self.direction]);
  for i := 0 to length(ForestObj) - 1 do
    screen.Canvas.Draw(ForestObj[i].X, ForestObj[i].Y, StaticObjImg[4]);
  for i := 0 to length(SteelObj) - 1 do
    screen.Canvas.Draw(SteelObj[i].X, SteelObj[i].Y, StaticObjImg[6]);
end;

procedure TTank.PlayerShoot(key: integer);

begin
  if not self.isShotMade then
  begin
    case key of
      32:
        self.isShotMade := true;
    else
      self.isShotMade := false;
    end;
    if self.isShotMade then
    begin
      PlayerShell := TShell.Create(self.direction, self.DP[0].X, self.DP[0].Y);
      GameInterface.PlayerShellMovement.Enabled := true;
    end;
  end
end;

end.
