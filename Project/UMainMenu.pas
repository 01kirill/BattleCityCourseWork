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
    procedure StartGameCaptionClick(Sender: TObject);

  end;

var
  MainMenu: TMainMenu;
  isAuthorised: boolean;

implementation

{$R *.dfm}

uses
  UGameInterface;

procedure TMainMenu.StartGameCaptionClick(Sender: TObject);
begin
  MainMenu.Hide;
  GameInterface.Show;
end;

end.
