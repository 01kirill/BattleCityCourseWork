unit UGameMap;

interface

uses
  Vcl.Graphics;

const
  MapSize = 1040;
  ObjLen = 80;
  SubObjLen = 40;
  ObjCnt = 13;
  SubObjCnt = 2;
  StaticObjImgCnt = 7;

type
  TPxMap = array [0 .. MapSize - 1, 0 .. MapSize - 1] of integer;
  TMapFileMtx = array [1 .. ObjCnt * SubObjCnt] of string;
  TStaticObjImgArr = array [1 .. StaticObjImgCnt] of TBitMap;

procedure DrawBackGround(MapSize: integer);

procedure StaticObjImgArrInit(var StaticObjImg: TStaticObjImgArr; n: integer);

procedure LoadMapFromFile(path: string; var PxMap: TPxMap; n: integer);

var
  PxMap: TPxMap;
  StaticObjImg: TStaticObjImgArr;

implementation

uses
  UGameInterface;

procedure DrawBackGround(MapSize: integer);

begin
  GameInterface.GameScreen.Canvas.Rectangle(0, 0, MapSize, MapSize);
end;

procedure StaticObjImgArrInit(var StaticObjImg: TStaticObjImgArr; n: integer);

var
  i: integer;

begin
  for i := 1 to n do
    StaticObjImg[i] := TBitMap.Create;
  StaticObjImg[1].LoadFromFile
    ('D:\work\Delphi\BattleCityCourseWork\Project\icons\StaticObjects\brick.bmp');
  StaticObjImg[2].LoadFromFile
    ('D:\work\Delphi\BattleCityCourseWork\Project\icons\StaticObjects\die.bmp');
  StaticObjImg[3].LoadFromFile
    ('D:\work\Delphi\BattleCityCourseWork\Project\icons\StaticObjects\eagle.bmp');
  StaticObjImg[4].LoadFromFile
    ('D:\work\Delphi\BattleCityCourseWork\Project\icons\StaticObjects\forest.bmp');
  StaticObjImg[5].LoadFromFile
    ('D:\work\Delphi\BattleCityCourseWork\Project\icons\StaticObjects\ice.bmp');
  StaticObjImg[6].LoadFromFile
    ('D:\work\Delphi\BattleCityCourseWork\Project\icons\StaticObjects\steel.bmp');
  StaticObjImg[7].LoadFromFile
    ('D:\work\Delphi\BattleCityCourseWork\Project\icons\StaticObjects\water.bmp');
end;

procedure LoadMapFromFile(path: string; var PxMap: TPxMap; n: integer);

var
  MapFile: TextFile;
  MapFileMtx: TMapFileMtx;
  i, j: integer;
  MapImgToDraw: TBitMap;

begin
  AssignFile(MapFile, path);
  Reset(MapFile);
  for i := 1 to n do
    readln(MapFile, MapFileMtx[i]);
  CloseFile(MapFile);
  MapImgToDraw := TBitMap.Create;
  for i := 1 to n do
    for j := 1 to n do
    begin
      case MapFileMtx[j][i] of
        'b':
          MapImgToDraw := StaticObjImg[1];
        'd':
          MapImgToDraw := StaticObjImg[2];
        'e':
          MapImgToDraw := StaticObjImg[3];
        'f':
          MapImgToDraw := StaticObjImg[4];
        'i':
          MapImgToDraw := StaticObjImg[5];
        's':
          MapImgToDraw := StaticObjImg[6];
        'w':
          MapImgToDraw := StaticObjImg[7];
        'z':
          MapImgToDraw := nil;
      end;
      GameInterface.GameScreen.Canvas.Draw((i - 1) * SubObjLen,
        (j - 1) * SubObjLen, MapImgToDraw);
    end;
end;

end.
