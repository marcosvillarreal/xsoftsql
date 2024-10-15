TEXT TO lcVersiones TEXTMERGE NOSHOW 
2.1.23
	CentroRecep.iddeposito int NULL
	FacVta, si GMSucursal.iddeposito#0, se asigna el deposito
2.1.22
	Buscador por acopio
	PidoPrecio, personabilizable
2.1.21
	CbioPrecioFile
	ListaProductos, se filtra la familia por rubro y articulos
	RegFacVta-modocodigo
2.1.20
	AbmProducto stockideal
	pidoconcepto
2.1.19
	RegFacVta, afectaremito =.f., excepto para facturas y remitos salida
2.1.18
	Exportacor Holistor
2.1.17
	SubdiarioCaja
	SubdiarioStock
2.1.16
	Proforma
	Sundiario iva venta ... horizontal
2.1.15
	CbioPrecio grupal, por alicuota de IVA
	ParaVario_facvta, mostrar IVA
	Buscador_v2, para delpuerto muestra IVA
2.1.14
	AbmProducto, grabar imagen
	Exportador AFIP y Holistor, cierran periodo presentado
	RegFacCpra, validamos al principio el ult periodo presentado
	FacVta y ImpComproba, se agrego el retiro/autorizo para los envios.
	FacVta, se permite enviar por correo el retiro
	SenEmail mejoras
	Cambio de PRecios por archivo
	MovRetiro.retiro char(30), autorizo char(30)
2.1.13
	Actualizador de precios a CSV
	Parametro opcional generar resguardo de pdf
2.1.12
	Cuerfac.idubicacion int
	RegFacvta, almacenamos la unibacion en bdd
	arreglo report_retiro 
	AbmProducto impitmask importes
2.1.11
	LocalProyecto separador de miles
	Paravario_facvta GridBackColor
	Impresiones de Respaldo, permite enviar por email
	Empresa.logofac char(20)
	MovRetiro.observa char(250), cTelefono char(30), cDireccion char(30)
2.1.10
	Imagenes
2.1.9
	Permitimos cargar la vecha de vto de CAE
2.1.8
  Facvta - FACMARGEN0, optativo si deja facturar o no, por defecto NP
2.1.7
	Banner
2.1.6
Error en los colores de los avisos, tomaba como endolar=1, cuando es endolar=2

2.1.5
Diferentes modulos se cambio el inputMask 

2.1.4
Subdiario de Caja por turno
Subbidarios de facturacion, ctacte

2.1.3
Abm de Cuenta corriente, se incorporo diasVto y CompVtoBloq
diasVto, estima los dias personalizados de vencimiento para un comprobante
CompVtoBloq, es la cantidad de comprobantes que puede acumular vencidos antes que se bloque.

Facturador Ventas
funcion si la fecha del precio es muy inferior controla con prodprecio
funcion de controlar comprobantes vencidos, no permite grabar nuevos
funcion de tomar la fecha personalizada por cliente
funcion de avisar la cantidad de proximos comprobantes a vencer

Cambio de Precio archivo.
Se almacena correctamente el margen1 40% y fecmod

ENDTEXT 



*=================== Pendiente
*Aviso de falta de stock (PuntoF)
