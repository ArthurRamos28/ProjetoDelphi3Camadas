object FrmRelatorioVenda: TFrmRelatorioVenda
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Relat'#243'rio de venda'
  ClientHeight = 172
  ClientWidth = 284
  Color = clBtnFace
  Constraints.MaxHeight = 203
  Constraints.MaxWidth = 292
  Constraints.MinHeight = 203
  Constraints.MinWidth = 292
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 284
    Height = 172
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lbl1: TLabel
      Left = 7
      Top = 20
      Width = 43
      Height = 13
      Caption = 'Per'#237'odo: '
    end
    object lbl2: TLabel
      Left = 159
      Top = 20
      Width = 6
      Height = 13
      Caption = #224
    end
    object edtDataInicio: TDateTimePicker
      Left = 53
      Top = 15
      Width = 97
      Height = 21
      Date = 45841.000000000000000000
      Time = 0.573405393515713500
      TabOrder = 0
    end
    object edtDataFinal: TDateTimePicker
      Left = 174
      Top = 15
      Width = 97
      Height = 21
      Date = 45841.000000000000000000
      Time = 0.573405393515713500
      TabOrder = 1
    end
    object btnGerar: TButton
      Left = 71
      Top = 92
      Width = 137
      Height = 25
      Caption = 'Gerar'
      TabOrder = 2
      OnClick = btnGerarClick
    end
  end
  object frxDBDataSet: TfrxDBDataset
    UserName = 'Dados'
    CloseDataSource = False
    DataSet = fmtRelatorio
    BCDToCurrency = False
    Left = 224
    Top = 104
  end
  object fmtRelatorio: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 136
    Top = 88
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 176
    Top = 56
  end
  object frxReport: TfrxReport
    Version = '6.9.12'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 45844.653241678200000000
    ReportOptions.LastChange = 45844.668359050930000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 232
    Top = 32
    Datasets = <
      item
        DataSet = frxDBDataSet
        DataSetName = 'Dados'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 20.000000000000000000
      Left = 125.000000000000000000
      Width = 80.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      Frame.Typ = []
      MirrorMode = []
      object ReportTitle1: TfrxReportTitle
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 37.559060000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        object MemoTitle: TfrxMemoView
          AllowVectorExport = True
          Width = 718.000000000000000000
          Height = 26.220470000000000000
          Frame.Typ = []
          HAlign = haCenter
        end
        object Memo6: TfrxMemoView
          Align = baClient
          AllowVectorExport = True
          Width = 718.110700000000000000
          Height = 37.559060000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            'Relat'#243'rio de vendas')
          ParentFont = False
        end
      end
      object PageHeader1: TfrxPageHeader
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 20.000000000000000000
        Top = 79.370130000000000000
        Width = 718.110700000000000000
      end
      object GroupHeader1: TfrxGroupHeader
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 27.559060000000000000
        Top = 158.740260000000000000
        Width = 718.110700000000000000
        Condition = 'Dados."LAN_ID"'
        object HdrCliente: TfrxMemoView
          Align = baLeft
          AllowVectorExport = True
          Top = 3.779530000000000000
          Width = 120.000000000000000000
          Height = 20.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          Memo.UTF8W = (
            'Cliente')
          ParentFont = False
        end
        object HdrData: TfrxMemoView
          Align = baLeft
          AllowVectorExport = True
          Left = 120.000000000000000000
          Top = 3.779530000000000000
          Width = 80.000000000000000000
          Height = 20.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          Memo.UTF8W = (
            'Data')
          ParentFont = False
        end
        object HdrProduto: TfrxMemoView
          Align = baLeft
          AllowVectorExport = True
          Left = 200.000000000000000000
          Top = 3.779530000000000000
          Width = 100.000000000000000000
          Height = 20.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          Memo.UTF8W = (
            'Produto')
          ParentFont = False
        end
        object HdrQtd: TfrxMemoView
          Align = baLeft
          AllowVectorExport = True
          Left = 300.000000000000000000
          Top = 3.779530000000000000
          Width = 50.000000000000000000
          Height = 20.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            'Qtd')
          ParentFont = False
        end
        object HdrValorUnit: TfrxMemoView
          Align = baLeft
          AllowVectorExport = True
          Left = 350.000000000000000000
          Top = 3.779530000000000000
          Width = 100.000000000000000000
          Height = 20.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            'Vlr Unit.')
          ParentFont = False
        end
        object HdrValorTotal: TfrxMemoView
          Align = baLeft
          AllowVectorExport = True
          Left = 450.000000000000000000
          Top = 3.779530000000000000
          Width = 100.000000000000000000
          Height = 20.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            'Vlr Total')
          ParentFont = False
        end
        object Memo1: TfrxMemoView
          Align = baWidth
          AllowVectorExport = True
          Left = 550.000000000000000000
          Top = 3.779530000000000000
          Width = 168.110700000000000000
          Height = 20.031496062992130000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          HAlign = haRight
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 20.000000000000000000
        Top = 207.874150000000000000
        Width = 718.110700000000000000
        DataSet = frxDBDataSet
        DataSetName = 'Dados'
        RowCount = 0
        object Cliente: TfrxMemoView
          Align = baLeft
          AllowVectorExport = True
          Width = 120.000000000000000000
          Height = 20.000000000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            '[Dados."LAN_CLI_NOME"]')
        end
        object Produto: TfrxMemoView
          Align = baLeft
          AllowVectorExport = True
          Left = 201.102350000000000000
          Width = 100.000000000000000000
          Height = 20.000000000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            '[Dados."PRO_NOME"]')
        end
        object Quantidade: TfrxMemoView
          Align = baLeft
          AllowVectorExport = True
          Left = 301.102350000000000000
          Width = 50.000000000000000000
          Height = 20.000000000000000000
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[Dados."LAI_QUANTIDADE"]')
        end
        object ValorUnitario: TfrxMemoView
          Align = baLeft
          AllowVectorExport = True
          Left = 351.102350000000000000
          Width = 100.000000000000000000
          Height = 20.000000000000000000
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[Dados."LAI_VALOR_UNITARIO"]')
        end
        object ValorTotal: TfrxMemoView
          Align = baLeft
          AllowVectorExport = True
          Left = 451.102350000000000000
          Width = 100.000000000000000000
          Height = 20.000000000000000000
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[Dados."LAI_VALOR_TOTAL"]')
        end
        object Memo2: TfrxMemoView
          Align = baLeft
          AllowVectorExport = True
          Left = 120.000000000000000000
          Width = 81.102350000000000000
          Height = 20.000000000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            '[Dados."LAN_DATA"]')
        end
      end
      object GroupFooter1: TfrxGroupFooter
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 20.000000000000000000
        Top = 249.448980000000000000
        Width = 718.110700000000000000
        object Memo3: TfrxMemoView
          Align = baRight
          AllowVectorExport = True
          Left = 498.897960000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            'Total: ')
          ParentFont = False
        end
        object Memo4: TfrxMemoView
          Align = baRight
          AllowVectorExport = True
          Left = 593.386210000000000000
          Width = 124.724490000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '[Dados."LAN_VALOR_TOTAL"]')
          ParentFont = False
        end
        object Memo5: TfrxMemoView
          Align = baWidth
          AllowVectorExport = True
          Width = 498.897960000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          HAlign = haRight
          ParentFont = False
        end
      end
      object PageFooter1: TfrxPageFooter
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 20.000000000000000000
        Top = 328.819110000000000000
        Width = 718.110700000000000000
        object Rodape: TfrxMemoView
          AllowVectorExport = True
          Width = 718.000000000000000000
          Height = 20.000000000000000000
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            'P'#225'gina [Page#] de [TotalPages#]')
        end
      end
    end
  end
end
