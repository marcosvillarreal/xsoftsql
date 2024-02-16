using mllib;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace Demo_QR
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
              /* Configure las cajas desde el módulo para poder usarlas con QR.
               Antes genere las sucursales desde la página de Mercadolibre
               Las cajas creadas desde la página de mercadopago no son válidas. */
              mllib.MPService mp = new mllib.MPService();
              mp.ConfigureStore();
        }

        private void button2_Click(object sender, EventArgs e)
        {
              mllib.MPService mp = new mllib.MPService();
              mllib.JsonObject Params = new mllib.JsonObject();
              Params.Str["title"] = "Pago QR";
              Params.Str["description"] = "Pago mediante QR";
              Params.Dbl["total_amount"] = 1.1;
              Params.Str["external_reference"] = mp.newUuid(); //Se recomeienda que referencia externa debe ser unica para cada transaccion.
              mllib.JsonObject Item = Params.Arr["items"].Obj[0];
              Item.Str["title"] = "Item 1";
              Item.Dbl["total_amount"] = 1.1;
              Item.Str["unit_measure"] = "unit";
              Item.Dbl["quantity"] = 1;
              Item.Dbl["unit_price"] = 1.1;
              if (mp.QRCreateOrder(Params)) 
              {
                  if (mp.WaitQRPayment())
                  {
                      // Obtengo informacion del pago. Json de ejemplo disponible en
                      // https://www.mercadopago.com.ar/developers/es/reference/payments/_payments_id/get
                      Payment oPayment = mp.GetPaymentResponseAsObj;
                      // Guardar el id de pago en el sistema para consultarlo posteriormente en caso de ser necesario (mp.GetPayment(Id))
                      string Id = oPayment.id;
                      string Status = oPayment.status; // approved, rejected, etc.
                      if (Status == "approved")
                      {
                          string date_approved = oPayment.date_approved;
                          double transaction_amount = oPayment.transaction_amount;
                          // Es el tipo de método de pago (tarjeta, transferencia bancaria, ticket, ATM, etc.)
                          string payment_type_id = oPayment.payment_type_id;
                          MessageBox.Show("Pago realizado con éxito. Id de operación  = " + Id);
                      }
                      else if (Status == "rejected")
                          MessageBox.Show("El pago ha sido rechazado!");
                      else
                          MessageBox.Show("El pago esta siendo procesado. Consulte el estado dentro de algunos minutos.");
                  }
              } else
                  MessageBox.Show(mp.ErrorDesc);
              
        }

    }
}
