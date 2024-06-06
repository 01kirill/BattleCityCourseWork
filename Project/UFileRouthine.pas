unit UFileRouthine;

interface

uses
  vcl.Dialogs, System.SysUtils;

type
  TString = string[8];

  TListData = record
    Name: TString;
    Password: TString;
    Score: integer;
  end;

  Tlist = array of TListData;

procedure AddUser();

procedure CheckUser(str1, str2: string);

procedure ReadUsersData();

procedure SaveData();

var
  header: Tlist;
  current: integer;

implementation

uses
  UAuthentication, UMainMenu, UGameInterface, ULeadersTable;

procedure ReadUsersData();

var
  Name, pass, Score: TextFile;

begin
  AssignFile(Name, '..\UsersList\UserName.txt');
  AssignFile(pass, '..\UsersList\UserPass.txt');
  AssignFile(Score, '..\UsersList\UserScore.txt');
  reset(name);
  reset(pass);
  reset(Score);
  while not EOF(name) do
  begin
    Setlength(header, length(header) + 1);
    readln(name, header[length(header) - 1].Name);
    readln(pass, header[length(header) - 1].Password);
    readln(Score, header[length(header) - 1].Score);
  end;
  closeFile(Name);
  closeFile(pass);
  closeFile(Score);
end;

procedure AddUser();

var
  Name, pass, Score: TextFile;
  i: integer;

begin
  AssignFile(Name, '..\UsersList\UserName.txt');
  AssignFile(pass, '..\UsersList\UserPass.txt');
  AssignFile(Score, '..\UsersList\UserScore.txt');
  Rewrite(name);
  Rewrite(pass);
  Rewrite(Score);
  for i := 0 to length(header) - 1 do
  begin
    writeln(name, header[i].Name);
    writeln(pass, header[i].Password);
    writeln(score, header[i].score);
  end;
  closeFile(Name);
  closeFile(pass);
  closeFile(Score);
end;

procedure CheckUser(str1, str2: string);

var
  i: integer;
  flag: boolean;

begin
  i := 0;
  flag := false;
  while (i <= length(header) - 1) and not flag do
  begin
    if header[i].Name = str1 then
    begin
      current := i;
      flag := true;
    end;
    inc(i);
  end;
  if not flag then
  begin
    ShowMessage('Новый пользователь под ником: ' + str1 + ' создан');
    SetLength(header, length(header) + 1);
    current := length(header) - 1;
    header[current].Name := str1;
    header[current].Password := str2;
    header[current].Score := 0;
    Adduser();
    isAuthorised := true;
    Auth.Destroy;
    Mainmenu.Show;
  end;
  if flag and (header[current].Password = str2) then
  begin
    ShowMessage('Пользователь под ником ' + str1 + ' авторизован.');
    isAuthorised := true;
    Auth.Destroy;
    Mainmenu.Show;
  end;
  if flag and (header[current].Password <> str2) then
    ShowMessage('Пароль неверный.');
end;

procedure SaveData();

var
  Name, pass, Score: TextFile;
  i: integer;

begin
  AssignFile(Name, '..\UsersList\UserName.txt');
  AssignFile(pass, '..\UsersList\UserPass.txt');
  AssignFile(Score, '..\UsersList\UserScore.txt');
  rewrite(name);
  rewrite(pass);
  rewrite(Score);
  for i := 0 to length(header) - 1 do
  begin
    writeln(name, header[i].Name);
    writeln(pass, header[i].Password);
    writeln(score, header[i].score);
  end;
  SetLength(header, 0);
  closeFile(Name);
  closeFile(pass);
  closeFile(Score);
end;

end.
