object FDiamanti: TFDiamanti
  Left = 464
  Top = 209
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Diamanti - XMLs sempre guardados'
  ClientHeight = 409
  ClientWidth = 518
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object LabelConexao: TLabel
    Left = 19
    Top = 308
    Width = 178
    Height = 16
    Caption = 'Status da Conex'#227'o: Desativada'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LabelQuantidade: TLabel
    Left = 19
    Top = 328
    Width = 243
    Height = 16
    Caption = 'Quantidade de arquivos XML guardados: 0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object btnAdd: TButton
    Left = 208
    Top = 240
    Width = 91
    Height = 48
    Caption = 'Upload'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btnAddClick
  end
  object btnGet: TButton
    Left = 310
    Top = 240
    Width = 90
    Height = 48
    Caption = 'Download'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnGetClick
  end
  object btnDelete: TButton
    Left = 411
    Top = 240
    Width = 89
    Height = 48
    Caption = 'Apagar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnDeleteClick
  end
  object ListView1: TListView
    Left = 12
    Top = 11
    Width = 488
    Height = 214
    Columns = <
      item
        Caption = 'Chave de Acesso'
        Width = 400
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    SortType = stText
    TabOrder = 3
    ViewStyle = vsReport
  end
  object btnConnect: TButton
    Left = 14
    Top = 240
    Width = 86
    Height = 48
    Caption = 'Conectar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnConnectClick
  end
  object btnDisconnect: TButton
    Left = 111
    Top = 240
    Width = 86
    Height = 48
    Caption = 'Desconectar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = btnDisconnectClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'All files (*.*)|*.*'
    InitialDir = '.'
    Left = 123
    Top = 74
  end
  object SaveDialog1: TSaveDialog
    Filter = 'All files (*.*)|*.*'
    InitialDir = '.'
    Left = 209
    Top = 76
  end
end
