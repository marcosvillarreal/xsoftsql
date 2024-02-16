VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Demo Mercadolibre - Ordenes"
   ClientHeight    =   6330
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   8955
   LinkTopic       =   "Form1"
   ScaleHeight     =   6330
   ScaleWidth      =   8955
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command7 
      Caption         =   "Infomacion de facturación"
      Height          =   615
      Left            =   240
      TabIndex        =   7
      Top             =   5520
      Width           =   2175
   End
   Begin VB.CommandButton Command6 
      Caption         =   "Actualizar Stock"
      Height          =   615
      Left            =   240
      TabIndex        =   6
      Top             =   4680
      Width           =   2175
   End
   Begin VB.CommandButton Command5 
      Caption         =   "Obtener Items"
      Height          =   615
      Left            =   240
      TabIndex        =   5
      Top             =   3840
      Width           =   2175
   End
   Begin VB.CommandButton Command4 
      Caption         =   "Obtener Factura"
      Height          =   615
      Left            =   240
      TabIndex        =   4
      Top             =   3000
      Width           =   2175
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Obtener Id Factura"
      Height          =   615
      Left            =   240
      TabIndex        =   3
      Top             =   2040
      Width           =   2175
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Cargar Facturas"
      Height          =   615
      Left            =   240
      TabIndex        =   2
      Top             =   1080
      Width           =   2175
   End
   Begin VB.TextBox Text1 
      Height          =   6015
      Left            =   2640
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   1
      Top             =   240
      Width           =   6255
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Obtener ordenes recientes"
      Height          =   615
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   2175
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
  
  ' Ejemplo de obtencion de las ordenes recientes de Mercadolibre.
  ' Describe la api documentada en https://developers.mercadolibre.com.ar/es_ar/gestiona-ventas#Ordenes-recientes
  
    Dim ml As mllib.MLService
    Set ml = New mllib.MLService
    
    ' Configuracion de filtros para acotar resultados
    Dim Filter As mllib.JsonObject
    Set Filter = ml.CreateFilter
    Filter.Str("sort") = "date_desc" ' Ordenamiento de las mismas de manera descenciente por fecha
    Filter.Str("tags") = "not_delivered" ' Ordenes que aun no han sido señaladas como entregadas
    Filter.Str("seller") = ml.UserId ' filtrar ordenes segun el id de vendedor autenticado
    Filter.Int("offset") = 0 ' Posicion del primer registro a traer de la lista.
    
    ' Obtención de las primeras 50 ordenes de compra
    If ml.GetRecentOrders(Filter) Then
      Dim Orders As mllib.JsonArray
      Set Orders = ml.GetRecentOrdersResponse.Arr("results")
      For I = 0 To Orders.Count - 1
        Dim Order As mllib.JsonObject
        
        If ml.GetOrders(Orders.Obj(I).Str("id")) Then
            Set Order = ml.GetOrdersResponse
            
            ' Datos de cada orden
            Text1.Text = Text1.Text + "********ORDEN " + Order.Str("id") + "********" + Chr(13) + Chr(10)
            Text1.Text = Text1.Text + "fecha de creacion=" + Order.Str("date_created") + Chr(13) + Chr(10)
            Text1.Text = Text1.Text + "nombre de vendedor=" + Order.Obj("seller").Str("first_name") + Chr(13) + Chr(10)
            Text1.Text = Text1.Text + "apellido de vendedor=" + Order.Obj("seller").Str("last_name") + Chr(13) + Chr(10)
            Text1.Text = Text1.Text + "email del vendedor=" + Order.Obj("seller").Str("email") + Chr(13) + Chr(10)
            Text1.Text = Text1.Text + "nombre de comprador=" + Order.Obj("buyer").Str("first_name") + Chr(13) + Chr(10)
            Text1.Text = Text1.Text + "apellido de comprador=" + Order.Obj("buyer").Str("last_name") + Chr(13) + Chr(10)
            Text1.Text = Text1.Text + "email del comprador=" + Order.Obj("buyer").Str("email") + Chr(13) + Chr(10)
            Text1.Text = Text1.Text + "tipo de documento del comprador=" + Order.Obj("buyer").Obj("billing_info").Str("doc_number") + Chr(13) + Chr(10)
            Text1.Text = Text1.Text + "docuemnto del comprador=" + Order.Obj("buyer").Obj("billing_info").Str("doc_type") + Chr(13) + Chr(10)
            For J = 0 To Order.Arr("order_items").Count - 1
              Text1.Text = Text1.Text + "    ********ARTICULO " + Order.Arr("order_items").Obj(J).Obj("item").Str("id") + "********" + Chr(13) + Chr(10)
              Text1.Text = Text1.Text + "    titulo=" + Order.Arr("order_items").Obj(J).Obj("item").Str("title") + Chr(13) + Chr(10)
              Text1.Text = Text1.Text + "    sku=" + Order.Arr("order_items").Obj(J).Obj("item").Str("seller_sku") + Chr(13) + Chr(10)
              Text1.Text = Text1.Text + "    cantidad=" + Order.Arr("order_items").Obj(J).Str("quantity") + Chr(13) + Chr(10)
              Text1.Text = Text1.Text + "    precio=" + Order.Arr("order_items").Obj(J).Str("unit_price") + Chr(13) + Chr(10)
              Text1.Text = Text1.Text + "    monto=" + Order.Arr("order_items").Obj(J).Str("full_unit_price") + Chr(13) + Chr(10)
              Text1.Text = Text1.Text + "    comision=" + Order.Arr("order_items").Obj(J).Str("sale_fee") + Chr(13) + Chr(10)
            Next
        Else
          MsgBox (ml.ErrorDesc)
          Exit For
        End If
      Next
    Else
      MsgBox ml.ErrorDesc
    End If
    
