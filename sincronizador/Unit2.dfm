object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 320
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 28
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 97
    Height = 41
    Caption = 'Monitorar'
    TabOrder = 0
  end
  object Button2: TButton
    Left = 523
    Top = 8
    Width = 97
    Height = 41
    Caption = 'Parar'
    Enabled = False
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 0
    Top = 62
    Width = 628
    Height = 258
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 53
    ExplicitWidth = 622
  end
  object FDQuery1: TFDQuery
    Active = True
    Connection = FDConnection1
    SQL.Strings = (
      'select * from sincronizar')
    Left = 352
    Top = 8
    object FDQuery1valor1: TIntegerField
      FieldName = 'valor1'
      Origin = 'valor1'
    end
    object FDQuery1valor2: TIntegerField
      FieldName = 'valor2'
      Origin = 'valor2'
    end
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=postgres'
      'User_Name=postgres'
      'Password=postgres'
      'Server=localhost'
      'DriverID=PG')
    Connected = True
    LoginPrompt = False
    Left = 144
    Top = 8
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    VendorHome = 
      'C:\Users\Thibonsan\Projetos\Delphi\ac-erp-sincronizador\sincroni' +
      'zador\bin'
    Left = 256
    Top = 8
  end
end
