object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Principal'
  ClientHeight = 597
  ClientWidth = 1293
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 1293
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Sistema em desenvolvimento'
    TabOrder = 0
  end
  object spvLateral: TSplitView
    Left = 0
    Top = 41
    Width = 200
    Height = 515
    OpenedWidth = 200
    Placement = svpLeft
    TabOrder = 1
    object btnMenuLateral: TCategoryButtons
      Left = 0
      Top = 0
      Width = 200
      Height = 515
      Align = alClient
      BorderStyle = bsNone
      ButtonFlow = cbfVertical
      ButtonHeight = 40
      ButtonOptions = [boFullSize, boShowCaptions, boVerticalCategoryCaptions, boCaptionOnlyBorder]
      Categories = <
        item
          Caption = 'Venda'
          Color = 15400959
          Collapsed = False
          Items = <
            item
              Caption = 'PDV'
              ImageIndex = 11
              ImageName = 'PDV'
              OnClick = btnMenuLateralCategories0Items0Click
            end
            item
              Caption = 'Relat'#243'rio de venda'
              ImageIndex = 22
              OnClick = btnMenuLateralCategories0Items1Click
            end>
        end
        item
          Caption = 'Cadastro'
          Color = 15400959
          Collapsed = False
          Items = <
            item
              Caption = 'Produto'
              ImageIndex = 5
              OnClick = btnMenuLateralCategories1Items0Click
            end
            item
              Caption = 'Cliente'
              ImageIndex = 22
              OnClick = btnMenuLateralCategories1Items1Click
            end>
        end>
      Images = DMImagem.img16x16
      RegularButtonColor = clNone
      SelectedButtonColor = clNone
      TabOrder = 0
    end
  end
  object pnlbarra: TPanel
    Left = 0
    Top = 556
    Width = 1293
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Desenvolvido por Dev. Arthur Ramos   07/2025'
    TabOrder = 2
    object imgGitHub: TImage
      Left = 1136
      Top = 8
      Width = 25
      Height = 25
    end
    object imgWebSite: TImage
      Left = 1176
      Top = 8
      Width = 25
      Height = 25
    end
    object imgLinkedIn: TImage
      Left = 1216
      Top = 8
      Width = 25
      Height = 25
    end
    object imgInstagram: TImage
      Left = 1256
      Top = 8
      Width = 25
      Height = 25
    end
  end
  object pnlServidorOffline: TPanel
    Left = 416
    Top = 278
    Width = 497
    Height = 131
    Caption = 'Servidor esta OFFLINE....................'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -25
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    Visible = False
  end
end
