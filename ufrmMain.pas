unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Actions,
  Vcl.ActnList, Vcl.Menus, System.ImageList, Vcl.ImgList, Vcl.ComCtrls,
  Vcl.ExtCtrls;

type
  TSortOptions = record
    SortColumn: Integer;
    SortDescending: Boolean;
  end;

  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    OpenFiles1: TMenuItem;
    OpenFolders1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    ActionList1: TActionList;
    actOpenFile: TAction;
    actOpenFolder: TAction;
    actExit: TAction;
    dlgFileOpen: TFileOpenDialog;
    dlgFolderOpen: TFileOpenDialog;
    lvFiles: TListView;
    ilSmall: TImageList;
    ilLarge: TImageList;
    actShowInExplorer: TAction;
    PopupMenu1: TPopupMenu;
    OpeninExplorer1: TMenuItem;
    StatusBar1: TStatusBar;
    actCopyToClipboard: TAction;
    Edit1: TMenuItem;
    CopytoClipboard1: TMenuItem;
    N2: TMenuItem;
    CopytoClipboard2: TMenuItem;
    View1: TMenuItem;
    actRefresh: TAction;
    Refresh1: TMenuItem;
    procedure actExitExecute(Sender: TObject);
    procedure actOpenFileExecute(Sender: TObject);
    procedure actOpenFolderExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvFilesColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvFilesCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure actShowInExplorerExecute(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure actCopyToClipboardExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
  private
    FSourceFileList: TStringList;
    FWorkingFileList: TStringList;
    FInterestingFileCount: Integer;
    FSortOptions: TSortOptions;
    FCanceled: Boolean;

    function CompareFileSize(const ASize1, ASize2: string): Integer;
    procedure FindInterestingFiles;
    procedure OnCancelEvent(Sender: TObject);
    procedure ProcessWorkingFileList;
    procedure UpdateFileCount(const aFileCount: Integer);
  protected
    procedure WMDropFiles(var Msg: TMessage); message WM_DROPFILES;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}


uses
  System.Types, System.Diagnostics, System.IOUtils, System.Math, Winapi.ShellAPI,
  Vcl.Clipbrd,
  ufrmProgress, uFileChecker, uFileUtils;


// TfrmMain
// ============================================================================
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FSourceFileList := TStringList.Create;
  FSourceFileList.CaseSensitive := False;
  FSourceFileList.Sorted := True;
  FSourceFileList.Duplicates := dupIgnore;

  FWorkingFileList := TStringList.Create;
  FWorkingFileList.Capacity := 1000;
  FWorkingFileList.CaseSensitive := False;
  FWorkingFileList.Sorted := True;
  FWorkingFileList.Duplicates := dupIgnore;

  DragAcceptFiles(Handle, True);

  FSortOptions.SortColumn := 1;
  FSortOptions.SortDescending := False;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FSourceFileList.Free;
  FWorkingFileList.Free;

  DragAcceptFiles(Handle, False);
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.lvFilesColumnClick(Sender: TObject; Column: TListColumn);
begin
  if Column.Index = FSortOptions.SortColumn then
    FSortOptions.SortDescending := not FSortOptions.SortDescending
  else
  begin
    FSortOptions.SortColumn := Column.Index;
    FSortOptions.SortDescending := False;
  end;

  lvFiles.AlphaSort;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.lvFilesCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
begin
  if FSortOptions.SortColumn = 0 then
    Compare := CompareText(Item1.Caption, Item2.Caption)
  else
    if FSortOptions.SortColumn = 4 then
    Compare := CompareFileSize(Item1.SubItems[FSortOptions.SortColumn - 1],
      Item2.SubItems[FSortOptions.SortColumn - 1])
  else
    Compare := CompareText(Item1.SubItems[FSortOptions.SortColumn - 1],
      Item2.SubItems[FSortOptions.SortColumn - 1]);

  if FSortOptions.SortDescending then
    Compare := -Compare;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.OnCancelEvent(Sender: TObject);
begin
  FCanceled := True;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.actCopyToClipboardExecute(Sender: TObject);
var
  s: string;
  LColumnIndex: Integer;
  LRowIndex: Integer;
  LCSVList: TStringList;
