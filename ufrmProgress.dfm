object frmProgress: TfrmProgress
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'IsDelphi Progress'
  ClientHeight = 206
  ClientWidth = 756
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblCurrentFolder: TLabel
    AlignWithMargins = True
    Left = 12
    Top = 158
    Width = 741
    Height = 13
    Margins.Left = 12
    Align = alBottom
    Caption = 'lblCurrentFolder'
    ExplicitWidth = 77
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 174
    Width = 756
    Height = 32
    Align = alBottom
    TabOrder = 0
    object btnClose: TButton
      AlignWithMargins = True
      Left = 672
      Top = 4
      Width = 75
      Height = 24
      Margins.Right = 8
      Align = alRight
      Anchors = [akTop, akRight]
      Caption = 'Close'
      Default = True
      TabOrder = 0
      OnClick = btnCloseClick
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 586
      Top = 4
      Width = 75
      Height = 24
      Margins.Right = 8
      Align = alRight
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      Visible = False
      OnClick = btnCancelClick
    end
    object ProgressBar1: TProgressBar
      AlignWithMargins = True
      Left = 9
      Top = 7
      Width = 566
      Height = 18
      Margins.Left = 8
      Margins.Top = 6
      Margins.Right = 8
      Margins.Bottom = 6
      Align = alClient
      TabOrder = 2
    end
  end
  object memLog: TRichEdit
    AlignWithMargins = True
    Left = 8
    Top = 3
    Width = 740
    Height = 149
    Margins.Left = 8
    Margins.Right = 8
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
    Zoom = 100
  end
end
