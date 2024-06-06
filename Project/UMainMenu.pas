unit UMainMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  UFileRouthine;

type
  TMainMenu = class(TForm)
    MenuPanel: TPanel;
    CaptionPanel: TPanel;
    GameName: TLabel;
    StartGameButton: TPanel;
    StartGameCaption: TLabel;
    ControlsDescription: TPanel;
    LeadsTable: TPanel;
    Authentication: TPanel;
    procedure StartGameCaptionClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure GameNameClick(Sender: TObject);
    procedure ControlsDescriptionClick(Sender: TObject);
    procedure LeadsTableClick(Sender: TObject);
    procedure AuthenticationClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  end;

var
  MainMenu: TMainMenu;
  isAuthorised: Boolean;
  isReaded: Boolean = false;

implementation

{$R *.dfm}

uses
  UGameInterface, ULeadersTable, UAuthentication;

procedure TMainMenu.FormActivate(Sender: TObject);
begin
  if not isReaded then
  begin
    ReadUsersData();
    isReaded := true;
  end;
end;

procedure TMainMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveData();
  MainMenu.Destroy;
end;

procedure TMainMenu.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if MessageDlg('Вы уверены, что хотите выйти?', mtConfirmation,
    [mbOk, mbCancel], 0) = mrCancel then
    CanClose := false;
end;

procedure TMainMenu.GameNameClick(Sender: TObject);
begin
  ShowMessage
    ('Программное средство было разработано студентом первого курса ПИ 2023/2024 - Кириллом Зиновенко.');
end;

procedure TMainMenu.StartGameCaptionClick(Sender: TObject);
begin

  if isAuthorised then
  begin
    GameInterface := TGameInterface.Create(Owner);
    // MainMenu.Hide;
  end
  else
    ShowMessage('Для начала игры необходимо авторизоваться.');

end;

procedure TMainMenu.AuthenticationClick(Sender: TObject);
begin
  Auth := TAuth.Create(Owner);
  // MainMenu.Hide;
end;

procedure TMainMenu.LeadsTableClick(Sender: TObject);
begin
  LeadersTable := TLeadersTable.Create(Owner);
  // MainMenu.Hide;
end;

procedure TMainMenu.ControlsDescriptionClick(Sender: TObject);
begin
  ShowMessage
    ('Для передвижения танка можно использовать клавиши w\a\s\d, или стрелки. Для стрельбы нужно использовать пробел.')
end;

end.
