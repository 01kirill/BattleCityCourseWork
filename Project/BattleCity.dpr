program BattleCity;

uses
  Vcl.Forms,
  UGameInterface in 'UGameInterface.pas' {GameInterface},
  UGameMap in 'UGameMap.pas',
  UTTankType in 'UTTankType.pas',
  UShellType in 'UShellType.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TGameInterface, GameInterface);
  Application.Run;
end.
