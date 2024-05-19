unit UGameInterface;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TGameInterface = class(TForm)
    PaddingPanelUp: TPanel;
    PaddingPanelLeft: TPanel;
    PaddingPanelBottom: TPanel;
    GameInfo: TPanel;
    GameScreen: TImage;
    procedure FormActivate(Sender: TObject);
  end;

var
  GameInterface: TGameInterface;

const
  MapSize = 1040;

implementation

{$R *.dfm}

procedure TGameInterface.FormActivate(Sender: TObject);
begin
  self.GameScreen.Canvas.Brush.Color := clBlack;
  self.GameScreen.Canvas.Pen.Color := clBlack;
  self.GameScreen.Height := MapSize;
  self.GameScreen.Width := MapSize;
  self.GameScreen.Canvas.Rectangle(0, 0, 1040, 1040);
end;

end.
