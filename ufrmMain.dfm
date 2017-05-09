object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'IsDelphi'
  ClientHeight = 448
  ClientWidth = 1056
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lvFiles: TListView
    Left = 0
    Top = 0
    Width = 1056
    Height = 429
    Align = alClient
    BorderStyle = bsNone
    Columns = <
      item
        Caption = 'Name'
        Width = 150
      end
      item
        Caption = 'Path'
        Width = 300
      end
      item
        Caption = 'Date Modified'
        Width = 110
      end
      item
        Caption = 'Type'
        Width = 120
      end
      item
        Alignment = taRightJustify
        Caption = 'Size'
        Width = 80
      end
      item
        Caption = 'Processor'
        Width = 60
      end
      item
        Caption = 'Compiler'
        Width = 135
      end
      item
        Caption = 'SKU'
        Width = 80
      end>
    DoubleBuffered = True
    GridLines = True
    LargeImages = ilLarge
    ReadOnly = True
    RowSelect = True
    ParentDoubleBuffered = False
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ShowHint = False
    SmallImages = ilSmall
    SortType = stData
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = lvFilesColumnClick
    OnCompare = lvFilesCompare
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 429
    Width = 1056
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 50
      end>
  end
  object MainMenu1: TMainMenu
    Left = 40
    Top = 232
    object File1: TMenuItem
      Caption = 'File'
      object OpenFiles1: TMenuItem
        Action = actOpenFile
      end
      object OpenFolders1: TMenuItem
        Action = actOpenFolder
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Action = actExit
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      object CopytoClipboard1: TMenuItem
        Action = actCopyToClipboard
      end
    end
    object View1: TMenuItem
      Caption = 'View'
      object Refresh1: TMenuItem
        Action = actRefresh
      end
    end
  end
  object ActionList1: TActionList
    Left = 104
    Top = 232
    object actOpenFile: TAction
      Category = 'File'
      Caption = 'Open File(s)...'
      OnExecute = actOpenFileExecute
    end
    object actOpenFolder: TAction
      Category = 'File'
      Caption = 'Open Folder(s)...'
      OnExecute = actOpenFolderExecute
    end
    object actExit: TAction
      Category = 'File'
      Caption = 'Exit'
      OnExecute = actExitExecute
    end
    object actShowInExplorer: TAction
      Caption = 'Show in Explorer'
      OnExecute = actShowInExplorerExecute
    end
    object actCopyToClipboard: TAction
      Category = 'Edit'
      Caption = 'Copy to Clipboard'
      ShortCut = 16451
      OnExecute = actCopyToClipboardExecute
    end
    object actRefresh: TAction
      Category = 'View'
      Caption = 'Refresh'
      ShortCut = 116
      OnExecute = actRefreshExecute
    end
  end
  object dlgFileOpen: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'All Files'
        FileMask = '*.*'
      end
      item
        DisplayName = 'Executable Files'
        FileMask = '*.exe;*.dll;*.ocx;*.bpl;*.cpl;*.scr'
      end>
    FileTypeIndex = 2
    Options = [fdoAllowMultiSelect, fdoPathMustExist, fdoFileMustExist]
    Left = 168
    Top = 232
  end
  object dlgFolderOpen: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = [fdoPickFolders, fdoAllowMultiSelect, fdoPathMustExist, fdoFileMustExist]
    Left = 240
    Top = 232
  end
  object ilSmall: TImageList
    Left = 336
    Top = 232
  end
  object ilLarge: TImageList
    Height = 32
    Width = 32
    Left = 376
    Top = 232
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 40
    Top = 288
    object CopytoClipboard2: TMenuItem
      Action = actCopyToClipboard
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object OpeninExplorer1: TMenuItem
      Action = actShowInExplorer
    end
  end
end
