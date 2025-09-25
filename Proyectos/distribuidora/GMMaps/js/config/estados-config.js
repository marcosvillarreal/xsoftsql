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
			
clientes: { codigo: 'CLIENTES', descripcion :'Clientes' },
cta_cte_servicio: { codigo: 'CTA_CTE_SERVICIO', descripcion :'Cta cte servicio' }
		},    
		canal_venta: {
			
almacen_y_desp: { codigo: 'ALMACEN_Y_DESP', descripcion :'Almacen y desp' },
minimercado: { codigo: 'MINIMERCADO', descripcion :'Minimercado' },
otros: { codigo: 'OTROS', descripcion :'Otros' }        
		
		},    
		zona_geografica: {        
			
jueves_1_vrosas_whi: { codigo: 'JUEVES_1_VROSAS_WHI', descripcion :'Jueves 1 vrosas whi' },
jueves_2_centro_sude: { codigo: 'JUEVES_2_CENTRO_SUDE', descripcion :'Jueves 2 centro sude' },
jueves_3_resto: { codigo: 'JUEVES_3_RESTO', descripcion :'Jueves 3 resto' },
martes_1_centro_nort: { codigo: 'MARTES_1_CENTRO_NORT', descripcion :'Martes 1 centro nort' },
martes_2_norte: { codigo: 'MARTES_2_NORTE', descripcion :'Martes 2 norte' },
martes_3_centro: { codigo: 'MARTES_3_CENTRO', descripcion :'Martes 3 centro' },
miecoles_3_espora: { codigo: 'MIECOLES_3_ESPORA', descripcion :'Miecoles 3 espora' },
miercoles_1_vmitre: { codigo: 'MIERCOLES_1_VMITRE', descripcion :'Miercoles 1 vmitre' },
miercoles_2_aldea_ro: { codigo: 'MIERCOLES_2_ALDEA_RO', descripcion :'Miercoles 2 aldea ro' },
viernes_1_bordeux_ma: { codigo: 'VIERNES_1_BORDEUX_MA', descripcion :'Viernes 1 bordeux ma' },
viernes_2: { codigo: 'VIERNES_2', descripcion :'Viernes 2' },
viernes_3: { codigo: 'VIERNES_3', descripcion :'Viernes 3' },
viernes_4: { codigo: 'VIERNES_4', descripcion :'Viernes 4' } 
		},    
		tipo_negocio: {        
			comercial: { codigo: 'COMERCIAL', descripcion: 'Comercial' },        
			particular: { codigo: 'PARTICULAR', descripcion: 'Particular' },        
			empresa: { codigo: 'EMPRESA', descripcion: 'Empresa' }    
		},
		vendedor:{
			
daiana: { codigo: 'DAIANA', descripcion :'Daiana' },
marcos: { codigo: 'MARCOS', descripcion :'Marcos' },
oscar_bahia: { codigo: 'OSCAR_BAHIA', descripcion :'Oscar bahia' }
		},    
		estado: {    
			ninguno : { codigo: 'NINGUNO', descripcion: '' },        
			venta: { codigo: 'VENTA', descripcion: 'Venta' },        
			no_venta: { codigo: 'NO_VENTA', descripcion: 'Sin Venta' }
			        
		}
};
console.log('?? Estados-config cargado (códigos VFP-compatibles):', Object.keys(window.estadosConfig));