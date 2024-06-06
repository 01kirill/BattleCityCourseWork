unit ULeadersTable;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, UFileRouthine;

type
  TLeadersTable = class(TForm)
    LeadsDespription: TPanel;
    NameDesc: TPanel;
    ScoreDesc: TPanel;
    BuffPanel: TPanel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
  end;

var
  LeadersTable: TLeadersTable;

implementation

uses
  UMainMenu;

{$R *.dfm}

procedure TLeadersTable.FormActivate(Sender: TObject);

var
  i, j: integer;
  temp: TListData;

begin
  for i := 0 to length(header) - 2 do
    for j := i + 1 to length(header) - 1 do
      if header[j].Score > header[i].Score then
      begin
        temp := header[j];
        header[j] := header[i];
        header[i] := temp;
      end;
  for i := 0 to length(header) - 1 do
  begin
    listbox1.Items.Add(header[i].Name);
    listbox2.Items.Add(IntToStr(header[i].Score));
  end;
end;

procedure TLeadersTable.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  listbox1.Clear;
  listbox2.Clear;
  self.Destroy;
  MainMenu.Show;
end;

end.
