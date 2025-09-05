*!*	 datos tablas
 
*!*	 MAOPERA.switch			1	0 = fac s/patron carga factura 1=fac c/patron carga factura 
*!*								2
*!*								3	0 = fac s/patron carga n. pedido 1=fac c/patron carga n. pedido
*!*								4	1 = asiento modificado (regasicierre)
*!*								5	0 =(origen ='CPR')crpa mercaderia 
*!*									1 =(origen ='CPR')cpraregistracion (origen = 'FAC') cambio de plan pago
*!*									2 =asto importado sao
*!*									9 =(origen ='CPR/FAC')importacion facturas
*!*	 MAOPERA.estado		= 1 anulado
*!*	 MAOPERA.origen				FAC  = facturacion
*!*								FPE  = facturacion notas de pedido
*!*								PAG  = registracion pagos
*!*								COB  = registracion cobros
*!*								RFL  = rendicion fletero
*!*								MPU  = movimiento publico
*!*								ICA  = ingreso caja 
*!*								ECA  = egreso caja
*!*								BCO  = registra bancos
*!*								CAR  = registra cartera
*!*								CPR  = FACTURACION COMPRA
*!*								MOV  = Movimientos importados
*!*								AST  = Asientos manuales/Cierre/Reversa/etc

*!*	 MOVCTACTE.switch			1	1= movimiento por cheque rechazado
*!*								2	1= factura con retencion pagada
*!*								3	1= movimiento compactado
*!*								4	1= movimiento interno automatico
*!*								5	1= movimiento modificado manualmente por porgramador
						    
*!*	NMAOPERA.switch				1	0 = sin facturar 1 = facturado
*!*								2
*!*								3 	0 = sin cargar	1 = cargada
*!*								4 	
*!*								5
*!*	NMAOPERA.estado 			1 anulado

*en LEON NO se rinden planillas o cargas, sino facturas						   																													
*!*	 CABEFAC.switch				1	F= factura normal N=nota pedido P=premio
*!*								2	N= comprobante originado por facturacion nota pedido (form facpedido)
*!*								3	tipofactura
*!*								4   Mercaderia previamente comprometida
*!*								5	Estado de la rendicion A (anular) V (cobra vendedor) R (cobra repartidor)

*!*	 CABEFAC.status				1	TipoForm (Estado del Form al hacer el comprobante)


*!*	cabefac.rendida			0 = no rendida, 1=rendida

*!*	 CABEORD.switch				1	A= ajuste automatico
*!*								2	
*!*								3
*!*								4   
*!*								5	

*!*	 NCABEFAC.switch			1	'N' = normal
*!*								2	'1' = puesto preparado
*!*								3
*!*								4   
*!*								5

*!*	 FLETEPLANILLA.switch		1 1 = borrado	
*!*								2
*!*								3 1 = por notas de pedido
*!*								4
*!*								5 1 = mercaderia comprometida (impreso el patron)

*!*	 FLETECARGA.switch			1	1 = operacion pasada a cta cte/ 2 = facturada
*!*								2	1 = genero pendiente
*!*								3	1 = por notas de pedido
*!*								4
*!*								5
 							   
*!*	 MOVBCOCAR.switch			1	3RO 1=entregado / depositado
*!*								2 	1 = cheque rechazado
*!*								3	1 = cheque propio informado por banco
*!*								4
*!*								5
 							   						 

*!*	 MOVSTOCK.switch			1	1= es envase
*!*								2   0=stock real   1=stock disponible
*!*								3	0=normal  1=nota de pedido(solo real)
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
*!*								BPAG  = movbcocar (retiro 3ro pagos)
*!*								BDEP = movbcocar (retiro 3ro deposito)
*!*								BRET = movbcocar (retiro 3ro retiro cartera)
*!*								FACP = cabecpra
*!*								MAOP = maopera  (ing./egr. caja)
*!*								MBCO = movbcocar (REG.BANCO)
*!*								MCAR = movbcocar (REG.CARTERA)
*!*								MOCT = movctacte 

*!*	 RENMAOPE.switch	         1	0= cobranza cta cte anterior   1= rendicion de valores 2=operaciones afectadas en la rendicion (fac / rem)
*!*						2	0 = facturas 1 = recibos cobro
*!*						3       1 = entregadas
*!*						4 	1 = felte cobrado
*!*						5	1 = reembolso cobrado

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

*!*	PROVINCIA				ALICUOTA1 = percepcion de articulos q perciben.analcolicos (IBTO1)
*!*							ALICUOTA2 = percepcion general(IBTO2)
*!*							ALICUOTA3 = percepcion general monitributista
*!*							ALICUOTA4 = retencion  general. ah esta se le aplica convenio.(IBTO2)
*!*							ALICUOTA5 = 

*!*	PRODUCTO.switch				1  0=actualiza lista2, 1= no actualiza lista2
*!*								2  0=actualiza lista3, 1= no actualiza lista3

*!*	DETACONTA.switch			1  1=ejercicio activo

*!*	CABEDETA.switch			1  0=NRO REMITO
*!*							   1=REFERENCIA DE PEDIDO
*!*							   3=REFERENCIA DE COMP ASOCIADO PARA N.C
*!*							   4=REFERENCIA DE MOTIVO AJUSTE REMITO

*!*	FLETEREN.switch			1  0=REMITO GRABADO
*!*							   1=REMITO ANULADO
*!*							2  0=NORMAL
*!*							   1=REMITO DE CAJA

*!*	FLETERO.switch			1  1=SOLO CONTADO/CTACTE EN VENTAS

*!*	CUERFAC.switch			1  
*!*							4  1=TOTAL DIGITADO
*!*							5  1=BONIFICACION DIGITADA
