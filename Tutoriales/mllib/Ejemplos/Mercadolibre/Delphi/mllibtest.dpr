program mllibtest;

uses
  Forms,
  mllib_TLB in 'mllib_TLB.pas',
  uMLDemoMain in 'uMLDemoMain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
