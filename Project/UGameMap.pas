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

type
  TPxMap = array [0 .. MapSize - 1, 0 .. MapSize - 1] of integer;
  TMapFileMtx = array [1 .. ObjCnt * SubObjCnt] of string;
  TStaticObjImgArr = array [0 .. StaticObjImgCnt] of TBitMap;

procedure DrawBackGround(Screen: TImage; MapSize: integer);

procedure StaticObjImgArrInit(var StaticObjImg: TStaticObjImgArr; n: integer);

procedure LoadMapFromFile(Screen: TImage; path: string; var PxMap: TPxMap; StaticObjImg: TStaticObjImgArr; n, len: integer);

var
  PxMap: TPxMap;
  StaticObjImg: TStaticObjImgArr;

implementation

uses
  UGameInterface;

procedure DrawBackGround(Screen: TImage; MapSize: integer);

begin
  Screen.Canvas.Rectangle(0, 0, MapSize, MapSize);
end;

procedure StaticObjImgArrInit(var StaticObjImg: TStaticObjImgArr; n: integer);

var
  i: integer;

begin
  for i := 0 to n do
    StaticObjImg[i] := TBitMap.Create;
  StaticObjImg[0] := nil;
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

procedure LoadMapFromFile(Screen: TImage; path: string; var PxMap: TPxMap; StaticObjImg: TStaticObjImgArr; n, len: integer);

var
  MapFile: TextFile;
  MapFileMtx: TMapFileMtx;
  i, j, id, k, l: integer;
  MapImgToDraw: TBitMap;

begin
  AssignFile(MapFile, path);
  Reset(MapFile);
  for i := 1 to n do
    readln(MapFile, MapFileMtx[i]);
  CloseFile(MapFile);
  id := 0;
  for i := 1 to n do
    for j := 1 to n do
    begin
      case MapFileMtx[j][i] of
        'b':
          id := 1;
        'd':
          id := 2;
        'e':
          id := 3;
        'f':
          id := 4;
        'i':
          id := 5;
        's':
          id := 6;
        'w':
          id := 7;
        'z':
          id := 0;
      end;
      MapImgToDraw := StaticObjImg[id];
      Screen.Canvas.Draw((i - 1) * Len,
        (j - 1) * Len, MapImgToDraw);
      for k := (j - 1) * len to (j - 1) * len + len - 1 do
        for l := (i  -1) * len to (i - 1) * len + len - 1 do
          PxMap[k][l] := id;
    end;
end;

end.
