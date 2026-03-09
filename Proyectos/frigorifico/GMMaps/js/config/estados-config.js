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
categoria_c: { codigo: 'CATEGORIA_C', descripcion :'Categoria c' },
categoria_d: { codigo: 'CATEGORIA_D', descripcion :'Categoria d' },
categoria_e: { codigo: 'CATEGORIA_E', descripcion :'Categoria e' },
categoria_g: { codigo: 'CATEGORIA_G', descripcion :'Categoria g' },
verduleria_b: { codigo: 'VERDULERIA_B', descripcion :'Verduleria b' }
		},    
		canal_venta: {
			
almacen: { codigo: 'ALMACEN', descripcion :'almacen' },
almacen_y_desp: { codigo: 'ALMACEN_Y_DESP', descripcion :'Almacen y desp' },
carnic_y_desp: { codigo: 'CARNIC_Y_DESP', descripcion :'Carnic y desp' },
cine: { codigo: 'CINE', descripcion :'Cine' },
cotillon: { codigo: 'COTILLON', descripcion :'Cotillon' },
kiosco: { codigo: 'KIOSCO', descripcion :'Kiosco' },
minimercado: { codigo: 'MINIMERCADO', descripcion :'Minimercado' },
otros: { codigo: 'OTROS', descripcion :'Otros' },
superchino: { codigo: 'SUPERCHINO', descripcion :'Superchino' },
supermercado: { codigo: 'SUPERMERCADO', descripcion :'Supermercado' },
verd_y_desp: { codigo: 'VERD_Y_DESP', descripcion :'Verd y desp' },
verduleria: { codigo: 'VERDULERIA', descripcion :'Verduleria' }        
		
		},    
		zona_geografica: {        
			
a2__indflrjarca: { codigo: 'A2__INDFLRJARCA', descripcion :'A2  indflrjarca' },
a3__san_martinnor: { codigo: 'A3__SAN_MARTINNOR', descripcion :'A3  san martinnor' },
a6__banadobicesj: { codigo: 'A6__BANADOBICESJ', descripcion :'A6  banadobicesj' },
m1__centro_patagon: { codigo: 'M1__CENTRO_PATAGON', descripcion :'M1  centro patagon' },
m2__centro_viedma: { codigo: 'M2__CENTRO_VIEDMA', descripcion :'M2  centro viedma' },
m3__resto_mabel: { codigo: 'M3__RESTO_MABEL', descripcion :'M3  resto mabel' },
t1__san_javier: { codigo: 'T1__SAN_JAVIER', descripcion :'T1  san javier' },
v1__hospcagl: { codigo: 'V1__HOSPCAGL', descripcion :'V1  hospcagl' },
v2__guiinapielb: { codigo: 'V2__GUIINAPIELB', descripcion :'V2  guiinapielb' },
v6__ippvterminal: { codigo: 'V6__IPPVTERMINAL', descripcion :'V6  ippvterminal' } 
		},    
		tipo_negocio: {        
			comercial: { codigo: 'COMERCIAL', descripcion: 'Comercial' },        
			particular: { codigo: 'PARTICULAR', descripcion: 'Particular' },        
			empresa: { codigo: 'EMPRESA', descripcion: 'Empresa' }    
		},
		vendedor:{
			
contreras_julio_cesar: { codigo: 'CONTRERAS_JULIO_CESAR', descripcion :'Contreras julio cesar' },
frego_marino: { codigo: 'FREGO_MARINO', descripcion :'Frego marino' },
gonzalez_valentina: { codigo: 'GONZALEZ_VALENTINA', descripcion :'Gonzalez valentina' },
troncoso_jessica: { codigo: 'TRONCOSO_JESSICA', descripcion :'Troncoso jessica' },
zuniga_karen: { codigo: 'ZUNIGA_KAREN', descripcion :'Zuniga karen' }
		},    
		estado: {    
			ninguno : { codigo: 'NINGUNO', descripcion: '' },        
			venta: { codigo: 'VENTA', descripcion: 'Venta' },        
			no_venta: { codigo: 'NO_VENTA', descripcion: 'Sin Venta' }
			        
		}
};
console.log('?? Estados-config cargado (códigos VFP-compatibles):', Object.keys(window.estadosConfig));