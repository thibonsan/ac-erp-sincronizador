object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Agente'
  ClientHeight = 242
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 28
  object Memo1: TMemo
    Left = 0
    Top = 64
    Width = 628
    Height = 178
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 63
    ExplicitWidth = 624
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 97
    Height = 41
    Caption = 'Start'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 420
    Top = 8
    Width = 97
    Height = 41
    Caption = 'Evento'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 523
    Top = 8
    Width = 97
    Height = 41
    Caption = 'Testar'
    TabOrder = 3
    OnClick = Button3Click
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=C:\Users\Thibonsan\Projetos\Delphi\dados.sdb'
      'LockingMode=Normal'
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    Left = 144
    Top = 8
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 240
    Top = 8
  end
  object FDEventAlerter1: TFDEventAlerter
    Connection = FDConnection1
    Options.Timeout = 1000
    OnAlert = FDEventAlerter1Alert
    OnTimeout = FDEventAlerter1Timeout
    Left = 328
    Top = 8
  end
end
