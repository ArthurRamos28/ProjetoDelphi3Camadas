object FrmPDV: TFrmPDV
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'PDV'
  ClientHeight = 321
  ClientWidth = 662
  Color = clBtnFace
  Constraints.MaxHeight = 352
  Constraints.MaxWidth = 670
  Constraints.MinHeight = 352
  Constraints.MinWidth = 670
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object grdLancamento: TDBGrid
    Left = 0
    Top = 65
    Width = 353
    Height = 215
    Align = alLeft
    DataSource = dsLancamentoItem
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'NomeProduto'
        Title.Alignment = taCenter
        Title.Caption = 'Produto'
        Width = 130
        Visible = True
      end
      item
        Alignment = taLeftJustify
        Expanded = False
        FieldName = 'Quantidade'
        Title.Alignment = taCenter
        Title.Caption = 'Qtde.'
        Width = 45
        Visible = True
      end
      item
        Alignment = taLeftJustify
        Expanded = False
        FieldName = 'ValorUnitario'
        Title.Alignment = taCenter
        Title.Caption = 'Valor unit'#225'rio'
        Width = 70
        Visible = True
      end
      item
        Alignment = taLeftJustify
        Expanded = False
        FieldName = 'ValorTotal'
        Title.Alignment = taCenter
        Title.Caption = 'Valor total'
        Width = 70
        Visible = True
      end>
  end
  object pnl1: TPanel
    Left = 353
    Top = 65
    Width = 309
    Height = 215
    Align = alClient
    TabOrder = 1
    object lbl1: TLabel
      Left = 16
      Top = 13
      Width = 38
      Height = 13
      Caption = 'Produto'
    end
    object lblNomeProduto: TLabel
      Left = 95
      Top = 35
      Width = 83
      Height = 13
      Caption = 'Nome do produto'
    end
    object lbl3: TLabel
      Left = 88
      Top = 61
      Width = 63
      Height = 13
      Caption = 'Valor unitario'
    end
    object lbl4: TLabel
      Left = 16
      Top = 61
      Width = 56
      Height = 13
      Caption = 'Quantidade'
    end
    object lbl5: TLabel
      Left = 167
      Top = 61
      Width = 49
      Height = 13
      Caption = 'Valor total'
    end
    object edtIdProduto: TButtonedEdit
      Left = 16
      Top = 32
      Width = 73
      Height = 21
      Images = DMImagem.img16x16
      LeftButton.DisabledImageIndex = 0
      LeftButton.ImageIndex = 31
      NumbersOnly = True
      RightButton.DisabledImageIndex = 40
      RightButton.ImageIndex = 1
      RightButton.PressedImageIndex = 2
      RightButton.Visible = True
      TabOrder = 0
      OnChange = edtIdProdutoChange
      OnClick = edtIdProdutoClick
    end
    object edtQuantidade: TEdit
      Left = 16
      Top = 77
      Width = 66
      Height = 21
      NumbersOnly = True
      TabOrder = 2
      OnChange = edtQuantidadeChange
    end
    object edtValorUnitario: TEdit
      Left = 88
      Top = 77
      Width = 73
      Height = 21
      Enabled = False
      TabOrder = 1
    end
    object edtValorTotal: TEdit
      Left = 167
      Top = 77
      Width = 80
      Height = 21
      Enabled = False
      TabOrder = 3
    end
    object btnIncluir: TButton
      Left = 16
      Top = 128
      Width = 281
      Height = 50
      Caption = 'Incluir'
      TabOrder = 4
      OnClick = btnIncluirClick
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 0
    Width = 662
    Height = 65
    Align = alTop
    Caption = 'pnl2'
    TabOrder = 2
    object lbl2: TLabel
      Left = 8
      Top = 4
      Width = 76
      Height = 13
      Caption = 'Nome do cliente'
    end
    object edtCliente: TEdit
      Left = 8
      Top = 23
      Width = 433
      Height = 21
      TabOrder = 0
    end
    object btnPesquisar: TButton
      Left = 447
      Top = 21
      Width = 74
      Height = 25
      Caption = 'Buscar'
      TabOrder = 1
      OnClick = btnPesquisarClick
    end
  end
  object pnl3: TPanel
    Left = 0
    Top = 280
    Width = 662
    Height = 41
    Align = alBottom
    TabOrder = 3
    object lblTotalLancado: TLabel
      Left = 128
      Top = 6
      Width = 62
      Height = 22
      Caption = 'R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblNomeTotal: TLabel
      Left = 8
      Top = 14
      Width = 109
      Height = 13
      Caption = 'Total de lan'#231'amentos: '
    end
    object btnFechar: TButton
      Left = 369
      Top = 6
      Width = 281
      Height = 27
      Caption = 'Finalizar venda'
      TabOrder = 0
      OnClick = btnFecharClick
    end
  end
  object fmtLancamento: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 576
    Top = 56
    object fmtLancamentoValorTotal: TFloatField
      FieldName = 'ValorTotal'
    end
    object fmtLancamentoDataCadastro: TDateField
      FieldName = 'DataCadastro'
    end
    object fmtLancamentoId: TIntegerField
      FieldName = 'Id'
    end
    object fmtLancamentoIdCliente: TIntegerField
      FieldName = 'IdCliente'
    end
    object fmtLancamentoNomeCliente: TStringField
      FieldName = 'NomeCliente'
      Size = 255
    end
  end
  object dsLancamentoItem: TDataSource
    DataSet = fmtLancamentoItem
    Left = 576
    Top = 8
  end
  object fmtLancamentoItem: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 561
    Top = 121
    object fmtLancamentoItemId: TIntegerField
      FieldName = 'Id'
    end
    object fmtLancamentoItemIdLancamento: TIntegerField
      FieldName = 'IdLancamento'
    end
    object fmtLancamentoItemIdProduto: TIntegerField
      FieldName = 'IdProduto'
    end
    object fmtLancamentoItemQuantidade: TIntegerField
      FieldName = 'Quantidade'
    end
    object fmtLancamentoItemValorUnitario: TFloatField
      FieldName = 'ValorUnitario'
    end
    object fmtLancamentoItemValorTotal: TFloatField
      FieldName = 'ValorTotal'
    end
    object fmtLancamentoItemNomeProduto: TStringField
      FieldName = 'NomeProduto'
      Size = 255
    end
  end
end
