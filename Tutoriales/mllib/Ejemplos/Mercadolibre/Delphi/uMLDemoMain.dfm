object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Demo mllib'
  ClientHeight = 676
  ClientWidth = 1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1072
    Height = 676
    ActivePage = TabSheet3
    Align = alClient
    TabOrder = 0
    object TabSheet3: TTabSheet
      Caption = 'Mercadolibre'
      ImageIndex = 2
      object Label1: TLabel
        Left = 13
        Top = 79
        Width = 95
        Height = 13
        Caption = 'Respuesta en JSON'
      end
      object Label2: TLabel
        Left = 536
        Top = 79
        Width = 81
        Height = 13
        Caption = 'Datos parseados'
      end
      object Button9: TButton
        Left = 13
        Top = 34
        Width = 85
        Height = 25
        Caption = 'Listar articulos'
        TabOrder = 0
        OnClick = Button9Click
      end
      object Button10: TButton
        Left = 12
        Top = 3
        Width = 162
        Height = 25
        Caption = 'Obtener Ordenes Recientes'
        TabOrder = 1
        OnClick = Button10Click
      end
      object Memo1: TMemo
        Left = 13
        Top = 98
        Width = 500
        Height = 538
        Lines.Strings = (
          '')
        ScrollBars = ssBoth
        TabOrder = 2
      end
      object Button11: TButton
        Left = 366
        Top = 3
        Width = 121
        Height = 25
        Caption = 'Cargar Factura'
        TabOrder = 3
        OnClick = Button11Click
      end
      object Button12: TButton
        Left = 493
        Top = 3
        Width = 121
        Height = 25
        Caption = 'Obtener Id Factura'
        TabOrder = 4
        OnClick = Button12Click
      end
      object Button13: TButton
        Left = 622
        Top = 3
        Width = 121
        Height = 25
        Caption = 'Obtener Factura'
        TabOrder = 5
        OnClick = Button13Click
      end
      object Button14: TButton
        Left = 105
        Top = 34
        Width = 161
        Height = 25
        Caption = 'Actualizar stock de articulo'
        TabOrder = 6
        OnClick = Button14Click
      end
      object Button15: TButton
        Left = 180
        Top = 3
        Width = 180
        Height = 25
        Caption = 'Obtener Informacion facturacion'
        TabOrder = 7
        OnClick = Button15Click
      end
      object Button17: TButton
        Left = 269
        Top = 34
        Width = 218
        Height = 25
        Caption = 'Informaci'#243'n del usuario autenticado'
        TabOrder = 8
        OnClick = Button17Click
      end
      object Memo2: TMemo
        Left = 536
        Top = 98
        Width = 510
        Height = 535
        Lines.Strings = (
          '')
        ScrollBars = ssBoth
        TabOrder = 9
      end
      object Button19: TButton
        Left = 493
        Top = 34
        Width = 75
        Height = 25
        Caption = 'Cerrar Sesion'
        TabOrder = 10
        OnClick = Button19Click
      end
    end
  end
end
