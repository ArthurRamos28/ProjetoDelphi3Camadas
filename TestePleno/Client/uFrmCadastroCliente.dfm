inherited FrmCadastroCliente: TFrmCadastroCliente
  Caption = 'Cadastro de cliente'
  ClientHeight = 394
  ClientWidth = 659
  Constraints.MaxWidth = 665
  Constraints.MinHeight = 300
  Constraints.MinWidth = 665
  Visible = False
  ExplicitWidth = 665
  ExplicitHeight = 423
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlfundo: TPanel
    Width = 659
    Height = 339
    ExplicitWidth = 659
    ExplicitHeight = 339
    inherited pgcGeral: TPageControl
      Top = 1
      Width = 657
      Height = 337
      Align = alClient
      ExplicitTop = 1
      ExplicitWidth = 657
      ExplicitHeight = 337
      inherited tsConsulta: TTabSheet
        ExplicitWidth = 649
        ExplicitHeight = 306
        inherited grdConsulta: TJvDBGrid
          Width = 649
          Height = 256
          OnDblClick = grdConsultaDblClick
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
              Width = 505
              Visible = True
            end>
        end
        inherited pnlSuperior: TPanel
          Width = 649
          ExplicitWidth = 649
        end
      end
      inherited tsCadastro: TTabSheet
        ExplicitWidth = 649
        ExplicitHeight = 306
        object lbl1: TLabel
          Left = 3
          Top = 5
          Width = 11
          Height = 13
          Caption = 'ID'
        end
        object lbl2: TLabel
          Left = 71
          Top = 5
          Width = 27
          Height = 13
          Caption = 'Nome'
        end
        object lbl3: TLabel
          Left = 438
          Top = 5
          Width = 19
          Height = 13
          Caption = 'CPF'
        end
        object lbl4: TLabel
          Left = 3
          Top = 51
          Width = 19
          Height = 13
          Caption = 'CEP'
        end
        object lbl5: TLabel
          Left = 130
          Top = 51
          Width = 45
          Height = 13
          Caption = 'Endere'#231'o'
        end
        object lbl6: TLabel
          Left = 3
          Top = 91
          Width = 28
          Height = 13
          Caption = 'Bairro'
        end
        object lbl7: TLabel
          Left = 303
          Top = 91
          Width = 33
          Height = 13
          Caption = 'Cidade'
        end
        object edtID: TEdit
          Left = 3
          Top = 24
          Width = 62
          Height = 21
          Enabled = False
          TabOrder = 0
        end
        object edtNome: TEdit
          Left = 71
          Top = 24
          Width = 361
          Height = 21
          TabOrder = 1
        end
        object edtCpf: TEdit
          Left = 438
          Top = 24
          Width = 148
          Height = 21
          TabOrder = 2
        end
        object edtCep: TEdit
          Left = 3
          Top = 64
          Width = 121
          Height = 21
          TabOrder = 4
          OnExit = edtCepExit
        end
        object edtEndereco: TEdit
          Left = 130
          Top = 64
          Width = 511
          Height = 21
          TabOrder = 5
        end
        object edtBairro: TEdit
          Left = 3
          Top = 104
          Width = 294
          Height = 21
          TabOrder = 6
        end
        object edtCidade: TEdit
          Left = 303
          Top = 104
          Width = 275
          Height = 21
          TabOrder = 7
        end
        object cbbEstado: TComboBox
          Left = 584
          Top = 104
          Width = 57
          Height = 22
          Style = csOwnerDrawFixed
          ItemIndex = 0
          TabOrder = 8
          Items.Strings = (
            ''
            'AC'
            'AL'
            'AP'
            'AM'
            'BA'
            'CE'
            'DF'
            'ES'
            'GO'
            'MT'
            'MS'
            'MG'
            'PA'
            'PB'
            'PR'
            'PE'
            'PI'
            'RN'
            'RS'
            'RO'
            'RR'
            'SC'
            'SP'
            'SE'
            'TO')
        end
        object chkAtivo: TCheckBox
          Left = 592
          Top = 26
          Width = 49
          Height = 17
          Caption = 'Ativo'
          TabOrder = 3
        end
      end
    end
  end
  object pnl1: TPanel [1]
    Left = 0
    Top = 339
    Width = 659
    Height = 55
    Align = alBottom
    TabOrder = 1
    inline FraBotao: TufraBotaoDuplo
      Left = 403
      Top = 6
      Width = 250
      Height = 45
      DoubleBuffered = False
      ParentDoubleBuffered = False
      TabOrder = 0
      ExplicitLeft = 403
      ExplicitTop = 6
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
          Caption = 'Sair'
          OnClick = FraBotaobtnSairClick
        end
      end
    end
  end
  inherited tmrConsulta: TTimer
    Left = 304
    Top = 8
  end
  inherited fmtConsulta: TFDMemTable
    Left = 373
    Top = 11
  end
  inherited dsConsulta: TDataSource
    Left = 437
    Top = 11
  end
  inherited pmMenu: TPopupMenu
    Left = 229
    Top = 6
  end
end
