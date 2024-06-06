unit UMainMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

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

  end;

var
  MainMenu: TMainMenu;
  isAuthorised: Boolean;

implementation

{$R *.dfm}

uses
  UGameInterface, ULeadersTable;

procedure TMainMenu.ControlsDescriptionClick(Sender: TObject);
begin
  ShowMessage
    ('��� ������������ ����� ����� ������������ ������� w\a\s\d, ��� �������. ��� �������� ����� ������������ ������.')
end;

procedure TMainMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainMenu.Destroy;
end;

procedure TMainMenu.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if MessageDlg('�� �������, ��� ������ �����?', mtConfirmation,
    [mbOk, mbCancel], 0) = mrCancel then
    CanClose := false;
end;

procedure TMainMenu.GameNameClick(Sender: TObject);
begin
  ShowMessage
    ('����������� �������� ���� ����������� ��������� ������� ����� �� 2023/2024 - �������� ���������.');
end;

procedure TMainMenu.LeadsTableClick(Sender: TObject);
begin
  LeadersTable := TLeadersTable.Create(Owner);
  MainMenu.Hide;
end;

procedure TMainMenu.StartGameCaptionClick(Sender: TObject);
begin
  if isAuthorised then
  begin
    GameInterface := TGameInterface.Create(Owner);
    MainMenu.Hide;
  end
  else
    ShowMessage('��� ������ ���� ���������� ��������������.');
end;

end.