End Sub

Private Sub Command2_Click()
  ' https://developers.mercadolibre.com.ar/es_ar/cargar-factura
  Dim ml As mllib.MLService
  Set ml = New mllib.MLService
  Dim PackId As String
  PackId = "4475227777" ' Pack ID y si este es null entonces Order ID
  If ml.PostPacksFiscalDocuments(PackId, "c:\Datos\factura.pdf") Then
    ' Este ID de factura se debe guardar en el sistema por si se necesita eliminar en mercadolibre
    FileId = ml.PostPacksFiscalDocumentsResponse.Arr("ids").Str(0)
    MsgBox ("Factura cargada con éxito")
  Else
    MsgBox (ml.ErrorDesc)
  End If
End Sub

Private Sub Command3_Click()
  Dim PackId As String
  Dim I As Integer
  Dim ml As mllib.MLService
  Set ml = New mllib.MLService
  PackId = "4475227777" ' Pack ID y si este es null entonces Order ID
  If ml.GetPacksFiscalDocumentsId(PackId) Then
    For I = 0 To ml.GetPacksFiscalDocumentsIdResponse.Arr("fiscal_documents").Count - 1
      If ml.GetPacksFiscalDocumentsIdResponse.Arr("fiscal_documents").Obj(I).Str("file_type") = "application/pdf" Then
        Text1.Text = ml.GetPacksFiscalDocumentsIdResponse.Arr("fiscal_documents").Obj(I).Str("id")
      End If
    Next
  Else
    MsgBox (ml.ErrorDesc)
  End If
End Sub

Private Sub Command4_Click()
  Dim PackId As String
  Dim I As Integer
  Dim FiscalDocumentId As String
  Dim ml As mllib.MLService
  Set ml = New MLService
  PackId = "4475227777" ' Pack ID y si este es null entonces Order ID
  FiscalDocumentId = "488d6f69-ec94-4f62-8576-1a639f2d2d87"
  If ml.GetPacksFiscalDocument(PackId, FiscalDocumentId, "C:\Datos\factura.pdf") Then
    MsgBox ("Archivo descargado con éxito.")
  Else
    MsgBox (ml.ErrorDesc)
  End If
End Sub

