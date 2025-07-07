object frmServer: TfrmServer
  Left = 271
  Top = 114
  Caption = 'frmServer'
  ClientHeight = 171
  ClientWidth = 399
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 8
    Width = 26
    Height = 13
    Caption = 'Porta'
  end
  object lblCaminhoBase: TLabel
    Left = 24
    Top = 54
    Width = 67
    Height = 13
    Caption = 'Caminho base'
  end
  object btnIniciar: TButton
    Left = 96
    Top = 95
    Width = 75
    Height = 25
    Caption = 'Iniciar'
    TabOrder = 0
    OnClick = btnIniciarClick
  end
  object btnParar: TButton
    Left = 209
    Top = 95
    Width = 75
    Height = 25
    Caption = 'Parar'
    TabOrder = 1
    OnClick = btnPararClick
  end
  object edtPorta: TEdit
    Left = 24
    Top = 27
    Width = 57
    Height = 21
    TabOrder = 2
    Text = '8080'
  end
  object Panel1: TPanel
    Left = 0
    Top = 130
    Width = 399
    Height = 41
    Align = alBottom
    TabOrder = 3
  end
  object edtCaminhoBase: TEdit
    Left = 24
    Top = 68
    Width = 337
    Height = 21
    TabOrder = 4
    Text = 
      'C:\Users\arthu\OneDrive\ProjetosPessoais\Delphi\TestePleno\Dados' +
      '\BASEPLENO.FDB'
  end
end
