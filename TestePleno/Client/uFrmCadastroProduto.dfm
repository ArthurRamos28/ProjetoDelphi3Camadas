inherited FrmCadastroProduto: TFrmCadastroProduto
  Caption = 'Cadastro de produto'
  ClientWidth = 824
  Constraints.MaxWidth = 830
  Constraints.MinWidth = 830
  Visible = False
  ExplicitWidth = 830
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlfundo: TPanel
    Width = 824
    Height = 385
    ExplicitWidth = 824
    ExplicitHeight = 385
    inherited pgcGeral: TPageControl
      Top = 1
      Width = 822
      Height = 383
      ExplicitTop = 1
      ExplicitWidth = 822
      ExplicitHeight = 383
      inherited tsConsulta: TTabSheet
        ExplicitWidth = 814
        ExplicitHeight = 352
        inherited grdConsulta: TJvDBGrid
          Width = 814
          Height = 302
          OnDblClick = grdConsultaDblClick
          SelectColumn = scGrid
          Columns = <
            item
              Alignment = taCenter
              Expanded = False
              Title.Caption = 'Alt.'
              Width = 30
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
        inherited pnlSuperior: TPanel
          Width = 814
          ExplicitWidth = 814
          inherited edtConsulta: TEdit
            Width = 710
            ExplicitWidth = 710
          end
          inherited chkCadastroAtivo: TCheckBox
            Left = 732
            ExplicitLeft = 732
          end
        end
      end
      inherited tsCadastro: TTabSheet
        ExplicitWidth = 814
        ExplicitHeight = 352
        object lbl1: TLabel
          Left = 3
          Top = 8
          Width = 11
          Height = 13
          Caption = 'ID'
        end
        object lbl2: TLabel
          Left = 79
          Top = 8
          Width = 27
          Height = 13
          Caption = 'Nome'
        end
        object lbl3: TLabel
          Left = 639
          Top = 8
          Width = 27
          Height = 13
          Caption = 'Pre'#231'o'
        end
        object lbl4: TLabel
          Left = 3
          Top = 54
          Width = 46
          Height = 13
          Caption = 'Descri'#231#227'o'
        end
        object edtID: TEdit
          Left = 3
          Top = 27
          Width = 70
          Height = 21
          Enabled = False
          TabOrder = 0
        end
        object edtNome: TEdit
          Left = 79
          Top = 27
          Width = 554
          Height = 21
          TabOrder = 1
        end
        object mmoDescricao: TMemo
          Left = 0
          Top = 72
          Width = 814
          Height = 280
          Align = alBottom
          TabOrder = 4
        end
        object chkAtivo: TCheckBox
          Left = 766
          Top = 30
          Width = 45
          Height = 17
          Caption = 'Ativo'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object edtPreco: TEdit
          Left = 639
          Top = 27
          Width = 121
          Height = 21
          TabOrder = 2
        end
      end
    end
  end
  object pnlBarra: TPanel [1]
    Left = 0
    Top = 385
    Width = 824
    Height = 55
    Align = alBottom
    TabOrder = 1
    inline FraBotao: TufraBotaoDuplo
      Left = 550
      Top = 4
      Width = 250
      Height = 45
      DoubleBuffered = False
      ParentDoubleBuffered = False
      TabOrder = 0
      ExplicitLeft = 550
      ExplicitTop = 4
      inherited pnl1: TPanel
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 250
        ExplicitHeight = 45
        inherited btnOk: TButton
          Caption = 'Novo'
          OnClick = FraBotaobtnOkClick
        end
        inherited btnSair: TButton
          Left = 130
          Align = alRight
          Caption = 'Sair'
          OnClick = FraBotaobtnSairClick
          ExplicitLeft = 130
        end
        inherited pnl2: TPanel
          Width = 10
          Align = alClient
          ExplicitWidth = 10
        end
      end
    end
  end
  inherited tmrConsulta: TTimer
    Left = 736
    Top = 112
  end
  inherited fmtConsulta: TFDMemTable
    Left = 733
    Top = 171
  end
  inherited dsConsulta: TDataSource
    Left = 733
    Top = 235
  end
  inherited pmMenu: TPopupMenu
    Left = 733
    Top = 302
  end
end
