unit UAuthentication;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  UFileRouthine;

type
  TAuth = class(TForm)
    AuthPanel: TPanel;
    AuthDesc: TLabel;
    NickNameDesc: TLabel;
    PassWordDesc: TLabel;
    NickNameEnter: TEdit;
    PasswordEnter: TEdit;
    Confirm: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ConfirmClick(Sender: TObject);
  end;

var
  Auth: TAuth;

implementation

uses
  UMainMenu;

{$R *.dfm}

procedure TAuth.ConfirmClick(Sender: TObject);

var
  NickNameStr, PassWordStr: string;

begin
  NickNameStr := NickNameEnter.Text;
  PassWordStr := PasswordEnter.Text;
  CheckUser(NickNameStr, PassWordStr)
end;

procedure TAuth.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  self.Destroy;
  Mainmenu.Show;
end;

end.
