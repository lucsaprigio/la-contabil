object frm_view_principal: Tfrm_view_principal
  Left = 0
  Top = 0
  Caption = 'Organizador XML - API'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnlContainer: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 441
    Align = alClient
    TabOrder = 0
    object memLog: TMemo
      Left = 0
      Top = 0
      Width = 624
      Height = 441
      PopupMenu = PopupMenu
      TabOrder = 0
    end
  end
  object PopupMenu: TPopupMenu
    Left = 568
    Top = 152
    object PopupMenu1: TMenuItem
      Caption = 'Executar Scripts'
      OnClick = PopupMenu1Click
    end
  end
end
