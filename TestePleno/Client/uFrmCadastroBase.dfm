object frmCadastroBase: TfrmCadastroBase
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cadastro base'
  ClientHeight = 440
  ClientWidth = 886
  Color = clBtnFace
  Constraints.MaxHeight = 469
  Constraints.MaxWidth = 892
  Constraints.MinHeight = 469
  Constraints.MinWidth = 892
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlfundo: TPanel
    Left = 0
    Top = 0
    Width = 886
    Height = 440
    Align = alClient
    Caption = 'pnlfundo'
    TabOrder = 0
    object pgcGeral: TPageControl
      Left = 1
      Top = -29
      Width = 884
      Height = 468
      ActivePage = tsConsulta
      Style = tsFlatButtons
      TabOrder = 0
      object tsConsulta: TTabSheet
        Caption = 'tsConsulta'
        object grdConsulta: TJvDBGrid
          Left = 0
          Top = 50
          Width = 876
          Height = 387
          Align = alClient
          DataSource = dsConsulta
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          PopupMenu = pmMenu
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnDrawColumnCell = grdConsultaDrawColumnCell
          OnKeyDown = grdConsultaKeyDown
          OnMouseDown = grdConsultaMouseDown
          TitleButtons = True
          TitleButtonAllowMove = True
          ScrollBars = ssHorizontal
          SelectColumnsDialogStrings.Caption = 'Select columns'
          SelectColumnsDialogStrings.OK = '&OK'
          SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
          EditControls = <>
          RowsHeight = 17
          TitleRowHeight = 17
          Columns = <
            item
              Expanded = False
              Title.Caption = 'Alt.'
              Visible = True
            end
            item
              Expanded = False
              Title.Caption = 'Id'
              Width = 60
              Visible = True
            end
            item
              Expanded = False
              Title.Caption = 'Nome'
              Width = 700
              Visible = True
            end>
        end
        object pnlSuperior: TPanel
          Left = 0
          Top = 0
          Width = 876
          Height = 50
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object lblConsulta: TLabel
            Left = 3
            Top = 3
            Width = 46
            Height = 13
            Caption = 'Consultar'
          end
          object edtConsulta: TEdit
            Left = 3
            Top = 19
            Width = 806
            Height = 21
            TabOrder = 0
          end
          object chkCadastroAtivo: TCheckBox
            Left = 825
            Top = 19
            Width = 56
            Height = 17
            Caption = 'Ativo'
            TabOrder = 1
          end
        end
      end
      object tsCadastro: TTabSheet
        Caption = 'tsCadastro'
        ImageIndex = 1
      end
    end
  end
  object tmrConsulta: TTimer
    Left = 816
    Top = 96
  end
  object fmtConsulta: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 813
    Top = 155
  end
  object dsConsulta: TDataSource
    DataSet = fmtConsulta
    Left = 813
    Top = 211
  end
  object pmMenu: TPopupMenu
    Left = 813
    Top = 278
    object pmiAlterar: TMenuItem
      Caption = 'Alterar'
      OnClick = pmiAlterarClick
    end
    object pmiClonar: TMenuItem
      Caption = 'Clonar'
      OnClick = pmiClonarClick
    end
    object pmiExcluir: TMenuItem
      Caption = 'Excluir'
      OnClick = pmiExcluirClick
    end
  end
end
