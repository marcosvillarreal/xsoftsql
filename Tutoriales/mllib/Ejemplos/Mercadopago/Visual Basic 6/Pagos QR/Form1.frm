VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   5505
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   8385
   LinkTopic       =   "Form1"
   ScaleHeight     =   5505
   ScaleWidth      =   8385
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command2 
      Caption         =   "Enviar pago QR"
      Height          =   855
      Left            =   2280
      TabIndex        =   1
      Top             =   3000
      Width           =   3375
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Administrar cajas QR"
      Height          =   855
      Left            =   2280
      TabIndex        =   0
      Top             =   960
      Width           =   3375
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
  ' Configure las cajas desde el módulo para poder usarlas con QR.
  ' Antes genere las sucursales desde la página de Mercadolibre
  ' Las cajas creadas desde la página de mercadopago no son válidas.
  Dim mp As mllib.MPService
  Set mp = New mllib.MPService
  mp.ConfigureStore
End Sub

Private Sub Command2_Click()
  Dim mp As mllib.MPService
  Dim Params As mllib.JsonObject
  Dim Item As mllib.JsonObject
  
  Set mp = New mllib.MPService
  Set Params = New mllib.JsonObject
  Params.Str("title") = "Pago QR"
  Params.Str("description") = "Pago mediante QR"
  Params.Dbl("total_amount") = 1.1
  Params.Str("external_reference") = mp.newUuid 'Se recomeienda que referencia externa debe ser unica para cada transaccion.
  Set Item = Params.Arr("items").Obj(0)
  Item.Str("title") = "Item 1"
  Item.Dbl("total_amount") = 1.1
  Item.Str("unit_measure") = "unit"
  Item.Dbl("quantity") = 1
  Item.Dbl("unit_price") = 1.1
  If mp.QRCreateOrder(Params) Then
    If mp.WaitQRPayment Then
      ' Obtengo informacion del pago. Json de ejemplo disponible en
      ' https://www.mercadopago.com.ar/developers/es/reference/payments/_payments_id/get
      oPayment = mp.GetPaymentResponseAsObj
      ' Guardar el id de pago en el sistema para consultarlo posteriormente en caso de ser necesario (mp.GetPayment(Id))
      id = oPayment.id
      Status = oPayment.Status ' approved, rejected, etc.
      If Status = "approved" Then
        date_approved = oPayment.date_approved
        transaction_amount = oPayment.transaction_amount
        ' Es el tipo de método de pago (tarjeta, transferencia bancaria, ticket, ATM, etc.)
        payment_type_id = oPayment.payment_type_id
        MsgBox ("Pago realizado con éxito. Id de operación  = " + id)
      ElseIf Status = "rejected" Then
        MsgBox ("El pago ha sido rechazado!")
      Else
        MsgBox ("El pago esta siendo procesado. Consulte el estado dentro de algunos minutos.")
      End If
    End If
  Else
    MsgBox (mp.ErrorDesc)
  End If

End Sub
