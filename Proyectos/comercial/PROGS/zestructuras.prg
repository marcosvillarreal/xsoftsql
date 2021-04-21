*!*	 datos tablas
 
*!*	 MAOPERA.switch				1	0 = rtro normal G=rto en guarda
*!*								2
*!*								3 	0 = sin interes 1= por interes
*!*								4	1 = asiento modificado (regasicierre)
*!*								5	0 =(origen ='CPR')crpa mercaderia 
*!*									1 =(origen ='CPR')cpraregistracion
*!*									1 =(origen ='FAC')reginteres
*!*	 MAOPERA.estado		= 1 anulado
*!*	 MAOPERA.origen			FAC   = facturacion
*!*								FPE  = facturacion notas de pedido
*!*								PAG  = registracion pagos
*!*								COB  = registracion cobros
*!*								RFL  = rendicion fletero
*!*								MPU = movimiento publico
*!*								ICA   = ingreso caja 
*!*								ECA = egreso caja
*!*								BCO = registra bancos
*!*								CAR = registra cartera
*!*								TAR = tarjetas


*!*	 MOVCTACTE.switch		1	1= factura pasada a ctacte en rend.fletero
*!*							2	1= factura con retencion pagada

						    
*!*	NMAOPERA.switch			1	0 = sin facturar 1 = facturado
*!*								2
*!*								3 	0 = sin cargar	1 = cargada
*!*								4 	1= mercaderia comprometida
*!*								5
*!*	NMAOPERA.estado 		= 1 anulado

* en LEON NO se rinden planillas o cargas, sino facturas						   																													
*!*	 CABEFAC.switch		1	F= factura normal N=nota pedido P=premio
*!*							2	N= comprobante originado por facturacion nota pedido (form facpedido)
*!*							3 	0= normal 1=vale 2= canje 
*!*							4	TipoFactura
*!*							5	1=capitalizacion de intereses 
*!*							6   0=Pesos,1=Dolar (Valorizado )
*!*							7   1=No comprometio mercaderia (Factura)
*!*							8   1=imprenso por controlador fiscal
*!*							9
*!*							10

*!*	cabefac.rendida			0 = no rendida, 1=rendida

*!*	 FLETEPLANILLA.switch	1	
*!*								2
*!*								3 1 = por notas de pedido
*!*								4
*!*								5

*!*	 FLETECARGA.switch		1	1= operacion pasada a cta cte
*!*								2
*!*								3
*!*								4
*!*								5
 							   
*!*	 MOVBCOCAR.switch		1	3RO 1=entregado / depositado
*!*							2   1 = cheque rechazado
*!*								3
*!*								4
*!*								5
 							   						 

*!*	 MOVSTOCK.switch		1	1= es envase
*!*								2     0=stock real   1=stock disponible
*!*								3
*!*								4
*!*								5	
 							  						  							   						 
*!*	tabla IDASOCIADO		permite asociar 2 o mas registros dentro de una misma tabla, por ej. en fac.compras el neto gravado y el iva
*!*								al consultar un comprobante me permite armar el cursor de cuentas contables							
 							  						  							   						 
*!*	MOVCAJA.clase    			D  =  debita (suma)     H=haber (resta)
*!*	MOVCAJA.tablaori			MOCT  =  movctacte
*!*								CAFA  =  cabefac
*!*								FACP  =  cabecpra
*!*								MBCO =  movbcocar (reg.banco)

*!*	TABLAASI.origen				CAFA  = cabefac
*!*								CAJA  = movcaja
*!*								CH3R = movbcocar  (ch.3ro)
*!*								CHPR = movbcocar  (ch.pro)
*!*								CHVA = movbcocar  (ch.3ro valor negociado)
*!*								BPAG  = movbcocar (retiro 3ro pagos)
*!*								BDEP = movbcocar (retiro 3ro deposito)
*!*								BRET = movbcocar (retiro 3ro retiro cartera)
*!*								FACP = cabecpra
*!*								MAOP = maopera  (ing./egr. caja)
*!*								MBCO = movbcocar (REG.BANCO)
*!*								MCAR = movbcocar (REG.CARTERA)
*!*								TACR = movtarjeta (reg.tarjeta)

*!*	 RENMAOPE.switch	       1	0= cobranza cta cte anterior   1= rendicion de valores 2=operaciones afectadas en la rendicion (fac / rem)
*!*								2	0 = facturas 1 = recibos cobro
*!*								3
*!*								4
*!*								5

*!*	 PARACONFIG.switch	       1	0= no permite cambiar plan pago   1= permite cambiar plan pago   en facturacion venta
*!*								2
*!*								3
*!*								4
*!*								5

*!*	MOVPUB.origen			CCTE  = ctacte

*!*	 DETANROCAJA.switch	1	0= activa   1= cerrada
*!*								2
*!*								3
*!*								4
*!*								5
*!*								6
*!*								7
*!*								8
*!*								9
*!*								10

*!*	 CABEASI.tipo   			A= Apertura
*!*								C= registracion
*!*								E= inflacion
*!*								G= cierre resultado
*!*								I= cierre patrimonial
*!*								K= reversa resultado
*!*								M= reversa patrimonial
*!*								O= Ajustes
*!*								Q= Inflacion
*!*								S= cierre resultado
*!*								U= cierre patrimonial

*!*	PROVINCIA.ALICUOTA1 		= percepcion de articulos q perciben.analcolicos
*!*			ALICUOTA2 			= percepcion general
*!*			ALICUOTA3 			= percepcion general monitributista
*!*			ALICUOTA4 			= retencion  general. ah esta se le aplica convenio.
*!*			ALICUOTA5 = 

*!*	PRODUCTO.switch				1  0=actualiza lista2, 1= no actualiza lista2
*!*								2  0=actualiza lista3, 1= no actualiza lista3

*!*	AFECATEPROD.clave			MR =Marca-Rubro (Padre-Hijo)
*!*								RF =Rubro-Familia (Padre-Hijo)
*!*								FT =Familia-Tipo (Padre-Hijo)

*!*	PRODUCTODETA.switch			1 0=descripcion, 1 = comentario, 2=web, 3=observacion

*!*	MARCA.switch				1-2 xx = (Dos posiciones para el abrevia)

*!*	RUBRO.switch				1-2 xx = (Dos posiciones para el abrevia)
*!*								3 = Especifica si el rubro chequea stock

*!*	FAMILIA.switch				1 x = ( una posicion para el abrevia)

*!*	CATEGOTIPO.switch			1 x = ( una posicion para el abrevia)

*!*	CABEDETA.switch			1  0=NRO REMITO
*!*							   1=REFERENCIA DE PEDIDO
*!*	CABEDETA.switch			2  0=CONTACTO
*!*							   1=REFERENCIA DE CLIENTE
*!*							   2=FECHA DE ENTREGA
*!*							   1=ENTREGA EN

*!*	MOVTARJETA.origen		LTA = Liquidacion de tarjetas
*!*							   	CTA = Cierre de Lotes
*!*							      vacio o null =  tarjeta

*!*	DCABEFAC.switch			6= Estado del comprobante (0=normal,2=impreso/grabado,1=anulado)
*!*							   	CTA = Cierre de Lotes
*!*							      vacio o null =  tarjeta

*!*	CABEORD.switch				1 = 'Afectado'