Private Sub Command5_Click()
  Dim ml As mllib.MLService
  Dim Ids As String
  Dim Filter As mllib.JsonObject
  
  Text1.Text = ""
  Set ml = New mllib.MLService
  If ml.GetUserItems(Nothing) Then
    For I = 0 To ml.GetItemsResponse.Arr("results").Count - 1
      If I = 0 Then
        Ids = ml.GetItemsResponse.Arr("results").Str(I)
      Else
        Ids = Ids + "," + ml.GetItemsResponse.Arr("results").Str(I)
      End If
      If I = 19 Then ' El maximo nro de items a traer en un request es de 20
        Exit For
      End If
    Next
    Set Filter = ml.CreateFilter
    Filter.Str("ids") = Ids
    If ml.GetItems(Filter) Then
      For I = 0 To ml.GetItemsResponse.Arr("results").Count - 1
         Set Item = ml.GetItemsResponse.Arr("results").Obj(I).Obj("body")
         Text1.Text = Text1.Text + "********ARTICULO********" + Chr(13) + Chr(10)
         Text1.Text = Text1.Text + "id=" + Item.Str("id") + Chr(13) + Chr(10)
         Text1.Text = Text1.Text + "titulo=" + Item.Str("title") + Chr(13) + Chr(10)
         Text1.Text = Text1.Text + "precio=" + Item.Str("price") + Chr(13) + Chr(10)
         Text1.Text = Text1.Text + "cantidad inicial=" + Item.Str("initial_quantity") + Chr(13) + Chr(10)
         Text1.Text = Text1.Text + "cantidad disponible=" + Item.Str("available_quantity") + Chr(13) + Chr(10)
         Text1.Text = Text1.Text + "cantidad vendida=" + Item.Str("sold_quantity") + Chr(13) + Chr(10)
      Next
    Else
      MsgBox (ml.ErrorDesc)
    End If
  Else
    MsgBox (ml.ErrorDesc)
  End If
End Sub

Private Sub Command6_Click()
  ' https://developers.mercadolibre.com.ar/es_ar/producto-sincroniza-modifica-publicaciones#Actualiza-tu-art%C3%ADculo
  Dim ml As mllib.MLService
  Dim ItemId As String
  Dim Filter As mllib.JsonObject
  
  Set ml = New mllib.MLService
  ItemId = "MLA914228251"
  Set Filter = ml.CreateFilter
  Filter.Int("available_quantity") = 1
  If ml.PutItems(ItemId, Filter) Then
    MsgBox ("Cantidad actualizada con éxito")
  Else
    MsgBox (ml.ErrorDesc)
  End If
End Sub

Private Sub Command7_Click()
  Dim OrderID As String
  Dim BillingInfo As mllib.JsonObject
  Dim ml As mllib.MLService
  
  Set ml = New mllib.MLService
  OrderID = "4565755501"
  If ml.GetBillingInfo(OrderID) Then
    Set BillingInfo = ml.GetBillingInfoResponse.Obj("billing_info")
    For I = 0 To BillingInfo.Arr("additional_info").Count - 1
      If BillingInfo.Arr("additional_info").Obj(I).Str("type") = "ZIP_CODE" Then
        CodigoPostal = BillingInfo.Arr("additional_info").Obj(I).Str("value")
      End If
      If BillingInfo.Arr("additional_info").Obj(I).Str("type") = "CITY_NAME" Then
        Ciudad = BillingInfo.Arr("additional_info").Obj(I).Str("value")
      End If
      If BillingInfo.Arr("additional_info").Obj(I).Str("type") = "STATE_NAME" Then
        Povincia = BillingInfo.Arr("additional_info").Obj(I).Str("value")
      End If
      If BillingInfo.Arr("additional_info").Obj(I).Str("type") = "STREET_NAME" Then
        Calle = BillingInfo.Arr("additional_info").Obj(I).Str("value")
      End If
      If BillingInfo.Arr("additional_info").Obj(I).Str("type") = "STREET_NUMBER" Then
        NumeroCasa = BillingInfo.Arr("additional_info").Obj(I).Str("value")
      End If
      If BillingInfo.Arr("additional_info").Obj(I).Str("type") = "DOC_NUMBER" Then
        NroDocumento = BillingInfo.Arr("additional_info").Obj(I).Str("value")
      End If
      If BillingInfo.Arr("additional_info").Obj(I).Str("type") = "DOC_TYPE" Then
        TipoDocumento = BillingInfo.Arr("additional_info").Obj(I).Str("value")
      End If
      If BillingInfo.Arr("additional_info").Obj(I).Str("type") = "LAST_NAME" Then
        Apellido = BillingInfo.Arr("additional_info").Obj(I).Str("value")
      End If
      If BillingInfo.Arr("additional_info").Obj(I).Str("type") = "FIRST_NAME" Then
        Nombre = BillingInfo.Arr("additional_info").Obj(I).Str("value")
      End If
      If BillingInfo.Arr("additional_info").Obj(I).Str("type") = "COMMENT" Then
        Comentarios = BillingInfo.Arr("additional_info").Obj(I).Str("value")
      End If
    Next
  Else
    MsgBox (ml.ErrorDesc)
  End If
End Sub
