program BattleCity;

uses
  Vcl.Forms,
  UGameInterface in 'UGameInterface.pas' {GameInterface},
  UGameMap in 'UGameMap.pas',
  UTTankType in 'UTTankType.pas',
  UShellType in 'UShellType.pas',
  UEnemyTanks in 'UEnemyTanks.pas',
  UEnemyShells in 'UEnemyShells.pas',
  UMainMenu in 'UMainMenu.pas' {MainMenu},
  ULeadersTable in 'ULeadersTable.pas' {LeadersTable};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainMenu, MainMenu);
  Application.Run;
end.