begin
  LCSVList := TStringList.Create;
  try
    LCSVList.BeginUpdate;
    try
      for LColumnIndex := 0 to lvFiles.Columns.Count - 1 do
      begin
        if s <> '' then
          s := s + ',';
        s := s + AnsiQuotedStr(Trim(lvFiles.Columns[LColumnIndex].Caption), '"');
      end;
      LCSVList.Add(s);

      for LRowIndex := 0 to lvFiles.Items.Count - 1 do
      begin
        s := AnsiQuotedStr(lvFiles.Items[LRowIndex].Caption, '"');
        for LColumnIndex := 1 to lvFiles.Columns.Count - 1 do
        begin
          s := s + ',' + AnsiQuotedStr(Trim(lvFiles.Items[LRowIndex].SubItems[LColumnIndex - 1]), '"');
        end;
        LCSVList.Add(s);
      end;

      Clipboard.AsText := LCSVList.Text;
    finally
      LCSVList.EndUpdate;
    end;
  finally
    LCSVList.Free();
  end;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Close;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.actOpenFileExecute(Sender: TObject);
begin
  if dlgFileOpen.Execute then
  begin
    FSourceFileList.Assign(dlgFileOpen.Files);
    FindInterestingFiles;
  end;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.actOpenFolderExecute(Sender: TObject);
begin
  if dlgFolderOpen.Execute then
  begin
    FSourceFileList.Assign(dlgFolderOpen.Files);
    FindInterestingFiles;
  end;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.actRefreshExecute(Sender: TObject);
begin
  if FSourceFileList.Count > 0 then
    FindInterestingFiles;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.actShowInExplorerExecute(Sender: TObject);
var
  LFileName: string;
  LParameter: string;
  LSelectedItem: TListItem;
begin
  LSelectedItem := lvFiles.Selected;

  if Assigned(LSelectedItem) then
  begin
    LFileName := LSelectedItem.SubItems[0] + LSelectedItem.Caption;
    LParameter := Format('/select,"%s"', [LFileName]);
    ShellExecute(Application.Handle, 'open', 'explorer.exe', PChar(LParameter), nil, SW_NORMAL);
  end;
end;

// ----------------------------------------------------------------------------
function TfrmMain.CompareFileSize(const ASize1, ASize2: string): Integer;
var
  s: string;
  LFileSize1, LFileSize2: Integer;
begin
  s := Copy(ASize1, 1, Length(ASize1) - 3);
  s := StringReplace(s, ',', '', [rfReplaceAll]);
  LFileSize1 := StrToInt(s);

  s := Copy(ASize2, 1, Length(ASize2) - 3);
  s := StringReplace(s, ',', '', [rfReplaceAll]);
  LFileSize2 := StrToInt(s);

  Result := CompareValue(LFileSize1, LFileSize2);
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.PopupMenu1Popup(Sender: TObject);
begin
  actShowInExplorer.Enabled := Assigned(lvFiles.Selected);
  actCopyToClipboard.Enabled := lvFiles.Items.Count > 0;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.FindInterestingFiles;
var
  LStopwatch: TStopwatch;
begin
  FCanceled := False;

  frmProgress.OnCancel := OnCancelEvent;
  frmProgress.Show;
  frmProgress.Start;
  frmProgress.DisableCancel;

  FInterestingFileCount := 0;
  UpdateFileCount(FInterestingFileCount);
  StatusBar1.Update;
  frmProgress.EnableCancel;

  lvFiles.Clear;
  ilSmall.Clear;
  ilLarge.Clear;
  Application.ProcessMessages;

  LStopwatch := TStopwatch.StartNew;
  FWorkingFileList.BeginUpdate;
  try
    FWorkingFileList.Clear;
    FindExecutableFiles(FSourceFileList, FWorkingFileList);
    LStopwatch.Stop;
  finally
    FWorkingFileList.EndUpdate;
  end;

  if FWorkingFileList.Count = 0 then
    frmProgress.Log(Format('No executable files found (%.0n ms)',
      [LStopwatch.ElapsedMilliseconds + 0.0]))
  else
    frmProgress.Log(Format('%.0n executable files found (%.0n ms)',
      [FWorkingFileList.Count + 0.0, LStopwatch.ElapsedMilliseconds + 0.0]));
  frmProgress.Log('');

  if FWorkingFileList.Count > 0 then
  begin
    frmProgress.Log('Examining files...');

    LStopwatch := TStopwatch.StartNew;
    ProcessWorkingFileList;
    LStopwatch.Stop;

    if FCanceled then
      frmProgress.Log(Format('Canceled by user (%.0n ms)',
        [LStopwatch.ElapsedMilliseconds + 0.0]))
    else
      frmProgress.Log(Format('Completed (%.0n ms)',
        [LStopwatch.ElapsedMilliseconds + 0.0]));

    frmProgress.Log('');
    frmProgress.Log(Format('%.0n interesting files found', [FInterestingFileCount + 0.0]));
    frmProgress.Log('');
  end;
  frmProgress.Log('Done');

  frmProgress.Stop;

  actCopyToClipboard.Enabled := lvFiles.Items.Count > 0;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.ProcessWorkingFileList;
