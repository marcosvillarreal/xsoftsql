import javax.swing.JOptionPane;

public class MercadolibreMain {

	
	private static void getRecentOrders()
	{
		  // Ejemplo de obtencion de las ordenes recientes de Mercadolibre.
		  // Describe la api documentada en https://developers.mercadolibre.com.ar/es_ar/gestiona-ventas#Ordenes-recientes
		  
		    mllib.IMLService ml;
		    ml = mllib.ClassFactory.createMLService();
		    
		    // Configuracion de filtros para acotar resultados
		    mllib.IJsonObject filter; 
		    filter = ml.createFilter();
		    filter.str("sort", "date_desc"); // Ordenamiento de las mismas de manera descenciente por fecha
		    filter.str("tags", "not_delivered"); // Ordenes que aun no han sido señaladas como entregadas
		    filter.str("seller", ml.userId()); // filtrar ordenes segun el id de vendedor autenticado
		    filter._int("offset", 0); // Posicion del primer registro a traer de la lista.
		    
		    // Obtención de las primeras 50 ordenes de compra
		    String lines = "";
		    if (ml.getRecentOrders(filter))
		    {
		      mllib.IJsonArray orders; 
		      orders = ml.getRecentOrdersResponse().arr("results");
		      for (int i = 0; i < orders.count(); i++)
		      {
		        
		        if (ml.getOrders(orders.obj(i).str("id")))
		        {
			    	mllib.IJsonObject order;

			    	order = ml.getOrdersResponse();
		            
		            // Datos de cada orden
		            lines = lines + "********ORDEN " + order.str("id") + "********" + "\n";
		            lines = lines + "fecha de creacion=" + order.str("date_created") + "\n";
		            lines = lines + "nombre de vendedor=" + order.obj("seller").str("first_name") + "\n";
		            lines = lines + "apellido de vendedor=" + order.obj("seller").str("last_name") + "\n";
		            lines = lines + "email del vendedor=" + order.obj("seller").str("email") + "\n";
		            lines = lines + "nombre de comprador=" + order.obj("buyer").str("first_name") + "\n";
		            lines = lines + "apellido de comprador=" + order.obj("buyer").str("last_name") + "\n";
		            lines = lines + "email del comprador=" + order.obj("buyer").str("email") + "\n";
		            lines = lines + "tipo de documento del comprador=" + order.obj("buyer").obj("billing_info").str("doc_number") + "\n";
		            lines = lines + "docuemnto del comprador=" + order.obj("buyer").obj("billing_info").str("doc_type") + "\n";
		            for (int j = 0; i < order.arr("order_items").count(); j++)
		            {	
		            	lines = lines + "    ********ARTICULO " + order.arr("order_items").obj(j).obj("item").str("id") + "********" + "\n";
		            	lines = lines + "    titulo=" + order.arr("order_items").obj(j).obj("item").str("title") + "\n";
		            	lines = lines + "    sku=" + order.arr("order_items").obj(j).obj("item").str("seller_sku") + "\n";
		            	lines = lines + "    cantidad=" + order.arr("order_items").obj(j).str("quantity") + "\n";
		            	lines = lines + "    precio=" + order.arr("order_items").obj(j).str("unit_price") + "\n";
		            	lines = lines + "    monto=" + order.arr("order_items").obj(j).str("full_unit_price") + "\n";
		            	lines = lines + "    comision=" + order.arr("order_items").obj(j).str("sale_fee") + "\n";
		            }
		        }  else {
		        	JOptionPane.showMessageDialog(null, null, ml.errorDesc(), 0);
		            break;
		      	}
		        
		      }
		    } else {
	        	JOptionPane.showMessageDialog(null, null, ml.errorDesc(), 0);
		    }
		    if (lines != "") {
	        	JOptionPane.showMessageDialog(null, null, lines, 0);
		    }
	}
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub

		getRecentOrders();
		
	}

}
