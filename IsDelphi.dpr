program IsDelphi;

uses
  Vcl.Forms,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  uFileUtils in 'uFileUtils.pas',
  uFileChecker in 'uFileChecker.pas',
  ufrmProgress in 'ufrmProgress.pas' {frmProgress};

{$R *.res}


begin
  Application.Initialize;

  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmProgress, frmProgress);
  Application.Run;

end.