var
  LWorkingFileCount: Integer;
  LWorkingFileIndex: Integer;
  LFileName: string;
  LIcon: TIcon;
  LIconHandle: WORD;
  LImageIndex: Integer;
  LListItem: TListItem;

  LFileInformation: TFileInformation;
begin
  LWorkingFileCount := FWorkingFileList.Count;
  LWorkingFileIndex := 0;

  LIcon := TIcon.Create;
  try
    for LFileName in FWorkingFileList do
    begin
      if FCanceled then
        Exit;

      Inc(LWorkingFileIndex);
      frmProgress.CurrentFolder := ExtractFilePath(LFileName);
      frmProgress.UpdateProgress(Round((LWorkingFileIndex / LWorkingFileCount) * 100));

      if FileIsInteresting(LFileName, LFileInformation) then
      begin
        Inc(FInterestingFileCount);
        UpdateFileCount(FInterestingFileCount);
        lvFiles.Items.BeginUpdate;
        try
          LIcon.Handle := ExtractAssociatedIcon(Application.Handle, PChar(LFileName), LIconHandle);
          LImageIndex := ilSmall.AddIcon(LIcon);
          ilLarge.AddIcon(LIcon);
          LListItem := lvFiles.Items.Add;

          LListItem.Caption := ExtractFileName(LFileName);
          LListItem.SubItems.Add(ExtractFilePath((LFileName)));

          LListItem.SubItems.Add(FormatDateTime('yyyy-mm-dd hh:nn', LFileInformation.DataModified));

          LListItem.SubItems.Add(LFileInformation.FileType);

          LListItem.SubItems.Add(Format('%.0n KB', [LFileInformation.FileSize / 1024]));

          LListItem.SubItems.Add(LFileInformation.CPU);
          LListItem.SubItems.Add(LFileInformation.CompilerName);
          LListItem.SubItems.Add(LFileInformation.SKU);

          LListItem.ImageIndex := LImageIndex;
        finally
          lvFiles.Items.EndUpdate;
          Application.ProcessMessages;
        end;
      end;
    end;
  finally
    LIcon.Free;
  end;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.UpdateFileCount(const aFileCount: Integer);
begin
  if aFileCount = 0 then
    StatusBar1.Panels[0].Text := 'No files found'
  else
    StatusBar1.Panels[0].Text := Format('%.0n files found', [aFileCount + 0.0]);

  StatusBar1.Refresh;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.WMDropFiles(var Msg: TMessage);
var
  i: Integer;
  LDropHandle: THandle;
  LFileCount: Integer;
  LNameLength: Integer;
  LFileName: string;
begin
  LDropHandle := Msg.wParam;
  LFileCount := DragQueryFile(LDropHandle, $FFFFFFFF, nil, 0);

  FSourceFileList.Clear;
  for i := 0 to LFileCount - 1 do
  begin
    LNameLength := DragQueryFile(LDropHandle, i, nil, 0) + 1;
    SetLength(LFileName, LNameLength);
    DragQueryFile(LDropHandle, i, Pointer(LFileName), LNameLength);
    LFileName := Trim(LFileName);
    FSourceFileList.Add(LFileName);
  end;
  DragFinish(LDropHandle);

  FindInterestingFiles;
end;

end.
