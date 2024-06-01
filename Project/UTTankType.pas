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
    isShotMade: boolean;
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
  UGameInterface, UGameMap, UShellType;

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

begin
  self.direction := 0;
  self.isShotMade := false;
  self.DP[0].X := X;
  self.DP[0].Y := Y;
  self.DP[1].X := X + TankSize - 1;
  self.DP[1].Y := Y;
  self.DP[2].X := X;
  self.DP[2].Y := Y + TankSize - 1;
  self.DP[3].X := X + TankSize - 1;
  self.DP[3].Y := Y + TankSize - 1;
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

var
  isAbleToMove1, isAbleToMove2, isKeyPressed: boolean;
  i, X, Y: integer;
  PntToMov1, PntToMov2: TCoords;
  isOnIce: boolean;

begin
  screen.Canvas.Rectangle(self.DP[0].X, self.DP[0].Y, self.DP[3].X + 1,
    self.DP[3].Y + 1);
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
          end;
        1:
          begin
            PntToMov1 := self.DP[1];
            PntToMov2 := self.DP[3];
            inc(PntToMov1.X);
            inc(PntToMov2.X);
          end;
        2:
          begin
            PntToMov1 := self.DP[2];
            PntToMov2 := self.DP[3];
            inc(PntToMov1.Y);
            inc(PntToMov2.Y);
          end;
        3:
          begin
            PntToMov1 := self.DP[0];
            PntToMov2 := self.DP[2];
            dec(PntToMov1.X);
            dec(PntToMov2.X);
          end;
      end;
      isAbleToMove1 := CheckObjId(PxMap[PntToMov1.Y][PntToMov1.X]);
      isAbleToMove2 := CheckObjId(PxMap[PntToMov2.Y][PntToMov2.X]);
    end;
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
  if not self.isShotMade then
  begin
    for i := 0 to length(IceObj) - 1 do
      screen.Canvas.Draw(IceObj[i].X, IceObj[i].Y, StaticObjImg[5]);
    for i := 0 to length(WaterObj) - 1 do
      screen.Canvas.Draw(WaterObj[i].X, WaterObj[i].Y, StaticObjImg[7]);
  end;
  isOnIce := false;
  Y := self.DP[0].Y;
  X := 0;
  while Y < self.DP[3].Y do
  begin
    X := self.DP[0].X;
    while X < self.DP[3].X do
    begin
      if PxMap[Y][X] = 5 then
        isOnIce := true;
      inc(X, 40);
    end;
    dec(X);
    if PxMap[Y][X] = 5 then
      isOnIce := true;
    inc(Y, 40);
  end;
  dec(X);
  dec(Y);
  if PxMap[Y][X] = 5 then
    isOnIce := true;
  if isOnIce then
    GameInterface.PlayerTankMovement.Interval := 100
  else
    GameInterface.PlayerTankMovement.Interval := 1;
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
      GameInterface.PlayerShellMovement.Interval := 15;
    end;
  end
end;

end.
