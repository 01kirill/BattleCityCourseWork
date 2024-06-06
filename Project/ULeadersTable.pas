unit ULeadersTable;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TLeadersTable = class(TForm)
    LeadsDespription: TPanel;
    NameDesc: TPanel;
    ScoreDesc: TPanel;
    BuffPanel: TPanel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LeadersTable: TLeadersTable;

implementation

uses
  UMainMenu;

{$R *.dfm}

procedure TLeadersTable.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  self.Destroy;
  MainMenu.Show;
end;

procedure TLeadersTable.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   if MessageDlg('Вы уверены, что хотите выйти?', mtConfirmation,
    [mbOk, mbCancel], 0) = mrCancel then
    CanClose := false;
end;

end.
