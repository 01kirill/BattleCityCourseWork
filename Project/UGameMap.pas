unit UGameMap;

interface

uses
  Vcl.Graphics, Vcl.ExtCtrls;

const
  MapSize = 1040;
  ObjLen = 80;
  SubObjLen = 40;
  ObjCnt = 13;
  SubObjCnt = 2;
  StaticObjImgCnt = 7;
  LineBase = 24;
  ColumnBase = 12;

type
  TCoords = record
    X, Y: integer;
  end;

  TForestObjArr = array of TCoords;
  TWaterObjArr = array of TCoords;
  TSteelObjArr = array of TCoords;

  TTankPxMap = array [0 .. MapSize - 1, 0 .. MapSize - 1] of integer;
  TPxMap = array [0 .. MapSize - 1, 0 .. MapSize - 1] of integer;
  TMapFileMtx = array [1 .. ObjCnt * SubObjCnt] of string;
  TStaticObjImgArr = array [0 .. StaticObjImgCnt] of TBitMap;

procedure DrawBackGround(Screen: TImage);

procedure StaticObjImgArrInit(var StaticObjImg: TStaticObjImgArr);

procedure LoadMapFromFile(Screen: TImage; path: string);

var
  PxMap: TPxMap;
  TankPxMap: TTankPxMap;
  MapFileMtx: TMapFileMtx;
  StaticObjImg: TStaticObjImgArr;
  ForestObj: TForestObjArr;
  WaterObj: TWaterObjArr;
  SteelObj: TSteelObjArr;

implementation

uses
  UGameInterface, UTTankType, UShellType, UEnemyTanks, UEnemyShells;

procedure DrawBackGround(Screen: TImage);

begin
  Screen.Canvas.Rectangle(0, 0, MapSize, MapSize);
end;

procedure StaticObjImgArrInit(var StaticObjImg: TStaticObjImgArr);

var
  i: integer;

begin
  for i := 0 to StaticObjImgCnt do
    StaticObjImg[i] := TBitMap.Create;
  StaticObjImg[0] := nil;
  StaticObjImg[1].LoadFromFile('..\icons\StaticObjects\brick.bmp');
  StaticObjImg[2].LoadFromFile('..\icons\StaticObjects\die.bmp');
  StaticObjImg[3].LoadFromFile('..\icons\StaticObjects\eagle.bmp');
  StaticObjImg[4].LoadFromFile('..\icons\StaticObjects\forest.bmp');
  StaticObjImg[5].LoadFromFile('..\icons\StaticObjects\ice.bmp');
  StaticObjImg[6].LoadFromFile('..\icons\StaticObjects\steel.bmp');
  StaticObjImg[7].LoadFromFile('..\icons\StaticObjects\water.bmp');
  SetLength(ForestObj, 0);
  SetLength(WaterObj, 0);
  SetLength(SteelObj, 0);
end;

procedure LoadMapFromFile(Screen: TImage; path: string);

var
  MapFile: TextFile;
  i, j, id, k, l, posX, posY: integer;
  MapImgToDraw: TBitMap;

begin
  posX := -1;
  posY := -1;
  AssignFile(MapFile, path);
  Reset(MapFile);
  for i := 1 to ObjCnt * SubObjCnt do
    readln(MapFile, MapFileMtx[i]);
  CloseFile(MapFile);
  id := 0;
  for i := 1 to ObjCnt * SubObjCnt do
    for j := 1 to ObjCnt * SubObjCnt do
    begin
      case MapFileMtx[j][i] of
        'z':
          id := 0;
        'b':
          id := 1;
        'd':
          id := 2;
        'e':
          begin
            id := 3;
            posX := i;
            posY := j;
          end;
        'f':
          id := 4;
        's':
          id := 6;
        'w':
          id := 7;
      end;
      MapImgToDraw := StaticObjImg[id];
      Screen.Canvas.Draw((i - 1) * SubObjLen, (j - 1) * SubObjLen,
        MapImgToDraw);
      for k := (j - 1) * SubObjLen to (j - 1) * SubObjLen + SubObjLen - 1 do
        for l := (i - 1) * SubObjLen to (i - 1) * SubObjLen + SubObjLen - 1 do
          PxMap[k][l] := id;
      case MapFileMtx[j][i] of
        'f':
          begin
            SetLength(ForestObj, length(ForestObj) + 1);
            ForestObj[length(ForestObj) - 1].X := (i - 1) * SubObjLen;
            ForestObj[length(ForestObj) - 1].Y := (j - 1) * SubObjLen;
          end;
        'w':
          begin
            SetLength(WaterObj, length(WaterObj) + 1);
            WaterObj[length(WaterObj) - 1].X := (i - 1) * SubObjLen;
            WaterObj[length(WaterObj) - 1].Y := (j - 1) * SubObjLen;
          end;
        's':
          begin
            SetLength(SteelObj, length(SteelObj) + 1);
            SteelObj[length(SteelObj) - 1].X := (i - 1) * SubObjLen;
            SteelObj[length(SteelObj) - 1].Y := (j - 1) * SubObjLen;
          end;
      end;
    end;
  for i := (posX - 1) * SubObjLen to (posX - 1) * SubObjLen + ObjLen - 1 do
    for j := (posY - 1) * SubObjLen to (posY - 1) * SubObjLen + ObjLen - 1 do
      PxMap[j][i] := 3;

end;

end.
