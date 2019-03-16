program AntrianServerStakProject1;

uses
  Vcl.Forms,
  AntrianServerUnit1 in 'AntrianServerUnit1.pas' {Form1},
  antrikanU in 'antrikanU.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
