// config/estados-config.js - Estados con códigos VFP-compatibles
window.estadosConfig = {    
	// Configuraciones de estados por campo dinámico usando CÓDIGOS    
		activo: {        
			'true': { codigo: 'ACTIVO', descripcion: 'Activo' },        
			'false': { codigo: 'INACTIVO', descripcion: 'Inactivo' }    
		},    
		estado_cuenta: {        
			al_dia: { codigo: 'AL_DIA', descripcion: 'Al día' },        
			con_deuda: { codigo: 'CON_DEUDA', descripcion: 'Con deuda' },        
			moroso: { codigo: 'MOROSO', descripcion: 'Moroso' },        
			bloqueado: { codigo: 'BLOQUEADO', descripcion: 'Bloqueado' }    
		},    
		categoria_cliente: {        
			
categoria_a: { codigo: 'CATEGORIA_A', descripcion :'Categoria a' },
categoria_b: { codigo: 'CATEGORIA_B', descripcion :'Categoria b' },
categoria_d: { codigo: 'CATEGORIA_D', descripcion :'Categoria d' },
categoria_e: { codigo: 'CATEGORIA_E', descripcion :'Categoria e' },
categoria_f: { codigo: 'CATEGORIA_F', descripcion :'Categoria f' },
categoria_g: { codigo: 'CATEGORIA_G', descripcion :'Categoria g' },
kiosco_b: { codigo: 'KIOSCO_B', descripcion :'Kiosco b' },
morosos: { codigo: 'MOROSOS', descripcion :'Morosos' },
proximidad: { codigo: 'PROXIMIDAD', descripcion :'Proximidad' },
sin_presupuesto: { codigo: 'SIN_PRESUPUESTO', descripcion :'Sin presupuesto' }
		},    
		canal_venta: {
			
almacen: { codigo: 'ALMACEN', descripcion :'almacen' },
almacen_y_desp: { codigo: 'ALMACEN_Y_DESP', descripcion :'Almacen y desp' },
carnic_y_desp: { codigo: 'CARNIC_Y_DESP', descripcion :'Carnic y desp' },
cine: { codigo: 'CINE', descripcion :'Cine' },
cotillon: { codigo: 'COTILLON', descripcion :'Cotillon' },
est_servicio: { codigo: 'EST_SERVICIO', descripcion :'Est servicio' },
kiosco: { codigo: 'KIOSCO', descripcion :'Kiosco' },
otros: { codigo: 'OTROS', descripcion :'Otros' },
panaderia: { codigo: 'PANADERIA', descripcion :'Panaderia' },
polleria: { codigo: 'POLLERIA', descripcion :'Polleria' },
restaurant: { codigo: 'RESTAURANT', descripcion :'Restaurant' },
terminal_omnibus: { codigo: 'TERMINAL_OMNIBUS', descripcion :'Terminal omnibus' },
universidad: { codigo: 'UNIVERSIDAD', descripcion :'Universidad' },
verd_y_desp: { codigo: 'VERD_Y_DESP', descripcion :'Verd y desp' },
verduleria: { codigo: 'VERDULERIA', descripcion :'Verduleria' }        
		
		},    
		zona_geografica: {        
			
a1__milpaterno: { codigo: 'A1__MILPATERNO', descripcion :'A1  milpaterno' },
a2__indflrjarca: { codigo: 'A2__INDFLRJARCA', descripcion :'A2  indflrjarca' },
v1__hospcagl: { codigo: 'V1__HOSPCAGL', descripcion :'V1  hospcagl' },
v2__guiinapielb: { codigo: 'V2__GUIINAPIELB', descripcion :'V2  guiinapielb' },
v3__riosst_clara: { codigo: 'V3__RIOSST_CLARA', descripcion :'V3  riosst clara' },
v4__belgrano: { codigo: 'V4__BELGRANO', descripcion :'V4  belgrano' },
v5__amr20centro: { codigo: 'V5__AMR20CENTRO', descripcion :'V5  amr20centro' },
v6__ippvterminal: { codigo: 'V6__IPPVTERMINAL', descripcion :'V6  ippvterminal' } 
		},    
		tipo_negocio: {        
			comercial: { codigo: 'COMERCIAL', descripcion: 'Comercial' },        
			particular: { codigo: 'PARTICULAR', descripcion: 'Particular' },        
			empresa: { codigo: 'EMPRESA', descripcion: 'Empresa' }    
		},
		vendedor:{
			
baier_gustavo: { codigo: 'BAIER_GUSTAVO', descripcion :'Baier gustavo' },
contreras_julio_cesar: { codigo: 'CONTRERAS_JULIO_CESAR', descripcion :'Contreras julio cesar' }
		},    
		estado: {    
			ninguno : { codigo: 'NINGUNO', descripcion: '' },        
			venta: { codigo: 'VENTA', descripcion: 'Venta' },        
			no_venta: { codigo: 'NO_VENTA', descripcion: 'Sin Venta' }
			,
cerrado: { codigo: 'CERRADO', descripcion :'Cerrado' },
negocio_no_encontrado: { codigo: 'NEGOCIO_NO_ENCONTRADO', descripcion :'Negocio no encontrado' },
no_estaba_el_comprador: { codigo: 'NO_ESTABA_EL_COMPRADOR', descripcion :'No estaba el comprador' },
no_ternia_dinero: { codigo: 'NO_TERNIA_DINERO', descripcion :'No ternia dinero' }        
		}
};
console.log('?? Estados-config cargado (códigos VFP-compatibles):', Object.keys(window.estadosConfig));